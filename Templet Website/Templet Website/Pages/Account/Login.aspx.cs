using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Security;

namespace FreelanceStudentSystem.Pages.Account
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // If already logged in, redirect
            if (!IsPostBack && Session["UserID"] != null)
            {
                RedirectByUserType(Session["UserType"]?.ToString());
            }

            // Pre-fill username from Remember Me cookie
            if (!IsPostBack)
            {
                HttpCookie userCookie = Request.Cookies["RememberMeUser"];
                if (userCookie != null && !string.IsNullOrEmpty(userCookie["Username"]))
                {
                    txtUsername.Text = userCookie["Username"];
                    chkRememberMe.Checked = true;
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password))
            {
                lblMessage.Text = "<i class='bi bi-exclamation-circle'></i> Please enter both username and password.";
                return;
            }

            // ── Load in-memory user store ─────────────────────────────────
            var users = Application["Users"] as List<Dictionary<string, string>>;

            // Seed a default admin if no users exist yet
            if (users == null || users.Count == 0)
            {
                SeedDefaultAdmin();
                users = Application["Users"] as List<Dictionary<string, string>>;
            }

            // ── Find matching user ────────────────────────────────────────
            Dictionary<string, string> found = null;
            if (users != null)
            {
                string enteredHash = HashPassword(password);
                foreach (var u in users)
                {
                    if (u["Username"].Equals(username, StringComparison.OrdinalIgnoreCase)
                        && u["Password"] == enteredHash)
                    {
                        found = u;
                        break;
                    }
                }
            }

            if (found != null)
            {
                // ── Set Session ───────────────────────────────────────────
                Session["UserID"]   = found["UserID"];
                Session["UserType"] = found["UserType"];
                Session["FullName"] = found["FullName"];
                Session["Username"] = found["Username"];

                // ── Handle Remember Me Cookie ─────────────────────────────
                if (chkRememberMe.Checked)
                {
                    HttpCookie rememberCookie = new HttpCookie("RememberMeUser");
                    rememberCookie["Username"] = username;
                    rememberCookie.Expires = DateTime.Now.AddDays(30);
                    rememberCookie.HttpOnly = true;
                    Response.Cookies.Add(rememberCookie);
                    FormsAuthentication.SetAuthCookie(username, true);
                }
                else
                {
                    // Clear any existing remember-me cookie
                    HttpCookie expireCookie = new HttpCookie("RememberMeUser");
                    expireCookie.Expires = DateTime.Now.AddDays(-1);
                    Response.Cookies.Add(expireCookie);
                    FormsAuthentication.SetAuthCookie(username, false);
                }

                RedirectByUserType(found["UserType"]);
            }
            else
            {
                lblMessage.Text = "<i class='bi bi-exclamation-circle'></i> Invalid username or password.";
            }
        }

        // ── Seed a default Admin account ──────────────────────────────────────────
        private void SeedDefaultAdmin()
        {
            var users = new List<Dictionary<string, string>>();
            users.Add(new Dictionary<string, string>
            {
                { "UserID",   "1" },
                { "FullName", "System Admin" },
                { "Username", "admin" },
                { "Email",    "admin@freelancehub.com" },
                { "Password", HashPassword("admin123") },  // stored as SHA-256 hash
                { "UserType", "Admin" },
                { "CreatedAt", DateTime.Now.ToString("dd-MM-yyyy HH:mm") }
            });
            Application["Users"]   = users;
            Application["NextUID"] = 2;
        }

        // ── Password Hashing (SHA-256) ────────────────────────────────────────────
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

        private void RedirectByUserType(string userType)
        {
            switch (userType)
            {
                case "Student":
                    Response.Redirect("~/Pages/Student/Dashboard.aspx");
                    break;
                case "Client":
                    Response.Redirect("~/Pages/Client/Dashboard.aspx");
                    break;
                case "Admin":
                    Response.Redirect("~/Pages/Admin/Dashboard.aspx");
                    break;
                default:
                    Response.Redirect("~/Pages/Account/Login.aspx");
                    break;
            }
        }
    }
}
