DECLARE @IndexHtml NVARCHAR(MAX);

-- Build HTML table
SET @IndexHtml = 
    N'<style>
        table { border-collapse: collapse; width: 100%; font-family: Arial; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
     </style>
     <h3>Index Metadata Report</h3>
     <table>
        <tr>
            <th>Table Name</th>
            <th>Index Name</th>
            <th>Index Type</th>
            <th>Column Name</th>
            <th>Column Type</th>
        </tr>';

-- Append rows
SELECT @IndexHtml = @IndexHtml + 
    N'<tr>
        <td>' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + '.' + QUOTENAME(t.name) + N'</td>
        <td>' + QUOTENAME(i.name) + N'</td>
        <td>' + i.type_desc + N'</td>
        <td>' + c.name + N'</td>
        <td>' + typ.name + 
            CASE 
                WHEN typ.name IN ('char','varchar','nchar','nvarchar') 
                THEN '(' + 
                    CASE WHEN c.max_length = -1 THEN 'MAX' 
                         ELSE CAST(c.max_length AS VARCHAR) 
                    END + ')'
                ELSE ''
            END + 
        N'</td>
    </tr>'
FROM sys.indexes i
JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
JOIN sys.tables t ON i.object_id = t.object_id
JOIN sys.types typ ON c.user_type_id = typ.user_type_id
WHERE i.is_hypothetical = 0 AND i.name IS NOT NULL;

-- Close HTML
SET @IndexHtml = @IndexHtml + N'</table>';

EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'GmailProfile',   -- Replace with your mail profile
    @recipients = 'khushmurorodov@gmail.com',   -- Replace with actual recipient
    @subject = 'Index Metadata Report',
    @body = @IndexHtml,
    @body_format = 'HTML';
