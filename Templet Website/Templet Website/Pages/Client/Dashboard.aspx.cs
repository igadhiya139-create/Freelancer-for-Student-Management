using System;
using System.Collections.Generic;

namespace FreelanceStudentSystem.Pages.Client
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }
            if (Session["UserType"].ToString() != "Client")
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadClientProjects();
            }
        }

        private void LoadClientProjects()
        {
            var projects = Application["Projects"] as List<Dictionary<string, string>>;
            string clientId = Session["UserID"].ToString();

            var display = new System.Data.DataTable();
            display.Columns.Add("ProjectID");
            display.Columns.Add("Title");
            display.Columns.Add("Category");
            display.Columns.Add("Budget");
            display.Columns.Add("Deadline");
            display.Columns.Add("Status");

            if (projects != null)
            {
                foreach (var p in projects)
                {
                    if (p.ContainsKey("ClientID") && p["ClientID"] == clientId)
                    {
                        display.Rows.Add(
                            p.ContainsKey("ProjectID") ? p["ProjectID"] : "",
                            p.ContainsKey("Title")     ? p["Title"]     : "",
                            p.ContainsKey("Category")  ? p["Category"]  : "",
                            p.ContainsKey("Budget")    ? p["Budget"]    : "",
                            p.ContainsKey("Deadline")  ? p["Deadline"]  : "",
                            p.ContainsKey("Status")    ? p["Status"]    : ""
                        );
                    }
                }
            }

            gvMyProjects.DataSource = display;
            gvMyProjects.DataBind();
        }
    }
}
