using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class ClientPanel_Payments : System.Web.UI.Page
{
    private string GetConnectionString()
    {
        return ConfigurationManager.ConnectionStrings["dbcon"].ConnectionString;
    }

    private void ShowMessage(string message, bool isSuccess)
    {
        pnlMsg.Visible = true;
        lblMsg.Text = message;
        if (isSuccess)
        {
            pnlMsg.Style["background"] = "rgba(16, 185, 129, 0.15)";
            pnlMsg.Style["border"] = "1px solid #10b981";
            pnlMsg.Style["color"] = "#34d399";
        }
        else
        {
            pnlMsg.Style["background"] = "rgba(239, 68, 68, 0.15)";
            pnlMsg.Style["border"] = "1px solid #ef4444";
            pnlMsg.Style["color"] = "#f87171";
        }
    }

    private int GetClientId(string email)
    {
        using (SqlConnection con = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT Id FROM Registration_tbl WHERE Email = @Email", con))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                con.Open();
                object val = cmd.ExecuteScalar();
                int id;
                if (val != null && int.TryParse(val.ToString(), out id))
                {
                    return id;
                }
            }
        }
        return 0;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["Email"] == null || Session["Role"] == null || Session["Role"].ToString() != "Client")
        {
            Response.Redirect("~/Login.aspx");
            return;
        }

        string email = Session["Email"].ToString();
        string clientName = Session["Name"] != null ? Session["Name"].ToString() : "Client";
        lblSidebarName.Text = clientName + " · Client";

        if (!IsPostBack)
        {
            LoadPaymentsData();
        }
    }

    private void LoadPaymentsData()
    {
        try
        {
            string email = Session["Email"].ToString();
            int clientId = GetClientId(email);

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();

                string statsQuery = @"SELECT
                    ISNULL(SUM(CASE WHEN LOWER(Status) IN ('paid', 'completed') THEN Amount ELSE 0 END), 0) AS TotalSpent,
                    ISNULL(SUM(CASE WHEN LOWER(Status) = 'pending' THEN Amount ELSE 0 END), 0) AS PendingAmount,
                    ISNULL(SUM(CASE WHEN LOWER(Status) IN ('paid', 'completed') THEN 1 ELSE 0 END), 0) AS CompletedCount
                    FROM Payments_tbl
                    WHERE ClientId = @ClientId";

                using (SqlCommand cmdStats = new SqlCommand(statsQuery, con))
                {
                    cmdStats.Parameters.AddWithValue("@ClientId", clientId);
                    using (SqlDataReader reader = cmdStats.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            decimal totalSpent = reader["TotalSpent"] != DBNull.Value ? Convert.ToDecimal(reader["TotalSpent"]) : 0;
                            decimal pendingAmount = reader["PendingAmount"] != DBNull.Value ? Convert.ToDecimal(reader["PendingAmount"]) : 0;
                            int completedCount = reader["CompletedCount"] != DBNull.Value ? Convert.ToInt32(reader["CompletedCount"]) : 0;

                            lblTotalSpent.Text = "$" + totalSpent.ToString("N2");
                            lblPending.Text = "$" + pendingAmount.ToString("N2");
                            lblCompletedCount.Text = completedCount.ToString();
                        }
                    }
                }

                string listQuery = @"SELECT
                    p.PaymentId,
                    ISNULL(pr.Title, 'Project #' + CAST(p.ProjectId AS NVARCHAR)) AS ProjectTitle,
                    ISNULL(s.Name, 'Student #' + CAST(p.StudentId AS NVARCHAR)) AS StudentName,
                    p.Amount,
                    p.PaymentDate,
                    ISNULL(p.Status, 'Pending') AS Status
                    FROM Payments_tbl p
                    LEFT JOIN Projects_tbl pr ON p.ProjectId = pr.ProjectId
                    LEFT JOIN Registration_tbl s ON p.StudentId = s.Id
                    WHERE p.ClientId = @ClientId
                    ORDER BY p.PaymentDate DESC";

                using (SqlCommand cmdList = new SqlCommand(listQuery, con))
                {
                    cmdList.Parameters.AddWithValue("@ClientId", clientId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmdList))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptPayments.DataSource = dt;
                            rptPayments.DataBind();
                            rptPayments.Visible = true;
                            pnlNoPayments.Visible = false;
                        }
                        else
                        {
                            rptPayments.Visible = false;
                            pnlNoPayments.Visible = true;
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading payments: " + ex.Message, false);
        }
    }
}
