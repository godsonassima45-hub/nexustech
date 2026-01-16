"""
WSGI config for projet project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.2/howto/deployment/wsgi/
"""

import os
import sys
from django.core.wsgi import get_wsgi_application

# Ajouter le projet au chemin Python
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Détecter l'environnement
if os.environ.get('DJANGO_SETTINGS_MODULE') is None:
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'projet.settings')

# Optimisations pour la production
if 'DJANGO_SETTINGS_MODULE' in os.environ and 'prod' in os.environ['DJANGO_SETTINGS_MODULE']:
    # Activer le mode de production
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'projet.settings_prod')
    
    # Configuration pour Gunicorn
    from django.conf import settings
    
    # Activer le cache si disponible
    if hasattr(settings, 'CACHES') and 'default' in settings.CACHES:
        from django.core.cache import cache
        # Préchauffer le cache
        cache.set('wsgi_startup', True, timeout=60)

# Créer l'application WSGI
application = get_wsgi_application()

# Optimisations supplémentaires pour la production
if 'DJANGO_SETTINGS_MODULE' in os.environ and 'prod' in os.environ['DJANGO_SETTINGS_MODULE']:
    # Importer les modèles pour précharger
    try:
        from app.models import Contact, ProfilUser
        # Précharger les modèles pour éviter les latences au premier démarrage
        Contact._meta.get_field('nom')
        ProfilUser._meta.get_field('user')
    except ImportError:
        pass  # Les modèles ne sont pas encore disponibles
