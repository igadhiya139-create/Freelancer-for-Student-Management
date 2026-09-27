using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class StudentPanel_ApplyProject : System.Web.UI.Page
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
            LoadProjectDetails();
            FillExistingApplication();
        }
    }

    private void LoadProjectDetails()
    {
        string pidStr = Request.QueryString["pid"];
        if (string.IsNullOrEmpty(pidStr))
        {
            pidStr = Request.QueryString["id"];
        }
        int projectId;
        if (string.IsNullOrEmpty(pidStr) || !int.TryParse(pidStr, out projectId))
        {
            Response.Redirect("BrowseProjects.aspx");
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT Title, ClientId, ClientEmail, Status FROM Projects_tbl WHERE ProjectId = @ProjectId", con))
                {
                    cmd.Parameters.AddWithValue("@ProjectId", projectId);
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblProjectTitle.Text = dr["Title"].ToString();
                            ViewState["ProjectTitle"] = dr["Title"].ToString();
                            ViewState["ClientId"] = dr["ClientId"] != DBNull.Value ? Convert.ToInt32(dr["ClientId"]) : 0;
                            ViewState["ClientEmail"] = dr["ClientEmail"] != DBNull.Value ? dr["ClientEmail"].ToString() : "";
                        }
                        else
                        {
                            dr.Close();
                            Response.Redirect("BrowseProjects.aspx");
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

    private void FillExistingApplication()
    {
        string pidStr = Request.QueryString["pid"];
        if (string.IsNullOrEmpty(pidStr))
        {
            pidStr = Request.QueryString["id"];
        }
        int projectId;
        if (string.IsNullOrEmpty(pidStr) || !int.TryParse(pidStr, out projectId)) return;

        try
        {
            string email = Session["Email"].ToString();

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();
                string query = "SELECT AppId, Proposal, BidAmount, DeliveryDays, Status FROM Applications_tbl WHERE ProjectId = @ProjectId AND StudentEmail = @Email";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ProjectId", projectId);
                    cmd.Parameters.AddWithValue("@Email", email);

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            txtProposal.Text = dr["Proposal"] != DBNull.Value ? dr["Proposal"].ToString() : "";
                            txtBid.Text = dr["BidAmount"] != DBNull.Value ? Convert.ToDecimal(dr["BidAmount"]).ToString("0.##") : "";
                            txtDays.Text = dr["DeliveryDays"] != DBNull.Value ? dr["DeliveryDays"].ToString() : "";

                            ViewState["AppId"] = dr["AppId"].ToString();
                            string status = dr["Status"].ToString();
                            ViewState["ApplicationStatus"] = status;

                            Save_btn.Text = "Update Application";

                            if (status.Equals("Hired", StringComparison.OrdinalIgnoreCase) || status.Equals("Rejected", StringComparison.OrdinalIgnoreCase))
                            {
                                Save_btn.Enabled = false;
                                ShowMessage("This proposal has been " + status + " and can no longer be edited.", false);
                            }
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error checking existing application: " + ex.Message, false);
        }
    }

    protected void Save_btn_Click(object sender, EventArgs e)
    {
        string pidStr = Request.QueryString["pid"];
        if (string.IsNullOrEmpty(pidStr))
        {
            pidStr = Request.QueryString["id"];
        }
        int projectId;
        if (string.IsNullOrEmpty(pidStr) || !int.TryParse(pidStr, out projectId))
        {
            ShowMessage("Invalid project ID.", false);
            return;
        }

        string proposal = txtProposal.Text.Trim();
        string bidStr = txtBid.Text.Trim();
        string daysStr = txtDays.Text.Trim();

        if (string.IsNullOrEmpty(proposal) || string.IsNullOrEmpty(bidStr) || string.IsNullOrEmpty(daysStr))
        {
            ShowMessage("Please fill in all proposal, budget, and delivery timeline fields.", false);
            return;
        }

        decimal bidAmount;
        if (!decimal.TryParse(bidStr, out bidAmount) || bidAmount <= 0)
        {
            ShowMessage("Please enter a valid positive proposed budget.", false);
            return;
        }

        int deliveryDays;
        if (!int.TryParse(daysStr, out deliveryDays) || deliveryDays <= 0)
        {
            ShowMessage("Please enter a valid positive delivery days count.", false);
            return;
        }

        try
        {
            string email = Session["Email"].ToString();
            int studentId = GetStudentId(email);
            string projectTitle = ViewState["ProjectTitle"] != null ? ViewState["ProjectTitle"].ToString() : ("Project #" + projectId);
            int clientId = ViewState["ClientId"] != null ? Convert.ToInt32(ViewState["ClientId"]) : 0;
            string clientEmail = ViewState["ClientEmail"] != null ? ViewState["ClientEmail"].ToString() : "";

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();

                if (ViewState["AppId"] != null)
                {
                    int appId = Convert.ToInt32(ViewState["AppId"]);

                    // 1. UPDATE Applications_tbl
                    string updateAppQuery = @"
                        UPDATE Applications_tbl 
                        SET Proposal = @Proposal, BidAmount = @BidAmount, DeliveryDays = @DeliveryDays 
                        WHERE AppId = @AppId AND StudentEmail = @Email";

                    using (SqlCommand cmdApp = new SqlCommand(updateAppQuery, con))
                    {
                        cmdApp.Parameters.AddWithValue("@Proposal", proposal);
                        cmdApp.Parameters.AddWithValue("@BidAmount", bidAmount);
                        cmdApp.Parameters.AddWithValue("@DeliveryDays", deliveryDays);
                        cmdApp.Parameters.AddWithValue("@AppId", appId);
                        cmdApp.Parameters.AddWithValue("@Email", email);
                        cmdApp.ExecuteNonQuery();
                    }

                    // 2. UPDATE Bids_tbl if matching record exists
                    string updateBidQuery = @"
                        UPDATE Bids_tbl 
                        SET Proposal = @Proposal, BidAmount = @BidAmountStr 
                        WHERE ProjectId = @ProjectId AND (StudentEmail = @Email OR StudentId = @StudentId)";

                    using (SqlCommand cmdBid = new SqlCommand(updateBidQuery, con))
                    {
                        cmdBid.Parameters.AddWithValue("@Proposal", proposal);
                        cmdBid.Parameters.AddWithValue("@BidAmountStr", bidAmount.ToString("0.##"));
                        cmdBid.Parameters.AddWithValue("@ProjectId", projectId);
                        cmdBid.Parameters.AddWithValue("@Email", email);
                        cmdBid.Parameters.AddWithValue("@StudentId", studentId);
                        cmdBid.ExecuteNonQuery();
                    }

                    ShowMessage("Application updated successfully!", true);
                }
                else
                {
                    // 1. Check for duplicate application
                    string checkQuery = "SELECT COUNT(*) FROM Applications_tbl WHERE ProjectId = @ProjectId AND StudentEmail = @Email";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                    {
                        checkCmd.Parameters.AddWithValue("@ProjectId", projectId);
                        checkCmd.Parameters.AddWithValue("@Email", email);
                        int count = Convert.ToInt32(checkCmd.ExecuteScalar());
                        if (count > 0)
                        {
                            ShowMessage("You have already submitted an application for this project.", false);
                            return;
                        }
                    }

                    // 2. INSERT into Applications_tbl
                    string insertAppQuery = @"
                        INSERT INTO Applications_tbl (ProjectId, StudentEmail, Proposal, BidAmount, DeliveryDays, Status, AppliedDate) 
                        VALUES (@ProjectId, @Email, @Proposal, @BidAmount, @DeliveryDays, 'Pending', GETDATE());
                        SELECT SCOPE_IDENTITY();";

                    int newAppId = 0;
                    using (SqlCommand cmdApp = new SqlCommand(insertAppQuery, con))
                    {
                        cmdApp.Parameters.AddWithValue("@ProjectId", projectId);
                        cmdApp.Parameters.AddWithValue("@Email", email);
                        cmdApp.Parameters.AddWithValue("@Proposal", proposal);
                        cmdApp.Parameters.AddWithValue("@BidAmount", bidAmount);
                        cmdApp.Parameters.AddWithValue("@DeliveryDays", deliveryDays);
                        object res = cmdApp.ExecuteScalar();
                        if (res != null)
                        {
                            newAppId = Convert.ToInt32(res);
                        }
                    }

                    // 3. INSERT into Bids_tbl
                    string insertBidQuery = @"
                        INSERT INTO Bids_tbl (ProjectId, StudentId, BidAmount, Proposal, BidDate, Status, StudentEmail) 
                        VALUES (@ProjectId, @StudentId, @BidAmountStr, @Proposal, GETDATE(), 'Pending', @Email)";

                    using (SqlCommand cmdBid = new SqlCommand(insertBidQuery, con))
                    {
                        cmdBid.Parameters.AddWithValue("@ProjectId", projectId);
                        cmdBid.Parameters.AddWithValue("@StudentId", studentId);
                        cmdBid.Parameters.AddWithValue("@BidAmountStr", bidAmount.ToString("0.##"));
                        cmdBid.Parameters.AddWithValue("@Proposal", proposal);
                        cmdBid.Parameters.AddWithValue("@Email", email);
                        cmdBid.ExecuteNonQuery();
                    }

                    // 4. Log in ActivityLogs_tbl
                    try
                    {
                        string logQuery = "INSERT INTO ActivityLogs_tbl (UserId, Activity, ActivityDate) VALUES (@UserId, @Activity, GETDATE())";
                        using (SqlCommand cmdLog = new SqlCommand(logQuery, con))
                        {
                            cmdLog.Parameters.AddWithValue("@UserId", studentId);
                            cmdLog.Parameters.AddWithValue("@Activity", "Student applied for project: " + projectTitle);
                            cmdLog.ExecuteNonQuery();
                        }
                    }
                    catch { }

                    // 5. Notify Client in Notifications_tbl
                    try
                    {
                        if (!string.IsNullOrEmpty(clientEmail))
                        {
                            string notifQuery = "INSERT INTO Notifications_tbl (UserId, UserEmail, Message, CreatedDate, IsRead) VALUES (@UserId, @UserEmail, @Message, GETDATE(), 0)";
                            using (SqlCommand cmdNotif = new SqlCommand(notifQuery, con))
                            {
                                cmdNotif.Parameters.AddWithValue("@UserId", clientId);
                                cmdNotif.Parameters.AddWithValue("@UserEmail", clientEmail);
                                cmdNotif.Parameters.AddWithValue("@Message", "New proposal submitted by student for project: " + projectTitle);
                                cmdNotif.ExecuteNonQuery();
                            }
                        }
                    }
                    catch { }

                    ShowMessage("Application submitted successfully! Redirecting to your applications...", true);
                    Response.AddHeader("REFRESH", "1;URL=MyApplications.aspx");
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error submitting application: " + ex.Message, false);
        }
    }
}
