using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class StudentPanel_BrowseProjects : System.Web.UI.Page
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

        string name = Session["UserName"] != null ? Session["UserName"].ToString() : 
                     (Session["Name"] != null ? Session["Name"].ToString() : "Student");
        lblSidebarName.Text = name + " · Student";

        if (!IsPostBack)
        {
            LoadCategories();
            LoadProjects();
        }
    }

    private void LoadCategories()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT CategoryName FROM Categories_tbl WHERE Status = 'Active' ORDER BY CategoryName ASC", con))
                {
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        ddlCategory.Items.Clear();
                        ddlCategory.Items.Add(new ListItem("All Categories", ""));
                        while (dr.Read())
                        {
                            string cat = dr["CategoryName"].ToString();
                            ddlCategory.Items.Add(new ListItem(cat, cat));
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading categories: " + ex.Message, false);
        }
    }

    private void LoadProjects()
    {
        try
        {
            string search = txtSearch.Text.Trim();
            string category = ddlCategory.SelectedValue;

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();

                string query = @"
                    SELECT 
                        p.ProjectId, 
                        p.Title, 
                        p.Description, 
                        p.Budget, 
                        p.Skills, 
                        p.Category, 
                        p.PostedDate, 
                        ISNULL(p.Status, 'Open') AS Status
                    FROM Projects_tbl p
                    WHERE (LOWER(ISNULL(p.Status, 'open')) = 'open' OR LOWER(p.Status) = 'in progress')";

                if (!string.IsNullOrEmpty(search))
                {
                    query += " AND (p.Title LIKE @Search OR p.Skills LIKE @Search OR p.Description LIKE @Search)";
                }

                if (!string.IsNullOrEmpty(category))
                {
                    query += " AND p.Category = @Category";
                }

                query += " ORDER BY p.PostedDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (!string.IsNullOrEmpty(search))
                    {
                        cmd.Parameters.AddWithValue("@Search", "%" + search + "%");
                    }
                    if (!string.IsNullOrEmpty(category))
                    {
                        cmd.Parameters.AddWithValue("@Category", category);
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptProjects.DataSource = dt;
                            rptProjects.DataBind();
                            rptProjects.Visible = true;
                            pnlNoProjects.Visible = false;
                        }
                        else
                        {
                            rptProjects.Visible = false;
                            pnlNoProjects.Visible = true;
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading projects: " + ex.Message, false);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadProjects();
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        txtSearch.Text = string.Empty;
        if (ddlCategory.Items.Count > 0)
        {
            ddlCategory.SelectedIndex = 0;
        }
        LoadProjects();
    }
}
