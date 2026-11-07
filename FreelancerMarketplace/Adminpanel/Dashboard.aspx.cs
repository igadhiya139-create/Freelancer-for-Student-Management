using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class AdminPanel_Dashboard : System.Web.UI.Page
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
            string name = Session["UserName"] != null ? Session["UserName"].ToString() :
                         (Session["admin"] != null ? Session["admin"].ToString() : "Admin");
            lblWelcomeName.Text = name;
            lblSidebarName.Text = name + " · Admin";

            LoadStats();
            LoadRecentUsers();
        }
    }

    void LoadStats()
    {
        using (SqlConnection con = new SqlConnection(s))
        {
            con.Open();
            SqlCommand cmd;

            cmd = new SqlCommand("SELECT COUNT(*) FROM Registration_tbl", con);
            lblUsers.Text = cmd.ExecuteScalar().ToString();

            cmd = new SqlCommand("SELECT COUNT(*) FROM Registration_tbl WHERE Role='Student'", con);
            lblStudents.Text = cmd.ExecuteScalar().ToString();

            cmd = new SqlCommand("SELECT COUNT(*) FROM Registration_tbl WHERE Role='Client'", con);
            lblClients.Text = cmd.ExecuteScalar().ToString();

            try
            {
                cmd = new SqlCommand("SELECT COUNT(*) FROM Projects_tbl", con);
                lblProjects.Text = cmd.ExecuteScalar().ToString();
            }
            catch { lblProjects.Text = "0"; }

            try
            {
                cmd = new SqlCommand("SELECT COUNT(*) FROM Projects_tbl WHERE Status='Open'", con);
                lblOpenProjects.Text = cmd.ExecuteScalar().ToString();
            }
            catch { lblOpenProjects.Text = "0"; }

            try
            {
                cmd = new SqlCommand("SELECT COUNT(*) FROM Projects_tbl WHERE Status='In Progress'", con);
                lblInProgressProjects.Text = cmd.ExecuteScalar().ToString();
            }
            catch { lblInProgressProjects.Text = "0"; }

            try
            {
                cmd = new SqlCommand("SELECT COUNT(*) FROM Projects_tbl WHERE Status='Completed'", con);
                lblCompletedProjects.Text = cmd.ExecuteScalar().ToString();
            }
            catch { lblCompletedProjects.Text = "0"; }

            try
            {
                cmd = new SqlCommand("SELECT COUNT(*) FROM Categories_tbl", con);
                lblTotalCategories.Text = cmd.ExecuteScalar().ToString();
            }
            catch { lblTotalCategories.Text = "0"; }

            try
            {
                cmd = new SqlCommand("SELECT (SELECT COUNT(*) FROM Applications_tbl) + (SELECT COUNT(*) FROM Bids_tbl)", con);
                lblApplications.Text = cmd.ExecuteScalar().ToString();
            }
            catch
            {
                try
                {
                    cmd = new SqlCommand("SELECT COUNT(*) FROM Applications_tbl", con);
                    lblApplications.Text = cmd.ExecuteScalar().ToString();
                }
                catch { lblApplications.Text = "0"; }
            }

            try
            {
                cmd = new SqlCommand("SELECT ISNULL(SUM(Amount),0) FROM Payments_tbl WHERE Status='Completed'", con);
                lblRevenue.Text = "$" + Convert.ToDecimal(cmd.ExecuteScalar()).ToString("N0");
            }
            catch { lblRevenue.Text = "$0"; }
        }
    }

    void LoadRecentUsers()
    {
        using (SqlConnection con = new SqlConnection(s))
        {
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT TOP 5 Name, Role, Email FROM Registration_tbl ORDER BY Id DESC", con))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptRecentUsers.DataSource = dt;
                rptRecentUsers.DataBind();
            }
        }
    }
}
