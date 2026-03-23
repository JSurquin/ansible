---
layout: new-section
routeAlias: 'exercices-docker-compose'
---

<a name="EXERCICES_COMPOSE" id="EXERCICES_COMPOSE"></a>

# Exercices Docker Compose 🎼

### 3 niveaux DevOps progressifs

Orchestrez plusieurs containers facilement !

---

## 🎮 Exercices Express (Warm-up)

### 3 exercices rapides avec images officielles

Avant les exercices principaux, des exercices courts pour maîtriser les bases !

---

## 🟢 Exercice Express 1 : Ma Première Stack

### Stack super simple avec 2 services (15 min)

**Choix possibles** :
- nginx + redis
- nginx + mysql
- nginx + postgres
- nginx + mongo
- nginx + elasticsearch
- nginx + kibana

**Ce qu'on apprend** : Premier docker-compose.yml, services liés

---

## 🟢 Express 1 - Configuration YAML

```yaml
# Créer docker-compose.yml
version: '3.8'

services:
  web:
    image: nginx:alpine
    ports:
      - '8080:80'
  cache:
    image: votre_choix:alpine
```

---

## 🟢 Express 1 - Tests et vérification

```bash
# Tester la stack
docker compose up -d
docker compose ps
curl http://localhost:8080
docker compose down
```

**Mission** : Voir "nginx welcome page" sur http://localhost:8080

---

## 🟡 Exercice Express 2 : Stack Base de Données

### Postgres + Adminer pour explorer une BDD (20 min)

**Ce qu'on apprend** : Variables d'environnement, volumes, interface web

---

## 🟡 Express 2 - Configuration BDD

```yaml
# docker-compose.yml plus sophistiqué
version: '3.8'

services:
  database:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: testdb
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password123
    volumes:
      - db_data:/var/lib/postgresql/data
```

---

## 🟡 Express 2 - Interface Adminer

```yaml
# Suite du docker-compose.yml
  adminer:
    image: adminer:latest
    ports:
      - '8081:8080'
    depends_on:
      - database

volumes:
  db_data:
```

---

## 🟡 Express 2 - Tests et accès

```bash
# Test complet
docker compose up -d
echo "🌐 Interface BDD: http://localhost:8081"
# Se connecter via Adminer avec les credentials
docker compose down -v
```

**Mission** : Se connecter à la BDD via l'interface web Adminer

---

## 🔴 Exercice Express 3 : Stack Monitoring Simple

### Prometheus + Grafana pour surveiller (25 min)

**Ce qu'on apprend** : Stack monitoring, réseaux personnalisés

---

## 🔴 Express 3 - Service Prometheus

```yaml
# docker-compose.yml monitoring
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    ports:
      - '9090:9090'
    networks:
      - monitoring
```

---

## 🔴 Express 3 - Service Grafana

```yaml
# Suite du docker-compose.yml
  grafana:
    image: grafana/grafana:latest
    ports:
      - '3000:3000'
    environment:
      GF_SECURITY_ADMIN_PASSWORD: admin123
    networks:
      - monitoring
    volumes:
      - grafana_data:/var/lib/grafana

volumes:
  grafana_data:

networks:
  monitoring:
    driver: bridge
```

---

## 🔴 Express 3 - Déploiement et accès

```bash
# Déploiement monitoring
docker compose up -d
echo "📊 Prometheus: http://localhost:9090"
echo "📈 Grafana: http://localhost:3000 (admin/admin123)"
docker compose down -v
```

**Mission** : Accéder aux 2 interfaces de monitoring

---

## 🎯 Exercices Principaux Détaillés

---

# 🟢 Exercice Niveau Simple

### WordPress + MySQL (Stack de blog)

**Objectif** : Déployer un blog WordPress avec base de données

**Consignes** :
1. Utiliser l'image officielle `wordpress:latest`
2. Base de données `mysql:8.0`
3. Configurer les volumes pour la persistance
4. Accessible sur le port 8080

---

# 🟢 Correction Niveau Simple

```yaml
version: '3.8'

services:
  wordpress:
    image: wordpress:latest
    ports:
      - '8080:80'
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress123
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wordpress_data:/var/www/html
    depends_on:
      - db

  db:
    image: mysql:8.0
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress123
      MYSQL_ROOT_PASSWORD: rootpass123
    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  wordpress_data:
  mysql_data:
```

---

# 🟢 Test et Gestion Simple

### Déploiement et vérification

```bash
# Lancer la stack
docker compose up -d

# Vérifier les services
docker compose ps

# Voir les logs
docker compose logs wordpress
docker compose logs db

# Tester l'accès
echo "🌐 WordPress: http://localhost:8080"
curl -I http://localhost:8080

# Arrêter proprement
docker compose down
```

**✅ Résultat** : Blog WordPress fonctionnel avec persistance des données

---

# 🟡 Exercice Niveau Intermédiaire

### Stack NGINX + Node.js + Redis

**Objectif** : Application web avec proxy et cache

**Consignes** :
1. Proxy NGINX sur le port 80
2. Application Node.js (image `node:18-alpine`)
3. Cache Redis pour les sessions
4. Réseaux séparés frontend/backend

---

### 🟡 Correction Niveau Intermédiaire - Configuration avec réseaux

```yaml
version: '3.8'

services:
  nginx:
    image: nginx:alpine
    ports:
      - '80:80'
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - app
    networks:
      - frontend

  app:
    image: nginx:alpine
    expose:
      - '80'
    volumes:
      - ./html:/usr/share/nginx/html:ro
    networks:
      - frontend
      - backend
    depends_on:
      - redis

  redis:
    image: redis:7-alpine
    networks:
      - backend
    volumes:
      - redis_data:/data

volumes:
  redis_data:

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
```

---


<div class="-mt-4">

### 🟡 Nginx - Configuration de base (nginx.conf)

```bash
# Créer la configuration NGINX
mkdir -p nginx
```

```nginx
# 2. Créer le fichier nginx.conf
events {
    worker_connections 1024;
}

http {
    upstream app {
        server app:80;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://app;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

        location /health {
            return 200 'healthy\n';
            add_header Content-Type text/plain;
        }
    }
}
```

</div>

---

## 🟡 Nginx - Page web d'exemple

```bash
# Créer une page web simple
mkdir -p html
```

```html
<!-- 2. Créer le fichier index.html -->
<!DOCTYPE html>
<html>
<head>
    <title>Stack NGINX + Redis</title>
    <style>
        body { font-family: Arial; text-align: center; padding: 50px; background: #f0f8ff; }
        .card { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <div class="card">
        <h1>🚀 Stack Intermédiaire</h1>
        <p>NGINX Proxy + Application + Redis Cache</p>
        <p>✅ Proxy fonctionnel</p>
        <p>✅ Cache Redis en arrière-plan</p>
        <p>✅ Réseaux séparés</p>
    </div>
</body>
</html>
```

---

# 🟡 Test Stack Intermédiaire

```bash
# Déployer la stack complète
docker compose up -d

# Vérifier tous les services
docker compose ps

# Tester le proxy
curl http://localhost/
curl http://localhost/health

# Vérifier Redis
docker compose exec redis redis-cli ping

# Monitoring des logs
docker compose logs -f nginx

# Cleanup
docker compose down -v
```

**✅ Résultat** : Stack 3-tiers avec proxy et cache

---

# 🔴 Exercice Niveau Avancé

### Monitoring Stack (Prometheus + Grafana)

**Objectif** : Infrastructure de monitoring complète

**Consignes** :
1. Prometheus serveur de monitoring
2. Grafana interface de visualisation
3. Node Exporter pour les métriques système
4. AlertManager pour les alertes par email

---

# 🔴 Correction Niveau Avancé

### Stack de monitoring complète

---

## 🔴 Avancé - Service Prometheus

```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    ports:
      - '9090:9090'
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus
    command:
      - --config.file=/etc/prometheus/prometheus.yml
      - --storage.tsdb.path=/prometheus
      - --web.console.libraries=/etc/prometheus/console_libraries
      - --web.console.templates=/etc/prometheus/consoles
    networks:
      - monitoring
```

---

## 🔴 Avancé - Service Grafana

```yaml
# Suite du docker-compose.yml
  grafana:
    image: grafana/grafana:latest
    ports:
      - '3000:3000'
    environment:
      GF_SECURITY_ADMIN_PASSWORD: admin123
    volumes:
      - grafana_data:/var/lib/grafana
    networks:
      - monitoring
```

---

## 🔴 Avancé - Node Exporter

```yaml
# Suite du docker-compose.yml
  node-exporter:
    image: prom/node-exporter:latest
    ports:
      - '9100:9100'
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - --path.procfs=/host/proc
      - --path.rootfs=/rootfs
      - --path.sysfs=/host/sys
      - --collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)
    networks:
      - monitoring
```

---

## 🔴 Avancé - AlertManager et volumes

```yaml
# Suite du docker-compose.yml
  alertmanager:
    image: prom/alertmanager:latest
    ports:
      - '9093:9093'
    volumes:
      - ./alertmanager.yml:/etc/alertmanager/alertmanager.yml:ro
    networks:
      - monitoring

volumes:
  prometheus_data:
  grafana_data:

networks:
  monitoring:
    driver: bridge
```

---

## 🔴 Config - Fichier Prometheus

```yaml
# Configuration Prometheus
# Créer le fichier prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  # - "first_rules.yml"

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']

  - job_name: 'grafana'
    static_configs:
      - targets: ['grafana:3000']
```

---

## 🔴 Config - Fichier AlertManager

```yaml
# Configuration AlertManager
# Créer le fichier alertmanager.yml
global:
  smtp_smarthost: 'localhost:587'
  smtp_from: 'alertmanager@example.org'

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'web.hook'

receivers:
  - name: 'web.hook'
    webhook_configs:
      - url: 'http://127.0.0.1:5001/'
```

---

# 🔴 Déploiement et Monitoring

```bash
# Déployer la stack de monitoring
docker compose up -d

# Attendre que tout soit prêt
sleep 30

# Vérifier tous les services
docker compose ps

# URLs d'accès
echo "📊 Prometheus: http://localhost:9090"
echo "📈 Grafana: http://localhost:3000 (admin/admin123)"
echo "🔔 AlertManager: http://localhost:9093"
echo "📊 Node Exporter: http://localhost:9100"

# Tests automatiques
curl -s http://localhost:9090/-/healthy && echo "✅ Prometheus OK"
curl -s http://localhost:3000/api/health && echo "✅ Grafana OK"
curl -s http://localhost:9100/metrics | head -5 && echo "✅ Node Exporter OK"

# Monitoring en temps réel
docker compose logs -f prometheus
```

**✅ Résultat** : Infrastructure de monitoring production-ready

---

# 🔵 Exercice Niveau Expert

### Stack DevOps Complète (GitLab + Registry + Runner)

**Objectif** : Plateforme CI/CD complète avec GitLab

**Consignes** :
1. GitLab CE pour le code source
2. GitLab Registry pour les images
3. GitLab Runner pour les pipelines
4. PostgreSQL comme base de données

---

### 🔵 Correction Niveau Expert - Infrastructure GitLab complète

```yaml
version: '3.8'

services:
  gitlab:
    image: gitlab/gitlab-ce:latest
    hostname: gitlab.local
    ports:
      - '80:80'
      - '443:443'
      - '2222:22'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://gitlab.local'
        gitlab_rails['gitlab_shell_ssh_port'] = 2222
        postgresql['enable'] = false
        gitlab_rails['db_adapter'] = 'postgresql'
        gitlab_rails['db_encoding'] = 'utf8'
        gitlab_rails['db_host'] = 'postgresql'
        gitlab_rails['db_port'] = 5432
        gitlab_rails['db_database'] = 'gitlab'
        gitlab_rails['db_username'] = 'gitlab'
        gitlab_rails['db_password'] = 'gitlab123'
    volumes:
      - gitlab_config:/etc/gitlab
      - gitlab_logs:/var/log/gitlab
      - gitlab_data:/var/opt/gitlab
    depends_on:
      - postgresql
    networks:
      - gitlab-network

  postgresql:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: gitlab
      POSTGRES_USER: gitlab
      POSTGRES_PASSWORD: gitlab123
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - gitlab-network

  gitlab-runner:
    image: gitlab/gitlab-runner:latest
    volumes:
      - gitlab_runner_config:/etc/gitlab-runner
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - gitlab-network
    depends_on:
      - gitlab

volumes:
  gitlab_config:
  gitlab_logs:
  gitlab_data:
  postgres_data:
  gitlab_runner_config:

networks:
  gitlab-network:
    driver: bridge
```

---

### 🔵 Script de déploiement GitLab (deploy-gitlab.sh)

```bash
# Script de déploiement GitLab
# Créer le fichier deploy-gitlab.sh
#!/bin/bash

echo "🚀 Déploiement GitLab DevOps Stack..."

# Ajout de l'hostname local
echo "127.0.0.1 gitlab.local" | sudo tee -a /etc/hosts

# Démarrage de la stack
docker compose up -d

echo "⏳ GitLab démarre... (peut prendre 5-10 minutes)"
echo "📊 Monitoring du démarrage:"
```

---

## 🔵 Script d'attente GitLab

```bash
# Suite du script deploy-gitlab.sh

# Attendre que GitLab soit prêt
until curl -s http://gitlab.local/users/sign_in > /dev/null; do
  echo "⏳ GitLab en cours de démarrage..."
  sleep 30
done

echo "✅ GitLab est prêt !"

# Récupérer le mot de passe root initial
echo "🔑 Mot de passe root initial:"
docker compose exec gitlab cat /etc/gitlab/initial_root_password | grep Password:

echo ""
echo "🌐 GitLab: http://gitlab.local"
echo "👤 Utilisateur: root"
echo "🔧 Configuration Runner: docker compose exec gitlab-runner gitlab-runner register"

chmod +x deploy-gitlab.sh
```

---

# 🔵 Configuration GitLab Runner

### Registration automatique du Runner

---

## 🔵 Script configuration Runner

```bash
# Script de configuration du Runner
# Créer le fichier setup-runner.sh
#!/bin/bash

echo "🏃 Configuration GitLab Runner..."

# Récupérer le token de registration
echo "1. Aller sur http://gitlab.local/admin/runners"
echo "2. Copier le registration token"
echo "3. Exécuter la commande suivante:"
```

---

## 🔵 Commande registration Runner

```bash
# Suite du script setup-runner.sh

echo ""
echo "docker compose exec gitlab-runner gitlab-runner register \\"
echo "  --non-interactive \\"
echo "  --url http://gitlab.local \\"
echo "  --registration-token YOUR_TOKEN \\"
echo "  --executor docker \\"
echo "  --docker-image alpine:latest \\"
echo "  --description 'Docker Runner' \\"
echo "  --tag-list 'docker,linux' \\"
echo "  --docker-privileged"

echo ""
echo "✅ Runner configuré pour exécuter des pipelines Docker"

chmod +x setup-runner.sh
```

---

# 🔵 Test Stack DevOps Complète

---

## 🔵 Déploiement et attente

```bash
# Déploiement complet
./deploy-gitlab.sh

# Attendre le démarrage complet
sleep 300
```

---

## 🔵 Tests et vérifications

```bash
# Vérifications
echo "🧪 Tests de la stack DevOps..."

# Test GitLab
curl -I http://gitlab.local && echo "✅ GitLab accessible"

# Vérifier PostgreSQL
docker compose exec postgresql pg_isready -U gitlab && echo "✅ PostgreSQL OK"

# Status des services
docker compose ps
```

---

## 🔵 Informations finales

```bash
echo ""
echo "🎉 Stack DevOps GitLab déployée !"
echo "🌐 GitLab: http://gitlab.local"
echo "🗄️ Base de données: PostgreSQL"
echo "🏃 Runner: Prêt pour CI/CD"
echo "🔧 Configuration Runner: ./setup-runner.sh"

# Logs en continu
docker compose logs -f gitlab
```

**✅ Résultat** : Plateforme DevOps complète avec CI/CD intégré

---

# Récapitulatif Exercices Compose 📋

### Compétences acquises avec images officielles

**🟢 Niveau Simple** :
- WordPress + MySQL (images officielles)
- Volumes et persistance
- Variables d'environnement
- Commandes de base

**🟡 Niveau Intermédiaire** :
- NGINX + Node.js + Redis
- Réseaux personnalisés
- Configuration de proxy
- Monitoring des services

---

# Récapitulatif Compose (suite) 📋

**🔴 Niveau Avancé** :
- Stack Prometheus + Grafana (monitoring)
- Node Exporter + AlertManager
- Configuration avancée
- Health checks

**🔵 Niveau Expert** :
- GitLab CE + PostgreSQL + Runner
- Plateforme CI/CD complète
- Infrastructure DevOps
- Pipelines automatisés

### 🚀 **Docker Compose maîtrisé avec images réelles !**

Prochaine étape : Ansible pour automatiser le déploiement !