# 🚀 Commandes Git pour Déploiement TechNova

## 📋 Préparation du Repository

### 1. Initialisation Git (si nécessaire)
```bash
# Vérifier si Git est déjà initialisé
git status

# Si non initialisé
git init
```

### 2. Configuration Git (première fois)
```bash
git config --global user.name "Votre Nom"
git config --global user.email "votre-email@example.com"
```

### 3. Création du .gitignore
```bash
# Créer le fichier .gitignore
cat > .gitignore << EOF
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Django
*.log
local_settings.py
db.sqlite3
db.sqlite3-journal

# Environment variables
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Static files
staticfiles/
media/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Logs
logs/
*.log

# Backups
backups/
*.backup
*.bak

# Render
.render.yaml
EOF
```

## 🔄 Commandes de Déploiement

### 4. Premier Commit
```bash
# Ajouter tous les fichiers
git add .

# Premier commit
git commit -m "feat: Initial TechNova Django project ready for production

- Django 5.2.8 with production settings
- Gunicorn and WhiteNoise configured
- Environment variables with python-decouple
- PostgreSQL support for Render
- Static files optimization
- Security headers and SSL configuration
- Custom domain support (technova.com)
- Complete deployment documentation
- Automated deployment script"
```

### 5. Connexion à GitHub
```bash
# Ajouter le remote GitHub
git remote add origin https://github.com/votre-username/technova.git

# Pousser vers GitHub
git branch -M main
git push -u origin main
```

### 6. Déploiement Continu
```bash
# Pour chaque mise à jour
git add .
git commit -m "feat: Description des changements"
git push origin main
```

## 🌐 Workflow de Déploiement Render

### 7. Commandes de Déploiement Automatisé
```bash
# Déploiement local (test)
./deploy.sh local

# Déploiement vers Render
./deploy.sh render
```

### 8. Vérifications Pré-Déploiement
```bash
# Vérifier la configuration Django
python manage.py check --deploy

# Collecter les fichiers statiques
python manage.py collectstatic --noinput

# Tester Gunicorn localement
gunicorn projet.wsgi:application --bind 0.0.0.0:8000 --workers 3
```

## 🔧 Commandes de Maintenance

### 9. Mises à Jour de Dépendances
```bash
# Mettre à jour requirements.txt
pip freeze > requirements.txt

# Commit des mises à jour
git add requirements.txt
git commit -m "chore: Update dependencies"
git push origin main
```

### 10. Backup et Restauration
```bash
# Backup local
python manage.py dumpdata > backup_$(date +%Y%m%d).json

# Backup sur Render (via dashboard)
# Render → Database → Backups
```

## 🚨 Commandes de Dépannage

### 11. Problèmes Communs
```bash
# Problème de fichiers statiques
python manage.py collectstatic --clear --noinput

# Problème de migrations
python manage.py migrate --fake-initial

# Problème de permissions
chmod +x deploy.sh

# Reset complet (dernier recours)
git reset --hard HEAD
python manage.py migrate
python manage.py collectstatic --noinput
```

### 12. Vérification de Santé
```bash
# Vérifier le statut Git
git status

# Vérifier les logs de déploiement
git log --oneline -10

# Vérifier les branches
git branch -a
```

## 📊 Monitoring et Logs

### 13. Commandes de Monitoring
```bash
# Vérifier les processus Gunicorn
ps aux | grep gunicorn

# Vérifier les logs Django
tail -f logs/django.log

# Vérifier les logs de déploiement
tail -f logs/deploy.log
```

## 🎯 Checklist de Déploiement

### 14. Avant chaque Push
```bash
# ✅ Vérifier que tout fonctionne localement
python manage.py runserver

# ✅ Vérifier la configuration de production
python manage.py check --deploy

# ✅ Collecter les statiques
python manage.py collectstatic --noinput

# ✅ Tester avec Gunicorn
gunicorn projet.wsgi:application --bind 0.0.0.0:8000

# ✅ Ajouter et committer
git add .
git commit -m "feat: Ready for production deployment"
git push origin main
```

## 🌍 Configuration Domaine

### 15. Après Déploiement Render
```bash
# 1. Ajouter le domaine personnalisé sur Render
# 2. Configurer les DNS chez votre registrar
# 3. Attendre la propagation DNS (5-30 minutes)
# 4. Vérifier le SSL automatique

# Test du domaine personnalisé
curl -I https://technova.com
curl -I https://www.technova.com
```

---

## 📞 Support et Documentation

- **Render Docs**: https://render.com/docs
- **Django Deployment**: https://docs.djangoproject.com/en/5.2/howto/deployment/
- **Gunicorn Docs**: https://docs.gunicorn.org/

**TechNova est prêt pour le déploiement ! 🚀**
