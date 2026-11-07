using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AdminPanel_ManageClients : System.Web.UI.Page
{
    string s = ConfigurationManager.ConnectionStrings["dbcon"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {

        if (Session["admin"] == null || Session["Role"] == null || Session["Role"].ToString() != "Admin")
        {
            Response.Redirect("~/Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            string adminName = Session["UserName"] != null ? Session["UserName"].ToString() :
                               (Session["admin"] != null ? Session["admin"].ToString() : "Admin");
            lblSidebarName.Text = adminName + " · Admin";
            LoadClients();
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

    void LogActivity(string activity)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                string query = "INSERT INTO ActivityLogs_tbl (UserId, Activity, ActivityDate) VALUES (@UserId, @Activity, GETDATE())";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserId", 0);
                    cmd.Parameters.AddWithValue("@Activity", activity);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        catch { }
    }

    void LoadClients()
    {
        string search = txtSearch.Text.Trim();

        using (SqlConnection con = new SqlConnection(s))
        {
            string query = "SELECT Id, Name, Gender, Email, City, Mobile, CreatedDate FROM Registration_tbl WHERE Role='Client'";
            if (!string.IsNullOrEmpty(search))
            {
                query += " AND (Name LIKE @Search OR Email LIKE @Search OR City LIKE @Search)";
            }
            query += " ORDER BY Id DESC";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                if (!string.IsNullOrEmpty(search))
                {
                    cmd.Parameters.AddWithValue("@Search", "%" + search + "%");
                }

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    lblClientCount.Text = dt.Rows.Count.ToString();

                    if (dt.Rows.Count > 0)
                    {
                        rptClients.DataSource = dt;
                        rptClients.DataBind();
                        rptClients.Visible = true;
                        pnlNoData.Visible = false;
                    }
                    else
                    {
                        rptClients.Visible = false;
                        pnlNoData.Visible = true;
                    }
                }
            }
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        pnlMsg.Visible = false;
        LoadClients();
    }

    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        txtSearch.Text = string.Empty;
        pnlMsg.Visible = false;
        pnlClientDetails.Visible = false;
        LoadClients();
    }

    protected void btnCloseDetails_Click(object sender, EventArgs e)
    {
        pnlClientDetails.Visible = false;
    }

    protected void rptClients_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int clientId = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "ViewClient")
        {
            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                string query = "SELECT Id, Name, Gender, Email, City, Address, Mobile, CreatedDate FROM Registration_tbl WHERE Id = @Id";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Id", clientId);
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblDetId.Text = "#" + dr["Id"].ToString();
                            lblDetName.Text = dr["Name"].ToString();
                            lblDetFullName.Text = dr["Name"].ToString();
                            lblDetEmail.Text = dr["Email"].ToString();
                            lblDetGender.Text = string.IsNullOrEmpty(dr["Gender"].ToString()) ? "Not specified" : dr["Gender"].ToString();
                            lblDetCity.Text = string.IsNullOrEmpty(dr["City"].ToString()) ? "N/A" : dr["City"].ToString();
                            lblDetMobile.Text = string.IsNullOrEmpty(dr["Mobile"].ToString()) ? "N/A" : dr["Mobile"].ToString();
                            lblDetAddress.Text = string.IsNullOrEmpty(dr["Address"].ToString()) ? "N/A" : dr["Address"].ToString();
                            lblDetDate.Text = dr["CreatedDate"] != DBNull.Value ? Convert.ToDateTime(dr["CreatedDate"]).ToString("dd MMM yyyy, hh:mm tt") : "N/A";

                            pnlClientDetails.Visible = true;
                        }
                    }
                }
            }
        }
        else if (e.CommandName == "DeleteClient")
        {
            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();

                string checkQuery = "SELECT Email, Name FROM Registration_tbl WHERE Id = @Id";
                string targetEmail = "";
                string targetName = "";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                {
                    checkCmd.Parameters.AddWithValue("@Id", clientId);
                    using (SqlDataReader dr = checkCmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            targetEmail = dr["Email"].ToString();
                            targetName = dr["Name"].ToString();
                        }
                    }
                }

                if (string.IsNullOrEmpty(targetEmail))
                {
                    ShowMessage("Client record not found.", false);
                    return;
                }

                try
                {
                    using (SqlCommand delCmd = new SqlCommand("DELETE FROM Projects_tbl WHERE ClientEmail = @Email OR ClientId = @Id", con))
                    {
                        delCmd.Parameters.AddWithValue("@Email", targetEmail);
                        delCmd.Parameters.AddWithValue("@Id", clientId);
                        delCmd.ExecuteNonQuery();
                    }
                }
                catch { }

                using (SqlCommand delCmd = new SqlCommand("DELETE FROM Registration_tbl WHERE Id = @Id", con))
                {
                    delCmd.Parameters.AddWithValue("@Id", clientId);
                    int rows = delCmd.ExecuteNonQuery();
                    if (rows > 0)
                    {
                        LogActivity("Admin deleted client: " + targetName + " (" + targetEmail + ")");
                        ShowMessage("Client '" + targetName + "' was successfully removed.", true);
                    }
                    else
                    {
                        ShowMessage("Could not delete client record.", false);
                    }
                }
            }

            pnlClientDetails.Visible = false;
            LoadClients();
        }
    }
}
