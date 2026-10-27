<%@ Page Title="Messages" Language="C#" AutoEventWireup="true" CodeFile="Messages.aspx.cs" Inherits="ClientPanel_Messages" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Messages</title>
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
        <a href="Messages.aspx" class="active"><i class="bi bi-chat-dots"></i> <span>Messages</span></a>
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
    <div class="topbar"><h1>Messages &amp; Communication</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <div class="grid-2">

            <div class="card">
                <div class="card-title">
                    <span><i class="bi bi-people"></i> Contacts / Applicants</span>
                </div>
                <div style="max-height:450px; overflow-y:auto;">
                    <asp:Repeater ID="rptContacts" runat="server" OnItemCommand="rptContacts_ItemCommand">
                        <ItemTemplate>
                            <div style="padding:12px; border-bottom:1px solid rgba(255,255,255,0.06); display:flex; justify-content:space-between; align-items:center;">
                                <div>
                                    <div style="font-weight:600; color:#fff;"><%# Eval("Name") %></div>
                                    <div style="font-size:0.75rem; color:#94a3b8;"><%# Eval("Email") %></div>
                                </div>
                                <asp:LinkButton ID="btnSelectContact" runat="server" CssClass="btn btn-outline btn-sm" CommandName="SelectContact" CommandArgument='<%# Eval("Id") %>'>
                                    Chat &rarr;
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoContacts" runat="server" Visible="false" style="padding:24px; text-align:center; color:#94a3b8;">
                        No student contacts yet. Students who apply to your projects will appear here.
                    </asp:Panel>
                </div>
            </div>

            <div class="card">
                <div class="card-title">
                    <span><i class="bi bi-chat-dots"></i> Conversation with <asp:Label ID="lblChatContactName" runat="server">Student</asp:Label></span>
                </div>

                <div style="min-height:220px; max-height:300px; overflow-y:auto; background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.06); border-radius:10px; padding:16px; margin-bottom:16px;">
                    <asp:Repeater ID="rptMessages" runat="server">
                        <ItemTemplate>
                            <div style='<%# Convert.ToInt32(Eval("SenderId")) == Convert.ToInt32(ViewState["MyClientId"]) ? "text-align:right; margin-bottom:12px;" : "text-align:left; margin-bottom:12px;" %>'>
                                <div style='<%# Convert.ToInt32(Eval("SenderId")) == Convert.ToInt32(ViewState["MyClientId"]) ? "display:inline-block; background:#0284c7; color:#fff; padding:8px 14px; border-radius:12px 12px 2px 12px; max-width:80%; font-size:0.86rem; text-align:left;" : "display:inline-block; background:rgba(255,255,255,0.08); color:#e2e8f0; padding:8px 14px; border-radius:12px 12px 12px 2px; max-width:80%; font-size:0.86rem; text-align:left;" %>'>
                                    <div><%# Eval("Message") %></div>
                                    <div style="font-size:0.65rem; opacity:0.75; margin-top:4px;"><%# Eval("SentDate") != DBNull.Value ? Convert.ToDateTime(Eval("SentDate")).ToString("hh:mm tt, dd MMM") : "" %></div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoMessages" runat="server" Visible="false" style="text-align:center; padding:30px; color:#94a3b8;">
                        No messages exchanged yet. Send the first message below.
                    </asp:Panel>
                </div>

                <div style="display:flex; gap:10px;">
                    <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control" placeholder="Type your message here..."></asp:TextBox>
                    <asp:Button ID="btnSendMessage" runat="server" Text="Send" CssClass="btn btn-primary" OnClick="btnSendMessage_Click" />
                </div>
            </div>
        </div>

    </div>
</div>
</form>
</body>
</html>
