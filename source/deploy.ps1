[string]$source = gi 'OracleDashboard\'
[string]$dest = gi '\\RDW09026APP01\oramon'
$delExclude = @('web.config')
"Deleting:..."
gci $dest -Exclude $delExclude | rm -Recurse

$exclude = @('*.pdb','obj')
"Copying..."
Get-ChildItem $source -Recurse -Exclude $exclude | Copy-Item -Destination {Join-Path $dest $_.FullName.Substring($source.length)}