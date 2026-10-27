<%@ Page Title="Profile Settings" Language="C#" AutoEventWireup="true"
         CodeFile="ProfileSettings.aspx.cs" Inherits="ClientPanel_ProfileSettings" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Profile Settings</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <link href="../Content/panel.css" rel="stylesheet" />
    <style>
        .form-card          { background:#222C3C; border:1px solid rgba(255,255,255,.08);
                              border-radius:14px; padding:28px 32px;
                              box-shadow:0 4px 20px rgba(0,0,0,.25); }
        .form-card h5       { font-weight:700; color:#ffffff; margin-bottom:20px;
                              padding-bottom:12px; border-bottom:1px solid rgba(255,255,255,.08); font-size:1.05rem; }
        .form-row           { display:flex; flex-wrap:wrap; gap:16px; margin-bottom:16px; }
        .form-group         { flex:1 1 220px; display:flex; flex-direction:column; }
        .form-group label   { font-size:.8rem; font-weight:600; color:#94a3b8; margin-bottom:6px; }
        .form-group input,
        .form-group select,
        .form-group textarea{ width:100%; padding:10px 14px; background:#182230;
                              border:1px solid rgba(255,255,255,.12);
                              border-radius:8px; font-size:.88rem; color:#f1f5f9; outline:none;
                              transition:all .2s; box-sizing:border-box; font-family:'Inter',sans-serif; }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus { border-color:#38bdf8; background:#1c2738;
                                     box-shadow:0 0 0 2px rgba(56,189,248,.18); }
        .form-group input::placeholder,
        .form-group textarea::placeholder { color:#64748b; }
        .form-group select option { background:#222C3C; color:#ffffff; }
        .radio-row          { display:flex; gap:24px; padding-top:8px; }
        .radio-row label    { font-weight:500 !important; display:flex;
                              align-items:center; gap:8px; cursor:pointer; color:#e2e8f0; font-size:.88rem; }
        .radio-row input[type="radio"] { accent-color:#0284c7; cursor:pointer; }
        .btn-save           { margin-top:10px; padding:10px 28px; background:#0284c7;
                              color:#fff; border:none; border-radius:8px; font-size:.88rem;
                              font-weight:600; cursor:pointer; transition:background .2s;
                              box-shadow:0 2px 8px rgba(2,132,199,.3); }
        .btn-save:hover     { background:#0369a1; }
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
        <a href="ViewApplicants.aspx"><i class="bi bi-people"></i> <span>View Applicants</span></a>
        <a href="Messages.aspx"><i class="bi bi-chat-dots"></i> <span>Messages</span></a>
        <a href="Payments.aspx"><i class="bi bi-credit-card"></i> <span>Payments</span></a>
        <a href="ClientProfile.aspx"><i class="bi bi-person"></i> <span>My Profile</span></a>
        <a href="Notifications.aspx"><i class="bi bi-bell"></i> <span>Notifications</span></a>
        <a href="ProfileSettings.aspx" class="active"><i class="bi bi-gear"></i> <span>Settings</span></a>
        <a href="ChangePassword.aspx"><i class="bi bi-key"></i> <span>Change Password</span></a>
        <a href="../Logout.aspx"><i class="bi bi-box-arrow-right"></i> <span>Logout</span></a>
    </nav>
    <div class="sidebar-footer"><asp:Label ID="lblSidebarName" runat="server"></asp:Label></div>
</aside>

<div class="main">
    <div class="topbar"><h1>Profile Settings</h1><a href="../Logout.aspx" class="btn-logout">Logout</a></div>
    <div class="content">
        <asp:Panel ID="pnlMsg" runat="server" Visible="false" style="padding:12px 18px; border-radius:8px; margin-bottom:18px; font-size:0.85rem; font-weight:600;">
            <asp:Label ID="lblMsg" runat="server"></asp:Label>
        </asp:Panel>
        <div class="form-card">
            <h5><i class="bi bi-pencil-square me-2" style="color:#38bdf8;"></i>Edit My Profile</h5>

            <div class="form-row">
                <div class="form-group">
                    <label for="txtName">Full Name</label>
                    <asp:TextBox ID="txtName" runat="server" placeholder="Your full name" />
                </div>
                <div class="form-group">
                    <label for="txtEmail">Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email"
                                 ReadOnly="true" placeholder="your@email.com"
                                 style="background:rgba(255,255,255,.04);border:1px solid rgba(255,255,255,.08);color:#94a3b8;cursor:not-allowed;" />
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="txtMobile">Mobile Number</label>
                    <asp:TextBox ID="txtMobile" runat="server" placeholder="+91 98765 43210" />
                </div>
                <div class="form-group">
                    <label for="drpCity">City</label>
                    <asp:DropDownList ID="drpCity" runat="server">
                        <asp:ListItem Value="">-- Select City --</asp:ListItem>
                        <asp:ListItem Value="Mumbai">Mumbai</asp:ListItem>
                        <asp:ListItem Value="Delhi">Delhi</asp:ListItem>
                        <asp:ListItem Value="Bangalore">Bangalore</asp:ListItem>
                        <asp:ListItem Value="Hyderabad">Hyderabad</asp:ListItem>
                        <asp:ListItem Value="Pune">Pune</asp:ListItem>
                        <asp:ListItem Value="Chennai">Chennai</asp:ListItem>
                        <asp:ListItem Value="Kolkata">Kolkata</asp:ListItem>
                        <asp:ListItem Value="Ahmedabad">Ahmedabad</asp:ListItem>
                        <asp:ListItem Value="Jaipur">Jaipur</asp:ListItem>
                        <asp:ListItem Value="Surat">Surat</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Gender</label>
                    <div class="radio-row">
                        <asp:RadioButtonList ID="rdoGender" runat="server"
                            RepeatDirection="Horizontal" RepeatLayout="Table">
                            <asp:ListItem Value="Male">Male</asp:ListItem>
                            <asp:ListItem Value="Female">Female</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group" style="flex:1 1 100%;">
                    <label for="txtAddress">Address</label>
                    <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="3"
                                 placeholder="Enter your full address..." />
                </div>
            </div>

            <asp:Button ID="Save_btn" runat="server" Text="Save Changes"
                        CssClass="btn-save" OnClick="Save_btn_Click" />

        </div>
    </div>
</div>

</form>
</body>
</html>
