// ===== GESTION DU THÈME SOMBRE/CLAIR =====

class ThemeManager {
    constructor() {
        this.themeToggle = document.getElementById('themeToggle');
        this.htmlElement = document.documentElement;
        this.currentTheme = localStorage.getItem('theme') || 'light';
        
        this.init();
    }

    init() {
        // Appliquer le thème sauvegardé
        this.applyTheme(this.currentTheme);
        
        // Mettre à jour le toggle
        this.updateToggle();
        
        // Ajouter les écouteurs d'événements
        this.addEventListeners();
        
        // Détecter la préférence système
        this.detectSystemPreference();
    }

    addEventListeners() {
        if (this.themeToggle) {
            this.themeToggle.addEventListener('change', (e) => {
                const newTheme = e.target.checked ? 'dark' : 'light';
                this.setTheme(newTheme);
            });
        }

        // Écouter les changements de préférence système
        if (window.matchMedia) {
            window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
                if (!localStorage.getItem('theme')) {
                    // Seulement si l'utilisateur n'a pas manuellement choisi un thème
                    this.setTheme(e.matches ? 'dark' : 'light');
                }
            });
        }

        // Raccourci clavier (Ctrl/Cmd + Shift + D)
        document.addEventListener('keydown', (e) => {
            if ((e.ctrlKey || e.metaKey) && e.shiftKey && e.key === 'D') {
                e.preventDefault();
                this.toggleTheme();
            }
        });
    }

    detectSystemPreference() {
        if (!localStorage.getItem('theme')) {
            // Utiliser la préférence système si aucun thème n'est sauvegardé
            const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
            this.setTheme(prefersDark ? 'dark' : 'light');
        }
    }

    setTheme(theme) {
        this.currentTheme = theme;
        this.applyTheme(theme);
        this.updateToggle();
        this.saveTheme(theme);
        this.notifyThemeChange(theme);
    }

    applyTheme(theme) {
        // Appliquer l'attribut data-theme
        this.htmlElement.setAttribute('data-theme', theme);
        
        // Ajouter/retirer la classe sur le body
        document.body.classList.toggle('dark-theme', theme === 'dark');
        document.body.classList.toggle('light-theme', theme === 'light');
        
        // Mettre à jour les meta tags pour les navigateurs mobiles
        this.updateMetaThemeColor(theme);
        
        // Mettre à jour le favicon si nécessaire
        this.updateFavicon(theme);
    }

    updateToggle() {
        if (this.themeToggle) {
            this.themeToggle.checked = this.currentTheme === 'dark';
        }
    }

    saveTheme(theme) {
        localStorage.setItem('theme', theme);
    }

    updateMetaThemeColor(theme) {
        const themeColor = theme === 'dark' ? '#1a1a1a' : '#0d6efd';
        
        // Mettre à jour ou créer le meta tag theme-color
        let themeColorMeta = document.querySelector('meta[name="theme-color"]');
        if (!themeColorMeta) {
            themeColorMeta = document.createElement('meta');
            themeColorMeta.name = 'theme-color';
            document.head.appendChild(themeColorMeta);
        }
        themeColorMeta.content = themeColor;
        
        // Mettre à jour aussi pour Windows Phone
        let msThemeColor = document.querySelector('meta[name="msapplication-TileColor"]');
        if (!msThemeColor) {
            msThemeColor = document.createElement('meta');
            msThemeColor.name = 'msapplication-TileColor';
            document.head.appendChild(msThemeColor);
        }
        msThemeColor.content = themeColor;
    }

    updateFavicon(theme) {
        // Optionnel : changer le favicon selon le thème
        const favicon = document.querySelector('link[rel="icon"]') || document.querySelector('link[rel="shortcut icon"]');
        if (favicon) {
            // Vous pouvez avoir différents favicons pour chaque thème
            // favicon.href = theme === 'dark' ? '/favicon-dark.ico' : '/favicon.ico';
        }
    }

    toggleTheme() {
        const newTheme = this.currentTheme === 'dark' ? 'light' : 'dark';
        this.setTheme(newTheme);
    }

    notifyThemeChange(theme) {
        // Émettre un événement personnalisé
        const event = new CustomEvent('themeChanged', {
            detail: { theme: theme }
        });
        document.dispatchEvent(event);
        
        // Afficher une notification (optionnel)
        this.showThemeNotification(theme);
    }

    showThemeNotification(theme) {
        // Créer une notification temporaire
        const notification = document.createElement('div');
        notification.className = `theme-notification theme-${theme}`;
        notification.innerHTML = `
            <div class="notification-content">
                <i class="fas fa-${theme === 'dark' ? 'moon' : 'sun'}"></i>
                <span>Mode ${theme === 'dark' ? 'sombre' : 'clair'} activé</span>
            </div>
        `;
        
        // Styles pour la notification
        notification.style.cssText = `
            position: fixed;
            top: 80px;
            right: 20px;
            background: ${theme === 'dark' ? '#2d2d2d' : '#ffffff'};
            color: ${theme === 'dark' ? '#ffffff' : '#000000'};
            padding: 12px 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            z-index: 9999;
            opacity: 0;
            transform: translateX(100%);
            transition: all 0.3s ease;
            border: 1px solid ${theme === 'dark' ? '#404040' : '#e0e0e0'};
        `;
        
        document.body.appendChild(notification);
        
        // Animation d'entrée
        setTimeout(() => {
            notification.style.opacity = '1';
            notification.style.transform = 'translateX(0)';
        }, 100);
        
        // Animation de sortie et suppression
        setTimeout(() => {
            notification.style.opacity = '0';
            notification.style.transform = 'translateX(100%)';
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 300);
        }, 2000);
    }

    // Obtenir le thème actuel
    getCurrentTheme() {
        return this.currentTheme;
    }

    // Réinitialiser au thème système
    resetToSystemTheme() {
        localStorage.removeItem('theme');
        this.detectSystemPreference();
    }

    // Forcer un thème spécifique
    forceTheme(theme) {
        localStorage.setItem('theme', theme);
        this.setTheme(theme);
    }
}

// Fonctions utilitaires globales
window.toggleTheme = () => {
    if (window.themeManager) {
        window.themeManager.toggleTheme();
    }
};

window.setTheme = (theme) => {
    if (window.themeManager) {
        window.themeManager.setTheme(theme);
    }
};

window.getCurrentTheme = () => {
    return window.themeManager ? window.themeManager.getCurrentTheme() : 'light';
};

// Initialisation quand le DOM est prêt
document.addEventListener('DOMContentLoaded', () => {
    window.themeManager = new ThemeManager();
    
    // Ajouter les styles CSS pour les notifications
    const style = document.createElement('style');
    style.textContent = `
        .notification-content {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 500;
        }
        
        .theme-notification .fa-sun {
            color: #ffd43b;
        }
        
        .theme-notification .fa-moon {
            color: #4c6ef5;
        }
        
        @media (max-width: 768px) {
            .theme-notification {
                top: 60px;
                right: 10px;
                left: 10px;
            }
        }
    `;
    document.head.appendChild(style);
});

// Export pour les modules ES6
if (typeof module !== 'undefined' && module.exports) {
    module.exports = ThemeManager;
}
