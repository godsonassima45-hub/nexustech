from django.contrib import admin
from django.utils.html import format_html
from .models import Contact

@admin.register(Contact)
class ContactAdmin(admin.ModelAdmin):
    """Configuration de l'administration pour les messages de contact"""
    
    # Colonnes affichées dans la liste
    list_display = ['nom', 'email', 'message_preview', 'date_envoi', 'traite', 'statut_badge']
    
    # Filtres dans la barre latérale
    list_filter = ['traite', 'date_envoi']
    
    # Champs de recherche
    search_fields = ['nom', 'email', 'message']
    
    # Ordre par défaut
    ordering = ['-date_envoi']
    
    # Pagination
    list_per_page = 25
    
    # Actions personnalisées
    actions = ['marquer_comme_traite', 'marquer_comme_non_traite']
    
    # Configuration des champs en lecture seule
    readonly_fields = ['date_envoi']
    
    # Organisation des champs dans le formulaire
    fieldsets = (
        ('Informations du contact', {
            'fields': ('nom', 'email', 'date_envoi')
        }),
        ('Message', {
            'fields': ('message',)
        }),
        ('Statut', {
            'fields': ('traite',)
        }),
    )
    
    def message_preview(self, obj):
        """Affiche un aperçu du message dans la liste"""
        preview = obj.message[:50] + '...' if len(obj.message) > 50 else obj.message
        return format_html('<span title="{}">{}</span>', obj.message, preview)
    message_preview.short_description = 'Message'
    
    def statut_badge(self, obj):
        """Affiche un badge de couleur selon le statut"""
        if obj.traite:
            return format_html(
                '<span class="badge bg-success">Traité</span>'
            )
        else:
            return format_html(
                '<span class="badge bg-warning">En attente</span>'
            )
    statut_badge.short_description = 'Statut'
    
    def marquer_comme_traite(self, request, queryset):
        """Action pour marquer les messages comme traités"""
        updated = queryset.update(traite=True)
        self.message_user(
            request, 
            f'{updated} message(s) marqué(s) comme traité(s).'
        )
    marquer_comme_traite.short_description = 'Marquer comme traité'
    
    def marquer_comme_non_traite(self, request, queryset):
        """Action pour marquer les messages comme non traités"""
        updated = queryset.update(traite=False)
        self.message_user(
            request, 
            f'{updated} message(s) marqué(s) comme non traité(s).'
        )
    marquer_comme_non_traite.short_description = 'Marquer comme non traité'
    
    # Personnalisation du titre
    def get_queryset(self, request):
        """Optimise les requêtes en préchargeant les données"""
        qs = super().get_queryset(request)
        return qs
    
    # Configuration du site admin
    site_header = 'Administration ProServices'
    site_title = 'ProServices Admin'
    index_title = 'Tableau de bord'
