<%@ Page Title="Manage Projects" Language="C#" AutoEventWireup="true" CodeFile="ManageProjects.aspx.cs" Inherits="AdminPanel_ManageProjects" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Projects</title>
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
        <a href="ManageProjects.aspx" class="active"><i class="bi bi-briefcase"></i> <span>Manage Projects</span></a>
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
    <div class="topbar"><h1>Manage Projects</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <asp:Panel ID="pnlProjectDetails" runat="server" Visible="false" CssClass="card" style="border:1px solid rgba(129,140,248,0.35); background:rgba(30,27,75,0.7); margin-bottom:24px;">
            <div class="card-title" style="display:flex; justify-content:space-between; align-items:center;">
                <span><i class="bi bi-briefcase"></i> Project Details: <asp:Label ID="lblDetTitle" runat="server"></asp:Label></span>
                <asp:Button ID="btnCloseDetails" runat="server" Text="Close Details" CssClass="btn btn-outline btn-sm" OnClick="btnCloseDetails_Click" />
            </div>
            <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(200px, 1fr)); gap:16px; margin-top:12px;">
                <div><label style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Project ID</label><div style="color:#fff; font-weight:600;"><asp:Label ID="lblDetId" runat="server"></asp:Label></div></div>
                <div><label style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Client</label><div style="color:#fff;"><asp:Label ID="lblDetClient" runat="server"></asp:Label></div></div>
                <div><label style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Category</label><div style="color:#fff;"><asp:Label ID="lblDetCategory" runat="server"></asp:Label></div></div>
                <div><label style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Budget</label><div style="color:#34d399; font-weight:700;"><asp:Label ID="lblDetBudget" runat="server"></asp:Label></div></div>
                <div><label style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Deadline</label><div style="color:#fff;"><asp:Label ID="lblDetDeadline" runat="server"></asp:Label></div></div>
                <div><label style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Current Status</label><div><asp:Label ID="lblDetStatus" runat="server"></asp:Label></div></div>
                <div><label style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Posted Date</label><div style="color:#fff;"><asp:Label ID="lblDetPostedDate" runat="server"></asp:Label></div></div>
                <div><label style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Required Skills</label><div style="color:#e2e8f0;"><asp:Label ID="lblDetSkills" runat="server"></asp:Label></div></div>
                <div style="grid-column:1 / -1;"><label style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Description</label><div style="color:#cbd5e1; line-height:1.6; white-space:pre-wrap;"><asp:Label ID="lblDetDesc" runat="server"></asp:Label></div></div>
            </div>
            <div style="margin-top:20px; padding-top:16px; border-top:1px solid rgba(255,255,255,0.08); display:flex; gap:12px; align-items:center;">
                <label style="font-size:0.8rem; color:#94a3b8; margin:0;">Change Status:</label>
                <asp:DropDownList ID="ddlChangeStatus" runat="server" CssClass="form-control" style="width:160px;">
                    <asp:ListItem Value="Open">Open</asp:ListItem>
                    <asp:ListItem Value="In Progress">In Progress</asp:ListItem>
                    <asp:ListItem Value="Completed">Completed</asp:ListItem>
                    <asp:ListItem Value="Cancelled">Cancelled</asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="btnUpdateStatus" runat="server" Text="Update Status" CssClass="btn btn-primary btn-sm" OnClick="btnUpdateStatus_Click" />
            </div>
        </asp:Panel>

        <div class="card" style="padding:16px 20px; margin-bottom:20px;">
            <div style="display:flex; flex-wrap:wrap; gap:12px; align-items:center;">
                <div style="flex:1; min-width:220px;">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search projects by title, category or client..."></asp:TextBox>
                </div>
                <div style="width:160px;">
                    <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-control">
                        <asp:ListItem Value="" Text="All Statuses"></asp:ListItem>
                        <asp:ListItem Value="Open" Text="Open"></asp:ListItem>
                        <asp:ListItem Value="In Progress" Text="In Progress"></asp:ListItem>
                        <asp:ListItem Value="Completed" Text="Completed"></asp:ListItem>
                        <asp:ListItem Value="Cancelled" Text="Cancelled"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                <asp:Button ID="btnRefresh" runat="server" Text="Refresh" CssClass="btn btn-outline" OnClick="btnRefresh_Click" />
            </div>
        </div>

        <div class="card">
            <div class="card-title" style="display:flex; justify-content:space-between; align-items:center;">
                <span><i class="bi bi-briefcase"></i> All Projects (<asp:Label ID="lblProjectCount" runat="server">0</asp:Label>)</span>
            </div>

            <div style="overflow-x:auto;">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Project Title</th>
                            <th>Client</th>
                            <th>Category</th>
                            <th>Budget</th>
                            <th>Deadline</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptProjects" runat="server" OnItemCommand="rptProjects_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td>#<%# Eval("ProjectId") %></td>
                                    <td style="font-weight:600; color:#fff;"><%# Eval("Title") %></td>
                                    <td><%# !string.IsNullOrEmpty(Eval("ClientEmail").ToString()) ? Eval("ClientEmail") : Eval("ClientId") %></td>
                                    <td><%# Eval("Category") %></td>
                                    <td style="color:#34d399; font-weight:600;"><%# Eval("Budget") %></td>
                                    <td><%# Eval("Deadline") != DBNull.Value ? Convert.ToDateTime(Eval("Deadline")).ToString("dd MMM yyyy") : "-" %></td>
                                    <td>
                                        <span class='badge <%# Eval("Status").ToString() == "Completed" ? "badge-green" : Eval("Status").ToString() == "In Progress" ? "badge-blue" : Eval("Status").ToString() == "Cancelled" ? "badge-red" : "badge-yellow" %>'>
                                            <%# Eval("Status") %>
                                        </span>
                                    </td>
                                    <td class="action-btns">
                                        <asp:LinkButton ID="btnView" runat="server" CssClass="btn btn-outline btn-sm" CommandName="ViewProject" CommandArgument='<%# Eval("ProjectId") %>'>
                                            <i class="bi bi-eye"></i> View
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-danger btn-sm" CommandName="DeleteProject" CommandArgument='<%# Eval("ProjectId") %>'
                                            OnClientClick="return confirm('Are you sure you want to remove this project? All associated bids/applications will also be removed.');">
                                            <i class="bi bi-trash"></i> Delete
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
                No project records found.
            </asp:Panel>
        </div>

    </div>
</div>
</form>
</body>
</html>
