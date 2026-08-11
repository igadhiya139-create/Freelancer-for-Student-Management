<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="FreelanceStudentSystem.Pages.Admin.Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2><i class="bi bi-shield-lock"></i> Admin Panel</h2>
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card text-white bg-primary text-center">
                <div class="card-body">
                    <h5>Total Users</h5>
                    <h2><asp:Label ID="lblTotalUsers" runat="server" Text="0" /></h2>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-white bg-success text-center">
                <div class="card-body">
                    <h5>Total Projects</h5>
                    <h2><asp:Label ID="lblTotalProjects" runat="server" Text="0" /></h2>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-white bg-warning text-center">
                <div class="card-body">
                    <h5>Open Projects</h5>
                    <h2><asp:Label ID="lblOpenProjects" runat="server" Text="0" /></h2>
                </div>
            </div>
        </div>
    </div>
    <h4>All Users</h4>
    <asp:GridView ID="gvUsers" runat="server" CssClass="table table-striped table-hover table-bordered"
        AutoGenerateColumns="False" EmptyDataText="No users found.">
        <Columns>
            <asp:BoundField DataField="UserID" HeaderText="ID" />
            <asp:BoundField DataField="FullName" HeaderText="Full Name" />
            <asp:BoundField DataField="Username" HeaderText="Username" />
            <asp:BoundField DataField="Email" HeaderText="Email" />
            <asp:BoundField DataField="UserType" HeaderText="Role" />
            <asp:BoundField DataField="CreatedAt" HeaderText="Joined" DataFormatString="{0:yyyy-MM-dd}" />
        </Columns>
    </asp:GridView>
</asp:Content>