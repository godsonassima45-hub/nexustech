#!/bin/bash
set -e

# Attendre que la base de données soit prête
echo "Attente de la base de données..."
while ! nc -z $DB_HOST $DB_PORT; do
  sleep 0.1
done
echo "Base de données prête!"

# Attendre que Redis soit prêt (si utilisé)
if [ ! -z "$REDIS_URL" ]; then
    echo "Attente de Redis..."
    while ! nc -z redis 6379; do
      sleep 0.1
    done
    echo "Redis prêt!"
fi

# Exécuter les migrations
echo "Exécution des migrations..."
python manage.py migrate --noinput

# Collecter les fichiers statiques
echo "Collecte des fichiers statiques..."
python manage.py collectstatic --noinput

# Créer le superutilisateur si nécessaire
python manage.py shell << EOF
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@proservices.com', 'admin123')
    print('Superutilisateur créé')
else:
    print('Superutilisateur existe déjà')
EOF

# Démarrer l'application
echo "Démarrage de l'application..."
exec "$@"
