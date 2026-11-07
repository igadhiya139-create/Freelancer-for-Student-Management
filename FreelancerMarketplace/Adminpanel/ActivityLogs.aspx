<%@ Page Title="Activity Logs" Language="C#" AutoEventWireup="true" CodeFile="ActivityLogs.aspx.cs" Inherits="AdminPanel_ActivityLogs" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Activity Logs</title>
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
        <a href="AdminProfile.aspx"><i class="bi bi-person"></i> <span>Admin Profile</span></a>
        <a href="ActivityLogs.aspx" class="active"><i class="bi bi-clock-history"></i> <span>Activity Logs</span></a>
        <a href="../Logout.aspx"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a>
    </nav>
    <div class="sidebar-footer"><asp:Label ID="lblSidebarName" runat="server"></asp:Label></div>
</aside>
<div class="main">
    <div class="topbar"><h1>Activity Logs</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <div class="card" style="padding:16px 20px; margin-bottom:20px;">
            <div style="display:flex; flex-wrap:wrap; gap:12px; align-items:center;">
                <div style="flex:1; min-width:220px;">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search activity logs..."></asp:TextBox>
                </div>
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                <asp:Button ID="btnRefresh" runat="server" Text="Refresh" CssClass="btn btn-outline" OnClick="btnRefresh_Click" />
                <asp:Button ID="btnClearLogs" runat="server" Text="Clear All Logs" CssClass="btn btn-danger" OnClick="btnClearLogs_Click"
                    OnClientClick="return confirm('Are you sure you want to permanently clear all activity logs?');" />
            </div>
        </div>

        <div class="card">
            <div class="card-title" style="display:flex; justify-content:space-between; align-items:center;">
                <span><i class="bi bi-clock-history"></i> Recent Activity Logs (<asp:Label ID="lblLogCount" runat="server">0</asp:Label>)</span>
            </div>

            <div style="overflow-x:auto;">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th style="width:70px;">ID</th>
                            <th>Activity Details</th>
                            <th style="width:200px;">Date &amp; Time</th>
                            <th style="width:80px;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptLogs" runat="server" OnItemCommand="rptLogs_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td>#<%# Eval("LogId") %></td>
                                    <td style="color:#e2e8f0;"><%# Eval("Activity") %></td>
                                    <td style="color:#94a3b8;"><%# Eval("ActivityDate") != DBNull.Value ? Convert.ToDateTime(Eval("ActivityDate")).ToString("dd MMM yyyy, hh:mm tt") : "-" %></td>
                                    <td class="action-btns">
                                        <asp:LinkButton ID="btnDelLog" runat="server" CssClass="btn btn-danger btn-sm"
                                            CommandName="DeleteLog" CommandArgument='<%# Eval("LogId") %>'
                                            OnClientClick="return confirm('Delete this log entry?');">
                                            <i class="bi bi-trash"></i>
                                        </asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>

            <asp:Panel ID="pnlNoData" runat="server" Visible="false" style="text-align:center; padding:32px; color:#94a3b8;">
                <i class="bi bi-inbox" style="font-size:2rem; display:block; margin-bottom:8px;"></i>
                No activity logs found.
            </asp:Panel>
        </div>

    </div>
</div>
</form>
</body>
</html>
