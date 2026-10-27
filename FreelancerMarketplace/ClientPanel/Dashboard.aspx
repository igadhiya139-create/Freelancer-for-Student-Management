<%@ Page Title="Client Dashboard" Language="C#" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="ClientPanel_Dashboard" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Client Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <link href="../Content/panel.css" rel="stylesheet" />
</head>
<body class="client">
<form id="form1" runat="server">
<aside class="sidebar">
    <div class="sidebar-brand"><h2>Freelancer<span>Hub</span></h2><small>Client Panel</small></div>
    <nav class="sidebar-nav">
        <a href="Dashboard.aspx" class="active"><i class="bi bi-speedometer2"></i> <span>Dashboard</span></a>
        <a href="PostProject.aspx"><i class="bi bi-plus-circle"></i> <span>Post New Project</span></a>
        <a href="ManageProjects.aspx"><i class="bi bi-briefcase"></i> <span>Manage Projects</span></a>
        <a href="ViewApplicants.aspx"><i class="bi bi-people"></i> <span>View Applicants</span></a>
        <a href="Messages.aspx"><i class="bi bi-chat-dots"></i> <span>Messages</span></a>
        <a href="Payments.aspx"><i class="bi bi-credit-card"></i> <span>Payments</span></a>
        <a href="ClientProfile.aspx"><i class="bi bi-person"></i> <span>My Profile</span></a>
        <a href="Notifications.aspx"><i class="bi bi-bell"></i> <span>Notifications</span></a>
        <a href="ProfileSettings.aspx"><i class="bi bi-gear"></i> <span>Settings</span></a>
        <a href="ChangePassword.aspx"><i class="bi bi-key"></i> <span>Change Password</span></a>
        <a href="../Logout.aspx"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a>
    </nav>
    <div class="sidebar-footer"><asp:Label ID="lblSidebarName" runat="server"></asp:Label></div>
</aside>
<div class="main">
    <div class="topbar"><h1>Client Dashboard</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">
        <div class="welcome-box">
            <div><h2>Welcome, <asp:Label ID="lblWelcomeName" runat="server"></asp:Label>!</h2><p>Manage your projects, review applicants, and hire talented students.</p></div>
            <i class="bi bi-briefcase" style="font-size:3rem;opacity:.4;"></i>
        </div>

        <div class="stats-row">
            <div class="stat-card">
                <div class="label">Active Projects</div>
                <div class="value"><asp:Label ID="lblActiveProjects" runat="server">0</asp:Label></div>
                <div class="sub">Open &amp; In Progress</div>
            </div>
            <div class="stat-card">
                <div class="label">Total Applicants</div>
                <div class="value" style="color:#38bdf8;"><asp:Label ID="lblTotalApplicants" runat="server">0</asp:Label></div>
                <div class="sub">Across all projects</div>
            </div>
            <div class="stat-card">
                <div class="label">Completed Projects</div>
                <div class="value" style="color:#34d399;"><asp:Label ID="lblCompletedProjects" runat="server">0</asp:Label></div>
                <div class="sub">Finished successfully</div>
            </div>
            <div class="stat-card">
                <div class="label">Total Spent</div>
                <div class="value" style="color:#fbbf24;"><asp:Label ID="lblTotalSpent" runat="server">$0</asp:Label></div>
                <div class="sub">Completed payments</div>
            </div>
        </div>

        <div class="grid-2">

            <div class="card">
                <div class="card-title" style="display:flex; justify-content:space-between; align-items:center;">
                    <span><i class="bi bi-briefcase"></i> My Recent Projects</span>
                    <a href="ManageProjects.aspx" class="btn btn-outline btn-sm">View All &rarr;</a>
                </div>
                <div style="overflow-x:auto;">
                    <table class="data-table">
                        <thead><tr><th>Project</th><th>Budget</th><th>Status</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptRecentProjects" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td style="font-weight:600; color:#fff;">
                                            <a href='ProjectDetails.aspx?id=<%# Eval("ProjectId") %>' style="color:#e2e8f0; text-decoration:none;">
                                                <%# Eval("Title") %>
                                            </a>
                                        </td>
                                        <td style="color:#34d399;"><%# Eval("Budget") %></td>
                                        <td>
                                            <span class='badge <%# Eval("Status").ToString() == "Completed" ? "badge-green" : Eval("Status").ToString() == "In Progress" ? "badge-blue" : Eval("Status").ToString() == "Cancelled" ? "badge-red" : "badge-yellow" %>'>
                                                <%# Eval("Status") %>
                                            </span>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
                <asp:Panel ID="pnlNoProjects" runat="server" Visible="false" style="padding:20px; text-align:center; color:#94a3b8;">
                    No projects posted yet. Click <strong>Post New Project</strong> to get started.
                </asp:Panel>
            </div>

            <div class="card">
                <div class="card-title" style="display:flex; justify-content:space-between; align-items:center;">
                    <span><i class="bi bi-people"></i> Recent Applicants</span>
                    <a href="ViewApplicants.aspx" class="btn btn-outline btn-sm">View All &rarr;</a>
                </div>
                <div style="overflow-x:auto;">
                    <table class="data-table">
                        <thead><tr><th>Student</th><th>Project</th><th>Bid</th><th>Status</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptRecentApplicants" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td style="font-weight:600; color:#fff;"><%# Eval("StudentName") %></td>
                                        <td><%# Eval("ProjectTitle") %></td>
                                        <td style="color:#34d399;">$<%# Eval("BidAmount") %></td>
                                        <td>
                                            <span class='badge <%# Eval("Status").ToString() == "Hired" ? "badge-green" : Eval("Status").ToString() == "Rejected" ? "badge-red" : "badge-yellow" %>'>
                                                <%# Eval("Status") %>
                                            </span>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
                <asp:Panel ID="pnlNoApplicants" runat="server" Visible="false" style="padding:20px; text-align:center; color:#94a3b8;">
                    No applicants received yet.
                </asp:Panel>

                <div style="margin-top:20px; padding-top:16px; border-top:1px solid rgba(255,255,255,0.08); display:flex; gap:10px;">
                    <a href="PostProject.aspx" class="btn btn-primary btn-sm"><i class="bi bi-plus-circle"></i> Post New Project</a>
                    <a href="ViewApplicants.aspx" class="btn btn-outline btn-sm"><i class="bi bi-people"></i> View Applicants</a>
                </div>
            </div>
        </div>
    </div>
</div>
</form>
</body>
</html>
