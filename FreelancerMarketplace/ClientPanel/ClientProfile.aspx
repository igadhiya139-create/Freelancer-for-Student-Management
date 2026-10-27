<%@ Page Title="Client Profile" Language="C#" AutoEventWireup="true"
         CodeFile="ClientProfile.aspx.cs" Inherits="ClientPanel_ClientProfile" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Client Profile</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <link href="../Content/panel.css" rel="stylesheet" />
    <style>
        .profile-card   { background:#222C3C; border:1px solid rgba(255,255,255,.08);
                          border-radius:14px; padding:28px 32px; box-shadow:0 4px 20px rgba(0,0,0,.25); }
        .profile-avatar { width:80px;height:80px;border-radius:50%;background:linear-gradient(135deg,#0284c7,#0369a1);
                          color:#fff;font-size:1.8rem;font-weight:700;display:flex;
                          align-items:center;justify-content:center;flex-shrink:0;
                          box-shadow:0 4px 14px rgba(2,132,199,.3); }
        .profile-header { display:flex;align-items:center;gap:20px;margin-bottom:24px;
                          padding-bottom:20px;border-bottom:1px solid rgba(255,255,255,.08); }
        .info-grid      { display:grid;grid-template-columns:1fr 1fr;gap:20px; }
        .info-item label{ display:block;font-size:.78rem;font-weight:700;color:#94a3b8;
                          text-transform:uppercase;letter-spacing:.05em;margin-bottom:6px; }
        .info-item .val { font-size:.95rem;color:#f1f5f9;font-weight:600; }
        .btn-edit-link  { display:inline-flex;align-items:center;gap:8px;margin-top:24px;
                          padding:10px 24px;background:#0284c7;color:#fff;border-radius:8px;
                          text-decoration:none;font-weight:600;font-size:.9rem;
                          transition:background .2s; box-shadow:0 2px 8px rgba(2,132,199,.3); }
        .btn-edit-link:hover { background:#0369a1; }
    </style>
</head>
<body class="client">
<form id="form1" runat="server">

<aside class="sidebar">
    <div class="sidebar-brand"><h2>Freelancer<span>Hub</span></h2><small>Client Panel</small></div>
    <nav class="sidebar-nav">
        <a href="Dashboard.aspx"><i class="bi bi-speedometer2"></i> <span>Dashboard</span></a>
        <a href="PostProject.aspx"><i class="bi bi-plus-circle"></i> <span>Post New Project</span></a>
        <a href="ManageProjects.aspx"><i class="bi bi-briefcase"></i> <span>Manage Projects</span></a>
        <a href="ViewApplicants.aspx"><i class="bi bi-people"></i> <span>View Applicants</span></a>
        <a href="Messages.aspx"><i class="bi bi-chat-dots"></i> <span>Messages</span></a>
        <a href="Payments.aspx"><i class="bi bi-credit-card"></i> <span>Payments</span></a>
        <a href="ClientProfile.aspx" class="active"><i class="bi bi-person"></i> <span>My Profile</span></a>
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
        <div class="profile-card">

            <div class="profile-header">
                <div class="profile-avatar">
                    <asp:Label ID="lblInitials" runat="server"></asp:Label>
                </div>
                <div>
                    <h2 style="margin:0;font-size:1.25rem;color:#ffffff;font-weight:700;">
                        <asp:Label ID="lblName" runat="server"></asp:Label>
                    </h2>
                    <p style="margin:4px 0;color:#94a3b8;font-size:.85rem;">
                        Client &middot; <asp:Label ID="lblCity" runat="server"></asp:Label>
                    </p>
                </div>
            </div>

            <div class="info-grid">
                <div class="info-item">
                    <label><i class="bi bi-envelope me-1"></i>Email</label>
                    <div class="val"><asp:Label ID="lblEmail" runat="server"></asp:Label></div>
                </div>
                <div class="info-item">
                    <label><i class="bi bi-phone me-1"></i>Mobile</label>
                    <div class="val"><asp:Label ID="lblMobile" runat="server"></asp:Label></div>
                </div>
                <div class="info-item">
                    <label><i class="bi bi-geo-alt me-1"></i>City</label>
                    <div class="val"><asp:Label ID="lblCityDup" runat="server"></asp:Label></div>
                </div>
                <div class="info-item">
                    <label><i class="bi bi-person-badge me-1"></i>Gender</label>
                    <div class="val"><asp:Label ID="lblGender" runat="server"></asp:Label></div>
                </div>
                <div class="info-item" style="grid-column:1/-1;">
                    <label><i class="bi bi-house me-1"></i>Address</label>
                    <div class="val"><asp:Label ID="lblAddress" runat="server"></asp:Label></div>
                </div>
            </div>

            <a href="ProfileSettings.aspx" class="btn-edit-link">
                <i class="bi bi-pencil-square"></i> Edit Profile
            </a>

        </div>
    </div>
</div>

</form>
</body>
</html>
