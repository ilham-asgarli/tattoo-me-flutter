git add .
set /p "message=Message: "
git commit -m "%message%"
git push -u origin main