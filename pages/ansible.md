---
layout: new-section
routeAlias: 'intro-ansible'
---

<a name="intro-ansible" id="intro-ansible"></a>

# Module 1 : Introduction à Ansible

---

# Ansible - Automatisation Infrastructure 🎯

### Infrastructure as Code moderne et simple

Ansible est l'outil d'automatisation de référence : **sans agent, idempotent, déclaratif**.

> l'idempotence signifie qu'une opération a le même effet qu'on l'applique une ou plusieurs fois.

---

# Ansible - Perfect pour Docker

### Pourquoi Ansible + Docker ?

Parfait pour orchestrer Docker et automatiser l'infrastructure.

Exemple concret : Automatiser le déploiement d’une app Dockerisée sur plusieurs serveurs en une seule commande, sans se connecter manuellement à chaque machine, pour installer Docker, copier le code, builder l’image, lancer le conteneur, et gérer les mises à jour ou redémarrages.

---

# Pourquoi Ansible ? 💡

### Les avantages clés

🎯 **Simple** : Configuration YAML lisible

🔄 **Idempotent** : Même résultat à chaque exécution

🚀 **Sans agent** : SSH/WinRM/API uniquement

---

# Pourquoi Ansible ? (suite) 💡

### Plus d'avantages

📈 **Scalable** : De 1 à 10,000+ serveurs

🔒 **Sécurisé** : Utilise vos connexions existantes

---
layout: new-section
routeAlias: 'installation-setup'
---

<a name="installation-setup" id="installation-setup"></a>

# Module 2 : Installation et Setup 2025

---

# Installation et setup 2025 ⚙️

### Installation rapide

```bash
# Installation via pip (recommandé)
python3 -m pip install --user ansible
# Collections essentielles
# community.general : collection avec plein de modules pour gérer fichiers, paquets, services, réseau, clouds, etc.
# ansible.posix : modules spécifiques POSIX/Linux comme gestion utilisateurs, groupes, permissions, tâches cron, commandes système.
# ansible.windows : modules spécifiques Windows comme gestion services, tâches planifiées, partage de fichiers.
ansible-galaxy collection install community.general ansible.posix
# Vérification
ansible --version
```

> Si vous avez : Nothing to do. All requested collections are already installed. If you want to reinstall them, consider using `--force`.

<br/>

> Cela veut dire que vous avez déjà installé les collections ou que vous avez déjà installé ansible qui les comporte maintenant par défaut.

---

# Installation Windows

```bash
# Si Windows et pas de python :
# Installer python via chocolatey
choco install python
# Installer ansible via pip
python3 -m pip install --user ansible
# Vérification
ansible --version
```

---

# Solution environnement virtuel

Si vous avez un problème d'installation, voici une solution :

> Sur python 3 vous devez mettre en place un venv :

```bash
python3 -m venv .venv
source .venv/bin/activate
pip3 install ansible
```

> Cela créer un environnement virtuel avec ansible installé dedans. (mode sandbox par défaut de python 3 pour ne pas polluer votre environnement global)

---

# Fonctionnement d'Ansible

Pour bien comprendre schématiquement le fonctionnement d'ansible, voici un schéma :

```mermaid
flowchart TD
    ah[ansible_host]
    ah_ansible[ansible_installed]
    ah_docker[community.docker_collection]
    ah --> ah_ansible --> ah_docker

    ah -->|SSH + playbook| st1
    ah -->|SSH + playbook| st2
    ah -->|SSH + playbook| st3

    subgraph Server_Target_1 [server_target_1]
        st1_docker[docker_installed]
        st1_containers[containers_managed]
        st1 --> st1_docker --> st1_containers
    end

    subgraph Server_Target_2 [server_target_2]
        st2_docker[docker_installed]
        st2_containers[containers_managed]
        st2 --> st2_docker --> st2_containers
    end

    subgraph Server_Target_3 [server_target_3]
        st3_docker[docker_installed]
        st3_containers[containers_managed]
        st3 --> st3_docker --> st3_containers
    end

    style ah fill:#e91e63,stroke:#c2185b,stroke-width:3px,color:#fff
    style ah_ansible fill:#9c27b0,stroke:#7b1fa2,stroke-width:2px,color:#fff
    style ah_docker fill:#673ab7,stroke:#512da8,stroke-width:2px,color:#fff
    style Server_Target_1 fill:#e3f2fd,stroke:#2196f3,stroke-width:2px
    style Server_Target_2 fill:#e8f5e9,stroke:#4caf50,stroke-width:2px
    style Server_Target_3 fill:#fff3e0,stroke:#ff9800,stroke-width:2px
    style st1_docker fill:#42a5f5,stroke:#1976d2,stroke-width:2px,color:#fff
    style st1_containers fill:#64b5f6,stroke:#1976d2,stroke-width:2px,color:#fff
    style st2_docker fill:#66bb6a,stroke:#388e3c,stroke-width:2px,color:#fff
    style st2_containers fill:#81c784,stroke:#388e3c,stroke-width:2px,color:#fff
    style st3_docker fill:#ffa726,stroke:#f57c00,stroke-width:2px,color:#fff
    style st3_containers fill:#ffb74d,stroke:#f57c00,stroke-width:2px,color:#fff
```

---

Vous pouvez avoir plusieurs buts à l'utilisation d'ansible :

- Vous voulez automatiser des tâches répétitives (installation de paquets, configuration de services, etc.)
- Vous voulez déployer des applications sur plusieurs serveurs
- Vous voulez configurer des serveurs de manière uniforme
- Vous voulez gérer des secrets de manière sécurisée

---
layout: new-section
routeAlias: 'ci-cd-integration'
---

<a name="ci-cd-integration" id="ci-cd-integration"></a>

# Module 3 : Intégration CI/CD

---

# Intégration d’Ansible dans un workflow CI/CD

## Option 1 — Utilisation avec GitHub Actions

<br/>

> Il est tout à fait possible d’intégrer Ansible dans un pipeline GitHub Actions afin d’automatiser le déploiement à chaque git push.
Deux approches sont possibles :

- Exécution distante : GitHub Actions peut se connecter en SSH à un serveur (via une clé privée stockée dans les secrets) pour exécuter un ansible-playbook depuis ce serveur.
- Runner auto-hébergé : Vous pouvez utiliser un runner GitHub hébergé sur un serveur interne, avec Ansible installé, afin de lancer localement les déploiements via les playbooks.

>💡 Attention : dans ce modèle, Ansible ne copie pas directement le code applicatif. Le code est packagé dans une image Docker (via GitHub Actions), poussée vers un registry (comme GHCR), puis Ansible se charge uniquement de récupérer et d’exécuter cette image sur les serveurs cibles (docker pull, docker_container…).

---

```mermaid
flowchart LR
    dev["👨‍💻 Développeur<br/>git push code"]
    ci["🔄 GitHub Actions<br/>CI Pipeline"]
    img["🐳 Docker Build<br/>docker build -t app:v1.0"]
    reg["📦 GHCR Registry<br/>docker push ghcr.io/user/app:v1.0"]
    ssh["🔐 SSH Connection<br/>ansible-host via private key"]
    ans["🎯 Ansible Playbook<br/>ansible-playbook deploy.yml"]
    
    dev --> ci
    ci --> img
    img --> reg
    reg --> ssh
    ssh --> ans

    subgraph "🖥️ Ansible Control Node"
        ans --> playbook["📄 Playbook Tasks:<br/>• docker pull image<br/>• stop old container<br/>• start new container<br/>• health check"]
    end

    subgraph "🌐 Production Servers"
        srv1["🖥️ Server 1<br/>docker pull & run"]
        srv2["🖥️ Server 2<br/>docker pull & run"] 
        srv3["🖥️ Server 3<br/>docker pull & run"]
    end

    playbook --> srv1
    playbook --> srv2
    playbook --> srv3

    style dev fill:#9c27b0,stroke:#7b1fa2,stroke-width:3px,color:#fff
    style ci fill:#2196f3,stroke:#1976d2,stroke-width:3px,color:#fff
    style img fill:#00bcd4,stroke:#0097a7,stroke-width:3px,color:#fff
    style reg fill:#009688,stroke:#00796b,stroke-width:3px,color:#fff
    style ssh fill:#ff9800,stroke:#f57c00,stroke-width:3px,color:#fff
    style ans fill:#e91e63,stroke:#c2185b,stroke-width:3px,color:#fff
    style playbook fill:#673ab7,stroke:#512da8,stroke-width:2px,color:#fff
    style srv1 fill:#4caf50,stroke:#388e3c,stroke-width:2px,color:#fff
    style srv2 fill:#66bb6a,stroke:#388e3c,stroke-width:2px,color:#fff
    style srv3 fill:#81c784,stroke:#388e3c,stroke-width:2px,color:#fff
```

---

## 🧩 Option 2 — Intégration avec GitLab CI/CD

GitLab permet un fonctionnement similaire :

- Le pipeline CI build l’image Docker de votre application.
- Cette image est poussée automatiquement vers le GitLab Container Registry.
- Ensuite, plusieurs options sont possibles :
- Exécution Ansible depuis le pipeline, si le runner dispose d’Ansible.
- Connexion SSH à un hôte distant pour exécuter un playbook.

- Déclenchement via webhook d’un outil externe tel que Jenkins, qui se chargera lui-même de lancer Ansible.

---

```mermaid
flowchart LR
    dev["👨‍💻 Développeur<br/>git push code"]
    ci["🦊 GitLab CI/CD<br/>Pipeline Runner"]
    img["🐳 Docker Build<br/>docker build -t app:latest"]
    reg["📦 GitLab Registry<br/>registry.gitlab.com/project/app"]
    webhook["🔔 Webhook/SSH<br/>Trigger deployment"]
    ans["🎯 Ansible Execution<br/>ansible-playbook site.yml"]
    
    dev --> ci
    ci --> img
    img --> reg
    reg --> webhook
    webhook --> ans

    subgraph "🖥️ Ansible Control Node"
        ans --> inventory["📋 Inventory Check<br/>• production servers<br/>• staging servers"]
        inventory --> tasks["📄 Deployment Tasks:<br/>• login to registry<br/>• pull new image<br/>• rolling update<br/>• rollback if failed"]
    end

    subgraph "🌐 Target Infrastructure"
        prod1["🖥️ Production 1<br/>app:latest running"]
        prod2["🖥️ Production 2<br/>app:latest running"]
        stage1["🔧 Staging<br/>testing environment"]
    end

    tasks --> stage1
    stage1 --> prod1
    stage1 --> prod2
    
    subgraph "📊 Monitoring"
        health["❤️ Health Checks<br/>• container status<br/>• application metrics<br/>• logs monitoring"]
    end
    
    prod1 --> health
    prod2 --> health

    style dev fill:#9c27b0,stroke:#7b1fa2,stroke-width:3px,color:#fff
    style ci fill:#fc6d26,stroke:#e24329,stroke-width:3px,color:#fff
    style img fill:#00bcd4,stroke:#0097a7,stroke-width:3px,color:#fff
    style reg fill:#fc6d26,stroke:#e24329,stroke-width:3px,color:#fff
    style webhook fill:#ff9800,stroke:#f57c00,stroke-width:3px,color:#fff
    style ans fill:#e91e63,stroke:#c2185b,stroke-width:3px,color:#fff
    style inventory fill:#673ab7,stroke:#512da8,stroke-width:2px,color:#fff
    style tasks fill:#3f51b5,stroke:#303f9f,stroke-width:2px,color:#fff
    style prod1 fill:#4caf50,stroke:#388e3c,stroke-width:2px,color:#fff
    style prod2 fill:#66bb6a,stroke:#388e3c,stroke-width:2px,color:#fff
    style stage1 fill:#ffeb3b,stroke:#fbc02d,stroke-width:2px,color:#000
    style health fill:#f44336,stroke:#d32f2f,stroke-width:2px,color:#fff
```

---
layout: new-section
routeAlias: 'inventaires'
---

<a name="inventaires" id="inventaires"></a>

# Module 4 : Inventaires et serveurs

---

# Qu'est-ce qu'un Inventaire ? 📋

### Le carnet d'adresses de vos serveurs

L'**inventaire** est un fichier qui liste tous vos serveurs et leurs informations :

- 📍 **Adresses IP** : Où sont vos serveurs

- 👥 **Groupes** : Organiser par fonction (web, base de données...)

- ⚙️ **Variables** : Configuration spécifique à chaque serveur

- 🔑 **Connexion** : Comment se connecter (utilisateur, clés SSH...)

**Analogie** : C'est comme un carnet d'adresses pour vos serveurs !

---

# Inventaire : Définir vos serveurs 📋

```yaml
# inventory/hosts.yml - Fichier d'inventaire principal
all:  # Groupe racine qui contient TOUS les serveurs
  vars:  # Variables globales applicables à tous les serveurs
    ansible_user: ubuntu  # Utilisateur par défaut pour se connecter via SSH
    ansible_python_interpreter: /usr/bin/python3  # Chemin vers Python sur les serveurs cibles

  children:  # Sous-groupes organisés par fonction
    docker_hosts:  # Groupe des serveurs qui hébergent Docker
      hosts:  # Liste des serveurs dans ce groupe
        docker-01: {ansible_host: 10.0.1.10}  # Nom logique : adresse IP réelle
        docker-02: {ansible_host: 10.0.1.11}  # Deuxième serveur Docker

    databases:  # Groupe des serveurs de base de données
      hosts:  # Serveurs de BDD
        db-01: {ansible_host: 10.0.1.20}  # Serveur de base de données principal

    webservers:  # Groupe des serveurs web (déclaration vide ici)
databases:  # Redéfinition du groupe databases (peut créer confusion)
  hosts:  # Liste des serveurs de BDD
    db-01: {ansible_host: 10.0.1.20}  # Même serveur que plus haut

webservers:  # Définition du groupe webservers
  hosts:  # Serveurs web avec notation de plage
    web-[01:03]: {ansible_host: '10.0.1.{{ 30 + item }}'}  # Génère web-01, web-02, web-03 avec IPs 10.0.1.31, 10.0.1.32, 10.0.1.33
```

---

# Un inventaire déjà fait pour vous en local pour s'entraîner

```yaml
all:
  children:
    local:
      hosts:
        localhost:
          ansible_connection: local
          ansible_python_interpreter: /usr/bin/python3
```

```bash
ansible-inventory --graph
```

Vous aurez un graphique qui ressemblera à ça :

```bash
@all:
  |--ungrouped: # logique, vous n'avez rien qui n'est pas dans un groupe, donc ungrouped est vide
  |--@local:
  |  |--localhost
```

---

# ✅ Inventory : Nom vs Adresse

### Différence critique

```yaml
all:
  children:
    webservers:
      hosts:
        web-01:  # ⚠️ CECI EST LE NOM (alias logique)
          ansible_host: 10.0.1.10  # ⚠️ CECI EST L'ADRESSE RÉELLE
```

**Dans vos playbooks, vous utilisez le NOM, pas l'adresse !**

---

# Inventory : Utilisation du nom

```yaml
# ✅ CORRECT : Utiliser le nom défini dans l'inventory
- name: Déployer sur un serveur spécifique
  hosts: web-01  # Le nom logique
  tasks:
    - debug: msg="Je suis sur {{ inventory_hostname }}"
    # Affiche : "Je suis sur web-01"
```

```yaml
# ❌ INCORRECT : Utiliser l'IP directement
- name: Déployer
  hosts: 10.0.1.10  # ❌ Ansible ne trouvera pas ce host
```

---

# 🧠 Règle à retenir : Inventory

> **Nom = Ce que vous utilisez dans vos playbooks**
> 
> **ansible_host = Où Ansible se connecte vraiment**

Avantage : Vous pouvez changer l'IP sans toucher aux playbooks !

```yaml
# Avant
web-01: {ansible_host: 10.0.1.10}

# Après migration vers nouveau serveur
web-01: {ansible_host: 192.168.50.10}
# ✅ Vos playbooks fonctionnent toujours sans modification !
```

---
layout: new-section
routeAlias: 'playbooks'
---

<a name="playbooks" id="playbooks"></a>

# Module 5 : Playbooks

---

# Qu'est-ce qu'un Playbook ? 🎭

### La recette de cuisine pour vos serveurs

Un **playbook** est un fichier qui décrit les actions à effectuer :

- 📝 **Recette** : Suite d'étapes ordonnées

- 🎯 **Cibles** : Sur quels serveurs agir

- 🔧 **Tâches** : Quoi installer, configurer, démarrer

- 🎭 **Rôles** : Qui fait quoi (utilisateur admin ou normal)

**Analogie** : C'est comme une recette de cuisine, mais pour configurer vos serveurs !

---

# Premier playbook 🎭

```yaml
- name: Configuration serveurs Docker
  hosts: local
  become: true
  vars:
    docker_compose_version: '2.24.0'
    ansible_ssh_public_key: "{{ lookup('file', '~/.ssh/id_rsa.pub') }}"

  tasks:
    - name: Installation Docker
      apt:
        name:
          - docker.io
        state: present
        update_cache: true

    - name: Creer utilisateur ansible
      user:
        name: ansible
        groups: sudo,docker
        append: true
        shell: /bin/bash
        create_home: true

    - name: Creer le dossier .ssh
      file:
        path: /home/ansible/.ssh
        state: directory
        owner: ansible
        group: ansible
        mode: '0700'

    - name: Copier la clef publique dans authorized_keys
      copy:
        content: "{{ ansible_ssh_public_key }}"
        dest: /home/ansible/.ssh/authorized_keys
        owner: ansible
        group: ansible
        mode: '0600'

    - name: Creer le dossier /etc/sudoers.d si absent
      file:
        path: /etc/sudoers.d
        state: directory
        owner: root
        group: root
        mode: '0750'

    - name: Ajouter sudo sans mot de passe pour ansible
      copy:
        dest: /etc/sudoers.d/ansible
        content: "ansible ALL=(ALL) NOPASSWD: ALL\n"
        mode: '0440'

    - name: Demarrage et activation Docker
      systemd:
        name: docker
        state: started
        enabled: true
      when: ansible_facts.virtualization_type != "docker"
```

---

# ✅ become : Les privilèges sudo

### Comprendre `become: true`

```yaml
- name: Installer un package
  hosts: webservers
  become: true  # ⚠️ Exécuter avec sudo (root)
  tasks:
    - apt:
        name: nginx
        state: present
```

**Sans `become: true`** : Ansible se connecte avec votre utilisateur normal.

**Avec `become: true`** : Ansible exécute les commandes avec `sudo` (comme root).

---

# become : Quand l'utiliser ?

### Actions nécessitant les droits root

**Nécessite `become: true`** ✅
- Installer des packages (`apt`, `yum`)
- Modifier des fichiers système (`/etc/`)
- Gérer des services (`systemd`)
- Créer des utilisateurs
- Modifier les permissions système

---

**Ne nécessite PAS `become: true`** ❌
- Créer des fichiers dans `/home/user/`
- Lire des fichiers accessibles
- Exécuter des commandes utilisateur
- Manipuler des fichiers de l'utilisateur

---

# become : Niveaux de granularité

### Global vs par tâche

```yaml
# Global : Toutes les tâches avec sudo
- hosts: web
  become: true  # ✅ Appliqué à TOUTES les tâches
  tasks:
    - apt: name=nginx state=present
    - file: path=/tmp/test state=touch
```

```yaml
# Par tâche : Seulement certaines tâches
- hosts: web
  tasks:
    - apt: name=nginx state=present
      become: true  # ✅ Seulement cette tâche
    
    - file: path=/home/user/file state=touch
      # Pas de sudo ici
```

---

# ❌ Erreur courante : Oublier become

```yaml
- name: Installer nginx
  hosts: web
  tasks:
    - apt: name=nginx state=present
      # ❌ ERREUR : Permission denied !
```

**Message d'erreur typique** :
```
Failed to lock apt for exclusive operation
```

**Solution** : Ajouter `become: true`

---

# 🧠 Règle à retenir : become

> **`become: true` = sudo = droits root**

Si la commande nécessite `sudo` en ligne de commande, elle nécessite `become: true` dans Ansible !

---

# Exécution du playbook

```bash
# Exécution
ansible-playbook -i inventory/hosts.yml deploy.yml
```

---

# ✅ Comprendre `state` dans les modules

### Le paramètre le plus important !

```yaml
# Packages
- apt:
    name: nginx
    state: present  # ⚠️ Installé (mais pas forcément démarré)
```

```yaml
# Services
- systemd:
    name: nginx
    state: started  # ⚠️ Démarré (mais pas forcément installé avant)
```

**Important** : `state` a des valeurs différentes selon le module !

---

# state : Modules de packages

### apt, yum, dnf, package

| State | Signification |
|-------|---------------|
| `present` | Package installé (version quelconque) |
| `absent` | Package désinstallé |
| `latest` | Package installé à la dernière version |

```yaml
# ✅ Installer nginx
- apt: name=nginx state=present

# ✅ Désinstaller nginx
- apt: name=nginx state=absent

# ✅ Mettre à jour vers la dernière version
- apt: name=nginx state=latest
```

---

# state : Modules de services

### systemd, service

| State | Signification |
|-------|---------------|
| `started` | Service démarré |
| `stopped` | Service arrêté |
| `restarted` | Service redémarré |
| `reloaded` | Configuration rechargée (sans redémarrage complet) |

```yaml
# ✅ Démarrer nginx
- systemd: name=nginx state=started

# ✅ Arrêter nginx
- systemd: name=nginx state=stopped

# ✅ Redémarrer nginx
- systemd: name=nginx state=restarted
```

---

# state : Modules de fichiers/dossiers

### file, copy, template

| State | Signification |
|-------|---------------|
| `file` | Fichier existe (ne crée pas) |
| `directory` | Dossier existe (crée si besoin) |
| `absent` | Fichier/dossier supprimé |
| `touch` | Fichier vide créé (comme `touch`) |
| `link` | Lien symbolique |

```yaml
# ✅ Créer un dossier
- file: path=/opt/app state=directory

# ✅ Supprimer un fichier
- file: path=/tmp/old.txt state=absent
```

---

# state : Modules Docker

### community.docker.docker_container

| State | Signification |
|-------|---------------|
| `started` | Container lancé |
| `stopped` | Container arrêté |
| `absent` | Container supprimé |
| `present` | Container créé (mais pas démarré) |

```yaml
# ✅ Lancer un container
- community.docker.docker_container:
    name: webapp
    image: nginx
    state: started
```

---

# ❌ Erreur courante : Confusion de state

```yaml
# ❌ ERREUR : state=started n'existe pas pour apt !
- apt:
    name: nginx
    state: started  # ❌ InvalidArgumentError
```

```yaml
# ✅ CORRECT : Deux tâches distinctes
- apt: name=nginx state=present  # 1. Installer
- systemd: name=nginx state=started  # 2. Démarrer
```

---

# 🧠 Règle à retenir : state

> **Chaque module a ses propres valeurs de `state`**

Vérifiez toujours la documentation du module :
```bash
ansible-doc apt
ansible-doc systemd
ansible-doc file
```

---
layout: new-section
routeAlias: 'modules'
---

<a name="modules" id="modules"></a>

# Module 6 : Modules essentiels

---

# Qu'est-ce qu'un Module ? 📦

### Les outils prêts à l'emploi

Un **module** est une fonction prête à utiliser dans Ansible :

- 🛠️ **Outil spécialisé** : Une action précise (installer, copier, démarrer...)

- 🎛️ **Paramètres** : Options pour personnaliser l'action

- ✅ **Idempotent** : Peut être exécuté plusieurs fois sans problème

- 📚 **Bibliothèque** : Des centaines de modules disponibles

**Analogie** : C'est comme avoir une boîte à outils avec chaque outil pour une tâche précise !

---

# Modules essentiels 📦

### Les modules indispensables pour Docker/Infrastructure

```yaml
# Gestion des packages
- name: Installation packages
  apt:
    name: [nginx, git, docker.io, python3-pip]
    state: present
```

---

# Modules : Fichiers et templates

```yaml
# Gestion des fichiers/templates
- name: Configuration nginx
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
    backup: true
  notify: restart nginx
```

---

# Modules : Commandes et scripts

```yaml
# Commandes et scripts
- name: Build application
  shell: |
    cd /opt/app
    docker build -t myapp:{{ app_version }} .
  changed_when: true
```

---

# Modules : Containers Docker

```yaml
# Gestion des containers Docker
- name: Lancer container webapp
  community.docker.docker_container:
    name: webapp
    image: 'myapp:{{ app_version }}'
    ports:
      - '80:8080'
    state: started
    restart_policy: always
```

---
layout: new-section
routeAlias: 'variables'
---

<a name="variables" id="variables"></a>

# Module 7 : Variables

---

# Qu'est-ce qu'une Variable ? 🔧

### Les données personnalisables

Une **variable** permet de personnaliser vos playbooks :

- 📊 **Données** : Valeurs réutilisables (version, nom, chemin...)

- 🎯 **Flexibilité** : Même playbook pour différents environnements

- 🔄 **Réutilisabilité** : Évite la duplication de code

- 🌍 **Environnements** : Dev, test, production avec des valeurs différentes

**Analogie** : C'est comme des champs à remplir dans un formulaire !

---

# Variables et templates 🔧

### Configuration dynamique

```yaml
# group_vars/all.yml
app_version: 'v1.2.0'
db_password: '{{ vault_db_password }}'
nginx_worker_processes: '{{ ansible_processor_vcpus }}'
```

---

# Variables par environnement

```yaml
# Variables par environnement
environments:
  dev:
    domain: 'dev.myapp.com'
    replicas: 1
  prod:
    domain: 'myapp.com'
    replicas: 3
```

---
layout: new-section
routeAlias: 'templates'
---

<a name="templates" id="templates"></a>

# Module 8 : Templates Jinja2

---

# Qu'est-ce qu'un Template ? 📄

### Les fichiers configurables automatiquement

Un **template** est un fichier modèle avec des variables :

- 📄 **Modèle** : Fichier avec des zones à remplir automatiquement

- 🔧 **Variables** : Placeholders remplacés par des vraies valeurs

- 🎯 **Génération** : Crée des fichiers personnalisés pour chaque serveur

- ⚙️ **Configuration** : Fichiers de config adaptés à chaque environnement

**Analogie** : C'est comme un document Word avec des champs à compléter automatiquement !

---

# Template : Exemple concret 📄

### De la théorie à la pratique

**Situation** : Vous devez configurer une application web sur 10 serveurs différents, chacun avec son IP et sa configuration spécifique.

**Sans template** : 10 fichiers de config différents à maintenir manuellement 😰

**Avec template** : 1 seul fichier modèle + variables = 10 configs générées automatiquement ! 🎉

---

# Template : Exemple simple 📄

### Fichier de configuration d'application

```bash
{# templates/app.conf.j2 - Le template (modèle) #}
# Configuration pour {{ inventory_hostname }}
server_name={{ inventory_hostname }}
server_ip={{ ansible_default_ipv4.address }}
database_host={{ db_host }}
database_port={{ db_port | default(5432) }}
debug_mode={{ debug | default('false') }}

# Génération conditionnelle
{% if environment == 'production' %}
log_level=ERROR
{% else %}
log_level=DEBUG
{% endif %}
```

---

# Template : Résultat généré 📄

### Ce que produit le template sur le serveur web-01

```bash
# Configuration pour web-01
server_name=web-01
server_ip=10.0.1.31
database_host=db-01.mondomaine.com
database_port=5432
debug_mode=false

# Génération conditionnelle
log_level=ERROR
```

**🎯 Magie** : Même template → Configs différentes selon le serveur !

---

# Template nginx avancé

```bash
{# templates/nginx.conf.j2 #}
worker_processes {{ nginx_worker_processes }};
# On peut utiliser des boucles pour générer des fichiers de config dynamiquement
upstream app {
# autant de x le nombre de replicas dans le ".env" alors on fais l'action
# (si replicas = 3 => on écrira dans la conf de nginx 3 x la commande server app-)
{% for i in range(environments[env].replicas) %}
    server app-{{ i+1 }}:8080;
{% endfor %}
}
```

---

# Template nginx (suite)

```bash
server {
    server_name {{ environments[env].domain }};
    
    location / {
        proxy_pass http://app;
    }
}
```

---

# Template : Syntaxe Jinja2 📄

### Les éléments essentiels à retenir

```bash
{# Ceci est un commentaire (ne sera pas dans le fichier final) #}

{{ variable }}                    # Affiche la valeur d'une variable
{{ variable | default('valeur') }} # Valeur par défaut si variable vide
{{ ansible_hostname }}            # Variable automatique d'Ansible

{% if condition %}                # Structure conditionnelle
  contenu si vrai
{% else %}
  contenu si faux
{% endif %}

{% for item in liste %}           # Boucle
  traiter {{ item }}
{% endfor %}
```

**💡 Astuce** : Les templates utilisent l'extension `.j2` (pour Jinja2)

---

# ✅ Template : Extension et chemins

### Comprendre .j2 et les chemins

```yaml
- name: Déployer config nginx
  template:
    src: nginx.conf.j2  # ⚠️ Fichier LOCAL (sur votre machine Ansible)
    dest: /etc/nginx/nginx.conf  # ⚠️ Fichier DISTANT (sur le serveur cible)
```

**Important** :
- `src` : Cherche dans `templates/` par défaut
- `dest` : Chemin absolu sur le serveur distant
- `.j2` : Extension pour Jinja2 (le moteur de template)

---

# Template : Où Ansible cherche le fichier source

### Ordre de recherche automatique

```
Quand vous faites : src: nginx.conf.j2

Ansible cherche dans cet ordre :
1. templates/nginx.conf.j2  ✅ (dans votre playbook)
2. roles/ROLE_NAME/templates/nginx.conf.j2  ✅ (si dans un rôle)
```

Vous n'avez PAS besoin d'écrire `templates/nginx.conf.j2` !

---

# ❌ Erreurs courantes avec les templates

```yaml
# ❌ ERREUR : Mettre le chemin complet local
- template:
    src: /home/user/ansible/templates/nginx.conf.j2
    # Ansible cherche déjà dans templates/ !

# ✅ CORRECT : Juste le nom du fichier
- template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
```

```yaml
# ❌ ERREUR : Oublier le chemin absolu pour dest
- template:
    src: app.conf.j2
    dest: app.conf  # ⚠️ Où ça ? Ansible ne sait pas !

# ✅ CORRECT : Chemin absolu complet
- template:
    src: app.conf.j2
    dest: /etc/app/app.conf
```

---

# 🧠 Règle à retenir : Templates

> **`src` = relatif au dossier templates/ (automatique)**
> 
> **`dest` = chemin ABSOLU sur le serveur distant**

L'extension `.j2` n'est qu'une convention, pas une obligation !

---
layout: new-section
routeAlias: 'handlers'
---

<a name="handlers" id="handlers"></a>

# Module 9 : Handlers

---

# Qu'est-ce qu'un Handler ? 🎯

### Les actions déclenchées automatiquement

Un **handler** est une tâche qui se déclenche uniquement si nécessaire :

- 🔔 **Réaction** : Se déclenche quand quelque chose change

- ⚡ **Efficacité** : Évite les redémarrages inutiles

- 🎯 **Précision** : Action ciblée (redémarrer service, recharger config...)

- 🔄 **Idempotence** : Ne s'exécute que si vraiment nécessaire

**Analogie** : C'est comme un système d'alarme qui ne sonne que s'il y a un problème !

---

# Handlers et conditions 🎯

### Réactivité et logique

```yaml
tasks:
  - name: Configuration Docker daemon
    template:
      src: daemon.json.j2
      dest: /etc/docker/daemon.json
    notify: restart docker
    when: configure_docker_daemon | default(false)
```

---

# Handlers : Déploiement multi-réplicas

```yaml
- name: Déploiement app selon environnement
  community.docker.docker_container:
    name: 'webapp-{{ item }}'
    image: 'myapp:{{ app_version }}'
    ports:
      - '{{ 8080 + item }}:8080'
    env:
      ENV: '{{ env }}'
      REPLICA: '{{ item }}'
  loop: '{{ range(1, environments[env].replicas + 1) | list }}'
```

---

# Handlers : Définition

```yaml
handlers:
  - name: restart docker
    systemd:
      name: docker
      state: restarted

  - name: reload nginx
    systemd:
      name: nginx
      state: reloaded
```

---

# ✅ Comment un Handler est déclenché

### Le nom est la clé !

```yaml
tasks:
  - name: Modifier config nginx
    template:
      src: nginx.conf.j2
      dest: /etc/nginx/nginx.conf
    notify: restart nginx  # ⚠️ CE NOM DOIT CORRESPONDRE EXACTEMENT
```

```yaml
handlers:
  - name: restart nginx  # ⚠️ CE NOM DOIT CORRESPONDRE EXACTEMENT
    systemd:
      name: nginx
      state: restarted
```

---

# ❌ Erreurs courantes avec les Handlers

### Ces handlers ne seront JAMAIS déclenchés :

```yaml
notify: restart nginx

handlers:
  - name: Restart nginx  # ❌ Majuscule différente
  - name: restart_nginx  # ❌ Underscore vs espace
  - name: restart nginx service  # ❌ Mots supplémentaires
  - name: reload nginx  # ❌ Action différente
```

**Le nom dans `notify` DOIT être identique au nom dans `handlers`**

---

# 🧠 Règle à retenir : Handlers

> **Le nom du handler = l'identifiant unique**

- Sensible à la casse (`restart` ≠ `Restart`)
- Sensible aux espaces (`restart nginx` ≠ `restart_nginx`)
- Pas d'alias possible
- Un notify = un handler exactement

---
layout: new-section
routeAlias: 'roles'
---

<a name="roles" id="roles"></a>

# Module 10 : Rôles

---

# Qu'est-ce qu'un Rôle ? 📦

### Les modules réutilisables

Un **rôle** est un ensemble organisé de tâches réutilisables :

- 📁 **Organisation** : Structure claire (tâches, variables, templates...)

- 🔄 **Réutilisabilité** : Utilisable dans plusieurs playbooks

- 📚 **Bibliothèque** : Partageable avec d'autres équipes

- 🧩 **Modularité** : Combine plusieurs rôles pour une solution complète

**Analogie** : C'est comme une application mobile que vous installez pour une fonction précise !

---

# Rôles : Réutilisabilité 📦

### Structure modulaire

```yaml
# roles/docker/tasks/main.yml
---
- name: Installation Docker
  apt:
    name: [docker.io, docker-compose-plugin]
    state: present

- name: Configuration Docker daemon
  template:
    src: daemon.json.j2
    dest: /etc/docker/daemon.json
  notify: restart docker
```

---

# Utilisation des rôles

```yaml
# Utilisation dans un playbook
---
- name: Setup infrastructure
  hosts: all
  become: true

  roles:
    - docker
    - nginx
    - {role: app, app_version: 'v2.0.0'}
```

---

# ✅ Comment Ansible détermine le nom d'un rôle

```
roles/nginx/
```

➡️ Le rôle s'appelle `nginx` parce que le dossier s'appelle `nginx`

Rien de plus. Rien de magique.

---

# 📌 Où ce nom est utilisé

### Dans le playbook

```yaml
- hosts: web
  roles:
    - nginx
```

👉 Ansible cherche automatiquement :

```
roles/nginx/tasks/main.yml
```

---

# Si tu renommes le dossier

```
roles/webserver/
```

Alors le rôle devient :

```yaml
roles:
  - webserver
```

**C'est tout !** Le nom du dossier = le nom du rôle.

---

# ❌ Ce qui NE définit PAS le nom du rôle

- ❌ `meta/main.yml`
- ❌ `galaxy_info.name`
- ❌ Un champ dans `tasks/main.yml`
- ❌ Une variable

Tout ça est informatif, pas structurel.

---

# 🧠 Règle à retenir (ultra importante)

> **1 dossier = 1 rôle = 1 nom**

Le système de fichiers détermine le nom, pas le contenu.

---
layout: new-section
routeAlias: 'collections'
---

<a name="collections" id="collections"></a>

# Module 12 : Collections

---

# Qu'est-ce qu'une Collection ? 🌐

### Les extensions spécialisées

Une **collection** est un pack d'extensions pour Ansible :

- 📦 **Pack** : Ensemble de modules spécialisés

- 🌍 **Domaine** : Cloud (AWS, Azure), containers (Docker), orchestration (Kubernetes)

- 🔄 **Évolution** : Mises à jour indépendantes d'Ansible

- 🎯 **Spécialisation** : Outils experts pour des technologies précises

**Analogie** : C'est comme des extensions dans votre navigateur pour des fonctions spéciales !

---

# Collections et écosystème 🌐

### Extensions essentielles

```bash
# Collections Docker
ansible-galaxy collection install community.docker

# Collections Cloud
ansible-galaxy collection install amazon.aws
ansible-galaxy collection install azure.azcollection

# Collections Kubernetes
ansible-galaxy collection install kubernetes.core
```

---

# Utilisation avec collections

```yaml
# Utilisation avec collections
- name: Gestion infrastructure cloud + containers
  hosts: localhost
  tasks:
    - name: Création instance AWS
      amazon.aws.ec2_instance:
        name: 'docker-host'
        image_id: ami-0abcdef1234567890
        instance_type: t3.medium
```

---

# Collections : Attente et déploiement

```yaml
- name: Attente démarrage
  wait_for:
    host: '{{ item.public_ip_address }}'
    port: 22

- name: Déploiement containers
  community.docker.docker_container:
    name: myapp
    image: nginx:alpine
    delegate_to: '{{ item.public_ip_address }}'
```

---

# ✅ Modules avec namespace (collections)

### Comprendre `community.docker.docker_container`

```yaml
- name: Lancer un container
  community.docker.docker_container:  # ⚠️ Namespace complet !
    name: webapp
    image: nginx
    state: started
```

**Format** : `namespace.collection.module_name`
- `community` = namespace
- `docker` = collection
- `docker_container` = module

---

# Pourquoi les namespaces ?

### Organisation des milliers de modules

**Avant (Ansible < 2.10)** : Tous les modules dans un seul paquet
```yaml
- docker_container:  # ❌ Deprecated
```

**Maintenant (Ansible 2.10+)** : Modules organisés en collections
```yaml
- community.docker.docker_container:  # ✅ Moderne
```

**Avantage** : Mises à jour indépendantes, meilleure organisation

---

# ❌ Erreur courante : Module introuvable

```yaml
- name: Lancer container
  docker_container:  # ❌ ERREUR : Module not found
    name: webapp
```

**Message d'erreur** :
```
ERROR! couldn't resolve module/action 'docker_container'
```

**Solutions** :

```yaml
# ✅ Solution 1 : Utiliser le nom complet
- community.docker.docker_container:
    name: webapp
```

---

```yaml
# ✅ Solution 2 : Installer la collection
```

```bash
ansible-galaxy collection install community.docker
```

```yaml
# Puis dans votre playbook
- name: Lancer container
  community.docker.docker_container:
    name: webapp
```

---

# Collections les plus courantes

| Collection | Modules | Installation |
|------------|---------|--------------|
| `community.docker` | Docker/containers | `ansible-galaxy collection install community.docker` |
| `community.general` | Utilitaires divers | Inclus par défaut |
| `ansible.posix` | Linux/POSIX | Inclus par défaut |
| `amazon.aws` | AWS | `ansible-galaxy collection install amazon.aws` |
| `kubernetes.core` | Kubernetes | `ansible-galaxy collection install kubernetes.core` |

---

# 🧠 Règle à retenir : Collections

> **Si le module a un point (`.`) dans son nom, c'est une collection**

Toujours utiliser le nom complet : `namespace.collection.module`

---
layout: new-section
routeAlias: 'vault'
---

<a name="vault" id="vault"></a>

# Module 13 : Ansible Vault

---

# Qu'est-ce qu'Ansible Vault ? 🔐

### Le coffre-fort pour vos secrets

**Ansible Vault** chiffre vos données sensibles :

- 🔒 **Chiffrement** : Mots de passe, clés API, certificats

- 🔑 **Mot de passe maître** : Un seul mot de passe pour tout déchiffrer

- 📁 **Fichiers sécurisés** : Stockage chiffré dans votre projet

- 👥 **Partage sécurisé** : Équipe peut utiliser sans voir les secrets

**Analogie** : C'est comme un coffre-fort numérique pour vos mots de passe !

---

# Ansible Vault : Secrets 🔐

### Gestion sécurisée des secrets

```bash
# Créer un fichier chiffré
ansible-vault create secrets.yml
ansible-vault edit secrets.yml

# Utilisation
ansible-playbook -i inventory deploy.yml --ask-vault-pass
```

---

# Vault : Utilisation des secrets

```yaml
# secrets.yml (chiffré)
vault_db_password: 'super_secret_password'
vault_api_key: '1234567890abcdef'

# Utilisation dans les playbooks
database:
  password: '{{ vault_db_password }}'

api:
  key: '{{ vault_api_key }}'
```

---

# ✅ Vault : Convention de nommage

### Pourquoi préfixer avec `vault_` ?

```yaml
# secrets.yml (chiffré)
vault_db_password: 'super_secret_password'  # ✅ Préfixé
vault_api_key: '1234567890abcdef'  # ✅ Préfixé
```

**Ce n'est PAS obligatoire, mais c'est une bonne pratique !**

---

# Vault : Pourquoi cette convention ?

### Traçabilité et sécurité

```yaml
# group_vars/all.yml (NON chiffré, visible dans Git)
db_password: '{{ vault_db_password }}'  # Variable utilisée partout
api_key: '{{ vault_api_key }}'

# group_vars/vault.yml (CHIFFRÉ avec ansible-vault)
vault_db_password: 'le_vrai_secret'  # Secret protégé
vault_api_key: 'la_vraie_clé'
```

**Avantage** : On voit dans le code NON chiffré qu'une variable vient du vault !

---

# ❌ Sans convention : Risque de confusion

```yaml
# Tout dans le même fichier non chiffré = DANGER
db_password: 'super_secret'  # ⚠️ Secret en clair dans Git !
api_key: 'mon_api_key'  # ⚠️ Secret exposé !
```

```yaml
# Avec la convention vault_ : Plus clair
db_password: '{{ vault_db_password }}'  # ✅ On sait que c'est chiffré ailleurs
api_key: '{{ vault_api_key }}'  # ✅ On sait que c'est chiffré ailleurs
```

---

# 🧠 Règle à retenir : Vault

> **Préfixe `vault_` = Bonne pratique, pas une obligation technique**

**Mais ça aide à :**
- 🔍 Identifier les secrets rapidement
- 🛡️ Éviter de commiter des secrets en clair
- 📖 Rendre le code plus lisible pour l'équipe

---
layout: new-section
routeAlias: 'bonnes-pratiques'
---

<a name="bonnes-pratiques" id="bonnes-pratiques"></a>

# Module 14 : Optimisation & Bonnes pratiques

---

# Optimisation et bonnes pratiques 🚀

### Configuration production

```ini
# ansible.cfg
[defaults]
# Pour ne pas vérifier les clés SSH
host_key_checking = False
# Pour afficher le temps d'exécution de chaque tâche
callback_whitelist = timer, profile_tasks
# Pour afficher les résultats de chaque tâche
stdout_callback = yaml
# Pour configurer le nombre de forks
forks = 20
# Pour configurer le timeout
timeout = 60
```

---

# Structure projet

```
ansible-project/
├── ansible.cfg
├── inventory/
│   ├── production.yml
│   └── staging.yml
├── group_vars/
│   ├── all.yml
│   ├── docker.yml
│   └── webapp.yml
├── templates/
│   ├── nginx.conf.j2
│   ├── docker-compose.yml.j2
│   ├── daemon.json.j2
│   ├── .env.j2
│   └── README.md
├── playbooks/
│   ├── site.yml
│   └── deploy.yml
├── roles/
│   ├── docker/
│   ├── nginx/
│   └── app/
├── .env
├── .env.staging
├── .env.production
├── .env.development
└── secrets.yml (vault)
```

---
layout: new-section
routeAlias: 'tags'
---

<a name="tags" id="tags"></a>

# Module 15 : Tags et exécution sélective

---

# Qu'est-ce qu'un Tag ? 🏷️

### Les étiquettes pour l'exécution sélective

Un **tag** permet d'exécuter seulement certaines parties :

- 🏷️ **Étiquette** : Marquer des tâches par fonction

- 🎯 **Sélectif** : Exécuter seulement l'installation, ou la config...

- ⚡ **Rapidité** : Éviter de rejouer tout le playbook

- 🔧 **Maintenance** : Corrections ciblées sans tout recommencer

**Analogie** : C'est comme des filtres dans une liste de courses !

---

# Tags et exécution sélective

```yaml
- name: Installation Docker
  apt: name=docker.io
  tags: [install, docker]

- name: Configuration
  template: src=config.j2 dest=/etc/app.conf
  tags: [config]
```

---

# Exécution avec tags

```bash
# Exécution sélective
ansible-playbook site.yml --tags "docker,config"
ansible-playbook site.yml --skip-tags "install"
```