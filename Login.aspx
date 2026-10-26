<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Login to FreelancerHub — Access your Admin, Client or Student dashboard." />
    <style>
        /* Role selector buttons */
        .role-selector { display: flex; gap: 8px; margin-bottom: 0; }
        .role-btn {
            flex: 1; padding: 10px 6px; border-radius: 10px; border: 2px solid #e2e8f0;
            background: #f8fafc; cursor: pointer; text-align: center;
            font-size: .78rem; font-weight: 600; color: #64748b;
            transition: all .2s; outline: none;
        }
        .role-btn:hover { border-color: #4f46e5; color: #4f46e5; background: #f0f0ff; }
        .role-btn.selected-admin   { border-color: #ef4444; background: #fef2f2; color: #ef4444; }
        .role-btn.selected-client  { border-color: #3b82f6; background: #eff6ff; color: #3b82f6; }
        .role-btn.selected-student { border-color: #10b981; background: #f0fdf4; color: #10b981; }
        .role-btn .role-icon { font-size: 1.3rem; display: block; margin-bottom: 3px; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-wrapper">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-5 col-lg-4">

                    <!-- Login Card -->
                    <div class="card-custom">

                        <!-- Header -->
                        <div class="text-center mb-4">
                            <div style="width:64px;height:64px;background:linear-gradient(135deg,#4f46e5,#312e81);
                                        border-radius:16px;display:flex;align-items:center;justify-content:center;
                                        margin:0 auto 16px;">
                                <span style="color:#fff;font-size:1.4rem;font-weight:700;letter-spacing:-1px;font-family:sans-serif;">FH</span>
                            </div>
                            <h1 class="section-title" style="font-size:1.5rem;margin-bottom:4px;">Welcome Back</h1>
                            <p style="color:#64748b;font-size:.875rem;margin:0;">Sign in to your FreelancerHub account</p>
                        </div>

                        <!-- Error/Success Message -->
                        <asp:Label ID="lblLoginMsg" runat="server" Visible="false"
                            CssClass="alert-danger-custom d-block mb-3"></asp:Label>

                        <!-- Role Selector -->
                        <div class="mb-3">
                            <label class="form-label">Login As</label>
                            <div class="role-selector" id="roleBtns">
                                <button type="button" class="role-btn" id="btnAdmin"
                                    onclick="selectRole('Admin')">
                                    <span class="role-icon"><i class="bi bi-person-badge"></i></span>Admin
                                </button>
                                <button type="button" class="role-btn" id="btnClient"
                                    onclick="selectRole('Client')">
                                    <span class="role-icon"><i class="bi bi-briefcase"></i></span>Client
                                </button>
                                <button type="button" class="role-btn" id="btnStudent"
                                    onclick="selectRole('Student')">
                                    <span class="role-icon"><i class="bi bi-mortarboard"></i></span>Student
                                </button>
                            </div>
                            <!-- Hidden field to pass selected role to server -->
                            <asp:HiddenField ID="hdnRole" runat="server" Value="" />
                        </div>

                        <!-- Name -->
                        <div class="mb-3">
                            <label class="form-label" for="txtLoginName">Your Name</label>
                            <div class="input-group">
                                <span class="input-group-text" style="border-right:0;background:#f8fafc;">
                                    <i class="bi bi-person" style="color:#4f46e5;"></i>
                                </span>
                                <asp:TextBox ID="txtLoginName" runat="server" CssClass="form-control"
                                    placeholder="Enter your name"
                                    style="border-left:0;" />
                            </div>
                        </div>

                        <!-- Email -->
                        <div class="mb-3">
                            <label class="form-label" for="txtLoginEmail">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text" style="border-right:0;background:#f8fafc;">
                                    <i class="bi bi-envelope" style="color:#4f46e5;"></i>
                                </span>
                                <asp:TextBox ID="txtLoginEmail" runat="server" CssClass="form-control"
                                    TextMode="Email" placeholder="you@example.com"
                                    style="border-left:0;" />
                            </div>
                        </div>

                        <!-- Password -->
                        <div class="mb-4">
                            <label class="form-label" for="txtLoginPassword">Password</label>
                            <div class="input-group">
                                <span class="input-group-text" style="border-right:0;background:#f8fafc;">
                                    <i class="bi bi-lock" style="color:#4f46e5;"></i>
                                </span>
                                <asp:TextBox ID="txtLoginPassword" runat="server" CssClass="form-control"
                                    TextMode="Password" placeholder="Enter your password"
                                    style="border-left:0;" />
                            </div>
                        </div>

                        <!-- Login Button -->
                        <asp:Button ID="btnLogin" runat="server" Text="Login"
                            CssClass="btn-primary-custom w-100"
                            OnClick="btnLogin_Click" />

                        <!-- Divider -->
                        <div class="text-center my-3" style="color:#94a3b8;font-size:.82rem;">── or ──</div>

                        <!-- Register Link -->
                        <div class="text-center">
                            <span style="font-size:.875rem;color:#64748b;">Don't have an account? </span>
                            <a href="Register.aspx"
                               style="color:#4f46e5;font-weight:600;font-size:.875rem;text-decoration:none;">
                                Register here
                            </a>
                        </div>

                    </div>

                    <!-- Info note -->
                    <div class="text-center mt-3">
                        <small style="color:#94a3b8;">
                            <i class="bi bi-info-circle me-1"></i>
                            Enter any name, email &amp; password — just select your role above.
                        </small>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <script>
        function selectRole(role) {
            // Clear all selections
            document.getElementById('btnAdmin').className   = 'role-btn';
            document.getElementById('btnClient').className  = 'role-btn';
            document.getElementById('btnStudent').className = 'role-btn';

            // Highlight selected
            if (role === 'Admin')   document.getElementById('btnAdmin').className   = 'role-btn selected-admin';
            if (role === 'Client')  document.getElementById('btnClient').className  = 'role-btn selected-client';
            if (role === 'Student') document.getElementById('btnStudent').className = 'role-btn selected-student';

            // Store in hidden field for server
            document.getElementById('<%= hdnRole.ClientID %>').value = role;
        }
    </script>

</asp:Content>
