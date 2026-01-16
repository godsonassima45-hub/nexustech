# Site Web Professionnel - ProServices

Un site web professionnel complet développé avec Django, featuring un design moderne et responsive avec système d'authentification utilisateur complet.

## 🚀 Fonctionnalités

### Frontend
- **Design moderne et professionnel** avec Bootstrap 5
- **Fully responsive** - fonctionne sur mobile, tablette et desktop
- **Animations fluides** et interactions utilisateur
- **Bouton WhatsApp** cliquable pour contact rapide
- **Navigation intuitive** avec menu mobile
- **Interface utilisateur** moderne et accessible

### Backend (Django)
- **Framework Django 5.2.8** avec Python
- **Base de données SQLite** pour le développement, **PostgreSQL** pour la production
- **Système d'authentification** utilisateur complet
- **Tableau de bord** personnel pour les utilisateurs
- **Gestion des profils** utilisateurs avancée
- **Système d'administration** Django complet
- **Formulaire de contact** sécurisé avec validation
- **Gestion des messages** dans l'admin Django

### Système d'Authentification
- **Inscription** utilisateur avec validation
- **Connexion/Déconnexion** sécurisée
- **Tableau de bord** personnel
- **Gestion du profil** utilisateur (photo, bio, réseaux sociaux)
- **Paramètres** du compte et confidentialité
- **Protection** des pages sensibles
- **Réinitialisation** du mot de passe

### Pages du site
1. **Accueil** - Hero section avec présentation des services
2. **Services** - Détail complet des offres de services
3. **À propos** - Histoire, mission, équipe et réalisations
4. **Contact** - Formulaire de contact et informations
5. **Tableau de bord** - Espace personnel utilisateur
6. **Profil** - Gestion du profil utilisateur
7. **Paramètres** - Configuration du compte
8. **Connexion/Inscription** - Authentification utilisateur

## 📁 Structure du projet

```
site_web_professionnel/
├── manage.py                    # Script de gestion Django
├── projet/                      # Configuration du projet
│   ├── __init__.py
│   ├── settings.py              # Paramètres Django
│   ├── urls.py                  # URLs principales
│   ├── wsgi.py
│   └── asgi.py
├── app/                         # Application principale
│   ├── __init__.py
│   ├── admin.py                 # Configuration admin
│   ├── apps.py
│   ├── forms.py                 # Formulaires Django
│   ├── models.py                # Modèles de données
│   ├── urls.py                  # URLs de l'app
│   ├── views.py                 # Vues Django
│   └── migrations/              # Migrations de la BDD
├── templates/                   # Templates HTML
│   ├── base.html               # Template de base
│   ├── accueil.html            # Page d'accueil
│   ├── services.html           # Page services
│   ├── a_propos.html           # Page à propos
│   └── contact.html            # Page contact
├── static/                      # Fichiers statiques
│   ├── css/
│   │   └── style.css           # Styles personnalisés
│   └── js/
│       └── script.js           # JavaScript personnalisé
├── staticfiles/                 # Fichiers statiques collectés
├── db.sqlite3                   # Base de données SQLite
└── requirements.txt             # Dépendances Python
```

## 🛠 Installation et Démarrage

### Prérequis
- Python 3.8+
- pip (gestionnaire de paquets Python)

### Étapes d'installation

1. **Cloner ou naviguer vers le dossier du projet**
   ```bash
   cd site_web_professionnel
   ```

2. **Créer un environnement virtuel (recommandé)**
   ```bash
   python -m venv venv
   
   # Windows
   venv\Scripts\activate
   
   # Mac/Linux
   source venv/bin/activate
   ```

3. **Installer les dépendances**
   ```bash
   pip install django
   ```

4. **Appliquer les migrations de la base de données**
   ```bash
   python manage.py makemigrations
   python manage.py migrate
   ```

5. **Collecter les fichiers statiques**
   ```bash
   python manage.py collectstatic
   ```

6. **Démarrer le serveur de développement**
   ```bash
   python manage.py runserver
   ```

7. **Accéder au site**
   - Site web : http://127.0.0.1:8000/
   - Administration : http://127.0.0.1:8000/admin/

## 🔐 Accès Administration

- **URL** : http://127.0.0.1:8000/admin/
- **Nom d'utilisateur** : `admin`
- **Mot de passe** : `admin123`

### Fonctionnalités de l'admin
- **Gestion des messages de contact**
- **Filtres par statut (traité/non traité)**
- **Recherche par nom, email ou message**
- **Actions groupées pour marquer les messages**
- **Interface intuitive avec badges de statut**

## 📱 Fonctionnalités Techniques

### Frontend Features
- **Responsive Design** : Adaptation automatique à tous les écrans
- **Animations CSS** : Transitions fluides et effets visuels
- **JavaScript Interactif** : Validation de formulaires, animations au scroll
- **Performance Optimisée** : Lazy loading, code optimisé
- **Accessibilité** : Support lecteurs d'écran, navigation clavier

### Backend Features
- **Modèle Contact** : Gestion complète des messages
- **Formulaires Sécurisés** : Protection CSRF, validation
- **Admin Personnalisé** : Interface d'administration sur mesure
- **Migrations Django** : Gestion automatique de la BDD
- **Messages Framework** : Notifications utilisateur

### Sécurité
- **Protection CSRF** intégrée
- **Validation des entrées** côté serveur et client
- **Échappement automatique** du contenu HTML
- **Mots de passe sécurisés** pour l'admin

## 🎨 Design et UX

### Thème visuel
- **Palette professionnelle** : Bleu principal avec accents
- **Typographie moderne** : Segoe UI et polices système
- **Icons Font Awesome** : Icônes cohérentes
- **Bootstrap 5** : Framework CSS moderne

### Expérience utilisateur
- **Navigation fluide** avec menu sticky
- **Animations subtiles** pour améliorer l'engagement
- **Formulaire intuitif** avec validation en temps réel
- **Bouton WhatsApp** pour contact instantané
- **Scroll-to-top** pour meilleure navigation

## 🚀 Déploiement

### Pour la production

1. **Variables d'environnement**
   ```bash
   export DEBUG=False
   export ALLOWED_HOSTS=votredomaine.com
   export SECRET_KEY=votre-cle-secrete
   ```

2. **Base de données production**
   - Configurer PostgreSQL/MySQL selon les besoins
   - Mettre à jour `settings.py`

3. **Serveur web**
   - Utiliser Gunicorn + Nginx
   - Configurer HTTPS avec SSL

4. **Static files**
   - Utiliser AWS S3 ou CDN pour les fichiers statiques

## 📞 Support et Contact

### Informations de contact (dans le site)
- **Email** : contact@proservices.com
- **Téléphone** : +33 1 23 45 67 89
- **WhatsApp** : +33 6 12 34 56 78
- **Adresse** : 123 Avenue des Champs-Élysées, 75008 Paris

### Support technique
- **Documentation** : Ce fichier README
- **Issues** : Signaler les problèmes via GitHub
- **Email support** : support@proservices.com

## 🔄 Mises à jour futures

### Fonctionnalités prévues
- [ ] Blog système
- [ ] Portfolio projets
- [ ] Témoignages clients
- [ ] Multi-langues
- [ ] Système de réservation
- [ ] Intégration paiement

### Améliorations techniques
- [ ] Tests unitaires
- [ ] CI/CD pipeline
- [ ] Monitoring performance
- [ ] SEO avancé
- [ ] API REST

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

## 🤝 Contribution

Les contributions sont bienvenues ! Merci de suivre les étapes suivantes :

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📊 Statistiques du projet

- **Lignes de code** : ~2000 lignes
- **Templates** : 5 fichiers HTML
- **Styles CSS** : ~800 lignes
- **JavaScript** : ~600 lignes
- **Modèles Django** : 1 modèle (Contact)
- **Vues** : 4 vues principales
- **Tests** : À implémenter

---

**Développé avec ❤️ par ProServices**  
*Votre partenaire digital de confiance*
