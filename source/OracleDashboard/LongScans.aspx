
<%@ Page Language="C#" EnableViewState="false"%>
<%@ OutputCache NoStore="true" Location="None" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>Long scans</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <script src="js/jquery-1.11.1.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">        
                <asp:SqlDataSource ID="sqlDataSource" runat="server"  ProviderName="Oracle.ManagedDataAccess.Client" SelectCommand="
select * from (
  select 	ss.username||'('||se.sid||') ' &quot;User Process&quot;,
    sum(decode(name,'table scans (short tables)',value)) &quot;Short Scans&quot;,
    sum(decode(name,'table scans (long tables)', value)) &quot;Long Scans&quot;,
    sum(decode(name,'table scan rows gotten',value)) &quot;Rows Retreived&quot;
  from 	v$session ss,
    v$sesstat se,
    v$statname sn
  where 	se.statistic# = sn.statistic#
  and 	(name  like '%table scans (short tables)%'
  or 	 name  like '%table scans (long tables)%'
  or 	 name  like '%table scan rows gotten%')
  and 	se.sid = ss.sid
  and 	ss.username is not null
  group 	by ss.username||'('||se.sid||') '
  order by 3 desc
) 
where rownum < 11
order by 3 desc
                    "></asp:SqlDataSource>
                <asp:GridView CssClass="table table-striped" ID="GridView1" runat="server" DataSourceID="sqlDataSource" EnableModelValidation="True">
                    <EmptyDataTemplate>
                        No Long scans
                    </EmptyDataTemplate>               
                </asp:GridView>            
    </form>
</body>
    <script src="js/ScriptsForWidgets.js"></script>
    <script>
        refreshEvery(10000);
    </script>
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            sqlDataSource.ConnectionString = ConfigurationManager.ConnectionStrings[Request["c"]].ConnectionString;
        }
    </script>
</html>
