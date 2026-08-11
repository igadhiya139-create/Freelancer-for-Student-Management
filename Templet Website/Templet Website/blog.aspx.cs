using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Templet_Website
{
    public partial class Blog : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Show static posts panel (no DB connected yet)
            pnlStaticPosts.Visible = true;
        }

        // Handles commands fired from the Repeater (e.g. "ReadMore" button if added)
        protected void rptBlogPosts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // Placeholder — extend when wiring up DB-driven posts
        }

        // Handles the newsletter Subscribe button
        protected void btnSubscribe_Click(object sender, EventArgs e)
        {
            string email = txtNewsletterEmail.Text.Trim();

            if (string.IsNullOrWhiteSpace(email))
            {
                lblSubscribeMsg.Text    = "<div class='alert alert-warning py-2'>Please enter your email address.</div>";
                lblSubscribeMsg.Visible = true;
                return;
            }

            // TODO: save email to DB or mailing list
            lblSubscribeMsg.Text    = "<div class='alert alert-success py-2'>Thank you! You have been subscribed.</div>";
            lblSubscribeMsg.Visible = true;
            txtNewsletterEmail.Text = "";
        }
    }
}
