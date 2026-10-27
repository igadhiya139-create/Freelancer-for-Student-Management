using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ClientPanel_ProjectDetails : System.Web.UI.Page
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

            LoadCategories();
            LoadProject();
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

    void LoadCategories()
    {
        using (SqlConnection con = new SqlConnection(s))
        {
            con.Open();
            using (SqlCommand cmd = new SqlCommand("SELECT CategoryName FROM Categories_tbl WHERE Status = 'Active' ORDER BY CategoryName ASC", con))
            {
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    ddlCategory.Items.Clear();
                    while (dr.Read())
                    {
                        string cat = dr["CategoryName"].ToString();
                        ddlCategory.Items.Add(new ListItem(cat, cat));
                    }
                }
            }
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

    void LoadProject()
    {
        string projIdStr = Request.QueryString["id"];
        int projectId;
        if (string.IsNullOrEmpty(projIdStr) || !int.TryParse(projIdStr, out projectId))
        {
            Response.Redirect("ManageProjects.aspx");
            return;
        }

        string email = Session["Email"].ToString();

        using (SqlConnection con = new SqlConnection(s))
        {
            con.Open();
            int clientId = GetClientId(con, email);

            string query = "SELECT ProjectId, Title, Description, Category, Budget, Deadline, Status, Skills, PostedDate, " +
                           "(SELECT COUNT(*) FROM Applications_tbl WHERE ProjectId = @Id) AS AppCount " +
                           "FROM Projects_tbl WHERE ProjectId = @Id AND (ClientEmail = @Email OR ClientId = @ClientId)";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Id", projectId);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@ClientId", clientId);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        lblProjectId.Text = dr["ProjectId"].ToString();
                        txtTitle.Text = dr["Title"].ToString();
                        txtDescription.Text = dr["Description"].ToString();
                        txtBudget.Text = dr["Budget"].ToString();

                        string cat = dr["Category"].ToString();
                        if (ddlCategory.Items.FindByValue(cat) != null)
                        {
                            ddlCategory.SelectedValue = cat;
                        }
                        else if (!string.IsNullOrEmpty(cat))
                        {
                            ddlCategory.Items.Add(new ListItem(cat, cat));
                            ddlCategory.SelectedValue = cat;
                        }

                        if (dr["Deadline"] != DBNull.Value)
                        {
                            txtDeadline.Text = Convert.ToDateTime(dr["Deadline"]).ToString("yyyy-MM-dd");
                        }

                        string status = dr["Status"].ToString();
                        if (ddlStatus.Items.FindByValue(status) != null)
                        {
                            ddlStatus.SelectedValue = status;
                        }

                        txtSkills.Text = dr["Skills"] != DBNull.Value ? dr["Skills"].ToString() : "";
                        lblPostedDate.Text = dr["PostedDate"] != DBNull.Value ? Convert.ToDateTime(dr["PostedDate"]).ToString("dd MMM yyyy, hh:mm tt") : "N/A";

                        string appCount = dr["AppCount"].ToString();
                        lblApplicantCount.Text = appCount;
                        lnkViewApplicants.NavigateUrl = "ViewApplicants.aspx?projectId=" + projectId;

                        ViewState["ProjectId"] = projectId;
                    }
                    else
                    {

                        Response.Redirect("ManageProjects.aspx");
                    }
                }
            }
        }
    }

    protected void btnSaveProject_Click(object sender, EventArgs e)
    {
        if (ViewState["ProjectId"] == null) return;

        int projectId = Convert.ToInt32(ViewState["ProjectId"]);
        string title = txtTitle.Text.Trim();
        string desc = txtDescription.Text.Trim();
        string cat = ddlCategory.SelectedValue;
        string budget = txtBudget.Text.Trim();
        string deadline = txtDeadline.Text.Trim();
        string status = ddlStatus.SelectedValue;
        string skills = txtSkills.Text.Trim();
        string email = Session["Email"].ToString();

        if (string.IsNullOrEmpty(title))
        {
            ShowMessage("Project title is required.", false);
            return;
        }
        if (string.IsNullOrEmpty(desc))
        {
            ShowMessage("Project description is required.", false);
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                int clientId = GetClientId(con, email);

                string updateQuery = "UPDATE Projects_tbl SET Title = @Title, Description = @Desc, Category = @Cat, " +
                                     "Budget = @Budget, Deadline = @Deadline, Status = @Status, Skills = @Skills " +
                                     "WHERE ProjectId = @Id AND (ClientEmail = @Email OR ClientId = @ClientId)";

                using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                {
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Desc", desc);
                    cmd.Parameters.AddWithValue("@Cat", cat);
                    cmd.Parameters.AddWithValue("@Budget", budget);

                    if (!string.IsNullOrEmpty(deadline))
                    {
                        cmd.Parameters.AddWithValue("@Deadline", Convert.ToDateTime(deadline));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@Deadline", DBNull.Value);
                    }

                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@Skills", string.IsNullOrEmpty(skills) ? (object)DBNull.Value : skills);
                    cmd.Parameters.AddWithValue("@Id", projectId);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@ClientId", clientId);

                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0)
                    {
                        ShowMessage("Project details updated successfully!", true);
                    }
                    else
                    {
                        ShowMessage("Unauthorized: Could not update project.", false);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error updating project: " + ex.Message, false);
        }
    }
}
