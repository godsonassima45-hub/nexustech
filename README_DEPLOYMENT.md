# NexusTech - Guide de Déploiement Production

## 🚀 Déploiement sur Render avec Domaine Personnalisé

Ce guide explique comment déployer votre application Django NexusTech sur Render avec le domaine personnalisé `nexustech.io`.

---

## 📋 Prérequis

- Compte Render (gratuit ou payant)
- Nom de domaine `nexustech.io` (ou autre)
- Git installé localement
- Compte GitHub

---

## 🛠️ Configuration du Projet

### 1. Variables d'Environnement

Copiez le fichier `.env.example` en `.env` pour le développement local :

```bash
cp .env.example .env
```

Pour Render, configurez ces variables dans le dashboard Render :

```bash
SECRET_KEY=votre-cle-secrete-tres-longue-et-compliquee-ici
DEBUG=False
ALLOWED_HOSTS=localhost,127.0.0.1,.onrender.com,nexustech.io,www.nexustech.io
```

### 2. Installation des Dépendances

```bash
# Installation locale
pip install -r requirements.txt

# Installation avec virtualenv (recommandé)
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

---

## 🌐 Déploiement sur Render

### Étape 1: Préparation du Repository Git

```bash
# Initialiser Git (si pas déjà fait)
git init

# Ajouter tous les fichiers
git add .

# Premier commit
git commit -m "Initial commit - TechNova ready for production"

# Ajouter le remote GitHub
git remote add origin https://github.com/votre-username/technova.git
git branch -M main
git push -u origin main
```

### Étape 2: Configuration sur Render

1. **Connectez-vous à [Render](https://render.com)**
2. **Créez un nouveau Web Service**
3. **Connectez votre repository GitHub**
4. **Configurez les paramètres :**

```
Name: technova
Environment: Python 3
Region: Europe (Frankfurt)
Branch: main
Root Directory: (laisser vide)
Build Command: pip install -r requirements.txt
Start Command: gunicorn projet.wsgi:application --bind 0.0.0.0:$PORT --workers 3
```

### Étape 3: Variables d'Environnement Render

Dans le dashboard Render → Settings → Environment Variables :

```bash
SECRET_KEY=votre-cle-secrete-tres-longue-et-compliquee-ici
DEBUG=False
ALLOWED_HOSTS=localhost,127.0.0.1,.onrender.com,technova.com,www.technova.com
```

### Étape 4: Base de Données

1. **Ajoutez un PostgreSQL Database** sur Render
2. **Notez la DATABASE_URL** fournie par Render
3. **Ajoutez DATABASE_URL** dans les variables d'environnement

---

## 🌍 Configuration du Domaine Personnalisé

### Étape 1: Ajouter le Domaine sur Render

1. **Allez dans votre Web Service → Settings → Custom Domains**
2. **Ajoutez `technova.com`**
3. **Ajoutez `www.technova.com`**

### Étape 2: Configuration DNS

Chez votre registrar de domaine (GoDaddy, Namecheap, etc.) :

```
Type: CNAME
Name: www
Value: your-app-name.onrender.com
TTL: 1 hour

Type: A
Name: @
Value: 34.117.59.81 (adresse IP Render)
TTL: 1 hour
```

### Étape 3: SSL/TLS

Render configure automatiquement SSL avec Let's Encrypt. Attendez quelques minutes après la configuration DNS.

---

## 🧪 Tests de Déploiement

### Test Local avec Gunicorn

```bash
# Activer l'environnement virtuel
source venv/bin/activate

# Tester avec Gunicorn
gunicorn projet.wsgi:application --bind 0.0.0.0:8000

# Test avec variables de production
export DEBUG=False
export SECRET_KEY="votre-cle-test"
gunicorn projet.wsgi:application --bind 0.0.0.0:8000
```

### Commandes Django

```bash
# Vérifier la configuration
python manage.py check --deploy

# Collecter les fichiers statiques
python manage.py collectstatic --noinput

# Migrations de base de données
python manage.py migrate

# Créer un superutilisateur
python manage.py createsuperuser
```

---

## 📊 Monitoring et Logs

### Logs Render

- **Build Logs**: Voir les logs de construction
- **Service Logs**: Voir les logs d'exécution
- **Access Logs**: Voir les logs d'accès

### Monitoring

```bash
# Vérifier le statut du service
curl https://votre-app.onrender.com/health/

# Vérifier les fichiers statiques
curl -I https://votre-app.onrender.com/static/css/style.css
```

---

## 🔧 Maintenance

### Mises à Jour

```bash
# Faire les modifications localement
git add .
git commit -m "Description des changements"
git push origin main

# Render déploie automatiquement
```

### Backup

Render fait des backups automatiques de la base de données PostgreSQL. Pour les fichiers médias :

```bash
# Configuration pour S3 (optionnel)
# Ajouter dans .env :
# USE_S3=True
# AWS_ACCESS_KEY_ID=votre-key
# AWS_SECRET_ACCESS_KEY=votre-secret
# AWS_STORAGE_BUCKET_NAME=technova-media
```

---

## 🚨 Dépannage

### Problèmes Communs

#### 1. Erreur 502 Bad Gateway
```bash
# Vérifier que Gunicorn fonctionne
gunicorn projet.wsgi:application --bind 0.0.0.0:$PORT

# Vérifier les variables d'environnement
echo $SECRET_KEY
echo $DEBUG
```

#### 2. Fichiers Statiques Non Chargés
```bash
# Forcer la collecte des statiques
python manage.py collectstatic --clear --noinput

# Vérifier STATIC_ROOT dans settings.py
# STATIC_ROOT = BASE_DIR / 'staticfiles'
```

#### 3. Erreur de Base de Données
```bash
# Vérifier DATABASE_URL
echo $DATABASE_URL

# Tester localement avec la base de données de production
# (temporairement pour débug)
```

#### 4. Domaine Non Accessible
```bash
# Vérifier la configuration DNS
dig technova.com
dig www.technova.com

# Vérifier les logs Render pour les erreurs SSL
```

---

## 📞 Support

### Documentation Utile

- [Render Documentation](https://render.com/docs)
- [Django Deployment Checklist](https://docs.djangoproject.com/en/5.2/howto/deployment/checklist/)
- [Gunicorn Documentation](https://docs.gunicorn.org/)

### Contact Support

- **Render**: support@render.com
- **TechNova**: contact@technova.com

---

## ✅ Checklist de Déploiement

- [ ] Repository Git créé et poussé
- [ ] Variables d'environnement configurées
- [ ] Base de données PostgreSQL ajoutée
- [ ] Service Web créé sur Render
- [ ] Déploiement réussi
- [ ] Domaine personnalisé configuré
- [ ] DNS configuré
- [ ] SSL/TLS activé
- [ ] Tests de fonctionnalité passés
- [ ] Monitoring configuré

---

## 🎉 Résultat Final

Une fois déployé, votre site sera accessible :
- **URL Render**: `https://votre-app.onrender.com`
- **Domaine personnalisé**: `https://technova.com`
- **Admin Django**: `https://technova.com/admin`

**TechNova est maintenant en ligne ! 🚀**
