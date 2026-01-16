web: gunicorn projet.wsgi:application --bind 0.0.0.0:$PORT --workers 3 --worker-class gevent --max-requests 1000 --max-requests-jitter 100 --timeout 120 --keep-alive 5
