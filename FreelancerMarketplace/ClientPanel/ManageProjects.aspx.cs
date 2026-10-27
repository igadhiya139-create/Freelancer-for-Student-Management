using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ClientPanel_ManageProjects : System.Web.UI.Page
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

    int GetClientId(SqlConnection con, string email)
    {
        using (SqlCommand cmd = new SqlCommand("SELECT Id FROM Registration_tbl WHERE Email = @Email", con))
        {
            cmd.Parameters.AddWithValue("@Email", email);
            object res = cmd.ExecuteScalar();
            return res != null ? Convert.ToInt32(res) : 0;
        }
    }

    void LoadProjects()
    {
        string search = txtSearch.Text.Trim();
        string status = ddlStatusFilter.SelectedValue;
        string email = Session["Email"].ToString();

        using (SqlConnection con = new SqlConnection(s))
        {
            con.Open();
            int clientId = GetClientId(con, email);

            string query = "SELECT p.ProjectId, p.Title, p.Category, p.Budget, p.Deadline, p.Status, p.PostedDate, " +
                           "(SELECT COUNT(*) FROM Applications_tbl a WHERE a.ProjectId = p.ProjectId) AS ApplicantCount " +
                           "FROM Projects_tbl p " +
                           "WHERE (p.ClientEmail = @Email OR p.ClientId = @ClientId)";

            if (!string.IsNullOrEmpty(status))
            {
                query += " AND p.Status = @Status";
            }
            if (!string.IsNullOrEmpty(search))
            {
                query += " AND (p.Title LIKE @Search OR p.Category LIKE @Search)";
            }
            query += " ORDER BY p.ProjectId DESC";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@ClientId", clientId);
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
        LoadProjects();
    }

    protected void rptProjects_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "DeleteProject")
        {
            int projectId = Convert.ToInt32(e.CommandArgument);
            string email = Session["Email"].ToString();

            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                int clientId = GetClientId(con, email);

                string checkQuery = "SELECT Title FROM Projects_tbl WHERE ProjectId = @ProjectId AND (ClientEmail = @Email OR ClientId = @ClientId)";
                string projectTitle = "";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                {
                    checkCmd.Parameters.AddWithValue("@ProjectId", projectId);
                    checkCmd.Parameters.AddWithValue("@Email", email);
                    checkCmd.Parameters.AddWithValue("@ClientId", clientId);
                    object res = checkCmd.ExecuteScalar();
                    if (res != null) projectTitle = res.ToString();
                }

                if (string.IsNullOrEmpty(projectTitle))
                {
                    ShowMessage("Unauthorized: You can only delete projects you posted.", false);
                    return;
                }

                try
                {
                    using (SqlCommand delApp = new SqlCommand("DELETE FROM Applications_tbl WHERE ProjectId = @ProjectId", con))
                    {
                        delApp.Parameters.AddWithValue("@ProjectId", projectId);
                        delApp.ExecuteNonQuery();
                    }
                    using (SqlCommand delBid = new SqlCommand("DELETE FROM Bids_tbl WHERE ProjectId = @ProjectId", con))
                    {
                        delBid.Parameters.AddWithValue("@ProjectId", projectId);
                        delBid.ExecuteNonQuery();
                    }
                }
                catch { }

                string delProj = "DELETE FROM Projects_tbl WHERE ProjectId = @ProjectId AND (ClientEmail = @Email OR ClientId = @ClientId)";
                using (SqlCommand cmd = new SqlCommand(delProj, con))
                {
                    cmd.Parameters.AddWithValue("@ProjectId", projectId);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@ClientId", clientId);
                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0)
                    {
                        ShowMessage("Project '" + projectTitle + "' (#" + projectId + ") was successfully deleted.", true);
                    }
                    else
                    {
                        ShowMessage("Could not delete project.", false);
                    }
                }
            }

            LoadProjects();
        }
    }
}
