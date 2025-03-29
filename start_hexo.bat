@echo off
chcp 65001 >nul

cd /d %~dp0   
echo "  _    _  ______ __   __  ____ ";
echo " | |  | ||  ____|\ \ / / / __ \ ";
echo " | |__| || |__    \ V / | |  | | ";
echo " |  __  ||  __|    > <  | |  | | ";
echo " | |  | || |____  / . \ | |__| | ";
echo " |_|  |_||______|/_/ \_\ \____/ ";

echo ...
timeout /t 1 >nul

echo 正在启动请稍后
timeout /t 1 >nula

echo 正在加载
call hexo g >nul
timeout /t 1 >nul
echo 加载完成

echo 开始启动本地预览
call hexo s
