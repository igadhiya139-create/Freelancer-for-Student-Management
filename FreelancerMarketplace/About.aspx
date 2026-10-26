<%@ Page Title="About Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="About.aspx.cs" Inherits="About" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="About Freelancer Marketplace for Students — Our mission, values, and the team behind the platform." />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-wrapper">
        <div class="container">

            <!-- Page Header -->
            <div class="mb-5">
                <div class="title-bar"></div>
                <h1 class="section-title">About FreelancerHub</h1>
                <p class="section-subtitle">Learn about our mission, vision, and the team that makes it happen</p>
            </div>

            <div class="row g-4 align-items-start">

                <!-- Main About Card -->
                <div class="col-lg-7">
                    <div class="about-card mb-4">
                        <h3 style="font-weight:700;margin-bottom:16px;">
                            <i class="bi bi-lightbulb-fill me-2" style="color:#fbbf24;"></i>Our Mission
                        </h3>
                        <p style="line-height:1.85;opacity:.9;font-size:.96rem;">
                            <strong>FreelancerHub</strong> was built with a single purpose: to bridge the gap between talented
                            student freelancers and businesses or individuals who need quality work done. We believe that
                            every student deserves the opportunity to apply their classroom knowledge to real-world projects —
                            and every client deserves access to fresh, innovative, and affordable talent.
                        </p>
                        <p style="line-height:1.85;opacity:.9;font-size:.96rem;margin-bottom:0;">
                            Our platform is a safe, structured, and supportive environment designed specifically for college
                            students across India. Whether you are learning web development, graphic design, content writing,
                            data entry, or digital marketing — FreelancerHub helps you build a portfolio, gain experience,
                            and earn while you learn.
                        </p>
                    </div>

                    <div class="card-custom">
                        <h5 style="font-weight:700;color:#1e1b4b;margin-bottom:18px;">
                            <i class="bi bi-check2-circle me-2" style="color:#4f46e5;"></i>What We Offer
                        </h5>
                        <ul style="list-style:none;padding:0;margin:0;">
                            <li class="d-flex align-items-center gap-3 mb-3">
                                <span style="width:32px;height:32px;background:rgba(79,70,229,.1);border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:.9rem;flex-shrink:0;">🎯</span>
                                <span style="font-size:.9rem;color:#475569;">Verified student profiles with skill-based portfolios</span>
                            </li>
                            <li class="d-flex align-items-center gap-3 mb-3">
                                <span style="width:32px;height:32px;background:rgba(14,165,233,.1);border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:.9rem;flex-shrink:0;">📋</span>
                                <span style="font-size:.9rem;color:#475569;">Project posting and bidding system for clients</span>
                            </li>
                            <li class="d-flex align-items-center gap-3 mb-3">
                                <span style="width:32px;height:32px;background:rgba(245,158,11,.1);border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:.9rem;flex-shrink:0;">💬</span>
                                <span style="font-size:.9rem;color:#475569;">Direct communication between students and clients</span>
                            </li>
                            <li class="d-flex align-items-center gap-3 mb-3">
                                <span style="width:32px;height:32px;background:rgba(16,185,129,.1);border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:.9rem;flex-shrink:0;">🔒</span>
                                <span style="font-size:.9rem;color:#475569;">Secure platform with admin moderation</span>
                            </li>
                            <li class="d-flex align-items-center gap-3">
                                <span style="width:32px;height:32px;background:rgba(239,68,68,.1);border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:.9rem;flex-shrink:0;">⭐</span>
                                <span style="font-size:.9rem;color:#475569;">Rating and review system for quality assurance</span>
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- Side Info -->
                <div class="col-lg-5">
                    <div class="card-custom mb-4">
                        <h5 style="font-weight:700;color:#1e1b4b;margin-bottom:18px;">
                            <i class="bi bi-bar-chart-fill me-2" style="color:#4f46e5;"></i>Platform At a Glance
                        </h5>
                        <div class="row g-3">
                            <div class="col-6">
                                <div style="background:#f8fafc;border-radius:10px;padding:16px;text-align:center;">
                                    <div style="font-size:1.6rem;font-weight:800;color:#4f46e5;">1,200+</div>
                                    <div style="font-size:.78rem;color:#64748b;font-weight:500;">Students</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div style="background:#f8fafc;border-radius:10px;padding:16px;text-align:center;">
                                    <div style="font-size:1.6rem;font-weight:800;color:#0ea5e9;">450+</div>
                                    <div style="font-size:.78rem;color:#64748b;font-weight:500;">Clients</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div style="background:#f8fafc;border-radius:10px;padding:16px;text-align:center;">
                                    <div style="font-size:1.6rem;font-weight:800;color:#10b981;">850+</div>
                                    <div style="font-size:.78rem;color:#64748b;font-weight:500;">Projects Done</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div style="background:#f8fafc;border-radius:10px;padding:16px;text-align:center;">
                                    <div style="font-size:1.6rem;font-weight:800;color:#f59e0b;">4.8★</div>
                                    <div style="font-size:.78rem;color:#64748b;font-weight:500;">Avg. Rating</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card-custom">
                        <h5 style="font-weight:700;color:#1e1b4b;margin-bottom:16px;">
                            <i class="bi bi-geo-alt-fill me-2" style="color:#4f46e5;"></i>Our Reach
                        </h5>
                        <p style="font-size:.9rem;color:#64748b;line-height:1.7;margin-bottom:12px;">
                            Currently operating across <strong>20+ cities</strong> in India with plans to expand
                            to all major university towns by 2025.
                        </p>
                        <p style="font-size:.9rem;color:#64748b;line-height:1.7;margin:0;">
                            Partnered with colleges and universities to offer internship credit for freelance
                            projects completed on the platform.
                        </p>
                    </div>
                </div>

            </div>
        </div>
    </div>

</asp:Content>
