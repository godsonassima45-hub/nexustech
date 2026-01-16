# Configuration Gunicorn pour ProServices
# Optimisé pour la production

import multiprocessing
import os

# Liaison
bind = "0.0.0.0:8000"

# Workers (basé sur le nombre de CPU cores)
workers = multiprocessing.cpu_count() * 2 + 1
worker_class = "sync"
worker_connections = 1000

# Timeout
timeout = 30
keepalive = 2

# Max requests
max_requests = 1000
max_requests_jitter = 100

# Logging
accesslog = "-"
errorlog = "-"
loglevel = "info"
access_log_format = '%(h)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s" %(D)s'

# Process naming
proc_name = "proservices"

# Server mechanics
daemon = False
pidfile = "/tmp/gunicorn.pid"
user = None
group = None
tmp_upload_dir = None

# SSL (si nécessaire)
keyfile = None
certfile = None

# Worker process settings
preload_app = True
max_requests = 1000
max_requests_jitter = 50

# Security
limit_request_line = 4094
limit_request_fields = 100
limit_request_field_size = 8190

# Graceful timeout
graceful_timeout = 30

# Environment variables
raw_env = [
    'DJANGO_SETTINGS_MODULE=projet.settings_prod',
]

# Hooks
def on_starting(server):
    """Exécuté au démarrage du master process"""
    server.log.info("Starting ProServices with Gunicorn")

def on_reload(server):
    """Exécuté lors du rechargement"""
    server.log.info("Reloading ProServices")

def worker_int(worker):
    """Exécuté quand un worker reçoit SIGINT"""
    worker.log.info("Worker received INT or QUIT signal")

def pre_fork(server, worker):
    """Exécuté juste avant le fork du worker"""
    server.log.info(f"Worker spawned (pid: {worker.pid})")

def post_fork(server, worker):
    """Exécuté juste après le fork du worker"""
    server.log.info(f"Worker spawned (pid: {worker.pid})")

def post_worker_init(worker):
    """Exécuté après l'initialisation du worker"""
    pass

def worker_exit(server, worker):
    """Exécuté quand un worker sort"""
    server.log.info(f"Worker exiting (pid: {worker.pid})")

def child_exit(server, worker):
    """Exécuté quand un child process sort"""
    server.log.info(f"Child worker exited (pid: {worker.pid})")

def on_exit(server):
    """Exécuté à la sortie du master process"""
    server.log.info("Gunicorn master process exiting")

# Configuration spécifique pour l'environnement
if os.environ.get('ENVIRONMENT') == 'development':
    # Configuration pour le développement
    workers = 1
    loglevel = "debug"
    access_log_format = '%(h)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s"'
    reload = True
