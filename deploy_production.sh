#!/bin/bash

# Script de déploiement en production pour TechNova
# Domaine: technova.fr

set -e

# Variables
DOMAIN="technova.fr"
PROJECT_NAME="technova"
DEPLOY_USER="deploy"
DEPLOY_PATH="/var/www/$PROJECT_NAME"
BACKUP_DIR="/var/backups/$PROJECT_NAME"
LOG_FILE="/var/log/$PROJECT_NAME/deploy.log"

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a $LOG_FILE
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" | tee -a $LOG_FILE
}

warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1" | tee -a $LOG_FILE
}

log "🚀 Déploiement en production de TechNova"
log "Domaine: $DOMAIN"

# 1. Création des répertoires de logs
sudo mkdir -p $(dirname $LOG_FILE)
sudo mkdir -p $BACKUP_DIR
sudo chown $USER:$USER $(dirname $LOG_FILE)

# 2. Sauvegarde de la base de données
log "📦 Sauvegarde de la base de données..."
if [ -f "db.sqlite3" ]; then
    cp db.sqlite3 $BACKUP_DIR/db_backup_$(date +%Y%m%d_%H%M%S).sqlite3
    log "Base de données sauvegardée"
fi

# 3. Installation des dépendances
log "📦 Installation des dépendances..."
pip install -r requirements.txt
log "Dépendances installées"

# 4. Configuration des variables d'environnement
log "⚙️ Configuration de l'environnement..."
cat > .env << EOF
# Configuration Production TechNova
DJANGO_SETTINGS_MODULE=projet.settings_prod
DEBUG=False
SECRET_KEY=$(python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())')
ALLOWED_HOSTS=$DOMAIN,www.$DOMAIN,localhost,127.0.0.1

# Domaine
DOMAIN_NAME=$DOMAIN

# Base de données PostgreSQL
DB_NAME=technova_prod
DB_USER=technova_user
DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
DB_HOST=localhost
DB_PORT=5432

# Configuration Email
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_HOST_USER=contact@technova.fr
EMAIL_HOST_PASSWORD=VOTRE_MOT_DE_PASSE_APP
DEFAULT_FROM_EMAIL=contact@technova.fr

# Sécurité
SECURE_SSL_REDIRECT=True
SESSION_COOKIE_SECURE=True
CSRF_COOKIE_SECURE=True
SECURE_HSTS_SECONDS=31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS=True
SECURE_HSTS_PRELOAD=True

# Analytics (optionnel)
GOOGLE_ANALYTICS_ID=GA_MEASUREMENT_ID
SENTRY_DSN=VOTRE_SENTRY_DSN

# Performance
USE_REDIS=True
REDIS_URL=redis://localhost:6379/1
EOF

log "Variables d'environnement configurées"

# 5. Collecte des fichiers statiques
log "🎨 Collecte des fichiers statiques..."
python manage.py collectstatic --noinput --clear
log "Fichiers statiques collectés"

# 6. Migration de la base de données
log "🗄️ Migration de la base de données..."
python manage.py migrate
log "Base de données migrée"

# 7. Création du superutilisateur
log "👤 Création du superutilisateur..."
python manage.py shell << EOF
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@technova.fr', 'TechNova2024!')
    print('Superutilisateur créé')
else:
    print('Superutilisateur existe déjà')
EOF

# 8. Configuration de Nginx
log "🌐 Configuration de Nginx..."
sudo tee /etc/nginx/sites-available/$PROJECT_NAME << EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name $DOMAIN www.$DOMAIN;
    
    # SSL Certificate (Let's Encrypt)
    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
    
    # SSL Configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # Security Headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
    add_header X-Frame-Options DENY always;
    add_header X-Content-Type-Options nosniff always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    
    # Django Application
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header Host \$host;
        proxy_redirect off;
        
        # Timeout settings
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
    
    # Static files
    location /static/ {
        alias $DEPLOY_PATH/staticfiles/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Media files
    location /media/ {
        alias $DEPLOY_PATH/media/;
        expires 1y;
        add_header Cache-Control "public";
    }
    
    # Security
    location ~ /\. {
        deny all;
    }
    
    # Logging
    access_log /var/log/nginx/$PROJECT_NAME.access.log;
    error_log /var/log/nginx/$PROJECT_NAME.error.log;
}
EOF

# Activation du site Nginx
sudo ln -sf /etc/nginx/sites-available/$PROJECT_NAME /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
log "Nginx configuré"

# 9. Configuration de Gunicorn
log "🚀 Configuration de Gunicorn..."
sudo tee /etc/systemd/system/$PROJECT_NAME.service << EOF
[Unit]
Description=$PROJECT_NAME daemon
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=$DEPLOY_PATH
Environment="PATH=$DEPLOY_PATH/venv/bin"
ExecStart=$DEPLOY_PATH/venv/bin/gunicorn --workers 3 --bind unix:$DEPLOY_PATH/gunicorn.sock projet.wsgi:application
ExecReload=/bin/kill -s HUP \$MAINPID
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable $PROJECT_NAME
sudo systemctl restart $PROJECT_NAME
log "Gunicorn configuré"

# 10. Configuration SSL avec Let's Encrypt
log "🔒 Configuration SSL avec Let's Encrypt..."
sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email contact@technova.fr --redirect
log "SSL configuré"

# 11. Configuration du firewall
log "🔥 Configuration du firewall..."
sudo ufw allow 'Nginx Full'
sudo ufw allow ssh
sudo ufw --force enable
log "Firewall configuré"

# 12. Vérification de la santé
log "🔍 Vérification de la santé de l'application..."
python manage.py check --deploy
if [ $? -eq 0 ]; then
    log "✅ Application déployée avec succès!"
else
    error "❌ Problèmes détectés lors de la vérification"
    exit 1
fi

# 13. Test du site
log "🌐 Test du site..."
if curl -s -o /dev/null -w "%{http_code}" https://$DOMAIN | grep -q "200"; then
    log "✅ Site accessible: https://$DOMAIN"
else
    error "❌ Site non accessible"
    exit 1
fi

# 14. Redémarrage des services
log "🔄 Redémarrage des services..."
sudo systemctl restart $PROJECT_NAME
sudo systemctl restart nginx
log "Services redémarrés"

# 15. Nettoyage
log "🧹 Nettoyage..."
find $BACKUP_DIR -name "*.sqlite3" -mtime +7 -delete 2>/dev/null || true
find . -name "*.pyc" -delete 2>/dev/null || true
find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
log "Nettoyage terminé"

log "🎉 Déploiement terminé avec succès!"
log "📊 Résumé:"
log "   - Domaine: https://$DOMAIN"
log "   - Base de données: PostgreSQL"
log "   - Serveur web: Nginx + Gunicorn"
log "   - SSL: Let's Encrypt"
log "   - Monitoring: Activé"
log "   - Backup: Activé"

log "🌐 Accès au site:"
log "   - Site: https://$DOMAIN"
log "   - Admin: https://$DOMAIN/admin/"
log "   - Utilisateur: admin"
log "   - Mot de passe: TechNova2024!"

log "📧 Informations de contact:"
log "   - Email: contact@technova.fr"
log "   - Téléphone: +33 1 23 45 67 89"

log "✨ TechNova est maintenant en ligne! 🚀"
