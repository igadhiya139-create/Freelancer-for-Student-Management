using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class ClientPanel_ApplicantProfile : System.Web.UI.Page
{
    string s = ConfigurationManager.ConnectionStrings["dbcon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["Email"] == null || Session["Role"] == null || Session["Role"].ToString() != "Client")
        {
            Response.Redirect("~/Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            string name = Session["UserName"] != null ? Session["UserName"].ToString() : 
                         (Session["admin"] != null ? Session["admin"].ToString() : "Client");
            lblSidebarName.Text = name + " · Client";

            LoadApplicant();
        }
    }

    void ShowMessage(string msg, bool isSuccess)
    {
        pnlMsg.Visible = true;
        lblMsg.Text = msg;
        if (isSuccess)
        {
            pnlMsg.Style["background"] = "rgba(52,211,153,0.15)";
            pnlMsg.Style["border"] = "1px solid rgba(52,211,153,0.3)";
            pnlMsg.Style["color"] = "#34d399";
        }
        else
        {
            pnlMsg.Style["background"] = "rgba(248,113,113,0.15)";
            pnlMsg.Style["border"] = "1px solid rgba(248,113,113,0.3)";
            pnlMsg.Style["color"] = "#f87171";
        }
    }

    int GetClientId(SqlConnection con, string email)
    {
        using (SqlCommand cmd = new SqlCommand("SELECT Id FROM Registration_tbl WHERE Email = @Email", con))
        {
            cmd.Parameters.AddWithValue("@Email", email);
            object res = cmd.ExecuteScalar();
            return res != null ? Convert.ToInt32(res) : 0;
        }
    }

    void LoadApplicant()
    {
        string appIdStr = Request.QueryString["appId"];
        int appId;
        if (string.IsNullOrEmpty(appIdStr) || !int.TryParse(appIdStr, out appId))
        {
            Response.Redirect("ViewApplicants.aspx");
            return;
        }

        string email = Session["Email"].ToString();

        using (SqlConnection con = new SqlConnection(s))
        {
            con.Open();
            int clientId = GetClientId(con, email);

            string query = "SELECT a.AppId, a.ProjectId, a.Proposal, a.BidAmount, a.DeliveryDays, " +
                           "       a.Status, a.StudentEmail, a.AppliedDate, " +
                           "       p.Title AS ProjectTitle, " +
                           "       ISNULL(r.Name, a.StudentEmail) AS Name, r.Email, r.Mobile, r.City " +
                           "FROM   Applications_tbl a " +
                           "INNER JOIN Projects_tbl     p ON p.ProjectId = a.ProjectId " +
                           "LEFT JOIN Registration_tbl r ON r.Email = a.StudentEmail " +
                           "WHERE  a.AppId = @AppId AND (p.ClientEmail = @Email OR p.ClientId = @ClientId)";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@AppId", appId);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@ClientId", clientId);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        string name = dr["Name"].ToString();
                        string status = dr["Status"].ToString();
                        string studentEmail = dr["StudentEmail"].ToString();

                        lblName.Text = name;
                        lblProjectTitle.Text = dr["ProjectTitle"].ToString();
                        lblEmail.Text = !string.IsNullOrEmpty(dr["Email"].ToString()) ? dr["Email"].ToString() : studentEmail;
                        lblMobile.Text = !string.IsNullOrEmpty(dr["Mobile"].ToString()) ? dr["Mobile"].ToString() : "N/A";
                        lblCity.Text = !string.IsNullOrEmpty(dr["City"].ToString()) ? dr["City"].ToString() : "N/A";
                        lblProposal.Text = dr["Proposal"].ToString();
                        lblBid.Text = Convert.ToDecimal(dr["BidAmount"]).ToString("N2");
                        lblDays.Text = dr["DeliveryDays"].ToString();
                        lblAppliedDate.Text = dr["AppliedDate"] != DBNull.Value ? Convert.ToDateTime(dr["AppliedDate"]).ToString("dd MMM yyyy, hh:mm tt") : "N/A";

                        lblStatusBadge.Text = status;
                        lblStatusBadge.CssClass = (status == "Hired")
                            ? "badge-status badge-hired"
                            : ((status == "Rejected") ? "badge-status badge-rejected" : "badge-status badge-pending");

                        string[] parts = name.Split(' ');
                        string initials = parts[0].Length > 0 ? parts[0].Substring(0, 1).ToUpper() : "ST";
                        if (parts.Length > 1 && parts[parts.Length - 1].Length > 0)
                            initials += parts[parts.Length - 1].Substring(0, 1).ToUpper();
                        lblInitials.Text = initials;

                        btnHire.Visible = (status == "Pending");
                        btnReject.Visible = (status == "Pending");

                        ViewState["AppId"] = appId;
                        ViewState["ProjectId"] = Convert.ToInt32(dr["ProjectId"]);
                        ViewState["StudentEmail"] = studentEmail;
                    }
                    else
                    {
                        Response.Redirect("ViewApplicants.aspx");
                        return;
                    }
                }
            }

            if (ViewState["StudentEmail"] != null)
            {
                LoadStudentSkills(con, ViewState["StudentEmail"].ToString());
            }
        }
    }

    void LoadStudentSkills(SqlConnection con, string studentEmail)
    {
        if (string.IsNullOrEmpty(studentEmail)) return;

        string query = "SELECT SkillName, SkillLevel FROM Skills_tbl WHERE StudentEmail = @Email ORDER BY SkillLevel DESC";
        using (SqlCommand cmd = new SqlCommand(query, con))
        {
            cmd.Parameters.AddWithValue("@Email", studentEmail);
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                if (dt.Rows.Count > 0)
                {
                    rptSkills.DataSource = dt;
                    rptSkills.DataBind();
                    lblNoSkills.Visible = false;
                }
                else
                {
                    rptSkills.DataSource = null;
                    rptSkills.DataBind();
                    lblNoSkills.Visible = true;
                }
            }
        }
    }

    protected void btnHire_Click(object sender, EventArgs e)
    {
        if (ViewState["AppId"] == null) return;

        int appId = Convert.ToInt32(ViewState["AppId"]);
        int projId = ViewState["ProjectId"] != null ? Convert.ToInt32(ViewState["ProjectId"]) : 0;
        string email = Session["Email"].ToString();

        using (SqlConnection con = new SqlConnection(s))
        {
            con.Open();
            int clientId = GetClientId(con, email);

            string updateQuery = "UPDATE a SET a.Status = 'Hired' FROM Applications_tbl a " +
                                 "INNER JOIN Projects_tbl p ON a.ProjectId = p.ProjectId " +
                                 "WHERE a.AppId = @AppId AND (p.ClientEmail = @Email OR p.ClientId = @ClientId)";

            using (SqlCommand cmd = new SqlCommand(updateQuery, con))
            {
                cmd.Parameters.AddWithValue("@AppId", appId);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@ClientId", clientId);
                int rows = cmd.ExecuteNonQuery();

                if (rows > 0)
                {
                    if (projId > 0)
                    {
                        using (SqlCommand projCmd = new SqlCommand("UPDATE Projects_tbl SET Status = 'In Progress' WHERE ProjectId = @ProjectId AND Status = 'Open'", con))
                        {
                            projCmd.Parameters.AddWithValue("@ProjectId", projId);
                            projCmd.ExecuteNonQuery();
                        }
                    }

                  
                    try
                    {
                        string logQuery = "INSERT INTO ActivityLogs_tbl (UserId, Activity, ActivityDate) VALUES (@UserId, @Activity, GETDATE())";
                        using (SqlCommand logCmd = new SqlCommand(logQuery, con))
                        {
                            logCmd.Parameters.AddWithValue("@UserId", clientId);
                            logCmd.Parameters.AddWithValue("@Activity", "Client hired applicant for Application #" + appId);
                            logCmd.ExecuteNonQuery();
                        }
                    }
                    catch { }

                   
                    try
                    {
                        string studentEmail = ViewState["StudentEmail"] != null ? ViewState["StudentEmail"].ToString() : "";
                        if (!string.IsNullOrEmpty(studentEmail))
                        {
                            using (SqlCommand notifCmd = new SqlCommand("INSERT INTO Notifications_tbl (UserEmail, Message, CreatedDate, IsRead) VALUES (@UserEmail, @Message, GETDATE(), 0)", con))
                            {
                                notifCmd.Parameters.AddWithValue("@UserEmail", studentEmail);
                                notifCmd.Parameters.AddWithValue("@Message", "Congratulations! You have been hired for project: " + lblProjectTitle.Text);
                                notifCmd.ExecuteNonQuery();
                            }
                        }
                    }
                    catch { }

                    ShowMessage("Student was hired successfully!", true);
                }
                else
                {
                    ShowMessage("Unauthorized: Could not update application.", false);
                }
            }
        }

        LoadApplicant();
    }

    protected void btnReject_Click(object sender, EventArgs e)
    {
        if (ViewState["AppId"] == null) return;

        int appId = Convert.ToInt32(ViewState["AppId"]);
        string email = Session["Email"].ToString();

        using (SqlConnection con = new SqlConnection(s))
        {
            con.Open();
            int clientId = GetClientId(con, email);

            string updateQuery = "UPDATE a SET a.Status = 'Rejected' FROM Applications_tbl a " +
                                 "INNER JOIN Projects_tbl p ON a.ProjectId = p.ProjectId " +
                                 "WHERE a.AppId = @AppId AND (p.ClientEmail = @Email OR p.ClientId = @ClientId)";

            using (SqlCommand cmd = new SqlCommand(updateQuery, con))
            {
                cmd.Parameters.AddWithValue("@AppId", appId);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@ClientId", clientId);
                int rows = cmd.ExecuteNonQuery();

                if (rows > 0)
                {
                    
                    try
                    {
                        string studentEmail = ViewState["StudentEmail"] != null ? ViewState["StudentEmail"].ToString() : "";
                        if (!string.IsNullOrEmpty(studentEmail))
                        {
                            using (SqlCommand notifCmd = new SqlCommand("INSERT INTO Notifications_tbl (UserEmail, Message, CreatedDate, IsRead) VALUES (@UserEmail, @Message, GETDATE(), 0)", con))
                            {
                                notifCmd.Parameters.AddWithValue("@UserEmail", studentEmail);
                                notifCmd.Parameters.AddWithValue("@Message", "Your application for project '" + lblProjectTitle.Text + "' was declined.");
                                notifCmd.ExecuteNonQuery();
                            }
                        }
                    }
                    catch { }

                    ShowMessage("Proposal was rejected.", true);
                }
                else
                {
                    ShowMessage("Unauthorized: Could not update application.", false);
                }
            }
        }

        LoadApplicant();
    }
}
