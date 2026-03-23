---
layout: default
routeAlias: 'mini-blog-exercices'
---

<a name="MINI_BLOG_EXERCICES" id="MINI_BLOG_EXERCICES"></a>

# Exercices Mini-Blog

## Module 1 : Introduction à Docker

### Exercice 1.1 : Création d'un conteneur Nginx
```bash
# Créer un conteneur Nginx
docker run -d --name nginx -p 80:80 nginx

# Vérifier le statut
docker ps

# Accéder au conteneur
docker exec -it nginx bash
```

### Exercice 1.2 : Dockerfile pour une application simple
```dockerfile
# Créer un Dockerfile pour une application Node.js
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "app.js"]
```

---

# Exercices (Suite)

## Module 2 : Docker Compose

### Exercice 2.1 : Configuration de base
```yaml
# Créer un docker-compose.yml pour le frontend
version: '3.8'
services:
  frontend:
    build: ./frontend
    ports:
      - "4200:4200"
    volumes:
      - ./frontend:/app
      - /app/node_modules
```

### Exercice 2.2 : Gestion des volumes et réseaux
```yaml
# Ajouter des volumes et réseaux
version: '3.8'
services:
  frontend:
    # ... configuration précédente ...
    networks:
      - frontend
    volumes:
      - frontend_data:/app/data

  backend:
    build: ./backend
    networks:
      - frontend
      - backend
    volumes:
      - backend_data:/app/data

volumes:
  frontend_data:
  backend_data:

networks:
  frontend:
  backend:
```

---

# Exercices (Suite)

## Module 3 : CI/CD

### Exercice 3.1 : Pipeline GitHub Actions
```yaml
# Créer un pipeline CI/CD
name: CI/CD Pipeline
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build and Test
        run: |
          docker-compose build
          docker-compose up -d
          npm test
```

### Exercice 3.2 : Déploiement automatique
```yaml
# Ajouter le déploiement
  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Deploy
        run: |
          ansible-playbook deploy.yml
```

---

# Exercices (Suite)

## Module 4 : Ansible

### Exercice 4.1 : Playbook de base
```yaml
# Créer un playbook pour l'installation
---
- name: Installation de Docker
  hosts: all
  become: yes
  tasks:
    - name: Installation des prérequis
      apt:
        name: "{{ packages }}"
        state: present
      vars:
        packages:
          - docker.io
          - docker-compose
```

### Exercice 4.2 : Déploiement d'application
```yaml
# Ajouter le déploiement
    - name: Déploiement de l'application
      docker_compose:
        project_src: "{{ app_path }}"
        files:
          - docker-compose.yml
        state: present
```

---

# Exercices (Suite)

## Module 5 : Sécurité

### Exercice 5.1 : Sécurisation des conteneurs
```yaml
# Ajouter des règles de sécurité
version: '3.8'
services:
  frontend:
    # ... configuration précédente ...
    security_opt:
      - no-new-privileges:true
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE
```

### Exercice 5.2 : Configuration SSL/TLS
```nginx
# Configurer Nginx avec SSL
server {
    listen 443 ssl;
    server_name example.com;
    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    # ... configuration supplémentaire ...
}
```

---

# Exercices (Suite)

## Module 6 : Avancé

### Exercice 6.1 : Optimisation des images
```dockerfile
# Optimiser une image Docker
FROM node:20-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
```

### Exercice 6.2 : Scaling et load balancing
```yaml
# Configurer le scaling
version: '3.8'
services:
  frontend:
    # ... configuration précédente ...
    deploy:
      replicas: 3
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
```

---

# Exercices pratiques

## Exercice 1 : Création d'un article
1. Créer un composant Angular pour l'édition d'articles
2. Implémenter le formulaire avec validation
3. Connecter au backend avec HttpClient
4. Gérer les erreurs et le feedback utilisateur

## Exercice 2 : Authentification
1. Créer un service d'authentification
2. Implémenter JWT dans le backend
3. Ajouter des guards de route
4. Gérer le refresh token

---

# Exercices pratiques (Suite)

## Exercice 3 : Gestion des médias
1. Créer un service de upload
2. Configurer le stockage des fichiers
3. Implémenter la prévisualisation
4. Gérer les permissions

## Exercice 4 : Recherche et filtrage
1. Implémenter la recherche côté frontend
2. Ajouter les filtres côté backend
3. Optimiser les requêtes MongoDB
4. Ajouter la pagination

---

# Exercices de déploiement

## Exercice 1 : Environnement de développement
1. Configurer Docker Compose pour le développement
2. Mettre en place les hot-reloads
3. Configurer les variables d'environnement
4. Ajouter les outils de debug

## Exercice 2 : Environnement de production
1. Configurer Nginx pour la production
2. Mettre en place SSL/TLS
3. Configurer les backups
4. Mettre en place le monitoring

---

# Exercices de monitoring

## Exercice 1 : Configuration de Prometheus
1. Installer et configurer Prometheus
2. Ajouter les exporters nécessaires
3. Configurer les alertes
4. Visualiser les métriques

## Exercice 2 : Configuration de Grafana
1. Installer et configurer Grafana
2. Créer des dashboards
3. Configurer les alertes
4. Mettre en place les notifications

---

# Exercices de sécurité

## Exercice 1 : Sécurisation de l'API
1. Implémenter rate limiting
2. Ajouter la validation des données
3. Mettre en place CORS
4. Configurer les headers de sécurité

## Exercice 2 : Sécurisation des conteneurs
1. Configurer les capabilities
2. Mettre en place les security contexts
3. Configurer les network policies
4. Implémenter la rotation des logs

---

# Exercices de maintenance

## Exercice 1 : Gestion des dépendances
1. Mettre à jour les dépendances
2. Gérer les vulnérabilités
3. Implémenter les tests de régression
4. Documenter les changements

## Exercice 2 : Sauvegarde et restauration
1. Configurer les backups automatiques
2. Implémenter la rotation des backups
3. Tester la restauration
4. Documenter les procédures 