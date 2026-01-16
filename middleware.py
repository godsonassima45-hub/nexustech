"""
Middleware de sécurité pour NexusTech
Force HTTPS et ajoute des headers de sécurité
"""

class SecurityMiddleware:
    """
    Middleware personnalisé pour la sécurité HTTPS
    """
    
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)
        
        # Ajouter des headers de sécurité supplémentaires
        self.add_security_headers(response)
        
        return response
    
    def add_security_headers(self, response):
        """
        Ajoute des headers de sécurité à toutes les réponses
        """
        # Politique de sécurité de contenu
        csp = (
            "default-src 'self'; "
            "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://www.google.com https://www.gstatic.com https://fonts.googleapis.com https://fonts.gstatic.com; "
            "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://fonts.gstatic.com; "
            "font-src 'self' https://fonts.gstatic.com https://fonts.googleapis.com; "
            "img-src 'self' data: https:; "
            "connect-src 'self' https://www.google-analytics.com; "
            "frame-ancestors 'none'; "
            "object-src 'none'; "
            "base-uri 'self'; "
            "form-action 'self'; "
            "upgrade-insecure-requests"
        )
        
        # Headers de sécurité
        response['Content-Security-Policy'] = csp
        response['X-Content-Type-Options'] = 'nosniff'
        response['X-Frame-Options'] = 'DENY'
        response['X-XSS-Protection'] = '1; mode=block'
        response['Referrer-Policy'] = 'strict-origin-when-cross-origin'
        response['Permissions-Policy'] = (
            'geolocation=(), '
            'microphone=(), '
            'camera=(), '
            'payment=(), '
            'usb=(), '
            'magnetometer=(), '
            'gyroscope=(), '
            'accelerometer=()'
        )
        
        # Headers de performance et cache
        if not response.get('Cache-Control'):
            response['Cache-Control'] = 'no-cache, no-store, must-revalidate'
            response['Pragma'] = 'no-cache'
            response['Expires'] = '0'
        
        # Headers de sécurité pour les API
        if request.path.startswith('/api/'):
            response['Access-Control-Allow-Origin'] = 'https://nexustech.io'
            response['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
            response['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'
            response['Access-Control-Allow-Credentials'] = 'true'
            response['Access-Control-Max-Age'] = '86400'
        
        return response


class HTTPSRedirectMiddleware:
    """
    Middleware pour forcer la redirection HTTPS
    """
    
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # Forcer HTTPS en production
        if not request.is_secure() and not self.is_development(request):
            # Construire l'URL HTTPS
            https_url = request.build_absolute_uri(
                request.get_full_path(),
                scheme='https'
            )
            
            # Redirection permanente vers HTTPS
            from django.http import HttpResponsePermanentRedirect
            return HttpResponsePermanentRedirect(https_url)
        
        return self.get_response(request)
    
    def is_development(self, request):
        """
        Vérifie si nous sommes en développement
        """
        return (
            'localhost' in request.get_host() or
            '127.0.0.1' in request.get_host() or
            'test' in request.get_host() or
            request.META.get('DJANGO_SETTINGS_MODULE', '').endswith('.local')
        )


class HSTSMiddleware:
    """
    Middleware pour HSTS (HTTP Strict Transport Security)
    """
    
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)
        
        # Ajouter HSTS seulement pour les requêtes HTTPS
        if request.is_secure():
            max_age = 31536000  # 1 an
            include_subdomains = True
            preload = True
            
            hsts_header = (
                f"max-age={max_age}; "
                f"includeSubDomains={'true' if include_subdomains else 'false'}; "
                f"preload={'true' if preload else 'false'}"
            )
            
            response['Strict-Transport-Security'] = hsts_header
        
        return response


class SecurityHeadersMiddleware:
    """
    Middleware combiné pour tous les headers de sécurité
    """
    
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)
        
        # Ne pas ajouter les headers de sécurité aux réponses d'erreur
        if response.status_code >= 400:
            return response
        
        # Headers de base
        response['X-Content-Type-Options'] = 'nosniff'
        response['X-Frame-Options'] = 'DENY'
        response['X-XSS-Protection'] = '1; mode=block'
        response['Referrer-Policy'] = 'strict-origin-when-cross-origin'
        
        # CSP pour les pages HTML
        if response.get('Content-Type', '').startswith('text/html'):
            csp = (
                "default-src 'self'; "
                "script-src 'self' 'unsafe-inline' https://www.google.com https://www.gstatic.com https://fonts.googleapis.com; "
                "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://fonts.gstatic.com; "
                "font-src 'self' https://fonts.gstatic.com; "
                "img-src 'self' data: https:; "
                "connect-src 'self'; "
                "frame-ancestors 'none'; "
                "object-src 'none'; "
                "base-uri 'self'; "
                "form-action 'self'; "
                "upgrade-insecure-requests"
            )
            response['Content-Security-Policy'] = csp
        
        # Permissions Policy
        permissions = (
            'geolocation=(), '
            'microphone=(), '
            'camera=(), '
            'payment=(), '
            'usb=(), '
            'interest-cohort=(), '
            'browsing-topics=()'
        )
        response['Permissions-Policy'] = permissions
        
        return response
