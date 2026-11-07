<%@ Page Title="Manage Clients" Language="C#" AutoEventWireup="true" CodeFile="ManageClients.aspx.cs" Inherits="AdminPanel_ManageClients" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Clients</title>
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
        <a href="ManageClients.aspx" class="active"><i class="bi bi-building"></i> <span>Manage Clients</span></a>
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
    <div class="topbar"><h1>Manage Clients</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <asp:Panel ID="pnlClientDetails" runat="server" Visible="false" CssClass="card" style="border:1px solid rgba(56,189,248,0.35); background:rgba(3,105,161,0.2); margin-bottom:24px;">
            <div class="card-title" style="display:flex; justify-content:space-between; align-items:center;">
                <span><i class="bi bi-building"></i> Client Profile (<asp:Label ID="lblDetName" runat="server"></asp:Label>)</span>
                <asp:Button ID="btnCloseDetails" runat="server" Text="Close Details" CssClass="btn btn-outline btn-sm" OnClick="btnCloseDetails_Click" />
            </div>
            <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(200px, 1fr)); gap:16px; margin-top:12px;">
                <div><label style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Client ID</label><div style="color:#fff; font-weight:600;"><asp:Label ID="lblDetId" runat="server"></asp:Label></div></div>
                <div><label style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Company / Client Name</label><div style="color:#fff; font-weight:600;"><asp:Label ID="lblDetFullName" runat="server"></asp:Label></div></div>
                <div><label style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Email Address</label><div style="color:#fff; font-weight:600;"><asp:Label ID="lblDetEmail" runat="server"></asp:Label></div></div>
                <div><label style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Gender</label><div style="color:#fff;"><asp:Label ID="lblDetGender" runat="server"></asp:Label></div></div>
                <div><label style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">City</label><div style="color:#fff;"><asp:Label ID="lblDetCity" runat="server"></asp:Label></div></div>
                <div><label style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Mobile</label><div style="color:#fff;"><asp:Label ID="lblDetMobile" runat="server"></asp:Label></div></div>
                <div><label style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Registered Date</label><div style="color:#fff;"><asp:Label ID="lblDetDate" runat="server"></asp:Label></div></div>
                <div style="grid-column:1 / -1;"><label style="font-size:0.75rem; color:#94a3b8; text-transform:uppercase;">Address</label><div style="color:#cbd5e1;"><asp:Label ID="lblDetAddress" runat="server"></asp:Label></div></div>
            </div>
        </asp:Panel>

        <div class="card" style="padding:16px 20px; margin-bottom:20px;">
            <div style="display:flex; flex-wrap:wrap; gap:12px; align-items:center;">
                <div style="flex:1; min-width:220px;">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search clients by name, email or city..."></asp:TextBox>
                </div>
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                <asp:Button ID="btnRefresh" runat="server" Text="Refresh" CssClass="btn btn-outline" OnClick="btnRefresh_Click" />
            </div>
        </div>

        <div class="card">
            <div class="card-title" style="display:flex; justify-content:space-between; align-items:center;">
                <span><i class="bi bi-building"></i> Registered Clients (<asp:Label ID="lblClientCount" runat="server">0</asp:Label>)</span>
            </div>

            <div style="overflow-x:auto;">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name / Company</th>
                            <th>Email</th>
                            <th>Gender</th>
                            <th>City</th>
                            <th>Mobile</th>
                            <th>Registered</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptClients" runat="server" OnItemCommand="rptClients_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td>#<%# Eval("Id") %></td>
                                    <td style="font-weight:600; color:#fff;"><%# Eval("Name") %></td>
                                    <td><%# Eval("Email") %></td>
                                    <td><%# Eval("Gender") %></td>
                                    <td><%# Eval("City") %></td>
                                    <td><%# Eval("Mobile") %></td>
                                    <td><%# Eval("CreatedDate") != DBNull.Value ? Convert.ToDateTime(Eval("CreatedDate")).ToString("dd MMM yyyy") : "-" %></td>
                                    <td class="action-btns">
                                        <asp:LinkButton ID="btnView" runat="server" CssClass="btn btn-outline btn-sm" CommandName="ViewClient" CommandArgument='<%# Eval("Id") %>'>
                                            <i class="bi bi-eye"></i> View
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-danger btn-sm" CommandName="DeleteClient" CommandArgument='<%# Eval("Id") %>'
                                            OnClientClick="return confirm('Are you sure you want to delete this client account?');">
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
                No client records found.
            </asp:Panel>
        </div>

    </div>
</div>
</form>
</body>
</html>
