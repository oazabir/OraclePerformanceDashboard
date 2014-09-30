
<%@ Page Language="C#" EnableViewState="false"%>
<%@ OutputCache NoStore="true" Location="None" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>Session CPU chart</title>
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
    <script type="text/javascript">
        var datasets = {
        };
        var plot = null;

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
                lines: { show: true, fill: true },
                grid: {
                    hoverable: true,
                    clickable: true
                },
                yaxis: {
                    min: 0,
                    max: 100
                },
                xaxis: {
                    show: true
                }
            };

            var data = [];
            $.each(datasets, function (key, val) {
                var items = [];
                for (var i = 0; i < val.data.length; i++)
                    items.push([i, val.data[i]]);

                data.push({ label: key, color: val.color, data: items } );
                
                ++index;
            });

            if (plot == null) {
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
            else {
                plot = $.plot("#placeholder", data, options);
                //plot.setData(data);
                plot.draw();
            }
        }

        function setContent(iframe, id) {
            
            $.each(datasets, function (key, val) {
                // put a default 0 into all existing items so that if the item is missing
                // then it will at least get a 0 and not get out of sync
                val.data.pop();
                val.data.splice(0, 0, 0);                
            });
            $(iframe).contents().find("form").find(".x-axis").each(function (i, e) {
                var x = $(e);
                var y = x.next('.y-axis');
                var xname = x.text();
                var yvalue = parseInt(y.text());
                if (datasets[xname] == null) {
                    datasets[xname] = {
                        label: xname,
                        data: initData(30),
                        color: datasets.length
                    };
                    datasets[xname].data[0] = yvalue;
                } else {
                    var data = datasets[xname].data;
                    data[0] = yvalue;
                }               
                
            });

            $("#output").html("");
            $.each(datasets, function (key, val) {
                $("#output").append("<div>" + val.label + '=' + val.data + "</div>");
            });
            updatePlot();
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
</head>
<body>

    <div class="demo-container">
        <div id="placeholder" class="demo-placeholder"></div>
    </div>

    <iframe class="content_loader" onload="setContent(this, 'SessionCPU')" src="SessionCPU.aspx?c=<%= Request["c"] %>" style="width: 100%; height: 100%; border: none; display:none" frameborder="0"></iframe>

    <div id="output" style="display:none"></div>
</body>
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }
    </script>
</html>
