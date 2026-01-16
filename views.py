from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
from django.contrib.auth import login
from .models import Contact, ProfilUser
from .forms import ContactForm, InscriptionForm, ProfilForm

def accueil(request):
    """Vue pour la page d'accueil"""
    return render(request, 'accueil.html')

def services(request):
    """Vue pour la page des services"""
    return render(request, 'services.html')

def a_propos(request):
    """Vue pour la page à propos"""
    return render(request, 'a_propos.html')

def contact(request):
    """Vue pour la page de contact avec formulaire"""
    if request.method == 'POST':
        form = ContactForm(request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, 'Votre message a été envoyé avec succès!')
            return redirect('contact')
    else:
        form = ContactForm()
    
    return render(request, 'contact.html', {'form': form})

def inscription(request):
    """Vue pour l'inscription des utilisateurs"""
    if request.method == 'POST':
        form = InscriptionForm(request.POST)
        if form.is_valid():
            user = form.save()
            # Gérer l'abonnement newsletter
            newsletter = request.POST.get('newsletter', False)
            if newsletter:
                user.profiluser.newsletter = True
                user.profiluser.save()
            
            login(request, user)
            messages.success(request, 'Votre compte a été créé avec succès! Bienvenue!')
            return redirect('tableau_bord')
    else:
        form = InscriptionForm()
    
    return render(request, 'auth/inscription.html', {'form': form})

@login_required
def tableau_bord(request):
    """Vue pour le tableau de bord utilisateur"""
    profil = request.user.profiluser
    # Récupérer les informations de l'utilisateur
    context = {
        'profil': profil,
        'nombre_contacts': Contact.objects.count(),
        'derniers_contacts': Contact.objects.order_by('-date_envoi')[:5],
    }
    return render(request, 'tableau_bord.html', context)

@login_required
def profil(request):
    """Vue pour la gestion du profil utilisateur"""
    profil = request.user.profiluser
    
    if request.method == 'POST':
        form = ProfilForm(request.POST, request.FILES, instance=profil)
        if form.is_valid():
            form.save()
            messages.success(request, 'Votre profil a été mis à jour avec succès!')
            return redirect('profil')
    else:
        form = ProfilForm(instance=profil)
    
    return render(request, 'profil.html', {'form': form, 'profil': profil})

@login_required
def parametres(request):
    """Vue pour les paramètres du compte utilisateur"""
    if request.method == 'POST':
        # Mise à jour des informations utilisateur de base
        user = request.user
        user.first_name = request.POST.get('first_name', user.first_name)
        user.last_name = request.POST.get('last_name', user.last_name)
        user.email = request.POST.get('email', user.email)
        
        # Vérifier si le mot de passe doit être changé
        new_password = request.POST.get('new_password')
        if new_password:
            user.set_password(new_password)
            messages.success(request, 'Votre mot de passe a été changé avec succès!')
        
        user.save()
        messages.success(request, 'Vos informations ont été mises à jour!')
        return redirect('parametres')
    
    return render(request, 'parametres.html')
