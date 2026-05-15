@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERREUR : 'git' n'est pas installé.
    echo Veuillez installer git pour continuer.
    echo.
    pause
    exit /b 1
)

echo L'outil 'git' est bien installé. Démarrage du script...
echo.

:: ===========================
:: Modules Evarisk
:: ===========================
set response=
set /p response="Souhaitez-vous parcourir la liste des modules Evarisk ? (o/N) "
if /I "!response!"=="o" set response=oui
if /I "!response!"=="oui" if /I "!response!"=="y" set response=oui
if /I "!response!"=="yes" set response=oui

if /I "!response!"=="oui" (
    echo.
    echo --- Sélection des modules Evarisk ---
    
    set repos="https://github.com/Evarisk/Digirisk|digiriskdolibarr" "https://github.com/Evarisk/Saturne|saturne" "https://github.com/Evarisk/dolicar|dolicar" "https://github.com/Evarisk/dolimeet|dolimeet" "https://github.com/Evarisk/digiboard|digiboard" "https://github.com/Evarisk/DoliSecu|dolisecu"
    
    for %%A in (!repos!) do (
        for /F "tokens=1,2 delims=|" %%B in ("%%~A") do (
            echo.
            echo Voulez-vous installer le module suivant ?
            echo   -^> Dépôt      : %%B
            echo   -^> Destination : %%C
            set install_confirm=
            set /p install_confirm="   (o/N) "
            
            set do_install=0
            if /I "!install_confirm!"=="o" set do_install=1
            if /I "!install_confirm!"=="oui" set do_install=1
            if /I "!install_confirm!"=="y" set do_install=1
            if /I "!install_confirm!"=="yes" set do_install=1
            
            if !do_install!==1 (
                echo Clonage en cours...
                git clone "%%B" "%%C"
                if !errorlevel! equ 0 (
                    echo Succès !
                ) else (
                    echo ERREUR lors du clonage de %%B. Le dossier existe peut-être déjà.
                )
            ) else (
                echo Module ignoré.
            )
            echo -----------------------------------------------------
        )
    )
    echo.
    echo --- Fin de la sélection des modules Evarisk ---
) else (
    echo Installation des modules Evarisk entièrement ignorée.
)

:: ===========================
:: Modules Eoxia
:: ===========================
echo.
set response=
set /p response="Souhaitez-vous parcourir la liste des modules Eoxia ? (o/N) "
if /I "!response!"=="o" set response=oui
if /I "!response!"=="y" set response=oui
if /I "!response!"=="yes" set response=oui

if /I "!response!"=="oui" (
    echo.
    echo --- Sélection des modules Eoxia ---
    
    set repos="https://github.com/Eoxia/WPshop|WPshop" "https://github.com/Eoxia/reedcrm|reedcrm" "https://github.com/Eoxia/priseo|priseo" "https://github.com/Eoxia/EasyURL|EasyURL"
    
    for %%A in (!repos!) do (
        for /F "tokens=1,2 delims=|" %%B in ("%%~A") do (
            echo.
            echo Voulez-vous installer le module suivant ?
            echo   -^> Dépôt      : %%B
            echo   -^> Destination : %%C
            set install_confirm=
            set /p install_confirm="   (o/N) "
            
            set do_install=0
            if /I "!install_confirm!"=="o" set do_install=1
            if /I "!install_confirm!"=="oui" set do_install=1
            if /I "!install_confirm!"=="y" set do_install=1
            if /I "!install_confirm!"=="yes" set do_install=1
            
            if !do_install!==1 (
                echo Clonage en cours...
                git clone "%%B" "%%C"
                if !errorlevel! equ 0 (
                    echo Succès !
                ) else (
                    echo ERREUR lors du clonage de %%B. Le dossier existe peut-être déjà.
                )
            ) else (
                echo Module ignoré.
            )
            echo -----------------------------------------------------
        )
    )
    echo.
    echo --- Fin de la sélection des modules Eoxia ---
) else (
    echo Installation des modules Eoxia entièrement ignorée.
)

echo.
echo ✅ Script terminé ! 👋
echo.
pause
