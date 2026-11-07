using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AdminPanel_ActivityLogs : System.Web.UI.Page
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
            LoadLogs();
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

    void LoadLogs()
    {
        string search = txtSearch.Text.Trim();

        using (SqlConnection con = new SqlConnection(s))
        {
            string query = "SELECT LogId, UserId, Activity, ActivityDate FROM ActivityLogs_tbl WHERE 1=1";
            if (!string.IsNullOrEmpty(search))
            {
                query += " AND Activity LIKE @Search";
            }
            query += " ORDER BY LogId DESC";

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
                    lblLogCount.Text = dt.Rows.Count.ToString();

                    if (dt.Rows.Count > 0)
                    {
                        rptLogs.DataSource = dt;
                        rptLogs.DataBind();
                        rptLogs.Visible = true;
                        pnlNoData.Visible = false;
                    }
                    else
                    {
                        rptLogs.Visible = false;
                        pnlNoData.Visible = true;
                    }
                }
            }
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        pnlMsg.Visible = false;
        LoadLogs();
    }

    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        txtSearch.Text = string.Empty;
        pnlMsg.Visible = false;
        LoadLogs();
    }

    protected void btnClearLogs_Click(object sender, EventArgs e)
    {
        using (SqlConnection con = new SqlConnection(s))
        {
            con.Open();
            using (SqlCommand cmd = new SqlCommand("DELETE FROM ActivityLogs_tbl", con))
            {
                cmd.ExecuteNonQuery();
            }
        }

        ShowMessage("All activity logs have been cleared.", true);
        LoadLogs();
    }

    protected void rptLogs_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "DeleteLog")
        {
            int logId = Convert.ToInt32(e.CommandArgument);
            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("DELETE FROM ActivityLogs_tbl WHERE LogId = @Id", con))
                {
                    cmd.Parameters.AddWithValue("@Id", logId);
                    cmd.ExecuteNonQuery();
                }
            }

            ShowMessage("Log entry #" + logId + " deleted.", true);
            LoadLogs();
        }
    }
}
