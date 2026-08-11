<%@ Page Title="Newsletter"
    Language="C#"
    MasterPageFile="~/MasterPages/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Newsletter.aspx.cs"
    Inherits="FreelanceStudentSystem.Newsletter" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-md-6 offset-md-3">
            <h3>Subscribe</h3>
            <div class="input-group mb-3">
                <asp:TextBox ID="txtNewsletterEmail" runat="server" CssClass="form-control" placeholder="Email"></asp:TextBox>
                <button class="btn btn-primary" type="button" onclick="document.getElementById('<%= btnSubscribe.ClientID %>').click();">Subscribe</button>
            </div>

            <asp:Button ID="btnSubscribe" runat="server" OnClick="btnSubscribe_Click" Style="display:none" />

            <asp:Label ID="lblStatus" runat="server" CssClass="d-block" />
        </div>
    </div>
</asp:Content>