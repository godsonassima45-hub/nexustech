# Utiliser une image Python officielle
FROM python:3.11-slim

# Définir les variables d'environnement
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# Définir le répertoire de travail
WORKDIR /app

# Installer les dépendances système
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
        build-essential \
        libpq-dev \
        gettext \
        curl \
        netcat \
        && rm -rf /var/lib/apt/lists/*

# Copier les fichiers de dépendances
COPY requirements.txt .

# Installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Copier le projet
COPY . .

# Créer les répertoires nécessaires
RUN mkdir -p /app/staticfiles /app/media /app/logs

# Donner les permissions appropriées
RUN chmod +x deploy.sh

# Exposer le port
EXPOSE 8000

# Script de démarrage
COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# Commande par défaut
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "projet.wsgi:application"]
