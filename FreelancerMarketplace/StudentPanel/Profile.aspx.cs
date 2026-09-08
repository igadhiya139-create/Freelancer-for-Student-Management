using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class StudentPanel_Profile : System.Web.UI.Page
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

        if (!IsPostBack)
        {
            LoadProfile();
        }
    }

    private void LoadProfile()
    {
        try
        {
            string email = Session["Email"].ToString();

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();
                string query = "SELECT Name, Email, Gender, City, Mobile, Address FROM Registration_tbl WHERE Email = @Email";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            string name = dr["Name"] != DBNull.Value ? dr["Name"].ToString() : "Student";
                            lblName.Text = name;
                            lblEmail.Text = dr["Email"] != DBNull.Value ? dr["Email"].ToString() : email;
                            lblGender.Text = dr["Gender"] != DBNull.Value && !string.IsNullOrWhiteSpace(dr["Gender"].ToString()) ? dr["Gender"].ToString() : "Not specified";
                            lblMobile.Text = dr["Mobile"] != DBNull.Value && !string.IsNullOrWhiteSpace(dr["Mobile"].ToString()) ? dr["Mobile"].ToString() : "Not specified";
                            lblAddress.Text = dr["Address"] != DBNull.Value && !string.IsNullOrWhiteSpace(dr["Address"].ToString()) ? dr["Address"].ToString() : "Not specified";
                            lblCity.Text = dr["City"] != DBNull.Value && !string.IsNullOrWhiteSpace(dr["City"].ToString()) ? dr["City"].ToString() : "Not specified";
                            lblSidebarName.Text = name + " · Student";

                            // Avatar Initials
                            string[] parts = name.Trim().Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                            string initials = "ST";
                            if (parts.Length > 0 && parts[0].Length > 0)
                            {
                                initials = parts[0].Substring(0, 1).ToUpper();
                                if (parts.Length > 1 && parts[parts.Length - 1].Length > 0)
                                {
                                    initials += parts[parts.Length - 1].Substring(0, 1).ToUpper();
                                }
                            }
                            lblInitials.Text = initials;
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading profile: " + ex.Message, false);
        }
    }
}
