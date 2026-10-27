<%@ Page Title="Payments" Language="C#" AutoEventWireup="true" CodeFile="Payments.aspx.cs" Inherits="ClientPanel_Payments" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Payments</title>
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
        <a href="ManageProjects.aspx"><i class="bi bi-briefcase"></i> <span>Manage Projects</span></a>
        <a href="ViewApplicants.aspx"><i class="bi bi-people"></i> <span>View Applicants</span></a>
        <a href="Messages.aspx"><i class="bi bi-chat-dots"></i> <span>Messages</span></a>
        <a href="Payments.aspx" class="active"><i class="bi bi-credit-card"></i> <span>Payments</span></a>
        <a href="ClientProfile.aspx"><i class="bi bi-person"></i> <span>My Profile</span></a>
        <a href="Notifications.aspx"><i class="bi bi-bell"></i> <span>Notifications</span></a>
        <a href="ProfileSettings.aspx"><i class="bi bi-gear"></i> <span>Settings</span></a>
        <a href="ChangePassword.aspx"><i class="bi bi-key"></i> <span>Change Password</span></a>
        <a href="../Logout.aspx"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a>
    </nav>
    <div class="sidebar-footer"><asp:Label ID="lblSidebarName" runat="server"></asp:Label></div>
</aside>
<div class="main">
    <div class="topbar"><h1>Payments</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <div class="stats-row">
            <div class="stat-card">
                <div class="label">Total Spent</div>
                <div class="value"><asp:Label ID="lblTotalSpent" runat="server">$0.00</asp:Label></div>
            </div>
            <div class="stat-card">
                <div class="label">Pending</div>
                <div class="value"><asp:Label ID="lblPending" runat="server">$0.00</asp:Label></div>
            </div>
            <div class="stat-card">
                <div class="label">Completed Payments</div>
                <div class="value"><asp:Label ID="lblCompletedCount" runat="server">0</asp:Label></div>
            </div>
        </div>

        <div class="card">
            <div class="card-title"><i class="bi bi-receipt"></i> Recent Transactions</div>

            <asp:Repeater ID="rptPayments" runat="server">
                <HeaderTemplate>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Project</th>
                                <th>Student</th>
                                <th>Amount</th>
                                <th>Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><strong><%# Eval("ProjectTitle") %></strong></td>
                        <td><%# Eval("StudentName") %></td>
                        <td>$<%# Eval("Amount", "{0:N2}") %></td>
                        <td><%# Eval("PaymentDate") != DBNull.Value ? Convert.ToDateTime(Eval("PaymentDate")).ToString("dd MMM yyyy") : "N/A" %></td>
                        <td>
                            <span class='<%# Eval("Status").ToString().Equals("Paid", StringComparison.OrdinalIgnoreCase) || Eval("Status").ToString().Equals("Completed", StringComparison.OrdinalIgnoreCase) ? "badge badge-green" : "badge badge-yellow" %>'>
                                <%# Eval("Status") %>
                            </span>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoPayments" runat="server" Visible="false" style="padding:32px; text-align:center; color:#94a3b8;">
                <i class="bi bi-credit-card-2-front" style="font-size:2.2rem; display:block; margin-bottom:10px;"></i>
                No payment transactions recorded for your account yet.
            </asp:Panel>
        </div>
    </div>
</div>
</form>
</body>
</html>
