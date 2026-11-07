using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AdminPanel_AdminProfile : System.Web.UI.Page
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
            LoadProfile();
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

    void LoadProfile()
    {
        string email = Session["Email"] != null ? Session["Email"].ToString() : "";

        using (SqlConnection con = new SqlConnection(s))
        {
            con.Open();
            string query = "SELECT Name, Email, Mobile, City FROM Registration_tbl WHERE Email = @Email";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        string name = dr["Name"].ToString();
                        string userEmail = dr["Email"].ToString();
                        string mobile = dr["Mobile"].ToString();
                        string city = dr["City"].ToString();

                        txtName.Text = name;
                        txtEmail.Text = userEmail;
                        txtMobile.Text = mobile;
                        txtCity.Text = city;

                        lblHeaderName.Text = name;
                        lblHeaderEmail.Text = userEmail;
                        lblAvatarInitials.Text = name.Length >= 2 ? name.Substring(0, 2).ToUpper() : "AD";
                    }
                }
            }
        }
    }

    protected void btnUpdateProfile_Click(object sender, EventArgs e)
    {
        string email = Session["Email"] != null ? Session["Email"].ToString() : "";
        string newName = txtName.Text.Trim();
        string newMobile = txtMobile.Text.Trim();
        string newCity = txtCity.Text.Trim();
        string newPass = txtPassword.Text.Trim();

        if (string.IsNullOrEmpty(newName))
        {
            ShowMessage("Name cannot be empty.", false);
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(s))
            {
                con.Open();
                string query;
                if (!string.IsNullOrEmpty(newPass))
                {
                    query = "UPDATE Registration_tbl SET Name=@Name, Mobile=@Mobile, City=@City, Password=@Password WHERE Email=@Email";
                }
                else
                {
                    query = "UPDATE Registration_tbl SET Name=@Name, Mobile=@Mobile, City=@City WHERE Email=@Email";
                }

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Name", newName);
                    cmd.Parameters.AddWithValue("@Mobile", newMobile);
                    cmd.Parameters.AddWithValue("@City", newCity);
                    cmd.Parameters.AddWithValue("@Email", email);
                    if (!string.IsNullOrEmpty(newPass))
                    {
                        cmd.Parameters.AddWithValue("@Password", newPass);
                    }

                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0)
                    {
                        Session["admin"] = newName;
                        Session["UserName"] = newName;
                        lblSidebarName.Text = newName + " · Admin";
                        lblHeaderName.Text = newName;
                        lblAvatarInitials.Text = newName.Length >= 2 ? newName.Substring(0, 2).ToUpper() : "AD";

                        LogActivity("Admin updated profile details");
                        ShowMessage("Profile updated successfully.", true);
                    }
                    else
                    {
                        ShowMessage("Could not update profile.", false);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Error updating profile: " + ex.Message, false);
        }
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        pnlMsg.Visible = false;
        LoadProfile();
    }
}
