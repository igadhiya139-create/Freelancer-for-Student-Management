using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AdminPanel_ManageApplications : System.Web.UI.Page
{
    string s = ConfigurationManager.ConnectionStrings["dbcon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {

        if (Session["admin"] == null || Session["Role"] == null || Session["Role"].ToString() != "Admin")
        {
            Response.Redirect("~/Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            string adminName = Session["UserName"] != null ? Session["UserName"].ToString() :
                               (Session["admin"] != null ? Session["admin"].ToString() : "Admin");
            lblSidebarName.Text = adminName + " · Admin";
            LoadApplications();
        }
    }

    void ShowMessage(string msg, bool isSuccess)
    {
        pnlMsg.Visible = true;
        lblMsg.Text = msg;
        if (isSuccess)
        {
            pnlMsg.Style["background"] = "rgba(52,211,153,0.15)";
            pnlMsg.Style["border"] = "1px solid rgba(52,211,153,0.3)";
            pnlMsg.Style["color"] = "#34d399";
        }
        else
        {
            pnlMsg.Style["background"] = "rgba(248,113,113,0.15)";
            pnlMsg.Style["border"] = "1px solid rgba(248,113,113,0.3)";
            pnlMsg.Style["color"] = "#f87171";
        }
    }

    void LogActivity(string activity)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                string query = "INSERT INTO ActivityLogs_tbl (UserId, Activity, ActivityDate) VALUES (@UserId, @Activity, GETDATE())";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserId", 0);
                    cmd.Parameters.AddWithValue("@Activity", activity);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        catch { }
    }

    void LoadApplications()
    {
        string search = txtSearch.Text.Trim();
        string status = ddlStatusFilter.SelectedValue;

        using (SqlConnection con = new SqlConnection(s))
        {
            string query = "SELECT a.AppId, a.ProjectId, a.StudentEmail, a.Proposal, a.BidAmount, a.DeliveryDays, a.Status, a.AppliedDate, " +
                           "ISNULL(p.Title, 'Project #' + CAST(a.ProjectId AS NVARCHAR)) AS ProjectTitle " +
                           "FROM Applications_tbl a " +
                           "LEFT JOIN Projects_tbl p ON a.ProjectId = p.ProjectId WHERE 1=1";

            if (!string.IsNullOrEmpty(status))
            {
                query += " AND a.Status = @Status";
            }
            if (!string.IsNullOrEmpty(search))
            {
                query += " AND (a.StudentEmail LIKE @Search OR p.Title LIKE @Search OR a.Proposal LIKE @Search)";
            }
            query += " ORDER BY a.AppId DESC";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                if (!string.IsNullOrEmpty(status))
                {
                    cmd.Parameters.AddWithValue("@Status", status);
                }
                if (!string.IsNullOrEmpty(search))
                {
                    cmd.Parameters.AddWithValue("@Search", "%" + search + "%");
                }

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    lblAppCount.Text = dt.Rows.Count.ToString();

                    if (dt.Rows.Count > 0)
                    {
                        rptApplications.DataSource = dt;
                        rptApplications.DataBind();
                        rptApplications.Visible = true;
                        pnlNoData.Visible = false;
                    }
                    else
                    {
                        rptApplications.Visible = false;
                        pnlNoData.Visible = true;
                    }
                }
            }
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        pnlMsg.Visible = false;
        LoadApplications();
    }

    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        txtSearch.Text = string.Empty;
        ddlStatusFilter.SelectedIndex = 0;
        pnlMsg.Visible = false;
        pnlAppDetails.Visible = false;
        LoadApplications();
    }

    protected void btnCloseDetails_Click(object sender, EventArgs e)
    {
        pnlAppDetails.Visible = false;
    }

    protected void rptApplications_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int appId = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "ViewApp")
        {
            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                string query = "SELECT a.AppId, a.StudentEmail, a.Proposal, a.BidAmount, a.DeliveryDays, a.Status, a.AppliedDate, " +
                               "ISNULL(p.Title, 'Project #' + CAST(a.ProjectId AS NVARCHAR)) AS ProjectTitle " +
                               "FROM Applications_tbl a " +
                               "LEFT JOIN Projects_tbl p ON a.ProjectId = p.ProjectId WHERE a.AppId = @Id";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Id", appId);
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblDetId.Text = dr["AppId"].ToString();
                            lblDetProject.Text = dr["ProjectTitle"].ToString();
                            lblDetStudent.Text = dr["StudentEmail"].ToString();
                            lblDetBid.Text = "$" + Convert.ToDecimal(dr["BidAmount"]).ToString("N2");
                            lblDetDays.Text = dr["DeliveryDays"].ToString();

                            string currentStatus = dr["Status"].ToString();
                            string badgeClass = currentStatus == "Hired" || currentStatus == "Accepted" ? "badge-green" : (currentStatus == "Rejected" ? "badge-red" : "badge-yellow");
                            lblDetStatus.Text = "<span class='badge " + badgeClass + "'>" + currentStatus + "</span>";

                            lblDetDate.Text = dr["AppliedDate"] != DBNull.Value ? Convert.ToDateTime(dr["AppliedDate"]).ToString("dd MMM yyyy, hh:mm tt") : "N/A";
                            lblDetProposal.Text = dr["Proposal"].ToString();

                            pnlAppDetails.Visible = true;
                        }
                    }
                }
            }
        }
        else if (e.CommandName == "AcceptApp")
        {
            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("UPDATE Applications_tbl SET Status='Hired' WHERE AppId=@Id", con))
                {
                    cmd.Parameters.AddWithValue("@Id", appId);
                    cmd.ExecuteNonQuery();
                }
            }

            LogActivity("Admin approved/hired application #" + appId);
            ShowMessage("Application #" + appId + " marked as Hired.", true);
            LoadApplications();
        }
        else if (e.CommandName == "RejectApp")
        {
            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("UPDATE Applications_tbl SET Status='Rejected' WHERE AppId=@Id", con))
                {
                    cmd.Parameters.AddWithValue("@Id", appId);
                    cmd.ExecuteNonQuery();
                }
            }

            LogActivity("Admin rejected application #" + appId);
            ShowMessage("Application #" + appId + " marked as Rejected.", true);
            LoadApplications();
        }
        else if (e.CommandName == "DeleteApp")
        {
            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("DELETE FROM Applications_tbl WHERE AppId=@Id", con))
                {
                    cmd.Parameters.AddWithValue("@Id", appId);
                    cmd.ExecuteNonQuery();
                }
            }

            LogActivity("Admin removed application #" + appId);
            ShowMessage("Application #" + appId + " was removed.", true);
            pnlAppDetails.Visible = false;
            LoadApplications();
        }
    }
}
