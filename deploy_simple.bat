@echo off
echo ========================================
echo   NexusTech - Deploiement Simplifie
echo ========================================
echo.

REM Vérifier si on est dans le bon répertoire
if not exist "manage.py" (
    echo ❌ Ce script doit etre execute depuis la racine du projet Django!
    echo.
    echo Naviguez vers: "c:\Users\hacker\Desktop\IA site web\site_web_professionnel"
    echo.
    pause
    exit /b 1
)

echo ✅ Repertoire du projet Django verifie
echo.

REM Vérifier Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python n'est pas installe!
    echo.
    echo Veuillez installer Python depuis: https://www.python.org/
    echo.
    pause
    exit /b 1
)

echo ✅ Python est installe
echo.

REM Vérifier l'environnement virtuel
if not exist "venv" (
    echo 🐍 Creation de l'environnement virtuel...
    python -m venv venv
    call venv\Scripts\activate
    pip install --upgrade pip
) else (
    echo 🐍 Activation de l'environnement virtuel...
    call venv\Scripts\activate
)

echo.
echo 📦 Installation des dependances...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo ❌ Erreur lors de l'installation des dependances
    pause
    exit /b 1
)

echo.
echo 🔍 Verification de la configuration Django...
python manage.py check --deploy
if %errorlevel% neq 0 (
    echo ❌ Erreurs dans la configuration Django
    echo.
    echo Continuez malgre les avertissements...
)

echo.
echo 🎨 Collecte des fichiers statiques...
python manage.py collectstatic --noinput --clear
if %errorlevel% neq 0 (
    echo ❌ Erreur lors de la collecte des fichiers statiques
    pause
    exit /b 1
)

echo.
echo 🗄️ Migration de la base de donnees...
python manage.py migrate
if %errorlevel% neq 0 (
    echo ❌ Erreur lors des migrations
    pause
    exit /b 1
)

echo.
echo ✅ NexusTech est pret pour le deploiement!
echo.
echo ========================================
echo   ETAPES SUIVANTES MANUELLES:
echo ========================================
echo.
echo 1. Installez Git depuis: https://git-scm.com/
echo 2. Redemarrez votre ordinateur
echo 3. Creez un repository sur GitHub: nexustech
echo 4. Executez ces commandes:
echo.
echo    git init
echo    git config --global user.name "Votre Nom"
echo    git config --global user.email "votre-email@example.com"
echo    git add .
echo    git commit -m "feat: NexusTech ready for production"
echo    git remote add origin https://github.com/votre-username/nexustech.git
echo    git branch -M main
echo    git push -u origin main
echo.
echo 5. Allez sur https://render.com
echo 6. Connectez GitHub et creez un Web Service
echo 7. Configurez les variables d'environnement:
echo    SECRET_KEY=nexustech-secure-key-123456789
echo    DEBUG=False
echo    ALLOWED_HOSTS=localhost,127.0.0.1,.onrender.com,nexustech.io,www.nexustech.io
echo    SECURE_SSL_REDIRECT=True
echo.
echo 8. Ajoutez une base de donnees PostgreSQL
echo 9. Lancez le deploiement
echo.
echo ========================================
echo   RESULTAT FINAL:
echo ========================================
echo.
echo 🌐 Site: https://nexustech.onrender.com
echo ⚙️ Admin: https://nexustech.onrender.com/admin
echo 👤 Login: admin / NexusTech2024!
echo.
echo 🎉 NexusTech sera en ligne!
echo.
pause
