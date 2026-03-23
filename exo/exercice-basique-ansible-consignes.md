# Exercice Basique Ansible 🚀

## Objectif

Créer votre premier inventaire et playbook Ansible pour gérer les serveurs du lab Docker.

**Durée estimée** : 45 minutes

---

## Prérequis

### 1. Démarrer l'infrastructure de test

```bash
# Démarrer tous les containers du lab
docker-compose -f docker-compose-lab.yml up -d

# Vérifier que les containers sont démarrés (attendre 30 secondes)
sleep 30
docker ps | grep ansible-lab
```

**Ce que vous devriez voir** : 10 containers avec les noms suivants :
- `ansible-lab-web01`, `ansible-lab-web02`, `ansible-lab-web03` (serveurs web)
- `ansible-lab-db01`, `ansible-lab-db02` (bases de données)
- `ansible-lab-app01`, `ansible-lab-app02`, `ansible-lab-app03` (serveurs applicatifs)
- `ansible-lab-monitor01`, `ansible-lab-monitor02` (monitoring)

---

### 2. Vérifier qu'Ansible est installé

```bash
# Installer Ansible si nécessaire
pip3 install ansible

# Vérifier la version
ansible --version
```

---

## Partie 1 : Créer l'inventaire (15 min)

### Étape 1.1 : Créer le dossier de travail

```bash
# Créer un dossier pour l'exercice
mkdir -p exercice-basique-ansible
cd exercice-basique-ansible
```

---

### Étape 1.2 : Créer le fichier inventory.yml

**Mission** : Créer un fichier `inventory.yml` qui organise vos 10 serveurs en groupes.

**Structure attendue** :
- Un groupe `webservers` avec web01, web02, web03
- Un groupe `databases` avec db01, db02
- Un groupe `appservers` avec app01, app02, app03
- Un groupe `monitoring` avec monitor01, monitor02

**Configuration requise pour TOUS les serveurs** :
- `ansible_connection: docker` (car on se connecte à des containers)
- `ansible_user: root` (utilisateur par défaut)
- `ansible_python_interpreter: /usr/bin/python3` (chemin Python)

**Indications** :
- Utilisez le format YAML
- Commencez par `all:` pour définir les variables globales
- Utilisez `children:` pour définir les groupes
- Pour chaque host, définissez `ansible_host` avec le nom du container Docker
  - Exemple : pour web01, utilisez `ansible_host: ansible-lab-web01`

**Aide supplémentaire** :
```yaml
# Structure de base à compléter
---
all:
  vars:
    # Ajoutez les 3 variables globales ici
    ansible_connection: ???
    ansible_user: ???
    ansible_python_interpreter: ???

  children:
    webservers:
      hosts:
        web01:
          ansible_host: ???
        # Ajoutez web02 et web03
    
    databases:
      hosts:
        # Ajoutez db01 et db02
    
    # Ajoutez les groupes appservers et monitoring
```

---

### Étape 1.3 : Tester l'inventaire

```bash
# Lister tous les hosts de l'inventaire
ansible-inventory -i inventory.yml --list

# Vérifier la connectivité avec tous les serveurs (PING)
ansible all -i inventory.yml -m ping
```

**Résultat attendu** : Vous devriez voir "SUCCESS" en vert pour chaque serveur.

**En cas d'erreur** :
- Vérifiez que les containers Docker sont bien démarrés
- Vérifiez l'orthographe des noms de containers
- Vérifiez l'indentation YAML (2 espaces)

---

## Partie 2 : Créer votre premier playbook (20 min)

### Étape 2.1 : Créer le fichier playbook.yml

**Mission** : Créer un playbook qui configure tous les serveurs avec des outils de base.

**Tâches à réaliser dans votre playbook** :

1. **Afficher un message de bienvenue**
   - Module : `debug`
   - Afficher : "Hello depuis [nom du serveur]"

2. **Mettre à jour le cache APT**
   - Module : `apt`
   - Options : `update_cache: yes` et `cache_valid_time: 3600`

3. **Installer des outils de base**
   - Module : `apt`
   - Packages à installer : `curl`, `vim`, `htop`, `net-tools`
   - État : `present`

4. **Créer un fichier d'information**
   - Module : `copy`
   - Créer le fichier `/tmp/ansible-info.txt`
   - Contenu : Nom du serveur et date
   - Mode : `0644`

5. **Afficher le contenu du fichier créé**
   - Module : `command`
   - Commande : `cat /tmp/ansible-info.txt`
   - Enregistrer le résultat dans une variable `file_content`
   - Ajouter : `changed_when: false` (car c'est juste une lecture)

6. **Afficher les informations système**
   - Module : `debug`
   - Afficher : Distribution, version, architecture, mémoire

**Structure de base** :
```yaml
---
- name: Configuration basique des serveurs
  hosts: ???  # Sur quels serveurs ?
  become: ???  # Faut-il les droits root ? (true/false)

  tasks:
    - name: Afficher un message de bienvenue
      debug:
        msg: "👋 Hello depuis {{ ??? }}"
    
    - name: Mettre à jour le cache APT
      apt:
        update_cache: ???
        cache_valid_time: ???
    
    # Continuez avec les autres tâches...
```

**Variables Ansible utiles** :
- `{{ inventory_hostname }}` : Nom du serveur dans l'inventory
- `{{ ansible_host }}` : Nom du container Docker
- `{{ ansible_date_time.iso8601 }}` : Date/heure ISO
- `{{ ansible_distribution }}` : Nom de la distribution (Ubuntu)
- `{{ ansible_distribution_version }}` : Version (22.04)
- `{{ ansible_architecture }}` : Architecture (x86_64)
- `{{ ansible_memtotal_mb }}` : Mémoire totale en MB

---

### Étape 2.2 : Exécuter le playbook

```bash
# Exécuter le playbook sur tous les serveurs
ansible-playbook -i inventory.yml playbook.yml
```

**Résultat attendu** :
- Toutes les tâches doivent s'exécuter avec succès (status "ok" ou "changed")
- Vous devriez voir le message de bienvenue pour chaque serveur
- Les packages doivent être installés
- Le fichier `/tmp/ansible-info.txt` doit être créé

---

## Partie 3 : Playbook pour un groupe spécifique (10 min)

### Étape 3.1 : Créer playbook-webservers.yml

**Mission** : Créer un playbook qui configure UNIQUEMENT les serveurs web.

**Tâches à réaliser** :

1. Créer le répertoire `/var/www/html`
   - Module : `file`
   - Type : `directory`
   - Mode : `0755`

2. Créer une page HTML simple
   - Module : `copy`
   - Destination : `/var/www/html/index.html`
   - Contenu : Une page HTML qui affiche le nom du serveur
   - Mode : `0644`

**Indications** :
```yaml
---
- name: Configuration des serveurs web
  hosts: ???  # Quel groupe cibler ?
  become: true

  tasks:
    - name: Créer un répertoire web
      file:
        path: ???
        state: ???
        mode: ???
    
    - name: Créer une page web simple
      copy:
        content: |
          <!DOCTYPE html>
          <html>
          <head><title>{{ ??? }}</title></head>
          <body>
            <h1>Serveur Web: {{ ??? }}</h1>
            <p>Configuré avec Ansible</p>
          </body>
          </html>
        dest: ???
        mode: ???
```

**Exécution** :
```bash
ansible-playbook -i inventory.yml playbook-webservers.yml
```

---

## Partie 4 : Playbook avec variables (10 min)

### Étape 4.1 : Créer playbook-avec-variables.yml

**Mission** : Créer un playbook avec des variables personnalisées pour les serveurs de base de données.

**Variables à définir** :
- `db_port: 5432`
- `db_name: production`
- `admin_email: admin@example.com`

**Tâches à réaliser** :

1. Créer un fichier de configuration `/etc/db-config.conf`
   - Utiliser les variables définies
   - Inclure aussi le nom du serveur

2. Afficher le contenu du fichier créé

**Indications** :
```yaml
---
- name: Configuration avec variables
  hosts: ???  # Groupe databases
  become: true

  vars:
    db_port: ???
    db_name: ???
    admin_email: ???

  tasks:
    - name: Créer un fichier de configuration
      copy:
        content: |
          # Configuration de base de données
          DB_PORT={{ ??? }}
          DB_NAME={{ ??? }}
          ADMIN_EMAIL={{ ??? }}
          HOSTNAME={{ ??? }}
        dest: ???
        mode: ???
    
    # Ajoutez une tâche pour lire et afficher le fichier
```

---

## Tests et Vérifications

### Vérifier que tout fonctionne

```bash
# Vérifier que curl est installé partout
ansible all -i inventory.yml -m command -a "curl --version"

# Vérifier le fichier ansible-info.txt
ansible all -i inventory.yml -m command -a "cat /tmp/ansible-info.txt"

# Vérifier les pages web (serveurs web uniquement)
ansible webservers -i inventory.yml -m command -a "cat /var/www/html/index.html"

# Vérifier la configuration DB (serveurs de base de données uniquement)
ansible databases -i inventory.yml -m command -a "cat /etc/db-config.conf"
```

---

## Commandes ad-hoc utiles à essayer

```bash
# Vérifier la version d'Ubuntu sur tous les serveurs
ansible all -i inventory.yml -m command -a "cat /etc/os-release"

# Voir l'espace disque
ansible all -i inventory.yml -m command -a "df -h"

# Créer un fichier sur tous les serveurs
ansible all -i inventory.yml -m copy -a "content='Test Ansible' dest=/tmp/test.txt"

# Lire le fichier créé
ansible all -i inventory.yml -m command -a "cat /tmp/test.txt"

# Supprimer le fichier
ansible all -i inventory.yml -m file -a "path=/tmp/test.txt state=absent"
```

---

## Nettoyage

```bash
# Supprimer les fichiers de test
ansible all -i inventory.yml -m file -a "path=/tmp/ansible-info.txt state=absent"

# Arrêter l'infrastructure de test
cd ..
docker-compose -f docker-compose-lab.yml down

# Supprimer les volumes (optionnel)
docker-compose -f docker-compose-lab.yml down -v
```

---

## Checklist de validation ✅

Avant de passer à la suite, assurez-vous que :

- [ ] Votre inventory contient bien les 4 groupes avec tous les serveurs
- [ ] La commande `ansible all -i inventory.yml -m ping` fonctionne pour tous les serveurs
- [ ] Votre playbook principal s'exécute sans erreur
- [ ] Les outils (curl, vim, htop, net-tools) sont installés sur tous les serveurs
- [ ] Le playbook webservers ne s'exécute QUE sur les serveurs web
- [ ] Les pages HTML sont créées sur les serveurs web
- [ ] La configuration DB est créée sur les serveurs de base de données
- [ ] Vous savez exécuter des commandes ad-hoc

---

## Aide et astuces 💡

### Problèmes courants

**Erreur "Could not match supplied host pattern"**
- Vérifiez l'indentation de votre inventory.yml
- Assurez-vous que tous les groupes sont sous `children:`

**Erreur de connexion Docker**
- Vérifiez que les containers sont bien démarrés : `docker ps | grep ansible-lab`
- Redémarrez les containers si nécessaire

**Erreur APT "Unable to acquire the dpkg frontend lock"**
- Attendez 30 secondes après le démarrage des containers
- Les containers doivent finir leur initialisation

**Playbook qui ne fait rien**
- Vérifiez que `hosts:` cible le bon groupe ou `all`
- Vérifiez que `become: true` est défini si vous avez besoin des droits root

---

## Pour aller plus loin 🚀

Une fois l'exercice terminé, essayez de :

1. Créer un playbook qui installe nginx sur les webservers
2. Utiliser des handlers pour redémarrer des services
3. Créer des templates Jinja2 pour les fichiers de configuration
4. Organiser vos variables dans des fichiers séparés (group_vars/)
5. Créer votre premier rôle Ansible

---

## Ressources

- [Documentation Ansible Inventory](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html)
- [Documentation Ansible Playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html)
- [Liste des modules Ansible](https://docs.ansible.com/ansible/latest/collections/index_module.html)

**Correction disponible** : `exercice-basique-ansible.md` (à consulter après avoir terminé l'exercice)

---

**Bon courage ! 🎉**
