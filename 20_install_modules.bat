@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set CSV_FILE=list-repo-to-clone.csv

git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERREUR : 'git' n'est pas installé.
    echo Veuillez installer git pour continuer.
    echo.
    pause
    exit /b 1
)

if not exist "%CSV_FILE%" (
    echo ERREUR : Le fichier '%CSV_FILE%' est introuvable.
    echo.
    pause
    exit /b 1
)

echo L'outil 'git' est bien installé. Démarrage du script...
echo.

:: 1. Extraction dynamique des organisations uniques depuis le CSV
set "ORG_LIST="
for /F "usebackq skip=1 tokens=1 delims=," %%A in ("%CSV_FILE%") do (
    if not defined ORG_SEEN_%%A (
        set ORG_SEEN_%%A=1
        set ORG_LIST=!ORG_LIST! %%A
    )
)

:: 2. Boucle sur chaque organisation trouvée
for %%O in (!ORG_LIST!) do (
    echo ===========================
    echo Modules %%O
    echo ===========================
    
    set response=
    set /p response="Souhaitez-vous parcourir la liste des modules %%O ? (o/N) "
    
    set do_org=0
    if /I "!response!"=="o" set do_org=1
    if /I "!response!"=="oui" set do_org=1
    if /I "!response!"=="y" set do_org=1
    if /I "!response!"=="yes" set do_org=1

    if !do_org!==1 (
        echo.
        echo --- Sélection des modules %%O ---
        
        :: Lecture du CSV pour trouver les dépôts de cette organisation
        for /F "usebackq skip=1 tokens=1,2,3,4,5 delims=," %%A in ("%CSV_FILE%") do (
            if /I "%%A"=="%%O" (
                
                set "CSV_BRANCH=%%~B"
                set "GIT_CLONE_CMD=git clone "%%C" "%%D""
                if not "!CSV_BRANCH!"=="" if /I not "!CSV_BRANCH!"=="default" (
                    set "GIT_CLONE_CMD=git clone -b "!CSV_BRANCH!" "%%C" "%%D""
                )

                if "%%E"=="0" (
                    echo.
                    echo Module silencieusement ignoré ^(config toclone=0^) : %%C
                    echo -----------------------------------------------------
                ) else if "%%E"=="2" (
                    echo.
                    echo Installation AUTOMATIQUE du module ^(config toclone=2^) :
                    echo   -^> Dépôt       : %%C
                    echo   -^> Destination : %%D
                    if not "!CSV_BRANCH!"=="" if /I not "!CSV_BRANCH!"=="default" echo   -^> Branche     : !CSV_BRANCH!
                    echo Clonage en cours...
                    !GIT_CLONE_CMD!
                    if !errorlevel! equ 0 (
                        echo ✅ Succès !
                    ) else (
                        echo.
                        echo ❌ ERREUR : Impossible de cloner %%C
                        echo    -^> Raisons possibles : Le dépôt n'existe pas, il est privé, ou le dossier cible est déjà pris.
                    )
                    echo -----------------------------------------------------
                ) else (
                    echo.
                    echo Voulez-vous installer le module suivant ?
                    echo   -^> Dépôt       : %%C
                    echo   -^> Destination : %%D
                    if not "!CSV_BRANCH!"=="" if /I not "!CSV_BRANCH!"=="default" echo   -^> Branche     : !CSV_BRANCH!
                    
                    set install_confirm=
                    set /p install_confirm="   (o/N) "
                    
                    set do_install=0
                    if /I "!install_confirm!"=="o" set do_install=1
                    if /I "!install_confirm!"=="oui" set do_install=1
                    if /I "!install_confirm!"=="y" set do_install=1
                    if /I "!install_confirm!"=="yes" set do_install=1
                    
                    if !do_install!==1 (
                        echo Clonage en cours...
                        !GIT_CLONE_CMD!
                        if !errorlevel! equ 0 (
                            echo ✅ Succès !
                        ) else (
                            echo.
                            echo ❌ ERREUR : Impossible de cloner %%C
                            echo    -^> Raisons possibles : Le dépôt n'existe pas, il est privé, ou le dossier cible est déjà pris.
                        )
                    ) else (
                        echo Module ignoré.
                    )
                    echo -----------------------------------------------------
                )
            )
        )
        echo.
        echo --- Fin de la sélection des modules %%O ---
    ) else (
        echo Installation des modules %%O ignorée.
    )
    echo.
)

echo ✅ Script terminé ! 👋
echo.
pause
