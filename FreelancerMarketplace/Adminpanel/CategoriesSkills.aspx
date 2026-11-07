<%@ Page Title="Categories / Skills" Language="C#" AutoEventWireup="true" CodeFile="CategoriesSkills.aspx.cs" Inherits="AdminPanel_CategoriesSkills" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Categories / Skills</title>
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
        <a href="CategoriesSkills.aspx" class="active"><i class="bi bi-tags"></i> <span>Categories / Skills</span></a>
        <a href="Reports.aspx"><i class="bi bi-bar-chart"></i> <span>Reports</span></a>
        <a href="SystemSettings.aspx"><i class="bi bi-gear"></i> <span>System Settings</span></a>
        <a href="AdminProfile.aspx"><i class="bi bi-person"></i> <span>Admin Profile</span></a>
        <a href="ActivityLogs.aspx"><i class="bi bi-clock-history"></i> <span>Activity Logs</span></a>
        <a href="../Logout.aspx"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a>
    </nav>
    <div class="sidebar-footer"><asp:Label ID="lblSidebarName" runat="server"></asp:Label></div>
</aside>
<div class="main">
    <div class="topbar">
        <h1>Categories &amp; Skills</h1>
        <div style="display:flex; gap:10px; align-items:center;">
            <asp:Button ID="btnRefresh" runat="server" Text="Refresh All" CssClass="btn btn-outline btn-sm" OnClick="btnRefresh_Click" />
            <a href="../Logout.aspx" class="btn-logout">Logout</a>
        </div>
    </div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <div class="grid-2">

            <div class="card">
                <div class="card-title">
                    <span><i class="bi bi-tags"></i> Categories (<asp:Label ID="lblCategoryCount" runat="server">0</asp:Label>)</span>
                </div>
                <div style="max-height:400px; overflow-y:auto;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Category</th>
                                <th>Projects</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptCategories" runat="server" OnItemCommand="rptCategories_ItemCommand">
                                <ItemTemplate>
                                    <tr>
                                        <td>#<%# Eval("CategoryID") %></td>
                                        <td style="font-weight:600; color:#fff;"><%# Eval("CategoryName") %></td>
                                        <td><%# Eval("ProjectCount") %></td>
                                        <td>
                                            <span class='badge <%# Eval("Status").ToString()=="Active" ? "badge-green" : "badge-gray" %>'>
                                                <%# Eval("Status") %>
                                            </span>
                                        </td>
                                        <td class="action-btns">
                                            <asp:LinkButton ID="btnDelCategory" runat="server" CssClass="btn btn-danger btn-sm"
                                                CommandName="DeleteCategory" CommandArgument='<%# Eval("CategoryID") %>'
                                                OnClientClick="return confirm('Are you sure you want to delete this category?');">
                                                <i class="bi bi-trash"></i>
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>

                <div style="margin-top:16px; padding-top:14px; border-top:1px solid rgba(255,255,255,0.08); display:flex; gap:8px;">
                    <asp:TextBox ID="txtNewCategory" runat="server" CssClass="form-control" placeholder="New category name" style="flex:1;"></asp:TextBox>
                    <asp:Button ID="btnAddCategory" runat="server" Text="Add Category" CssClass="btn btn-primary btn-sm" OnClick="btnAddCategory_Click" />
                </div>
            </div>

            <div class="card">
                <div class="card-title">
                    <span><i class="bi bi-award"></i> Student Skills (<asp:Label ID="lblSkillCount" runat="server">0</asp:Label>)</span>
                </div>
                <div style="max-height:400px; overflow-y:auto;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Skill Name</th>
                                <th>Student</th>
                                <th>Level</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptSkills" runat="server" OnItemCommand="rptSkills_ItemCommand">
                                <ItemTemplate>
                                    <tr>
                                        <td style="font-weight:600; color:#fff;"><%# Eval("SkillName") %></td>
                                        <td><%# !string.IsNullOrEmpty(Eval("StudentEmail").ToString()) ? Eval("StudentEmail") : Eval("StudentId") %></td>
                                        <td>
                                            <span class="badge badge-blue"><%# Eval("SkillLevel") %>%</span>
                                        </td>
                                        <td class="action-btns">
                                            <asp:LinkButton ID="btnDelSkill" runat="server" CssClass="btn btn-danger btn-sm"
                                                CommandName="DeleteSkill" CommandArgument='<%# Eval("SkillId") %>'
                                                OnClientClick="return confirm('Are you sure you want to delete this skill entry?');">
                                                <i class="bi bi-trash"></i>
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>

                <div style="margin-top:16px; padding-top:14px; border-top:1px solid rgba(255,255,255,0.08); display:flex; flex-wrap:wrap; gap:8px;">
                    <asp:TextBox ID="txtNewSkill" runat="server" CssClass="form-control" placeholder="Skill name (e.g. React)" style="flex:2; min-width:140px;"></asp:TextBox>
                    <asp:TextBox ID="txtSkillLevel" runat="server" CssClass="form-control" placeholder="Level %" style="width:75px;" Text="80"></asp:TextBox>
                    <asp:Button ID="btnAddSkill" runat="server" Text="Add Skill" CssClass="btn btn-primary btn-sm" OnClick="btnAddSkill_Click" />
                </div>
            </div>
        </div>

    </div>
</div>
</form>
</body>
</html>
