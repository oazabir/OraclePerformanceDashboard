<%@ Page Language="C#" %>
<%@ OutputCache NoStore="true" Location="None" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>Indexes</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <script src="js/jquery-1.11.1.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">        
                <asp:SqlDataSource ID="sqlDataSource" runat="server"  ProviderName="Oracle.ManagedDataAccess.Client" SelectCommand="
select i.table_name,i.index_name,
(select rtrim (xmlagg (xmlelement (e, column_name || ', ')).extract ('//text()'), ',') column_names from USER_IND_COLUMNS where index_name=i.index_name) column_names,
TO_CHAR(ROUND((i.distinct_keys/(i.num_rows+1))*100, 3), '999.000') as Uniqueness,
case 
when i.distinct_keys/(i.num_rows+1) = 0 then 'IGNORE'
when i.distinct_keys/(i.num_rows+1) < 0.1 AND num_rows > 1000 then 'KILLER!'
when i.distinct_keys/(i.num_rows+1) < 0.1 AND num_rows < 1000 then 'IGNORE'
when i.distinct_keys/(i.num_rows+1) < 0.2 AND num_rows > 1000 then 'SERIOUSLY POOR'
when i.distinct_keys/(i.num_rows+1) < 0.5 AND num_rows > 1000 then 'POOR'
when i.distinct_keys/(i.num_rows+1) < 0.8 then 'OK'
when i.distinct_keys/(i.num_rows+1) < 0.9 then 'GOOD'
else 'VERY GOOD'
end Quality,
i.distinct_keys,i.num_rows,i.blevel,i.leaf_blocks,i.avg_leaf_blocks_per_key,i.avg_data_blocks_per_key from user_indexes i 
where i.table_name in (select table_name from user_tables) 
and i.num_rows > 0
group by table_name,i.index_name,i.distinct_keys,i.num_rows,i.blevel,i.leaf_blocks,i.avg_leaf_blocks_per_key,i.avg_data_blocks_per_key
order by Uniqueness, num_rows desc
"></asp:SqlDataSource>
                <asp:GridView CssClass="table table-striped" ID="GridView1" runat="server" DataSourceID="sqlDataSource" EnableModelValidation="True">
                    <EmptyDataTemplate>
                        No waits
                    </EmptyDataTemplate>     
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <%#HandleDbNull(Eval("UNIQUENESS"))<0.5 && HandleDbNull(Eval("NUM_ROWS"))>1000 ? "<span class='label label-warning'>" + Eval("QUALITY") + "</span>" : ""%>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>          
                </asp:GridView>            
    </form>
</body>    
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            sqlDataSource.ConnectionString = ConfigurationManager.ConnectionStrings[Request["c"]].ConnectionString;
        }
        protected double HandleDbNull(object o)
        {
            return Convert.IsDBNull(o) ? 0 : Convert.ToDouble(o);
        }
    </script>
</html>
