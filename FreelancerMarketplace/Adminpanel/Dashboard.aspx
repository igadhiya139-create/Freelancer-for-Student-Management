<%@ Page Title="Admin Dashboard" Language="C#" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="AdminPanel_Dashboard" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <link href="../Content/panel.css" rel="stylesheet" />
</head>
<body class="admin">
<form id="form1" runat="server">
<aside class="sidebar">
    <div class="sidebar-brand"><h2>Freelancer<span>Hub</span></h2><small>Admin Panel</small></div>
    <nav class="sidebar-nav">
        <a href="Dashboard.aspx" class="active"><i class="bi bi-speedometer2"></i> <span>Dashboard</span></a>
        <a href="ManageUsers.aspx"><i class="bi bi-people"></i> <span>Manage Users</span></a>
        <a href="ManageStudents.aspx"><i class="bi bi-mortarboard"></i> <span>Manage Students</span></a>
        <a href="ManageClients.aspx"><i class="bi bi-building"></i> <span>Manage Clients</span></a>
        <a href="ManageProjects.aspx"><i class="bi bi-briefcase"></i> <span>Manage Projects</span></a>
        <a href="ManageApplications.aspx"><i class="bi bi-file-earmark-check"></i> <span>Applications</span></a>
        <a href="CategoriesSkills.aspx"><i class="bi bi-tags"></i> <span>Categories / Skills</span></a>
        <a href="Reports.aspx"><i class="bi bi-bar-chart"></i> <span>Reports</span></a>
        <a href="SystemSettings.aspx"><i class="bi bi-gear"></i> <span>System Settings</span></a>
        <a href="AdminProfile.aspx"><i class="bi bi-person"></i> <span>Admin Profile</span></a>
        <a href="ActivityLogs.aspx"><i class="bi bi-clock-history"></i> <span>Activity Logs</span></a>
        <a href="../Logout.aspx"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a>
    </nav>
    <div class="sidebar-footer"><asp:Label ID="lblSidebarName" runat="server"></asp:Label></div>
</aside>
<div class="main">
    <div class="topbar"><h1>Admin Dashboard</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">
        <div class="welcome-box">
            <div><h2>Welcome, <asp:Label ID="lblWelcomeName" runat="server"></asp:Label>!</h2><p>Overview of the Freelancer Marketplace platform.</p></div>
            <i class="bi bi-shield-lock" style="font-size:3rem;opacity:.4;"></i>
        </div>
        <div class="stats-row">
            <div class="stat-card"><div class="label">Total Users</div><div class="value"><asp:Label ID="lblUsers" runat="server">0</asp:Label></div></div>
            <div class="stat-card"><div class="label">Students</div><div class="value"><asp:Label ID="lblStudents" runat="server">0</asp:Label></div></div>
            <div class="stat-card"><div class="label">Clients</div><div class="value"><asp:Label ID="lblClients" runat="server">0</asp:Label></div></div>
            <div class="stat-card"><div class="label">Projects</div><div class="value"><asp:Label ID="lblProjects" runat="server">0</asp:Label></div></div>
            <div class="stat-card"><div class="label">Bids / Apps</div><div class="value"><asp:Label ID="lblApplications" runat="server">0</asp:Label></div></div>
            <div class="stat-card"><div class="label">Revenue</div><div class="value"><asp:Label ID="lblRevenue" runat="server">$0</asp:Label></div></div>
        </div>
        <div class="grid-2">
            <div class="card">
                <div class="card-title">Projects & System Status</div>
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px; margin-top:10px;">
                    <div style="background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.06); border-radius:10px; padding:12px;">
                        <div style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Open Projects</div>
                        <div style="font-size:1.3rem; font-weight:700; color:#38bdf8; margin-top:4px;"><asp:Label ID="lblOpenProjects" runat="server">0</asp:Label></div>
                    </div>
                    <div style="background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.06); border-radius:10px; padding:12px;">
                        <div style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">In Progress</div>
                        <div style="font-size:1.3rem; font-weight:700; color:#fbbf24; margin-top:4px;"><asp:Label ID="lblInProgressProjects" runat="server">0</asp:Label></div>
                    </div>
                    <div style="background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.06); border-radius:10px; padding:12px;">
                        <div style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Completed</div>
                        <div style="font-size:1.3rem; font-weight:700; color:#34d399; margin-top:4px;"><asp:Label ID="lblCompletedProjects" runat="server">0</asp:Label></div>
                    </div>
                    <div style="background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.06); border-radius:10px; padding:12px;">
                        <div style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Categories</div>
                        <div style="font-size:1.3rem; font-weight:700; color:#818cf8; margin-top:4px;"><asp:Label ID="lblTotalCategories" runat="server">0</asp:Label></div>
                    </div>
                </div>
                <div style="margin-top:16px; text-align:right;">
                    <a href="ManageProjects.aspx" class="btn btn-outline btn-sm">Manage Projects &rarr;</a>
                </div>
            </div>
            <div class="card">
                <div class="card-title">Recent Users</div>
                <table class="data-table">
                    <thead><tr><th>Name</th><th>Role</th><th>Email</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptRecentUsers" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("Name") %></td>
                                    <td>
                                        <span class='badge <%# Eval("Role").ToString() == "Admin" ? "badge-purple" : Eval("Role").ToString() == "Client" ? "badge-blue" : "badge-green" %>'>
                                            <%# Eval("Role") %>
                                        </span>
                                    </td>
                                    <td><%# Eval("Email") %></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
                <div style="margin-top:16px; text-align:right;">
                    <a href="ManageUsers.aspx" class="btn btn-outline btn-sm">View All Users &rarr;</a>
                </div>
            </div>
        </div>
    </div>
</div>
</form>
</body>
</html>
