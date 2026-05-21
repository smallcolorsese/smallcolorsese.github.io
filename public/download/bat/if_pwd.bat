@echo off
chcp 65001 >nul & :: 强制命令指示符使用utf-8编码，不然中文会乱码
set /p pwd=请输入密码 & :: 将用户输入的密码赋值到pwd

if "%pwd%" == "123" (
  echo 密码正确
  pause % 防止输出后闪退 %
) else (
  % 注意else和(之间有空格 %
  echo 密码错误
  pause 
)
