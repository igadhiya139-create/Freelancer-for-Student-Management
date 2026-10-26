<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Contact.aspx.cs" Inherits="Contact" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Contact FreelancerHub — Get in touch with our support team for any queries or assistance." />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-wrapper">
        <div class="container">

            <!-- Page Header -->
            <div class="mb-5">
                <div class="title-bar"></div>
                <h1 class="section-title">Contact Us</h1>
                <p class="section-subtitle">Have a question or need help? Drop us a message and we'll get back to you shortly.</p>
            </div>

            <!-- Success Message Placeholder -->
            <asp:Label ID="lblMessage" runat="server" Visible="false"
                CssClass="alert-success-custom d-block mb-4"></asp:Label>

            <div class="row g-4">

                <!-- Contact Form -->
                <div class="col-lg-7">
                    <div class="card-custom">
                        <h5 style="font-weight:700;color:#1e1b4b;margin-bottom:24px;">
                            <i class="bi bi-send-fill me-2" style="color:#4f46e5;"></i>Send Us a Message
                        </h5>

                        <div class="mb-3">
                            <label class="form-label" for="txtName">Full Name</label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control"
                                placeholder="Enter your full name" />
                        </div>

                        <div class="mb-3">
                            <label class="form-label" for="txtEmail">Email Address</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"
                                TextMode="Email" placeholder="Enter your email address" />
                        </div>

                        <div class="mb-4">
                            <label class="form-label" for="txtMessage">Message</label>
                            <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control"
                                TextMode="MultiLine" Rows="5"
                                placeholder="Type your message here..." />
                        </div>

                        <asp:Button ID="btnSubmit" runat="server" Text="Send Message"
                            CssClass="btn-primary-custom"
                            OnClick="btnSubmit_Click" />
                    </div>
                </div>

                <!-- Contact Info -->
                <div class="col-lg-5">
                    <div class="card-custom mb-4">
                        <h5 style="font-weight:700;color:#1e1b4b;margin-bottom:20px;">
                            <i class="bi bi-info-circle-fill me-2" style="color:#4f46e5;"></i>Contact Information
                        </h5>

                        <div class="contact-info-item">
                            <div class="contact-icon">
                                <i class="bi bi-geo-alt-fill"></i>
                            </div>
                            <div>
                                <div style="font-weight:600;font-size:.9rem;color:#1e293b;">Address</div>
                                <div style="font-size:.875rem;color:#64748b;line-height:1.6;">
                                    FreelancerHub HQ, Tech Park,<br />Pune, Maharashtra 411001, India
                                </div>
                            </div>
                        </div>

                        <div class="contact-info-item">
                            <div class="contact-icon">
                                <i class="bi bi-envelope-fill"></i>
                            </div>
                            <div>
                                <div style="font-weight:600;font-size:.9rem;color:#1e293b;">Email</div>
                                <div style="font-size:.875rem;color:#64748b;">support@freelancerhub.in</div>
                            </div>
                        </div>

                        <div class="contact-info-item">
                            <div class="contact-icon">
                                <i class="bi bi-telephone-fill"></i>
                            </div>
                            <div>
                                <div style="font-weight:600;font-size:.9rem;color:#1e293b;">Phone</div>
                                <div style="font-size:.875rem;color:#64748b;">+91 98765 43210</div>
                            </div>
                        </div>

                        <div class="contact-info-item" style="margin-bottom:0;">
                            <div class="contact-icon">
                                <i class="bi bi-clock-fill"></i>
                            </div>
                            <div>
                                <div style="font-weight:600;font-size:.9rem;color:#1e293b;">Support Hours</div>
                                <div style="font-size:.875rem;color:#64748b;">Mon – Sat: 9:00 AM – 6:00 PM</div>
                            </div>
                        </div>
                    </div>

                    <div class="card-custom" style="background:linear-gradient(135deg,#4f46e5,#312e81);color:#fff;">
                        <h6 style="font-weight:700;margin-bottom:10px;">
                            <i class="bi bi-question-circle-fill me-2"></i>Need Quick Help?
                        </h6>
                        <p style="font-size:.875rem;opacity:.85;margin-bottom:12px;line-height:1.65;">
                            Check our FAQ section or reach out to our community on social media for faster responses.
                        </p>
                        <div style="font-size:.85rem;opacity:.75;">
                            Available on Instagram, LinkedIn, and Twitter @FreelancerHub
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

</asp:Content>
