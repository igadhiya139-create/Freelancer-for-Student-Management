<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Register" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="description" content="Register on FreelancerHub — Create your student or client profile today." />
    <style>
        /* GridView image thumbnail */
        .grid-table img { width: 48px; height: 48px; border-radius: 50%; object-fit: cover; border: 2px solid #e2e8f0; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-wrapper">
        <div class="container">

            <!-- Page Header -->
            <div class="mb-4">
                <div class="title-bar"></div>
                <h1 class="section-title">User Registration</h1>
                <p class="section-subtitle">Fill in the details below to create a new account on FreelancerHub</p>
            </div>

            <!-- =========================================
                 REGISTRATION FORM CARD
                 ========================================= -->
            <div class="card-custom mb-5">

                <h5 style="font-weight:700;color:#1e1b4b;margin-bottom:24px;padding-bottom:14px;border-bottom:1px solid #e2e8f0;">
                    <i class="bi bi-person-plus-fill me-2" style="color:#4f46e5;"></i>Registration Form
                </h5>

                <div class="row g-3">

                    <!-- Full Name -->
                    <div class="col-md-6">
                        <label class="form-label" for="txtusername">Full Name</label>
                        <asp:TextBox ID="txtusername" runat="server" CssClass="form-control"
                            placeholder="Enter your full name" />
                    </div>

                    <!-- Email -->
                    <div class="col-md-6">
                        <label class="form-label" for="txtemail">Email Address</label>
                        <asp:TextBox ID="txtemail" runat="server" CssClass="form-control"
                            TextMode="Email" placeholder="you@example.com" />
                    </div>

                    <!-- Mobile -->
                    <div class="col-md-6">
                        <label class="form-label" for="txtmbl">Mobile Number</label>
                        <asp:TextBox ID="txtmbl" runat="server" CssClass="form-control"
                            placeholder="+91 98765 43210" />
                    </div>

                    <!-- City -->
                    <div class="col-md-6">
                        <label class="form-label" for="drpcity">City</label>
                        <asp:DropDownList ID="drpcity" runat="server" CssClass="form-select">
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

                    <!-- Address -->
                    <div class="col-12">
                        <label class="form-label" for="txtaddress">Address</label>
                        <asp:TextBox ID="txtaddress" runat="server" CssClass="form-control"
                            TextMode="MultiLine" Rows="3"
                            placeholder="Enter your full address..." />
                    </div>

                    <!-- Gender -->
                    <div class="col-md-6">
                        <label class="form-label d-block">Gender</label>
                        <div class="radio-group pt-1">
                            <asp:RadioButtonList ID="rdogen" runat="server"
                                RepeatDirection="Horizontal" RepeatLayout="Table">
                                <asp:ListItem Value="Male">Male</asp:ListItem>
                                <asp:ListItem Value="Female">Female</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>

                    <!-- Role -->
                    <div class="col-md-6">
                        <label class="form-label" for="drprole">Role</label>
                        <asp:DropDownList ID="drprole" runat="server" CssClass="form-select">
                            <asp:ListItem Value="">-- Select Role --</asp:ListItem>
                            <asp:ListItem Value="Student">Student</asp:ListItem>
                            <asp:ListItem Value="Client">Client</asp:ListItem>
                            <asp:ListItem Value="Admin">Admin</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- Password -->
                    <div class="col-md-6">
                        <label class="form-label" for="txtpassword">Password</label>
                        <asp:TextBox ID="txtpassword" runat="server" CssClass="form-control"
                            TextMode="Password" placeholder="Create a password" />
                    </div>

                    <!-- Profile Image -->
                    <div class="col-12">
                        <label class="form-label">Profile Image</label>
                        <div style="border:2px dashed #c7d2fe;border-radius:10px;padding:18px 20px;background:#f8f7ff;">
                            <asp:FileUpload ID="imgupload" runat="server" CssClass="form-control" />
                            <div style="font-size:.78rem;color:#64748b;margin-top:6px;">
                                <i class="bi bi-image me-1"></i>Accepted formats: JPG, PNG, GIF. Max size: 2 MB.
                            </div>
                        </div>
                    </div>

                    <!-- Save Button -->
                    <div class="col-12 pt-2">
                        <asp:Button ID="Save_btn" runat="server" Text="Save"
                            CssClass="btn-primary-custom"
                            OnClick="Save_btn_Click" />
                    </div>

                </div><!-- /row -->
            </div><!-- /card -->


            <!-- =========================================
                 RECORDS GRIDVIEW
                 ========================================= -->
            <div class="mb-3 d-flex align-items-center justify-content-between">
                <div>
                    <div class="title-bar"></div>
                    <h2 class="section-title" style="font-size:1.4rem;margin-bottom:0;">Registered Users</h2>
                </div>
                <span style="background:rgba(79,70,229,.08);color:#4f46e5;padding:6px 14px;
                             border-radius:99px;font-size:.82rem;font-weight:600;">
                    <i class="bi bi-table me-1"></i>All Records
                </span>
            </div>

            <div class="grid-wrapper">
                <asp:GridView ID="GridView1" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="grid-table"
                    OnRowCommand="GridView1_RowCommand"
                    EmptyDataText="No records found. Register the first user above!"
                    DataKeyNames="Id">

                    <Columns>

                        <asp:BoundField DataField="Id"     HeaderText="#"      />
                        <asp:BoundField DataField="Name"   HeaderText="Name"   />
                        <asp:BoundField DataField="Gender" HeaderText="Gender" />
                        <asp:BoundField DataField="Email"  HeaderText="Email"  />
                        <asp:BoundField DataField="City"   HeaderText="City"   />
                        <asp:BoundField DataField="Mobile" HeaderText="Mobile" />

                        <asp:TemplateField HeaderText="Role">
                            <ItemTemplate>
                                <%# Eval("Role").ToString() == "Student"
                                    ? "<span class='badge-student'>" + Eval("Role") + "</span>"
                                    : "<span class='badge-client'>"  + Eval("Role") + "</span>" %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Photo">
                            <ItemTemplate>
                                <img src='<%# Eval("Image") %>'
                                     onerror="this.src='https://ui-avatars.com/api/?name=<%# Eval %>&background=4f46e5&color=fff&size=48'"
                                     alt="Profile Photo" />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkEdit" runat="server"
                                    CommandName="cmd_edt"
                                    CommandArgument='<%# Eval("Id") %>'
                                    CssClass="btn-edit">
                                    <i class="bi bi-pencil-square me-1"></i>Edit
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Delete">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkDelete" runat="server"
                                    CommandName="cmd_del"
                                    CommandArgument='<%# Eval("Id") %>'
                                    CssClass="btn-delete"
                                    OnClientClick="return confirm('Are you sure you want to delete this record?');">
                                    <i class="bi bi-trash me-1"></i>Delete
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div><!-- /grid-wrapper -->

        </div><!-- /container -->
    </div><!-- /page-wrapper -->

</asp:Content>


