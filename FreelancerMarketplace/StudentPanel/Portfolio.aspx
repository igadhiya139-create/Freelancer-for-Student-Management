<%@ Page Title="Portfolio" Language="C#" AutoEventWireup="true" CodeFile="Portfolio.aspx.cs" Inherits="StudentPanel_Portfolio" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Portfolio</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <link href="../Content/panel.css" rel="stylesheet" />
    <style>
        .portfolio-card     { background:#182230; border:1px solid rgba(255,255,255,0.08);
                              border-radius:12px; padding:20px; display:flex; flex-direction:column;
                              justify-content:space-between; position:relative; }
        .portfolio-card:hover { border-color:rgba(52,211,153,0.3); }
        .form-card          { background:#222C3C; border:1px solid rgba(255,255,255,.08);
                              border-radius:14px; padding:24px 28px;
                              box-shadow:0 4px 20px rgba(0,0,0,.25); margin-top:20px; }
        .form-card h5       { font-weight:700; color:#ffffff; margin-bottom:18px;
                              padding-bottom:10px; border-bottom:1px solid rgba(255,255,255,.08); font-size:1.05rem; }
        .form-row           { display:flex; flex-wrap:wrap; gap:14px; margin-bottom:14px; }
        .form-group         { flex:1 1 200px; display:flex; flex-direction:column; }
        .form-group label   { font-size:.8rem; font-weight:600; color:#94a3b8; margin-bottom:6px; }
        .form-group input,
        .form-group textarea{ padding:10px 14px; background:#182230; border:1px solid rgba(255,255,255,.12);
                              border-radius:8px; font-size:.88rem; color:#f1f5f9; outline:none; transition:border .2s;
                              font-family:'Inter',sans-serif; }
        .form-group input:focus,
        .form-group textarea:focus { border-color:#34d399; box-shadow:0 0 0 2px rgba(52,211,153,.18); }
        .btn-del            { background:none; border:none; color:#f87171; cursor:pointer; font-size:1rem; padding:4px; }
        .btn-del:hover      { color:#ef4444; }
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
        <a href="Portfolio.aspx" class="active"><i class="bi bi-folder2-open"></i> <span>Portfolio</span></a>
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
    <div class="topbar"><h1>My Portfolio</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <div class="card">
            <div class="card-title" style="display:flex;justify-content:space-between;align-items:center;">
                <span><i class="bi bi-folder2-open me-2" style="color:#34d399;"></i>Projects Showcase</span>
            </div>

            <asp:Repeater ID="rptPortfolio" runat="server" OnItemCommand="rptPortfolio_ItemCommand">
                <HeaderTemplate>
                    <div class="grid-3">
                </HeaderTemplate>
                <ItemTemplate>
                    <div class="portfolio-card">
                        <div>
                            <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:8px;">
                                <h4 style="color:#ffffff; font-size:1rem; margin:0; font-weight:700;"><%# Eval("Title") %></h4>
                                <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn-del"
                                    CommandName="cmd_del"
                                    CommandArgument='<%# Eval("PortfolioId") %>'
                                    OnClientClick="return confirm('Delete this portfolio project?');">
                                    <i class="bi bi-trash"></i>
                                </asp:LinkButton>
                            </div>
                            <p style="font-size:0.84rem; color:#94a3b8; line-height:1.5; margin-bottom:12px;">
                                <%# Eval("Description") %>
                            </p>
                        </div>
                        <div style="display:flex; justify-content:space-between; align-items:center; border-top:1px solid rgba(255,255,255,0.06); padding-top:10px; margin-top:8px;">
                            <span style="font-size:0.75rem; color:#64748b;">
                                <%# Eval("CreatedDate") != DBNull.Value ? Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM yyyy") : "" %>
                            </span>
                            <a href='<%# Eval("ProjectLink") %>' target="_blank" class="btn btn-outline btn-sm"
                               style='<%# string.IsNullOrEmpty(Eval("ProjectLink").ToString()) ? "display:none;" : "" %>'>
                                <i class="bi bi-box-arrow-up-right me-1"></i> Live Link
                            </a>
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    </div>
                </FooterTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoPortfolio" runat="server" Visible="false" style="padding:32px; text-align:center; color:#94a3b8;">
                <i class="bi bi-folder-plus" style="font-size:2.2rem; display:block; margin-bottom:10px;"></i>
                No portfolio projects added yet. Showcase your work using the form below.
            </asp:Panel>
        </div>

        <%-- ── Add Portfolio Form ── --%>
        <div class="form-card">
            <h5><i class="bi bi-plus-circle me-2" style="color:#34d399;"></i>Add Portfolio Project</h5>
            <div class="form-row">
                <div class="form-group">
                    <label for="txtPortfolioTitle">Project Title</label>
                    <asp:TextBox ID="txtPortfolioTitle" runat="server" placeholder="e.g. E-Commerce Website with C# & SQL" />
                </div>
                <div class="form-group">
                    <label for="txtPortfolioLink">Live URL or GitHub Repository Link</label>
                    <asp:TextBox ID="txtPortfolioLink" runat="server" placeholder="https://github.com/yourname/project" />
                </div>
            </div>
            <div class="form-row">
                <div class="form-group" style="flex:1 1 100%;">
                    <label for="txtPortfolioDesc">Description / Technologies Used</label>
                    <asp:TextBox ID="txtPortfolioDesc" runat="server" TextMode="MultiLine" Rows="3"
                                 placeholder="Built a complete online shopping portal using ASP.NET Web Forms, ADO.NET and SQL Server..." />
                </div>
            </div>
            <asp:Button ID="btnAddPortfolio" runat="server" Text="Add to Portfolio"
                        CssClass="btn btn-success" OnClick="btnAddPortfolio_Click" />
        </div>

    </div>
</div>
</form>
</body>
</html>
