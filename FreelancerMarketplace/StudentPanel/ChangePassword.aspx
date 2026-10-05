<%@ Page Title="Change Password" Language="C#" AutoEventWireup="true" CodeFile="ChangePassword.aspx.cs" Inherits="StudentPanel_ChangePassword" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Change Password</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <link href="../Content/panel.css" rel="stylesheet" />
    <style>
        .form-card          { background:#222C3C; border:1px solid rgba(255,255,255,.08);
                              border-radius:14px; padding:28px 32px; max-width:480px;
                              box-shadow:0 4px 20px rgba(0,0,0,.25); }
        .form-card h5       { font-weight:700; color:#ffffff; margin-bottom:20px;
                              padding-bottom:12px; border-bottom:1px solid rgba(255,255,255,.08); font-size:1.05rem; }
        .form-group         { display:flex; flex-direction:column; margin-bottom:16px; }
        .form-group label   { font-size:.8rem; font-weight:600; color:#94a3b8; margin-bottom:6px; }
        .form-group input   { width:100%; padding:10px 14px; background:#182230;
                              border:1px solid rgba(255,255,255,.12);
                              border-radius:8px; font-size:.88rem; color:#f1f5f9; outline:none;
                              transition:all .2s; box-sizing:border-box; font-family:'Inter',sans-serif; }
        .form-group input:focus { border-color:#34d399; background:#1c2738;
                                  box-shadow:0 0 0 2px rgba(52,211,153,.18); }
        .form-group input::placeholder { color:#64748b; }
        .btn-change         { margin-top:10px; padding:10px 28px; background:#059669;
                              color:#fff; border:none; border-radius:8px; font-size:.88rem;
                              font-weight:600; cursor:pointer; transition:background .2s;
                              box-shadow:0 2px 8px rgba(5,150,105,.3); }
        .btn-change:hover   { background:#047857; }
    </style>
</head>
<body class="student">
<form id="form1" runat="server">
<aside class="sidebar">
    <div class="sidebar-brand"><h2>Freelancer<span>Hub</span></h2><small>Student Panel</small></div>
    <nav class="sidebar-nav">
        <a href="Dashboard.aspx"><i class="bi bi-speedometer2"></i> <span>Dashboard</span></a>
        <a href="Profile.aspx"><i class="bi bi-person"></i> <span>My Profile</span></a>
        <a href="SkillsManagement.aspx"><i class="bi bi-tools"></i> <span>Skills</span></a>
        <a href="Portfolio.aspx"><i class="bi bi-folder2-open"></i> <span>Portfolio</span></a>
        <a href="BrowseProjects.aspx"><i class="bi bi-search"></i> <span>Browse Projects</span></a>
        <a href="MyApplications.aspx"><i class="bi bi-file-earmark-text"></i> <span>My Applications</span></a>
        <a href="Notifications.aspx"><i class="bi bi-bell"></i> <span>Notifications</span></a>
        <a href="ProfileSettings.aspx"><i class="bi bi-gear"></i> <span>Settings</span></a>
        <a href="ChangePassword.aspx" class="active"><i class="bi bi-key"></i> <span>Change Password</span></a>
        <a href="../Logout.aspx"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a>
    </nav>
    <div class="sidebar-footer"><asp:Label ID="lblSidebarName" runat="server"></asp:Label></div>
</aside>
<div class="main">
    <div class="topbar"><h1>Change Password</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">

        <!-- Status / Message Panel -->
        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600; max-width:480px;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <div class="form-card">
            <h5><i class="bi bi-shield-lock me-2" style="color:#34d399;"></i>Update Account Password</h5>
            <div class="form-group">
                <label>Current Password</label>
                <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" placeholder="Enter current password"></asp:TextBox>
            </div>
            <div class="form-group">
                <label>New Password</label>
                <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" placeholder="Enter new password (min. 4 characters)"></asp:TextBox>
            </div>
            <div class="form-group">
                <label>Confirm New Password</label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="Confirm new password"></asp:TextBox>
            </div>
            <asp:Button ID="btnChangePassword" runat="server" Text="Update Password" CssClass="btn-change" OnClick="btnChangePassword_Click" />
        </div>
    </div>
</div>
</form>
</body>
</html>
