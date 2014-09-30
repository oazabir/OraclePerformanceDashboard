<%@ Page Language="C#" EnableViewState="false" %>
<%@ OutputCache NoStore="true" Location="None" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>Sessions</title>
    <script src="js/jquery-1.11.1.min.js"></script>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />    
</head>
<body>
    <form id="form1" runat="server">        
                <asp:SqlDataSource ID="sqlDataSource" runat="server"  ProviderName="Oracle.ManagedDataAccess.Client" SelectCommand="
SELECT 
      SID,
      v$session.STATUS,
      USERNAME || &#39; (&#39; || OSUSER || &#39;)&#39; &quot;USER&quot;, 
      MACHINE,
      Logon_time,      
      /*SYS.AUDIT_ACTIONS.NAME || ' ' || OBJECT_NAME &quot;Command&quot;,*/
      SYS.AUDIT_ACTIONS.NAME &quot;Command&quot;,
     (case 
        when v$session.STATUS = 'ACTIVE' and v$session.ROW_WAIT_OBJ# > 0 then (select OBJECT_NAME FROM dba_objects WHERE v$session.ROW_WAIT_OBJ# = dba_objects.object_ID)
        else ''
      end) &quot;Wait Object&quot;,
      sql_text,
         (SELECT ROUND (VALUE / 1024 / 1024, 2)
            FROM v$sesstat
           WHERE STATISTIC# = 25 AND v$sesstat.SID = v$session.sid)
            AS &quot;PGA Memory, in MB&quot;,
         (SELECT VALUE
            FROM v$sesstat
           WHERE STATISTIC# = 12 AND v$sesstat.SID = v$session.sid)
            AS &quot;CPU, used by session&quot;,
         ROUND ( (SELECT VALUE
                    FROM v$sesstat
                   WHERE STATISTIC# = 339 AND v$sesstat.SID = v$session.sid)
                / (SELECT DECODE (VALUE, 0, 1, VALUE)
                     FROM v$sesstat
                    WHERE STATISTIC# = 338 AND v$sesstat.SID = v$session.sid),
                2)
            AS &quot;Hard Parse, %&quot;,
         (SELECT ROUND (VALUE / 1024 / 1024, 2)
            FROM v$sesstat
           WHERE STATISTIC# = 58 AND v$sesstat.SID = v$session.sid)
            AS &quot;Physical read bytes, in MB&quot;,
         (SELECT ROUND (VALUE / 1024 / 1024, 2)
            FROM v$sesstat
           WHERE STATISTIC# = 66 AND v$sesstat.SID = v$session.sid)
            AS &quot;Physical write bytes, in MB&quot;,
         (SELECT ROUND (VALUE / 1024 / 1024, 2)
            FROM v$sesstat
           WHERE STATISTIC# = 139 AND v$sesstat.SID = v$session.sid)
            AS &quot;Redo size, in MB&quot;,
         (SELECT ROUND (VALUE / 1024 / 1024, 2)
            FROM v$sesstat
           WHERE STATISTIC# = 344 AND v$sesstat.SID = v$session.sid)
            AS &quot;Received from client, in MB&quot;,
         (SELECT ROUND (VALUE / 1024 / 1024, 2)
            FROM v$sesstat
           WHERE STATISTIC# = 343 AND v$sesstat.SID = v$session.sid)
            AS &quot;Sent to client, in MB&quot;,
         SERIAL#,
         PROGRAM,         
         OWNERID,
         PROCESS         
    FROM    v$session
         /*LEFT OUTER JOIN
            DBA_OBJECTS
         ON v$session.ROW_WAIT_OBJ# = dba_objects.object_ID*/
           
         LEFT OUTER JOIN
            v$sqlarea
         ON 
          v$session.sql_hash_value = v$sqlarea.hash_value 
          AND v$session.sql_address  = v$sqlarea.address  
        
         LEFT OUTER JOIN SYS.AUDIT_ACTIONS ON v$session.command = SYS.AUDIT_ACTIONS.action
         
   WHERE v$session.LOGON_TIME BETWEEN TRUNC (SYSDATE) AND SYSDATE
        AND
        v$session.sid != userenv('SESSIONID') 
        AND 
        rownum < 10
    ORDER BY 2, 10 DESC                    
                    "></asp:SqlDataSource>
                <asp:GridView CssClass="table table-striped" ID="GridView1" runat="server" DataSourceID="sqlDataSource" EnableModelValidation="True">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <%#HandleDbNull(Eval("Hard Parse, %"))>0 ? "<span class='label label-warning'>Hard Parse</span>" : ""%>
                                <%#HandleDbNull(Eval("PGA Memory, in MB"))>10 ? "<span class='label label-warning'>PGA</span>" : ""%>
                                <%#HandleDbNull(Eval("CPU, used by session"))>3000 ? "<span class='label label-warning'>CPU</span>" : ""%>
                                <%#HandleDbNull(Eval("Physical read bytes, in MB"))>100 ? "<span class='label label-warning'>Physical Read</span>" : ""%>
                                <%#HandleDbNull(Eval("Physical write bytes, in MB"))>100 ? "<span class='label label-warning'>Physical Write</span>" : ""%>
                                <%#HandleDbNull(Eval("Redo size, in MB"))>10 ? "<span class='label label-warning'>Redo</span>" : ""%>
                                
                                
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>                    
                    
                </asp:GridView>
    </form>
</body>
    <script src="js/ScriptsForWidgets.js"></script>
    <script>
        refreshEvery(5000);
        applyLargeCells('td:eq(8)');
    </script>
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            sqlDataSource.ConnectionString = ConfigurationManager.ConnectionStrings[Request["c"]].ConnectionString;
            GridView1.HeaderRow.TableSection = TableRowSection.TableHeader;
        }

        protected int HandleDbNull(object o) 
        {
            return Convert.IsDBNull(o) ? 0 : Convert.ToInt32(o);
        }
    </script>
</html>
