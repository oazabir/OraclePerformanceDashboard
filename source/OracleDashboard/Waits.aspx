<%@ Page Language="C#" %>
<%@ OutputCache NoStore="true" Location="None" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>Waits</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <script src="js/jquery-1.11.1.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">        
                <asp:SqlDataSource ID="sqlDataSource" runat="server"  ProviderName="Oracle.ManagedDataAccess.Client" SelectCommand="
SELECT s.username, s.program, w.event, w.p1, w.p2, o.object_type, o.object_name
  FROM v$session_wait w, v$session s, dba_objects o
 WHERE 
  --w.event LIKE '%contention%' AND
   s.sid = w.sid AND 
   w.p2 = o.object_id
"></asp:SqlDataSource>
                <asp:GridView CssClass="table table-striped" ID="GridView1" runat="server" DataSourceID="sqlDataSource" EnableModelValidation="True">
                    <EmptyDataTemplate>
                        No waits
                    </EmptyDataTemplate>               
                </asp:GridView>            
    </form>
</body>
    <script src="js/ScriptsForWidgets.js"></script>
    <script>
        refreshEvery(5000);
    </script>
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            sqlDataSource.ConnectionString = ConfigurationManager.ConnectionStrings[Request["c"]].ConnectionString;
        }
    </script>
</html>
