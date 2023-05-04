git add .
set /p "message=Message: "
if not defined %message% ( set "message=Initial commit" )
git commit -m "%message%"
git push -u origin main