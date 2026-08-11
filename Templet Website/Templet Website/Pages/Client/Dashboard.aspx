<%@ Page Title="Client Dashboard" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="FreelanceStudentSystem.Pages.Client.Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Client Dashboard</h2>
    <p>Welcome back, <strong><%= Session["FullName"] %></strong>! Manage your projects here.</p>
    <a href="PostProject.aspx" class="btn btn-primary mb-3"><i class="bi bi-plus-circle"></i> Post New Project</a>
    <h4>My Projects</h4>
    <asp:GridView ID="gvMyProjects" runat="server" CssClass="table table-striped table-hover"
        AutoGenerateColumns="False" EmptyDataText="You have not posted any projects yet.">
        <Columns>
            <asp:BoundField DataField="Title" HeaderText="Title" />
            <asp:BoundField DataField="Category" HeaderText="Category" />
            <asp:BoundField DataField="Budget" HeaderText="Budget (PKR)" DataFormatString="{0:N0}" />
            <asp:BoundField DataField="Deadline" HeaderText="Deadline" DataFormatString="{0:yyyy-MM-dd}" />
            <asp:BoundField DataField="Status" HeaderText="Status" />
        </Columns>
    </asp:GridView>
</asp:Content>