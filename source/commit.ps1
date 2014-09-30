param (
	[string]$commitFrom = "..",
	[Parameter(Mandatory=$true)][string]$comment
)
Push-Location

# Git push 
cd $commitFrom
git pull
git add -A *.*
git commit -a -m $comment
git push 

Pop-Location
