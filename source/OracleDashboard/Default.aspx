<%@ Page Language="C#" %>

<%@ OutputCache NoStore="true" Location="None" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>Oracle Health Monitor</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <link href="css/basic.css" rel="stylesheet" />
    <link href="css/dashboard.css" rel="stylesheet" />
    <script src="js/jquery-1.11.1.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/jquery.idletimer.js"></script>
    <script src="js/Dashboard.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="navbar navbar-inverse" role="navigation">
            <div class="container">
                <div class="navbar-collapse collapse">
                    <ul class="nav navbar-nav">
                        <li class="active"><a href="#">Oracle Performance Dashboard</a></li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Servers <span class="caret"></span></a>
                            <ul class="dropdown-menu" role="menu">
                                <asp:Repeater ID="ConnectionStrings" runat="server">
                                    <ItemTemplate>
                                        <li><a href="Dashboard.aspx?c=<%# Eval("Name") %>"><%# Eval("Name") %></a></li>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="container">
            <asp:Repeater ID="Repeater" runat="server">
                <ItemTemplate>
                    <div class="col-sm-4">
                        <div class="panel panel-success">
                            <div class="panel-heading">
                                <h3 class="panel-title">
                                    <a href="Dashboard.aspx?c=<%# Eval("Name") %>"><%# Eval("Name") %></a>
                                </h3>
                            </div>
                            <div class="panel-body noscroll panel-padding">
                                <iframe id="cpuIframe" src="CPU.aspx?c=<%# Eval("Name") %>" class="tab_iframe" scrolling="no" style="visibility: visible; position:relative;"></iframe>
                                <div id="summary_<%# Convert.ToString(Eval("Name")).Replace(" ", "_") %>"></div>
                                <iframe id="summaryIframe" onload="setContent(this, 'summary_<%# Convert.ToString(Eval("Name")).Replace(" ", "_") %>')" src="Summary.aspx?c=<%# Eval("Name") %>" class="tab_iframe" scrolling="no" style="display:none" ></iframe>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </form>

    <div id="basic-modal-content">
        <pre id="content_text">

        </pre>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {            
            $(document).idleTimer(300000);
            $(document).on("idle.idleTimer", function (event, elem, obj) {
                document.location.href = "idle.html";
            });

            window.setInterval(function () {
                $('iframe.tab_iframe').each(function (i, e) {
                    var frame = $(e);
                    var iframeDoc = e.contentDocument || e.contentWindow.document;

                    // Check if loading is complete
                    if (iframeDoc.readyState == 'complete') {
                        frame.height(frame.contents().height());
                    }
                });
            }, 5000);
        });


    </script>

    <script runat="server">
        protected string ConnectionString
        {
            get
            {
                return Request["c"] ?? ConfigurationManager.ConnectionStrings[0].Name;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            ConnectionStrings.DataSource = ConfigurationManager.ConnectionStrings;
            ConnectionStrings.DataBind();
            Repeater.DataSource = ConfigurationManager.ConnectionStrings;
            Repeater.DataBind();
        }
    </script>



</body>
</html>
