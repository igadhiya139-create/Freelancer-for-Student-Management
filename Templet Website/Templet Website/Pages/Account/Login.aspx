<%@ Page Title="Login" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="FreelanceStudentSystem.Pages.Account.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center mt-5">
        <div class="col-md-5">
            <div class="card shadow-lg border-0">
                <div class="card-header bg-primary text-white text-center py-3">
                    <h4 class="mb-0"><i class="bi bi-person-lock"></i> Login to Your Account</h4>
                </div>
                <div class="card-body p-4">
                    <asp:Label ID="lblMessage" runat="server" CssClass="text-danger d-block mb-3"></asp:Label>

                    <div class="mb-3">
                        <label for="txtUsername" class="form-label fw-semibold">Username</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter your username"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="txtPassword" class="form-label fw-semibold">Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock"></i></span>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter your password"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-3 form-check">
                        <asp:CheckBox ID="chkRememberMe" runat="server" CssClass="form-check-input" />
                        <label class="form-check-label" for="chkRememberMe">Remember Me (Keep me logged in)</label>
                    </div>

                    <div class="d-grid mb-3">
                        <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary btn-lg" OnClick="btnLogin_Click" />
                    </div>

                    <div class="text-center">
                        <span class="text-muted">Don't have an account?</span>
                        <a href="Register.aspx" class="fw-semibold"> Register here</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>