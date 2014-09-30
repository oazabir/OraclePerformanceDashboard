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
    <script src="js/jquery.flot.js"></script>    
    <script src="js/jquery.flot.baseline.js"></script>
    <script type="text/javascript" src="js/Dashboard.js"></script>
    <style>
        body { padding: 10px; }
    </style>
    <script type="text/javascript">
        var datasets = {
            "Buffer cache hit ratio (95+)": {
                label: "Buffer cache hit ratio (95+)",
                data: initData(30),
                color: "green",
                threshold: {
                    below: 80,
                    color: "rgb(200, 20, 30)"
                },
                ymax: 100
            },
            "Parse to execute ratio (<0.3)": {
                label: "Parse to execute ratio (<0.3)",
                data: initData(30),
                color: "rgb(200, 20, 30)",
                ymax: 1.0,
                threshold: {
                    below: 0.3,
                    color: "rgb(20, 200, 30)"
                }
            },
            "Shared pool free (~0)": {
                label: "Shared pool free (~0)",
                data: initData(30),
                color: "rgb(200, 20, 30)",
                ymax: 100,
                threshold: {
                    below: 10,
                    color: "rgb(20, 200, 30)"
                }
            },
            "Parse CPU to total CPU ratio (<30)": {
                label: "Parse CPU to total CPU ratio (<30)",
                data: initData(30),
                color: "rgb(200, 20, 30)",
                ymax: 100,
                threshold: {
                    below: 0.3,
                    color: "rgb(20, 200, 30)"
                }
            },
        };


    </script>
</head>
<body>
    <form id="form1" runat="server">
          
        <div class="row">
            <div class="col-md-6">
                <div class="panel panel-success">
                    <div class="panel-heading">CPU Usage</div>
                    <div class="panel-body">
                        <iframe src="CPU.aspx?c=<%= ConnectionString %>" style="width: 100%; height: 200px; border: none;" frameborder="0"></iframe>
                    </div>                    
                </div>
            </div>
            <div class="col-md-6">
                <div class="panel panel-success">
                    <div class="panel-heading">Individual Session CPU compared to Total Session CPU</div>
                    <div class="panel-body">
                        <iframe src="SessionCPUChart.aspx?c=<%= ConnectionString %>" style="width: 100%; height: 200px; border: none;" frameborder="0"></iframe>
                    </div>                    
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-3">
                <div class="panel panel-success">
                    <div class="panel-heading">Buffer cache hit ratio (95+)</div>
                    <div class="panel-body panel-body-height">
                        <div class="demo-container">
                            <div id="placeholder1" class="demo-placeholder"></div>
                        </div>
                    </div>   
                </div>
            </div>
            <div class="col-md-3">
                <div class="panel panel-success">
                    <div class="panel-heading">Parse to execute ratio (<0.3)</div>
                    <div class="panel-body panel-body-height" >
                        <div class="demo-container">
                            <div id="placeholder2" class="demo-placeholder"></div>
                        </div>
                    </div>   
                </div>
            </div>
            <div class="col-md-3">
                <div class="panel panel-success">
                    <div class="panel-heading">Shared pool free (~0)</div>
                    <div class="panel-body panel-body-height" >
                        <div class="demo-container">
                            <div id="placeholder3" class="demo-placeholder"></div>
                        </div>
                    </div>   
                </div>
            </div>
            <div class="col-md-3">
                <div class="panel panel-success">
                    <div class="panel-heading">Parse CPU to total CPU ratio (<30)</div>
                    <div class="panel-body panel-body-height" >
                        <div class="demo-container">
                            <div id="placeholder4" class="demo-placeholder"></div>
                        </div>
                    </div>   
                </div>
            </div>
        </div>
            
 
        <div class="row">
            <!-- Sys Stats -->
            <div class="col-md-6">
                <div class="panel panel-success">
                    <div class="panel-heading"><a target="_blank" href="SysStats.aspx?c=<%= ConnectionString %>">Sys Stats</a></div>
                    <div class="panel-body panel-body-height" id="SysStats">
                        <div class="progress">
                            <div class="progress-bar progress-bar-striped" style="width: 60%"><span class="sr-only">100% Complete</span></div>
                        </div>
                    </div>
                    <iframe class="content_loader" onload="setContent(this, 'SysStats')" src="SysStats.aspx?c=<%= ConnectionString %>" style="width: 100%; height: 100%; border: none; display: none" frameborder="0"></iframe>
                </div>
            </div>
            <!-- Session CPU -->
            <div class="col-md-6">
                <div class="panel panel-success">
                    <div class="panel-heading"><a target="_blank" href="SessionCPU.aspx?c=<%= ConnectionString %>">Session CPU</a></div>
                    <div class="panel-body panel-body-height" id="SessionCPU">
                        <div class="progress">
                            <div class="progress-bar progress-bar-striped" style="width: 60%"><span class="sr-only">100% Complete</span></div>
                        </div>
                    </div>
                    <iframe class="content_loader" onload="setContent(this, 'SessionCPU')" src="SessionCPU.aspx?c=<%= ConnectionString %>" style="width: 100%; height: 100%; border: none; display: none" frameborder="0"></iframe>
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
