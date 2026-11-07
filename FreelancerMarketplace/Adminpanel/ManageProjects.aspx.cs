using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AdminPanel_ManageProjects : System.Web.UI.Page
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
            LoadProjects();
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

    void LoadProjects()
    {
        string search = txtSearch.Text.Trim();
        string status = ddlStatusFilter.SelectedValue;

        using (SqlConnection con = new SqlConnection(s))
        {
            string query = "SELECT ProjectId, Title, Description, Budget, Skills, Category, Deadline, ClientId, Status, PostedDate, ClientEmail FROM Projects_tbl WHERE 1=1";
            if (!string.IsNullOrEmpty(status))
            {
                query += " AND Status = @Status";
            }
            if (!string.IsNullOrEmpty(search))
            {
                query += " AND (Title LIKE @Search OR Description LIKE @Search OR Category LIKE @Search OR ClientEmail LIKE @Search)";
            }
            query += " ORDER BY ProjectId DESC";

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
                    lblProjectCount.Text = dt.Rows.Count.ToString();

                    if (dt.Rows.Count > 0)
                    {
                        rptProjects.DataSource = dt;
                        rptProjects.DataBind();
                        rptProjects.Visible = true;
                        pnlNoData.Visible = false;
                    }
                    else
                    {
                        rptProjects.Visible = false;
                        pnlNoData.Visible = true;
                    }
                }
            }
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        pnlMsg.Visible = false;
        LoadProjects();
    }

    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        txtSearch.Text = string.Empty;
        ddlStatusFilter.SelectedIndex = 0;
        pnlMsg.Visible = false;
        pnlProjectDetails.Visible = false;
        LoadProjects();
    }

    protected void btnCloseDetails_Click(object sender, EventArgs e)
    {
        pnlProjectDetails.Visible = false;
    }

    protected void rptProjects_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int projId = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "ViewProject")
        {
            ViewState["SelectedProjectId"] = projId;
            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                string query = "SELECT ProjectId, Title, Description, Budget, Skills, Category, Deadline, Status, PostedDate, ClientEmail FROM Projects_tbl WHERE ProjectId = @Id";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Id", projId);
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblDetId.Text = "#" + dr["ProjectId"].ToString();
                            lblDetTitle.Text = dr["Title"].ToString();
                            lblDetClient.Text = !string.IsNullOrEmpty(dr["ClientEmail"].ToString()) ? dr["ClientEmail"].ToString() : "N/A";
                            lblDetCategory.Text = dr["Category"].ToString();
                            lblDetBudget.Text = dr["Budget"].ToString();
                            lblDetDeadline.Text = dr["Deadline"] != DBNull.Value ? Convert.ToDateTime(dr["Deadline"]).ToString("dd MMM yyyy") : "N/A";

                            string currentStatus = dr["Status"].ToString();
                            string badgeClass = currentStatus == "Completed" ? "badge-green" : (currentStatus == "In Progress" ? "badge-blue" : (currentStatus == "Cancelled" ? "badge-red" : "badge-yellow"));
                            lblDetStatus.Text = "<span class='badge " + badgeClass + "'>" + currentStatus + "</span>";

                            if (ddlChangeStatus.Items.FindByValue(currentStatus) != null)
                            {
                                ddlChangeStatus.SelectedValue = currentStatus;
                            }

                            lblDetPostedDate.Text = dr["PostedDate"] != DBNull.Value ? Convert.ToDateTime(dr["PostedDate"]).ToString("dd MMM yyyy, hh:mm tt") : "N/A";
                            lblDetSkills.Text = !string.IsNullOrEmpty(dr["Skills"].ToString()) ? dr["Skills"].ToString() : "Not specified";
                            lblDetDesc.Text = dr["Description"].ToString();

                            pnlProjectDetails.Visible = true;
                        }
                    }
                }
            }
        }
        else if (e.CommandName == "DeleteProject")
        {
            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();

                string projTitle = "";
                using (SqlCommand checkCmd = new SqlCommand("SELECT Title FROM Projects_tbl WHERE ProjectId = @Id", con))
                {
                    checkCmd.Parameters.AddWithValue("@Id", projId);
                    object res = checkCmd.ExecuteScalar();
                    if (res != null) projTitle = res.ToString();
                }

                if (string.IsNullOrEmpty(projTitle))
                {
                    ShowMessage("Project not found.", false);
                    return;
                }

                try
                {
                    using (SqlCommand delCmd = new SqlCommand("DELETE FROM Applications_tbl WHERE ProjectId = @Id", con))
                    {
                        delCmd.Parameters.AddWithValue("@Id", projId);
                        delCmd.ExecuteNonQuery();
                    }
                    using (SqlCommand delCmd = new SqlCommand("DELETE FROM Bids_tbl WHERE ProjectId = @Id", con))
                    {
                        delCmd.Parameters.AddWithValue("@Id", projId);
                        delCmd.ExecuteNonQuery();
                    }
                }
                catch { }

                using (SqlCommand delCmd = new SqlCommand("DELETE FROM Projects_tbl WHERE ProjectId = @Id", con))
                {
                    delCmd.Parameters.AddWithValue("@Id", projId);
                    int rows = delCmd.ExecuteNonQuery();
                    if (rows > 0)
                    {
                        LogActivity("Admin removed project #" + projId + " (" + projTitle + ")");
                        ShowMessage("Project '" + projTitle + "' (#" + projId + ") was successfully removed.", true);
                    }
                    else
                    {
                        ShowMessage("Failed to delete project.", false);
                    }
                }
            }

            pnlProjectDetails.Visible = false;
            LoadProjects();
        }
    }

    protected void btnUpdateStatus_Click(object sender, EventArgs e)
    {
        if (ViewState["SelectedProjectId"] == null) return;

        int projId = Convert.ToInt32(ViewState["SelectedProjectId"]);
        string newStatus = ddlChangeStatus.SelectedValue;

        using (SqlConnection con = new SqlConnection(s))
        {
            con.Open();
            string updateQuery = "UPDATE Projects_tbl SET Status = @Status WHERE ProjectId = @Id";
            using (SqlCommand cmd = new SqlCommand(updateQuery, con))
            {
                cmd.Parameters.AddWithValue("@Status", newStatus);
                cmd.Parameters.AddWithValue("@Id", projId);
                int rows = cmd.ExecuteNonQuery();
                if (rows > 0)
                {
                    LogActivity("Admin updated status of Project #" + projId + " to '" + newStatus + "'");
                    ShowMessage("Project #" + projId + " status updated to '" + newStatus + "' successfully.", true);

                    string badgeClass = newStatus == "Completed" ? "badge-green" : (newStatus == "In Progress" ? "badge-blue" : (newStatus == "Cancelled" ? "badge-red" : "badge-yellow"));
                    lblDetStatus.Text = "<span class='badge " + badgeClass + "'>" + newStatus + "</span>";
                }
                else
                {
                    ShowMessage("Could not update status.", false);
                }
            }
        }

        LoadProjects();
    }
}
