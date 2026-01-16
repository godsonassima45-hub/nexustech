@echo off
echo ========================================
echo   NexusTech - Deploiement Windows
echo ========================================
echo.

REM Vérifier si Git est installé
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Git n'est pas installe!
    echo.
    echo Veuillez installer Git depuis: https://git-scm.com/
    echo.
    pause
    exit /b 1
)

echo ✅ Git est installe
echo.

REM Vérifier si on est dans le bon répertoire
if not exist "manage.py" (
    echo ❌ Ce script doit etre execute depuis la racine du projet Django!
    echo.
    pause
    exit /b 1
)

echo ✅ Repertoire du projet Django verifie
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
    pause
    exit /b 1
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
echo 📝 Preparation Git...
git init
git config --global user.name "Votre Nom"
git config --global user.email "votre-email@example.com"

echo.
echo 📤 Ajout des fichiers...
git add .

echo.
echo 💾 Commit des changements...
git commit -m "feat: NexusTech ready for production deployment

- Django 5.2.8 production ready
- NexusTech branding with nexustech.io domain
- Complete authentication system
- Dark/light mode with persistence
- Responsive design with modern UI
- Render deployment configuration
- PostgreSQL database support
- Security headers and SSL ready
- Complete documentation"

echo.
echo 🌐 Pousser vers GitHub...
echo.
echo ⚠️  ASSUREZ-VOUS D'AVOIR CREE LE REPOSITORY GITHUB AVANT DE CONTINUER!
echo.
echo 1. Allez sur https://github.com
echo 2. Creez un nouveau repository: nexustech
echo 3. Copiez l'URL du repository
echo.
set /p github_url="Entrez l'URL de votre repository GitHub: "

git remote add origin %github_url%
git branch -M main
git push -u origin main

if %errorlevel% neq 0 (
    echo ❌ Erreur lors du push vers GitHub
    echo.
    echo Verifiez:
    echo - Que le repository existe bien sur GitHub
    echo - Que vous avez les droits d'ecriture
    echo - Que l'URL est correcte
    pause
    exit /b 1
)

echo.
echo ✅ NexusTech est pret pour le deploiement sur Render!
echo.
echo 📋 Prochaines etapes:
echo.
echo 1. Allez sur https://render.com
echo 2. Connectez votre compte GitHub
echo 3. Creez un "Web Service" avec le repository nexustech
echo 4. Configurez les variables d'environnement:
echo    - SECRET_KEY=nexustech-secret-key-very-long-and-secure
echo    - DEBUG=False
echo    - ALLOWED_HOSTS=localhost,127.0.0.1,.onrender.com,nexustech.io,www.nexustech.io
echo 5. Ajoutez une base de donnees PostgreSQL
echo 6. Lancez le deploiement
echo.
echo 🌐 Votre site sera accessible sur: https://nexustech.onrender.com
echo.
echo 📞 Documentation complete: DEPLOY_NOW.md
echo.
echo 🎉 NexusTech est pret pour la mise en ligne!
echo.
pause
