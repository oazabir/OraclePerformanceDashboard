<%@ Page Language="C#" EnableViewState="false"%>
<%@ OutputCache NoStore="true" Location="None" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>Blocks</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <script src="js/jquery-1.11.1.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">        
                <asp:SqlDataSource ID="sqlDataSource" runat="server"  ProviderName="Oracle.ManagedDataAccess.Client" SelectCommand="
SELECT vs.username,
 vs.osuser,
 vh.sid locking_sid,
 vs.status status,
 vs.module module,
 vs.program program_holding,
 jrh.job_name,
 vsw.username,
 vsw.osuser,
 vw.sid waiter_sid,
 vsw.program program_waiting,
 jrw.job_name,
 'alter system kill session ' || ''''|| vh.sid || ',' || vs.serial# || ''';'  &quot;Kill_Command&quot;
FROM v$lock vh,
 v$lock vw,
 v$session vs,
 v$session vsw,
 dba_scheduler_running_jobs jrh,
 dba_scheduler_running_jobs jrw
WHERE     (vh.id1, vh.id2) IN (SELECT id1, id2
 FROM v$lock
 WHERE request = 0
 INTERSECT
 SELECT id1, id2
 FROM v$lock
 WHERE lmode = 0)
 AND vh.id1 = vw.id1
 AND vh.id2 = vw.id2
 AND vh.request = 0
 AND vw.lmode = 0
 AND vh.sid = vs.sid
 AND vw.sid = vsw.sid
 AND vh.sid = jrh.session_id(+)
 AND vw.sid = jrw.session_id(+)
                                        "></asp:SqlDataSource>
                <asp:GridView CssClass="table table-striped" ID="GridView1" runat="server" DataSourceID="sqlDataSource" EnableModelValidation="True">
                    <EmptyDataTemplate>
                        No blocking session
                    </EmptyDataTemplate>               
                </asp:GridView>            



        <asp:SqlDataSource ID="LockTreeSqlData" runat="server"  ProviderName="Oracle.ManagedDataAccess.Client" SelectCommand="
WITH sessions AS
   (SELECT /*+materialize*/
           sid, blocking_session, row_wait_obj#, sql_id
      FROM v$session)
SELECT LPAD(' ', LEVEL ) || sid sid, object_name, 
       substr(sql_text,1,40) sql_text
  FROM sessions s 
  LEFT OUTER JOIN dba_objects 
       ON (object_id = row_wait_obj#)
  LEFT OUTER JOIN v$sql
       USING (sql_id)
 WHERE sid IN (SELECT blocking_session FROM sessions)
    OR blocking_session IS NOT NULL
 CONNECT BY PRIOR sid = blocking_session
 START WITH blocking_session IS NULL         "></asp:SqlDataSource>
                <asp:GridView CssClass="table table-striped" ID="GridView2" runat="server" DataSourceID="LockTreeSqlData" EnableModelValidation="True">
                    <EmptyDataTemplate>
                        No blocking tree.
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
            LockTreeSqlData.ConnectionString = sqlDataSource.ConnectionString;
        }
    </script>
</html>
