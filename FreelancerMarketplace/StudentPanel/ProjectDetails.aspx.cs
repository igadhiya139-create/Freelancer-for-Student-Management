using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class StudentPanel_ProjectDetails : System.Web.UI.Page
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
            LoadProjectDetails();
        }
    }

    private void LoadProjectDetails()
    {
        string idStr = Request.QueryString["id"];
        int projectId;
        if (string.IsNullOrEmpty(idStr) || !int.TryParse(idStr, out projectId))
        {
            Response.Redirect("BrowseProjects.aspx");
            return;
        }

        try
        {
            string email = Session["Email"].ToString();

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();

                // 1. Fetch Project Details
                string queryProj = @"
                    SELECT 
                        p.ProjectId,
                        p.Title,
                        p.Description,
                        p.Budget,
                        p.Skills,
                        p.Category,
                        p.Deadline,
                        p.Status,
                        p.PostedDate,
                        p.ClientEmail,
                        ISNULL(r.Name, p.ClientEmail) AS ClientName
                    FROM Projects_tbl p
                    LEFT JOIN Registration_tbl r ON p.ClientId = r.Id
                    WHERE p.ProjectId = @ProjectId";

                using (SqlCommand cmd = new SqlCommand(queryProj, con))
                {
                    cmd.Parameters.AddWithValue("@ProjectId", projectId);
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblTitle.Text = dr["Title"].ToString();
                            lblDescription.Text = dr["Description"] != DBNull.Value ? dr["Description"].ToString() : "No detailed description provided.";
                            lblCategory.Text = dr["Category"] != DBNull.Value ? dr["Category"].ToString() : "General";
                            lblBudget.Text = dr["Budget"] != DBNull.Value ? dr["Budget"].ToString() : "N/A";
                            lblSkills.Text = dr["Skills"] != DBNull.Value && !string.IsNullOrWhiteSpace(dr["Skills"].ToString()) ? dr["Skills"].ToString() : "None specified";
                            lblPostedDate.Text = dr["PostedDate"] != DBNull.Value ? Convert.ToDateTime(dr["PostedDate"]).ToString("dd MMM yyyy") : "N/A";
                            lblDeadline.Text = dr["Deadline"] != DBNull.Value ? Convert.ToDateTime(dr["Deadline"]).ToString("dd MMM yyyy") : "Flexible";
                            lblClientName.Text = dr["ClientName"] != DBNull.Value ? dr["ClientName"].ToString() : "Client";

                            string status = dr["Status"] != DBNull.Value ? dr["Status"].ToString() : "Open";
                            lblStatus.Text = status;
                            lblStatus.CssClass = status.Equals("Open", StringComparison.OrdinalIgnoreCase) ? "badge badge-green" : "badge badge-yellow";
                        }
                        else
                        {
                            dr.Close();
                            Response.Redirect("BrowseProjects.aspx");
                            return;
                        }
                    }
                }

                // 2. Count Total Applicants
                using (SqlCommand cmdCount = new SqlCommand("SELECT COUNT(*) FROM Applications_tbl WHERE ProjectId = @ProjectId", con))
                {
                    cmdCount.Parameters.AddWithValue("@ProjectId", projectId);
                    object cnt = cmdCount.ExecuteScalar();
                    lblApplicantCount.Text = cnt != null ? cnt.ToString() : "0";
                }

                // 3. Check if current student has already applied
                string queryApp = "SELECT Status, AppId FROM Applications_tbl WHERE ProjectId = @ProjectId AND StudentEmail = @Email";
                using (SqlCommand cmdApp = new SqlCommand(queryApp, con))
                {
                    cmdApp.Parameters.AddWithValue("@ProjectId", projectId);
                    cmdApp.Parameters.AddWithValue("@Email", email);

                    using (SqlDataReader drApp = cmdApp.ExecuteReader())
                    {
                        if (drApp.Read())
                        {
                            pnlAlreadyApplied.Visible = true;
                            lblApplicationStatus.Text = drApp["Status"].ToString();
                            lnkApply.Text = "Update Application";
                            lnkApply.NavigateUrl = "ApplyProject.aspx?pid=" + projectId;
                        }
                        else
                        {
                            pnlAlreadyApplied.Visible = false;
                            lnkApply.Text = "Apply for Project";
                            lnkApply.NavigateUrl = "ApplyProject.aspx?pid=" + projectId;
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading project: " + ex.Message, false);
        }
    }
}
