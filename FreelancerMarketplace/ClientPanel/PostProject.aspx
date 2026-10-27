<%@ Page Title="Post New Project" Language="C#" AutoEventWireup="true" CodeFile="PostProject.aspx.cs" Inherits="ClientPanel_PostProject" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Post New Project</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <link href="../Content/panel.css" rel="stylesheet" />
</head>
<body class="client">
<form id="form1" runat="server">
<aside class="sidebar">
    <div class="sidebar-brand"><h2>Freelancer<span>Hub</span></h2><small>Client Panel</small></div>
    <nav class="sidebar-nav">
        <a href="Dashboard.aspx"><i class="bi bi-speedometer2"></i> <span>Dashboard</span></a>
        <a href="PostProject.aspx" class="active"><i class="bi bi-plus-circle"></i> <span>Post New Project</span></a>
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
    <div class="topbar"><h1>Post New Project</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <div class="card" style="max-width:760px;">
            <div class="card-title">
                <span><i class="bi bi-plus-circle"></i> Project Details</span>
            </div>

            <div class="form-group">
                <label>Project Title <span style="color:#f87171;">*</span></label>
                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="e.g. Website Design for Travel Blog"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Project Description <span style="color:#f87171;">*</span></label>
                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control" placeholder="Describe the project scope, deliverables, and requirements..."></asp:TextBox>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Category <span style="color:#f87171;">*</span></label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>Budget ($) <span style="color:#f87171;">*</span></label>
                    <asp:TextBox ID="txtBudget" runat="server" CssClass="form-control" placeholder="e.g. 500"></asp:TextBox>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Deadline (Optional)</label>
                    <asp:TextBox ID="txtDeadline" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Required Skills</label>
                    <asp:TextBox ID="txtSkills" runat="server" CssClass="form-control" placeholder="e.g. HTML, CSS, JavaScript, ASP.NET"></asp:TextBox>
                </div>
            </div>

            <div style="margin-top:20px; display:flex; gap:12px;">
                <asp:Button ID="btnPostProject" runat="server" Text="Post Project Now" CssClass="btn btn-primary" OnClick="btnPostProject_Click" />
                <a href="ManageProjects.aspx" class="btn btn-outline">Cancel</a>
            </div>
        </div>

    </div>
</div>
</form>
</body>
</html>
