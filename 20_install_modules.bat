@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set CSV_FILE=list-repo-to-clone.csv
set "LOG_FILE=git_update.log"

set DATE_STR=!date! !time:~0,8!
echo --- Session d'installation démarrée le !DATE_STR! --- >> "!LOG_FILE!"
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
        for /F "usebackq skip=1 tokens=1,2,3,4,5,6 delims=," %%A in ("%CSV_FILE%") do (
            if /I "%%A"=="%%O" (
                
                set "CHOICE=%%A"
                set "URL_REPO=%%B"
                set "CSV_BRANCH=%%~C"
                set "URL_FORK=%%D"
                set "DOSSIER=%%E"
                set "TOCLONE=%%F"
                
                set "TARGET_URL="
                
                :: Est-ce que le choix correspond au repo original ?
                echo !URL_REPO! | find /I "!CHOICE!" >nul
                if !errorlevel! equ 0 (
                    set "TARGET_URL=!URL_REPO!"
                ) else (
                    :: Est-ce que le choix correspond au fork ?
                    echo !URL_FORK! | find /I "!CHOICE!" >nul
                    if !errorlevel! equ 0 (
                        set "TARGET_URL=!URL_FORK!"
                    )
                )

                if "!TARGET_URL!"=="" (
                    echo.
                    echo ❌ ERREUR DE CONFIGURATION CSV
                    echo   -^> La valeur '!CHOICE!' ne se trouve ni dans l'URL du repo original, ni dans celle du fork.
                    echo   -^> Repo original : !URL_REPO!
                    echo   -^> Fork : !URL_FORK!
                    set DATE_STR=!date! !time:~0,8!
                    echo [!DATE_STR!] - ERREUR  : Configuration '!CHOICE!' invalide pour '!DOSSIER!' >> "!LOG_FILE!"
                    echo -----------------------------------------------------
                ) else (
                    set "GIT_CLONE_CMD=git clone "!TARGET_URL!" "!DOSSIER!""
                    if not "!CSV_BRANCH!"=="" if /I not "!CSV_BRANCH!"=="default" (
                        set "GIT_CLONE_CMD=git clone -b "!CSV_BRANCH!" "!TARGET_URL!" "!DOSSIER!""
                    )

                    if "!TOCLONE!"=="0" (
                        echo.
                        echo Module silencieusement ignoré ^(config toclone=0^) : !TARGET_URL!
                        set DATE_STR=!date! !time:~0,8!
                        echo [!DATE_STR!] - IGNORÉ  : Module '!TARGET_URL!' silencieusement ignoré ^(toclone=0^) >> "!LOG_FILE!"
                        echo -----------------------------------------------------
                    ) else if "!TOCLONE!"=="2" (
                        echo.
                        echo Installation AUTOMATIQUE du module ^(config toclone=2^) :
                        echo   -^> Dépôt       : !TARGET_URL!
                        echo   -^> Destination : !DOSSIER!
                        if not "!CSV_BRANCH!"=="" if /I not "!CSV_BRANCH!"=="default" echo   -^> Branche     : !CSV_BRANCH!
                        echo Clonage en cours...
                        !GIT_CLONE_CMD!
                        if !errorlevel! equ 0 (
                            echo ✅ Succès !
                            set DATE_STR=!date! !time:~0,8!
                            echo [!DATE_STR!] - SUCCÈS  : Clonage du dépôt '!TARGET_URL!' dans '!DOSSIER!' >> "!LOG_FILE!"
                        ) else (
                            echo.
                            echo ❌ ERREUR : Impossible de cloner !TARGET_URL!
                            echo    -^> Raisons possibles : Le dépôt n'existe pas, il est privé, ou le dossier cible est déjà pris.
                            set DATE_STR=!date! !time:~0,8!
                            echo [!DATE_STR!] - ERREUR  : Échec du clonage du dépôt '!TARGET_URL!' >> "!LOG_FILE!"
                        )
                        echo -----------------------------------------------------
                    ) else (
                        echo.
                        echo Voulez-vous installer le module suivant ?
                        echo   -^> Dépôt       : !TARGET_URL!
                        echo   -^> Destination : !DOSSIER!
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
                                set DATE_STR=!date! !time:~0,8!
                                echo [!DATE_STR!] - SUCCÈS  : Clonage du dépôt '!TARGET_URL!' dans '!DOSSIER!' >> "!LOG_FILE!"
                            ) else (
                                echo.
                                echo ❌ ERREUR : Impossible de cloner !TARGET_URL!
                                echo    -^> Raisons possibles : Le dépôt n'existe pas, il est privé, ou le dossier cible est déjà pris.
                                set DATE_STR=!date! !time:~0,8!
                                echo [!DATE_STR!] - ERREUR  : Échec du clonage du dépôt '!TARGET_URL!' >> "!LOG_FILE!"
                            )
                        ) else (
                            echo Module ignoré.
                            set DATE_STR=!date! !time:~0,8!
                            echo [!DATE_STR!] - IGNORÉ  : Installation annulée par l'utilisateur pour '!TARGET_URL!' >> "!LOG_FILE!"
                        )
                        echo -----------------------------------------------------
                    )
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

echo --- Session terminée. --- >> "!LOG_FILE!"
echo ✅ Script terminé ! 👋
echo Journal des opérations disponible dans le fichier : %LOG_FILE%
echo.
pause
