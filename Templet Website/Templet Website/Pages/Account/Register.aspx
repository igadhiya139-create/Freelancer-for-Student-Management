<%@ Page Title="Register" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="FreelanceStudentSystem.Pages.Account.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        /* ── Register Card ── */
        .reg-card {
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.12);
            overflow: hidden;
        }
        .reg-card .card-header {
            background: linear-gradient(135deg, #198754, #20c997);
            padding: 20px;
        }

        /* ── Users GridView Table ── */
        .users-section {
            margin-top: 40px;
        }
        .users-section .section-heading {
            font-size: 1.4rem;
            font-weight: 700;
            color: #1a1a2e;
            border-left: 5px solid #198754;
            padding-left: 12px;
            margin-bottom: 20px;
        }
        .users-table {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            width: 100%;
        }
        .users-table thead {
            background: linear-gradient(135deg, #0d6efd, #0dcaf0);
            color: #fff;
        }
        .users-table thead th {
            padding: 14px 16px;
            font-size: 0.85rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            border: none;
        }
        .users-table tbody tr {
            transition: background 0.2s;
        }
        .users-table tbody tr:hover {
            background-color: #f0f7ff;
        }
        .users-table tbody td {
            padding: 12px 16px;
            vertical-align: middle;
            font-size: 0.9rem;
            border-bottom: 1px solid #e9ecef;
        }
        /* Badge for UserType */
        .badge-student  { background:#0d6efd; color:#fff; padding:4px 10px; border-radius:20px; font-size:0.78rem; }
        .badge-client   { background:#fd7e14; color:#fff; padding:4px 10px; border-radius:20px; font-size:0.78rem; }
        .badge-admin    { background:#dc3545; color:#fff; padding:4px 10px; border-radius:20px; font-size:0.78rem; }



        .empty-msg { text-align:center; padding:30px; color:#6c757d; font-style:italic; }
        .total-badge { background:#e8f5e9; color:#198754; padding:6px 14px; border-radius:20px; font-weight:600; font-size:0.88rem; }
    </style>

    <%-- ══════════════════════════════════════════
         REGISTER FORM
    ══════════════════════════════════════════ --%>
    <div class="row justify-content-center mt-4">
        <div class="col-md-7">
            <div class="card reg-card border-0">
                <div class="card-header text-white text-center py-3">
                    <h4 class="mb-0"><i class="bi bi-person-plus"></i> Create New Account</h4>
                </div>
                <div class="card-body p-4">
                    <asp:Label ID="lblMsg" runat="server" CssClass="d-block mb-3"></asp:Label>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Full Name</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person"></i></span>
                                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Your full name" />
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Username</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-at"></i></span>
                                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Choose a username" />
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="your@email.com" />
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Choose a password" />
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">User Type</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-people"></i></span>
                                <asp:DropDownList ID="ddlUserType" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Student (Freelancer)" Value="Student" />
                                    <asp:ListItem Text="Client"               Value="Client"  />
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>

                    <div class="d-grid mt-2">
                        <asp:Button ID="btnRegister" runat="server" Text="Create Account"
                            CssClass="btn btn-success btn-lg" OnClick="btnRegister_Click" />
                    </div>

                    <div class="text-center mt-3">
                        <span class="text-muted">Already have an account?</span>
                        <a href="Login.aspx" class="fw-semibold"> Login here</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- ══════════════════════════════════════════
         REGISTERED USERS — GridView
    ══════════════════════════════════════════ --%>
    <div class="users-section">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <div class="section-heading mb-0">
                <i class="bi bi-people-fill text-success"></i> Registered Users
            </div>
        </div>

        <asp:Label ID="lblGridMsg" runat="server" CssClass="d-block mb-2" />

        <asp:GridView ID="gvUsers" runat="server"
            CssClass="users-table table table-bordered"
            AutoGenerateColumns="False"
            DataKeyNames="UserID"
            EmptyDataText=""
            GridLines="None">

            <Columns>

                <%-- # ID --%>
                <asp:BoundField DataField="UserID"   HeaderText="#ID"       ReadOnly="True" />

                <%-- Full Name (editable) --%>
                <asp:TemplateField HeaderText="Full Name">
                    <ItemTemplate>
                        <span><%# Eval("FullName") %></span>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtEditFullName" runat="server"
                            Text='<%# Bind("FullName") %>'
                            CssClass="form-control form-control-sm" />
                    </EditItemTemplate>
                </asp:TemplateField>

                <%-- Username (editable) --%>
                <asp:TemplateField HeaderText="Username">
                    <ItemTemplate>
                        <span><%# Eval("Username") %></span>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtEditUsername" runat="server"
                            Text='<%# Bind("Username") %>'
                            CssClass="form-control form-control-sm" />
                    </EditItemTemplate>
                </asp:TemplateField>

                <%-- Email (editable) --%>
                <asp:TemplateField HeaderText="Email">
                    <ItemTemplate>
                        <span><%# Eval("Email") %></span>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtEditEmail" runat="server"
                            Text='<%# Bind("Email") %>'
                            CssClass="form-control form-control-sm" />
                    </EditItemTemplate>
                </asp:TemplateField>

                <%-- User Type (dropdown in edit) --%>
                <asp:TemplateField HeaderText="User Type">
                    <ItemTemplate>
                        <%# GetUserTypeBadge(Eval("UserType")?.ToString()) %>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddlEditUserType" runat="server"
                            CssClass="form-select form-select-sm">
                            <asp:ListItem Text="Student" Value="Student" />
                            <asp:ListItem Text="Client"  Value="Client"  />
                            <asp:ListItem Text="Admin"   Value="Admin"   />
                        </asp:DropDownList>
                    </EditItemTemplate>
                </asp:TemplateField>

                <%-- Created At (read-only) --%>
                <asp:BoundField DataField="CreatedAt" HeaderText="Registered On" ReadOnly="True" />



            </Columns>

            <EmptyDataTemplate>
                <div class="empty-msg">
                    <i class="bi bi-inbox" style="font-size:2rem;"></i><br/>
                    No registered users yet. Register someone above!
                </div>
            </EmptyDataTemplate>

        </asp:GridView>
    </div>

</asp:Content>
