using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class StudentPanel_MyApplications : System.Web.UI.Page
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

    private int GetStudentId(string email)
    {
        using (SqlConnection con = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT Id FROM Registration_tbl WHERE Email = @Email", con))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                con.Open();
                object obj = cmd.ExecuteScalar();
                int id;
                if (obj != null && int.TryParse(obj.ToString(), out id))
                {
                    return id;
                }
            }
        }
        return 0;
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
            LoadApplications();
        }
    }

    private void LoadApplications()
    {
        try
        {
            string email = Session["Email"].ToString();

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();
                string query = @"
                    SELECT 
                        a.AppId, 
                        a.ProjectId, 
                        a.BidAmount, 
                        a.DeliveryDays, 
                        a.Proposal, 
                        a.Status, 
                        a.AppliedDate, 
                        ISNULL(p.Title, 'Project #' + CAST(a.ProjectId AS NVARCHAR)) AS ProjectTitle,
                        ISNULL(p.Category, 'General') AS Category
                    FROM Applications_tbl a
                    LEFT JOIN Projects_tbl p ON a.ProjectId = p.ProjectId
                    WHERE a.StudentEmail = @Email
                    ORDER BY a.AppliedDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptApplications.DataSource = dt;
                            rptApplications.DataBind();
                            rptApplications.Visible = true;
                            pnlNoApplications.Visible = false;
                        }
                        else
                        {
                            rptApplications.Visible = false;
                            pnlNoApplications.Visible = true;
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading applications: " + ex.Message, false);
        }
    }

    protected void rptApplications_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "cmd_withdraw")
        {
            int appId;
            if (!int.TryParse(e.CommandArgument.ToString(), out appId))
            {
                ShowMessage("Invalid application ID.", false);
                return;
            }

            try
            {
                string email = Session["Email"].ToString();
                int studentId = GetStudentId(email);

                using (SqlConnection con = new SqlConnection(GetConnectionString()))
                {
                    con.Open();

                    // Retrieve ProjectId first
                    int projectId = 0;
                    string getProj = "SELECT ProjectId FROM Applications_tbl WHERE AppId = @AppId AND StudentEmail = @Email AND Status = 'Pending'";
                    using (SqlCommand cmdGet = new SqlCommand(getProj, con))
                    {
                        cmdGet.Parameters.AddWithValue("@AppId", appId);
                        cmdGet.Parameters.AddWithValue("@Email", email);
                        object pObj = cmdGet.ExecuteScalar();
                        if (pObj != null)
                        {
                            projectId = Convert.ToInt32(pObj);
                        }
                        else
                        {
                            ShowMessage("Could not withdraw application: it may have already been reviewed or does not belong to you.", false);
                            return;
                        }
                    }

                    // 1. Delete from Applications_tbl
                    string delApp = "DELETE FROM Applications_tbl WHERE AppId = @AppId AND StudentEmail = @Email AND Status = 'Pending'";
                    using (SqlCommand cmdDelApp = new SqlCommand(delApp, con))
                    {
                        cmdDelApp.Parameters.AddWithValue("@AppId", appId);
                        cmdDelApp.Parameters.AddWithValue("@Email", email);
                        cmdDelApp.ExecuteNonQuery();
                    }

                    // 2. Delete from Bids_tbl
                    if (projectId > 0)
                    {
                        string delBid = "DELETE FROM Bids_tbl WHERE ProjectId = @ProjectId AND (StudentEmail = @Email OR StudentId = @StudentId)";
                        using (SqlCommand cmdDelBid = new SqlCommand(delBid, con))
                        {
                            cmdDelBid.Parameters.AddWithValue("@ProjectId", projectId);
                            cmdDelBid.Parameters.AddWithValue("@Email", email);
                            cmdDelBid.Parameters.AddWithValue("@StudentId", studentId);
                            cmdDelBid.ExecuteNonQuery();
                        }
                    }

                    // 3. Log activity
                    try
                    {
                        string logQuery = "INSERT INTO ActivityLogs_tbl (UserId, Activity, ActivityDate) VALUES (@UserId, @Activity, GETDATE())";
                        using (SqlCommand cmdLog = new SqlCommand(logQuery, con))
                        {
                            cmdLog.Parameters.AddWithValue("@UserId", studentId);
                            cmdLog.Parameters.AddWithValue("@Activity", "Student withdrew application for Project #" + projectId);
                            cmdLog.ExecuteNonQuery();
                        }
                    }
                    catch { }

                    ShowMessage("Application withdrawn successfully.", true);
                    LoadApplications();
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error withdrawing application: " + ex.Message, false);
            }
        }
    }
}
