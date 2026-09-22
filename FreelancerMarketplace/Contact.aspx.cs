using System;
using System.Web.UI;

public partial class Contact : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Static contact page — no logic on load
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        // Placeholder — no DB save required yet
        lblMessage.Text = "<i class='bi bi-check-circle-fill me-2'></i>Message Sent! Thank you for reaching out. We will get back to you soon.";
        lblMessage.Visible = true;

        // Clear form fields after submit
        txtName.Text = string.Empty;
        txtEmail.Text = string.Empty;
        txtMessage.Text = string.Empty;
    }
}
