using System;
using System.Web.UI;

namespace FreelanceStudentSystem.Pages.Student
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["FullName"] != null)
                lblName.Text = Session["FullName"].ToString();
            else
                Response.Redirect("~/Pages/Account/Login.aspx");
        }
    }
}