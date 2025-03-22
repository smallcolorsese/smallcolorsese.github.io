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
echo 直接退出请按3
echo =========================

choice /c 123 /n /m "请输入选项"


if "%errorlevel%" == "3" goto END
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

:END
timeout /t 1 >nul
for /l %%i in (3, -1, 1) do (
	echo 程序将在%%i秒后退出...
	timeout /t 1 >nul
)
exit
