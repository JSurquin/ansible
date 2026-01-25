---
layout: new-section
routeAlias: 'reseaux-volumes-docker'
---

<a name="reseaux-volumes-docker" id="reseaux-volumes-docker"></a>

# Réseaux & Volumes Docker 🌐💾

---

## Pourquoi a-t-on besoin de réseaux et volumes ? 🤔

### Les problèmes à résoudre

**Sans réseaux Docker** :
- Vos containers ne peuvent pas se parler facilement
- Difficile de faire communiquer une app web avec sa base de données

**Sans volumes Docker** :
- 💀 **Vos données disparaissent** quand vous supprimez un container
- Impossible de partager des fichiers entre containers
- Pas de persistance pour vos bases de données

### Ce que Docker résout

✅ **Réseaux** : Communication simple entre containers  
✅ **Volumes** : Vos données survivent aux containers  

---

## 💾 Volumes - Le problème de base

### Que se passe-t-il SANS volumes ?

```bash
# Créer un container avec des données
docker run -it --name test-data ubuntu:20.04 bash

# Dans le container, créer un fichier important
echo "Mes données importantes" > /app/data.txt
exit

# PROBLÈME : Supprimer le container = PERTE DES DONNÉES
docker rm test-data

# 💀 Le fichier data.txt a DISPARU pour toujours !
```

**😱 Résultat** : Toutes vos données sont **perdues** !

---

## 🔧 Solution : Les Volumes Docker

### Qu'est-ce qu'un volume exactement ?

Un **volume** est un **dossier spécial** que Docker gère pour vous :

- 📁 **Stocké sur votre disque dur** (pas dans le container)
- 🔄 **Partageable** entre plusieurs containers
- 💾 **Persistent** : survit à la suppression du container
- 🛡️ **Géré par Docker** : sauvegarde, permissions automatiques

**Analogie** : C'est comme un **disque dur externe** que vous branchez sur différents ordinateurs !

> Vous pouvez aussi le voir comme un disque dur virtuel qui est géré par Docker.

---

## 📊 Types de volumes - Comprendre les différences

### 3 façons de gérer vos données

| Type | Quand l'utiliser | Où sont les données |
|------|------------------|-------------------|
| **🤖 Volume anonyme** | Par accident/débutant | Docker le gère |
| **📛 Volume nommé** | **Production** | Docker le gère |
| **📁 Bind mount** | **Développement** | Sur votre PC |

---

⚙️ Analogie simple : Volumes = Clés USB

| Type | Quand l'utiliser | Où sont les données | Analogie 🧠 |
|------|------------------|-------------------|-------------|
| **🤖 Volume anonyme** | Débutant / oubli | Docker (nom auto) | 🕳️ Clé USB sans étiquette jetée dans un tiroir — tu la retrouves jamais |
| **📛 Volume nommé** | Production | Docker (nom choisi) | 🏷️ Clé USB avec ton nom, rangée dans une boîte — facile à retrouver, réutiliser |
| **📁 Bind mount** | Développement | Sur votre PC | 💻 Tu bosses directement sur un dossier de ton PC, comme si ton app était "en live" |

---

## 🤖 Volumes Anonymes - Ce qui arrive aux débutants

### Quand Docker crée des volumes automatiquement

```bash
# ❌ Commande de débutant (SANS -v)
docker run -d --name mysql-test mysql:8.0

# 🤖 Docker crée automatiquement un volume ANONYME
docker volume ls
# DRIVER    VOLUME NAME
# local     a1b2c3d4e5f6...  ← Volume avec nom aléatoire !
```

**⚠️ Problème** : Volume avec nom bizarre, difficile à retrouver !

---

### Pourquoi Docker fait ça automatiquement ?

```bash
# Voir les détails du container MySQL
docker inspect mysql-test

# Dans les détails, vous verrez :
# "Mounts": [
#   {
#     "Type": "volume",
#     "Name": "a1b2c3d4e5f6...",
#     "Source": "/var/lib/docker/volumes/a1b2c3d4e5f6.../",
#     "Destination": "/var/lib/mysql"
#   }
# ]
```

**💡 Pourquoi ?** MySQL **a besoin** de persister ses données, Docker crée donc automatiquement un volume pour `/var/lib/mysql` !

---

## 📛 Volumes Nommés - La bonne pratique

### Créer et utiliser un volume avec un nom explicite

```bash
# ✅ Créer un volume avec un nom clair
docker volume create mysql-data

# ✅ Utiliser ce volume avec votre container
docker run -d \
  --name mysql-prod \
  -v mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=password123 \
  mysql:8.0

# ✅ Vérifier que vos données sont là
docker volume ls
# DRIVER    VOLUME NAME
# local     mysql-data    ← Nom clair et lisible !
```

---

### Test de persistance des données

```bash
# 1. Créer une base de données
docker exec -it mysql-prod mysql -p
# permet de faire deux commande en meme temps, se connecter au container et executer une commande
# CREATE DATABASE test_app;
# exit

# 2. SUPPRIMER le container (simulation crash)
docker stop mysql-prod
docker rm mysql-prod

# 3. Recréer un nouveau container avec le MÊME volume
docker run -d \
  --name mysql-nouveau \
  -v mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=password123 \
  mysql:8.0

# 4. Vérifier que les données sont TOUJOURS LÀ !
docker exec -it mysql-nouveau mysql -p
# SHOW DATABASES;  ← test_app est toujours là ! ✅
```

**🎉 Résultat** : Vos données ont **survécu** à la destruction du container !

---

## 📁 Bind Mounts - Pour le développement

### Lier un dossier de votre PC au container

```bash
# Créer un dossier sur votre PC
mkdir ~/mon-projet
echo "console.log('Hello Docker!');" > ~/mon-projet/app.js

# Lier ce dossier au container
docker run -it \
  --name dev-container \
  -v ~/mon-projet:/app \
  node:18-alpine \
  sh

# Dans le container :
# cd /app
# ls -la        ← Vous voyez app.js !
# node app.js   ← "Hello Docker!"
```

---

### Magie du bind mount - Modification en temps réel

```bash
# Sur votre PC, modifier le fichier
echo "console.log('Modifié depuis mon PC!');" > ~/mon-projet/app.js

# Dans le container, relancer
# node app.js   ← "Modifié depuis mon PC!"
```

**🪄 Magie** : Les modifications sur votre PC apparaissent **instantanément** dans le container !

---

### Ce qu'il se passe VRAIMENT avec un bind mount :

- Le dossier de votre PC est **monté directement** dans le container
- Il n'y a **aucune copie** de fichier : c'est le même fichier vu des deux côtés
- Le container lit/écrit directement dans le dossier du host
- Toute modification faite sur le PC est **instantanément visible** dans le container
- Et inversement, ce que fait le container modifie le fichier sur le host
- Vous pouvez vérifier ça avec `cat /app/app.js` ou `cat ~/mon-projet/app.js` → même contenu

🧠 Attention : Si un dossier existe déjà dans le container (ex: /app), le bind mount va **masquer** son contenu. Le dossier de votre PC **remplace entièrement** celui du container. Le contenu initial du container à cet endroit est **invisible**, mais **pas supprimé**

Si vous annulez le bind mount, le dossier du container reprend son contenu initial.

---

## 🌐 Réseaux Docker - Le problème de communication

### Pourquoi les containers ne se parlent pas par défaut ?

```bash
# Lancer 2 containers séparés
docker run -d --name app1 nginx:alpine
docker run -d --name app2 nginx:alpine

# Essayer de faire communiquer app1 avec app2
docker exec app1 ping app2
# ping: bad address 'app2'  ← ÉCHEC !
```

**😕 Problème** : Les containers sont **isolés** par défaut !

---

## 🔗 Solution : Créer un réseau personnalisé

### Les containers peuvent se parler par leur nom

```bash
# 1. Créer un réseau personnalisé
docker network create mon-reseau

# 2. Lancer les containers dans ce réseau
docker run -d --name app1 --network mon-reseau nginx:alpine
docker run -d --name app2 --network mon-reseau nginx:alpine

# 3. Maintenant ils peuvent se parler !
docker exec app1 ping app2
# PING app2 (172.20.0.3): 56 data bytes  ← ✅ ÇA MARCHE !

# Ils sont tout les deux sur le même réseau "mon-reseau" et peuvent se parler.
```

**🎯 Résultat** : Communication par **nom de container** !

---

## 🏗️ Exemple concret : Site web + Base de données

### Stack complète qui fonctionne ensemble

```bash
# 1. Créer l'infrastructure
docker network create webapp-network
docker volume create database-data

# 2. Lancer la base de données
docker run -d \
  --name database \
  --network webapp-network \
  -v database-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=secret \
  -e MYSQL_DATABASE=myapp \
  mysql:8.0
```

---

### Suite : Application web

```bash
# 3. Lancer l'application web
docker run -d \
  --name webapp \
  --network webapp-network \
  -p 3000:3000 \
  -e DATABASE_HOST=database \
  -e DATABASE_USER=root \
  -e DATABASE_PASSWORD=secret \
  -e DATABASE_NAME=myapp \
  node:18-alpine \
  sh -c "
    npm init -y &&
    npm install express mysql2 &&
    echo 'const express = require(\"express\");
    const app = express();
    app.get(\"/\", (req, res) => res.send(\"App connectée à MySQL!\"));
    app.listen(3000);' > app.js &&
    node app.js
  "
```

---

### Test de la stack complète

```bash
# 4. Tester que tout fonctionne
curl http://localhost:3000
# "App connectée à MySQL!"  ← ✅ ÇA MARCHE !

# 5. Voir les containers qui communiquent
docker exec webapp ping database
# PING database (172.21.0.2)  ← Communication réseau ✅

# 6. Vérifier la persistance
docker volume inspect database-data
# Les données MySQL sont sauvegardées ✅
```

---

## 🔍 Types de réseaux Docker - Les vraies différences

### 🤔 Pourquoi bridge et host semblent similaires ?

À première vue, **bridge** et **host** ont l'air pareils :
- ✅ Les containers peuvent accéder à Internet
- ✅ Tu peux exposer des ports
- ✅ Ça marche pour tes apps

**MAIS** la différence est dans **l'isolation réseau** et **comment ça fonctionne sous le capot** !

---

### 🧱 Réseau Bridge (défaut) - Isolation sécurisée

```bash
# Le container a son propre réseau virtuel
docker run -d -p 8080:80 --name web nginx

# ✅ Ce qui se passe :
# - Container a une IP interne (ex: 172.17.0.2)
# - Tu DOIS utiliser -p pour exposer les ports
# - Accessible via localhost:8080 sur ton PC
# - Container isolé du réseau de ton PC
```

**🔒 Isolation** : Container dans sa bulle réseau, plus sécurisé

---

### 🏠 Réseau Host - Performance maximale

```bash
# Le container utilise directement le réseau de ta machine
docker run -d --network host --name web nginx

# ⚡ Ce qui se passe :
# - Container utilise l'IP de ton PC
# - PAS besoin de -p → nginx accessible direct sur port 80
# - Plus rapide car pas de couche réseau virtuelle
# - ⚠️ Marche QUE sur Linux natif (pas Docker Desktop Mac/Windows)
```

**🚀 Performance** : Container "fusionné" avec ton PC, plus rapide

---

### 🚫 Réseau None - Isolation totale

```bash
# Aucun réseau du tout
docker run -d --network none --name isolated alpine

# 🔒 Ce qui se passe :
# - Pas d'accès Internet
# - Pas de communication avec d'autres containers
# - Parfait pour traitement de données sensibles
```

**🔐 Sécurité** : Container complètement coupé du monde

---

### 📊 Tableau comparatif - Bridge vs Host vs None

| Mode | IP container ? | Isolation ? | Accès aux ports | Performance | Usage typique |
|------|---------------|-------------|-----------------|-------------|---------------|
| **🧱 bridge** | ✅ Oui (virtuel) | ✅ Sécurisé | via `-p` | Standard | Apps normales, production |
| **🏠 host** | ❌ Non (host IP) | ❌ Aucune | direct | Maximum | Apps haute perf, debug |
| **🚫 none** | ❌ Aucune | ✅ Totale | aucun | N/A | Traitement isolé |
| **🔗 bridge custom** | ✅ Oui | ✅ Sécurisé | via `-p` + DNS | Standard | Multi-containers |

---

### 🎯 Exemples concrets des différences

```bash
# === BRIDGE (défaut) ===
docker run -d -p 8080:80 --name web-bridge nginx
# → Accessible sur http://localhost:8080
# → Container IP: 172.17.0.2 (réseau virtuel)

# === HOST ===
docker run -d --network host --name web-host nginx
# → Accessible sur http://localhost:80 (direct)
# → Container IP: même que ton PC

# === Comparaison ===
docker exec web-bridge ip addr    # IP virtuelle Docker
docker exec web-host ip addr      # IP de ton PC
```

---

### ⚠️ Limitations importantes

**Réseau Host** :
- ❌ **Ne fonctionne QUE sur Linux natif**
- ❌ Docker Desktop (Mac/Windows) → host = bridge automatiquement
- ❌ Moins sécurisé (pas d'isolation)
- ❌ Conflicts de ports possible avec le host

**Réseau Bridge** :
- ⚠️ Containers sur bridge par défaut ne se voient pas par nom
- ✅ Solution : créer un bridge personnalisé

---

### 💡 Analogies pour retenir

**🧱 Bridge** :
- **Analogie** : Tu es dans une colocation avec d'autres colocataires (containers) : vous pouvez parler entre vous (même réseau), et vous avez tous accès à Internet.

**🏠 Host** :
- **Analogie** : Tu bosses **seul** sur ton propre PC connecté directement à Internet - aucune cloison, tu fais tout toi-même, vite, mais moins sécurisé.

**🚫 None** :
- **Analogie** : Tu bosses dans une **salle sans Wi-Fi, sans câble, sans rien** : impossible de communiquer, même avec tes voisins.

---

## 📋 Commandes essentielles - Diagnostic et debug

### Réseaux - Voir ce qui se passe

```bash
# Lister tous les réseaux
docker network ls

# Voir les détails d'un réseau (quels containers sont dessus)
docker network inspect mon-reseau

# Connecter un container existant à un réseau
docker network connect mon-reseau mon-container

# Tester la connectivité entre containers
docker exec container1 ping container2
docker exec container1 nslookup container2
```

---

### Volumes - Gérer vos données

```bash
# Lister tous les volumes
docker volume ls

# Voir où Docker stocke un volume sur votre disque
docker volume inspect mon-volume

# Nettoyer les volumes non utilisés
docker volume prune

# Voir l'espace utilisé par Docker
docker system df

# Backup d'un volume
docker run --rm -v mon-volume:/data -v $(pwd):/backup alpine \
  tar czf /backup/backup.tar.gz -C /data .
```

---

## 🚨 Erreurs courantes et solutions

### "Container can't connect to database"

```bash
# ❌ Erreur : containers pas sur le même réseau
docker run -d --name db mysql:8.0
docker run -d --name app mon-app  # Différents réseaux !

# ✅ Solution : même réseau
docker network create app-net
docker run -d --name db --network app-net mysql:8.0
docker run -d --name app --network app-net mon-app
```

---

### "Data lost after container restart"

```bash
# ❌ Erreur : pas de volume
docker run -d --name db mysql:8.0  # Données perdues !

# ✅ Solution : volume nommé
docker volume create db-data
docker run -d --name db -v db-data:/var/lib/mysql mysql:8.0
```

---

### "Permission denied in bind mount"

```bash
# ❌ Erreur : problème de permissions
docker run -v /host/folder:/container/folder image

# ✅ Solution : utiliser l'option :Z pour SELinux
docker run -v /host/folder:/container/folder:Z image

# ✅ Alternative : changer les permissions
chmod 755 /host/folder
```

---

## 🛡️ Bonnes pratiques 2026

### Réseaux sécurisés

✅ **DO** - Créez des réseaux séparés par fonction :
```bash
docker network create frontend-net
docker network create backend-net
# Web servers sur frontend-net
# Databases sur backend-net
```

❌ **DON'T** - Utilisez le réseau bridge par défaut en production

---

### Volumes optimisés

✅ **DO** - Volumes nommés en production :
```bash
docker volume create app-data
docker run -v app-data:/data mon-app
```

✅ **DO** - Bind mounts en développement :
```bash
docker run -v $(pwd)/src:/app/src mon-app
```

❌ **DON'T** - Volumes anonymes (sauf cas spéciaux)

---

### Sécurité

✅ **DO** - Lecture seule quand possible :
```bash
docker run -v /host/config:/app/config:ro mon-app
```

✅ **DO** - Réseaux internes pour les bases de données :
```bash
docker network create --internal db-network
```

❌ **DON'T** - Exposez les ports de database directement

---

## 🎯 Récapitulatif - Ce que vous avez appris

### Volumes 💾
- **Problème** : Les données disparaissent avec les containers
- **Solution** : Volumes pour la persistance
- **Types** : Anonymes (éviter), nommés (production), bind mounts (dev)

### Réseaux 🌐
- **Problème** : Containers isolés par défaut
- **Solution** : Réseaux personnalisés pour la communication
- **Magie** : Communication par nom de container
- **Types** : Bridge (sécurisé), Host (performance), None (isolé)

### Next step 🚀
Prêt pour **Docker Compose** qui simplifie tout ça !