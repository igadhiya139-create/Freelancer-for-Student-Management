<%@ Page Title="My Applications" Language="C#" AutoEventWireup="true" CodeFile="MyApplications.aspx.cs" Inherits="StudentPanel_MyApplications" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Applications</title>
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
        <a href="MyApplications.aspx" class="active"><i class="bi bi-file-earmark-text"></i> <span>My Applications</span></a>
        <a href="Notifications.aspx"><i class="bi bi-bell"></i> <span>Notifications</span></a>
        <a href="ProfileSettings.aspx"><i class="bi bi-gear"></i> <span>Settings</span></a>
        <a href="ChangePassword.aspx"><i class="bi bi-key"></i> <span>Change Password</span></a>
        <a href="../Logout.aspx"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a>
    </nav>
    <div class="sidebar-footer"><asp:Label ID="lblSidebarName" runat="server"></asp:Label></div>
</aside>
<div class="main">
    <div class="topbar"><h1>My Applications</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <div class="card">
            <div class="card-title" style="display:flex; justify-content:space-between; align-items:center;">
                <span><i class="bi bi-file-earmark-text me-2" style="color:#34d399;"></i>Application History</span>
                <a href="BrowseProjects.aspx" class="btn btn-success btn-sm"><i class="bi bi-plus-circle me-1"></i> Browse More Projects</a>
            </div>
            <div class="table-wrap">
                <asp:Repeater ID="rptApplications" runat="server" OnItemCommand="rptApplications_ItemCommand">
                    <HeaderTemplate>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Project</th>
                                    <th>Proposed Budget</th>
                                    <th>Timeline</th>
                                    <th>Status</th>
                                    <th>Applied On</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td>
                                <div><strong><%# Eval("ProjectTitle") %></strong></div>
                                <div style="font-size:0.75rem; color:#94a3b8;"><%# Eval("Category") %></div>
                            </td>
                            <td>$<%# Eval("BidAmount") %></td>
                            <td><%# Eval("DeliveryDays") %> days</td>
                            <td>
                                <span class='<%# Eval("Status").ToString() == "Hired" || Eval("Status").ToString() == "Accepted" ? "badge badge-green" : (Eval("Status").ToString() == "Rejected" ? "badge badge-red" : "badge badge-yellow") %>'>
                                    <%# Eval("Status") %>
                                </span>
                            </td>
                            <td><%# Eval("AppliedDate") != DBNull.Value ? Convert.ToDateTime(Eval("AppliedDate")).ToString("dd MMM yyyy") : "N/A" %></td>
                            <td>
                                <div class="action-btns">
                                    <a href='ProjectDetails.aspx?id=<%# Eval("ProjectId") %>' class="btn btn-outline btn-sm">View Project</a>
                                    <a href='ApplyProject.aspx?pid=<%# Eval("ProjectId") %>' class="btn btn-outline btn-sm" style='<%# Eval("Status").ToString() == "Pending" ? "" : "display:none;" %>'>Edit</a>
                                    <asp:LinkButton ID="btnWithdraw" runat="server" CssClass="btn btn-danger btn-sm"
                                        CommandName="cmd_withdraw"
                                        CommandArgument='<%# Eval("AppId") %>'
                                        OnClientClick="return confirm('Withdraw your application for this project?');"
                                        Visible='<%# Eval("Status").ToString() == "Pending" %>'>Withdraw</asp:LinkButton>
                                </div>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlNoApplications" runat="server" Visible="false" style="padding:36px; text-align:center; color:#94a3b8;">
                    <i class="bi bi-inbox" style="font-size:2.2rem; display:block; margin-bottom:12px;"></i>
                    You have not submitted any project applications yet.
                    <div style="margin-top:14px;">
                        <a href="BrowseProjects.aspx" class="btn btn-success">Browse Open Projects</a>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>
</div>
</form>
</body>
</html>
