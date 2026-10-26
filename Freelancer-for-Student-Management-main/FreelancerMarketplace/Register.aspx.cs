using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

public partial class Register : System.Web.UI.Page
{
    // -------------------------------------------------------
    //  Fields — exact same style as reference code
    // -------------------------------------------------------
    SqlConnection con;
    SqlCommand cmd;
    SqlDataAdapter da;
    DataSet ds;
    string fnm;

    string s = ConfigurationManager.ConnectionStrings["dbcon"].ConnectionString;

    // -------------------------------------------------------
    //  getCon() — opens SqlConnection
    // -------------------------------------------------------
    void getCon()
    {
        con = new SqlConnection(s);
        con.Open();
    }

    // -------------------------------------------------------
    //  fileUpload() — saves uploaded image to /images/ folder
    // -------------------------------------------------------
    public void fileUpload()
    {
        fnm = "images/" + imgupload.FileName;
        imgupload.SaveAs(Server.MapPath(fnm));
    }

    // -------------------------------------------------------
    //  fillGrid() — loads all Registration_tbl records into GridView1
    // -------------------------------------------------------
    void fillGrid()
    {
        getCon();
        da = new SqlDataAdapter("Select * from Registration_tbl", con);
        ds = new DataSet();
        da.Fill(ds);
        GridView1.DataSource = ds;
        GridView1.DataBind();
    }

    // -------------------------------------------------------
    //  fillData() — loads a single record into form fields for editing
    // -------------------------------------------------------
    void fillData()
    {
        getCon();
        da = new SqlDataAdapter("select * from Registration_tbl where Id ='" + ViewState["id"] + "'", con);
        ds = new DataSet();
        da.Fill(ds);

        txtusername.Text        = ds.Tables[0].Rows[0]["Name"].ToString();
        rdogen.SelectedValue    = ds.Tables[0].Rows[0]["Gender"].ToString();
        txtemail.Text           = ds.Tables[0].Rows[0]["Email"].ToString();
        drpcity.SelectedValue   = ds.Tables[0].Rows[0]["City"].ToString();
        txtaddress.Text         = ds.Tables[0].Rows[0]["Address"].ToString();
        txtmbl.Text             = ds.Tables[0].Rows[0]["Mobile"].ToString();
        drprole.SelectedValue   = ds.Tables[0].Rows[0]["Role"].ToString();
    }

    // -------------------------------------------------------
    //  clear() — resets all form controls to empty/default
    // -------------------------------------------------------
    public void clear()
    {
        txtusername.Text        = string.Empty;
        txtaddress.Text         = string.Empty;
        txtemail.Text           = string.Empty;
        txtmbl.Text             = string.Empty;
        txtpassword.Text        = string.Empty;
        rdogen.SelectedIndex    = -1;
        drpcity.SelectedIndex   = -1;
        drprole.SelectedIndex   = -1;
    }

    // -------------------------------------------------------
    //  Page_Load — bind grid on first load only
    // -------------------------------------------------------
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            fillGrid();
    }

    // -------------------------------------------------------
    //  Save_btn_Click — INSERT when button text is "Save"
    //                   UPDATE when button text is "Update"
    // -------------------------------------------------------
    protected void Save_btn_Click(object sender, EventArgs e)
    {
        if (Save_btn.Text == "Save")
        {
            getCon();
            fileUpload();

            string command = "insert into Registration_tbl(Name,Gender,Email,City,Address,Mobile,Role,Password,Image) " +
                             "values('" + txtusername.Text + "','" + rdogen.SelectedValue + "','" +
                             txtemail.Text + "','" + drpcity.SelectedValue + "','" +
                             txtaddress.Text + "','" + txtmbl.Text + "','" +
                             drprole.SelectedValue + "','" + txtpassword.Text + "','" + fnm + "')";

            cmd = new SqlCommand(command, con);
            cmd.ExecuteNonQuery();
            fillGrid();
            Response.Write("<script>alert('Data Inserted Successfully');</script>");
            clear();
        }
        else
        {
            getCon();

            cmd = new SqlCommand(
                "update Registration_tbl set " +
                "Name='"    + txtusername.Text      + "'," +
                "Gender='"  + rdogen.SelectedValue  + "'," +
                "Email='"   + txtemail.Text         + "'," +
                "City='"    + drpcity.SelectedValue + "'," +
                "Address='" + txtaddress.Text       + "'," +
                "Mobile='"  + txtmbl.Text           + "'," +
                "Role='"    + drprole.SelectedValue + "' " +
                "where Id='" + ViewState["id"] + "'", con);

            cmd.ExecuteNonQuery();
            fillGrid();
            clear();
            Response.Write("<script>alert('Data Updated Successfully');</script>");
            Save_btn.Text = "Save";
        }
    }

    // -------------------------------------------------------
    //  GridView1_RowCommand — handles cmd_edt and cmd_del
    // -------------------------------------------------------
    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "cmd_edt")
        {
            int id = Convert.ToInt32(e.CommandArgument);
            ViewState["id"] = id;
            Save_btn.Text = "Update";
            fillData();
        }
        else if (e.CommandName == "cmd_del")
        {
            getCon();
            cmd = new SqlCommand(
                "delete from Registration_tbl where Id = '" + e.CommandArgument + "'", con);
            cmd.ExecuteNonQuery();
            fillGrid();
            Response.Write("<script>alert('Data Deleted Successfully');</script>");
        }
    }
}
