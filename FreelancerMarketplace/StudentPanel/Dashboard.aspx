<%@ Page Title="Student Dashboard" Language="C#" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="StudentPanel_Dashboard" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <link href="../Content/panel.css" rel="stylesheet" />
</head>
<body class="student">
<form id="form1" runat="server">
<aside class="sidebar">
    <div class="sidebar-brand">
        <h2>Freelancer<span>Hub</span></h2>
        <small>Student Panel</small>
    </div>
    <nav class="sidebar-nav">
        <a href="Dashboard.aspx" class="active"><i class="bi bi-speedometer2"></i> <span>Dashboard</span></a>
        <a href="Profile.aspx"><i class="bi bi-person"></i> <span>My Profile</span></a>
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
    <div class="topbar">
        <h1>Student Dashboard</h1>
        <div class="topbar-right">
            <a href="../Logout.aspx" class="btn-logout">Logout</a>
        </div>
    </div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <div class="welcome-box">
            <div>
                <h2>Welcome, <asp:Label ID="lblWelcomeName" runat="server"></asp:Label>!</h2>
                <p>Your student freelancer dashboard — find projects and grow your skills.</p>
            </div>
            <i class="bi bi-mortarboard" style="font-size:3rem;opacity:.4;"></i>
        </div>
        <div class="stats-row">
            <div class="stat-card">
                <div class="label">Applications</div>
                <div class="value"><asp:Label ID="lblTotalApplications" runat="server">0</asp:Label></div>
            </div>
            <div class="stat-card">
                <div class="label">In Progress</div>
                <div class="value"><asp:Label ID="lblInProgress" runat="server">0</asp:Label></div>
            </div>
            <div class="stat-card">
                <div class="label">Completed</div>
                <div class="value"><asp:Label ID="lblCompleted" runat="server">0</asp:Label></div>
            </div>
            <div class="stat-card">
                <div class="label">Available Projects</div>
                <div class="value"><asp:Label ID="lblAvailableProjects" runat="server">0</asp:Label></div>
            </div>
        </div>
        <div class="grid-2">
            <div class="card">
                <div class="card-title">Recent Applications</div>
                <div class="table-wrap">
                    <asp:Repeater ID="rptRecentApplications" runat="server">
                        <HeaderTemplate>
                            <table class="data-table">
                                <thead><tr><th>Project</th><th>Bid Amount</th><th>Status</th><th>Applied Date</th></tr></thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td><strong><%# Eval("ProjectTitle") %></strong></td>
                                <td>$<%# Eval("BidAmount") %></td>
                                <td>
                                    <span class='<%# Eval("Status").ToString() == "Hired" || Eval("Status").ToString() == "Accepted" ? "badge badge-green" : (Eval("Status").ToString() == "Rejected" ? "badge badge-red" : "badge badge-yellow") %>'>
                                        <%# Eval("Status") %>
                                    </span>
                                </td>
                                <td><%# Eval("AppliedDate") != DBNull.Value ? Convert.ToDateTime(Eval("AppliedDate")).ToString("dd MMM yyyy") : "" %></td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoApplications" runat="server" Visible="false" style="padding:24px; text-align:center; color:#94a3b8;">
                        No applications submitted yet. Browse open projects to submit your first proposal!
                    </asp:Panel>
                </div>
            </div>
            <div class="card">
                <div class="card-title">Quick Actions</div>
                <p style="margin-bottom:12px;font-size:.85rem;color:#94a3b8;">Continue building your profile and find new work.</p>
                <a href="BrowseProjects.aspx" class="btn btn-success" style="margin-right:8px;margin-bottom:8px;"><i class="bi bi-search me-1"></i> Browse Projects</a>
                <a href="SkillsManagement.aspx" class="btn btn-outline" style="margin-right:8px;margin-bottom:8px;"><i class="bi bi-tools me-1"></i> Manage Skills</a>
                <a href="Portfolio.aspx" class="btn btn-outline" style="margin-bottom:8px;"><i class="bi bi-folder2-open me-1"></i> Update Portfolio</a>
            </div>
        </div>
    </div>
</div>
</form>
</body>
</html>
