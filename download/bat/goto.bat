@echo off
chcp 65001>nul & :: 强制命令指示符使用utf-8编码，不然中文会乱码

:MENU
REM 这是主菜单
goto START
REM 跳转到START标签下，执行其标签下的代码

:START
echo 到达START标签

pause