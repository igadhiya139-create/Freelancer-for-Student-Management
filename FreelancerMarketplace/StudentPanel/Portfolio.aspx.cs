using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class StudentPanel_Portfolio : System.Web.UI.Page
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
            LoadPortfolio();
        }
    }

    private void LoadPortfolio()
    {
        try
        {
            string email = Session["Email"].ToString();

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();
                string query = "SELECT PortfolioId, StudentId, Title, Description, ProjectLink, CreatedDate, StudentEmail FROM Portfolio_tbl WHERE StudentEmail = @Email ORDER BY CreatedDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptPortfolio.DataSource = dt;
                            rptPortfolio.DataBind();
                            rptPortfolio.Visible = true;
                            pnlNoPortfolio.Visible = false;
                        }
                        else
                        {
                            rptPortfolio.Visible = false;
                            pnlNoPortfolio.Visible = true;
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading portfolio: " + ex.Message, false);
        }
    }

    protected void btnAddPortfolio_Click(object sender, EventArgs e)
    {
        string title = txtPortfolioTitle.Text.Trim();
        string link = txtPortfolioLink.Text.Trim();
        string desc = txtPortfolioDesc.Text.Trim();

        if (string.IsNullOrEmpty(title))
        {
            ShowMessage("Please enter a project title.", false);
            return;
        }

        try
        {
            string email = Session["Email"].ToString();
            int studentId = GetStudentId(email);

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();
                string query = @"
                    INSERT INTO Portfolio_tbl (StudentId, Title, Description, ProjectLink, CreatedDate, StudentEmail)
                    VALUES (@StudentId, @Title, @Description, @ProjectLink, GETDATE(), @Email)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(desc) ? (object)DBNull.Value : desc);
                    cmd.Parameters.AddWithValue("@ProjectLink", string.IsNullOrEmpty(link) ? (object)DBNull.Value : link);
                    cmd.Parameters.AddWithValue("@Email", email);

                    cmd.ExecuteNonQuery();
                }
            }

            txtPortfolioTitle.Text = string.Empty;
            txtPortfolioLink.Text = string.Empty;
            txtPortfolioDesc.Text = string.Empty;

            ShowMessage("Portfolio project '" + title + "' added successfully!", true);
            LoadPortfolio();
        }
        catch (Exception ex)
        {
            ShowMessage("Error adding portfolio project: " + ex.Message, false);
        }
    }

    protected void rptPortfolio_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "cmd_del")
        {
            int portfolioId;
            if (!int.TryParse(e.CommandArgument.ToString(), out portfolioId))
            {
                ShowMessage("Invalid portfolio ID.", false);
                return;
            }

            try
            {
                string email = Session["Email"].ToString();

                using (SqlConnection con = new SqlConnection(GetConnectionString()))
                {
                    con.Open();
                    string query = "DELETE FROM Portfolio_tbl WHERE PortfolioId = @PortfolioId AND StudentEmail = @Email";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@PortfolioId", portfolioId);
                        cmd.Parameters.AddWithValue("@Email", email);
                        int rows = cmd.ExecuteNonQuery();
                        if (rows > 0)
                        {
                            ShowMessage("Portfolio item removed successfully.", true);
                        }
                    }
                }

                LoadPortfolio();
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting portfolio project: " + ex.Message, false);
            }
        }
    }
}
