using System;
using System.Collections.Generic;

namespace FreelanceStudentSystem.Pages.Student
{
    public partial class Portfolio : System.Web.UI.Page
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
                LoadPortfolio();
            }
        }

        private void LoadPortfolio()
        {
            var portfolioItems = Application["Portfolio"] as List<Dictionary<string, string>>;
            string studentId   = Session["UserID"].ToString();

            var display = new System.Data.DataTable();
            display.Columns.Add("PortfolioID");
            display.Columns.Add("Title");
            display.Columns.Add("Description");
            display.Columns.Add("FileUrl");
            display.Columns.Add("UploadedAt");

            if (portfolioItems != null)
            {
                foreach (var item in portfolioItems)
                {
                    if (!item.ContainsKey("StudentID") || item["StudentID"] != studentId) continue;

                    display.Rows.Add(
                        item.ContainsKey("PortfolioID")  ? item["PortfolioID"]  : "",
                        item.ContainsKey("Title")        ? item["Title"]        : "",
                        item.ContainsKey("Description")  ? item["Description"]  : "",
                        item.ContainsKey("FileUrl")      ? item["FileUrl"]      : "",
                        item.ContainsKey("UploadedAt")   ? item["UploadedAt"]   : ""
                    );
                }
            }

            gvPortfolio.DataSource = display;
            gvPortfolio.DataBind();
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (!fuPortfolio.HasFile)
            {
                lblMsg.Text = "Please select a file to upload.";
                return;
            }

            if (string.IsNullOrWhiteSpace(txtPortfolioTitle.Text))
            {
                lblMsg.Text = "Please enter a title for this portfolio item.";
                return;
            }

            string fileName = System.IO.Path.GetFileName(fuPortfolio.FileName);
            string saveDir  = Server.MapPath("~/uploads/portfolio/");
            System.IO.Directory.CreateDirectory(saveDir);
            fuPortfolio.SaveAs(saveDir + fileName);

            string fileUrl = "~/uploads/portfolio/" + fileName;

            // ── Load or create in-memory portfolio store ─────────────────
            var portfolioItems = Application["Portfolio"] as List<Dictionary<string, string>>;
            if (portfolioItems == null)
            {
                portfolioItems        = new List<Dictionary<string, string>>();
                Application["Portfolio"] = portfolioItems;
                Application["NextPortfolioID"] = 1;
            }

            int newPortfolioID = (int)Application["NextPortfolioID"];
            Application["NextPortfolioID"] = newPortfolioID + 1;

            portfolioItems.Add(new Dictionary<string, string>
            {
                { "PortfolioID",  newPortfolioID.ToString()                    },
                { "StudentID",    Session["UserID"].ToString()                 },
                { "Title",        txtPortfolioTitle.Text.Trim()                },
                { "Description",  txtPortfolioDesc.Text.Trim()                },
                { "FileUrl",      fileUrl                                      },
                { "UploadedAt",   DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") }
            });

            lblMsg.ForeColor = System.Drawing.Color.Green;
            lblMsg.Text = "Portfolio item uploaded successfully!";
            LoadPortfolio();
        }
    }
}
