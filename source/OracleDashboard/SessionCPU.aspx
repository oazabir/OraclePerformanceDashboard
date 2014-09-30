<%@ Page Language="C#" EnableViewState="false"%>
<%@ OutputCache NoStore="true" Location="None" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>Session CPU</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <script src="js/jquery-1.11.1.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">        
                <asp:SqlDataSource ID="sqlDataSource" runat="server"  ProviderName="Oracle.ManagedDataAccess.Client" SelectCommand="
WITH TOTAL_CPU AS
(
select 
   sum(VALUE/100) cpu_usage_seconds
from
   v$session ss, 
   v$sesstat se, 
   v$statname sn
where
   se.STATISTIC# = sn.STATISTIC#
and
   NAME like '%CPU used by this session%'
and
   se.SID = ss.SID
--and 
   --ss.status='ACTIVE'
and 
  ss.username is not null)
select * from 
(
  select 
     ss.username || '-' || se.SID &quot;Session&quot;,
     --VALUE/100 cpu_usage_seconds,
     sum(round(VALUE/(select * from TOTAL_CPU),2)) as CPU   
  from
     v$session ss, 
     v$sesstat se, 
     v$statname sn
  where
     se.STATISTIC# = sn.STATISTIC#
  and
     NAME like '%CPU used by this session%'
  and
     se.SID = ss.SID
  and 
     ss.status='ACTIVE'
  and 
     ss.username is not null
  and value > 0
  group by ss.username, se.SID  
  order by CPU desc
)
where rownum < 11
order by CPU desc
                    "></asp:SqlDataSource>
                <asp:GridView CssClass="table table-striped" ID="GridView1" runat="server" DataSourceID="sqlDataSource" EnableModelValidation="True">
                    <EmptyDataTemplate>
                        No Locks
                    </EmptyDataTemplate>               
                </asp:GridView>            
    </form>
</body>
    <script src="js/ScriptsForWidgets.js"></script>
    <script>
        refreshEvery(5000);

        $('tr').each(function (i, tr) {
            $('td:first', tr).each(function (i, td) {
                $(td).addClass("x-axis").next().addClass("y-axis");
            });
        });
    </script>
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            sqlDataSource.ConnectionString = ConfigurationManager.ConnectionStrings[Request["c"]].ConnectionString;
        }
    </script>
</html>
