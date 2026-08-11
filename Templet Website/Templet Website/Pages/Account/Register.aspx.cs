using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI.WebControls;

namespace FreelanceStudentSystem.Pages.Account
{
    public partial class Register : System.Web.UI.Page
    {
        // Connection string from Web.config
        private string ConnStr => ConfigurationManager.ConnectionStrings["DBConn"].ConnectionString;

        // Page Load
        protected void Page_Load(object sender, EventArgs e)
        {
            // If already logged in, redirect away
            if (!IsPostBack && Session["UserID"] != null)
            {
                string userType = Session["UserType"]?.ToString();
                switch (userType)
                {
                    case "Student": Response.Redirect("~/Pages/Student/Dashboard.aspx"); break;
                    case "Client":  Response.Redirect("~/Pages/Client/Dashboard.aspx");  break;
                    case "Admin":   Response.Redirect("~/Pages/Admin/Dashboard.aspx");   break;
                }
            }

            if (!IsPostBack)
                BindGrid();
        }

        // Register Button
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            // Validation
            if (string.IsNullOrWhiteSpace(txtFullName.Text) ||
                string.IsNullOrWhiteSpace(txtUsername.Text) ||
                string.IsNullOrWhiteSpace(txtEmail.Text)    ||
                string.IsNullOrWhiteSpace(txtPassword.Text))
            {
                ShowMsg(lblMsg, "danger", "All fields are required.");
                return;
            }

            string fullName  = txtFullName.Text.Trim();
            string username  = txtUsername.Text.Trim();
            string email     = txtEmail.Text.Trim();
            string userType  = ddlUserType.SelectedValue;
            string passHash  = HashPassword(txtPassword.Text);

            try
            {
                using (SqlConnection con = new SqlConnection(ConnStr))
                {
                    con.Open();

                    // Check duplicate username
                    using (SqlCommand chkUser = new SqlCommand(
                        "SELECT COUNT(*) FROM Users WHERE Username = @u", con))
                    {
                        chkUser.Parameters.AddWithValue("@u", username);
                        if ((int)chkUser.ExecuteScalar() > 0)
                        {
                            ShowMsg(lblMsg, "danger", "Username already exists. Choose another.");
                            return;
                        }
                    }

                    // Check duplicate email
                    using (SqlCommand chkEmail = new SqlCommand(
                        "SELECT COUNT(*) FROM Users WHERE Email = @em", con))
                    {
                        chkEmail.Parameters.AddWithValue("@em", email);
                        if ((int)chkEmail.ExecuteScalar() > 0)
                        {
                            ShowMsg(lblMsg, "danger", "Email is already registered.");
                            return;
                        }
                    }

                    // INSERT new user
                    string sql = @"INSERT INTO Users (FullName, Username, Email, PasswordHash, UserType)
                                   VALUES (@fn, @un, @em, @ph, @ut)";
                    using (SqlCommand cmd = new SqlCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@fn", fullName);
                        cmd.Parameters.AddWithValue("@un", username);
                        cmd.Parameters.AddWithValue("@em", email);
                        cmd.Parameters.AddWithValue("@ph", passHash);
                        cmd.Parameters.AddWithValue("@ut", userType);
                        cmd.ExecuteNonQuery();
                    }
                }

                // Clear form
                txtFullName.Text = "";
                txtUsername.Text = "";
                txtEmail.Text    = "";
                txtPassword.Text = "";

                ShowMsg(lblMsg, "success", $"User '{username}' registered successfully!");
                BindGrid();
            }
            catch (Exception ex)
            {
                ShowMsg(lblMsg, "danger", "Error: " + ex.Message);
            }
        }

        // Bind GridView from database
        private void BindGrid()
        {
            try
            {
                DataTable dt = new DataTable();
                using (SqlConnection con = new SqlConnection(ConnStr))
                using (SqlDataAdapter da  = new SqlDataAdapter(
                    "SELECT UserID, FullName, Username, Email, UserType, CreatedAt FROM Users ORDER BY UserID", con))
                {
                    da.Fill(dt);
                }

                gvUsers.DataSource = dt;
                gvUsers.DataBind();
                //lblTotalUsers.Text = dt.Rows.Count.ToString();
            }
            catch (Exception ex)
            {
                lblGridMsg.Text = $"<div class='alert alert-danger'>DB Error: {ex.Message}</div>";
            }
        }

        // Show coloured alert message
        private void ShowMsg(System.Web.UI.WebControls.Label lbl, string type, string text)
        {
            string icon = type == "success" ? "bi-check-circle" :
                          type == "warning" ? "bi-exclamation-triangle" : "bi-exclamation-circle";
            lbl.Text = $"<div class='alert alert-{type} py-2 mb-0'><i class='bi {icon}'></i> {text}</div>";
        }

        // Password Hashing (SHA-256)
        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder sb = new StringBuilder();
                foreach (byte b in bytes)
                    sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }

        // Helper called from ASPX for badge colour
        protected string GetUserTypeBadge(string userType)
        {
            string css;
            switch ((userType ?? "").ToLower())
            {
                case "student": css = "badge-student"; break;
                case "client":  css = "badge-client";  break;
                case "admin":   css = "badge-admin";   break;
                default:        css = "badge-student"; break;
            }
            return "<span class='" + css + "'>" + userType + "</span>";
        }
    }
}
