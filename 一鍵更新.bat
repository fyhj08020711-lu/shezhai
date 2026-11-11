@echo off
chcp 65001 >nul
title 社宅招租 一鍵更新
rem 把這個資料夾的修改上傳到 GitHub（fyhj08020711-lu/shezhai）。
cd /d "%~dp0" || goto fail

echo.
echo [1/3] 整理這台電腦上的修改...
git add -A
git diff --cached --quiet
if errorlevel 1 (
  git commit -q -m "更新 %date% %time:~0,8%"
  echo       有修改，已記錄。
) else (
  echo       沒有新的修改。
)

echo [2/3] 和 GitHub 同步...
git pull --rebase -q origin main
if errorlevel 1 goto conflict

echo [3/3] 上傳到 GitHub...
git push -q -u origin main
if errorlevel 1 goto fail

echo.
echo 完成！約 1 分鐘後網站會更新：
echo     https://fyhj08020711-lu.github.io/shezhai/
goto end

:conflict
git rebase --abort >nul 2>&1
echo.
echo 同步失敗：GitHub 上和這台電腦改到了同一個地方，或是連不上網路。
echo 這台電腦的修改都還在，請把這個視窗的畫面截圖給 Claude 處理。
goto end

:fail
echo.
echo 上傳失敗，請確認網路和 GitHub 登入，再把畫面截圖給 Claude。

:end
echo.
pause
