<%@ Page Title="My Profile" Language="C#" AutoEventWireup="true" CodeFile="Profile.aspx.cs" Inherits="StudentPanel_Profile" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Profile</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <link href="../Content/panel.css" rel="stylesheet" />
    <style>
        .profile-card   { background:#222C3C; border:1px solid rgba(255,255,255,.08);
                          border-radius:14px; padding:28px 32px; box-shadow:0 4px 20px rgba(0,0,0,.25); }
        .avatar-box     { width:80px; height:80px; border-radius:50%; background:linear-gradient(135deg,#059669,#047857);
                          color:#fff; font-size:1.8rem; font-weight:700; display:flex;
                          align-items:center; justify-content:center; flex-shrink:0;
                          box-shadow:0 4px 14px rgba(5,150,105,.3); }
        .profile-hdr    { display:flex; align-items:center; gap:20px; margin-bottom:24px;
                          padding-bottom:20px; border-bottom:1px solid rgba(255,255,255,.08); }
        .info-box       { background:#182230; border:1px solid rgba(255,255,255,.12);
                          border-radius:8px; padding:10px 14px; font-size:.88rem; color:#f1f5f9; }
    </style>
</head>
<body class="student">
<form id="form1" runat="server">
<aside class="sidebar">
    <div class="sidebar-brand"><h2>Freelancer<span>Hub</span></h2><small>Student Panel</small></div>
    <nav class="sidebar-nav">
        <a href="Dashboard.aspx"><i class="bi bi-speedometer2"></i> <span>Dashboard</span></a>
        <a href="Profile.aspx" class="active"><i class="bi bi-person"></i> <span>My Profile</span></a>
        <a href="SkillsManagement.aspx"><i class="bi bi-tools"></i> <span>Skills</span></a>
        <a href="Portfolio.aspx"><i class="bi bi-folder2-open"></i> <span>Portfolio</span></a>
        <a href="BrowseProjects.aspx"><i class="bi bi-search"></i> <span>Browse Projects</span></a>
        <a href="MyApplications.aspx"><i class="bi bi-file-earmark-text"></i> <span>My Applications</span></a>
        <a href="Notifications.aspx"><i class="bi bi-bell"></i> <span>Notifications</span></a>
        <a href="ProfileSettings.aspx"><i class="bi bi-gear"></i> <span>Settings</span></a>
        <a href="ChangePassword.aspx"><i class="bi bi-key"></i> <span>Change Password</span></a>
        <a href="../Logout.aspx"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a>
    </nav>
    <div class="sidebar-footer"><asp:Label ID="lblSidebarName" runat="server"></asp:Label></div>
</aside>
<div class="main">
    <div class="topbar"><h1>My Profile</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <div class="profile-card">
            <div class="profile-hdr">
                <div class="avatar-box"><asp:Label ID="lblInitials" runat="server"></asp:Label></div>
                <div>
                    <h2 style="margin:0;font-size:1.3rem;color:#ffffff;font-weight:700;"><asp:Label ID="lblName" runat="server"></asp:Label></h2>
                    <p style="margin:4px 0 8px;color:#94a3b8;font-size:.85rem;">Student · <asp:Label ID="lblCity" runat="server"></asp:Label></p>
                    <span class="badge badge-green">Active Student Account</span>
                </div>
            </div>
            <div class="grid-2" style="margin-bottom:24px;">
                <div>
                    <div class="form-group">
                        <label style="color:#94a3b8; font-size:0.8rem; font-weight:600; display:block; margin-bottom:6px;"><i class="bi bi-envelope me-1"></i> Email Address</label>
                        <div class="info-box"><asp:Label ID="lblEmail" runat="server"></asp:Label></div>
                    </div>
                    <div class="form-group">
                        <label style="color:#94a3b8; font-size:0.8rem; font-weight:600; display:block; margin-bottom:6px;"><i class="bi bi-phone me-1"></i> Mobile Number</label>
                        <div class="info-box"><asp:Label ID="lblMobile" runat="server"></asp:Label></div>
                    </div>
                    <div class="form-group">
                        <label style="color:#94a3b8; font-size:0.8rem; font-weight:600; display:block; margin-bottom:6px;"><i class="bi bi-gender-ambiguous me-1"></i> Gender</label>
                        <div class="info-box"><asp:Label ID="lblGender" runat="server"></asp:Label></div>
                    </div>
                </div>
                <div>
                    <div class="form-group">
                        <label style="color:#94a3b8; font-size:0.8rem; font-weight:600; display:block; margin-bottom:6px;"><i class="bi bi-geo-alt me-1"></i> Address</label>
                        <div class="info-box" style="min-height:120px; white-space:pre-line;"><asp:Label ID="lblAddress" runat="server"></asp:Label></div>
                    </div>
                </div>
            </div>
            <a href="ProfileSettings.aspx" class="btn btn-success"><i class="bi bi-pencil-square me-1"></i> Edit Profile</a>
        </div>
    </div>
</div>
</form>
</body>
</html>
