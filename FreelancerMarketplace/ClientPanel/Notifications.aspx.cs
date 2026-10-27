using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class ClientPanel_Notifications : System.Web.UI.Page
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
            pnlMsg.Style["background"] = "rgba(16, 185, 129, 0.15)";
            pnlMsg.Style["border"] = "1px solid #10b981";
            pnlMsg.Style["color"] = "#34d399";
        }
        else
        {
            pnlMsg.Style["background"] = "rgba(239, 68, 68, 0.15)";
            pnlMsg.Style["border"] = "1px solid #ef4444";
            pnlMsg.Style["color"] = "#f87171";
        }
    }

    private int GetClientId(string email)
    {
        using (SqlConnection con = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT Id FROM Registration_tbl WHERE Email = @Email", con))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                con.Open();
                object val = cmd.ExecuteScalar();
                int id;
                if (val != null && int.TryParse(val.ToString(), out id))
                {
                    return id;
                }
            }
        }
        return 0;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["Email"] == null || Session["Role"] == null || Session["Role"].ToString() != "Client")
        {
            Response.Redirect("~/Login.aspx");
            return;
        }

        string email = Session["Email"].ToString();
        string clientName = Session["Name"] != null ? Session["Name"].ToString() : "Client";
        lblSidebarName.Text = clientName + " · Client";

        if (!IsPostBack)
        {
            LoadNotifications();
        }
    }

    private void LoadNotifications()
    {
        try
        {
            string email = Session["Email"].ToString();
            int clientId = GetClientId(email);

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                string query = "SELECT NotificationId, UserId, Message, CreatedDate, IsRead, UserEmail " +
                               "FROM Notifications_tbl " +
                               "WHERE (UserEmail = @Email OR (UserId = @ClientId AND @ClientId > 0)) " +
                               "ORDER BY CreatedDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@ClientId", clientId);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptNotifications.DataSource = dt;
                            rptNotifications.DataBind();
                            rptNotifications.Visible = true;
                            pnlNoNotif.Visible = false;
                        }
                        else
                        {
                            rptNotifications.Visible = false;
                            pnlNoNotif.Visible = true;
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading notifications: " + ex.Message, false);
        }
    }

    protected void btnMarkAllRead_Click(object sender, EventArgs e)
    {
        try
        {
            string email = Session["Email"].ToString();
            int clientId = GetClientId(email);

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                string query = "UPDATE Notifications_tbl SET IsRead = 1 " +
                               "WHERE (UserEmail = @Email OR (UserId = @ClientId AND @ClientId > 0))";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@ClientId", clientId);

                    con.Open();
                    int affected = cmd.ExecuteNonQuery();
                    ShowMessage(affected > 0 ? "All notifications marked as read." : "No unread notifications to mark.", true);
                }
            }

            LoadNotifications();
        }
        catch (Exception ex)
        {
            ShowMessage("Error updating notifications: " + ex.Message, false);
        }
    }
}
