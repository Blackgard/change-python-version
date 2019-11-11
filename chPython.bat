goto start
--------------------------------------
Комманды для работы с реестром напрямую:
	@reg delete %KEY1% /v PATH /f 
	@reg delete "%KEY2%" /v PATH /f
	@reg add %KEY1% /v PATH /t %REG_TYPE% /d "%__PATH_x_x%" /f
	@reg add "%KEY2%" /v PATH /t %REG_TYPE% /d "%__PATH_x_x%" /f

Данный скрип необходим для смены использумых версий Python (Пример разных версий 3.6.x, 3.7.x, 3.8.x).

Устаревший метод для поиска версии Python в реестре:
	@for /f "delims=" %%i in ('type "%infile%"^| find /i "Python38" ') do @set python38=%%i
	@for /f "delims=" %%i in ('type "%infile%"^| find /i "Python37" ') do @set python37=%%i
	@for /f "delims=" %%i in ('type "%infile%"^| find /i "Python36" ') do @set python36=%%i
--------------------------------------
:start

@echo on
@chcp 1251

@set "KEY1=HKCU\Environment"
@set "KEY2=HKLM\SYSTEM\ControlSet001\Control\Session Manager\Environment"

for /f "tokens=2*" %%a in ('REG QUERY %KEY1% /v PATH') do set "AppPath=%%~b"

@set "__PATH_8_6=%AppPath:Python38=Python36%"
@set "__PATH_7_8=%AppPath:Python37=Python38%"
@set "__PATH_6_7=%AppPath:Python36=Python37%"

@echo %AppPath%>_del.txt
@set "file=_del.txt"
@set "REG_TYPE=REG_SZ"
 
type "%file%" | find /i "Python38" && set "python38=True"
type "%file%" | find /i "Python37" && set "python37=True"
type "%file%" | find /i "Python36" && set "python36=True"

if "%python38%"=="True" (
	setx PATH "%__PATH_8_6%"
	setx /M PATH "%__PATH_8_6%"
) else (
	if "%python37%"=="True" (
		setx PATH "%__PATH_7_8%"
		setx /M PATH "%__PATH_7_8%"
	) else (
		if "%python36%"=="True" (
			setx PATH "%__PATH_6_7%"
			setx /M PATH "%__PATH_6_7%"
		) 
	)
)

@erase _del.txt
@start cmd /k python -V

:END
