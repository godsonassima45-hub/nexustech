#!/bin/bash

echo "========================================"
echo "   NexusTech - DÉPLOIEMENT GITHUB"
echo "========================================"
echo

# Vérifier si on est dans le bon répertoire
if [ ! -f "manage.py" ]; then
    echo "❌ Ce script doit être exécuté depuis la racine du projet Django!"
    echo
    exit 1
fi

echo "✅ Répertoire du projet Django vérifié"
echo

# Vérifier Git
if ! command -v git &> /dev/null; then
    echo "❌ Git n'est pas installé!"
    echo
    echo "Installation de Git..."
    echo "1. Allez sur https://git-scm.com/"
    echo "2. Téléchargez Git for Windows"
    echo "3. Installez avec options par défaut"
    echo "4. Redémarrez ce script"
    exit 1
fi

echo "✅ Git est installé"
echo

# Configuration Git
echo "⚙️ Configuration de Git..."
echo "Entrez votre nom (pour Git):"
read -p "Nom: " git_name
echo "Entrez votre email (pour Git):"
read -p "Email: " git_email

git config --global user.name "$git_name"
git config --global user.email "$git_email"

echo
echo "📁 Initialisation du repository Git..."
git init

echo
echo "📤 Ajout des fichiers..."
git add .

echo
echo "💾 Commit des changements..."
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

echo
echo "========================================"
echo "   ÉTAPE SUIVANTE MANUELLE REQUISE"
echo "========================================"
echo
echo "1. 🌐 Allez sur https://github.com"
echo "2. 📧 Connectez-vous ou créez un compte"
echo "3. ➕ 'New repository'"
echo "4. 📝 Repository name: nexustech"
echo "5. 🌍 Public ou Private"
echo "6. ✅ 'Create repository'"
echo
echo "7. 📋 Copiez l'URL du repository:"
echo "    https://github.com/votre-username/nexustech.git"
echo
read -p "8. 🔄 Entrez l'URL de votre repository GitHub: " github_url

echo
echo "🔗 Connexion au repository GitHub..."
git remote add origin "$github_url"

echo
echo "🌐 Poussage vers GitHub..."
git branch -M main
git push -u origin main

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors du push vers GitHub"
    echo
    echo "Solutions possibles:"
    echo "1. Vérifiez que le repository existe sur GitHub"
    echo "2. Vérifiez que vous avez les droits d'écriture"
    echo "3. Vérifiez l'URL du repository"
    echo "4. Essayez: git push -u origin main --force"
    echo
    exit 1
fi

echo
echo "✅ NexusTech est maintenant sur GitHub!"
echo
echo "========================================"
echo "   ÉTAPE SUIVANTE: DÉPLOIEMENT RENDER"
echo "========================================"
echo
echo "1. 🌐 Allez sur https://render.com"
echo "2. 📧 'Sign up' (gratuit)"
echo "3. 🔗 'Connect GitHub'"
echo "4. 📁 Autorisez l'accès à nexustech"
echo "5. 🚀 'New Web Service'"
echo "6. 📁 Choisissez le repository: nexustech"
echo "7. ⚙️ Configuration:"
echo "   - Name: nexustech"
echo "   - Environment: Python 3"
echo "   - Build: pip install -r requirements.txt"
echo "   - Start: gunicorn projet.wsgi:application --bind 0.0.0.0:\$PORT --workers 3"
echo
echo "8. 🔧 Variables d'environnement:"
echo "   SECRET_KEY=nexustech-production-secure-key-123456789"
echo "   DEBUG=False"
echo "   ALLOWED_HOSTS=localhost,127.0.0.1,.onrender.com,nexustech.io,www.nexustech.io"
echo "   SECURE_SSL_REDIRECT=True"
echo
echo "9. 🗄️ Ajoutez PostgreSQL"
echo "10. 🚀 Lancez le déploiement"
echo
echo "========================================"
echo "   RÉSULTAT FINAL"
echo "========================================"
echo
echo "🌐 Site: https://nexustech.onrender.com"
echo "🔒 Domaine: https://nexustech.io"
echo "⚙️ Admin: https://nexustech.io/admin"
echo "👤 Login: admin / NexusTech2024!"
echo
echo "🎉 NexusTech sera 100% fonctionnel!"
echo
echo "📋 Documentation complète: GUIDE_COMPLET.md"
echo
