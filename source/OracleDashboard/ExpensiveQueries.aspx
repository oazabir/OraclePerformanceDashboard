<%@ Page Language="C#" EnableViewState="false" %>
<%@ OutputCache NoStore="true" Location="None" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>Expensive Queries</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />    
    <style>
        td.large-cell {
            padding: 0px;
            margin: 0px;
            table-layout:fixed;
        }

        td.large-cell div {
            height: 80px;
            overflow-y: auto;
            cursor: hand;
            cursor: pointer                
        }
    </style>

</head>
<body>
        <form id="form1" runat="server">        
                <asp:SqlDataSource ID="sqlDataSource" runat="server"  ProviderName="Oracle.ManagedDataAccess.Client" SelectCommand="
SELECT  SYS_CONTEXT('USERENV','SERVER_HOST')           ENV,
        SYS_CONTEXT('USERENV','DB_NAME')               DATABASE_NAME,
        ROUND(A.ELAPSED_TIME / A.EXECUTIONS / 1000000) SQL_AVERAGE_ELAPSED_TIME,
        A.SQL_ID                                       SQL_ID,
        A.EXECUTIONS                                   SQL_EXECUTIONS,
        A.SQL_FULLTEXT                                 SQL_TEXT,        
        NVL(S.PROGRAM,A.MODULE)                        SESSION_PROGRAM_NAME,
        NVL(S.USERNAME,A.PARSING_SCHEMA_NAME)          SESSION_USER_NAME,
        S.OSUSER                                       SESSION_OS_USER_NAME,
        S.lockwait                                     LOCK_WAIT
  FROM  V$SQLAREA A,
        V$SESSION S
  WHERE A.SQL_ID = S.SQL_ID(+)
    AND A.EXECUTIONS > 0
    AND ROUND(A.ELAPSED_TIME / A.EXECUTIONS / 1000000) > 10
    AND rownum < 10
  ORDER BY SQL_AVERAGE_ELAPSED_TIME desc"></asp:SqlDataSource>
                <asp:GridView CssClass="table table-striped" ID="GridView1" runat="server" DataSourceID="sqlDataSource" EnableModelValidation="True">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <%--<%# Convert.ToInt32(Eval("Avg CPU Time")) > 5000 ? "<span class='label label-warning'>High CPU</span>" : "" %>                                
                                <%# Convert.ToInt32(Eval("max_logical_reads")) > 5000 ? "<span class='label label-warning'>High Logical Read</span>" : "" %>                                
                                <%# Convert.ToInt32(Eval("max_physical_reads")) > 1000 ? "<span class='label label-warning'>High Physical Read</span>" : "" %>                                
                                <%# Convert.ToInt32(Eval("max_logical_writes")) > 5000 ? "<span class='label label-warning'>High Logical Write</span>" : "" %>                                                                
                                --%>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>              
                    <EmptyDataTemplate>
                        No data found.
                    </EmptyDataTemplate>
                          
                </asp:GridView>            
    </form>
</body>
    <script src="js/jquery-1.11.1.min.js"></script>
    <script src="js/ScriptsForWidgets.js"></script>
    <script>
        applyLargeCells('td:eq(6)');
    </script>
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            sqlDataSource.ConnectionString = ConfigurationManager.ConnectionStrings[Request["c"]].ConnectionString;
        }
    </script>
</html>
