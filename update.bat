@echo off
chcp 65001 >nul

cd /d %~dp0                                          
echo " ##     ##    ###     #######  ########     ###    ##    ## ";
echo " ##     ##   ## ##   ##     ## ##     ##   ## ##   ###   ## ";
echo " ##     ##  ##   ##  ##     ## ##     ##  ##   ##  ####  ## ";
echo " ######### ##     ## ##     ## ########  ##     ## ## ## ## ";
echo " ##     ## ######### ##     ## ##   ##   ######### ##  #### ";
echo " ##     ## ##     ## ##     ## ##    ##  ##     ## ##   ### ";
echo " ##     ## ##     ##  #######  ##     ## ##     ## ##    ## ";

:MENU
echo =========================
echo 将代码上传到git仓库请按1
echo 将git仓库远程同步到本地请按2
echo 将博客部署到服务器请按3
echo 直接退出请按4
echo =========================

choice /c 1234 /n /m "请输入选项"


if "%errorlevel%" == "4" goto END
if "%errorlevel%" == "3" call :HEXO
if "%errorlevel%" == "2" call :PULL
if "%errorlevel%" == "1" call :UPDATE

:UPDATE
echo 开始上传代码
git add .
git commit -m "new"
git push
echo 上传完毕

goto MENU

:PULL
echo 开始拉取远程代码，请稍等
git pull
echo 拉取完成！

goto MENU

:HEXO
start cmd /c "hexo g && hexo d && timeout /t 2 >nul"
timeout /t 6 >nul
echo 部署完毕

goto MENU

:END
timeout /t 1 >nul
for /l %%i in (3, -1, 1) do (
	echo 程序将在%%i秒后退出...
	timeout /t 1 >nul
)
exit
