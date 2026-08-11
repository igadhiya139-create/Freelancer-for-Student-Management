<%@ Page Title="Post Project" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="PostProject.aspx.cs" Inherits="FreelanceStudentSystem.Pages.Client.PostProject" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-briefcase"></i> Post New Project</h4>
                </div>
                <div class="card-body">
                    <asp:Label ID="lblMsg" runat="server" CssClass="text-danger d-block mb-3"></asp:Label>
                    <div class="mb-3">
                        <label class="form-label">Project Title *</label>
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="e.g. Build a React Dashboard" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description *</label>
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" placeholder="Describe your project requirements..." />
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Category</label>
                            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Web Development" Value="Web Development" />
                                <asp:ListItem Text="Mobile App" Value="Mobile App" />
                                <asp:ListItem Text="Graphic Design" Value="Graphic Design" />
                                <asp:ListItem Text="Data Entry" Value="Data Entry" />
                                <asp:ListItem Text="Content Writing" Value="Content Writing" />
                                <asp:ListItem Text="Other" Value="Other" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Budget (PKR) *</label>
                            <asp:TextBox ID="txtBudget" runat="server" CssClass="form-control" TextMode="Number" placeholder="5000" />
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Deadline</label>
                        <asp:TextBox ID="txtDeadline" runat="server" CssClass="form-control" TextMode="Date" />
                    </div>
                    <asp:Button ID="btnPost" runat="server" Text="Post Project" CssClass="btn btn-primary w-100" OnClick="btnPost_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>