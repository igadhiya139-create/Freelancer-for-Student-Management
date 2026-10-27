using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ClientPanel_PostProject : System.Web.UI.Page
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
                    ddlCategory.Items.Add(new ListItem("-- Select Category --", ""));
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

    protected void btnPostProject_Click(object sender, EventArgs e)
    {
        string title = txtTitle.Text.Trim();
        string desc = txtDescription.Text.Trim();
        string cat = ddlCategory.SelectedValue;
        string budget = txtBudget.Text.Trim();
        string deadline = txtDeadline.Text.Trim();
        string skills = txtSkills.Text.Trim();
        string email = Session["Email"].ToString();

        if (string.IsNullOrEmpty(title))
        {
            ShowMessage("Please enter a project title.", false);
            return;
        }
        if (string.IsNullOrEmpty(desc))
        {
            ShowMessage("Please enter a project description.", false);
            return;
        }
        if (string.IsNullOrEmpty(cat))
        {
            ShowMessage("Please select a valid category.", false);
            return;
        }
        if (string.IsNullOrEmpty(budget))
        {
            ShowMessage("Please enter a project budget.", false);
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                int clientId = GetClientId(con, email);

                string insertQuery = "INSERT INTO Projects_tbl (Title, Description, Category, Budget, Deadline, Skills, ClientId, ClientEmail, Status, PostedDate) " +
                                     "VALUES (@Title, @Description, @Category, @Budget, @Deadline, @Skills, @ClientId, @ClientEmail, 'Open', GETDATE())";

                using (SqlCommand cmd = new SqlCommand(insertQuery, con))
                {
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Description", desc);
                    cmd.Parameters.AddWithValue("@Category", cat);
                    cmd.Parameters.AddWithValue("@Budget", budget);

                    if (!string.IsNullOrEmpty(deadline))
                    {
                        cmd.Parameters.AddWithValue("@Deadline", Convert.ToDateTime(deadline));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@Deadline", DBNull.Value);
                    }

                    cmd.Parameters.AddWithValue("@Skills", string.IsNullOrEmpty(skills) ? (object)DBNull.Value : skills);
                    cmd.Parameters.AddWithValue("@ClientId", clientId);
                    cmd.Parameters.AddWithValue("@ClientEmail", email);

                    cmd.ExecuteNonQuery();
                }

                try
                {
                    string logQuery = "INSERT INTO ActivityLogs_tbl (UserId, Activity, ActivityDate) VALUES (@UserId, @Activity, GETDATE())";
                    using (SqlCommand logCmd = new SqlCommand(logQuery, con))
                    {
                        logCmd.Parameters.AddWithValue("@UserId", clientId);
                        logCmd.Parameters.AddWithValue("@Activity", "Client posted new project: " + title);
                        logCmd.ExecuteNonQuery();
                    }
                }
                catch { }

                ShowMessage("Project '" + title + "' was posted successfully! Students can now submit proposals.", true);

                txtTitle.Text = string.Empty;
                txtDescription.Text = string.Empty;
                ddlCategory.SelectedIndex = 0;
                txtBudget.Text = string.Empty;
                txtDeadline.Text = string.Empty;
                txtSkills.Text = string.Empty;
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error posting project: " + ex.Message, false);
        }
    }
}
