using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class StudentPanel_SkillsManagement : System.Web.UI.Page
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
            pnlMsg.Style["background"] = "rgba(52, 211, 153, 0.15)";
            pnlMsg.Style["border"] = "1px solid #34d399";
            pnlMsg.Style["color"] = "#34d399";
        }
        else
        {
            pnlMsg.Style["background"] = "rgba(239, 68, 68, 0.15)";
            pnlMsg.Style["border"] = "1px solid #ef4444";
            pnlMsg.Style["color"] = "#f87171";
        }
    }

    private int GetStudentId(string email)
    {
        using (SqlConnection con = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT Id FROM Registration_tbl WHERE Email = @Email", con))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                con.Open();
                object obj = cmd.ExecuteScalar();
                int id;
                if (obj != null && int.TryParse(obj.ToString(), out id))
                {
                    return id;
                }
            }
        }
        return 0;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["Email"] == null || Session["Role"] == null || Session["Role"].ToString() != "Student")
        {
            Response.Redirect("~/Login.aspx");
            return;
        }

        string name = Session["UserName"] != null ? Session["UserName"].ToString() : 
                     (Session["Name"] != null ? Session["Name"].ToString() : "Student");
        lblSidebarName.Text = name + " · Student";

        if (!IsPostBack)
        {
            LoadSkills();
        }
    }

    private void LoadSkills()
    {
        try
        {
            string email = Session["Email"].ToString();

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();
                string query = "SELECT SkillId, SkillName, SkillLevel, AddedDate FROM Skills_tbl WHERE StudentEmail = @Email ORDER BY AddedDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptSkills.DataSource = dt;
                            rptSkills.DataBind();
                            rptSkills.Visible = true;
                            pnlNoSkills.Visible = false;
                        }
                        else
                        {
                            rptSkills.Visible = false;
                            pnlNoSkills.Visible = true;
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading skills: " + ex.Message, false);
        }
    }

    protected void Save_btn_Click(object sender, EventArgs e)
    {
        string skillName = txtSkillName.Text.Trim();
        string levelStr = txtSkillLevel.Text.Trim();

        if (string.IsNullOrEmpty(skillName) || string.IsNullOrEmpty(levelStr))
        {
            ShowMessage("Please enter both Skill Name and Proficiency Level.", false);
            return;
        }

        int level;
        if (!int.TryParse(levelStr, out level) || level < 0 || level > 100)
        {
            ShowMessage("Skill proficiency level must be an integer between 0 and 100.", false);
            return;
        }

        try
        {
            string email = Session["Email"].ToString();
            int studentId = GetStudentId(email);

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();

                // Check if this skill already exists for this student
                string checkQuery = "SELECT SkillId FROM Skills_tbl WHERE StudentEmail = @Email AND LOWER(SkillName) = @SkillName";
                int existingSkillId = 0;
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                {
                    checkCmd.Parameters.AddWithValue("@Email", email);
                    checkCmd.Parameters.AddWithValue("@SkillName", skillName.ToLower());
                    object res = checkCmd.ExecuteScalar();
                    if (res != null)
                    {
                        existingSkillId = Convert.ToInt32(res);
                    }
                }

                if (existingSkillId > 0)
                {
                    // UPDATE
                    string updateQuery = "UPDATE Skills_tbl SET SkillLevel = @SkillLevel, AddedDate = GETDATE() WHERE SkillId = @SkillId";
                    using (SqlCommand updateCmd = new SqlCommand(updateQuery, con))
                    {
                        updateCmd.Parameters.AddWithValue("@SkillLevel", level.ToString());
                        updateCmd.Parameters.AddWithValue("@SkillId", existingSkillId);
                        updateCmd.ExecuteNonQuery();
                    }
                    ShowMessage("Skill '" + skillName + "' updated to " + level + "%.", true);
                }
                else
                {
                    // INSERT
                    string insertQuery = @"
                        INSERT INTO Skills_tbl (StudentId, StudentEmail, SkillName, SkillLevel, AddedDate) 
                        VALUES (@StudentId, @Email, @SkillName, @SkillLevel, GETDATE())";

                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, con))
                    {
                        insertCmd.Parameters.AddWithValue("@StudentId", studentId);
                        insertCmd.Parameters.AddWithValue("@Email", email);
                        insertCmd.Parameters.AddWithValue("@SkillName", skillName);
                        insertCmd.Parameters.AddWithValue("@SkillLevel", level.ToString());
                        insertCmd.ExecuteNonQuery();
                    }
                    ShowMessage("Skill '" + skillName + "' added successfully!", true);
                }
            }

            txtSkillName.Text = string.Empty;
            txtSkillLevel.Text = string.Empty;
            LoadSkills();
        }
        catch (Exception ex)
        {
            ShowMessage("Error saving skill: " + ex.Message, false);
        }
    }

    protected void rptSkills_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "cmd_del")
        {
            int skillId;
            if (!int.TryParse(e.CommandArgument.ToString(), out skillId))
            {
                ShowMessage("Invalid skill ID.", false);
                return;
            }

            try
            {
                string email = Session["Email"].ToString();

                using (SqlConnection con = new SqlConnection(GetConnectionString()))
                {
                    con.Open();
                    string query = "DELETE FROM Skills_tbl WHERE SkillId = @SkillId AND StudentEmail = @Email";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@SkillId", skillId);
                        cmd.Parameters.AddWithValue("@Email", email);
                        int rows = cmd.ExecuteNonQuery();
                        if (rows > 0)
                        {
                            ShowMessage("Skill removed successfully.", true);
                        }
                    }
                }

                LoadSkills();
            }
            catch (Exception ex)
            {
                ShowMessage("Error removing skill: " + ex.Message, false);
            }
        }
    }
}
