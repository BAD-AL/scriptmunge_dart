del /Y pandemic_output\*

md pandemic_output
C:\BF2_ModTools\ToolsFL\bin\ScriptMunge.exe  -inputfile $*.lua -sourcedir lua -outputdir pandemic_output

my_luac.bat *.lua 
 