@echo off
echo ========================================
echo   NexusTech - DEPLOIEMENT COMPLET
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
    echo Installation de Python...
    start https://www.python.org/downloads/
    echo.
    echo 1. Telechargez Python 3.11+
    echo 2. Cochez "Add Python to PATH"
    echo 3. Installez Python
    echo 4. Redemarrez ce script
    pause
    exit /b 1
)

echo ✅ Python est installe
echo.

REM Créer l'environnement virtuel
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
echo 👤 Creation du superutilisateur...
python manage.py shell -c "
from django.contrib.auth.models import User;
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@nexustech.io', 'NexusTech2024!')
    print('✅ Superutilisateur admin cree')
else:
    print('✅ Superutilisateur admin existe deja')
"

echo.
echo 🧪 Test du serveur local...
echo.
echo Lancement du serveur de test...
echo Appuyez sur Ctrl+C pour arreter le serveur
echo.
echo Le site sera accessible sur: http://127.0.0.1:8000
echo Admin: http://127.0.0.1:8000/admin
echo Login: admin / NexusTech2024!
echo.
pause

python manage.py runserver 0.0.0.0:8000

echo.
echo ========================================
echo   ETAPE SUIVANTE: DEPLOIEMENT EN LIGNE
echo ========================================
echo.
echo Votre site fonctionne localement!
echo.
echo POUR METTRE EN LIGNE:
echo.
echo 1. 💻 Installez Git depuis: https://git-scm.com/
echo 2. 🔄 Redemarrez votre ordinateur
echo 3. 🌐 Allez sur https://github.com
echo 4. 📁 Creez un repository: "nexustech"
echo 5. 🚀 Executez ces commandes:
echo.
echo    cd "c:\Users\hacker\Desktop\IA site web\site_web_professionnel"
echo    git init
echo    git config --global user.name "Votre Nom"
echo    git config --global user.email "votre-email@example.com"
echo    git add .
echo    git commit -m "feat: NexusTech ready for production"
echo    git remote add origin https://github.com/votre-username/nexustech.git
echo    git branch -M main
echo    git push -u origin main
echo.
echo 6. 🌐 Allez sur https://render.com
echo 7. 🔗 Connectez votre compte GitHub
echo 8. 🚀 "New Web Service" → Repository: nexustech
echo 9. ⚙️ Build: pip install -r requirements.txt
echo 10. 🚀 Start: gunicorn projet.wsgi:application --bind 0.0.0.0:$PORT --workers 3
echo 11. 🔧 Variables d'environnement:
echo     SECRET_KEY=nexustech-production-secure-key-123456789
echo     DEBUG=False
echo     ALLOWED_HOSTS=localhost,127.0.0.1,.onrender.com,nexustech.io,www.nexustech.io
echo     SECURE_SSL_REDIRECT=True
echo 12. 🗄️ Ajoutez PostgreSQL
echo 13. 🚀 Lancez le deploiement
echo.
echo ========================================
echo   RESULTAT FINAL:
echo ========================================
echo.
echo 🌐 Site en ligne: https://nexustech.onrender.com
echo 🔒 Domaine perso: https://nexustech.io
echo ⚙️ Admin: https://nexustech.io/admin
echo 👤 Login: admin / NexusTech2024!
echo.
echo 🎉 NexusTech sera 100% fonctionnel!
echo.
pause
