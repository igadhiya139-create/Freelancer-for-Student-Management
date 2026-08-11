using System;
using System.Web.Security;

namespace FreelanceStudentSystem.Pages.Account
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            FormsAuthentication.SignOut();
            Response.Redirect("~/Pages/Account/Login.aspx");
        }
    }
}
