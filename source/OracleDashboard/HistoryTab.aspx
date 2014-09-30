<%@ Page Language="C#"  %>
<%@ OutputCache NoStore="true" Location="None" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>CPU Monitor</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <link href="css/basic.css" rel="stylesheet" />
    <link href="css/dashboard.css" rel="Stylesheet" />
    <script>
        function setContent() { }
    </script>
    <script src="js/jquery-1.11.1.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/jquery.simplemodal.js"></script>
    <script type="text/javascript" src="js/Dashboard.js"></script>
    <style>
        body { padding: 20px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">         
        
        <!-- Expensive Queries -->
        <div class="row">
            <div class="panel panel-success">
                <div class="panel-heading"><a target="_blank" href="ExpensiveQueries.aspx?c=<%= ConnectionString %>">Most CPU intensive Queries</a></div>
                <div class="panel-body panel-body-height" id="ExpensiveQueries">
                    <div class="progress">
                        <div class="progress-bar progress-bar-striped" style="width: 60%"><span class="sr-only">100% Complete</span></div>
                    </div>
                </div>
                <iframe class="content_loader" onload="setContent(this, 'ExpensiveQueries')" src="ExpensiveQueries.aspx?c=<%= ConnectionString %>" style="width: 100%; height: 100%; border: none; display: none" frameborder="0"></iframe>
            </div>
        </div>
        <!-- Top buffer gets -->
        <div class="row">
            <div class="panel panel-success">
                <div class="panel-heading"><a target="_blank" href="TopBufferGets.aspx?c=<%= ConnectionString %>">Top Buffer Gets</a></div>
                <div class="panel-body panel-body-height" id="TopBufferGets">
                    <div class="progress">
                        <div class="progress-bar progress-bar-striped" style="width: 60%"><span class="sr-only">100% Complete</span></div>
                    </div>
                </div>
                <iframe class="content_loader" onload="setContent(this, 'TopBufferGets')" src="TopBufferGets.aspx?c=<%= ConnectionString %>" style="width: 100%; height: 100%; border: none; display: none" frameborder="0"></iframe>
            </div>
        </div>

        <div class="row">
            <!-- Table changes -->
            <div class="col-md-6">
                <div class="panel panel-success">
                    <div class="panel-heading"><a target="_blank" href="TableChanges.aspx?c=<%= ConnectionString %>">Table changes</a></div>
                    <div class="panel-body panel-body-height" id="TableChanges">
                        <div class="progress">
                            <div class="progress-bar progress-bar-striped" style="width: 60%"><span class="sr-only">100% Complete</span></div>
                        </div>
                    </div>
                    <iframe class="content_loader" onload="setContent(this, 'TableChanges')" src="TableChanges.aspx?c=<%= ConnectionString %>" style="width: 100%; height: 100%; border: none; display: none" frameborder="0"></iframe>
                </div>
            </div>
            <!-- SGA Resize -->
            <div class="col-md-6">
                <div class="panel panel-success">
                    <div class="panel-heading"><a target="_blank" href="SGAResize.aspx?c=<%= ConnectionString %>">SGA Resize</a></div>
                    <div class="panel-body panel-body-height" id="SGAResize">
                        <div class="progress">
                            <div class="progress-bar progress-bar-striped" style="width: 60%"><span class="sr-only">100% Complete</span></div>
                        </div>
                    </div>
                    <iframe class="content_loader" onload="setContent(this, 'SGAResize')" src="SGAResize.aspx?c=<%= ConnectionString %>" style="width: 100%; height: 100%; border: none; display: none" frameborder="0"></iframe>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- IO Usage -->
            <div class="col-md-6">
                <div class="panel panel-success">
                    <div class="panel-heading"><a target="_blank" href="IOUsage.aspx?c=<%= ConnectionString %>">IO Usage</a></div>
                    <div class="panel-body panel-body-height" id="IOUsage">
                        <div class="progress">
                            <div class="progress-bar progress-bar-striped" style="width: 60%"><span class="sr-only">100% Complete</span></div>
                        </div>
                    </div>
                    <iframe class="content_loader" onload="setContent(this, 'IOUsage')" src="IOUsage.aspx?c=<%= ConnectionString %>" style="width: 100%; height: 100%; border: none; display: none" frameborder="0"></iframe>
                </div>
            </div>
            <!-- Tablespace usage -->
            <div class="col-md-6">
                <div class="panel panel-success">
                    <div class="panel-heading"><a target="_blank" href="TablespaceUsage.aspx?c=<%= ConnectionString %>">Tablespace Usage</a></div>
                    <div class="panel-body panel-body-height" id="TablespaceUsage">
                        <div class="progress">
                            <div class="progress-bar progress-bar-striped" style="width: 60%"><span class="sr-only">100% Complete</span></div>
                        </div>
                    </div>
                    <iframe class="content_loader" onload="setContent(this, 'TablespaceUsage')" src="TablespaceUsage.aspx?c=<%= ConnectionString %>" style="width: 100%; height: 100%; border: none; display: none" frameborder="0"></iframe>
                </div>
            </div>
        </div>


        <div class="row">
            <!-- Stale Stats -->
            <div class="col-md-6">
                <div class="panel panel-success">
                    <div class="panel-heading"><a target="_blank" href="StaleStats.aspx?c=<%= ConnectionString %>">Stale Stats</a></div>
                    <div class="panel-body panel-body-height" id="StaleStats">
                        <div class="progress">
                            <div class="progress-bar progress-bar-striped" style="width: 60%"><span class="sr-only">100% Complete</span></div>
                        </div>
                    </div>
                    <iframe class="content_loader" onload="setContent(this, 'StaleStats')" src="StaleStats.aspx?c=<%= ConnectionString %>" style="width: 100%; height: 100%; border: none; display: none" frameborder="0"></iframe>
                </div>
            </div>
            <!-- Indexes -->
            <div class="col-md-6">
                <div class="panel panel-success">
                    <div class="panel-heading"><a target="_blank" href="Indexes.aspx?c=<%= ConnectionString %>">Indexes</a></div>
                    <div class="panel-body panel-body-height" id="Indexes">
                        <div class="progress">
                            <div class="progress-bar progress-bar-striped" style="width: 60%"><span class="sr-only">100% Complete</span></div>
                        </div>
                    </div>
                    <iframe class="content_loader" onload="setContent(this, 'Indexes')" src="Indexes.aspx?c=<%= ConnectionString %>" style="width: 100%; height: 100%; border: none; display: none" frameborder="0"></iframe>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- OS Stats -->
            <div class="col-md-6">
                <div class="panel panel-success">
                    <div class="panel-heading"><a target="_blank" href="OSStats.aspx?c=<%= ConnectionString %>">OS Stats</a></div>
                    <div class="panel-body panel-body-height" id="OSStats">
                        <div class="progress">
                            <div class="progress-bar progress-bar-striped" style="width: 60%"><span class="sr-only">100% Complete</span></div>
                        </div>
                    </div>
                    <iframe class="content_loader" onload="setContent(this, 'OSStats')" src="OSStats.aspx?c=<%= ConnectionString %>" style="width: 100%; height: 100%; border: none; display: none" frameborder="0"></iframe>
                </div>
            </div>
            <!-- No bind variable -->
            <div class="col-md-6">
                <div class="panel panel-success">
                    <div class="panel-heading"><a target="_blank" href="NoBindVariable.aspx?c=<%= ConnectionString %>">No Bind Variable</a></div>
                    <div class="panel-body panel-body-height" id="NoBindVariable">
                        <div class="progress">
                            <div class="progress-bar progress-bar-striped" style="width: 60%"><span class="sr-only">100% Complete</span></div>
                        </div>
                    </div>
                    <iframe class="content_loader" onload="setContent(this, 'NoBindVariable')" src="NoBindVariable.aspx?c=<%= ConnectionString %>" style="width: 100%; height: 100%; border: none; display: none" frameborder="0"></iframe>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Invalid objects -->
            <div class="col-md-6">
                <div class="panel panel-success">
                    <div class="panel-heading"><a target="_blank" href="InvalidObjects.aspx?c=<%= ConnectionString %>">Invalid Objects</a></div>
                    <div class="panel-body panel-body-height" id="InvalidObjects">
                        <div class="progress">
                            <div class="progress-bar progress-bar-striped" style="width: 60%"><span class="sr-only">100% Complete</span></div>
                        </div>
                    </div>
                    <iframe class="content_loader" onload="setContent(this, 'InvalidObjects')" src="InvalidObjects.aspx?c=<%= ConnectionString %>" style="width: 100%; height: 100%; border: none; display: none" frameborder="0"></iframe>
                </div>
            </div>
        </div>
    </form>

    <div id="basic-modal-content">
        <pre id="content_text" >

        </pre>
    </div> 
    
    <script runat="server">
        protected string ConnectionString
        {
            get
            {
                return Request["c"] ?? ConfigurationManager.ConnectionStrings[0].Name;
            }
        }       
    </script>

    

</body>
</html>
