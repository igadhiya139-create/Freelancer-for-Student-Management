using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class AdminPanel_ManageApplications
{
    protected HtmlForm form1;
    protected Label lblSidebarName;
    protected Panel pnlMsg;
    protected Label lblMsg;
    protected Panel pnlAppDetails;
    protected Label lblDetId;
    protected Button btnCloseDetails;
    protected Label lblDetProject;
    protected Label lblDetStudent;
    protected Label lblDetBid;
    protected Label lblDetDays;
    protected Label lblDetStatus;
    protected Label lblDetDate;
    protected Label lblDetProposal;
    protected TextBox txtSearch;
    protected DropDownList ddlStatusFilter;
    protected Button btnSearch;
    protected Button btnRefresh;
    protected Label lblAppCount;
    protected Repeater rptApplications;
    protected Panel pnlNoData;
}
