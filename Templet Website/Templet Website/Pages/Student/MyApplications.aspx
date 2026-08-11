<%@ Page Title="My Applications" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="MyApplications.aspx.cs" Inherits="FreelanceStudentSystem.Pages.Student.MyApplications" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2><i class="bi bi-file-earmark-text"></i> My Applications</h2>
    <asp:GridView ID="gvApplications" runat="server" CssClass="table table-striped table-hover"
        AutoGenerateColumns="False" EmptyDataText="You haven't applied to any projects yet.">
        <Columns>
            <asp:BoundField DataField="ProjectTitle" HeaderText="Project" />
            <asp:BoundField DataField="Category" HeaderText="Category" />
            <asp:BoundField DataField="Budget" HeaderText="Budget (PKR)" DataFormatString="{0:N0}" />
            <asp:BoundField DataField="Status" HeaderText="Status" />
            <asp:BoundField DataField="AppliedAt" HeaderText="Applied On" DataFormatString="{0:yyyy-MM-dd}" />
        </Columns>
    </asp:GridView>
</asp:Content>