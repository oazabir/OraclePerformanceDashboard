<%@ Page Language="C#" EnableViewState="false"%>
<%@ OutputCache NoStore="true" Location="None" %>
<%@ Import Namespace="Oracle.ManagedDataAccess.Client" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>CPU</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <link href="css/basic.css" rel="stylesheet" />
    <script src="js/jquery-1.11.1.min.js"></script>
    <script src="js/jquery.flot.js"></script>    
    <style>
        .demo-container {
            box-sizing: border-box;
            width: 100%;
            height: 200px;
            /*padding: 20px 15px 15px 15px;
            margin: 15px auto 30px auto;*/
            border: 1px solid #ddd;
            background: #fff;
            background: linear-gradient(#f6f6f6 0, #fff 50px);
            background: -o-linear-gradient(#f6f6f6 0, #fff 50px);
            background: -ms-linear-gradient(#f6f6f6 0, #fff 50px);
            background: -moz-linear-gradient(#f6f6f6 0, #fff 50px);
            background: -webkit-linear-gradient(#f6f6f6 0, #fff 50px);
            box-shadow: 0 3px 10px rgba(0,0,0,0.15);
            -o-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            -ms-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            -moz-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            -webkit-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .demo-placeholder {
            width: 100%;
            height: 100%;
            font-size: 14px;
            line-height: 1.2em;
        }
    </style>
</head>
<body>
     <div class="demo-container">
        <div id="placeholder" class="demo-placeholder"></div>
    </div>
    <form id="form1" runat="server">        
                   
    </form>
</body>
    <script src="js/ScriptsForWidgets.js"></script>
    <script type = "text/javascript">
        var datasets = {
            "Total time": {
                label: "Total time",
                data: initData(30),
                color: "rgb(200, 200, 200)"
            },
            "User time": {
                label: "User time",
                data: initData(30),
                color: "rgb(20, 20, 200)"
            },
            "Nice time": {
                label: "Nice time",
                data: initData(30),
                color: "rgb(20, 200, 30)"
            },
            "Sys time": {
                label: "Sys time",
                data: initData(30),
                color: "rgb(200, 20, 30)"
            },
            "IO Wait time": {
                label: "IO Wait time",
                data: initData(30),
                color: "rgb(100, 20, 30)"
            }//,
            //"Idle Time": {
            //    label: "Idle Time",
            //    data: []
            //}
        };


        function initData(count) {
            var data = [];
            for (var i = 0; i < count; i++)
                data.push(0);
            return data;
        }

        function updatePlot() {
            var index = 0;
            var options = {
                series: {
                    //shadowSize: 0	// Drawing is faster without shadows                    
                },
                lines: { show: true, fill: true},
                grid: {
                    hoverable: true,
                    clickable: true
                },
                yaxis: {
                    min: 0,
                    max: 100
                },
                xaxis: {
                    show: false,
                    min: 0,
                    max: 30
                }
            };

            var data = [];
            $.each(datasets, function (key, val) {
                var items = [];
                for (var i = 0; i < val.data.length; i++)
                    items.push([i, val.data[i]]);

                data.push({ label: key, color: val.color, data: items });

                ++index;
            });

            plot = $.plot("#placeholder", data, options);

            $("#placeholder").bind("plothover", function (event, pos, item) {
                var str = "(" + pos.y.toFixed(2) + ")";
                $("#hoverdata").text(str);

                if (item) {
                    var x = item.datapoint[0].toFixed(2),
                        y = item.datapoint[1].toFixed(2);

                    $("#tooltip").html(item.series.label + " = " + y)
                        .css({ top: item.pageY + 5, left: item.pageX + 5 })
                        .fadeIn(200);
                } else {
                    $("#tooltip").hide();
                }

            });

            plot.draw();
        }

        function updateChart() {
            $.ajax({
                type: "POST",
                url: "CPU.aspx/GetCPUStats",
                data: "{\"connectionName\": \"<%= Request["c"] %>\"}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSuccess,
                failure: function (response) {
                    alert(response.d);
                }
            });
        }

        function OnSuccess(response) {
            //alert(response.d);
            var data = eval(response.d);
            //var data = data.data;
            if (data) {               
                
                var date = data["DATE_TIME"];
                for(var col in data)
                {                        
                    var set = datasets[col];
                    if (set) {
                        set.data.pop();
                        set.data.splice(0, 0, data[col]);
                    }                        
                }
                
            }
            //alert(JSON.stringify(datasets, null, 4));
            updatePlot();

            refreshtimer = window.setTimeout(function () {
                updateChart();
            }, 5000);
        }

        $(document).ready(function () {
            $("<div id='tooltip'></div>").css({
                position: "absolute",
                display: "none",
                border: "1px solid #fdd",
                padding: "2px",
                "background-color": "#fee",
                opacity: 0.80
            }).appendTo("body");
        });
</script>
    <script>
        $(document).ready(updateChart);

        document.ondblclick = function () {
            window.clearTimeout(refreshtimer);
        }
    </script>
    <script runat="server">
        [System.Web.Services.WebMethod]
        public static string GetCurrentTime(string name)
        {
            return "Hello " + name + Environment.NewLine + "The Current Time is: "
                + DateTime.Now.ToString();
        }

        [System.Web.Services.WebMethod]
        public static string GetCPUStats(string connectionName)
        {
            using (OracleConnection conn = new OracleConnection(ConfigurationManager.ConnectionStrings[connectionName].ConnectionString))
            {
                conn.Open();
                using (OracleCommand cmd = new OracleCommand())
                {
                    cmd.Connection = conn;
//                    cmd.CommandText = @"SELECT 
//  to_char(date_time,'HH:MI:SS') as date_time, 
//  round(user_time + nice_time + sys_time + iowait_time, 2) as ""total_time"",
//  round(user_time,2) as ""User time"", 
//  round(nice_time,2) as ""Nice time"", 
//  round(sys_time,2) as ""Sys time"", 
//  round(iowait_time,2) as ""IO Wait time"", 
//  round(idle_time,2) as ""Idle Time""  
//FROM table(osstat(1,2))
//where user_time is not null";
                    cmd.CommandText = @"
SELECT systimestamp as DATETIME,
(SELECT value
  FROM v$osstat
  WHERE stat_name = 'NUM_CPUS') CPU,
          sum(decode(stat_name,'IDLE_TIME', value, NULL)) as idle_time,
           sum(decode(stat_name,'USER_TIME', value, NULL)) as user_time,
           sum(decode(stat_name,'SYS_TIME', value, NULL)) as sys_time,
           sum(decode(stat_name,'IOWAIT_TIME', value, NULL)) as iowait_time,
           sum(decode(stat_name,'NICE_TIME', value, NULL)) as nice_time           
    FROM v$osstat
    WHERE stat_name in ('IDLE_TIME','USER_TIME','SYS_TIME','IOWAIT_TIME','NICE_TIME')
    GROUP BY systimestamp";
                    cmd.CommandType = System.Data.CommandType.Text;

                    StringBuilder buf = new StringBuilder();
                    //using (OracleDataReader dr = cmd.ExecuteReader())
                    //    WriteDataReader(buf, dr);
                    using (OracleDataReader dr1 = cmd.ExecuteReader())
                    {
                        dr1.Read();
                        double num_cpu = Convert.ToDouble(dr1["CPU"]);
                        DateTime firstTime = Convert.ToDateTime(dr1["DATETIME"]);
                        
                        System.Threading.Thread.Sleep(1000);
                        using (OracleDataReader dr2 = cmd.ExecuteReader())
                        {
                            dr2.Read();
                            DateTime secondTime = Convert.ToDateTime(dr2["DATETIME"]);                        
                            
                            double interval = (secondTime - firstTime).Seconds;
                            double idle_time = (Convert.ToDouble(dr2["idle_time"]) - Convert.ToDouble(dr1["idle_time"])) / num_cpu / interval;
                            double user_time = (Convert.ToDouble(dr2["user_time"]) - Convert.ToDouble(dr1["user_time"])) / num_cpu / interval;
                            double sys_time = (Convert.ToDouble(dr2["sys_time"]) - Convert.ToDouble(dr1["sys_time"])) / num_cpu / interval;
                            double iowait_time = (Convert.ToDouble(dr2["iowait_time"]) - Convert.ToDouble(dr1["iowait_time"])) / num_cpu / interval;
                            double nice_time = (Convert.ToDouble(dr2["nice_time"]) - Convert.ToDouble(dr1["nice_time"])) / num_cpu / interval;
                            double total_time = idle_time+user_time+sys_time+iowait_time+nice_time;

                            double idle = idle_time / total_time * 100;
                            double user = user_time / total_time * 100;
                            double sys = sys_time / total_time * 100;
                            double iowait = iowait_time / total_time * 100;
                            double nice = nice_time / total_time * 100;
                            double total = user + sys + iowait + nice;
                            
                            buf.Append(string.Format(
                                "({{'Total time':{0}, 'Idle time': {1}, 'User time': {2}, 'Sys time': {3}, 'IO Wait time': {4}, 'Nice time':{5} }})",
                                    Convert.ToString(total), 
                                    Convert.ToString(idle),
                                    Convert.ToString(user),
                                    Convert.ToString(sys),
                                    Convert.ToString(iowait),
                                    Convert.ToString(nice)));
                        }
                    }                    
                    
                    return buf.ToString();
                }
            }
        }

        private static void WriteDataReader(StringBuilder sb, System.Data.IDataReader reader)
        {
            if (reader == null || reader.FieldCount == 0)
            {
                sb.Append("null");
                return;
            }

            int dataCount = 0;

            sb.Append("({\"data\":[");
            sb.Append(Environment.NewLine);

            while (reader.Read())
            {
                sb.Append("{");

                for (int i = 0; i < reader.FieldCount; i++)
                {
                    sb.Append("\"" + reader.GetName(i) + "\":");
                    //WriteValue(sb, reader[i]);
                    object val = reader[i];
                    double d;
                    DateTime dt;
                    if (val == null || Convert.IsDBNull(val))
                        sb.Append("null");
                    else if (Double.TryParse(Convert.ToString(val), System.Globalization.NumberStyles.Any, System.Globalization.NumberFormatInfo.InvariantInfo, out d))
                        sb.Append(Convert.ToString(val));
                    //else if (DateTime.TryParse(Convert.ToString(val), System.Globalization.DateTimeFormatInfo.InvariantInfo, System.Globalization.DateTimeStyles.None, out dt))
                    //    sb.Append("/Date(" + dt.Ticks.ToString() + "/");
                    else
                        sb.Append("\"" + Convert.ToString(val) + "\"");
                    
                    sb.Append(",");
                    sb.Append(Environment.NewLine);
                }
                // strip off trailing comma
                if (reader.FieldCount > 0)
                    if (sb[sb.Length - 1 - Environment.NewLine.Length] == ',')
                        sb.Remove(sb.Length - 1 - Environment.NewLine.Length, 1);

                sb.Append("},");
                sb.Append(Environment.NewLine);

                dataCount++;
            }

            // remove trailing comma
            if (dataCount > 0)
                if (sb[sb.Length - 1 - Environment.NewLine.Length] == ',')
                    sb.Remove(sb.Length - 1 - Environment.NewLine.Length, 1);

            sb.Append("]})");
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            //sqlDataSource.ConnectionString = ConfigurationManager.ConnectionStrings[Request["c"]].ConnectionString;
        }
    </script>
</html>
