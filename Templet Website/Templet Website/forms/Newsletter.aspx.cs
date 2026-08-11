using System;
using System.Web.UI;

namespace FreelanceStudentSystem
{
    public partial class Newsletter : Page
    {
        protected void btnSubscribe_Click(object sender, EventArgs e)
        {
            string email = txtNewsletterEmail.Text?.Trim() ?? string.Empty;
            if (string.IsNullOrEmpty(email))
            {
                lblStatus.CssClass = "text-danger";
                lblStatus.Text = "Please enter an email address.";
                return;
            }

            try
            {
                // TODO: Persist subscription to DB or send confirmation email.
                lblStatus.CssClass = "text-success";
                lblStatus.Text = "Subscription successful. (Demo)";
            }
            catch (Exception ex)
            {
                lblStatus.CssClass = "text-danger";
                lblStatus.Text = "Error: " + ex.Message;
            }
        }
    }
}