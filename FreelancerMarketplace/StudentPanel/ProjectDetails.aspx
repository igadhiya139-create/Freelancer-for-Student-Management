<%@ Page Title="Project Details" Language="C#" AutoEventWireup="true" CodeFile="ProjectDetails.aspx.cs" Inherits="StudentPanel_ProjectDetails" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Project Details</title>
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
    <div class="topbar"><h1>Project Details</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">

        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>

        <div class="card">
            <div class="card-title">
                <asp:Label ID="lblTitle" runat="server">Project Title</asp:Label>
            </div>
            <div class="grid-2">
                <div>
                    <h5 style="color:#94a3b8; font-size:0.8rem; text-transform:uppercase; letter-spacing:0.05em; margin-bottom:8px;">Description</h5>
                    <p style="font-size:.88rem;color:#cbd5e1;line-height:1.6;margin-bottom:18px; white-space:pre-line;">
                        <asp:Label ID="lblDescription" runat="server"></asp:Label>
                    </p>

                    <h5 style="color:#94a3b8; font-size:0.8rem; text-transform:uppercase; letter-spacing:0.05em; margin-bottom:8px;">Required Skills</h5>
                    <p style="font-size:.88rem;color:#38bdf8;font-weight:600;margin-bottom:18px;">
                        <asp:Label ID="lblSkills" runat="server"></asp:Label>
                    </p>

                    <div style="display:flex; flex-direction:column; gap:8px;">
                        <p style="font-size:.84rem; margin:0;"><strong>Category:</strong> <asp:Label ID="lblCategory" runat="server"></asp:Label></p>
                        <p style="font-size:.84rem; margin:0;"><strong>Budget:</strong> $<asp:Label ID="lblBudget" runat="server"></asp:Label></p>
                        <p style="font-size:.84rem; margin:0;"><strong>Posted Date:</strong> <asp:Label ID="lblPostedDate" runat="server"></asp:Label></p>
                        <p style="font-size:.84rem; margin:0;"><strong>Deadline:</strong> <asp:Label ID="lblDeadline" runat="server"></asp:Label></p>
                    </div>
                </div>
                <div>
                    <div style="background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.07); border-radius:10px; padding:18px; margin-bottom:16px;">
                        <p style="font-size:.84rem;margin-bottom:8px;"><strong>Client:</strong> <asp:Label ID="lblClientName" runat="server"></asp:Label></p>
                        <p style="font-size:.84rem;margin-bottom:8px;"><strong>Project Status:</strong> <asp:Label ID="lblStatus" runat="server" CssClass="badge badge-green"></asp:Label></p>
                        <p style="font-size:.84rem;margin-bottom:0;"><strong>Total Applicants:</strong> <asp:Label ID="lblApplicantCount" runat="server">0</asp:Label></p>
                    </div>

                    <asp:Panel ID="pnlAlreadyApplied" runat="server" Visible="false" style="padding:14px; border-radius:8px; background:rgba(56,189,248,0.1); border:1px solid rgba(56,189,248,0.25); margin-bottom:16px;">
                        <div style="font-size:0.85rem; font-weight:600; color:#38bdf8;">
                            <i class="bi bi-check-circle me-1"></i> You have already applied for this project.
                        </div>
                        <div style="font-size:0.78rem; color:#cbd5e1; margin-top:4px;">
                            Application Status: <asp:Label ID="lblApplicationStatus" runat="server" Font-Bold="true"></asp:Label>
                        </div>
                    </asp:Panel>

                    <div style="display:flex; gap:10px; align-items:center;">
                        <asp:HyperLink ID="lnkApply" runat="server" CssClass="btn btn-success" Text="Apply for Project"></asp:HyperLink>
                        <a href="BrowseProjects.aspx" class="btn btn-outline">Back to Browse</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</form>
</body>
</html>
