@echo off
setlocal

set NAME=GOOSEGRAPPLE

set PROJECT_DIR=%~dp0
set BUILD_DIR=%PROJECT_DIR%build
set CLASSES_DIR=%BUILD_DIR%\classes
set JAR_FILE=%PROJECT_DIR%%NAME%.jar

echo Building %NAME%...

REM Find JDK installation
set JDK_HOME=
for /f "tokens=*" %%i in ('dir /b /ad "C:\Program Files\Java\jdk*" 2^>nul') do (
    set JDK_HOME=C:\Program Files\Java\%%i
    goto :found_jdk
)
for /f "tokens=*" %%i in ('dir /b /ad "C:\Program Files (x86)\Java\jdk*" 2^>nul') do (
    set JDK_HOME=C:\Program Files (x86)\Java\%%i
    goto :found_jdk
)

echo ERROR: JDK not found. Please install JDK or set JAVA_HOME manually.
pause
exit /b 1

:found_jdk
echo Found JDK at: %JDK_HOME%
set JAVAC_CMD="%JDK_HOME%\bin\javac.exe"
set JAR_CMD="%JDK_HOME%\bin\jar.exe"

REM Verify tools exist
if not exist %JAVAC_CMD% (
    echo ERROR: javac not found at %JAVAC_CMD%
    pause
    exit /b 1
)
if not exist %JAR_CMD% (
    echo ERROR: jar not found at %JAR_CMD%
    pause
    exit /b 1
)

rmdir /s /q "%BUILD_DIR%" 2>nul
mkdir "%CLASSES_DIR%"
mkdir "%BUILD_DIR%\META-INF"

echo Compiling Java sources...
dir /s /b "%PROJECT_DIR%src\*.java" > "%BUILD_DIR%\sources.txt"
%JAVAC_CMD% -d "%CLASSES_DIR%" @"%BUILD_DIR%\sources.txt"

if errorlevel 1 (
    echo Compilation failed!
    pause
    exit /b 1
)

echo Creating manifest...
echo Manifest-Version: 1.0> "%BUILD_DIR%\META-INF\MANIFEST.MF"
echo Main-Class: Game.Game>> "%BUILD_DIR%\META-INF\MANIFEST.MF"

echo Copying resources...
mkdir "%CLASSES_DIR%\Resources"
xcopy /s /e /q /y "%PROJECT_DIR%Resources\*" "%CLASSES_DIR%\Resources\" >nul
xcopy /q /y "%PROJECT_DIR%MapFiles\*" "%CLASSES_DIR%\" >nul 2>&1
copy /y "%PROJECT_DIR%levels.json" "%CLASSES_DIR%\" >nul 2>&1

echo Creating JAR...
cd /d "%CLASSES_DIR%"
%JAR_CMD% cfm "%JAR_FILE%" "%BUILD_DIR%\META-INF\MANIFEST.MF" .

if errorlevel 1 (
    echo JAR creation failed!
    pause
    exit /b 1
)

echo Build complete: %JAR_FILE%
echo Run with: java -jar %NAME%.jar

endlocal
pause