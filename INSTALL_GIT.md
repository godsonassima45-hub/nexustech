# 🔧 Installation Git pour NexusTech

## ❌ **Problème : "no found"**

Le script `deploy_windows.bat` affiche "no found" car **Git n'est pas installé** sur votre système Windows.

---

## 🚀 **SOLUTION : Installer Git (2 minutes)**

### **Méthode 1: Téléchargement Manuel (Recommandé)**

1. 🌐 **Allez sur** : https://git-scm.com/
2. 💻 **Téléchargez** : Git for Windows
3. 📥 **Installez** : Cliquez sur le fichier `.exe`
4. ✅ **Options** : Gardez les options par défaut
5. 🔄 **Redémarrez** : Votre ordinateur après l'installation

### **Méthode 2: Via PowerShell (Automatique)**

Ouvrez PowerShell en tant qu'administrateur et exécutez :
```powershell
# Télécharge et installe Git automatiquement
Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/latest/download/Git-2.43.0-64-bit.exe" -OutFile "git-installer.exe"
Start-Process "git-installer.exe" -Wait
```

---

## 🔍 **VÉRIFICATION DE L'INSTALLATION**

### **Après installation, ouvrez un nouveau terminal** :
```cmd
git --version
```

**Doit afficher quelque chose comme :**
```
git version 2.43.0.windows.1
```

---

## 🚀 **DÉPLOIEMENT APRÈS INSTALLATION**

### **1. Ouvrez un nouveau terminal** (important !)
### **2. Naviguez vers le projet** :
```cmd
cd "c:\Users\hacker\Desktop\IA site web\site_web_professionnel"
```

### **3. Lancez le script** :
```cmd
deploy_windows.bat
```

### **4. Le script fonctionnera maintenant** :
- ✅ Git détecté
- ✅ Environnement virtuel créé
- ✅ Dépendances installées
- ✅ Configuration vérifiée
- ✅ Git commit et push

---

## 🛠️ **SI PROBLÈME PERSISTE**

### **Option 1: Utiliser Git Bash**
1. 📁 **Clic droit** sur le dossier du projet
2. 🐚 **"Git Bash Here"**
3. 🚀 **Exécutez** : `bash deploy_windows.bat`

### **Option 2: Installation manuelle complète**
```cmd
# 1. Téléchargez Git
# 2. Installez-le
# 3. Redémarrez votre PC
# 4. Ouvrez un NOUVEAU terminal
# 5. Testez: git --version
# 6. Lancez: deploy_windows.bat
```

---

## 🔧 **DÉPANNAGE COMPLET**

### **Si "command not found" persiste** :
1. 🔄 **Redémarrez votre ordinateur** (important !)
2. 🚫 **Fermez tous les terminaux ouverts**
3. 🆕 **Ouvrez un NOUVEAU terminal**
4. 🧪 **Testez** : `git --version`

### **Si le PATH n'est pas configuré** :
```cmd
# Ajoutez Git au PATH manuellement
set PATH=%PATH%;C:\Program Files\Git\bin
set PATH=%PATH%;C:\Program Files\Git\cmd
git --version
```

### **Si vous utilisez VS Code** :
1. 🔄 **Redémarrez VS Code**
2. 🆕 **Ouvrez un nouveau terminal intégré**
3. 🧪 **Testez** : `git --version`

---

## 🎯 **OBJECTIF FINAL**

### **Après installation de Git** :
- ✅ Le script `deploy_windows.bat` fonctionnera
- 🚀 NexusTech sera déployé sur Render
- 🔒 HTTPS sera configuré automatiquement
- 🌐 Votre site sera en ligne

---

## 📞 **ASSISTANCE**

### **Si vous avez besoin d'aide** :
- 📧 **NexusTech** : contact@nexustech.io
- 🌐 **Git Documentation** : https://git-scm.com/doc
- 📋 **Support Windows** : https://support.microsoft.com

---

## 🚀 **ÉTAPES RAPIDES**

1. 🌐 **Téléchargez** : https://git-scm.com/
2. 💻 **Installez** : Git for Windows
3. 🔄 **Redémarrez** : Votre ordinateur
4. 🆕 **Ouvrez** : Nouveau terminal
5. 🚀 **Lancez** : `deploy_windows.bat`

**Une fois Git installé, votre site NexusTech sera en ligne en 10 minutes ! 🚀✨**
