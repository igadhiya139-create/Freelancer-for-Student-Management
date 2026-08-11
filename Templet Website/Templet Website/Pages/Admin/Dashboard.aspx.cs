using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;

namespace FreelanceStudentSystem.Pages.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["UserType"].ToString() != "Admin")
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStats();
                LoadUsers();
            }
        }

        private void LoadStats()
        {
            var users = Application["Users"] as List<Dictionary<string, string>>;
            int totalUsers = users != null ? users.Count : 0;
            lblTotalUsers.Text = totalUsers.ToString();

            var projects = Application["Projects"] as List<Dictionary<string, string>>;
            int totalProjects = projects != null ? projects.Count : 0;
            lblTotalProjects.Text = totalProjects.ToString();

            int openProjects = 0;
            if (projects != null)
            {
                foreach (var p in projects)
                {
                    if (p.ContainsKey("Status") && p["Status"] == "Open")
                        openProjects++;
                }
            }
            lblOpenProjects.Text = openProjects.ToString();
        }

        private void LoadUsers()
        {
            var users = Application["Users"] as List<Dictionary<string, string>>;

            if (users == null || users.Count == 0)
            {
                gvUsers.DataSource = null;
                gvUsers.DataBind();
                return;
            }

            // Build a bindable list
            var display = new System.Data.DataTable();
            display.Columns.Add("UserID");
            display.Columns.Add("FullName");
            display.Columns.Add("Username");
            display.Columns.Add("Email");
            display.Columns.Add("UserType");
            display.Columns.Add("CreatedAt");

            foreach (var u in users)
            {
                display.Rows.Add(
                    u.ContainsKey("UserID")    ? u["UserID"]    : "",
                    u.ContainsKey("FullName")  ? u["FullName"]  : "",
                    u.ContainsKey("Username")  ? u["Username"]  : "",
                    u.ContainsKey("Email")     ? u["Email"]     : "",
                    u.ContainsKey("UserType")  ? u["UserType"]  : "",
                    u.ContainsKey("CreatedAt") ? u["CreatedAt"] : ""
                );
            }

            gvUsers.DataSource = display;
            gvUsers.DataBind();
        }
    }
}
