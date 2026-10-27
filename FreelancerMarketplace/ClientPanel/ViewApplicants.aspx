<%@ Page Title="View Applicants" Language="C#" AutoEventWireup="true"
         CodeFile="ViewApplicants.aspx.cs" Inherits="ClientPanel_ViewApplicants" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>View Applicants</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <link href="../Content/panel.css" rel="stylesheet" />
    <style>
        .grid-wrapper  { overflow-x:auto; }
        .grid-table    { width:100%;border-collapse:collapse;font-size:.88rem; }
        .grid-table th { background:rgba(255,255,255,0.06);color:#94a3b8;padding:12px 14px;
                         text-align:left;font-weight:600;font-size:0.75rem;text-transform:uppercase;letter-spacing:0.05em;border-bottom:1px solid rgba(255,255,255,0.08); }
        .grid-table td { padding:12px 14px;border-bottom:1px solid rgba(255,255,255,0.05);vertical-align:middle;color:#cbd5e1; }
        .grid-table tr:hover td { background:rgba(255,255,255,0.03); }
        .badge-pending { background:rgba(251,191,36,0.15);color:#fbbf24;padding:3px 10px;
                         border-radius:99px;font-size:.75rem;font-weight:700;display:inline-block; }
        .badge-hired   { background:rgba(52,211,153,0.15);color:#34d399;padding:3px 10px;
                         border-radius:99px;font-size:.75rem;font-weight:700;display:inline-block; }
        .badge-rejected{ background:rgba(248,113,113,0.15);color:#f87171;padding:3px 10px;
                         border-radius:99px;font-size:.75rem;font-weight:700;display:inline-block; }
        .btn-view      { background:rgba(56,189,248,0.15);color:#38bdf8;border:1px solid rgba(56,189,248,0.3);border-radius:6px;
                         padding:5px 12px;cursor:pointer;font-size:.8rem;font-weight:600;
                         text-decoration:none;display:inline-block;transition:0.2s; }
        .btn-view:hover{ background:rgba(56,189,248,0.25); }
    </style>
</head>
<body class="client">
<form id="form1" runat="server">

<aside class="sidebar">
    <div class="sidebar-brand"><h2>Freelancer<span>Hub</span></h2><small>Client Panel</small></div>
    <nav class="sidebar-nav">
        <a href="Dashboard.aspx"><i class="bi bi-speedometer2"></i> <span>Dashboard</span></a>
        <a href="PostProject.aspx"><i class="bi bi-plus-circle"></i> <span>Post New Project</span></a>
        <a href="ManageProjects.aspx"><i class="bi bi-briefcase"></i> <span>Manage Projects</span></a>
        <a href="ViewApplicants.aspx" class="active"><i class="bi bi-people"></i> <span>View Applicants</span></a>
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
    <div class="topbar"><h1>View Applicants &amp; Proposals</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <div class="card" style="padding:16px 20px; margin-bottom:20px;">
            <div style="display:flex; flex-wrap:wrap; gap:12px; align-items:center;">
                <div style="flex:1; min-width:200px;">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by student name or email..."></asp:TextBox>
                </div>
                <div style="width:200px;">
                    <asp:DropDownList ID="ddlProjectFilter" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>
                <div style="width:140px;">
                    <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-control">
                        <asp:ListItem Value="" Text="All Statuses"></asp:ListItem>
                        <asp:ListItem Value="Pending" Text="Pending"></asp:ListItem>
                        <asp:ListItem Value="Hired" Text="Hired"></asp:ListItem>
                        <asp:ListItem Value="Rejected" Text="Rejected"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <asp:Button ID="btnSearch" runat="server" Text="Filter" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                <asp:Button ID="btnRefresh" runat="server" Text="Refresh" CssClass="btn btn-outline" OnClick="btnRefresh_Click" />
            </div>
        </div>

        <div class="card">
            <div class="card-title" style="display:flex; justify-content:space-between; align-items:center;">
                <span><i class="bi bi-people" style="color:#38bdf8;"></i> Applicants (<asp:Label ID="lblCount" runat="server">0</asp:Label>)</span>
            </div>
            <div class="grid-wrapper">

                <asp:GridView ID="gvApplicants" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="grid-table"
                    EmptyDataText="No applicants found matching your filter criteria."
                    DataKeyNames="AppId"
                    OnRowCommand="gvApplicants_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="StudentName"   HeaderText="Student" ItemStyle-Font-Bold="true" ItemStyle-ForeColor="#ffffff" />
                        <asp:BoundField DataField="ProjectTitle"  HeaderText="Project" />
                        <asp:BoundField DataField="BidAmount"     HeaderText="Bid ($)" DataFormatString="${0:N2}" ItemStyle-ForeColor="#34d399" ItemStyle-Font-Bold="true" />
                        <asp:BoundField DataField="DeliveryDays"  HeaderText="Days" ItemStyle-HorizontalAlign="Center" />

                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='<%# ((string)Eval("Status") == "Hired") ? "badge-hired" :
                                                  ((string)Eval("Status") == "Rejected") ? "badge-rejected" :
                                                  "badge-pending" %>'>
                                    <%# Eval("Status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div style="display:flex; gap:6px; align-items:center;">
                                    <a href='ApplicantProfile.aspx?appId=<%# Eval("AppId") %>' class="btn-view">
                                        <i class="bi bi-eye"></i> View Profile
                                    </a>
                                    <asp:LinkButton ID="btnHire" runat="server" CssClass="btn btn-success btn-sm" CommandName="HireStudent" CommandArgument='<%# Eval("AppId") %>'
                                        Visible='<%# Eval("Status").ToString() == "Pending" %>'
                                        OnClientClick="return confirm('Are you sure you want to hire this student?');">
                                        <i class="bi bi-check"></i> Hire
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnReject" runat="server" CssClass="btn btn-warning btn-sm" CommandName="RejectStudent" CommandArgument='<%# Eval("AppId") %>'
                                        Visible='<%# Eval("Status").ToString() == "Pending" %>'
                                        OnClientClick="return confirm('Are you sure you want to reject this proposal?');">
                                        <i class="bi bi-x"></i> Reject
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>

            </div>
        </div>

    </div>
</div>

</form>
</body>
</html>
