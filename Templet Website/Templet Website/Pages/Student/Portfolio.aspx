<%@ Page Title="Portfolio" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Portfolio.aspx.cs" Inherits="FreelanceStudentSystem.Pages.Student.Portfolio" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2><i class="bi bi-folder2-open"></i> My Portfolio</h2>
    <div class="card shadow mb-4">
        <div class="card-header bg-success text-white"><h5 class="mb-0">Upload New Item</h5></div>
        <div class="card-body">
            <asp:Label ID="lblMsg" runat="server" CssClass="d-block mb-2 text-danger"></asp:Label>
            <div class="mb-3">
                <label class="form-label">Title *</label>
                <asp:TextBox ID="txtPortfolioTitle" runat="server" CssClass="form-control" placeholder="e.g. E-commerce Website" />
            </div>
            <div class="mb-3">
                <label class="form-label">Description</label>
                <asp:TextBox ID="txtPortfolioDesc" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
            </div>
            <div class="mb-3">
                <label class="form-label">File</label>
                <asp:FileUpload ID="fuPortfolio" runat="server" CssClass="form-control" />
            </div>
            <asp:Button ID="btnUpload" runat="server" Text="Upload" CssClass="btn btn-success" OnClick="btnUpload_Click" />
        </div>
    </div>
    <h4>My Portfolio Items</h4>
    <asp:GridView ID="gvPortfolio" runat="server" CssClass="table table-striped table-hover"
        AutoGenerateColumns="False" EmptyDataText="No portfolio items yet.">
        <Columns>
            <asp:BoundField DataField="Title" HeaderText="Title" />
            <asp:BoundField DataField="Description" HeaderText="Description" />
            <asp:HyperLinkField DataNavigateUrlFields="FileUrl" Text="View File" HeaderText="File"
                Target="_blank" ControlStyle-CssClass="btn btn-sm btn-outline-primary" />
            <asp:BoundField DataField="UploadedAt" HeaderText="Uploaded" DataFormatString="{0:yyyy-MM-dd}" />
        </Columns>
    </asp:GridView>
</asp:Content>