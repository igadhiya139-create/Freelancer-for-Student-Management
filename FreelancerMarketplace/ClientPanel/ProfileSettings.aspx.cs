using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class ClientPanel_ProfileSettings : System.Web.UI.Page
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

    private void FillData()
    {
        try
        {
            string email = Session["Email"].ToString();

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                string query = "SELECT Name, Email, Gender, City, Mobile, Address " +
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
                            string name = row["Name"] != DBNull.Value ? row["Name"].ToString() : "";
                            string city = row["City"] != DBNull.Value ? row["City"].ToString() : "";
                            string gender = row["Gender"] != DBNull.Value ? row["Gender"].ToString() : "";

                            txtName.Text = name;
                            txtEmail.Text = row["Email"] != DBNull.Value ? row["Email"].ToString() : email;
                            txtMobile.Text = row["Mobile"] != DBNull.Value ? row["Mobile"].ToString() : "";
                            txtAddress.Text = row["Address"] != DBNull.Value ? row["Address"].ToString() : "";

                            if (drpCity.Items.FindByValue(city) != null)
                            {
                                drpCity.SelectedValue = city;
                            }

                            if (rdoGender.Items.FindByValue(gender) != null)
                            {
                                rdoGender.SelectedValue = gender;
                            }

                            lblSidebarName.Text = (string.IsNullOrEmpty(name) ? "Client" : name) + " · Client";
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error loading profile details: " + ex.Message, false);
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
            FillData();
        }
    }

    protected void Save_btn_Click(object sender, EventArgs e)
    {
        string name = txtName.Text.Trim();
        if (string.IsNullOrEmpty(name))
        {
            ShowMessage("Name cannot be empty.", false);
            return;
        }

        try
        {
            string email = Session["Email"].ToString();

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                string query = "UPDATE Registration_tbl SET " +
                               "Name = @Name, " +
                               "Gender = @Gender, " +
                               "City = @City, " +
                               "Mobile = @Mobile, " +
                               "Address = @Address " +
                               "WHERE Email = @Email";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Gender", string.IsNullOrEmpty(rdoGender.SelectedValue) ? (object)DBNull.Value : rdoGender.SelectedValue);
                    cmd.Parameters.AddWithValue("@City", string.IsNullOrEmpty(drpCity.SelectedValue) ? (object)DBNull.Value : drpCity.SelectedValue);
                    cmd.Parameters.AddWithValue("@Mobile", txtMobile.Text.Trim());
                    cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", email);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            Session["Name"] = name;
            lblSidebarName.Text = name + " · Client";

            ShowMessage("Profile updated successfully!", true);
        }
        catch (Exception ex)
        {
            ShowMessage("Error saving profile: " + ex.Message, false);
        }
    }
}
