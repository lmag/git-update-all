@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set LOG_FILE=git_update.log
set LOG_FILE_PATH=%CD%\%LOG_FILE%
set CSV_FILE=list-repo-to-clone.csv

echo =================================================
echo   Mise à jour des forks depuis l'upstream
echo =================================================
echo.

if not exist "%CSV_FILE%" (
    echo ERREUR : Le fichier '%CSV_FILE%' est introuvable.
    echo Assurez-vous d'avoir exécuté 10_deploy_all.bat ou d'être dans le bon répertoire.
    echo.
    pause
    exit /b 1
)

set response=
set /p response="Voulez-vous mettre à jour tous vos forks configurés dans le CSV depuis leur upstream ? [y/N] "

if /I "!response!"=="y" goto :do_update
if /I "!response!"=="yes" goto :do_update
if /I "!response!"=="o" goto :do_update
if /I "!response!"=="oui" goto :do_update

goto :cancel_update

:do_update
echo Lancement de la mise à jour...

echo ================================================= >> "%LOG_FILE_PATH%"
set DATE_STR=!date! !time:~0,8!
echo Début de la mise à jour depuis l'upstream le !DATE_STR! >> "%LOG_FILE_PATH%"
echo ================================================= >> "%LOG_FILE_PATH%"

for /F "usebackq skip=1 delims=" %%L in ("%CSV_FILE%") do (
    set "LINE=%%L"
    set "LINE=!LINE:,,=,"",!"
    set "LINE=!LINE:,,=,"",!"
    for /F "tokens=1,2,3,4,5,6 delims=," %%A in ("!LINE!") do (
        set "URL_UPSTREAM=%%B"
        set "DOSSIER=%%E"
        
        rem Enlève les guillemets si besoin
        set "URL_UPSTREAM=!URL_UPSTREAM:"=!"
        set "DOSSIER=!DOSSIER:"=!"

        if not "!DOSSIER!"=="" (
            if exist "!DOSSIER!\.git\" (
                echo Mise à jour de : !DOSSIER!
                echo. >> "%LOG_FILE_PATH%"
                echo --- Mise à jour de [!DOSSIER!] depuis l'upstream --- >> "%LOG_FILE_PATH%"
                
                pushd "!DOSSIER!" >nul
                
                rem Ajoute ou met à jour le remote upstream
                git remote get-url upstream >nul 2>&1
                if !errorlevel! equ 0 (
                    git remote set-url upstream "!URL_UPSTREAM!" >> "%LOG_FILE_PATH%" 2>&1
                ) else (
                    git remote add upstream "!URL_UPSTREAM!" >> "%LOG_FILE_PATH%" 2>&1
                )
                
                rem Récupère la branche courante
                set "CURRENT_BRANCH="
                for /F "delims=" %%C in ('git branch --show-current') do set "CURRENT_BRANCH=%%C"
                
                echo   -^> Branche courante : !CURRENT_BRANCH!
                echo   -^> Upstream : !URL_UPSTREAM!
                
                rem Pull depuis upstream
                echo   -^> Pull depuis upstream...
                git pull upstream !CURRENT_BRANCH! > "%TEMP%\git_temp.log" 2>&1
                type "%TEMP%\git_temp.log"
                type "%TEMP%\git_temp.log" >> "%LOG_FILE_PATH%"
                echo. >> "%LOG_FILE_PATH%"
                
                rem Push vers origin
                echo   -^> Push vers origin...
                git push origin !CURRENT_BRANCH! > "%TEMP%\git_temp.log" 2>&1
                type "%TEMP%\git_temp.log"
                type "%TEMP%\git_temp.log" >> "%LOG_FILE_PATH%"
                echo. >> "%LOG_FILE_PATH%"
                
                popd >nul
            ) else (
                echo   -^> !DOSSIER! ignoré [non cloné ou pas un dépôt Git].
            )
        )
    )
)

echo ================================================= >> "%LOG_FILE_PATH%"
set DATE_STR=!date! !time:~0,8!
echo Fin de la mise à jour depuis l'upstream le !DATE_STR! >> "%LOG_FILE_PATH%"
echo ================================================= >> "%LOG_FILE_PATH%"

echo.
echo ✅ Mise à jour depuis upstream terminée. Consultez le fichier '%LOG_FILE%' pour les détails.
goto :end

:cancel_update
echo Opération annulée par l'utilisateur.

echo. >> "%LOG_FILE_PATH%"
echo ================================================= >> "%LOG_FILE_PATH%"
set DATE_STR=!date! !time:~0,8!
echo Opération annulée par l'utilisateur le !DATE_STR! >> "%LOG_FILE_PATH%"
echo ================================================= >> "%LOG_FILE_PATH%"
goto :end

:end
echo.
pause
