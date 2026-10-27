<%@ Page Title="Manage Projects" Language="C#" AutoEventWireup="true" CodeFile="ManageProjects.aspx.cs" Inherits="ClientPanel_ManageProjects" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Projects</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <link href="../Content/panel.css" rel="stylesheet" />
</head>
<body class="client">
<form id="form1" runat="server">
<aside class="sidebar">
    <div class="sidebar-brand"><h2>Freelancer<span>Hub</span></h2><small>Client Panel</small></div>
    <nav class="sidebar-nav">
        <a href="Dashboard.aspx"><i class="bi bi-speedometer2"></i> <span>Dashboard</span></a>
        <a href="PostProject.aspx"><i class="bi bi-plus-circle"></i> <span>Post New Project</span></a>
        <a href="ManageProjects.aspx" class="active"><i class="bi bi-briefcase"></i> <span>Manage Projects</span></a>
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
    <div class="topbar"><h1>My Projects</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <div class="card" style="padding:16px 20px; margin-bottom:20px;">
            <div style="display:flex; flex-wrap:wrap; gap:12px; align-items:center;">
                <div style="flex:1; min-width:220px;">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search my projects by title or category..."></asp:TextBox>
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
                <a href="PostProject.aspx" class="btn btn-primary" style="margin-left:auto;"><i class="bi bi-plus-lg"></i> Post New Project</a>
            </div>
        </div>

        <div class="card">
            <div class="card-title" style="display:flex; justify-content:space-between; align-items:center;">
                <span><i class="bi bi-briefcase"></i> Posted Projects (<asp:Label ID="lblProjectCount" runat="server">0</asp:Label>)</span>
            </div>

            <div style="overflow-x:auto;">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Project Title</th>
                            <th>Category</th>
                            <th>Budget</th>
                            <th>Deadline</th>
                            <th>Status</th>
                            <th>Applicants</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptProjects" runat="server" OnItemCommand="rptProjects_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td style="font-weight:600; color:#fff;">
                                        <a href='ProjectDetails.aspx?id=<%# Eval("ProjectId") %>' style="color:#e2e8f0; text-decoration:none;">
                                            <%# Eval("Title") %>
                                        </a>
                                    </td>
                                    <td><%# Eval("Category") %></td>
                                    <td style="color:#34d399; font-weight:600;">$<%# Eval("Budget") %></td>
                                    <td><%# Eval("Deadline") != DBNull.Value ? Convert.ToDateTime(Eval("Deadline")).ToString("dd MMM yyyy") : "-" %></td>
                                    <td>
                                        <span class='badge <%# Eval("Status").ToString() == "Completed" ? "badge-green" : Eval("Status").ToString() == "In Progress" ? "badge-blue" : Eval("Status").ToString() == "Cancelled" ? "badge-red" : "badge-yellow" %>'>
                                            <%# Eval("Status") %>
                                        </span>
                                    </td>
                                    <td>
                                        <a href='ViewApplicants.aspx?projectId=<%# Eval("ProjectId") %>' style="color:#38bdf8; text-decoration:none; font-weight:600;">
                                            <%# Eval("ApplicantCount") %> applicants
                                        </a>
                                    </td>
                                    <td class="action-btns">
                                        <a href='ViewApplicants.aspx?projectId=<%# Eval("ProjectId") %>' class="btn btn-primary btn-sm">
                                            <i class="bi bi-people"></i> Applicants
                                        </a>
                                        <a href='ProjectDetails.aspx?id=<%# Eval("ProjectId") %>' class="btn btn-outline btn-sm">
                                            <i class="bi bi-pencil-square"></i> Details / Edit
                                        </a>
                                        <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-danger btn-sm" CommandName="DeleteProject" CommandArgument='<%# Eval("ProjectId") %>'
                                            OnClientClick="return confirm('Are you sure you want to delete this project? All associated applications will also be removed.');">
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
                No projects found. Click <strong>Post New Project</strong> to create your first project.
            </asp:Panel>
        </div>

    </div>
</div>
</form>
</body>
</html>
