<%@ Page Title="Browse Projects" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="BrowseProjects.aspx.cs" Inherits="FreelanceStudentSystem.Pages.Student.BrowseProjects" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Browse Freelance Projects</h2>
    
    <div class="row mb-3">
        <div class="col-md-6">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search projects..."></asp:TextBox>
        </div>
        <div class="col-md-3">
            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                <asp:ListItem Value="">All Categories</asp:ListItem>
                <asp:ListItem>Web Development</asp:ListItem>
                <asp:ListItem>Graphic Design</asp:ListItem>
                <asp:ListItem>Content Writing</asp:ListItem>
                <asp:ListItem>Video Editing</asp:ListItem>
            </asp:DropDownList>
        </div>
        <div class="col-md-3">
            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
        </div>
    </div>

    <asp:GridView ID="gvProjects" runat="server" CssClass="table table-striped table-hover" AutoGenerateColumns="False" OnRowCommand="gvProjects_RowCommand">
        <Columns>
            <asp:BoundField DataField="Title" HeaderText="Project Title" />
            <asp:BoundField DataField="Category" HeaderText="Category" />
            <asp:BoundField DataField="Budget" HeaderText="Budget" DataFormatString="{0:C}" />
            <asp:BoundField DataField="Deadline" HeaderText="Deadline" DataFormatString="{0:dd-MM-yyyy}" />
            <asp:BoundField DataField="Status" HeaderText="Status" />
            <asp:TemplateField HeaderText="Action">
                <ItemTemplate>
                    <asp:Button ID="btnApply" runat="server" CommandName="Apply" CommandArgument='<%# Eval("ProjectID") %>' 
                                Text="Apply Now" CssClass="btn btn-success btn-sm" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>
