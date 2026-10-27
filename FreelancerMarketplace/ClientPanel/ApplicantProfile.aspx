<%@ Page Title="Applicant Profile" Language="C#" AutoEventWireup="true"
         CodeFile="ApplicantProfile.aspx.cs" Inherits="ClientPanel_ApplicantProfile" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Applicant Profile</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <link href="../Content/panel.css" rel="stylesheet" />
    <style>
        .profile-avatar { width:80px;height:80px;border-radius:50%;background:#059669;
                          color:#fff;font-size:1.8rem;font-weight:700;display:flex;
                          align-items:center;justify-content:center;flex-shrink:0; }
        .profile-header { display:flex;align-items:center;gap:20px;margin-bottom:24px;
                          padding-bottom:20px;border-bottom:1px solid rgba(255,255,255,0.08); }
        .badge-status   { display:inline-block;padding:3px 12px;border-radius:99px;
                          font-size:.78rem;font-weight:700; }
        .badge-pending  { background:rgba(251,191,36,0.15);color:#fbbf24; }
        .badge-hired    { background:rgba(52,211,153,0.15);color:#34d399; }
        .badge-rejected { background:rgba(248,113,113,0.15);color:#f87171; }
        .info-grid      { display:grid;grid-template-columns:1fr 1fr;gap:18px;margin-bottom:24px; }
        .info-item label{ display:block;font-size:.78rem;font-weight:700;color:#94a3b8;
                          text-transform:uppercase;letter-spacing:.05em;margin-bottom:5px; }
        .info-item .val { font-size:.95rem;color:#fff;font-weight:500; }
        .proposal-box   { background:rgba(255,255,255,0.04);border:1px solid rgba(255,255,255,0.08);border-radius:10px;
                          padding:16px;margin-bottom:24px;font-size:.9rem;color:#cbd5e1;
                          line-height:1.7;white-space:pre-wrap; }
        .skills-list    { display:flex;flex-wrap:wrap;gap:8px;margin-bottom:24px; }
        .skill-tag      { background:rgba(56,189,248,0.15);color:#38bdf8;border:1px solid rgba(56,189,248,0.25);border-radius:99px;
                          padding:4px 14px;font-size:.82rem;font-weight:600; }
        .action-row     { display:flex;gap:12px;align-items:center; }
        .btn-hire       { padding:10px 24px;background:#059669;color:#fff;border:none;
                          border-radius:8px;font-size:.9rem;font-weight:600;cursor:pointer; }
        .btn-hire:hover { background:#047857; }
        .btn-reject     { padding:10px 24px;background:rgba(248,113,113,0.15);color:#f87171;border:1px solid rgba(248,113,113,0.3);
                          border-radius:8px;font-size:.9rem;font-weight:600;cursor:pointer; }
        .btn-reject:hover{ background:rgba(248,113,113,0.25); }
        .btn-msg        { padding:10px 24px;background:rgba(255,255,255,0.08);color:#e2e8f0;border:1px solid rgba(255,255,255,0.15);
                          border-radius:8px;font-size:.9rem;font-weight:600;cursor:pointer;text-decoration:none;display:inline-flex;align-items:center;gap:6px; }
        .btn-msg:hover  { background:rgba(255,255,255,0.14); }
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
    <div class="topbar">
        <h1>Applicant Profile</h1>
        <div style="display:flex; gap:10px;">
            <a href="ViewApplicants.aspx" class="btn btn-outline btn-sm">&larr; Back to Applicants</a>
            <a href="../Logout.aspx" class="btn-logout">Logout</a>
        </div>
    </div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <div class="card" style="max-width:800px;">

            <div class="profile-header">
                <div class="profile-avatar">
                    <asp:Label ID="lblInitials" runat="server"></asp:Label>
                </div>
                <div>
                    <h2 style="margin:0;font-size:1.25rem;color:#fff;">
                        <asp:Label ID="lblName" runat="server"></asp:Label>
                    </h2>
                    <p style="margin:4px 0 6px;color:#94a3b8;font-size:.85rem;">
                        Student &middot; <asp:Label ID="lblCity" runat="server"></asp:Label>
                    </p>
                    <asp:Label ID="lblStatusBadge" runat="server" CssClass="badge-status badge-pending"></asp:Label>
                </div>
            </div>

            <div class="info-grid">
                <div class="info-item">
                    <label><i class="bi bi-briefcase me-1"></i>Project Applied</label>
                    <div class="val"><asp:Label ID="lblProjectTitle" runat="server"></asp:Label></div>
                </div>
                <div class="info-item">
                    <label><i class="bi bi-envelope me-1"></i>Email Address</label>
                    <div class="val"><asp:Label ID="lblEmail" runat="server"></asp:Label></div>
                </div>
                <div class="info-item">
                    <label><i class="bi bi-currency-dollar me-1"></i>Bid Amount</label>
                    <div class="val" style="color:#34d399; font-weight:700;">$<asp:Label ID="lblBid" runat="server"></asp:Label></div>
                </div>
                <div class="info-item">
                    <label><i class="bi bi-calendar me-1"></i>Delivery Days</label>
                    <div class="val"><asp:Label ID="lblDays" runat="server"></asp:Label> days</div>
                </div>
                <div class="info-item">
                    <label><i class="bi bi-phone me-1"></i>Mobile</label>
                    <div class="val"><asp:Label ID="lblMobile" runat="server"></asp:Label></div>
                </div>
                <div class="info-item">
                    <label><i class="bi bi-clock-history me-1"></i>Applied Date</label>
                    <div class="val"><asp:Label ID="lblAppliedDate" runat="server"></asp:Label></div>
                </div>
            </div>

            <label style="font-size:.78rem;font-weight:700;color:#94a3b8;
                          text-transform:uppercase;letter-spacing:.05em;display:block;margin-bottom:8px;">
                <i class="bi bi-chat-text me-1"></i>Proposal
            </label>
            <div class="proposal-box">
                <asp:Label ID="lblProposal" runat="server"></asp:Label>
            </div>

            <label style="font-size:.78rem;font-weight:700;color:#94a3b8;
                          text-transform:uppercase;letter-spacing:.05em;display:block;margin-bottom:10px;">
                <i class="bi bi-tools me-1"></i>Skills Listed
            </label>
            <div class="skills-list">
                <asp:Repeater ID="rptSkills" runat="server">
                    <ItemTemplate>
                        <span class="skill-tag"><%# Eval("SkillName") %> &nbsp; <%# Eval("SkillLevel") %>%</span>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Label ID="lblNoSkills" runat="server" Visible="false"
                    Text="No specific skills listed." style="color:#64748b;font-size:.88rem;" />
            </div>

            <div class="action-row">
                <asp:Button ID="btnHire" runat="server" Text="Hire Student"
                            CssClass="btn-hire" OnClick="btnHire_Click"
                            OnClientClick="return confirm('Confirm hiring this student for this project?');" />
                <asp:Button ID="btnReject" runat="server" Text="Reject Proposal"
                            CssClass="btn-reject" OnClick="btnReject_Click"
                            OnClientClick="return confirm('Confirm rejecting this proposal?');" />
                <a href="Messages.aspx" class="btn-msg">
                    <i class="bi bi-chat-dots me-1"></i> Send Message
                </a>
            </div>

        </div>
    </div>
</div>

</form>
</body>
</html>
