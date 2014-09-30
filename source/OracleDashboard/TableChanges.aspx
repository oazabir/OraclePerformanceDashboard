<%@ Page Language="C#" EnableViewState="false"%>
<%@ OutputCache NoStore="true" Location="None" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>Table changes</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">        
                <asp:SqlDataSource ID="sqlDataSource" runat="server"  ProviderName="Oracle.ManagedDataAccess.Client" SelectCommand="
SELECT DT.OWNER,
       DT.TABLE_NAME,
       ROUND ( (DELETES + UPDATES + INSERTS) / NUM_ROWS * 100) PERCENTAGE
FROM   dba_tables dt, ALL_TAB_MODIFICATIONS atm
WHERE      DT.OWNER = ATM.TABLE_OWNER
       AND DT.TABLE_NAME = ATM.TABLE_NAME
       AND NUM_ROWS > 0
       AND ROUND ( (DELETES + UPDATES + INSERTS) / NUM_ROWS * 100) >= 10
       AND OWNER NOT IN ('SYS','SYSTEM','DBSNMP','OSMMON','PERFSTAT')
ORDER BY 3 desc
"></asp:SqlDataSource>
                <asp:GridView CssClass="table table-striped" ID="GridView1" runat="server" DataSourceID="sqlDataSource" EnableModelValidation="True">
                    <EmptyDataTemplate>
                        No data for table usage
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
