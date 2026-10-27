using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class ClientPanel_Dashboard : System.Web.UI.Page
{
    string s = ConfigurationManager.ConnectionStrings["dbcon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {

        if (Session["Email"] == null || Session["Role"] == null || Session["Role"].ToString() != "Client")
        {
            Response.Redirect("~/Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            string name = Session["UserName"] != null ? Session["UserName"].ToString() :
                         (Session["admin"] != null ? Session["admin"].ToString() : "Client");
            lblWelcomeName.Text = name;
            lblSidebarName.Text = name + " · Client";

            LoadDashboardData();
        }
    }

    int GetClientId(SqlConnection con, string email)
    {
        using (SqlCommand cmd = new SqlCommand("SELECT Id FROM Registration_tbl WHERE Email = @Email", con))
        {
            cmd.Parameters.AddWithValue("@Email", email);
            object res = cmd.ExecuteScalar();
            return res != null ? Convert.ToInt32(res) : 0;
        }
    }

    void LoadDashboardData()
    {
        string email = Session["Email"].ToString();

        using (SqlConnection con = new SqlConnection(s))
        {
            con.Open();
            int clientId = GetClientId(con, email);

            using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Projects_tbl WHERE (ClientEmail = @Email OR ClientId = @ClientId) AND Status IN ('Open', 'In Progress')", con))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@ClientId", clientId);
                lblActiveProjects.Text = cmd.ExecuteScalar().ToString();
            }

            try
            {
                string countQuery = "SELECT (SELECT COUNT(*) FROM Applications_tbl a INNER JOIN Projects_tbl p ON a.ProjectId = p.ProjectId WHERE p.ClientEmail = @Email OR p.ClientId = @ClientId) + " +
                                    "(SELECT COUNT(*) FROM Bids_tbl b INNER JOIN Projects_tbl p ON b.ProjectId = p.ProjectId WHERE p.ClientEmail = @Email OR p.ClientId = @ClientId)";
                using (SqlCommand cmd = new SqlCommand(countQuery, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@ClientId", clientId);
                    lblTotalApplicants.Text = cmd.ExecuteScalar().ToString();
                }
            }
            catch
            {
                try
                {
                    string countQuery = "SELECT COUNT(*) FROM Applications_tbl a INNER JOIN Projects_tbl p ON a.ProjectId = p.ProjectId WHERE p.ClientEmail = @Email OR p.ClientId = @ClientId";
                    using (SqlCommand cmd = new SqlCommand(countQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@ClientId", clientId);
                        lblTotalApplicants.Text = cmd.ExecuteScalar().ToString();
                    }
                }
                catch { lblTotalApplicants.Text = "0"; }
            }

            using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Projects_tbl WHERE (ClientEmail = @Email OR ClientId = @ClientId) AND Status = 'Completed'", con))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@ClientId", clientId);
                lblCompletedProjects.Text = cmd.ExecuteScalar().ToString();
            }

            try
            {
                using (SqlCommand cmd = new SqlCommand("SELECT ISNULL(SUM(Amount), 0) FROM Payments_tbl WHERE ClientId = @ClientId AND Status = 'Completed'", con))
                {
                    cmd.Parameters.AddWithValue("@ClientId", clientId);
                    decimal spent = Convert.ToDecimal(cmd.ExecuteScalar());
                    lblTotalSpent.Text = "$" + spent.ToString("N0");
                }
            }
            catch
            {
                lblTotalSpent.Text = "$0";
            }

            string projQuery = "SELECT TOP 5 ProjectId, Title, Status, Budget, PostedDate FROM Projects_tbl WHERE ClientEmail = @Email OR ClientId = @ClientId ORDER BY ProjectId DESC";
            using (SqlCommand cmd = new SqlCommand(projQuery, con))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@ClientId", clientId);
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        rptRecentProjects.DataSource = dt;
                        rptRecentProjects.DataBind();
                        rptRecentProjects.Visible = true;
                        pnlNoProjects.Visible = false;
                    }
                    else
                    {
                        rptRecentProjects.Visible = false;
                        pnlNoProjects.Visible = true;
                    }
                }
            }

            try
            {
                string appQuery = "SELECT TOP 5 a.AppId, a.BidAmount, a.Status, a.AppliedDate, p.Title AS ProjectTitle, " +
                                  "ISNULL(r.Name, a.StudentEmail) AS StudentName " +
                                  "FROM Applications_tbl a " +
                                  "INNER JOIN Projects_tbl p ON a.ProjectId = p.ProjectId " +
                                  "LEFT JOIN Registration_tbl r ON a.StudentEmail = r.Email " +
                                  "WHERE p.ClientEmail = @Email OR p.ClientId = @ClientId " +
                                  "ORDER BY a.AppliedDate DESC";

                using (SqlCommand cmd = new SqlCommand(appQuery, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@ClientId", clientId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        if (dt.Rows.Count > 0)
                        {
                            rptRecentApplicants.DataSource = dt;
                            rptRecentApplicants.DataBind();
                            rptRecentApplicants.Visible = true;
                            pnlNoApplicants.Visible = false;
                        }
                        else
                        {
                            rptRecentApplicants.Visible = false;
                            pnlNoApplicants.Visible = true;
                        }
                    }
                }
            }
            catch
            {
                rptRecentApplicants.Visible = false;
                pnlNoApplicants.Visible = true;
            }
        }
    }
}
