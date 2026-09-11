using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class StudentPanel_ProfileSettings : System.Web.UI.Page
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
            FillStudentProfile();
        }
    }

    private void FillStudentProfile()
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
                            string name = dr["Name"] != DBNull.Value ? dr["Name"].ToString() : "";
                            string city = dr["City"] != DBNull.Value ? dr["City"].ToString() : "";
                            string gender = dr["Gender"] != DBNull.Value ? dr["Gender"].ToString() : "";

                            txtName.Text = name;
                            txtEmail.Text = dr["Email"] != DBNull.Value ? dr["Email"].ToString() : email;
                            txtMobile.Text = dr["Mobile"] != DBNull.Value ? dr["Mobile"].ToString() : "";
                            txtAddress.Text = dr["Address"] != DBNull.Value ? dr["Address"].ToString() : "";

                            if (drpCity.Items.FindByValue(city) != null)
                            {
                                drpCity.SelectedValue = city;
                            }
                            else if (!string.IsNullOrEmpty(city))
                            {
                                drpCity.Items.Add(new System.Web.UI.WebControls.ListItem(city, city));
                                drpCity.SelectedValue = city;
                            }

                            if (rdoGender.Items.FindByValue(gender) != null)
                            {
                                rdoGender.SelectedValue = gender;
                            }

                            lblSidebarName.Text = (string.IsNullOrEmpty(name) ? "Student" : name) + " · Student";
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

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string name = txtName.Text.Trim();
        if (string.IsNullOrEmpty(name))
        {
            ShowMessage("Full name cannot be blank.", false);
            return;
        }

        try
        {
            string email = Session["Email"].ToString();

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();
                string query = @"
                    UPDATE Registration_tbl 
                    SET Name = @Name,
                        Gender = @Gender,
                        City = @City,
                        Mobile = @Mobile,
                        Address = @Address
                    WHERE Email = @Email";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Gender", string.IsNullOrEmpty(rdoGender.SelectedValue) ? (object)DBNull.Value : rdoGender.SelectedValue);
                    cmd.Parameters.AddWithValue("@City", string.IsNullOrEmpty(drpCity.SelectedValue) ? (object)DBNull.Value : drpCity.SelectedValue);
                    cmd.Parameters.AddWithValue("@Mobile", txtMobile.Text.Trim());
                    cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", email);

                    cmd.ExecuteNonQuery();
                }
            }

            // Update session values
            Session["Name"] = name;
            Session["UserName"] = name;
            lblSidebarName.Text = name + " · Student";

            ShowMessage("Profile updated successfully!", true);
        }
        catch (Exception ex)
        {
            ShowMessage("Error saving profile: " + ex.Message, false);
        }
    }
}
