<%@ Page Language="C#" EnableViewState="false"%>
<%@ OutputCache NoStore="true" Location="None" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>IO Usage</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">        
                <asp:SqlDataSource ID="sqlDataSource" runat="server"  ProviderName="Oracle.ManagedDataAccess.Client" SelectCommand="
select 	NAME,
	PHYRDS &quot;Physical Reads&quot;,
	round((PHYRDS / PD.PHYS_READS)*100,2) &quot;Read %&quot;,
	PHYWRTS &quot;Physical Writes&quot;,
	round(PHYWRTS * 100 / PD.PHYS_WRTS,2) &quot;Write %&quot;,
	fs.PHYBLKRD+FS.PHYBLKWRT &quot;Total Block I/O's&quot;
from (
	select 	sum(PHYRDS) PHYS_READS,
		sum(PHYWRTS) PHYS_WRTS
	from  	v$filestat
	) pd,
	v$datafile df,
	v$filestat fs
where 	df.FILE# = fs.FILE#
order 	by fs.PHYBLKRD+fs.PHYBLKWRT desc
"></asp:SqlDataSource>
                <asp:GridView CssClass="table table-striped" ID="GridView1" runat="server" DataSourceID="sqlDataSource" EnableModelValidation="True">
                    <EmptyDataTemplate>
                        No data for IO usage
                    </EmptyDataTemplate>               
                </asp:GridView>            
    </form>
</body>
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            sqlDataSource.ConnectionString = ConfigurationManager.ConnectionStrings[Request["c"]].ConnectionString;
        }
    </script>
</html>
