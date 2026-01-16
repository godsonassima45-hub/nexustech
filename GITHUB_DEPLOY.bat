@echo off
echo ========================================
echo   NexusTech - DEPLOIEMENT GITHUB
echo ========================================
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

REM Vérifier Git
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Git n'est pas installe!
    echo.
    echo Installation de Git...
    start https://git-scm.com/
    echo.
    echo 1. Telechargez Git for Windows
    echo 2. Installez avec options par defaut
    echo 3. Redemarrez ce script
    pause
    exit /b 1
)

echo ✅ Git est installe
echo.

REM Configuration Git
echo ⚙️ Configuration de Git...
git config --global user.name "Votre Nom"
git config --global user.email "votre-email@example.com"

echo.
echo 📁 Initialisation du repository Git...
git init

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
- HTTPS security configuration
- PostgreSQL database support
- Complete documentation
- Ready for Render deployment"

echo.
echo ========================================
echo   ETAPE SUIVANTE MANUELLE REQUISE
echo ========================================
echo.
echo 1. 🌐 Allez sur https://github.com
echo 2. 📧 Connectez-vous ou creez un compte
echo 3. ➕ "New repository"
echo 4. 📝 Repository name: nexustech
echo 5. 🌍 Public ou Private
echo 6. ✅ "Create repository"
echo.
echo 7. 📋 Copiez l'URL du repository:
echo    https://github.com/votre-username/nexustech.git
echo.
echo 8. 🔄 Revenez ici et appuyez sur une touche pour continuer...
pause

set /p github_url="Entrez l'URL de votre repository GitHub: "

echo.
echo 🔗 Connexion au repository GitHub...
git remote add origin %github_url%

echo.
echo 🌐 Poussage vers GitHub...
git branch -M main
git push -u origin main

if %errorlevel% neq 0 (
    echo ❌ Erreur lors du push vers GitHub
    echo.
    echo Solutions possibles:
    echo 1. Verifiez que le repository existe sur GitHub
    echo 2. Verifiez que vous avez les droits d'ecriture
    echo 3. Verifiez l'URL du repository
    echo 4. Essayez: git push -u origin main --force
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ NexusTech est maintenant sur GitHub!
echo.
echo ========================================
echo   ETAPE SUIVANTE: DEPLOIEMENT RENDER
echo ========================================
echo.
echo 1. 🌐 Allez sur https://render.com
echo 2. 📧 "Sign up" (gratuit)
echo 3. 🔗 "Connect GitHub"
echo 4. 📁 Autorisez l'acces a nexustech
echo 5. 🚀 "New Web Service"
echo 6. 📁 Choisissez le repository: nexustech
echo 7. ⚙️ Configuration:
echo    - Name: nexustech
echo    - Environment: Python 3
echo    - Build: pip install -r requirements.txt
echo    - Start: gunicorn projet.wsgi:application --bind 0.0.0.0:$PORT --workers 3
echo.
echo 8. 🔧 Variables d'environnement:
echo    SECRET_KEY=nexustech-production-secure-key-123456789
echo    DEBUG=False
echo    ALLOWED_HOSTS=localhost,127.0.0.1,.onrender.com,nexustech.io,www.nexustech.io
echo    SECURE_SSL_REDIRECT=True
echo.
echo 9. 🗄️ Ajoutez PostgreSQL
echo 10. 🚀 Lancez le deploiement
echo.
echo ========================================
echo   RESULTAT FINAL
echo ========================================
echo.
echo 🌐 Site: https://nexustech.onrender.com
echo 🔒 Domaine: https://nexustech.io
echo ⚙️ Admin: https://nexustech.io/admin
echo 👤 Login: admin / NexusTech2024!
echo.
echo 🎉 NexusTech sera 100% fonctionnel!
echo.
echo 📋 Documentation complete: GUIDE_COMPLET.md
echo.
pause
