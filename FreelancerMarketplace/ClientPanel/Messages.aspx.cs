using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ClientPanel_Messages : System.Web.UI.Page
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

            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                int myId = GetClientId(con, Session["Email"].ToString());
                ViewState["MyClientId"] = myId;
            }

            LoadContacts();
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

    void LoadContacts()
    {
        string email = Session["Email"].ToString();
        int myId = ViewState["MyClientId"] != null ? Convert.ToInt32(ViewState["MyClientId"]) : 0;

        using (SqlConnection con = new SqlConnection(s))
        {
            con.Open();

            string query = "SELECT DISTINCT r.Id, r.Name, r.Email FROM Registration_tbl r " +
                           "WHERE r.Role = 'Student' AND (" +
                           "r.Email IN (SELECT a.StudentEmail FROM Applications_tbl a INNER JOIN Projects_tbl p ON a.ProjectId = p.ProjectId WHERE p.ClientEmail = @Email OR p.ClientId = @ClientId) " +
                           "OR r.Id IN (SELECT SenderId FROM Messages_tbl WHERE ReceiverId = @ClientId) " +
                           "OR r.Id IN (SELECT ReceiverId FROM Messages_tbl WHERE SenderId = @ClientId)) " +
                           "ORDER BY r.Name ASC";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@ClientId", myId);

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        rptContacts.DataSource = dt;
                        rptContacts.DataBind();
                        rptContacts.Visible = true;
                        pnlNoContacts.Visible = false;

                        if (ViewState["SelectedContactId"] == null)
                        {
                            ViewState["SelectedContactId"] = Convert.ToInt32(dt.Rows[0]["Id"]);
                            lblChatContactName.Text = dt.Rows[0]["Name"].ToString();
                            LoadConversation(Convert.ToInt32(dt.Rows[0]["Id"]));
                        }
                    }
                    else
                    {
                        rptContacts.Visible = false;
                        pnlNoContacts.Visible = true;
                        pnlNoMessages.Visible = true;
                    }
                }
            }
        }
    }

    void LoadConversation(int contactId)
    {
        int myId = ViewState["MyClientId"] != null ? Convert.ToInt32(ViewState["MyClientId"]) : 0;

        using (SqlConnection con = new SqlConnection(s))
        {
            con.Open();

            string query = "SELECT MessageId, SenderId, ReceiverId, Message, SentDate, Status " +
                           "FROM Messages_tbl " +
                           "WHERE (SenderId = @MyId AND ReceiverId = @ContactId) OR (SenderId = @ContactId AND ReceiverId = @MyId) " +
                           "ORDER BY SentDate ASC";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@MyId", myId);
                cmd.Parameters.AddWithValue("@ContactId", contactId);

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        rptMessages.DataSource = dt;
                        rptMessages.DataBind();
                        rptMessages.Visible = true;
                        pnlNoMessages.Visible = false;
                    }
                    else
                    {
                        rptMessages.Visible = false;
                        pnlNoMessages.Visible = true;
                    }
                }
            }
        }
    }

    protected void rptContacts_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "SelectContact")
        {
            int contactId = Convert.ToInt32(e.CommandArgument);
            ViewState["SelectedContactId"] = contactId;

            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT Name FROM Registration_tbl WHERE Id = @Id", con))
                {
                    cmd.Parameters.AddWithValue("@Id", contactId);
                    object res = cmd.ExecuteScalar();
                    if (res != null) lblChatContactName.Text = res.ToString();
                }
            }

            pnlMsg.Visible = false;
            LoadConversation(contactId);
        }
    }

    protected void btnSendMessage_Click(object sender, EventArgs e)
    {
        string msg = txtMessage.Text.Trim();
        if (string.IsNullOrEmpty(msg)) return;

        if (ViewState["SelectedContactId"] == null)
        {
            ShowMessage("Please select a student contact to send a message.", false);
            return;
        }

        int receiverId = Convert.ToInt32(ViewState["SelectedContactId"]);
        int senderId = ViewState["MyClientId"] != null ? Convert.ToInt32(ViewState["MyClientId"]) : 0;

        using (SqlConnection con = new SqlConnection(s))
        {
            con.Open();
            string insertQuery = "INSERT INTO Messages_tbl (SenderId, ReceiverId, Message, SentDate, Status) " +
                                 "VALUES (@SenderId, @ReceiverId, @Message, GETDATE(), 'Unread')";

            using (SqlCommand cmd = new SqlCommand(insertQuery, con))
            {
                cmd.Parameters.AddWithValue("@SenderId", senderId);
                cmd.Parameters.AddWithValue("@ReceiverId", receiverId);
                cmd.Parameters.AddWithValue("@Message", msg);
                cmd.ExecuteNonQuery();
            }

            txtMessage.Text = string.Empty;
        }

        LoadConversation(receiverId);
    }
}
