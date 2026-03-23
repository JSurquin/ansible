---
layout: new-section
routeAlias: 'exercices-ansible'
---

<a name="EXERCICES_ANSIBLE" id="EXERCICES_ANSIBLE"></a>

# Exercices Ansible 🤖

### 3 niveaux progressifs alignés sur les exemples

Mettez en pratique ce que vous avez appris avec Nginx !

---

# 🎯 Vue d'ensemble des exercices

### Progression pédagogique

Les exercices suivent **exactement** la même logique que les exemples :

| Exercice | Basé sur | Concepts pratiqués |
|----------|----------|-------------------|
| 🟢 Simple | Exemple 1 | Inventaire + Playbook basique |
| 🟡 Intermédiaire | Exemple 2 | Variables + Templates Jinja2 |
| 🔴 Avancé | Exemple 3 + 4 | Rôles + Projet production |

**L'objectif** : Vous allez refaire les exemples vous-même, sans copier-coller !

---

# 📋 Prérequis pour tous les exercices

### Infrastructure de test

```bash
# 1. Démarrer le lab Docker (si pas déjà fait)
docker-compose -f docker-compose-lab.yml up -d

# 2. Vérifier que les containers sont up
docker ps | grep ansible-lab

# 3. Installer Ansible (si pas déjà fait)
pip3 install ansible

# 4. Créer votre dossier de travail
mkdir -p exercices-ansible
cd exercices-ansible
```

**💡 Rappel** : Les containers Docker simulent des serveurs Linux réels.

---

## 🟢 Exercice Niveau Simple

### Mission : Reproduire l'exemple 1 par vous-même

**Objectif** : Créer un playbook qui installe et configure Nginx sur un serveur web

**Ce que vous devez créer** :
1. Un fichier `inventory.yml` avec un serveur web
2. Un playbook `install-nginx.yml`
3. Installer Nginx
4. Démarrer le service
5. Afficher un message de confirmation

---

## 🟢 Consignes détaillées

### Étape 1 : Créer l'inventaire

Créez `inventory.yml` avec :
- Un serveur nommé `web01`
- `ansible_host: ansible-lab-web01`
- `ansible_connection: docker`
- `ansible_user: root`

### Étape 2 : Créer le playbook

Créez `install-nginx.yml` avec :
- Cible : `hosts: all`
- `become: true`
- Variables : `nginx_port: 80` et `server_name: web01`

---

## 🟢 Consignes détaillées (suite)

### Étape 3 : Les tâches à créer

Votre playbook doit contenir ces tâches :
1. Mettre à jour le cache APT
2. Installer le package nginx
3. Démarrer et activer le service nginx
4. Afficher un message avec les infos du serveur

**⏱️ Temps estimé** : 15-20 minutes

**🎯 Test** : `ansible-playbook -i inventory.yml install-nginx.yml`

---

## 🟢 Correction - Inventaire

```yaml
# inventory.yml
all:
  vars:
    ansible_connection: docker
    ansible_user: root
    ansible_python_interpreter: /usr/bin/python3

  hosts:
    web01:
      ansible_host: ansible-lab-web01
```

---

## 🟢 Correction - Playbook

```yaml
# install-nginx.yml
---
- name: Installation et configuration Nginx
  hosts: all
  become: true
  
  vars:
    nginx_port: 80
    server_name: web01
  
  tasks:
    - name: Mettre à jour le cache APT
      apt:
        update_cache: yes
        cache_valid_time: 3600
    
    - name: Installer Nginx
      apt:
        name: nginx
        state: present
```

---

## 🟢 Correction - Playbook (suite)

```yaml
    - name: Démarrer et activer Nginx
      service:
        name: nginx
        state: started
        enabled: yes
    
    - name: Afficher les informations
      debug:
        msg: |
          ✅ Nginx installé avec succès !
          🌐 Serveur: {{ server_name }}
          📍 Port: {{ nginx_port }}
          🔗 Container: {{ ansible_host }}
```

---

## 🟢 Test de l'exercice

```bash
# Exécuter le playbook
ansible-playbook -i inventory.yml install-nginx.yml

# Vérifier que Nginx fonctionne (avec service dans Docker)
docker exec ansible-lab-web01 service nginx status

# Tester la page par défaut
docker exec ansible-lab-web01 curl localhost
```

💡 **Note** : Dans les containers Docker, on utilise `service` au lieu de `systemctl`

**✅ Résultat attendu** : Nginx installé et fonctionnel !

---

## 🟡 Exercice Niveau Intermédiaire

### Mission : Variables + Templates (comme l'exemple 2)

**Objectif** : Déployer Nginx avec configuration personnalisée sur plusieurs serveurs

**Ce que vous devez créer** :
1. Inventaire avec 3 serveurs web (web01, web02, web03)
2. Fichier de variables `group_vars/all.yml`
3. Template `nginx.conf.j2`
4. Template `index.html.j2` personnalisé
5. Playbook avec handlers

---

## 🟡 Consignes détaillées

### Étape 1 : Structure du projet

Créez cette structure :
```
exercice-intermediate/
├── inventory.yml
├── group_vars/
│   └── all.yml
├── templates/
│   ├── nginx.conf.j2
│   └── index.html.j2
└── deploy.yml
```

---

## 🟡 Étape 2 : Inventaire multi-serveurs

Créez un inventaire avec :
- Un groupe `webservers`
- 3 serveurs : web01, web02, web03
- Tous pointent vers `ansible-lab-web01`, `ansible-lab-web02`, `ansible-lab-web03`

### Étape 3 : Variables

Dans `group_vars/all.yml`, définissez :
- `app_name`: Votre nom d'application
- `app_version`: "1.0.0"
- `app_environment`: "development"
- `nginx_config` avec port, worker_connections, client_max_body_size

---

## 🟡 Étape 4 : Templates à créer

### Template nginx.conf.j2

Doit contenir :
- Nombre de workers (variable)
- Configuration HTTP de base
- Virtual host avec port variable
- Location / qui sert /var/www/html
- Location /health pour health check

**💡 Astuce** : Inspirez-vous de l'exemple 2 !

---

## 🟡 Étape 5 : Template HTML

### Template index.html.j2

Créez une page HTML personnalisée avec :
- Titre : `{{ app_name }}`
- Affichage de la version
- Affichage de l'environnement
- Affichage du nom du serveur (inventory_hostname)
- Couleur de fond selon l'environnement

**Variables de couleur** :
- development: "#e3f2fd"
- staging: "#fff3e0"
- production: "#e8f5e8"

---

## 🟡 Étape 6 : Playbook avec handlers

Votre playbook `deploy.yml` doit :
1. Installer Nginx
2. Créer le répertoire web
3. Générer nginx.conf depuis le template
4. Générer index.html depuis le template
5. Démarrer Nginx
6. Notifier un handler "Redémarrer Nginx" si config change

**⏱️ Temps estimé** : 30-40 minutes

---

## 🟡 Correction - Inventaire

```yaml
# inventory.yml
all:
  vars:
    ansible_connection: docker
    ansible_user: root
    ansible_python_interpreter: /usr/bin/python3

  children:
    webservers:
      hosts:
        web01:
          ansible_host: ansible-lab-web01
        web02:
          ansible_host: ansible-lab-web02
        web03:
          ansible_host: ansible-lab-web03
```

---

## 🟡 Correction - Variables

```yaml
# group_vars/all.yml
---
app_name: "Mon Application Web"
app_version: "1.0.0"
app_environment: "development"

nginx_config:
  port: 80
  worker_connections: 1024
  client_max_body_size: "10m"

company:
  name: "Andromed"
  url: "https://www.andromed.fr"

env_colors:
  development: "#e3f2fd"
  staging: "#fff3e0"
  production: "#e8f5e8"
```

---

## 🟡 Correction - Template nginx.conf.j2

```nginx
# templates/nginx.conf.j2
user www-data;
worker_processes {{ ansible_processor_vcpus | default(2) }};
pid /run/nginx.pid;

events {
    worker_connections {{ nginx_config.worker_connections }};
}

http {
    sendfile on;
    tcp_nopush on;
    keepalive_timeout 65;
    client_max_body_size {{ nginx_config.client_max_body_size }};

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
```

---

## 🟡 Correction - nginx.conf.j2 (suite)

```nginx
    server {
        listen {{ nginx_config.port }};
        server_name {{ inventory_hostname }};

        root /var/www/html;
        index index.html;

        location / {
            try_files $uri $uri/ =404;
        }

        location /health {
            access_log off;
            return 200 "OK";
            add_header Content-Type text/plain;
        }
    }
}
```

---

## 🟡 Correction - Template index.html.j2

```html
<!-- templates/index.html.j2 -->
<!DOCTYPE html>
<html>
<head>
    <title>{{ app_name }}</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px;
            background-color: {{ env_colors[app_environment] }};
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            max-width: 600px;
            margin: 0 auto;
        }
```

---

## 🟡 Correction - index.html.j2 (suite)

```html
        h1 { color: #2196f3; }
        .info { margin: 20px 0; }
        .label { font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 {{ app_name }}</h1>
        <div class="info">
            <p><span class="label">Serveur:</span> {{ inventory_hostname }}</p>
            <p><span class="label">Version:</span> {{ app_version }}</p>
            <p><span class="label">Environnement:</span> {{ app_environment }}</p>
            <p><span class="label">Date:</span> {{ ansible_date_time.date }}</p>
        </div>
        <hr>
        <small>Déployé avec Ansible + {{ company.name }}</small>
    </div>
</body>
</html>
```

---

## 🟡 Correction - Playbook deploy.yml

```yaml
# deploy.yml
---
- name: Déploiement avec variables et templates
  hosts: webservers
  become: true
  
  tasks:
    - name: Installer Nginx
      apt:
        name: nginx
        state: present
        update_cache: yes
    
    - name: Créer le répertoire web
      file:
        path: /var/www/html
        state: directory
        owner: www-data
        group: www-data
        mode: '0755'
```

---

## 🟡 Correction - deploy.yml (suite)

```yaml
    - name: Configurer Nginx avec template
      template:
        src: templates/nginx.conf.j2
        dest: /etc/nginx/nginx.conf
        owner: root
        group: root
        mode: '0644'
        backup: yes
      notify: Redémarrer Nginx
    
    - name: Déployer la page HTML personnalisée
      template:
        src: templates/index.html.j2
        dest: /var/www/html/index.html
        owner: www-data
        group: www-data
        mode: '0644'
```

---

## 🟡 Correction - deploy.yml (fin)

```yaml
    - name: Démarrer Nginx
      service:
        name: nginx
        state: started
        enabled: yes
    
    - name: Afficher les informations
      debug:
        msg: |
          ✅ Déploiement terminé pour {{ inventory_hostname }}
          🌐 Application: {{ app_name }} v{{ app_version }}
          🏷️ Environnement: {{ app_environment }}
  
  handlers:
    - name: Redémarrer Nginx
      service:
        name: nginx
        state: restarted
```

---

## 🟡 Test de l'exercice

```bash
# Exécuter le playbook sur tous les serveurs
ansible-playbook -i inventory.yml deploy.yml

# Vérifier sur chaque serveur
docker exec ansible-lab-web01 curl localhost
docker exec ansible-lab-web02 curl localhost
docker exec ansible-lab-web03 curl localhost

# Tester le health check
docker exec ansible-lab-web01 curl localhost/health

# Test avec autre environnement
ansible-playbook -i inventory.yml deploy.yml -e app_environment=production
```

**✅ Résultat attendu** : 3 serveurs Nginx avec pages personnalisées !

---

## 🔴 Exercice Niveau Avancé

### Mission : Créer un rôle Nginx réutilisable

**Objectif** : Reproduire l'exemple 3 - Organisation professionnelle avec rôles

**Ce que vous devez créer** :
1. Structure de rôle complète pour Nginx
2. Variables par défaut
3. Templates modulaires
4. Handlers
5. Métadonnées
6. Support multi-vhosts

---

## 🔴 Étape 1 : Structure du projet

Créez cette structure complète :
```
exercice-avance/
├── inventory.yml
├── site.yml
├── group_vars/
│   └── all.yml
└── roles/
    └── nginx/
        ├── tasks/
        │   └── main.yml
        ├── handlers/
        │   └── main.yml
        ├── templates/
        │   ├── nginx.conf.j2
        │   └── vhost.conf.j2
        ├── defaults/
        │   └── main.yml
        └── meta/
            └── main.yml
```

---

## 🔴 Étape 2 : Defaults du rôle

Dans `roles/nginx/defaults/main.yml`, définissez :
- `nginx_user: www-data`
- `nginx_worker_processes: auto`
- `nginx_conf_path: /etc/nginx/nginx.conf`
- `nginx_vhost_path: /etc/nginx/sites-available`
- `nginx_vhost_enabled_path: /etc/nginx/sites-enabled`
- `nginx_remove_default_vhost: true`
- `nginx_service_state: started`
- `nginx_service_enabled: true`
- `nginx_vhosts: []` (liste vide par défaut)

---

## 🔴 Étape 3 : Tâches du rôle

Dans `roles/nginx/tasks/main.yml`, créez les tâches :
1. Mettre à jour le cache APT
2. Installer Nginx
3. Créer les répertoires nécessaires (boucle)
4. Générer nginx.conf depuis template
5. Supprimer le vhost par défaut (si `nginx_remove_default_vhost`)
6. Configurer les virtual hosts (boucle sur `nginx_vhosts`)
7. Activer les virtual hosts (liens symboliques)
8. Créer les répertoires web pour chaque vhost
9. Démarrer et activer Nginx

**💡 Utilisez les tags** : packages, config, vhosts, service

---

## 🔴 Étape 4 : Handlers

Dans `roles/nginx/handlers/main.yml` :
- Handler "Recharger Nginx" : `state: reloaded`
- Handler "Redémarrer Nginx" : `state: restarted`

### Étape 5 : Métadonnées

Dans `roles/nginx/meta/main.yml` :
- Informations Galaxy (author, description)
- Versions minimales (ansible_version: 2.9)
- Plateformes supportées (Ubuntu 20.04, 22.04)

---

## 🔴 Étape 6 : Templates

### Template nginx.conf.j2
Configuration globale de Nginx (similaire à l'intermédiaire)

### Template vhost.conf.j2
Configuration d'un virtual host :
```nginx
server {
    listen {{ item.port | default(80) }};
    server_name {{ item.server_name }};
    root {{ item.root }};
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

---

## 🔴 Étape 7 : Playbook principal

Dans `site.yml` :
```yaml
---
- name: Déploiement avec rôles
  hosts: webservers
  become: true
  
  vars:
    nginx_vhosts:
      - server_name: "{{ inventory_hostname }}"
        root: "/var/www/html"
        port: 80
  
  roles:
    - role: nginx
      tags: ['nginx', 'webserver']
```

**⏱️ Temps estimé** : 45-60 minutes

---

## 🔴 Correction - defaults/main.yml

```yaml
# roles/nginx/defaults/main.yml
---
# Configuration utilisateur et processus
nginx_user: www-data
nginx_worker_processes: auto

# Chemins de configuration
nginx_conf_path: /etc/nginx/nginx.conf
nginx_vhost_path: /etc/nginx/sites-available
nginx_vhost_enabled_path: /etc/nginx/sites-enabled

# Options de configuration
nginx_remove_default_vhost: true
nginx_worker_connections: 1024
nginx_client_max_body_size: "10m"

# Configuration du service
nginx_service_state: started
nginx_service_enabled: true

# Virtual hosts (vide par défaut)
nginx_vhosts: []
```

---

## 🔴 Correction - tasks/main.yml (partie 1)

```yaml
# roles/nginx/tasks/main.yml
---
- name: Mettre à jour le cache APT
  apt:
    update_cache: yes
    cache_valid_time: 3600
  tags: ['packages']

- name: Installer Nginx
  apt:
    name: nginx
    state: present
  tags: ['packages']

- name: Créer les répertoires nécessaires
  file:
    path: "{{ item }}"
    state: directory
    owner: "{{ nginx_user }}"
    group: "{{ nginx_user }}"
    mode: '0755'
  loop:
    - "{{ nginx_vhost_path }}"
    - "{{ nginx_vhost_enabled_path }}"
  tags: ['config']
```

---

## 🔴 Correction - tasks/main.yml (partie 2)

```yaml
- name: Configurer Nginx (nginx.conf)
  template:
    src: nginx.conf.j2
    dest: "{{ nginx_conf_path }}"
    owner: root
    group: root
    mode: '0644'
    validate: 'nginx -t -c %s'
  notify: Recharger Nginx
  tags: ['config']

- name: Supprimer le vhost par défaut
  file:
    path: "{{ nginx_vhost_enabled_path }}/default"
    state: absent
  when: nginx_remove_default_vhost
  notify: Recharger Nginx
  tags: ['config']
```

---

## 🔴 Correction - tasks/main.yml (partie 3)

```yaml
- name: Configurer les virtual hosts
  template:
    src: vhost.conf.j2
    dest: "{{ nginx_vhost_path }}/{{ item.server_name }}.conf"
    owner: root
    group: root
    mode: '0644'
  loop: "{{ nginx_vhosts }}"
  when: nginx_vhosts | length > 0
  notify: Recharger Nginx
  tags: ['config', 'vhosts']

- name: Activer les virtual hosts
  file:
    src: "{{ nginx_vhost_path }}/{{ item.server_name }}.conf"
    dest: "{{ nginx_vhost_enabled_path }}/{{ item.server_name }}.conf"
    state: link
  loop: "{{ nginx_vhosts }}"
  when: nginx_vhosts | length > 0
  notify: Recharger Nginx
  tags: ['config', 'vhosts']
```

---

## 🔴 Correction - tasks/main.yml (partie 4)

```yaml
- name: Créer les répertoires web
  file:
    path: "{{ item.root }}"
    state: directory
    owner: "{{ nginx_user }}"
    group: "{{ nginx_user }}"
    mode: '0755'
  loop: "{{ nginx_vhosts }}"
  when: nginx_vhosts | length > 0
  tags: ['config']

- name: Démarrer et activer Nginx
  service:
    name: nginx
    state: "{{ nginx_service_state }}"
    enabled: "{{ nginx_service_enabled }}"
  tags: ['service']
```

---

## 🔴 Correction - handlers/main.yml

```yaml
# roles/nginx/handlers/main.yml
---
- name: Recharger Nginx
  service:
    name: nginx
    state: reloaded

- name: Redémarrer Nginx
  service:
    name: nginx
    state: restarted
```

---

## 🔴 Correction - meta/main.yml

```yaml
# roles/nginx/meta/main.yml
---
dependencies: []

galaxy_info:
  author: "Votre Nom"
  description: "Rôle Ansible pour installer et configurer Nginx"
  company: "Andromed"
  license: "MIT"
  min_ansible_version: 2.9
  
  platforms:
    - name: Ubuntu
      versions:
        - focal
        - jammy
  
  galaxy_tags:
    - nginx
    - webserver
    - web
```

---

## 🔴 Correction - templates/nginx.conf.j2

```nginx
# roles/nginx/templates/nginx.conf.j2
user {{ nginx_user }};
worker_processes {{ nginx_worker_processes }};
pid /run/nginx.pid;

events {
    worker_connections {{ nginx_worker_connections }};
}

http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    client_max_body_size {{ nginx_client_max_body_size }};

    include /etc/nginx/mime.types;
    default_type application/octet-stream;
```

---

## 🔴 Correction - nginx.conf.j2 (suite)

```nginx
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    gzip on;
    gzip_disable "msie6";

    # Inclure tous les virtual hosts activés
    include {{ nginx_vhost_enabled_path }}/*;
}
```

---

## 🔴 Correction - templates/vhost.conf.j2

```nginx
# roles/nginx/templates/vhost.conf.j2
server {
    listen {{ item.port | default(80) }};
    server_name {{ item.server_name }};

    root {{ item.root }};
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }

    # Health check
    location /health {
        access_log off;
        return 200 "OK - {{ item.server_name }}";
        add_header Content-Type text/plain;
    }
}
```

---

## 🔴 Test de l'exercice

```bash
# Exécuter le playbook complet
ansible-playbook -i inventory.yml site.yml

# Exécuter seulement certains tags
ansible-playbook -i inventory.yml site.yml --tags "packages,config"

# Vérifier la configuration Nginx
ansible webservers -i inventory.yml -m shell -a "nginx -t"

# Tester les vhosts
docker exec ansible-lab-web01 curl localhost
docker exec ansible-lab-web01 curl localhost/health

# Lister les tasks du rôle
ansible-playbook -i inventory.yml site.yml --list-tasks
```

**✅ Résultat attendu** : Rôle Nginx professionnel et réutilisable !

---

## 🔴 Bonus : Projet Production Multi-Environnements

### Mission ultime : Reproduire l'exemple 4

**Objectif** : Structure production complète avec staging et production

**Structure à créer** :
```
projet-production/
├── ansible.cfg
├── site.yml
├── inventories/
│   ├── staging/hosts.yml
│   └── production/hosts.yml
├── group_vars/
│   ├── all.yml
│   ├── staging.yml
│   └── production.yml
├── roles/
│   └── nginx/  (le rôle créé avant)
└── secrets.yml (avec Vault)
```

---

## 🔴 Bonus - ansible.cfg

```ini
# ansible.cfg
[defaults]
inventory = inventories/staging/hosts.yml
roles_path = ./roles
host_key_checking = False
retry_files_enabled = False
callback_whitelist = timer, profile_tasks
stdout_callback = yaml
log_path = ./ansible.log

[ssh_connection]
pipelining = True
```

---

## 🔴 Bonus - Inventaires

```yaml
# inventories/staging/hosts.yml
all:
  vars:
    ansible_connection: docker
    ansible_user: root
    environment: staging
  
  children:
    webservers:
      hosts:
        web01:
          ansible_host: ansible-lab-web01
```

```yaml
# inventories/production/hosts.yml
all:
  vars:
    ansible_connection: docker
    ansible_user: root
    environment: production
  
  children:
    webservers:
      hosts:
        web01: {ansible_host: ansible-lab-web01}
        web02: {ansible_host: ansible-lab-web02}
        web03: {ansible_host: ansible-lab-web03}
```

---

## 🔴 Bonus - Variables par environnement

```yaml
# group_vars/staging.yml
---
app_environment: staging
nginx_worker_processes: 2
nginx_worker_connections: 512

nginx_vhosts:
  - server_name: staging.monapp.local
    root: /var/www/staging
    port: 80
```

```yaml
# group_vars/production.yml
---
app_environment: production
nginx_worker_processes: 4
nginx_worker_connections: 2048

nginx_vhosts:
  - server_name: www.monapp.com
    root: /var/www/production
    port: 80
```

---

## 🔴 Bonus - Utilisation de Vault

```bash
# Créer le fichier de secrets
ansible-vault create secrets.yml

# Contenu du secrets.yml
vault_ssl_cert_password: "mon_super_secret"
vault_admin_password: "password_admin_securise"

# Utiliser dans un playbook
ansible-playbook -i inventories/production site.yml --ask-vault-pass

# Éditer les secrets
ansible-vault edit secrets.yml

# Chiffrer un fichier existant
ansible-vault encrypt secrets.yml
```

---

## 🔴 Test du projet production

```bash
# Déploiement staging
ansible-playbook -i inventories/staging site.yml

# Déploiement production
ansible-playbook -i inventories/production site.yml

# Déploiement production avec Vault
ansible-playbook -i inventories/production site.yml --ask-vault-pass

# Dry-run avant déploiement
ansible-playbook -i inventories/production site.yml --check --diff

# Déploiement avec tags
ansible-playbook -i inventories/production site.yml --tags "config"
```

---

## 📊 Récapitulatif des exercices

### Compétences acquises

**🟢 Niveau Simple** :
- ✅ Créer un inventaire Ansible
- ✅ Écrire un playbook de base
- ✅ Utiliser les modules apt et service
- ✅ Déployer sur un serveur

**🟡 Niveau Intermédiaire** :
- ✅ Organiser les variables dans group_vars
- ✅ Créer des templates Jinja2
- ✅ Déployer sur plusieurs serveurs
- ✅ Utiliser les handlers

---

## 📊 Récapitulatif (suite)

**🔴 Niveau Avancé** :
- ✅ Créer un rôle Ansible complet
- ✅ Structure professionnelle
- ✅ Variables par défaut et métadonnées
- ✅ Templates modulaires
- ✅ Tags pour exécution sélective

**🔴 Bonus Production** :
- ✅ Multi-environnements (staging/prod)
- ✅ Configuration centralisée (ansible.cfg)
- ✅ Ansible Vault pour les secrets
- ✅ Organisation projet professionnel

---

## 🎯 Comparaison : Exemples vs Exercices

### Vous avez reproduit tous les exemples !

| Exemple | Exercice | Concepts |
|---------|----------|----------|
| 01-simple-playbook | 🟢 Simple | Playbook basique |
| 02-variables-templates | 🟡 Intermédiaire | Variables + Templates |
| 03-avec-roles | 🔴 Avancé | Rôles |
| 04-projet-production | 🔴 Bonus | Multi-env + Vault |

**💪 Bravo !** Vous maîtrisez maintenant Ansible de A à Z !

---

## 💡 Points clés à retenir

### Les fondamentaux

✅ **Inventaire** : Liste des serveurs à gérer
✅ **Playbook** : Ensemble de tâches à exécuter
✅ **Variables** : Personnalisation des déploiements
✅ **Templates** : Génération de fichiers dynamiques
✅ **Handlers** : Actions déclenchées par changements
✅ **Rôles** : Organisation modulaire et réutilisable
✅ **Tags** : Exécution sélective
✅ **Vault** : Chiffrement des secrets

---

## 🚀 Aller plus loin

### Prochaines étapes

**Améliorer vos rôles** :
- Ajouter des tests avec Molecule
- Publier sur Ansible Galaxy
- Ajouter le support SSL/TLS
- Gérer les certificats Let's Encrypt

**Intégrer dans CI/CD** :
- GitHub Actions + Ansible
- GitLab CI + Ansible
- Jenkins + Ansible

**Explorer** :
- AWX / Ansible Tower
- Ansible Operator pour Kubernetes
- Collections avancées (AWS, Azure, GCP)

---

## 🎉 Félicitations !

### Vous avez terminé les exercices Ansible !

Vous savez maintenant :
- 📋 Gérer un inventaire de serveurs
- 🎭 Écrire des playbooks efficaces
- 🔧 Utiliser variables et templates
- 📦 Créer des rôles réutilisables
- 🔐 Sécuriser vos secrets avec Vault
- 🚀 Organiser un projet production

**Prêt pour le QCM final ?** ✅
