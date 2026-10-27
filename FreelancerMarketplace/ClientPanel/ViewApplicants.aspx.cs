using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ClientPanel_ViewApplicants : System.Web.UI.Page
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
            lblSidebarName.Text = name + " · Client";

            LoadProjectFilter();

            string projParam = Request.QueryString["projectId"];
            if (!string.IsNullOrEmpty(projParam) && ddlProjectFilter.Items.FindByValue(projParam) != null)
            {
                ddlProjectFilter.SelectedValue = projParam;
            }

            LoadApplicants();
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

    int GetClientId(SqlConnection con, string email)
    {
        using (SqlCommand cmd = new SqlCommand("SELECT Id FROM Registration_tbl WHERE Email = @Email", con))
        {
            cmd.Parameters.AddWithValue("@Email", email);
            object res = cmd.ExecuteScalar();
            return res != null ? Convert.ToInt32(res) : 0;
        }
    }

    void LoadProjectFilter()
    {
        string email = Session["Email"].ToString();

        using (SqlConnection con = new SqlConnection(s))
        {
            con.Open();
            int clientId = GetClientId(con, email);

            string query = "SELECT ProjectId, Title FROM Projects_tbl WHERE ClientEmail = @Email OR ClientId = @ClientId ORDER BY ProjectId DESC";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@ClientId", clientId);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    ddlProjectFilter.Items.Clear();
                    ddlProjectFilter.Items.Add(new ListItem("All My Projects", ""));
                    while (dr.Read())
                    {
                        string id = dr["ProjectId"].ToString();
                        string title = dr["Title"].ToString();
                        ddlProjectFilter.Items.Add(new ListItem(title, id));
                    }
                }
            }
        }
    }

    void LoadApplicants()
    {
        string email = Session["Email"].ToString();
        string search = txtSearch.Text.Trim();
        string projFilter = ddlProjectFilter.SelectedValue;
        string statusFilter = ddlStatusFilter.SelectedValue;

        using (SqlConnection con = new SqlConnection(s))
        {
            con.Open();
            int clientId = GetClientId(con, email);

            string query = "SELECT a.AppId, a.BidAmount, a.DeliveryDays, a.Status, a.AppliedDate, " +
                           "p.Title AS ProjectTitle, ISNULL(r.Name, a.StudentEmail) AS StudentName " +
                           "FROM Applications_tbl a " +
                           "INNER JOIN Projects_tbl p ON a.ProjectId = p.ProjectId " +
                           "LEFT JOIN Registration_tbl r ON a.StudentEmail = r.Email " +
                           "WHERE (p.ClientEmail = @Email OR p.ClientId = @ClientId)";

            int pid;
            if (!string.IsNullOrEmpty(projFilter) && int.TryParse(projFilter, out pid))
            {
                query += " AND a.ProjectId = @ProjectId";
            }
            if (!string.IsNullOrEmpty(statusFilter))
            {
                query += " AND a.Status = @Status";
            }
            if (!string.IsNullOrEmpty(search))
            {
                query += " AND (r.Name LIKE @Search OR a.StudentEmail LIKE @Search)";
            }

            query += " ORDER BY a.AppliedDate DESC";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@ClientId", clientId);

                int pidVal;
                if (!string.IsNullOrEmpty(projFilter) && int.TryParse(projFilter, out pidVal))
                {
                    cmd.Parameters.AddWithValue("@ProjectId", pidVal);
                }
                if (!string.IsNullOrEmpty(statusFilter))
                {
                    cmd.Parameters.AddWithValue("@Status", statusFilter);
                }
                if (!string.IsNullOrEmpty(search))
                {
                    cmd.Parameters.AddWithValue("@Search", "%" + search + "%");
                }

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    lblCount.Text = dt.Rows.Count.ToString();
                    gvApplicants.DataSource = dt;
                    gvApplicants.DataBind();
                }
            }
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        pnlMsg.Visible = false;
        LoadApplicants();
    }

    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        txtSearch.Text = string.Empty;
        ddlProjectFilter.SelectedIndex = 0;
        ddlStatusFilter.SelectedIndex = 0;
        pnlMsg.Visible = false;
        LoadApplicants();
    }

    protected void gvApplicants_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "HireStudent" || e.CommandName == "RejectStudent")
        {
            int appId = Convert.ToInt32(e.CommandArgument);
            string newStatus = e.CommandName == "HireStudent" ? "Hired" : "Rejected";
            string email = Session["Email"].ToString();

            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                int clientId = GetClientId(con, email);

                string checkQuery = "SELECT a.AppId, a.ProjectId, p.Title, ISNULL(r.Name, a.StudentEmail) as StudentName " +
                                   "FROM Applications_tbl a " +
                                   "INNER JOIN Projects_tbl p ON a.ProjectId = p.ProjectId " +
                                   "LEFT JOIN Registration_tbl r ON a.StudentEmail = r.Email " +
                                   "WHERE a.AppId = @AppId AND (p.ClientEmail = @Email OR p.ClientId = @ClientId)";

                string studentName = "";
                string projTitle = "";
                int projId = 0;

                using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                {
                    checkCmd.Parameters.AddWithValue("@AppId", appId);
                    checkCmd.Parameters.AddWithValue("@Email", email);
                    checkCmd.Parameters.AddWithValue("@ClientId", clientId);

                    using (SqlDataReader dr = checkCmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            studentName = dr["StudentName"].ToString();
                            projTitle = dr["Title"].ToString();
                            projId = Convert.ToInt32(dr["ProjectId"]);
                        }
                    }
                }

                if (projId == 0)
                {
                    ShowMessage("Unauthorized: You can only manage applicants for your own projects.", false);
                    return;
                }

                using (SqlCommand updateCmd = new SqlCommand("UPDATE Applications_tbl SET Status = @Status WHERE AppId = @AppId", con))
                {
                    updateCmd.Parameters.AddWithValue("@Status", newStatus);
                    updateCmd.Parameters.AddWithValue("@AppId", appId);
                    updateCmd.ExecuteNonQuery();
                }

                if (newStatus == "Hired")
                {
                    using (SqlCommand projCmd = new SqlCommand("UPDATE Projects_tbl SET Status = 'In Progress' WHERE ProjectId = @ProjectId AND Status = 'Open'", con))
                    {
                        projCmd.Parameters.AddWithValue("@ProjectId", projId);
                        projCmd.ExecuteNonQuery();
                    }
                }

                try
                {
                    string logQuery = "INSERT INTO ActivityLogs_tbl (UserId, Activity, ActivityDate) VALUES (@UserId, @Activity, GETDATE())";
                    using (SqlCommand logCmd = new SqlCommand(logQuery, con))
                    {
                        logCmd.Parameters.AddWithValue("@UserId", clientId);
                        logCmd.Parameters.AddWithValue("@Activity", "Client " + newStatus.ToLower() + " applicant " + studentName + " for '" + projTitle + "'");
                        logCmd.ExecuteNonQuery();
                    }
                }
                catch { }

                ShowMessage("Applicant " + studentName + " was marked as " + newStatus + ".", true);
            }

            LoadApplicants();
        }
    }
}
