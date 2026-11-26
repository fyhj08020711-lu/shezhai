@echo off
title Shezhai Update
cd /d "%~dp0" || goto fail

echo.
echo [1/3] Saving local changes...
git add -A
git diff --cached --quiet
if errorlevel 1 (
  git commit -q -m "update %date% %time:~0,8%"
  echo       Changes committed.
) else (
  echo       No new changes.
)

echo [2/3] Syncing with GitHub...
git ls-remote --exit-code origin >nul 2>&1
if errorlevel 1 goto norepo
git ls-remote --exit-code --heads origin main >nul 2>&1
if errorlevel 1 goto push
git pull --rebase -q origin main
if errorlevel 1 goto conflict

:push
echo [3/3] Uploading to GitHub...
git push -q -u origin main
if errorlevel 1 goto fail

echo.
echo Done! The site updates in about 1 minute:
echo     https://fyhj08020711-lu.github.io/shezhai/
goto end

:norepo
echo.
echo GitHub repo not found: https://github.com/fyhj08020711-lu/shezhai
echo Create it first (Public, no README), then run this again.
echo If you are not logged in to GitHub on this PC, log in when asked.
goto end

:conflict
git rebase --abort >nul 2>&1
echo.
echo Sync failed. Your local changes are safe.
echo Take a screenshot of this window and send it to Claude.
goto end

:fail
echo.
echo Upload failed. Check network and GitHub login, then screenshot this window.

:end
echo.
pause
