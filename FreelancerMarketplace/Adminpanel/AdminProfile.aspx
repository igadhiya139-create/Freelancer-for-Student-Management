<%@ Page Title="Admin Profile" Language="C#" AutoEventWireup="true" CodeFile="AdminProfile.aspx.cs" Inherits="AdminPanel_AdminProfile" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Profile</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <link href="../Content/panel.css" rel="stylesheet" />
</head>
<body class="admin">
<form id="form1" runat="server">
<aside class="sidebar">
    <div class="sidebar-brand"><h2>Freelancer<span>Hub</span></h2><small>Admin Panel</small></div>
    <nav class="sidebar-nav">
        <a href="Dashboard.aspx"><i class="bi bi-speedometer2"></i> <span>Dashboard</span></a>
        <a href="ManageUsers.aspx"><i class="bi bi-people"></i> <span>Manage Users</span></a>
        <a href="ManageStudents.aspx"><i class="bi bi-mortarboard"></i> <span>Manage Students</span></a>
        <a href="ManageClients.aspx"><i class="bi bi-building"></i> <span>Manage Clients</span></a>
        <a href="ManageProjects.aspx"><i class="bi bi-briefcase"></i> <span>Manage Projects</span></a>
        <a href="ManageApplications.aspx"><i class="bi bi-file-earmark-check"></i> <span>Applications</span></a>
        <a href="CategoriesSkills.aspx"><i class="bi bi-tags"></i> <span>Categories / Skills</span></a>
        <a href="Reports.aspx"><i class="bi bi-bar-chart"></i> <span>Reports</span></a>
        <a href="SystemSettings.aspx"><i class="bi bi-gear"></i> <span>System Settings</span></a>
        <a href="AdminProfile.aspx" class="active"><i class="bi bi-person"></i> <span>Admin Profile</span></a>
        <a href="ActivityLogs.aspx"><i class="bi bi-clock-history"></i> <span>Activity Logs</span></a>
        <a href="../Logout.aspx"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a>
    </nav>
    <div class="sidebar-footer"><asp:Label ID="lblSidebarName" runat="server"></asp:Label></div>
</aside>
<div class="main">
    <div class="topbar"><h1>Admin Profile</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <div class="card" style="max-width:580px;">
            <div class="profile-header">
                <div class="avatar" style="width:48px; height:48px; font-size:1.1rem; background:linear-gradient(135deg,#818cf8,#4f46e5);">
                    <asp:Label ID="lblAvatarInitials" runat="server">AD</asp:Label>
                </div>
                <div>
                    <h2 style="margin:0; font-size:1.15rem; color:#fff;">
                        <asp:Label ID="lblHeaderName" runat="server">Administrator</asp:Label>
                    </h2>
                    <p style="margin:4px 0; color:#94a3b8; font-size:0.85rem;">
                        <asp:Label ID="lblHeaderEmail" runat="server">admin@freelancer.com</asp:Label> &middot; <span class="badge badge-purple">Admin</span>
                    </p>
                </div>
            </div>

            <div class="form-group">
                <label>Full Name</label>
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Email Address (Account Login)</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ReadOnly="true" style="opacity:0.7;"></asp:TextBox>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Mobile Number</label>
                    <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>City</label>
                    <asp:TextBox ID="txtCity" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>

            <div class="form-group">
                <label>New Password (leave blank to keep current password)</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter new password"></asp:TextBox>
            </div>

            <div style="margin-top:20px; display:flex; gap:10px;">
                <asp:Button ID="btnUpdateProfile" runat="server" Text="Update Profile" CssClass="btn btn-primary" OnClick="btnUpdateProfile_Click" />
                <asp:Button ID="btnReset" runat="server" Text="Cancel" CssClass="btn btn-outline" OnClick="btnReset_Click" />
            </div>
        </div>

    </div>
</div>
</form>
</body>
</html>
