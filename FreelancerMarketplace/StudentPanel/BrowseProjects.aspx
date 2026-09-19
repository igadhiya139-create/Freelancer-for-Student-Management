<%@ Page Title="Browse Projects" Language="C#" AutoEventWireup="true" CodeFile="BrowseProjects.aspx.cs" Inherits="StudentPanel_BrowseProjects" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Browse Projects</title>
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
        <a href="BrowseProjects.aspx" class="active"><i class="bi bi-search"></i> <span>Browse Projects</span></a>
        <a href="MyApplications.aspx"><i class="bi bi-file-earmark-text"></i> <span>My Applications</span></a>
        <a href="Notifications.aspx"><i class="bi bi-bell"></i> <span>Notifications</span></a>
        <a href="ProfileSettings.aspx"><i class="bi bi-gear"></i> <span>Settings</span></a>
        <a href="ChangePassword.aspx"><i class="bi bi-key"></i> <span>Change Password</span></a>
        <a href="../Logout.aspx"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a>
    </nav>
    <div class="sidebar-footer"><asp:Label ID="lblSidebarName" runat="server"></asp:Label></div>
</aside>
<div class="main">
    <div class="topbar"><h1>Browse Projects</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <div class="card">
            <div class="form-row" style="margin-bottom:16px; display:flex; gap:12px; align-items:center; flex-wrap:wrap;">
                <div class="form-group" style="margin:0; flex:1 1 240px;">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by project title or skills..."></asp:TextBox>
                </div>
                <div class="form-group" style="margin:0; flex:0 1 200px;">
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                        <asp:ListItem Value="">All Categories</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div style="display:flex; gap:8px;">
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-success" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-outline" OnClick="btnReset_Click" />
                </div>
            </div>

            <div class="table-wrap">
                <asp:Repeater ID="rptProjects" runat="server">
                    <HeaderTemplate>
                        <table class="data-table">
                            <thead><tr><th>Project</th><th>Category</th><th>Budget</th><th>Skills</th><th>Posted</th><th>Action</th></tr></thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><strong><%# Eval("Title") %></strong></td>
                            <td><span class="badge badge-blue"><%# Eval("Category") %></span></td>
                            <td>$<%# Eval("Budget") %></td>
                            <td><small style="color:#94a3b8;"><%# Eval("Skills") %></small></td>
                            <td><%# Eval("PostedDate") != DBNull.Value ? Convert.ToDateTime(Eval("PostedDate")).ToString("dd MMM yyyy") : "N/A" %></td>
                            <td><a href='ProjectDetails.aspx?id=<%# Eval("ProjectId") %>' class="btn btn-success btn-sm">View Details</a></td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlNoProjects" runat="server" Visible="false" style="padding:32px; text-align:center; color:#94a3b8;">
                    <i class="bi bi-search" style="font-size:2rem; display:block; margin-bottom:10px;"></i>
                    No projects found matching your search criteria.
                </asp:Panel>
            </div>
        </div>
    </div>
</div>
</form>
</body>
</html>
