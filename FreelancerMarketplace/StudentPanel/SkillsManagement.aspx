<%@ Page Title="Skills Management" Language="C#" AutoEventWireup="true"
         CodeFile="SkillsManagement.aspx.cs" Inherits="StudentPanel_SkillsManagement" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skills Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <link href="../Content/panel.css" rel="stylesheet" />
    <style>
        .skill-row      { display:flex; align-items:center; gap:14px; margin-bottom:14px;
                          padding:10px 14px; background:#182230; border:1px solid rgba(255,255,255,0.08); border-radius:10px; }
        .skill-name     { width:140px; font-weight:600; font-size:.88rem; color:#ffffff; }
        .skill-pct      { width:48px; text-align:right; font-size:.85rem; color:#34d399; font-weight:600; }
        .progress-bar-bg{ flex:1; height:10px; background:rgba(255,255,255,0.1); border-radius:99px; overflow:hidden; }
        .progress-bar-fill{ height:100%; background:linear-gradient(90deg, #059669, #34d399); border-radius:99px; transition:width .3s; }
        .btn-del        { background:none; border:none; color:#f87171; cursor:pointer; font-size:1.1rem; padding:0 6px; }
        .btn-del:hover  { color:#ef4444; }
        .form-card      { background:#222C3C; border:1px solid rgba(255,255,255,.08);
                          border-radius:14px; padding:24px 28px;
                          box-shadow:0 4px 20px rgba(0,0,0,.25); margin-top:20px; }
        .form-card h5   { font-weight:700; color:#ffffff; margin-bottom:18px;
                          padding-bottom:10px; border-bottom:1px solid rgba(255,255,255,.08); font-size:1.05rem; }
        .form-row       { display:flex; flex-wrap:wrap; gap:14px; margin-bottom:14px; }
        .form-group     { flex:1 1 200px; display:flex; flex-direction:column; }
        .form-group label{ font-size:.8rem; font-weight:600; color:#94a3b8; margin-bottom:6px; }
        .form-group input{ padding:10px 14px; background:#182230; border:1px solid rgba(255,255,255,.12);
                           border-radius:8px; font-size:.88rem; color:#f1f5f9; outline:none; transition:border .2s; }
        .form-group input:focus{ border-color:#34d399; box-shadow:0 0 0 2px rgba(52,211,153,.18); }
        .form-group input::placeholder{ color:#64748b; }
        .btn-save       { padding:10px 26px; background:#059669; color:#fff; border:none;
                          border-radius:8px; font-size:.88rem; font-weight:600; cursor:pointer;
                          transition:background .2s; box-shadow:0 2px 8px rgba(5,150,105,.3); }
        .btn-save:hover { background:#047857; }
    </style>
</head>
<body class="student">
<form id="form1" runat="server">

<aside class="sidebar">
    <div class="sidebar-brand"><h2>Freelancer<span>Hub</span></h2><small>Student Panel</small></div>
    <nav class="sidebar-nav">
        <a href="Dashboard.aspx"><i class="bi bi-speedometer2"></i> <span>Dashboard</span></a>
        <a href="Profile.aspx"><i class="bi bi-person"></i> <span>My Profile</span></a>
        <a href="SkillsManagement.aspx" class="active"><i class="bi bi-tools"></i> <span>Skills</span></a>
        <a href="Portfolio.aspx"><i class="bi bi-folder2-open"></i> <span>Portfolio</span></a>
        <a href="BrowseProjects.aspx"><i class="bi bi-search"></i> <span>Browse Projects</span></a>
        <a href="MyApplications.aspx"><i class="bi bi-file-earmark-text"></i> <span>My Applications</span></a>
        <a href="Notifications.aspx"><i class="bi bi-bell"></i> <span>Notifications</span></a>
        <a href="ProfileSettings.aspx"><i class="bi bi-gear"></i> <span>Settings</span></a>
        <a href="ChangePassword.aspx"><i class="bi bi-key"></i> <span>Change Password</span></a>
        <a href="../Logout.aspx"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a>
    </nav>
    <div class="sidebar-footer"><asp:Label ID="lblSidebarName" runat="server"></asp:Label></div>
</aside>

<div class="main">
    <div class="topbar"><h1>Skills Management</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <%-- ── Current Skills List ── --%>
        <div class="card">
            <div class="card-title"><i class="bi bi-tools me-2" style="color:#34d399;"></i>My Skills</div>

            <asp:Repeater ID="rptSkills" runat="server" OnItemCommand="rptSkills_ItemCommand">
                <ItemTemplate>
                    <div class="skill-row">
                        <span class="skill-name"><%# Eval("SkillName") %></span>
                        <div class="progress-bar-bg">
                            <div class="progress-bar-fill" style='width:<%# Eval("SkillLevel") %>%;'></div>
                        </div>
                        <span class="skill-pct"><%# Eval("SkillLevel") %>%</span>
                        <asp:LinkButton ID="lbDelete" runat="server" CssClass="btn-del"
                            CommandName="cmd_del"
                            CommandArgument='<%# Eval("SkillId") %>'
                            OnClientClick="return confirm('Remove this skill?');">
                            <i class="bi bi-trash"></i>
                        </asp:LinkButton>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoSkills" runat="server" Visible="false" style="padding:28px; text-align:center; color:#94a3b8;">
                <i class="bi bi-tools" style="font-size:2rem; display:block; margin-bottom:10px;"></i>
                No skills added yet. Use the form below to showcase your proficiencies.
            </asp:Panel>
        </div>

        <%-- ── Add Skill Form ── --%>
        <div class="form-card">
            <h5><i class="bi bi-plus-circle me-2" style="color:#34d399;"></i>Add or Update a Skill</h5>
            <div class="form-row">
                <div class="form-group">
                    <label for="txtSkillName">Skill Name</label>
                    <asp:TextBox ID="txtSkillName" runat="server" placeholder="e.g. C#, ASP.NET, SQL Server, Python, Figma" />
                </div>
                <div class="form-group">
                    <label for="txtSkillLevel">Proficiency Level (0 – 100 %)</label>
                    <asp:TextBox ID="txtSkillLevel" runat="server" TextMode="Number"
                                 placeholder="e.g. 85" />
                </div>
            </div>
            <asp:Button ID="Save_btn" runat="server" Text="Save Skill"
                        CssClass="btn-save" OnClick="Save_btn_Click" />
        </div>

    </div>
</div>

</form>
</body>
</html>
