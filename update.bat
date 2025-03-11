@echo off
chcp 65001 >nul

cd /d %~dp0
REM 切换到当前目录

git add .
git commit -m "update hexo"
git push origin hexo
echo 任务完成

pause