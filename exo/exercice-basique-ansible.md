# Exercice Basique Ansible 🚀

## Objectif
Créer votre premier inventaire et playbook Ansible pour gérer les serveurs du lab Docker.

Ce fichier est la **correction** à comparer avec les consignes détaillées dans `exercice-basique-ansible-consignes.md` : les playbooks ci‑dessous reprennent **exactement** ce qui y est demandé (inventaire, `playbook.yml`, `playbook-webservers.yml`, `playbook-avec-variables.yml`). Les sections sur les commandes ad‑hoc et le récapitulatif proposent en plus des exemples pour aller plus loin.

---

## Prérequis

### 1. Démarrer l'infrastructure de test

```bash
# Démarrer tous les containers du lab
docker-compose -f docker-compose-lab.yml up -d

# Vérifier que les containers sont démarrés (attendre 30 secondes)
sleep 30
docker ps | grep ansible-lab

# Vous devriez voir 10 containers :
# - 3 serveurs web (web01, web02, web03)
# - 2 serveurs de base de données (db01, db02)
# - 3 serveurs applicatifs (app01, app02, app03)
# - 2 serveurs de monitoring (monitor01, monitor02)
```

### 2. Vérifier qu'Ansible est installé

```bash
# Installer Ansible si nécessaire
pip3 install ansible

# Vérifier la version
ansible --version
```

---

## Partie 1 : Créer l'inventaire

### Créer le dossier de travail

```bash
# Créer un dossier pour l'exercice
mkdir -p exercice-basique-ansible
cd exercice-basique-ansible
```

---

### Créer le fichier inventory.yml

```yaml
# inventory.yml
---
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

    databases:
      hosts:
        db01:
          ansible_host: ansible-lab-db01
        db02:
          ansible_host: ansible-lab-db02

    appservers:
      hosts:
        app01:
          ansible_host: ansible-lab-app01
        app02:
          ansible_host: ansible-lab-app02
        app03:
          ansible_host: ansible-lab-app03

    monitoring:
      hosts:
        monitor01:
          ansible_host: ansible-lab-monitor01
        monitor02:
          ansible_host: ansible-lab-monitor02
```

---

### Tester l'inventaire

```bash
# Lister tous les hosts de l'inventaire
ansible-inventory -i inventory.yml --list

# Vérifier la connectivité avec tous les serveurs
ansible all -i inventory.yml -m ping

# Vous devriez voir SUCCESS pour chaque serveur
```

---

## Partie 2 : Créer votre premier playbook

### Créer le fichier playbook.yml

Aligné sur les consignes (message de bienvenue, APT, paquets, fichier d’information minimal, lecture du fichier, puis debug des infos système).

```yaml
# playbook.yml
---
- name: Configuration basique des serveurs
  hosts: all
  become: true

  tasks:
    - name: Afficher un message de bienvenue
      debug:
        msg: "👋 Hello depuis {{ inventory_hostname }}"

    - name: Mettre à jour le cache APT
      apt:
        update_cache: yes
        cache_valid_time: 3600

    - name: Installer des outils de base
      apt:
        name:
          - curl
          - vim
          - htop
          - net-tools
        state: present

    - name: Créer un fichier d'information
      copy:
        content: |
          Nom du serveur: {{ inventory_hostname }}
          Date: {{ ansible_date_time.iso8601 }}
        dest: /tmp/ansible-info.txt
        mode: '0644'

    - name: Afficher le contenu du fichier créé
      command: cat /tmp/ansible-info.txt
      register: file_content
      changed_when: false

    - name: Afficher les informations système
      debug:
        msg: |
          Distribution: {{ ansible_distribution }}
          Version: {{ ansible_distribution_version }}
          Architecture: {{ ansible_architecture }}
          Mémoire (Mo): {{ ansible_memtotal_mb }}
```

---

### Exécuter le playbook

```bash
# Exécuter le playbook sur tous les serveurs
ansible-playbook -i inventory.yml playbook.yml

# Vous devriez voir toutes les tâches s'exécuter avec succès
```

---

## Partie 3 : Playbook pour un groupe spécifique

### playbook-webservers.yml

```yaml
# playbook-webservers.yml
---
- name: Configuration des serveurs web
  hosts: webservers
  become: true

  tasks:
    - name: Créer un répertoire web
      file:
        path: /var/www/html
        state: directory
        mode: '0755'

    - name: Créer une page web simple
      copy:
        content: |
          <!DOCTYPE html>
          <html>
          <head><title>{{ inventory_hostname }}</title></head>
          <body>
            <h1>Serveur Web: {{ inventory_hostname }}</h1>
            <p>Configuré avec Ansible</p>
          </body>
          </html>
        dest: /var/www/html/index.html
        mode: '0644'
```

```bash
# Exécuter uniquement sur les webservers
ansible-playbook -i inventory.yml playbook-webservers.yml
```

---

## Partie 4 : Playbook avec variables

### playbook-avec-variables.yml

```yaml
# playbook-avec-variables.yml
---
- name: Configuration avec variables
  hosts: databases
  become: true

  vars:
    db_port: 5432
    db_name: production
    admin_email: admin@example.com

  tasks:
    - name: Créer un fichier de configuration
      copy:
        content: |
          # Configuration de base de données
          DB_PORT={{ db_port }}
          DB_NAME={{ db_name }}
          ADMIN_EMAIL={{ admin_email }}
          HOSTNAME={{ inventory_hostname }}
        dest: /etc/db-config.conf
        mode: '0644'

    - name: Afficher le contenu du fichier créé
      command: cat /etc/db-config.conf
      register: db_config_content
      changed_when: false

    - name: Montrer la configuration
      debug:
        var: db_config_content.stdout_lines
```

```bash
# Exécuter sur les serveurs de base de données
ansible-playbook -i inventory.yml playbook-avec-variables.yml
```

---

## Partie 5 : Commandes ad-hoc utiles (compléments)

```bash
# Vérifier la version d'Ubuntu sur tous les serveurs
ansible all -i inventory.yml -m command -a "cat /etc/os-release"

# Voir la distribution de manière formatée
ansible all -i inventory.yml -m setup -a "filter=ansible_distribution*"

# Créer un répertoire sur les serveurs web
ansible webservers -i inventory.yml -m file -a "path=/tmp/test state=directory mode=0755"

# Copier un fichier sur tous les serveurs
ansible all -i inventory.yml -m copy -a "content='Hello World from Ansible' dest=/tmp/hello.txt mode=0644"

# Lire le fichier créé
ansible all -i inventory.yml -m command -a "cat /tmp/hello.txt"

# Voir l'espace disque sur tous les serveurs
ansible all -i inventory.yml -m command -a "df -h"

# Voir les processus sur les webservers
ansible webservers -i inventory.yml -m command -a "ps aux | head -10"

# Voir la mémoire disponible
ansible all -i inventory.yml -m command -a "free -h"

# Vérifier l'uptime des serveurs
ansible all -i inventory.yml -m command -a "uptime"

# Lister les utilisateurs connectés
ansible all -i inventory.yml -m command -a "who"

# Créer un utilisateur de test (exemple avancé)
ansible appservers -i inventory.yml -m user -a "name=testuser state=present shell=/bin/bash"

# Installer un package sur un groupe spécifique
ansible monitoring -i inventory.yml -m apt -a "name=htop state=present update_cache=yes" --become

# Voir les variables d'un serveur spécifique
ansible web01 -i inventory.yml -m setup

# Filtrer les variables réseau
ansible all -i inventory.yml -m setup -a "filter=ansible_default_ipv4"

# Filtrer les variables de mémoire
ansible all -i inventory.yml -m setup -a "filter=ansible_mem*"

# Copier un fichier local vers les serveurs
echo "Test file" > /tmp/local-file.txt
ansible webservers -i inventory.yml -m copy -a "src=/tmp/local-file.txt dest=/tmp/remote-file.txt"

# Créer un fichier avec permissions spécifiques
ansible databases -i inventory.yml -m file -a "path=/tmp/secure-file.txt state=touch mode=0600 owner=root"

# Vérifier si un package est installé
ansible all -i inventory.yml -m command -a "dpkg -l | grep curl"

# Redémarrer un service (exemple avec un service existant)
ansible all -i inventory.yml -m service -a "name=ssh state=restarted" --become

# Obtenir uniquement certaines informations
ansible all -i inventory.yml -m setup -a "filter=ansible_hostname"
ansible all -i inventory.yml -m setup -a "filter=ansible_processor_vcpus"
ansible all -i inventory.yml -m setup -a "filter=ansible_memtotal_mb"
```

---

## Partie 6 : Vérifications et tests

### Tester la configuration

```bash
# Vérifier que les outils sont installés sur tous les serveurs
ansible all -i inventory.yml -m command -a "curl --version"
ansible all -i inventory.yml -m command -a "vim --version"

# Vérifier le fichier ansible-info.txt sur chaque serveur
ansible all -i inventory.yml -m command -a "cat /tmp/ansible-info.txt"

# Vérifier les serveurs web
ansible webservers -i inventory.yml -m command -a "cat /var/www/html/index.html"

# Vérifier les serveurs de base de données
ansible databases -i inventory.yml -m command -a "cat /etc/db-config.conf"
```

---

## Partie 7 : Nettoyage

```bash
# Supprimer les fichiers de test
ansible all -i inventory.yml -m file -a "path=/tmp/ansible-info.txt state=absent"
ansible all -i inventory.yml -m file -a "path=/tmp/hello.txt state=absent"

# Arrêter l'infrastructure de test
cd ..
docker-compose -f docker-compose-lab.yml down

# Supprimer les volumes (optionnel)
docker-compose -f docker-compose-lab.yml down -v
```

---

## Récapitulatif

### Ce que vous avez appris ✅

1. **Inventaire Ansible**
   - Structure YAML avec groupes et hosts
   - Variables globales (`all.vars`)
   - Groupes de serveurs (webservers, databases, appservers, monitoring)
   - Variables de connexion Docker
   - Organisation hiérarchique des serveurs

2. **Playbooks de base**
   - Structure d'un playbook (`name`, `hosts`, `become`, `tasks`)
   - Tâches simples (debug, apt, copy, command, file)
   - Variables Ansible prédéfinies :
     - `{{ inventory_hostname }}` - Nom du serveur
     - `{{ ansible_host }}` - Container Docker
     - `{{ ansible_distribution }}` - Distribution Linux
     - `{{ ansible_distribution_version }}` - Version
     - `{{ ansible_architecture }}` - Architecture système
     - `{{ ansible_memtotal_mb }}` - Mémoire totale
     - `{{ ansible_processor_vcpus }}` - Nombre de CPUs
     - `{{ ansible_date_time.iso8601 }}` - Date/heure ISO
     - `{{ ansible_user }}` - Utilisateur de connexion
     - `{{ ansible_python_interpreter }}` - Chemin Python
     - `{{ group_names }}` - Liste des groupes
   - Variables personnalisées dans `vars:`
   - Enregistrement de résultats avec `register:`
   - Filtres Jinja2 : d’autres exemples (`join`, conditions, etc.) figurent dans la partie « Commandes ad-hoc utiles (compléments) »

3. **Modules Ansible essentiels**
   - `ping` : Tester la connectivité
   - `debug` : Afficher des informations (msg, var)
   - `apt` : Gérer les packages (install, update_cache)
   - `copy` : Copier/créer des fichiers (content, dest, mode)
   - `file` : Gérer fichiers/répertoires (path, state, mode, owner)
   - `command` : Exécuter des commandes (+ changed_when)
   - `setup` : Collecter les facts (filter)
   - `user` : Gérer les utilisateurs
   - `service` : Gérer les services

4. **Commandes ad-hoc**
   - Exécution rapide sans playbook
   - Syntaxe : `ansible <hosts> -i <inventory> -m <module> -a "<args>"`
   - Options utiles : `--become`, `--check`, `--diff`
   - Filtrage avec `setup` et `filter=`
   - Utile pour tests, debug et opérations ponctuelles

5. **Bonnes pratiques**
   - Organisation en groupes logiques
   - Utilisation de variables pour la réutilisabilité
   - Mode `0644` pour les fichiers, `0755` pour les répertoires
   - `changed_when: false` pour les commandes de lecture
   - `become: true` quand les droits root sont nécessaires
   - Commentaires dans les playbooks
   - Messages explicites dans les tâches

---

## Prochaines étapes 🚀

Maintenant que vous maîtrisez les bases, vous pouvez :

1. Créer des playbooks plus complexes
2. Utiliser des templates Jinja2
3. Créer des rôles Ansible
4. Gérer des variables avancées
5. Utiliser des handlers

**Bravo ! Vous avez terminé l'exercice basique Ansible !** 🎉
