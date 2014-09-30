<%@ Page Language="C#" EnableViewState="false"%>
<%@ OutputCache NoStore="true" Location="None" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
    <title>Sys Stats</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <script src="js/jquery-1.11.1.min.js"></script>
    <script src="js/ScriptsForWidgets.js"></script>
</head>
<body>
    <form id="form1" runat="server">        
                <asp:SqlDataSource ID="sqlDataSource" runat="server"  ProviderName="Oracle.ManagedDataAccess.Client" SelectCommand="
select 'Buffer cache hit ratio (95+)' as Name, 
round((1-(pr.value/(bg.value+cg.value)))*100,2) as Value
from v$sysstat pr, v$sysstat bg, v$sysstat cg
where pr.name='physical reads'
and bg.name='db block gets'
and cg.name='consistent gets'
union
select 'Parse to execute ratio (<0.3)' as Name,
trunc(1 - (a.value / b.value),3) as Value
from v$sysstat a, v$sysstat b 
where a.name = 'parse count (total)' and b.name = 'execute count'
union
select 'Parse CPU to total CPU ratio (<30)' as Name,
trunc(1 - (a.value / b.value),2)*100 as Value
from v$sysstat a, v$sysstat b 
where a.name = 'parse time cpu' and 
b.name = 'CPU used by this session'
union
select 'Dictionary cache hit ratio (99+)' as Name,
round(sum(gets-getmisses)*100/sum(gets),2) as Value
from v$rowcache
union
select 'Sorts in memory (99+)' as Name,
round((mem.value/(mem.value+dsk.value))*100,2) as Value
from v$sysstat mem, v$sysstat dsk
where mem.name='sorts (memory)'
and dsk.name='sorts (disk)'
union
select 'Shared pool free (~0)' as Name,
round((sum(decode(name,'free memory',bytes,0))/sum(bytes))*100,2) as Value
from v$sgastat
union
select 'Shared pool reloads (~0)' as Name,
round(sum(reloads)/sum(pins)*100,2) as Value
from v$librarycache
where namespace in ('SQL AREA','TABLE/PROCEDURE','BODY','TRIGGER')
union
select 'Library Cache Get Hit Ratio (99+)' as Name,
round(sum(gethits)/sum(gets)*100,2) as Value
from v$librarycache
union
select 'Library Cache Pin Hit Ratio (99+)' as Name,
round(sum(pinhits)/sum(pins)*100,2) as Value
from v$librarycache
union
select 'Short/Total Table Scans (99+)' as Name,
round((shrt.value/(shrt.value+lng.value))*100,2) as Value
from v$sysstat shrt, v$sysstat lng
where shrt.name='table scans (short tables)'
and lng.name='table scans (long tables)'
union
select 'Recursive Calls/Total Calls (<10)' as Name,
round((rcv.value/(rcv.value+usr.value))*100,2) as Value
from v$sysstat rcv, v$sysstat usr
where rcv.name='recursive calls'
and usr.name='user calls'
union
select 'Redo Space Wait Ratio (~0)' as Name,
round((req.value/wrt.value)*100,2) as Value
from v$sysstat req, v$sysstat wrt
where req.name= 'redo log space requests' 
and wrt.name= 'redo writes' 
union
select 'Redo Allocation Latch (~0)' as Name,
round(greatest(
(sum(decode(ln.name,'redo allocation',misses,0))
/greatest(sum(decode(ln.name,'redo allocation',gets,0)),1)),
(sum(decode(ln.name,'redo allocation',immediate_misses,0))
/greatest(sum(decode(ln.name,'redo allocation',immediate_gets,0))
+sum(decode(ln.name,'redo allocation',immediate_misses,0)),1))
)*100,2) as Value
from v$latch l,v$latchname ln
where l.latch#=ln.latch#
union
select 'Redo Copy Latches (~0)' as Name,
round(greatest(
(sum(decode(ln.name,'redo copy',misses,0))
/greatest(sum(decode(ln.name,'redo copy',gets,0)),1)),
(sum(decode(ln.name,'redo copy',immediate_misses,0))
/greatest(sum(decode(ln.name,'redo copy',immediate_gets,0))
+sum(decode(ln.name,'redo copy',immediate_misses,0)),1)) )*100,2) as value
from v$latch l,v$latchname ln
where l.latch#=ln.latch#
union
select 'Chained Fetch Ratio (~0)' as Name,
round((cont.value/(scn.value+rid.value))*100,2) as Value
from v$sysstat cont, v$sysstat scn, v$sysstat rid
where cont.name= 'table fetch continued row' 
and scn.name= 'table scan rows gotten'
and rid.name= 'table fetch by rowid'
union
select 'Free List Contention (~0)' as Name,
round((sum(decode(w.class,'free list',count,0))/
 (sum(decode(name,'db block gets',value,0))
 + sum(decode(name,'consistent gets',value,0))))*100,2) as Value
from v$waitstat w, v$sysstat
union
select 'CPU Parse Overhead (~0)' as Name,
round((prs.value/(prs.value+exe.value))*100,2) as Value
from v$sysstat prs, v$sysstat exe
where prs.name like 'parse count (hard)' 
and exe.name= 'execute count'
union
select 'Willing to Wait Latch Gets (90+)' as Name,
round(((sum(gets) - sum(misses)) / sum(gets))*100,2) as Value
from v$latch
union
select 'Immediate Latch Gets (95+)' as Name,
round(((sum(immediate_gets) - sum(immediate_misses)) / sum(immediate_gets))*100,2) as Value
from v$latch
union
select 'Rollback Segment Contention (<5)' as Name,
round(sum(waits)/sum(gets)*100,2) as Value
from v$rollstat
                                        "></asp:SqlDataSource>
                <asp:GridView CssClass="table table-striped" ID="GridView1" runat="server" DataSourceID="sqlDataSource" EnableModelValidation="True">
                    <EmptyDataTemplate>
                        No SysStats available.
                    </EmptyDataTemplate>            
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <%# Convert.ToString(Eval("Name")) == "Buffer cache hit ratio (95+)" && HandleDbNull(Eval("Value")) < 95 ? Warning("Low") : "" %>
                                <%# Convert.ToString(Eval("Name")) == "CPU Parse Overhead (~0)" && HandleDbNull(Eval("Value")) > 0.2 ? Warning("High") : "" %>
                                <%# Convert.ToString(Eval("Name")) == "Parse CPU to total CPU ratio (<30)" && HandleDbNull(Eval("Value")) > 30 ? Warning("High") : "" %>
                                <%# Convert.ToString(Eval("Name")) == "Parse to execute ratio (<0.3)" && HandleDbNull(Eval("Value")) > 0.3 ? Warning("High") : "" %>
                                <%# Convert.ToString(Eval("Name")) == "Short/Total Table Scans (99+)" && HandleDbNull(Eval("Value")) < 95 ? Warning("Low") : "" %>
                                <%# Convert.ToString(Eval("Name")) == "Shared pool free (~0)" && HandleDbNull(Eval("Value")) < 20 ? Warning("Low") : "" %>
                                <%# Convert.ToString(Eval("Name")) == "Immediate Latch Gets (95+)" && HandleDbNull(Eval("Value")) < 95 ? Warning("Low") : "" %>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>   
                </asp:GridView>            
    </form>
</body>
    <script>
        refreshEvery(5000);

        var plot = ["Buffer cache hit ratio (95+)", "Parse CPU to total CPU ratio (<30)", "Shared pool free (~0)", "Parse to execute ratio (<0.3)"];
        applyPlotAxis(plot);

    </script>
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            sqlDataSource.ConnectionString = ConfigurationManager.ConnectionStrings[Request["c"]].ConnectionString;
        }
        protected float HandleDbNull(object o)
        {
            return Convert.IsDBNull(o) ? 0 : Convert.ToSingle(o);
        }
        protected string Warning(string m)
        {
            return "<span class='label label-warning'>" + m + "</span>";
        }
    </script>
</html>
