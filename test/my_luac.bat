::@echo off
:: Check if any arguments were provided
if "%~1"=="" (
    echo Usage: my_luac.bat *.lua
    exit /b 1
)

:: Loop through each file matching the pattern provided (e.g., *.lua)
for %%f in (%*) do (
    echo Compiling %%f...
    
    :: -s: strip debug info
    :: -o: output to [filename].luac
    :: %%~nf: gets the name without the extension
    C:\BF2_ModTools\ToolsFL\bin\luac.exe -s -o "%%~nf.luac" "%%f"
)

echo Done.