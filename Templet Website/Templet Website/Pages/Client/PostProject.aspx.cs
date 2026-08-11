using System;
using System.Collections.Generic;

namespace FreelanceStudentSystem.Pages.Client
{
    public partial class PostProject : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["UserType"].ToString() != "Client")
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
            }
        }

        protected void btnPost_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtTitle.Text) ||
                string.IsNullOrWhiteSpace(txtDescription.Text) ||
                string.IsNullOrWhiteSpace(txtBudget.Text))
            {
                lblMsg.Text = "Please fill in all required fields.";
                return;
            }

            // ── Load or create in-memory project store ───────────────────
            var projects = Application["Projects"] as List<Dictionary<string, string>>;
            if (projects == null)
            {
                projects = new List<Dictionary<string, string>>();
                Application["Projects"]  = projects;
                Application["NextPID"]   = 1;
            }

            int newProjectID = (int)Application["NextPID"];
            Application["NextPID"] = newProjectID + 1;

            projects.Add(new Dictionary<string, string>
            {
                { "ProjectID",   newProjectID.ToString()             },
                { "ClientID",    Session["UserID"].ToString()        },
                { "Title",       txtTitle.Text.Trim()                },
                { "Description", txtDescription.Text.Trim()         },
                { "Category",    ddlCategory.SelectedValue           },
                { "Budget",      txtBudget.Text.Trim()              },
                { "Deadline",    txtDeadline.Text.Trim()            },
                { "Status",      "Open"                              },
                { "CreatedAt",   DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") }
            });

            lblMsg.ForeColor = System.Drawing.Color.Green;
            lblMsg.Text = "Project posted successfully! <a href='Dashboard.aspx'>Go to Dashboard</a>";

            // Clear form
            txtTitle.Text       = "";
            txtDescription.Text = "";
            txtBudget.Text      = "";
            txtDeadline.Text    = "";
        }
    }
}
