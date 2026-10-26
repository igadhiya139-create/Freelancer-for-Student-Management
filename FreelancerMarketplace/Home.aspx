<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Home.aspx.cs" Inherits="Home" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Freelancer Marketplace for Students — Find freelance projects or hire talented student developers, designers, and writers." />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- ===== HERO ===== -->
    <section class="hero-section">
        <div class="container position-relative">
            <div class="hero-badge">
                <i class="bi bi-stars me-1"></i> India's #1 Student Freelance Platform
            </div>
            <h1 class="hero-title">
                Empowering <span>Student Freelancers</span><br />
                to Build Real Careers
            </h1>
            <p class="hero-desc">
                Connect talented student developers, designers, and writers with clients who need
                quality work done — affordably, efficiently, and professionally.
            </p>
            <div class="hero-actions">
                <a href="Register.aspx" class="btn-hero-primary">
                    <i class="bi bi-person-plus-fill me-2"></i>Register Now
                </a>
                <a href="Login.aspx" class="btn-hero-outline">
                    <i class="bi bi-box-arrow-in-right me-2"></i>Login
                </a>
            </div>
        </div>
    </section>

    <!-- ===== STATS STRIP ===== -->
    <div style="background:#fff; border-bottom:1px solid #e2e8f0; padding:20px 0;">
        <div class="container">
            <div class="row text-center g-3">
                <div class="col-6 col-md-3">
                    <div style="font-size:1.8rem;font-weight:800;color:#4f46e5;">1,200+</div>
                    <div style="font-size:.82rem;color:#64748b;font-weight:500;">Registered Students</div>
                </div>
                <div class="col-6 col-md-3">
                    <div style="font-size:1.8rem;font-weight:800;color:#4f46e5;">450+</div>
                    <div style="font-size:.82rem;color:#64748b;font-weight:500;">Active Clients</div>
                </div>
                <div class="col-6 col-md-3">
                    <div style="font-size:1.8rem;font-weight:800;color:#4f46e5;">850+</div>
                    <div style="font-size:.82rem;color:#64748b;font-weight:500;">Projects Completed</div>
                </div>
                <div class="col-6 col-md-3">
                    <div style="font-size:1.8rem;font-weight:800;color:#4f46e5;">20+</div>
                    <div style="font-size:.82rem;color:#64748b;font-weight:500;">Cities Covered</div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== FEATURES ===== -->
    <section class="page-wrapper">
        <div class="container">
            <div class="text-center mb-5">
                <div class="title-bar mx-auto"></div>
                <h2 class="section-title">How It Works</h2>
                <p class="section-subtitle">Simple steps to get started — whether you are a Student or a Client</p>
            </div>
            <div class="row g-4">
                <!-- For Students -->
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon purple">🎓</div>
                        <h5 style="font-weight:700;color:#1e1b4b;">For Students</h5>
                        <p style="color:#64748b;font-size:.9rem;line-height:1.7;">
                            Create your profile, showcase your skills, and bid on real-world projects.
                            Build your portfolio while earning money during your studies.
                        </p>
                        <a href="Register.aspx" style="color:#4f46e5;font-weight:600;font-size:.875rem;text-decoration:none;">
                            Join as Student <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>
                <!-- For Clients -->
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon blue">💼</div>
                        <h5 style="font-weight:700;color:#1e1b4b;">For Clients</h5>
                        <p style="color:#64748b;font-size:.9rem;line-height:1.7;">
                            Post your project requirements, review bids from skilled students,
                            and get quality work delivered on time — at budget-friendly rates.
                        </p>
                        <a href="Register.aspx" style="color:#0ea5e9;font-weight:600;font-size:.875rem;text-decoration:none;">
                            Post a Project <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>
                <!-- Why Us -->
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon amber">⭐</div>
                        <h5 style="font-weight:700;color:#1e1b4b;">Why FreelancerHub?</h5>
                        <p style="color:#64748b;font-size:.9rem;line-height:1.7;">
                            Verified student profiles, secure communication, milestone-based payments,
                            and dedicated support — making every collaboration a success.
                        </p>
                        <a href="About.aspx" style="color:#f59e0b;font-weight:600;font-size:.875rem;text-decoration:none;">
                            Learn More <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- CTA Banner -->
            <div class="mt-5 p-4 text-center"
                 style="background:linear-gradient(135deg,#4f46e5,#312e81);border-radius:16px;color:#fff;">
                <h4 style="font-weight:700;margin-bottom:10px;">Ready to get started?</h4>
                <p style="opacity:.85;margin-bottom:20px;font-size:.95rem;">
                    Register now — it's free. Whether you are a student or a client, your journey starts here.
                </p>
                <a href="Register.aspx" class="btn-hero-primary" style="font-size:.9rem;padding:10px 28px;">
                    <i class="bi bi-person-plus-fill me-2"></i>Create Account
                </a>
            </div>
        </div>
    </section>

</asp:Content>
