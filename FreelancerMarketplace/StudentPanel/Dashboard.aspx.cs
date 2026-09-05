using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class StudentPanel_Dashboard : System.Web.UI.Page
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

        if (!IsPostBack)
        {
            LoadStudentData();
        }
    }

    private void LoadStudentData()
    {
        try
        {
            string email = Session["Email"].ToString();
            string name = Session["UserName"] != null ? Session["UserName"].ToString() : 
                         (Session["Name"] != null ? Session["Name"].ToString() : "Student");

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();

                // 1. Fetch student info
                using (SqlCommand cmdUser = new SqlCommand("SELECT Id, Name FROM Registration_tbl WHERE Email = @Email", con))
                {
                    cmdUser.Parameters.AddWithValue("@Email", email);
                    using (SqlDataReader dr = cmdUser.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            name = dr["Name"].ToString();
                            Session["Name"] = name;
                            Session["UserName"] = name;
                        }
                    }
                }

                lblWelcomeName.Text = name;
                lblSidebarName.Text = name + " · Student";

                // 2. Compute Dashboard Statistics
                // Total Applications
                int totalApps = 0;
                int inProgressApps = 0;
                int completedApps = 0;

                string queryStats = @"
                    SELECT 
                        COUNT(*) AS TotalApps,
                        ISNULL(SUM(CASE WHEN LOWER(a.Status) IN ('hired', 'accepted', 'in progress') THEN 1 ELSE 0 END), 0) AS InProgressApps,
                        ISNULL(SUM(CASE WHEN LOWER(p.Status) = 'completed' THEN 1 ELSE 0 END), 0) AS CompletedApps
                    FROM Applications_tbl a
                    LEFT JOIN Projects_tbl p ON a.ProjectId = p.ProjectId
                    WHERE a.StudentEmail = @Email";

                using (SqlCommand cmdStats = new SqlCommand(queryStats, con))
                {
                    cmdStats.Parameters.AddWithValue("@Email", email);
                    using (SqlDataReader drStats = cmdStats.ExecuteReader())
                    {
                        if (drStats.Read())
                        {
                            totalApps = Convert.ToInt32(drStats["TotalApps"]);
                            inProgressApps = Convert.ToInt32(drStats["InProgressApps"]);
                            completedApps = Convert.ToInt32(drStats["CompletedApps"]);
                        }
                    }
                }

                lblTotalApplications.Text = totalApps.ToString();
                lblInProgress.Text = inProgressApps.ToString();
                lblCompleted.Text = completedApps.ToString();

                // 3. Available Projects Count
                int openProjects = 0;
                using (SqlCommand cmdProj = new SqlCommand("SELECT COUNT(*) FROM Projects_tbl WHERE LOWER(ISNULL(Status, 'open')) = 'open'", con))
                {
                    object obj = cmdProj.ExecuteScalar();
                    if (obj != null)
                    {
                        openProjects = Convert.ToInt32(obj);
                    }
                }
                lblAvailableProjects.Text = openProjects.ToString();

                // 4. Load Recent Applications
                string queryRecent = @"
                    SELECT TOP 5 
                        a.AppId, 
                        a.ProjectId, 
                        a.BidAmount, 
                        a.Status, 
                        a.AppliedDate, 
                        ISNULL(p.Title, 'Project #' + CAST(a.ProjectId AS NVARCHAR)) AS ProjectTitle
                    FROM Applications_tbl a
                    LEFT JOIN Projects_tbl p ON a.ProjectId = p.ProjectId
                    WHERE a.StudentEmail = @Email
                    ORDER BY a.AppliedDate DESC";

                using (SqlCommand cmdRecent = new SqlCommand(queryRecent, con))
                {
                    cmdRecent.Parameters.AddWithValue("@Email", email);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmdRecent))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptRecentApplications.DataSource = dt;
                            rptRecentApplications.DataBind();
                            rptRecentApplications.Visible = true;
                            pnlNoApplications.Visible = false;
                        }
                        else
                        {
                            rptRecentApplications.Visible = false;
                            pnlNoApplications.Visible = true;
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading dashboard data: " + ex.Message, false);
        }
    }
}
