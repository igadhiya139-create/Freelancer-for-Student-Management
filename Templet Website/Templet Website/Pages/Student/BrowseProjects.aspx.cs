using System;
using System.Collections.Generic;

namespace FreelanceStudentSystem.Pages.Student
{
    public partial class BrowseProjects : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProjects();
            }
        }

        private void LoadProjects(string search = "", string category = "")
        {
            var projects = Application["Projects"] as List<Dictionary<string, string>>;

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
                    // Only show Open projects
                    if (!p.ContainsKey("Status") || p["Status"] != "Open") continue;

                    // Apply search filter
                    if (!string.IsNullOrEmpty(search) &&
                        p.ContainsKey("Title") &&
                        !p["Title"].ToLower().Contains(search.ToLower())) continue;

                    // Apply category filter
                    if (!string.IsNullOrEmpty(category) &&
                        p.ContainsKey("Category") &&
                        p["Category"] != category) continue;

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

            gvProjects.DataSource = display;
            gvProjects.DataBind();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadProjects(txtSearch.Text.Trim(), ddlCategory.SelectedValue);
        }

        protected void gvProjects_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Apply")
            {
                int projectId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect("ApplyProject.aspx?ProjectID=" + projectId);
            }
        }
    }
}