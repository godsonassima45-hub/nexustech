#!/bin/bash

echo "========================================"
echo "   NexusTech - DEPLOIEMENT COMPLET"
echo "========================================"
echo

# Vérifier si on est dans le bon répertoire
if [ ! -f "manage.py" ]; then
    echo "❌ Ce script doit être exécuté depuis la racine du projet Django!"
    echo
    echo "Naviguez vers: ~/Desktop/IA site web/site_web_professionnel"
    echo
    exit 1
fi

echo "✅ Répertoire du projet Django vérifié"
echo

# Vérifier Python
if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    echo "❌ Python n'est pas installé!"
    echo
    echo "Installation de Python..."
    echo "1. Allez sur https://www.python.org/downloads/"
    echo "2. Téléchargez Python 3.11+"
    echo "3. Cochez 'Add Python to PATH'"
    echo "4. Installez Python"
    echo "5. Redémarrez ce script"
    exit 1
fi

# Utiliser python3 si disponible, sinon python
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
else
    PYTHON_CMD="python"
fi

echo "✅ Python est installé: $PYTHON_CMD"
echo

# Créer l'environnement virtuel
if [ ! -d "venv" ]; then
    echo "🐍 Création de l'environnement virtuel..."
    $PYTHON_CMD -m venv venv
    source venv/Scripts/activate
    pip install --upgrade pip
else
    echo "🐍 Activation de l'environnement virtuel..."
    source venv/Scripts/activate
fi

echo
echo "📦 Installation des dépendances..."
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de l'installation des dépendances"
    exit 1
fi

echo
echo "🔍 Vérification de la configuration Django..."
$PYTHON_CMD manage.py check --deploy
echo

echo "🎨 Collecte des fichiers statiques..."
$PYTHON_CMD manage.py collectstatic --noinput --clear
if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de la collecte des fichiers statiques"
    exit 1
fi

echo
echo "🗄️ Migration de la base de données..."
$PYTHON_CMD manage.py migrate
if [ $? -ne 0 ]; then
    echo "❌ Erreur lors des migrations"
    exit 1
fi

echo
echo "👤 Création du superutilisateur..."
$PYTHON_CMD manage.py shell << EOF
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@nexustech.io', 'NexusTech2024!')
    print('✅ Superutilisateur admin créé')
else:
    print('✅ Superutilisateur admin existe déjà')
EOF

echo
echo "🧪 Test du serveur local..."
echo
echo "Lancement du serveur de test..."
echo "Appuyez sur Ctrl+C pour arrêter le serveur"
echo
echo "Le site sera accessible sur: http://127.0.0.1:8000"
echo "Admin: http://127.0.0.1:8000/admin"
echo "Login: admin / NexusTech2024!"
echo
read -p "Appuyez sur Entrée pour lancer le serveur..."

$PYTHON_CMD manage.py runserver 0.0.0.0:8000

echo
echo "========================================"
echo "   ÉTAPE SUIVANTE: DÉPLOIEMENT EN LIGNE"
echo "========================================"
echo
echo "Votre site fonctionne localement!"
echo
echo "POUR METTRE EN LIGNE:"
echo
echo "1. 💻 Lancez: ./github_deploy.sh"
echo "2. 🌐 Suivez les instructions pour GitHub"
echo "3. 🚀 Configurez Render"
echo
echo "========================================"
echo "   RÉSULTAT FINAL:"
echo "========================================"
echo
echo "🌐 Site en ligne: https://nexustech.onrender.com"
echo "🔒 Domaine perso: https://nexustech.io"
echo "⚙️ Admin: https://nexustech.io/admin"
echo "👤 Login: admin / NexusTech2024!"
echo
echo "🎉 NexusTech sera 100% fonctionnel!"
echo
