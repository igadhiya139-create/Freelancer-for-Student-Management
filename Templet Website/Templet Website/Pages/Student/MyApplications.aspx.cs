using System;
using System.Collections.Generic;

namespace FreelanceStudentSystem.Pages.Student
{
    public partial class MyApplications : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["UserType"].ToString() != "Student")
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadApplications();
            }
        }

        private void LoadApplications()
        {
            var applications = Application["Applications"] as List<Dictionary<string, string>>;
            var projects     = Application["Projects"]     as List<Dictionary<string, string>>;
            string studentId = Session["UserID"].ToString();

            var display = new System.Data.DataTable();
            display.Columns.Add("ApplicationID");
            display.Columns.Add("ProjectTitle");
            display.Columns.Add("Category");
            display.Columns.Add("Budget");
            display.Columns.Add("CoverLetter");
            display.Columns.Add("Status");
            display.Columns.Add("AppliedAt");

            if (applications != null)
            {
                foreach (var a in applications)
                {
                    if (!a.ContainsKey("StudentID") || a["StudentID"] != studentId) continue;

                    // Look up the project title
                    string projectTitle = "N/A";
                    string category     = "";
                    string budget       = "";
                    if (projects != null && a.ContainsKey("ProjectID"))
                    {
                        foreach (var p in projects)
                        {
                            if (p.ContainsKey("ProjectID") && p["ProjectID"] == a["ProjectID"])
                            {
                                projectTitle = p.ContainsKey("Title")    ? p["Title"]    : "N/A";
                                category     = p.ContainsKey("Category") ? p["Category"] : "";
                                budget       = p.ContainsKey("Budget")   ? p["Budget"]   : "";
                                break;
                            }
                        }
                    }

                    display.Rows.Add(
                        a.ContainsKey("ApplicationID") ? a["ApplicationID"] : "",
                        projectTitle,
                        category,
                        budget,
                        a.ContainsKey("CoverLetter") ? a["CoverLetter"] : "",
                        a.ContainsKey("Status")      ? a["Status"]      : "Pending",
                        a.ContainsKey("AppliedAt")   ? a["AppliedAt"]   : ""
                    );
                }
            }

            gvApplications.DataSource = display;
            gvApplications.DataBind();
        }
    }
}
