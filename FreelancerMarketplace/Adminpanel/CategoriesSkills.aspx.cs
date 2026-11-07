using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AdminPanel_CategoriesSkills : System.Web.UI.Page
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
            LoadCategories();
            LoadSkills();
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

    void LoadCategories()
    {
        using (SqlConnection con = new SqlConnection(s))
        {
            string query = "SELECT c.CategoryID, c.CategoryName, ISNULL(c.Status, 'Active') AS Status, " +
                           "(SELECT COUNT(*) FROM Projects_tbl p WHERE p.Category = c.CategoryName) AS ProjectCount " +
                           "FROM Categories_tbl c ORDER BY c.CategoryID ASC";

            using (SqlDataAdapter da = new SqlDataAdapter(query, con))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                lblCategoryCount.Text = dt.Rows.Count.ToString();
                rptCategories.DataSource = dt;
                rptCategories.DataBind();
            }
        }
    }

    void LoadSkills()
    {
        using (SqlConnection con = new SqlConnection(s))
        {
            string query = "SELECT SkillId, SkillName, StudentEmail, StudentId, SkillLevel, AddedDate FROM Skills_tbl ORDER BY SkillId DESC";

            using (SqlDataAdapter da = new SqlDataAdapter(query, con))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                lblSkillCount.Text = dt.Rows.Count.ToString();
                rptSkills.DataSource = dt;
                rptSkills.DataBind();
            }
        }
    }

    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        pnlMsg.Visible = false;
        LoadCategories();
        LoadSkills();
    }

    protected void btnAddCategory_Click(object sender, EventArgs e)
    {
        string catName = txtNewCategory.Text.Trim();
        if (string.IsNullOrEmpty(catName))
        {
            ShowMessage("Please enter a category name.", false);
            return;
        }

        using (SqlConnection con = new SqlConnection(s))
        {
            con.Open();

            using (SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Categories_tbl WHERE CategoryName = @Name", con))
            {
                checkCmd.Parameters.AddWithValue("@Name", catName);
                int exists = Convert.ToInt32(checkCmd.ExecuteScalar());
                if (exists > 0)
                {
                    ShowMessage("Category '" + catName + "' already exists.", false);
                    return;
                }
            }

            string insertQuery = "INSERT INTO Categories_tbl (CategoryName, Status, CreatedDate) VALUES (@Name, 'Active', GETDATE())";
            using (SqlCommand cmd = new SqlCommand(insertQuery, con))
            {
                cmd.Parameters.AddWithValue("@Name", catName);
                cmd.ExecuteNonQuery();
            }

            LogActivity("Admin added category: " + catName);
            ShowMessage("Category '" + catName + "' added successfully.", true);
            txtNewCategory.Text = string.Empty;
        }

        LoadCategories();
    }

    protected void btnAddSkill_Click(object sender, EventArgs e)
    {
        string skillName = txtNewSkill.Text.Trim();
        string skillLevel = txtSkillLevel.Text.Trim();

        if (string.IsNullOrEmpty(skillName))
        {
            ShowMessage("Please enter a skill name.", false);
            return;
        }

        using (SqlConnection con = new SqlConnection(s))
        {
            con.Open();
            string insertQuery = "INSERT INTO Skills_tbl (SkillName, SkillLevel, StudentEmail, AddedDate) VALUES (@Name, @Level, 'All Students', GETDATE())";
            using (SqlCommand cmd = new SqlCommand(insertQuery, con))
            {
                cmd.Parameters.AddWithValue("@Name", skillName);
                cmd.Parameters.AddWithValue("@Level", string.IsNullOrEmpty(skillLevel) ? "80" : skillLevel);
                cmd.ExecuteNonQuery();
            }

            LogActivity("Admin added skill: " + skillName);
            ShowMessage("Skill '" + skillName + "' added successfully.", true);
            txtNewSkill.Text = string.Empty;
        }

        LoadSkills();
    }

    protected void rptCategories_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "DeleteCategory")
        {
            int catId = Convert.ToInt32(e.CommandArgument);
            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                string getCat = "SELECT CategoryName FROM Categories_tbl WHERE CategoryID = @Id";
                string name = "";
                using (SqlCommand cmd = new SqlCommand(getCat, con))
                {
                    cmd.Parameters.AddWithValue("@Id", catId);
                    object r = cmd.ExecuteScalar();
                    if (r != null) name = r.ToString();
                }

                using (SqlCommand cmd = new SqlCommand("DELETE FROM Categories_tbl WHERE CategoryID = @Id", con))
                {
                    cmd.Parameters.AddWithValue("@Id", catId);
                    cmd.ExecuteNonQuery();
                }

                LogActivity("Admin deleted category: " + name);
                ShowMessage("Category '" + name + "' was deleted successfully.", true);
            }

            LoadCategories();
        }
    }

    protected void rptSkills_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "DeleteSkill")
        {
            int skillId = Convert.ToInt32(e.CommandArgument);
            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                string getSkill = "SELECT SkillName FROM Skills_tbl WHERE SkillId = @Id";
                string name = "";
                using (SqlCommand cmd = new SqlCommand(getSkill, con))
                {
                    cmd.Parameters.AddWithValue("@Id", skillId);
                    object r = cmd.ExecuteScalar();
                    if (r != null) name = r.ToString();
                }

                using (SqlCommand cmd = new SqlCommand("DELETE FROM Skills_tbl WHERE SkillId = @Id", con))
                {
                    cmd.Parameters.AddWithValue("@Id", skillId);
                    cmd.ExecuteNonQuery();
                }

                LogActivity("Admin deleted skill: " + name);
                ShowMessage("Skill '" + name + "' was deleted successfully.", true);
            }

            LoadSkills();
        }
    }
}
