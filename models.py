from django.db import models
from django.contrib.auth.models import User
from django.db.models.signals import post_save
from django.dispatch import receiver

class Contact(models.Model):
    """Modèle pour gérer les messages de contact"""
    nom = models.CharField(max_length=100, verbose_name="Nom")
    email = models.EmailField(verbose_name="Email")
    message = models.TextField(verbose_name="Message")
    date_envoi = models.DateTimeField(auto_now_add=True, verbose_name="Date d'envoi")
    traite = models.BooleanField(default=False, verbose_name="Traité")

    class Meta:
        verbose_name = "Message de contact"
        verbose_name_plural = "Messages de contact"
        ordering = ['-date_envoi']

    def __str__(self):
        return f"Message de {self.nom} - {self.date_envoi.strftime('%d/%m/%Y')}"

class ProfilUser(models.Model):
    """Profil utilisateur étendant le modèle User de Django"""
    user = models.OneToOneField(User, on_delete=models.CASCADE, verbose_name="Utilisateur")
    telephone = models.CharField(max_length=20, blank=True, verbose_name="Téléphone")
    entreprise = models.CharField(max_length=100, blank=True, verbose_name="Entreprise")
    bio = models.TextField(max_length=500, blank=True, verbose_name="Biographie")
    photo = models.ImageField(upload_to='photos_profil/', blank=True, null=True, verbose_name="Photo de profil")
    date_naissance = models.DateField(null=True, blank=True, verbose_name="Date de naissance")
    site_web = models.URLField(blank=True, verbose_name="Site web")
    linkedin = models.URLField(blank=True, verbose_name="LinkedIn")
    newsletter = models.BooleanField(default=True, verbose_name="Abonné newsletter")
    date_creation = models.DateTimeField(auto_now_add=True, verbose_name="Date de création")
    date_modification = models.DateTimeField(auto_now=True, verbose_name="Date de modification")

    class Meta:
        verbose_name = "Profil utilisateur"
        verbose_name_plural = "Profils utilisateurs"

    def __str__(self):
        return f"Profil de {self.user.username}"

    @property
    def nom_complet(self):
        return f"{self.user.first_name} {self.user.last_name}".strip() or self.user.username

@receiver(post_save, sender=User)
def creer_profil_user(sender, instance, created, **kwargs):
    """Créer automatiquement un profil lorsqu'un utilisateur est créé"""
    if created:
        ProfilUser.objects.create(user=instance)

@receiver(post_save, sender=User)
def sauvegarder_profil_user(sender, instance, **kwargs):
    """Sauvegarder le profil lorsque l'utilisateur est sauvegardé"""
    instance.profiluser.save()
