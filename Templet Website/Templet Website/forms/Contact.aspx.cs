//using System;
//using System.Net.Mail;
//using System.Web;
//using System.Web.UI;
//using System.Configuration;
//using System.Net.Configuration;

//namespace FreelanceStudentSystem
//{
//    public partial class Contact : Page
//    {
//        protected void Page_Load(object sender, EventArgs e)
//        {
//            if (!string.Equals(Request.HttpMethod, "POST", StringComparison.OrdinalIgnoreCase))
//            {
//                Response.StatusCode = 405; // Method Not Allowed
//                Response.End();
//                return;
//            }

//            Response.ContentType = "text/plain";

//            string name = (Request.Form["name"] ?? string.Empty).Trim();
//            string email = (Request.Form["email"] ?? string.Empty).Trim();
//            string subject = (Request.Form["subject"] ?? "Website contact").Trim();
//            string phone = (Request.Form["phone"] ?? string.Empty).Trim();
//            string message = (Request.Form["message"] ?? string.Empty).Trim();

//            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(message))
//            {
//                Response.StatusCode = 400;
//                Response.Write("Missing required fields.");
//                Response.End();
//                return;
//            }

//            string recipient = ConfigurationManager.AppSettings["ContactRecipient"] ?? "contact@example.com";

//            string body = $"Name: {HttpUtility.HtmlEncode(name)}\nEmail: {HttpUtility.HtmlEncode(email)}\n";
//            if (!string.IsNullOrEmpty(phone)) body += $"Phone: {HttpUtility.HtmlEncode(phone)}\n";
//            body += "\nMessage:\n" + HttpUtility.HtmlEncode(message);

//            try
//            {
//                var smtpSection = ConfigurationManager.GetSection("system.net/mailSettings/smtp") as SmtpSection;
//                if (smtpSection != null && smtpSection.Network != null && !string.IsNullOrEmpty(smtpSection.Network.Host))
//                {
//                    using (var mail = new MailMessage())
//                    {
//                        mail.To.Add(recipient);
//                        try { mail.From = new MailAddress(email, name); }
//                        catch { mail.From = new MailAddress("no-reply@example.com", "Website"); }

//                        mail.Subject = subject;
//                        mail.Body = body;
//                        mail.IsBodyHtml = false;

//                        using (var client = new SmtpClient())
//                        {
//                            client.Send(mail);
//                        }
//                    }

//                    Response.Write("OK");
//                }
//                else
//                {
//                    // No SMTP configured — return demo success so UI can be tested
//                    Response.Write("OK (demo)");
//                }
//            }
//            catch
//            {
//                Response.StatusCode = 500;
//                Response.Write("Error sending message.");
//            }
//            finally
//            {
//                Response.End();
//            }
//        }
//    }
//}

using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace FreelanceStudentSystem
{
    public partial class Contact : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Nothing is required here.
        }

        

        protected void TextBox1_TextChanged(object sender, EventArgs e)
        {

        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            string name = TextBox1.Text.Trim();
            string email = TextBox2.Text.Trim();
            string phone = TextBox3.Text.Trim();
            string subject = TextBox4.Text.Trim();
            string message = TextBox5.Text.Trim();

            // Validation
            if (string.IsNullOrWhiteSpace(name) ||
                string.IsNullOrWhiteSpace(email) ||
                string.IsNullOrWhiteSpace(subject) ||
                string.IsNullOrWhiteSpace(message))
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Please fill all required fields.";
                return;
            }

            // Email Validation
            if (!email.Contains("@") || !email.Contains("."))
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Please enter a valid email address.";
                return;
            }

            // Success Message
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "Your message has been sent successfully.";

            // Clear TextBoxes
            TextBox1.Text = "";
            TextBox2.Text = "";
            TextBox3.Text = "";
            TextBox4.Text = "";
            TextBox5.Text = "";
        }

    }
}
