<%@ Page Language="C#" EnableViewState="false"%>
<%@ OutputCache NoStore="true" Location="None" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>No Bind Variable</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">        
                <asp:SqlDataSource ID="sqlDataSource" runat="server"  ProviderName="Oracle.ManagedDataAccess.Client" SelectCommand="
WITH force_matches AS
       (SELECT force_matching_signature,
               COUNT( * )  matches,
               MAX(sql_id || child_number) max_sql_child,
               DENSE_RANK() OVER (ORDER BY COUNT( * ) DESC)
                  ranking
        FROM v$sql
        WHERE force_matching_signature <> 0
          AND parsing_schema_name <> 'SYS'
        GROUP BY force_matching_signature
        HAVING COUNT( * ) > 5)
SELECT sql_id,  matches, parsing_schema_name schema, sql_text
  FROM    v$sql JOIN force_matches
    ON (sql_id || child_number = max_sql_child)
WHERE ranking <= 10
ORDER BY matches DESC
"></asp:SqlDataSource>
                <asp:GridView CssClass="table table-striped" ID="GridView1" runat="server" DataSourceID="sqlDataSource" EnableModelValidation="True">
                    <EmptyDataTemplate>
                        No data for Bind Variable usage.
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
