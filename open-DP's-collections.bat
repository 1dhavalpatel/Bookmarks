@echo off
echo Starting DP's HTML Library (Prompts, Checklists, Market)...
echo.

REM Navigate to the bookmarks directory
cd /d "C:\Users\dhaval_patel\OneDrive - S&P Global\Dhaval\Self Learning\Bookmarks"

REM Check if Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo Error: Python is not installed or not in PATH
    echo Please install Python from https://python.org
    pause
    exit /b 1
)

echo Python found. Starting HTTP server on port 8081...
echo.
echo Opening all HTML files in your default browser:
echo - Prompt Library
echo - Checklist Library  
echo.
echo To stop the server, press Ctrl+C in this window.
echo ================================================================

REM Start the HTTP server in background and open all HTML files
start "" http://localhost:8081/DP_PromptLibrary.html
start "" http://localhost:8081/DP_ChecklistLibrary.html

REM Wait a moment for the server to start before opening browser
timeout /t 2 /nobreak >nul

REM Start the Python HTTP server (this will keep running)
python -m http.server 8081