using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class ClientPanel_ClientProfile : System.Web.UI.Page
{
    private string GetConnectionString()
    {
        return ConfigurationManager.ConnectionStrings["dbcon"].ConnectionString;
    }

    private void LoadProfile()
    {
        try
        {
            string email = Session["Email"].ToString();

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                string query = "SELECT Name, Email, City, Mobile, Address, Gender " +
                               "FROM Registration_tbl " +
                               "WHERE Email = @Email";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            DataRow row = dt.Rows[0];
                            string name = row["Name"] != DBNull.Value ? row["Name"].ToString() : "Client";
                            string city = row["City"] != DBNull.Value ? row["City"].ToString() : "Not specified";

                            lblName.Text = name;
                            lblEmail.Text = row["Email"] != DBNull.Value ? row["Email"].ToString() : email;
                            lblMobile.Text = row["Mobile"] != DBNull.Value && !string.IsNullOrWhiteSpace(row["Mobile"].ToString()) ? row["Mobile"].ToString() : "Not specified";
                            lblCity.Text = city;
                            lblCityDup.Text = city;
                            lblGender.Text = row["Gender"] != DBNull.Value && !string.IsNullOrWhiteSpace(row["Gender"].ToString()) ? row["Gender"].ToString() : "Not specified";
                            lblAddress.Text = row["Address"] != DBNull.Value && !string.IsNullOrWhiteSpace(row["Address"].ToString()) ? row["Address"].ToString() : "Not specified";
                            lblSidebarName.Text = name + " · Client";

                            lblInitials.Text = name.Length > 0 ? name.Substring(0, 1).ToUpper() : "C";
                        }
                    }
                }
            }
        }
        catch (Exception)
        {

        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["Email"] == null || Session["Role"] == null || Session["Role"].ToString() != "Client")
        {
            Response.Redirect("~/Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadProfile();
        }
    }
}
