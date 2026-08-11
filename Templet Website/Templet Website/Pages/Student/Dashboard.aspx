<%@ Page Title="Student Dashboard" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="FreelanceStudentSystem.Pages.Student.Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Welcome, <asp:Label ID="lblName" runat="server"></asp:Label>!</h2>
    <div class="row">
        <div class="col-md-4">
            <div class="card text-white bg-primary">
                <div class="card-body">
                    <h5>My Applications</h5>
                    <h3>12</h3>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-white bg-success">
                <div class="card-body">
                    <h5>Active Projects</h5>
                    <h3>3</h3>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-white bg-info">
                <div class="card-body">
                    <h5>Portfolio Items</h5>
                    <h3>8</h3>
                </div>
            </div>
        </div>
    </div>
    <hr />
    <h4>Recent Projects</h4>
    <asp:GridView ID="gvRecent" runat="server" CssClass="table table-striped"></asp:GridView>
</asp:Content>