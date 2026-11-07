using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class AdminPanel_ManageProjects
{
    protected HtmlForm form1;
    protected Label lblSidebarName;
    protected Panel pnlMsg;
    protected Label lblMsg;
    protected Panel pnlProjectDetails;
    protected Label lblDetTitle;
    protected Button btnCloseDetails;
    protected Label lblDetId;
    protected Label lblDetClient;
    protected Label lblDetCategory;
    protected Label lblDetBudget;
    protected Label lblDetDeadline;
    protected Label lblDetStatus;
    protected Label lblDetPostedDate;
    protected Label lblDetSkills;
    protected Label lblDetDesc;
    protected DropDownList ddlChangeStatus;
    protected Button btnUpdateStatus;
    protected TextBox txtSearch;
    protected DropDownList ddlStatusFilter;
    protected Button btnSearch;
    protected Button btnRefresh;
    protected Label lblProjectCount;
    protected Repeater rptProjects;
    protected Panel pnlNoData;
}
