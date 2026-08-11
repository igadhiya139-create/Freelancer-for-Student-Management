using System;
using System.Web.UI;

namespace Templet_Website
{
    public partial class Site1 : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (lblContactResult != null)
                    lblContactResult.Text = "";

                if (lblSubscribeResult != null)
                    lblSubscribeResult.Text = "";

                if (lblFooterSubscribeResult != null)
                    lblFooterSubscribeResult.Text = "";
            }
        }

        protected void btnContactSend_Click(object sender, EventArgs e)
        {
            string name = txtContactName.Text.Trim();
            string email = txtContactEmail.Text.Trim();
            string subject = txtContactSubject.Text.Trim();
            string message = txtContactMessage.Text.Trim();

            if (string.IsNullOrWhiteSpace(name) ||
                string.IsNullOrWhiteSpace(email) ||
                string.IsNullOrWhiteSpace(subject) ||
                string.IsNullOrWhiteSpace(message))
            {
                lblContactResult.ForeColor = System.Drawing.Color.Red;
                lblContactResult.Text = "Please fill in all required fields.";
                return;
            }

            lblContactResult.ForeColor = System.Drawing.Color.Green;
            lblContactResult.Text = "Your message has been sent successfully!";

            txtContactName.Text = "";
            txtContactEmail.Text = "";
            txtContactSubject.Text = "";
            txtContactMessage.Text = "";
        }

        protected void btnSubscribe_Click(object sender, EventArgs e)
        {
            string email = txtNewsletterEmail.Text.Trim();

            if (string.IsNullOrWhiteSpace(email) || !email.Contains("@"))
            {
                lblSubscribeResult.ForeColor = System.Drawing.Color.Red;
                lblSubscribeResult.Text = "Please enter a valid email address.";
                return;
            }

            lblSubscribeResult.ForeColor = System.Drawing.Color.Green;
            lblSubscribeResult.Text = "Thank you for subscribing!";
            txtNewsletterEmail.Text = "";
        }

        protected void btnFooterSubscribe_Click(object sender, EventArgs e)
        {
            string email = txtFooterEmail.Text.Trim();

            if (string.IsNullOrWhiteSpace(email) || !email.Contains("@"))
            {
                lblFooterSubscribeResult.ForeColor = System.Drawing.Color.Red;
                lblFooterSubscribeResult.Text = "Please enter a valid email address.";
                return;
            }

            lblFooterSubscribeResult.ForeColor = System.Drawing.Color.White;
            lblFooterSubscribeResult.Text = "Thank you for subscribing!";
            txtFooterEmail.Text = "";
        }
    }
}
