using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

public partial class StudentPanel_ChangePassword : System.Web.UI.Page
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

    private int GetStudentId(string email)
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

    private void LogActivity(int userId, string activity)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                string query = "INSERT INTO ActivityLogs_tbl (UserId, Activity, ActivityDate) VALUES (@UserId, @Activity, GETDATE())";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@Activity", activity);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
        catch
        {
            // Non-critical logging
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["Email"] == null || Session["Role"] == null || Session["Role"].ToString() != "Student")
        {
            Response.Redirect("~/Login.aspx");
            return;
        }

        string studentName = Session["Name"] != null ? Session["Name"].ToString() : "Student";
        lblSidebarName.Text = studentName + " · Student";
    }

    protected void btnChangePassword_Click(object sender, EventArgs e)
    {
        string currentPass = txtCurrentPassword.Text.Trim();
        string newPass = txtNewPassword.Text.Trim();
        string confirmPass = txtConfirmPassword.Text.Trim();

        if (string.IsNullOrEmpty(currentPass) || string.IsNullOrEmpty(newPass) || string.IsNullOrEmpty(confirmPass))
        {
            ShowMessage("All password fields are required.", false);
            return;
        }

        if (newPass.Length < 4)
        {
            ShowMessage("New password must be at least 4 characters long.", false);
            return;
        }

        if (newPass != confirmPass)
        {
            ShowMessage("New password and confirmation password do not match.", false);
            return;
        }

        try
        {
            string email = Session["Email"].ToString();
            int studentId = GetStudentId(email);

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();

                // 1. Verify existing password
                string checkQuery = "SELECT Password FROM Registration_tbl WHERE Email = @Email";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                {
                    checkCmd.Parameters.AddWithValue("@Email", email);
                    object dbPassObj = checkCmd.ExecuteScalar();

                    if (dbPassObj == null || dbPassObj.ToString() != currentPass)
                    {
                        ShowMessage("Current password is incorrect.", false);
                        return;
                    }
                }

                // 2. Update to new password
                string updateQuery = "UPDATE Registration_tbl SET Password = @NewPassword WHERE Email = @Email";
                using (SqlCommand updateCmd = new SqlCommand(updateQuery, con))
                {
                    updateCmd.Parameters.AddWithValue("@NewPassword", newPass);
                    updateCmd.Parameters.AddWithValue("@Email", email);
                    updateCmd.ExecuteNonQuery();
                }

                LogActivity(studentId, "Student changed account password.");
                ShowMessage("Password changed successfully!", true);

                txtCurrentPassword.Text = string.Empty;
                txtNewPassword.Text = string.Empty;
                txtConfirmPassword.Text = string.Empty;
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error changing password: " + ex.Message, false);
        }
    }
}
