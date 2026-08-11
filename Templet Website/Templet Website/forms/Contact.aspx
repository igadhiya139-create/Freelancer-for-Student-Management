<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site1.Master" 
    AutoEventWireup="true" CodeBehind="Contact.aspx.cs" 
    Inherits="FreelanceStudentSystem.Contact" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <section class="contact section">

        <div class="container">

            <div class="row gy-4">

                <div class="col-lg-6">

                    <h3>Contact Us</h3>

                    <p>
                        Have a question or need help? Send us a message.
                    </p>

                    <div>
                        <label>Name</label>
                        <asp:TextBox ID="TextBox1" runat="server" 
                            CssClass="form-control">
                        </asp:TextBox>
                    </div>

                    <br />

                    <div>
                        <label>Email</label>
                        <asp:TextBox ID="TextBox2" runat="server" 
                            CssClass="form-control">
                        </asp:TextBox>
                    </div>

                    <br />

                    <div>
                        <label>Phone</label>
                        <asp:TextBox ID="TextBox3" runat="server" 
                            CssClass="form-control">
                        </asp:TextBox>
                    </div>

                    <br />

                    <div>
                        <label>Subject</label>
                        <asp:TextBox ID="TextBox4" runat="server" 
                            CssClass="form-control">
                        </asp:TextBox>
                    </div>

                    <br />

                    <div>
                        <label>Message</label>
                        <asp:TextBox ID="TextBox5" runat="server"
                            TextMode="MultiLine"
                            Rows="5"
                            CssClass="form-control">
                        </asp:TextBox>
                    </div>

                    <br />

                    <asp:Label ID="lblMessage" runat="server"></asp:Label>

                    <br /><br />

                    <asp:Button ID="btnSend" runat="server"
                        Text="Send Message"
                        CssClass="btn btn-primary"
                        OnClick="btnSend_Click" />

                </div>

            </div>

        </div>

    </section>

</asp:Content>
