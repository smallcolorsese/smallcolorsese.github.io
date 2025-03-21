@echo off
chcp 65001 >nul

cd /d %~dp0
REM 切换到当前目录

git add .
git commit -m "new"
git push
echo 任务完成

pause