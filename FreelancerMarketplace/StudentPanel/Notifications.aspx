<%@ Page Title="Notifications" Language="C#" AutoEventWireup="true" CodeFile="Notifications.aspx.cs" Inherits="StudentPanel_Notifications" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Notifications</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <link href="../Content/panel.css" rel="stylesheet" />
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
        <a href="Notifications.aspx" class="active"><i class="bi bi-bell"></i> <span>Notifications</span></a>
        <a href="ProfileSettings.aspx"><i class="bi bi-gear"></i> <span>Settings</span></a>
        <a href="ChangePassword.aspx"><i class="bi bi-key"></i> <span>Change Password</span></a>
        <a href="../Logout.aspx"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a>
    </nav>
    <div class="sidebar-footer"><asp:Label ID="lblSidebarName" runat="server"></asp:Label></div>
</aside>
<div class="main">
    <div class="topbar"><h1>Notifications</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <div class="card">
            <div class="card-title" style="display:flex; justify-content:space-between; align-items:center;">
                <span><i class="bi bi-bell me-2" style="color:#34d399;"></i>Recent Notifications</span>
                <asp:LinkButton ID="btnMarkAllRead" runat="server" CssClass="btn btn-outline btn-sm" OnClick="btnMarkAllRead_Click">
                    <i class="bi bi-check2-all me-1"></i> Mark All as Read
                </asp:LinkButton>
            </div>

            <asp:Repeater ID="rptNotifications" runat="server">
                <ItemTemplate>
                    <div class="notif-item">
                        <div class="notif-dot" style='<%# Convert.ToBoolean(Eval("IsRead")) ? "background:#64748b;" : "background:#34d399;" %>'></div>
                        <div style="flex:1;">
                            <div class="notif-text"><%# Eval("Message") %></div>
                            <div class="notif-time"><%# Eval("CreatedDate") != DBNull.Value ? Convert.ToDateTime(Eval("CreatedDate")).ToString("dd MMM yyyy, hh:mm tt") : "" %></div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoNotif" runat="server" Visible="false" style="padding:32px; text-align:center; color:#94a3b8;">
                <i class="bi bi-bell-slash" style="font-size:2rem; display:block; margin-bottom:10px;"></i>
                No notifications found.
            </asp:Panel>
        </div>
    </div>
</div>
</form>
</body>
</html>
