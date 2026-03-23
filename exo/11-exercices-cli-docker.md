---
layout: new-section
routeAlias: 'exercices-cli-docker'
---

<a name="EXERCICES_CLI" id="EXERCICES_CLI"></a>

# Exercices CLI Docker 🎯

### 3 niveaux DevOps progressifs

Maîtrisez Docker avec des **stacks complètes** : réseaux + volumes + communication inter-containers !

---

## Pourquoi ces exercices ? 🤔

### Objectifs pédagogiques

- **🌐 Réseaux** : Faire communiquer plusieurs containers
- **💾 Volumes** : Persister et partager des données
- **🔧 Variables** : Configurer vos applications
- **👀 Monitoring** : Voir ce qui se passe en temps réel
- **🚀 Production** : Préparer des environnements réalistes

### Ce que vous allez construire aujourd'hui :
✅ Base de données avec interface web  
✅ Site WordPress complet  
✅ Environnement DevOps multi-distributions  
✅ Stack de monitoring professionnel  

---

# 🟢 Exercice Niveau Simple

## Stack PostgreSQL + Interface Web

### 🎯 **Objectif** : Votre première base de données avec interface

**Ce que vous allez apprendre** :
- Créer et utiliser des **réseaux Docker**
- Persister des données avec les **volumes**
- Connecter des containers entre eux
- Avoir un **feedback visuel** de votre base de données

---

### 📚 **Qu'est-ce que PostgreSQL ?**

**PostgreSQL** est une base de données relationnelle très populaire :
- Plus moderne que MySQL pour certains aspects
- Utilisée par Instagram, Spotify, Reddit
- Excellente pour l'apprentissage et la production

**phpPgAdmin** est une interface web pour PostgreSQL :
- Équivalent de phpMyAdmin mais pour PostgreSQL
- Permet de créer des tables, voir les données visuellement
- Parfait pour débuter sans lignes de commande

---

### 🔧 **Étape 1 : Préparer l'environnement**

```bash
# Créer le réseau pour que les containers se parlent
docker network create db-network

# Créer les volumes pour la persistence
docker volume create postgres-data
docker volume create postgres-logs

# Vérifier que tout est créé
docker network ls | grep db-network
docker volume ls | grep postgres
```

**💡 Pourquoi faire ça ?**
- **Réseau** : Les containers pourront se parler par leur nom
- **Volumes** : Vos données survivront aux redémarrages
- **Organisation** : Structure propre et réutilisable

---

### 🔧 **Étape 2 : Lancer PostgreSQL**

```bash
# Lancer PostgreSQL avec toute la configuration
docker run -d \
  --name ma-postgres \
  --network db-network \
  -e POSTGRES_DB=formation \
  -e POSTGRES_USER=docker \
  -e POSTGRES_PASSWORD=formation123 \
  -v postgres-data:/var/lib/postgresql/data \
  -v postgres-logs:/var/log/postgresql \
  -p 5432:5432 \
  postgres:15-alpine
```

---

### 📋 **Explication de la commande PostgreSQL**

```bash
# Décortiquons chaque option :

--name ma-postgres          # Nom du container (pour s'y référer)
--network db-network        # Rejoint notre réseau personnalisé
-e POSTGRES_DB=formation     # Crée une base "formation"
-e POSTGRES_USER=docker      # Utilisateur avec droits admin
-e POSTGRES_PASSWORD=...     # Mot de passe (OBLIGATOIRE!)
-v postgres-data:/var/lib... # Volume pour les données
-v postgres-logs:/var/log... # Volume pour les logs
-p 5432:5432                # Port accessible depuis votre PC
postgres:15-alpine          # Image officielle, version légère
```

---

### 🔧 **Étape 3 : Vérifier que PostgreSQL fonctionne**

```bash
# Attendre 5 secondes que PostgreSQL démarre
echo "⏳ PostgreSQL démarre..."
sleep 5

# Vérifier le statut
docker ps | grep postgres

# Voir les logs de démarrage
docker logs ma-postgres

# Tester la connexion
docker exec ma-postgres pg_isready -U docker
```

**✅ Que voir** : 
- Container en statut "Up"
- Logs sans erreur "database system is ready"
- Message "accepting connections"

---

### 🔧 **Étape 4 : Lancer l'interface web phpPgAdmin**

```bash
# Interface web pour gérer PostgreSQL
docker run -d \
  --name phppgadmin \
  --network db-network \
  -e POSTGRES_HOST=ma-postgres \
  -e POSTGRES_PORT=5432 \
  -p 8081:80 \
  dockage/phppgadmin:latest
```

---

### 📋 **Explication phpPgAdmin**

```bash
# Décortiquons cette commande :

--name phppgadmin           # Nom de l'interface web
--network db-network        # Même réseau que PostgreSQL
-e POSTGRES_HOST=ma-postgres # Se connecte à notre base
-e POSTGRES_PORT=5432       # Port standard PostgreSQL
-p 8081:80                  # Interface accessible sur port 8081
dockage/phppgadmin:latest   # Image avec interface web
```

**🌐 Magie des réseaux** : phpPgAdmin peut contacter `ma-postgres` par son nom !

---

### 🎉 **Étape 5 : Tester votre stack !**

```bash
# Vérifier que tout tourne
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "🎯 VOTRE STACK EST PRÊTE !"
echo "🌐 Interface web: http://localhost:8081"
echo "👤 Serveur: ma-postgres"
echo "🔑 User: docker"
echo "🔐 Password: formation123"
echo ""
echo "📊 Ouvrez votre navigateur et connectez-vous !"
```

---

### 🧪 **Étape 6 : Expérimenter avec les données**

**Dans l'interface web** (http://localhost:8081) :
1. **Connectez-vous** avec les identifiants
2. **Créez une table** `utilisateurs` 
3. **Ajoutez quelques données**
4. **Redémarrez PostgreSQL** : `docker restart ma-postgres`
5. **Vérifiez** que vos données sont toujours là !

```bash
# Redémarrage test
docker restart ma-postgres
sleep 5
echo "🔄 PostgreSQL redémarré, vos données sont-elles toujours là ?"
```

---

### 🔍 **Étape 7 : Explorer les volumes**

```bash
# Voir où Docker stocke vos données
docker volume inspect postgres-data

# Voir l'espace utilisé
docker system df

# Voir les fichiers de la base (depuis l'intérieur du container)
docker exec ma-postgres ls -la /var/lib/postgresql/data
```

**💡 Comprendre** : Vos données sont **physiquement** stockées sur votre disque, pas dans le container !

---

### 🧹 **Étape 8 : Nettoyage (optionnel)**

```bash
# Script pour tout supprimer proprement
echo "🧹 Nettoyage de la stack PostgreSQL..."

# Arrêter les containers
docker stop phppgadmin ma-postgres

# Supprimer les containers
docker rm phppgadmin ma-postgres

# Supprimer le réseau
docker network rm db-network

# Supprimer les volumes (ATTENTION: perte des données!)
docker volume rm postgres-data postgres-logs

echo "✅ Stack PostgreSQL supprimée"
```

---

### 🏆 **Bilan Niveau Simple**

**✅ Vous avez maîtrisé** :
- Créer des **réseaux** Docker personnalisés
- Utiliser des **volumes** pour la persistence
- Connecter des **containers** entre eux
- Configurer avec des **variables d'environnement**
- Avoir une **interface visuelle** pour vos données

**🚀 Prêt pour le niveau intermédiaire !**

---

# 🟡 Exercice Niveau Intermédiaire

## Stack WordPress Complète

### 🎯 **Objectif** : Site web professionnel avec base de données

**Ce que vous allez construire** :
- Site **WordPress** complet et fonctionnel
- Base de données **MySQL** dédiée
- Interface **phpMyAdmin** pour gérer la DB
- **Volumes** persistants pour tout sauvegarder
- **Réseau** sécurisé entre les services

---

### 📚 **Qu'est-ce que WordPress ?**

**WordPress** est le CMS le plus populaire au monde :
- Utilise environ **40% des sites web** mondiaux
- Interface d'administration intuitive
- Milliers de thèmes et plugins
- Parfait pour blogs, sites vitrine, e-commerce

**MySQL** est sa base de données préférée :
- Stocker articles, utilisateurs, commentaires
- Base relationnelle très répandue
- **phpMyAdmin** permet de la gérer visuellement

---

### 🔧 **Étape 1 : Créer l'environnement WordPress**

```bash
# Environnement dédié au WordPress
docker network create wordpress-network
docker volume create mysql-data
docker volume create wordpress-data

# Vérifier la création
echo "🌐 Réseau créé:"
docker network ls | grep wordpress

echo "💾 Volumes créés:"
docker volume ls | grep -E "(mysql|wordpress)"
```

---

### 🔧 **Étape 2 : Lancer MySQL pour WordPress**

```bash
# Base de données MySQL optimisée pour WordPress
docker run -d \
  --name mysql-wordpress \
  --network wordpress-network \
  -e MYSQL_ROOT_PASSWORD=root123 \
  -e MYSQL_DATABASE=wordpress \
  -e MYSQL_USER=wpuser \
  -e MYSQL_PASSWORD=wppass \
  -v mysql-data:/var/lib/mysql \
  --restart unless-stopped \
  mysql:8.0
```

---

### 📋 **Configuration MySQL expliquée**

```bash
# Analysons cette configuration MySQL :

-e MYSQL_ROOT_PASSWORD=root123    # Mot de passe administrateur
-e MYSQL_DATABASE=wordpress       # Base dédiée à WordPress
-e MYSQL_USER=wpuser             # Utilisateur WordPress
-e MYSQL_PASSWORD=wppass         # Son mot de passe
-v mysql-data:/var/lib/mysql     # Persistence des données
--restart unless-stopped         # Redémarre auto (sauf arrêt manuel)
mysql:8.0                        # Version stable de MySQL
```

**🔒 Sécurité** : WordPress n'a accès qu'à sa base, pas aux autres !

---

### 🔧 **Étape 3 : Attendre que MySQL soit prêt**

```bash
# MySQL prend du temps à démarrer
echo "⏳ Démarrage de MySQL (peut prendre 30 secondes)..."
sleep 15

# Vérifier que MySQL accepte les connexions
docker exec mysql-wordpress mysqladmin ping -h localhost

# Voir les logs de démarrage
docker logs mysql-wordpress --tail 10
```

**💡 Pourquoi attendre ?** MySQL doit initialiser la base `wordpress` avant que WordPress se connecte !

---

### 🔧 **Étape 4 : Lancer WordPress**

```bash
# WordPress connecté à MySQL
docker run -d \
  --name mon-wordpress \
  --network wordpress-network \
  -e WORDPRESS_DB_HOST=mysql-wordpress \
  -e WORDPRESS_DB_USER=wpuser \
  -e WORDPRESS_DB_PASSWORD=wppass \
  -e WORDPRESS_DB_NAME=wordpress \
  -v wordpress-data:/var/www/html \
  -p 8080:80 \
  --restart unless-stopped \
  wordpress:latest
```

---

### 📋 **Configuration WordPress expliquée**

```bash
# Configuration de WordPress :

-e WORDPRESS_DB_HOST=mysql-wordpress  # Se connecte à notre MySQL
-e WORDPRESS_DB_USER=wpuser          # Utilise notre utilisateur
-e WORDPRESS_DB_PASSWORD=wppass      # Avec le bon mot de passe
-e WORDPRESS_DB_NAME=wordpress       # Dans la bonne base
-v wordpress-data:/var/www/html      # Fichiers WordPress persistants
-p 8080:80                          # Accessible sur port 8080
```

**🌐 Réseau magique** : WordPress trouve MySQL via le nom `mysql-wordpress` !

---

### 🔧 **Étape 5 : Ajouter phpMyAdmin pour la base**

```bash
# Interface pour gérer la base MySQL
docker run -d \
  --name mysql-admin \
  --network wordpress-network \
  -e PMA_HOST=mysql-wordpress \
  -e PMA_USER=root \
  -e PMA_PASSWORD=root123 \
  -p 8081:80 \
  phpmyadmin:latest

echo "📊 phpMyAdmin disponible sur: http://localhost:8081"
```

---

### 🎉 **Étape 6 : Tester votre stack WordPress !**

```bash
# Vérifier tous les services
echo "🔍 État de votre stack WordPress:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(wordpress|mysql)"

echo ""
echo "🎯 VOTRE STACK WORDPRESS EST PRÊTE !"
echo ""
echo "🌐 WordPress: http://localhost:8080"
echo "📊 phpMyAdmin: http://localhost:8081"
echo "   👤 User: root | Password: root123"
echo ""
echo "🚀 Installez WordPress en suivant l'assistant !"
```

---

### 🧪 **Étape 7 : Installation WordPress complète**

**Dans votre navigateur** :

1. **Allez sur** http://localhost:8080
2. **Suivez l'assistant** d'installation WordPress
3. **Créez votre compte** administrateur
4. **Connectez-vous** au tableau de bord WordPress

```bash
# Pendant l'installation, surveillez les logs
docker logs mon-wordpress --follow
```

**🎉 Premier article** : Créez un article "Hello Docker World!" pour tester !

---

### 🔍 **Étape 8 : Explorer la base de données**

**Dans phpMyAdmin** (http://localhost:8081) :

1. **Connectez-vous** avec root/root123
2. **Sélectionnez** la base `wordpress`
3. **Explorez** les tables WordPress (wp_posts, wp_users, etc.)
4. **Trouvez** votre article dans `wp_posts` !

```bash
# Voir les tables WordPress depuis le terminal
docker exec mysql-wordpress mysql -u wpuser -pwppass wordpress -e "SHOW TABLES;"
```

---

### 🔄 **Étape 9 : Test de persistence**

```bash
# Test ultime : redémarrer toute la stack
echo "🔄 Test de persistence - redémarrage de tout..."

docker restart mysql-wordpress mon-wordpress mysql-admin

# Attendre le redémarrage
sleep 20

echo "✅ Stack redémarrée !"
echo "🌐 Votre site: http://localhost:8080"
echo "📊 Votre base: http://localhost:8081"
echo ""
echo "🎯 Vos données sont-elles toujours là ?"
```

---

### 🏆 **Bilan Niveau Intermédiaire**

**✅ Vous avez maîtrisé** :
- **Stack multi-containers** complète et fonctionnelle
- **Communication** sécurisée via réseau personnalisé
- **Persistence** totale avec volumes dédiés
- **Variables d'environnement** pour la configuration
- **Interface d'administration** pour la base de données
- **Restart policies** pour la robustesse

**🚀 Niveau avancé : environnements DevOps !**

---

# 🔴 Exercice Niveau Avancé

## Environnement DevOps Multi-Distributions

### 🎯 **Objectif** : Simuler un environnement de production DevOps

**Ce que vous allez construire** :
- **Cluster** de containers avec différentes distributions Linux
- **Workspace partagé** entre tous les containers
- **Logs centralisés** pour le monitoring
- **Outils DevOps** installés et configurés
- **Communication** inter-containers testée

---

### 📚 **Pourquoi plusieurs distributions ?**

**En production DevOps** on gère souvent :
- **CentOS/RHEL** : Serveurs d'entreprise traditionnels
- **Fedora** : Environnements de développement avec outils récents
- **Rocky Linux** : Alternative moderne à CentOS
- **Alpine** : Containers ultra-légers pour les microservices

**L'exercice simule** :
- Environnement **hétérogène** réaliste
- **Partage de fichiers** entre serveurs
- **Centralisation des logs** comme en production
- **Outils** que vous utiliseriez vraiment

---

### 🔧 **Étape 1 : Créer l'environnement DevOps**

```bash
# Infrastructure DevOps
docker network create devops-network
docker volume create shared-workspace
docker volume create logs-centralized
docker volume create tools-shared

# Créer un dossier local de travail
mkdir -p ~/docker-devops
cd ~/docker-devops

echo "🏗️ Infrastructure DevOps créée"
docker network ls | grep devops
docker volume ls | grep -E "(shared|logs|tools)"
```

---

### 🔧 **Étape 2 : Container CentOS - Serveur Legacy**

```bash
# Serveur CentOS avec outils DevOps traditionnels
docker run -d \
  --name centos-legacy \
  --network devops-network \
  -v shared-workspace:/workspace \
  -v logs-centralized:/var/log/shared \
  -v tools-shared:/opt/tools \
  --hostname centos-srv \
  --privileged \
  centos:7 \
  /bin/bash -c "
    yum update -y && 
    yum install -y git vim curl wget htop net-tools &&
    echo 'CentOS Legacy Server Ready' > /var/log/shared/centos.log &&
    tail -f /dev/null
  "
```

---

### 📋 **Configuration CentOS expliquée**

```bash
# Analysons ce container CentOS :

--hostname centos-srv              # Nom réseau identifiable
--privileged                      # Accès étendu (nécessaire pour certains outils)
-v shared-workspace:/workspace     # Dossier partagé pour les projets
-v logs-centralized:/var/log/shared # Logs centralisés
-v tools-shared:/opt/tools         # Outils partagés
yum install -y git vim curl...     # Outils DevOps essentiels
echo '...' > /var/log/shared/...   # Log de démarrage
tail -f /dev/null                  # Garde le container actif
```

---

### 🔧 **Étape 3 : Container Fedora - Environnement Modern**

```bash
# Fedora avec outils modernes de développement
docker run -d \
  --name fedora-modern \
  --network devops-network \
  -v shared-workspace:/workspace \
  -v logs-centralized:/var/log/shared \
  -v tools-shared:/opt/tools \
  --hostname fedora-dev \
  -p 9090:9090 \
  fedora:38 \
  /bin/bash -c "
    dnf update -y && 
    dnf install -y git vim curl wget htop python3 nodejs npm docker &&
    echo 'Fedora Modern Environment Ready' > /var/log/shared/fedora.log &&
    python3 -m http.server 9090 --directory /workspace &
    tail -f /dev/null
  "
```

**🚀 Bonus** : Fedora expose un serveur web sur le port 9090 pour partager des fichiers !

---

### 🔧 **Étape 4 : Container Rocky Linux - Serveur Production**

```bash
# Rocky Linux comme serveur web de production
docker run -d \
  --name rocky-production \
  --network devops-network \
  -v shared-workspace:/workspace \
  -v logs-centralized:/var/log/shared \
  -v tools-shared:/opt/tools \
  --hostname rocky-prod \
  -p 8080:80 \
  rockylinux:9 \
  /bin/bash -c "
    dnf install -y httpd git curl vim &&
    echo '<h1>🐳 Rocky Linux Production Server</h1><p>Shared workspace available</p>' > /var/www/html/index.html &&
    echo 'Rocky Production Server Ready' > /var/log/shared/rocky.log &&
    httpd -D FOREGROUND
  "
```

**🌐 Serveur web** : Rocky Linux expose un serveur HTTP sur le port 8080 !

---

### 🔧 **Étape 5 : Attendre que tout démarre**

```bash
# Laisser le temps aux installations
echo "⏳ Installation des packages sur toutes les distributions..."
sleep 30

# Vérifier que tous les containers tournent
echo "🔍 État de l'environnement DevOps:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(centos|fedora|rocky)"

echo ""
echo "🌐 Services exposés:"
echo "📁 Partage de fichiers (Fedora): http://localhost:9090"
echo "🌐 Serveur web (Rocky): http://localhost:8080"
```

---

### 🧪 **Étape 6 : Tester la communication inter-containers**

```bash
# Test de connectivité réseau
echo "🌐 Test de la communication inter-containers:"

# CentOS ping Fedora
docker exec centos-legacy ping -c 3 fedora-dev

# Fedora ping Rocky
docker exec fedora-modern ping -c 3 rocky-prod

# Rocky ping CentOS
docker exec rocky-production ping -c 3 centos-srv

echo "✅ Communication réseau testée!"
```

---

### 🧪 **Étape 7 : Tester le workspace partagé**

```bash
# Créer un fichier depuis CentOS
docker exec centos-legacy bash -c "
  echo '# Projet DevOps 2026' > /workspace/README.md
  echo 'Ce fichier est partagé entre tous les containers' >> /workspace/README.md
  echo 'Créé depuis CentOS Legacy' >> /workspace/README.md
  date >> /workspace/README.md
"

# Le lire depuis Fedora
echo "📖 Contenu lu depuis Fedora:"
docker exec fedora-modern cat /workspace/README.md

# Le modifier depuis Rocky
docker exec rocky-production bash -c "
  echo 'Modifié depuis Rocky Production' >> /workspace/README.md
"

# Vérifier depuis CentOS
echo ""
echo "📖 Contenu final lu depuis CentOS:"
docker exec centos-legacy cat /workspace/README.md
```

---

### 🔍 **Étape 8 : Explorer les logs centralisés**

```bash
# Voir tous les logs de démarrage
echo "📋 Logs centralisés de toutes les distributions:"
docker exec centos-legacy ls -la /var/log/shared/

echo ""
echo "📄 Contenu des logs:"
docker exec centos-legacy cat /var/log/shared/centos.log
docker exec fedora-modern cat /var/log/shared/fedora.log  
docker exec rocky-production cat /var/log/shared/rocky.log

# Ajouter un log personnalisé
docker exec fedora-modern bash -c "
  echo 'Test de monitoring - $(date)' >> /var/log/shared/monitoring.log
"
```

---

### 🎯 **Étape 9 : Simulation DevOps réaliste**

```bash
# Créer un script de déploiement partagé
docker exec centos-legacy bash -c "
#!/bin/bash
echo '🚀 Déploiement automatisé'
echo 'Serveur: \$(hostname)'
echo 'Distribution: \$(cat /etc/os-release | grep PRETTY_NAME)'
echo 'Date: \$(date)'
echo 'Utilisateur: \$(whoami)'
echo '✅ Déploiement terminé'
chmod +x /workspace/deploy.sh
"

# Exécuter le script depuis chaque distribution
echo "🚀 Exécution du script de déploiement:"
echo ""
echo "--- CentOS Legacy ---"
docker exec centos-legacy /workspace/deploy.sh

echo ""
echo "--- Fedora Modern ---"
docker exec fedora-modern /workspace/deploy.sh

echo ""  
echo "--- Rocky Production ---"
docker exec rocky-production /workspace/deploy.sh
```

---

### 🏆 **Bilan Niveau Avancé**

**✅ Environnement DevOps maîtrisé** :
- **Multi-distributions** Linux en communication
- **Workspace partagé** pour les projets communs
- **Logs centralisés** pour le monitoring
- **Scripts de déploiement** cross-platform
- **Simulation production** réaliste

**🔥 Prêt pour le niveau expert avec monitoring !**

---

# 🔥 Exercice BONUS - Expert

## Stack de Monitoring Professionnel

### 🎯 **Objectif** : Monitoring comme en production

**Ce que vous allez construire** :
- **Prometheus** : Collecte de métriques
- **Grafana** : Dashboards visuels magnifiques  
- **cAdvisor** : Métriques containers
- Stack complète de **monitoring production**

---

### 📚 **Qu'est-ce que le monitoring moderne ?**

**Prometheus** 🔍 :
- Base de données de **métriques** temporelles
- Utilisé par Google, SoundCloud, DigitalOcean
- Collecte automatique depuis vos applications
- Système d'**alertes** intégré

**Grafana** 📊 :
- **Dashboards** magnifiques et interactifs
- Graphiques en temps réel
- Utilisé par PayPal, eBay, Intel
- Interface web moderne et intuitive

---

### 🔧 **Étape 1 : Préparer l'environnement monitoring**

```bash
# Infrastructure de monitoring
docker network create monitoring-network
docker volume create prometheus-data
docker volume create grafana-data

# Créer le dossier de configuration
mkdir -p ~/monitoring-stack
cd ~/monitoring-stack

echo "📊 Infrastructure monitoring créée"
```

---

### 🔧 **Étape 2 : Configuration Prometheus**

```bash
# Créer la configuration Prometheus
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']

echo "⚙️ Configuration Prometheus créée"
```

**📋 Configuration expliquée** :
- `scrape_interval: 15s` : Collecte les métriques toutes les 15 secondes
- Surveille **Prometheus lui-même** et **cAdvisor**

---

### 🔧 **Étape 3 : Lancer Prometheus**

```bash
# Prometheus avec configuration personnalisée
docker run -d \
  --name prometheus \
  --network monitoring-network \
  -p 9090:9090 \
  -v $(pwd)/prometheus.yml:/etc/prometheus/prometheus.yml \
  -v prometheus-data:/prometheus \
  --restart unless-stopped \
  prom/prometheus:latest \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/prometheus \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.console.templates=/etc/prometheus/consoles \
  --web.enable-lifecycle
```

---

### 🔧 **Étape 4 : Lancer cAdvisor (métriques containers)**

```bash
# Node Exporter pour métriques système
docker run -d \
  --name node-exporter \
  --network monitoring-network \
  -p 9100:9100 \
  --restart unless-stopped \
  prom/node-exporter:latest \
  --path.rootfs=/host \
  --collector.filesystem.mount-points-exclude="^/(sys|proc|dev|host|etc)($$|/)"
```

---

### 🔧 **Étape 5 : Lancer Prometheus**

```bash
# Prometheus avec configuration personnalisée
docker run -d \
  --name cadvisor \
  --network monitoring-network \
  -p 8080:8080 \
  --restart unless-stopped \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  gcr.io/cadvisor/cadvisor:latest
```

**🐳 Qu'est-ce que cAdvisor ?**
- Développé par **Google** pour monitorer les containers
- Collecte métriques de **tous vos containers** Docker
- CPU, RAM, réseau, I/O par container

---

### 🔧 **Étape 6 : Lancer Grafana avec dashboard**

```bash
# Grafana avec storage persistant
docker run -d \
  --name grafana \
  --network monitoring-network \
  -p 3000:3000 \
  -v grafana-data:/var/lib/grafana \
  -e GF_SECURITY_ADMIN_PASSWORD=admin123 \
  -e GF_USERS_ALLOW_SIGN_UP=false \
  --restart unless-stopped \
  grafana/grafana:latest
```

**🎨 Grafana** va créer de magnifiques graphiques avec toutes ces métriques !

---

### 🎉 **Étape 7 : Vérifier votre stack monitoring**

```bash
# Attendre que tout démarre
echo "⏳ Démarrage de la stack monitoring (30 secondes)..."
sleep 30

# Vérifier tous les services
echo "📊 État de votre stack de monitoring:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(prometheus|grafana|node-exporter|cadvisor)"

echo ""
echo "🎯 STACK DE MONITORING PRÊTE !"
echo ""
echo "📈 Prometheus: http://localhost:9090"
echo "📊 Grafana: http://localhost:3000"
echo "   👤 User: admin | Password: admin123"
echo "🐳 cAdvisor: http://localhost:8080"
echo ""
echo "🚀 Configurez maintenant vos dashboards Grafana !"
```

---

### 🎨 **Étape 8 : Configuration Grafana (Hands-on)**

**Dans Grafana** (http://localhost:3000) :

1. **Connectez-vous** avec admin/admin123
2. **Ajoutez Prometheus** comme source de données :
   - URL : `http://prometheus:9090`   
   - Click "Save & Test"

3. **Importez des dashboards** préconfigurés :
   - Docker containers : Dashboard ID `193`

```bash
# Pendant que vous configurez, surveillez les métriques
echo "📈 Métriques en cours de collecte..."
docker logs prometheus --tail 10
```

---

### 🧪 **Étape 9 : Générer de l'activité à monitorer**

```bash
# Créer de l'activité pour voir les métriques bouger
echo "🔥 Génération d'activité pour le monitoring..."

# Lancer quelques containers gourmands
docker run -d --name stress-test alpine:latest \
  sh -c "while true; do echo 'generating load...'; sleep 1; done"

docker run -d --name cpu-test alpine:latest \
  sh -c "while true; do dd if=/dev/zero of=/dev/null bs=1M count=100; done"

# Surveiller en temps réel
echo "📊 Observez vos dashboards Grafana maintenant !"
echo "🔍 Vous devriez voir l'activité CPU et containers augmenter"
```

---

### 🔍 **Étape 10 : Exploration des métriques**

**Dans Prometheus** (http://localhost:9090) :

1. **Explorez les métriques** disponibles
2. **Essayez ces requêtes** dans l'onglet "Graph" :

```bash
# CPU usage
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage
100 * (1 - ((node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)))

# Container count
count(container_last_seen)
```

---

### 🏆 **Félicitations ! Stack Expert Maîtrisée**

**✅ Vous avez construit une infrastructure de monitoring professionnelle** :

- **Prometheus** : Base de données métriques comme Netflix, Uber
- **Grafana** : Dashboards visuels comme Tesla, PayPal  
- **cAdvisor** : Monitoring containers par Google
- **Configuration** production-ready avec persistence

**🎯 Compétences acquises** :
- Architecture **observabilité** moderne
- Configuration **time-series databases**  
- **Dashboards** interactifs professionnels
- **Métriques** système et containers
- **Stack** utilisée dans le monde réel

---

# 🎉 Récapitulatif Complet des Exercices

<small>

### 🟢 **Niveau Simple - Base de données**
- Réseaux Docker personnalisés
- Volumes persistants  
- Communication inter-containers
- Interface web pour bases de données

### 🟡 **Niveau Intermédiaire - Site web complet**
- Stack multi-containers (WordPress + MySQL)
- Variables d'environnement avancées
- Restart policies
- Administration de base de données

</small>

---

<small>

### 🔴 **Niveau Avancé - DevOps multi-distributions**  
- Environnement hétérogène Linux
- Workspace partagé
- Logs centralisés
- Scripts cross-platform

### 🔥 **Niveau Expert - Monitoring professionnel**
- Prometheus + Grafana
- Métriques système et containers
- Dashboards interactifs
- Observabilité production

</small>


---

## 🚀 **Vous êtes maintenant prêts pour Docker Compose !**

### Ces exercices vous ont préparés à :
- **Orchestrer** des applications complexes
- **Gérer** des environnements multi-services
- **Monitorer** vos infrastructures
- **Automatiser** vos déploiements

**Prochain module** : Docker Compose pour simplifier tout ça ! 🎼
