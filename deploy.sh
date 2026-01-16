#!/bin/bash

# Script de déploiement pour NexusTech - Render
# Usage: ./deploy.sh [local|render]

set -e  # Arrêter le script en cas d'erreur

# Variables
ENVIRONMENT=${1:-local}
PROJECT_NAME="nexustech"
BACKUP_DIR="./backups"
LOG_FILE="./logs/deploy.log"

# Couleurs pour les logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction de log
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a $LOG_FILE
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" | tee -a $LOG_FILE
}

warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1" | tee -a $LOG_FILE
}

info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO:${NC} $1" | tee -a $LOG_FILE
}

# Vérifier si on est dans le bon répertoire
if [ ! -f "manage.py" ]; then
    error "Ce script doit être exécuté depuis la racine du projet Django"
    exit 1
fi

# Créer les répertoires nécessaires
mkdir -p $BACKUP_DIR
mkdir -p $(dirname $LOG_FILE)

log "🚀 Début du déploiement pour NexusTech - Environnement: $ENVIRONMENT"

# 1. Sauvegarde de la base de données locale
if [ "$ENVIRONMENT" = "local" ] && [ -f "db.sqlite3" ]; then
    log "📦 Sauvegarde de la base de données locale..."
    cp db.sqlite3 $BACKUP_DIR/db_backup_$(date +%Y%m%d_%H%M%S).sqlite3
    log "Base de données locale sauvegardée"
fi

# 2. Vérification de l'environnement virtuel
if [ ! -d "venv" ]; then
    log "🐍 Création de l'environnement virtuel..."
    python -m venv venv
    source venv/bin/activate
    pip install --upgrade pip
else
    log "🐍 Activation de l'environnement virtuel..."
    source venv/bin/activate
fi

# 3. Installation des dépendances
log "📦 Installation des dépendances Python..."
pip install -r requirements.txt
log "Dépendances installées"

# 4. Vérification du code
log "🔍 Vérification du code Django..."
python manage.py check --deploy
if [ $? -eq 0 ]; then
    log "✅ Code Django validé"
else
    error "❌ Erreurs dans le code Django"
    exit 1
fi

# 5. Collecte des fichiers statiques
log "🎨 Collecte des fichiers statiques..."
python manage.py collectstatic --noinput --clear
log "Fichiers statiques collectés"

# 6. Migration de la base de données
log "🗄️ Migration de la base de données..."
python manage.py migrate
log "Base de données migrée"

# 7. Test avec Gunicorn (local)
if [ "$ENVIRONMENT" = "local" ]; then
    log "🧪 Test local avec Gunicorn..."
    
    # Arrêter les processus Gunicorn existants
    pkill -f "gunicorn projet.wsgi" || true
    
    # Démarrer Gunicorn en arrière-plan
    gunicorn projet.wsgi:application --bind 127.0.0.1:8000 --workers 3 --daemon
    
    # Attendre que le serveur démarre
    sleep 3
    
    # Test de santé
    if curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8000/ | grep -q "200"; then
        log "✅ Test Gunicorn réussi"
    else
        error "❌ Test Gunicorn échoué"
        pkill -f "gunicorn projet.wsgi"
        exit 1
    fi
    
    # Arrêter Gunicorn
    pkill -f "gunicorn projet.wsgi"
fi

# 8. Préparation pour Render
if [ "$ENVIRONMENT" = "render" ]; then
    log "🌐 Préparation pour Render..."
    
    # Vérifier que le repository Git est propre
    if [ -n "$(git status --porcelain)" ]; then
        log "📝 Commit des changements..."
        git add .
        git commit -m "Auto-deploy: $(date)"
    fi
    
    # Pousser vers GitHub
    log "📤 Envoi vers GitHub..."
    git push origin main
    
    log "✅ Code poussé vers GitHub - Render déploiera automatiquement"
fi

# 9. Vérification finale
log "🔍 Vérification finale de l'application..."
python manage.py check --deploy
if [ $? -eq 0 ]; then
    log "✅ Application prête pour le déploiement!"
else
    error "❌ Problèmes détectés lors de la vérification finale"
    exit 1
fi

# 10. Nettoyage
log "🧹 Nettoyage des fichiers temporaires..."
find $BACKUP_DIR -name "*.sqlite3" -mtime +7 -delete 2>/dev/null || true
find . -name "*.pyc" -delete 2>/dev/null || true
find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
log "Nettoyage terminé"

# 11. Instructions finales
if [ "$ENVIRONMENT" = "local" ]; then
    log "🧪 Déploiement local terminé!"
    info "Pour démarrer le serveur local:"
    echo "   python manage.py runserver"
    info "Pour tester avec Gunicorn:"
    echo "   gunicorn projet.wsgi:application --bind 0.0.0.0:8000"
    info "Pour accéder à l'admin:"
    echo "   http://127.0.0.1:8000/admin/"
elif [ "$ENVIRONMENT" = "render" ]; then
    log "🌐 Déploiement pour Render terminé!"
    info "Prochaines étapes:"
    echo "   1. Vérifiez le déploiement sur Render Dashboard"
    echo "   2. Configurez votre domaine personnalisé"
    echo "   3. Configurez les variables d'environnement sur Render"
    echo "   4. Testez l'application en production"
fi

# 12. Statistiques
log "📊 Statistiques du déploiement:"
log "   - Fichiers statiques: $(find staticfiles -type f 2>/dev/null | wc -l) fichiers"
log "   - Taille des statiques: $(du -sh staticfiles 2>/dev/null | cut -f1)"
log "   - Version Git: $(git rev-parse --short HEAD 2>/dev/null || echo 'N/A')"
log "   - Environnement: $ENVIRONMENT"

log "✨ NexusTech est prêt pour le déploiement! 🚀"
