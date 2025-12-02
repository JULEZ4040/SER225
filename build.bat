@echo off
setlocal

set NAME=GOOSEGRAPPLE

set PROJECT_DIR=%~dp0
set BUILD_DIR=%PROJECT_DIR%build
set CLASSES_DIR=%BUILD_DIR%\classes
set JAR_FILE=%PROJECT_DIR%%NAME%.jar

echo Building %NAME%...

rmdir /s /q "%BUILD_DIR%" 2>nul
mkdir "%CLASSES_DIR%"
mkdir "%BUILD_DIR%\META-INF"

echo Compiling Java sources...
dir /s /b "%PROJECT_DIR%src\*.java" > "%BUILD_DIR%\sources.txt"
javac -d "%CLASSES_DIR%" @"%BUILD_DIR%\sources.txt"

echo Creating manifest...
echo Manifest-Version: 1.0> "%BUILD_DIR%\META-INF\MANIFEST.MF"
echo Main-Class: Game.Game>> "%BUILD_DIR%\META-INF\MANIFEST.MF"

echo Copying resources...
xcopy /s /e /q /y "%PROJECT_DIR%Resources\*" "%CLASSES_DIR%\" >nul
xcopy /q /y "%PROJECT_DIR%MapFiles\*" "%CLASSES_DIR%\" >nul 2>&1
copy /y "%PROJECT_DIR%levels.json" "%CLASSES_DIR%\" >nul 2>&1
copy /y "%PROJECT_DIR%speedrun_records.json" "%CLASSES_DIR%\" >nul 2>&1

echo Creating JAR...
cd /d "%CLASSES_DIR%"
jar cfm "%JAR_FILE%" "%BUILD_DIR%\META-INF\MANIFEST.MF" .

echo Build complete: %JAR_FILE%
echo Run with: java -jar %NAME%.jar

endlocal
