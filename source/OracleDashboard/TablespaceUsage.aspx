<%@ Page Language="C#" %>
<%@ OutputCache NoStore="true" Location="None" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>Tablespace Usage</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <script src="js/jquery-1.11.1.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">        
                <asp:SqlDataSource ID="sqlDataSource" runat="server"  ProviderName="Oracle.ManagedDataAccess.Client" SelectCommand="
SELECT df.tablespace_name as Name,
       df.file_name as FileName,
       to_char(df.size_mb, '999,999') as SizeMB,
       to_char(f.free_mb, '999,999') as FreeMB,
       to_char(df.max_size_mb, '999,999') as MaxSizeMB,
       to_char(f.free_mb + (df.max_size_mb - df.size_mb), '999,999') as MaxFreeMB,
       ROUND((df.max_size_mb-(f.free_mb + (df.max_size_mb - df.size_mb)))/max_size_mb*10,0) as PercentUsed
FROM   (SELECT file_id,
               file_name,
               tablespace_name,
               TRUNC(bytes/1024/1024) AS size_mb,
               TRUNC(GREATEST(bytes,maxbytes)/1024/1024) AS max_size_mb
        FROM   dba_data_files) df,
       (SELECT TRUNC(SUM(bytes)/1024/1024) AS free_mb,
               file_id
        FROM dba_free_space
        GROUP BY file_id) f
WHERE  df.file_id = f.file_id (+)
ORDER BY df.tablespace_name,
         df.file_name
"></asp:SqlDataSource>
                <asp:GridView CssClass="table table-striped" ID="GridView1" runat="server" DataSourceID="sqlDataSource" EnableModelValidation="True">
                    <EmptyDataTemplate>
                        No waits
                    </EmptyDataTemplate>     
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <%#HandleDbNull(Eval("PercentUsed"))>85 ? "<span class='label label-warning'>Free space</span>" : ""%>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>          
                </asp:GridView>            
    </form>
</body>
    <script src="js/ScriptsForWidgets.js"></script>
    <script>
        //refreshEvery(60000);
    </script>
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            sqlDataSource.ConnectionString = ConfigurationManager.ConnectionStrings[Request["c"]].ConnectionString;
        }
        protected int HandleDbNull(object o)
        {
            return Convert.IsDBNull(o) ? 0 : Convert.ToInt32(o);
        }
    </script>
</html>
