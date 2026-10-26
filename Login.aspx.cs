using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

public partial class Login : System.Web.UI.Page
{
    SqlConnection con;
    SqlCommand cmd;
    SqlDataAdapter da;
    DataSet ds;


string s = ConfigurationManager.ConnectionStrings["dbcon"].ConnectionString;

    void getCon()
    {
        con = new SqlConnection(s);
        con.Open();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["admin"] != null)
        {
            if (Session["Role"].ToString() == "Admin")
            {
                Response.Redirect("~/AdminPanel/Dashboard.aspx");
            }
            else if (Session["Role"].ToString() == "Client")
            {
                Response.Redirect("~/ClientPanel/Dashboard.aspx");
            }
            else if (Session["Role"].ToString() == "Student")
            {
                Response.Redirect("~/StudentPanel/Dashboard.aspx");
            }
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        getCon();

        cmd = new SqlCommand("select * from Registration_tbl where Name='" + txtLoginName.Text + "' and Email='" + txtLoginEmail.Text + "' and Password='" + txtLoginPassword.Text + "'", con);

        int i = Convert.ToInt32(cmd.ExecuteScalar());

        con.Close();

        if (i > 0)
        {
            Session["admin"] = txtLoginName.Text;
            Session["Role"] = hdnRole.Value;
            Session["UserName"] = txtLoginName.Text;
            Session["UserId"] = txtLoginEmail.Text;

            if (hdnRole.Value == "Admin")
            {
                Response.Redirect("~/AdminPanel/Dashboar3d.aspx");
            }
            else if (hdnRole.Value == "Client")
            {
                Response.Redirect("~/ClientPanel/Dashboard.aspx");
            }
            else if (hdnRole.Value == "Student")
            {
                Response.Redirect("~/StudentPanel/Dashboard.aspx");
            }
        }
        else
        {
            lblLoginMsg.Text = "Invalid username or password.";
            lblLoginMsg.Visible = true;
        }
    }


}
