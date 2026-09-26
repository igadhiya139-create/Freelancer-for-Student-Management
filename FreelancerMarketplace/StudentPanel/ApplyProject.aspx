<%@ Page Title="Apply for Project" Language="C#" AutoEventWireup="true"
         CodeFile="ApplyProject.aspx.cs" Inherits="StudentPanel_ApplyProject" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Apply for Project</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <link href="../Content/panel.css" rel="stylesheet" />
    <style>
        .form-card          { background:#222C3C; border:1px solid rgba(255,255,255,.08);
                              border-radius:14px; padding:28px 32px;
                              box-shadow:0 4px 20px rgba(0,0,0,.25); }
        .form-card h5       { font-weight:700; color:#ffffff; margin-bottom:18px;
                              padding-bottom:12px; border-bottom:1px solid rgba(255,255,255,.08); font-size:1.05rem; }
        .form-row           { display:flex; flex-wrap:wrap; gap:16px; margin-bottom:16px; }
        .form-group         { flex:1 1 220px; display:flex; flex-direction:column; }
        .form-group label   { font-size:.8rem; font-weight:600; color:#94a3b8; margin-bottom:6px; }
        .form-group input,
        .form-group textarea{ width:100%; padding:10px 14px; background:#182230;
                              border:1px solid rgba(255,255,255,.12);
                              border-radius:8px; font-size:.88rem; color:#f1f5f9; outline:none;
                              transition:all .2s; box-sizing:border-box; font-family:'Inter',sans-serif; }
        .form-group input:focus,
        .form-group textarea:focus{ border-color:#34d399; background:#1c2738;
                                     box-shadow:0 0 0 2px rgba(52,211,153,.18); }
        .form-group input::placeholder,
        .form-group textarea::placeholder{ color:#64748b; }
        .project-banner     { background:rgba(52,211,153,0.1); border-left:4px solid #34d399;
                              border-radius:8px; padding:14px 18px; margin-bottom:22px; }
        .project-banner p   { margin:0; font-size:.9rem; color:#34d399; font-weight:600; }
        .btn-submit         { padding:10px 28px; background:#059669; color:#fff; border:none;
                              border-radius:8px; font-size:.88rem; font-weight:600; cursor:pointer;
                              transition:background .2s; box-shadow:0 2px 8px rgba(5,150,105,.3); }
        .btn-submit:hover   { background:#047857; }
        .btn-cancel         { padding:10px 20px; background:transparent; color:#94a3b8;
                              border:1px solid rgba(255,255,255,0.18); border-radius:8px;
                              font-size:.88rem; font-weight:600; cursor:pointer; text-decoration:none;
                              display:inline-block; margin-left:8px; }
        .btn-cancel:hover   { border-color:rgba(255,255,255,0.35); color:#fff; }
    </style>
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
    <div class="topbar"><h1>Apply for Project</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <div class="form-card">

            <%-- Project title banner --%>
            <div class="project-banner">
                <p><i class="bi bi-briefcase me-2"></i>
                   Project: <asp:Label ID="lblProjectTitle" runat="server" Text="Loading..."></asp:Label>
                </p>
            </div>

            <h5><i class="bi bi-send me-2" style="color:#34d399;"></i>Submit Your Proposal</h5>

            <%-- Proposal --%>
            <div class="form-row">
                <div class="form-group" style="flex:1 1 100%;">
                    <label for="txtProposal">Your Proposal / Cover Letter</label>
                    <asp:TextBox ID="txtProposal" runat="server" TextMode="MultiLine" Rows="5"
                                 placeholder="Describe your skills, past experience, and why you are the best fit for this project..." />
                </div>
            </div>

            <%-- Bid Amount + Delivery Days --%>
            <div class="form-row">
                <div class="form-group">
                    <label for="txtBid">Proposed Budget ($)</label>
                    <asp:TextBox ID="txtBid" runat="server" TextMode="Number" placeholder="e.g. 250" />
                </div>
                <div class="form-group">
                    <label for="txtDays">Delivery Days</label>
                    <asp:TextBox ID="txtDays" runat="server" TextMode="Number" placeholder="e.g. 7" />
                </div>
            </div>

            <asp:Button ID="Save_btn" runat="server" Text="Submit Application"
                        CssClass="btn-submit" OnClick="Save_btn_Click" />
            <a href="BrowseProjects.aspx" class="btn-cancel">Cancel</a>

        </div>
    </div>
</div>

</form>
</body>
</html>
