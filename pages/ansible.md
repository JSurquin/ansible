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

# Module 2 : Installation et Setup 2026

---

# Installation et setup 2026 ⚙️

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

# ✅ Mini-QCM : Module 4 - Inventaires

**Question 1** : Quelle est la différence entre le nom d'hôte et `ansible_host` ?
- A) Il n'y a pas de différence
- B) Le nom est un alias, `ansible_host` est l'adresse réelle
- C) `ansible_host` est obsolète

**Question 2** : Comment grouper des serveurs dans un inventaire ?
- A) Avec `children:` en YAML
- B) Avec `[nom_groupe]` en INI
- C) Les deux sont possibles

**Question 3** : Quelle variable définit l'utilisateur SSH ?
- A) `ansible_ssh_user`
- B) `ansible_user`
- C) `ssh_username`

---

# 📝 Réponses Mini-QCM Module 4

**Question 1** : **B** ✅
Le nom (ex: web-01) est un alias logique. `ansible_host` contient l'IP/FQDN réel.

**Question 2** : **C** ✅
Les deux formats sont valides : `children:` en YAML ou `[groupe]` en INI.

**Question 3** : **B** ✅
`ansible_user` est la variable standard (anciennement `ansible_ssh_user`).

---

# 🎯 Mini-exercice : Module 4 (5 min)

**Objectif** : Créer un inventaire multi-groupes

```yaml
# Créer inventory.yml avec :
# - Groupe "web" : 2 serveurs (web01: 10.0.1.10, web02: 10.0.1.11)
# - Groupe "db" : 1 serveur (db01: 10.0.1.20)
# - Variable globale : ansible_user: ubuntu
```

**Test** :
```bash
ansible-inventory -i inventory.yml --graph
# Doit afficher la structure complète
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

#### Premier playbook 🎭

<small>

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

</small>

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

# ✅ Mini-QCM : Module 5 - Playbooks

**Question 1** : Que signifie `become: true` ?
- A) Devenir administrateur système
- B) Exécuter les tâches avec sudo (privilèges root)
- C) Se connecter en tant que root

**Question 2** : Quelle est la différence entre `state: present` et `state: started` ?
- A) Aucune différence
- B) `present` installe, `started` démarre un service
- C) `present` est obsolète

**Question 3** : Un playbook s'exécute sur :
- A) Les hôtes définis dans `hosts:`
- B) Tous les serveurs de l'inventaire
- C) Uniquement localhost

---

# 📝 Réponses Mini-QCM Module 5

**Question 1** : **B** ✅
`become: true` exécute les commandes avec `sudo`. Nécessaire pour installer des packages, modifier `/etc/`, gérer des services.

**Question 2** : **B** ✅
`state: present` pour les packages (installer), `state: started` pour les services (démarrer). Chaque module a ses propres valeurs de `state`.

**Question 3** : **A** ✅
Le playbook s'exécute sur les hôtes spécifiés dans `hosts:` (ex: `hosts: webservers` ou `hosts: all`).

---

# 🎯 Mini-exercice : Module 5 (10 min)

**Objectif** : Créer votre premier playbook fonctionnel

```yaml
# Créer playbook.yml qui :
# 1. Cible localhost
# 2. Utilise become: true
# 3. Installe git (state: present)
# 4. Crée le dossier /tmp/ansible-test
# 5. Affiche un message "Playbook terminé !"
```

**Exécution** :
```bash
ansible-playbook -i localhost, playbook.yml
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

# ✅ Mini-QCM : Module 6 - Modules essentiels

**Question 1** : Qu'est-ce qu'un module Ansible ?
- A) Un fichier de configuration
- B) Une fonction prête à l'emploi pour une tâche spécifique
- C) Un type de playbook

**Question 2** : Quel module utilise-t-on pour gérer des containers Docker ?
- A) `docker_container`
- B) `community.docker.docker_container`
- C) Les deux peuvent fonctionner

**Question 3** : Pourquoi utiliser le module `template` plutôt que `copy` ?
- A) `template` est plus rapide
- B) `template` permet d'utiliser des variables Jinja2
- C) Pas de différence

---

# 📝 Réponses Mini-QCM Module 6

**Question 1** : **B** ✅
Un module est une fonction réutilisable qui exécute une tâche précise (installer, copier, démarrer...). Ansible a des centaines de modules.

**Question 2** : **B** ✅
Le nom complet avec namespace est requis depuis Ansible 2.10+ : `community.docker.docker_container`. Il faut installer la collection d'abord.

**Question 3** : **B** ✅
`template` permet d'utiliser des variables Jinja2 (`{{ variable }}`), des conditions, des boucles. `copy` copie le fichier tel quel.

---

# 🎯 Mini-exercice : Module 6 (10 min)

**Objectif** : Utiliser différents modules

```yaml
# Créer playbook-modules.yml avec :
# 1. Module apt: installer nginx
# 2. Module file: créer /var/www/html/test
# 3. Module copy: créer index.html avec "Hello Ansible"
# 4. Module service: démarrer nginx
```

**Test** :
```bash
ansible-playbook -i localhost, playbook-modules.yml --become
curl localhost
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

# ✅ Mini-QCM : Module 7 - Variables

**Question 1** : Comment définir une variable dans un playbook ?
- A) `set: var_name value`
- B) `vars:` puis `var_name: value`
- C) `define var_name = value`

**Question 2** : Comment utiliser une variable dans une tâche ?
- A) `$var_name`
- B) `{{ var_name }}`
- C) `%var_name%`

**Question 3** : Quelle est la priorité des variables ?
- A) Playbook > Inventaire > extra-vars (-e)
- B) extra-vars (-e) > Playbook > Inventaire
- C) Inventaire > extra-vars (-e) > Playbook

---

# 📝 Réponses Mini-QCM Module 7

**Question 1** : **B** ✅
On définit les variables avec `vars:` suivi d'une liste clé-valeur en YAML (`var_name: value`).

**Question 2** : **B** ✅
Syntaxe Jinja2 : `{{ var_name }}`. Fonctionne partout : tâches, templates, conditions.

**Question 3** : **B** ✅
Ordre de priorité (du + fort au + faible) : extra-vars (-e) > vars du playbook > group_vars > defaults. Les extra-vars gagnent toujours.

---

# 🎯 Mini-exercice : Module 7 (5 min)

**Objectif** : Utiliser des variables

```yaml
# Créer playbook-vars.yml avec :
# - Variable app_name: "mon-app"
# - Variable app_version: "1.0.0"
# - Tâche debug affichant : "Deploying {{ app_name }} v{{ app_version }}"
```

**Test avec extra-vars** :
```bash
ansible-playbook playbook-vars.yml -e app_version=2.0.0
# Doit afficher version 2.0.0 (override)
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

# ✅ Mini-QCM : Module 8 - Templates Jinja2

**Question 1** : Où Ansible cherche-t-il les templates par défaut ?
- A) Dans le dossier courant
- B) Dans `templates/`
- C) Dans `/etc/ansible/templates/`

**Question 2** : Quelle est la syntaxe pour afficher une variable dans un template ?
- A) `${ variable }`
- B) `{{ variable }}`
- C) `<%= variable %>`

**Question 3** : Le paramètre `dest:` du module template doit être :
- A) Relatif au dossier templates/
- B) Un chemin absolu sur le serveur distant
- C) N'importe quel chemin

---

# 📝 Réponses Mini-QCM Module 8

**Question 1** : **B** ✅
Ansible cherche automatiquement dans `templates/` (playbook) ou `roles/ROLE/templates/` (rôle). Pas besoin du chemin complet.

**Question 2** : **B** ✅
Jinja2 utilise `{{ variable }}` pour afficher, `{% if %}` pour conditions, `{% for %}` pour boucles.

**Question 3** : **B** ✅
`src` est relatif (cherche dans templates/), `dest` doit être absolu sur le serveur cible (ex: `/etc/app/config.conf`).

---

# 🎯 Mini-exercice : Module 8 (10 min)

**Objectif** : Créer et déployer un template

```yaml
# 1. Créer templates/app.conf.j2 :
app_name={{ app_name }}
environment={{ environment | default('dev') }}
port={{ app_port }}

# 2. Créer playbook avec :
vars:
  app_name: "myapp"
  app_port: 8080
tasks:
  - template:
      src: app.conf.j2
      dest: /tmp/app.conf
```

**Test** : `cat /tmp/app.conf` doit afficher les valeurs.

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

# ✅ Mini-QCM : Module 9 - Handlers

**Question 1** : Quand un handler est-il exécuté ?
- A) Immédiatement quand il est notifié
- B) À la fin du playbook, seulement si notifié et que la tâche a changé
- C) Au début du play

**Question 2** : Comment appeler un handler ?
- A) `trigger: handler_name`
- B) `notify: handler_name`
- C) `call: handler_name`

**Question 3** : Le nom du handler doit être :
- A) Identique au nom dans `notify:` (sensible à la casse)
- B) Peu importe, Ansible trouve automatiquement
- C) En majuscules uniquement

---

# 📝 Réponses Mini-QCM Module 9

**Question 1** : **B** ✅
Les handlers s'exécutent à la FIN du playbook, uniquement si notifiés ET que la tâche a changé quelque chose (`changed: true`).

**Question 2** : **B** ✅
On utilise `notify: handler_name` dans une tâche. Le handler doit avoir exactement le même nom.

**Question 3** : **A** ✅
Le nom doit être EXACTEMENT identique : sensible à la casse, aux espaces, aux underscores. `restart nginx` ≠ `Restart nginx`.

---

# 🎯 Mini-exercice : Module 9 (10 min)

**Objectif** : Créer un handler fonctionnel

```yaml
# Créer playbook-handler.yml avec :
tasks:
  - name: Créer fichier config
    copy:
      content: "test config"
      dest: /tmp/app.conf
    notify: show message

handlers:
  - name: show message
    debug:
      msg: "Config changed!"
```

**Test** : Exécuter 2x, le handler ne s'exécute que la 1ère fois.

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

# ✅ Mini-QCM : Module 10 - Rôles

**Question 1** : Comment Ansible détermine-t-il le nom d'un rôle ?
- A) Par le nom du dossier
- B) Par le contenu de meta/main.yml
- C) Par le nom dans tasks/main.yml

**Question 2** : Quelle est la structure minimale d'un rôle ?
- A) Juste le dossier tasks/
- B) tasks/, handlers/, vars/, files/
- C) Tous les dossiers sont obligatoires

**Question 3** : Comment utiliser un rôle dans un playbook ?
- A) `roles: - nom_role`
- B) `include_role: nom_role`
- C) Les deux sont possibles

---

# 📝 Réponses Mini-QCM Module 10

**Question 1** : **A** ✅
Le nom du rôle = le nom du dossier. Si le dossier s'appelle `nginx`, le rôle s'appelle `nginx`. Le contenu ne change rien.

**Question 2** : **A** ✅
Seul `tasks/` est obligatoire (avec main.yml). Les autres dossiers (handlers/, vars/, files/, templates/) sont optionnels.

**Question 3** : **C** ✅
Les deux syntaxes fonctionnent : `roles:` (statique, au début) ou `include_role:` (dynamique, dans les tasks).

---

# 🎯 Mini-exercice : Module 10 (15 min)

**Objectif** : Créer votre premier rôle

```bash
# 1. Créer la structure
mkdir -p roles/hello/tasks

# 2. Créer roles/hello/tasks/main.yml :
---
- name: Afficher message
  debug:
    msg: "Hello from role!"

# 3. Playbook utilisant le rôle :
---
- hosts: localhost
  roles:
    - hello
```

**Test** : Le message doit s'afficher.

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

# ✅ Mini-QCM : Module 11 - Collections

**Question 1** : Qu'est-ce qu'une collection Ansible ?
- A) Un groupe de serveurs
- B) Un pack de modules spécialisés
- C) Un type de playbook

**Question 2** : Comment installer une collection ?
- A) `ansible install community.docker`
- B) `ansible-galaxy collection install community.docker`
- C) `pip install ansible-collection-docker`

**Question 3** : Le format `community.docker.docker_container` signifie :
- A) community = namespace, docker = collection, docker_container = module
- B) C'est juste un long nom de module
- C) community.docker est obsolète

---

# 📝 Réponses Mini-QCM Module 11

**Question 1** : **B** ✅
Une collection est un pack de modules spécialisés (ex: community.docker pour Docker, amazon.aws pour AWS).

**Question 2** : **B** ✅
Commande : `ansible-galaxy collection install nom.collection`. Galaxy est le gestionnaire de collections/rôles.

**Question 3** : **A** ✅
Format : `namespace.collection.module`. Ex: `community.docker.docker_container` = namespace community, collection docker, module docker_container.

---

# 🎯 Mini-exercice : Module 11 (5 min)

**Objectif** : Installer et utiliser une collection

```bash
# 1. Installer la collection
ansible-galaxy collection install community.general

# 2. Lister les collections installées
ansible-galaxy collection list

# 3. Utiliser un module de la collection
ansible localhost -m community.general.timezone -a "name=Europe/Paris" --become
```

**Vérification** : La collection doit apparaître dans la liste.

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

# ✅ Mini-QCM : Module 12 - Ansible Vault

**Question 1** : À quoi sert Ansible Vault ?
- A) Stocker les playbooks de manière sécurisée
- B) Chiffrer les données sensibles comme les mots de passe
- C) Faire des sauvegardes automatiques

**Question 2** : Comment créer un fichier chiffré ?
- A) `ansible-vault encrypt fichier.yml`
- B) `ansible-vault create fichier.yml`
- C) Les deux sont possibles

**Question 3** : Pourquoi préfixer les variables avec `vault_` ?
- A) C'est obligatoire techniquement
- B) Bonne pratique pour identifier les secrets
- C) Ansible l'exige

---

# 📝 Réponses Mini-QCM Module 12

**Question 1** : **B** ✅
Vault chiffre les données sensibles (mots de passe, clés API, certificats). Le fichier reste dans Git mais chiffré.

**Question 2** : **C** ✅
`create` : crée un nouveau fichier chiffré. `encrypt` : chiffre un fichier existant. Les deux fonctionnent.

**Question 3** : **B** ✅
Préfixe `vault_` = bonne pratique (pas obligatoire). Permet d'identifier rapidement qu'une variable vient du vault.

---

# 🎯 Mini-exercice : Module 12 (10 min)

**Objectif** : Créer et utiliser un secret chiffré

```bash
# 1. Créer fichier chiffré
ansible-vault create secrets.yml
# Ajouter : vault_api_key: "secret123"

# 2. Créer playbook utilisant le secret
---
- hosts: localhost
  vars_files:
    - secrets.yml
  tasks:
    - debug:
        msg: "API Key: {{ vault_api_key }}"

# 3. Exécuter
ansible-playbook playbook.yml --ask-vault-pass
```

---
layout: new-section
routeAlias: 'debugging'
---

<a name="debugging" id="debugging"></a>

# Module 13.5 : Debugging & Troubleshooting

---

# Pourquoi le debugging ? 🐛

### Les erreurs font partie du process

**Réalité** : Même les experts Ansible font des erreurs !

**Erreurs courantes** :
- Syntaxe YAML incorrecte
- Variables non définies
- Permissions insuffisantes
- Modules non trouvés
- Connexions SSH qui échouent

**L'objectif** : Diagnostiquer et corriger rapidement !

---

# Mode verbeux : -v, -vv, -vvv 📢

### Plus de détails = plus facile à débugger

```bash
# Niveau 1 : Basique
ansible-playbook playbook.yml -v

# Niveau 2 : Détaillé
ansible-playbook playbook.yml -vv

# Niveau 3 : Très détaillé
ansible-playbook playbook.yml -vvv

# Niveau 4 : Debug SSH
ansible-playbook playbook.yml -vvvv
```

**Usage** :
- `-v` : Voir les résultats des tâches
- `-vv` : Voir les détails des modules
- `-vvv` : Voir les commandes exécutées
- `-vvvv` : Voir le debug SSH complet

---

# Module debug : Afficher des variables 💡

### Votre meilleur ami pour le debugging

```yaml
# Afficher une variable
- debug:
    var: ansible_hostname

# Afficher un message formaté
- debug:
    msg: "App: {{ app_name }}, Version: {{ app_version }}"

# Afficher toutes les variables d'un hôte
- debug:
    var: hostvars[inventory_hostname]

# Afficher le résultat d'une tâche précédente
- debug:
    var: result.stdout
```

**💡 Astuce** : Utilisez debug pour vérifier les valeurs avant d'exécuter les vraies tâches !

---

# Mode dry-run : --check 🎯

### Tester sans modifier

```bash
# Simuler l'exécution sans rien changer
ansible-playbook playbook.yml --check

# Combiner avec diff pour voir les changements prévus
ansible-playbook playbook.yml --check --diff

# Tester sur un seul serveur
ansible-playbook playbook.yml --limit web-01 --check
```

**Avantages** :
- ✅ Voir ce qui va changer avant de le faire
- ✅ Tester en production sans risque
- ✅ Valider la logique du playbook

**⚠️ Attention** : Certains modules ne supportent pas --check

---

# Reprendre l'exécution : --start-at-task 🔄

### Éviter de rejouer tout depuis le début

```bash
# Reprendre à une tâche spécifique
ansible-playbook playbook.yml --start-at-task="Install nginx"

# Pratique après une erreur pour ne pas tout refaire
# 1. Correction du problème
# 2. Reprise à partir de la tâche qui a échoué
```

---

# Exécution pas à pas : --step ⏯️

### Contrôle total de l'exécution

```bash
# Demander confirmation avant chaque tâche
ansible-playbook playbook.yml --step
```

**Workflow** :
1. Ansible affiche la tâche suivante
2. Vous choisissez : (y)es, (n)o, (c)ontinue
3. Parfait pour tester des playbooks complexes

---

# Limiter l'exécution : --limit 🎯

### Tester sur un sous-ensemble de serveurs

```bash
# Sur un seul serveur
ansible-playbook playbook.yml --limit web-01

# Sur un groupe
ansible-playbook playbook.yml --limit webservers

# Sur plusieurs serveurs
ansible-playbook playbook.yml --limit "web-01,web-02"

# Exclure des serveurs
ansible-playbook playbook.yml --limit "all:!db-01"
```

**Usage** : Tester sur un serveur avant de déployer partout !

---

# Tags pour exécution sélective 🏷️

### Exécuter seulement certaines parties

```yaml
tasks:
  - name: Install packages
    apt: name=nginx
    tags: [install, packages]

  - name: Configure nginx
    template: src=nginx.conf.j2 dest=/etc/nginx/nginx.conf
    tags: [config]

  - name: Start nginx
    service: name=nginx state=started
    tags: [service, start]
```

```bash
# Exécuter seulement les tâches "config"
ansible-playbook playbook.yml --tags config

# Exécuter tout sauf "install"
ansible-playbook playbook.yml --skip-tags install

# Lister tous les tags disponibles
ansible-playbook playbook.yml --list-tags
```

---

# Erreurs courantes et solutions 🔧

### Les pièges classiques

**Erreur 1** : `Module not found: docker_container`
```bash
# Solution : Installer la collection
ansible-galaxy collection install community.docker
```

**Erreur 2** : `Permission denied`
```yaml
# Solution : Ajouter become
- hosts: web
  become: true  # ← Ajouter ceci
```

**Erreur 3** : `Unable to connect to host`
```bash
# Solution : Vérifier SSH
ansible web-01 -m ping
ssh ubuntu@web-01
```

---

# Erreurs courantes (suite) 🔧

**Erreur 4** : `Undefined variable: app_version`
```yaml
# Solution : Vérifier l'orthographe et définir la variable
vars:
  app_version: "1.0.0"  # ← Définir la variable
```

**Erreur 5** : `YAML syntax error`
```yaml
# ❌ Erreur : Mauvaise indentation
tasks:
- name: Install nginx
  apt:
  name: nginx  # ← Mal indenté

# ✅ Correct :
tasks:
  - name: Install nginx
    apt:
      name: nginx  # ← Bien indenté
```

---

# Stratégies de debugging 🎯

### Approche systématique

**1. Lire l'erreur attentivement**
- Le message indique souvent la solution
- Noter le numéro de ligne

**2. Vérifier la syntaxe YAML**
```bash
# Valider la syntaxe
ansible-playbook playbook.yml --syntax-check
```

**3. Tester sur localhost d'abord**
```yaml
- hosts: localhost
  connection: local  # ← Pas de SSH
```

**4. Ajouter des debug en cascade**
```yaml
- debug: var=my_var
- debug: msg="Avant la tâche problématique"
- name: Tâche qui pose problème
  ...
- debug: msg="Après la tâche"
```

---

# Outils utiles 🛠️

### Commandes de diagnostic

```bash
# Vérifier la syntaxe YAML
ansible-playbook playbook.yml --syntax-check

# Lister les tâches sans les exécuter
ansible-playbook playbook.yml --list-tasks

# Lister les hôtes ciblés
ansible-playbook playbook.yml --list-hosts

# Voir la configuration Ansible active
ansible-config dump

# Tester la connexion aux hôtes
ansible all -m ping -i inventory.yml

# Obtenir les facts d'un hôte
ansible web-01 -m setup
```

---

# 🎯 Checklist de debugging

**Avant de demander de l'aide, vérifiez** :

- [ ] La syntaxe YAML est valide (`--syntax-check`)
- [ ] Les variables sont bien définies (ajouter `debug`)
- [ ] L'inventaire est correct (`--list-hosts`)
- [ ] SSH fonctionne (`ansible host -m ping`)
- [ ] Les permissions sont suffisantes (`become: true` ?)
- [ ] Les modules/collections sont installés
- [ ] Le mode verbeux donne plus d'infos (`-vvv`)

**90% des problèmes se résolvent avec ces vérifications !**

---
layout: new-section
routeAlias: 'bonnes-pratiques'
---

<a name="bonnes-pratiques" id="bonnes-pratiques"></a>

# Module 14 : Optimisation & Bonnes pratiques (Bonus)

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

# Module 15 : Tags et exécution sélective (Bonus)

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