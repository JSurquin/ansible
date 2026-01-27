# 📖 Explications détaillées de la correction

## Vue d'ensemble

Cette correction illustre une architecture Ansible complète et professionnelle. Voici pourquoi chaque élément est organisé de cette façon.

---

## 🗂️ Structure du projet

### 1. `group_vars/all.yml` - Variables globales

```yaml
ansible_connection: docker
apache_port: 80
nginx_port: 8080
```

**Pourquoi ici ?**
- ✅ Variables communes à **tous** les serveurs
- ✅ Un seul endroit pour modifier une config globale
- ✅ `ansible_connection: docker` s'applique à tous les hosts

**Alternative possible** :
- Variables dans chaque inventaire (moins DRY)
- Variables dans les playbooks (moins réutilisable)

---

### 2. `inventories/` - Séparation des inventaires

**Pourquoi 2 inventaires distincts ?**

```
inventories/
├── apache2.yml  → Serveurs Apache uniquement
└── nginx.yml    → Serveurs Nginx uniquement
```

**Avantages** :
- ✅ Déploiement indépendant : `ansible-playbook -i inventories/apache2.yml ...`
- ✅ Groupes logiques : `apache_servers` vs `nginx_servers`
- ✅ Flexibilité : Différentes variables par groupe

**Scénario réel** :
```bash
# Déployer uniquement les serveurs web en production
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml

# Déployer uniquement les serveurs d'API
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml
```

**Structure des inventaires** :
```yaml
all:
  children:
    apache_servers:      # Nom du groupe
      hosts:
        apache1:         # Nom logique
          ansible_host: apache-server-1  # Nom du container Docker
          server_id: 1   # Variable spécifique au host
```

---

### 3. `playbooks/` - Playbooks dédiés

**Pourquoi un playbook par type de serveur ?**

```
playbooks/
├── play-apache2.yml  → Configure Apache
└── play-nginx.yml    → Configure Nginx
```

**Avantages** :
- ✅ Responsabilité unique (Single Responsibility Principle)
- ✅ Réutilisabilité
- ✅ Maintenance simplifiée

**Structure d'un playbook** :
```yaml
- name: Configuration des serveurs Apache2
  hosts: apache_servers    # Cible le groupe de l'inventaire
  become: yes              # Exécute avec sudo
  roles:
    - apache2              # Applique le rôle apache2
```

**Pourquoi `become: yes` ?**
- Installation de packages → Nécessite les droits root
- Modification de `/etc/` → Nécessite les droits root
- Démarrage de services → Nécessite les droits root

---

### 4. `roles/` - Organisation en rôles

**Architecture d'un rôle** :
```
roles/apache2/
├── tasks/          → Quoi faire
├── handlers/       → Réactions aux changements
├── templates/      → Fichiers dynamiques
└── vars/           → Variables du rôle
```

#### 4.1 `tasks/main.yml` - Les actions

```yaml
- name: Installer Apache2
  apt:
    name: "{{ apache_package }}"
    state: present

- name: Déployer la configuration
  template:
    src: apache2.conf.j2
    dest: "{{ apache_config_path }}"
  notify: restart apache2  # ← Déclenche le handler
```

**Concepts clés** :
- **Ordre d'exécution** : De haut en bas
- **Idempotence** : Peut être ré-exécuté sans effets de bord
- **Modules** : `apt`, `template`, `service`, `file`
- **Notify** : Déclenche un handler si changement

#### 4.2 `handlers/main.yml` - Les réactions

```yaml
- name: restart apache2
  service:
    name: "{{ apache_service }}"
    state: restarted
```

**Pourquoi les handlers ?**
- ✅ Ne redémarre QUE si config modifiée
- ✅ Exécuté UNE SEULE fois à la fin (même si notifié plusieurs fois)
- ✅ Performance optimisée

**Exemple** :
```
1. Modification de apache2.conf → notify "restart apache2"
2. Modification de index.html → (pas de notify)
3. Fin du playbook → Handler "restart apache2" exécuté UNE fois
```

#### 4.3 `templates/` - Fichiers dynamiques

**Template Jinja2** (`apache2.conf.j2`) :
```apache
<VirtualHost *:{{ apache_port }}>
    ServerName {{ apache_server_name }}
    DocumentRoot {{ apache_document_root }}
    # Hostname: {{ ansible_hostname }}
</VirtualHost>
```

**Avantages** :
- ✅ Configuration dynamique par serveur
- ✅ Utilise les variables Ansible
- ✅ Accès aux facts (`ansible_hostname`, etc.)

**Rendu sur apache1** :
```apache
<VirtualHost *:80>
    ServerName apache.local
    DocumentRoot /var/www/html
    # Hostname: apache1
</VirtualHost>
```

**Rendu sur apache2** :
```apache
<VirtualHost *:80>
    ServerName apache.local
    DocumentRoot /var/www/html
    # Hostname: apache2
</VirtualHost>
```

#### 4.4 `vars/main.yml` - Variables du rôle

```yaml
apache_package: apache2
apache_service: apache2
apache_document_root: /var/www/html
```

**Pourquoi ici et pas dans `group_vars/` ?**
- ✅ Variables spécifiques au rôle Apache
- ✅ Portabilité : Le rôle peut être réutilisé ailleurs
- ✅ Encapsulation : Les détails internes du rôle restent dans le rôle

**Hiérarchie des variables** (du moins prioritaire au plus prioritaire) :
1. `roles/*/vars/main.yml`
2. `group_vars/all.yml`
3. `inventories/*/hosts` (variables de host)
4. Variables en ligne de commande : `-e "apache_port=8080"`

---

## 🔄 Flux d'exécution complet

Quand vous lancez :
```bash
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml
```

**Voici ce qui se passe** :

### Étape 1 : Lecture de l'inventaire
```
inventories/apache2.yml
↓
Charge les hosts : apache1, apache2
Lit ansible_host : apache-server-1, apache-server-2
```

### Étape 2 : Lecture des variables globales
```
group_vars/all.yml
↓
ansible_connection: docker
apache_port: 80
nginx_port: 8080
```

### Étape 3 : Lecture du playbook
```
playbooks/play-apache2.yml
↓
Cible : apache_servers
Rôle à appliquer : apache2
```

### Étape 4 : Chargement du rôle
```
roles/apache2/
↓
Charge vars/main.yml (variables)
Charge tasks/main.yml (actions)
Charge handlers/main.yml (réactions)
Prépare templates/ (fichiers dynamiques)
```

### Étape 5 : Exécution des tasks sur apache1
```
1. Mettre à jour APT
2. Installer Apache2
3. Créer /var/www/html
4. Générer apache2.conf depuis le template
   → Si modifié : note "restart apache2" dans la queue
5. Générer index.html depuis le template
6. Démarrer Apache2
```

### Étape 6 : Exécution des tasks sur apache2
```
(Même processus que apache1)
```

### Étape 7 : Exécution des handlers
```
Si "restart apache2" a été notifié :
  → Redémarrage d'Apache sur les serveurs concernés
```

---

## 🎯 Concepts Ansible illustrés

### 1. Idempotence

**Première exécution** :
```
TASK [apache2 : Installer Apache2]
changed: [apache1]
changed: [apache2]
```

**Deuxième exécution** :
```
TASK [apache2 : Installer Apache2]
ok: [apache1]  ← Déjà installé, rien à faire
ok: [apache2]  ← Déjà installé, rien à faire
```

### 2. Variables et facts

**Variables définies** :
- `apache_port: 80` (group_vars)
- `server_id: 1` (inventaire)

**Facts collectés automatiquement** :
- `ansible_hostname`: "apache1"
- `ansible_distribution`: "Ubuntu"
- `ansible_distribution_version`: "22.04"

**Utilisation dans les templates** :
```jinja
<h1>Serveur {{ ansible_hostname }}</h1>
<p>Port: {{ apache_port }}</p>
<p>ID: {{ server_id }}</p>
```

### 3. Séparation des responsabilités

```
group_vars/     → Configuration globale
inventories/    → Définition des serveurs
playbooks/      → Orchestration
roles/          → Logique métier
  ├── tasks/    → Actions
  ├── handlers/ → Réactions
  ├── templates/→ Fichiers dynamiques
  └── vars/     → Configuration du rôle
```

---

## 🐳 Intégration Docker

### Configuration dans `group_vars/all.yml`

```yaml
ansible_connection: docker
```

**Ce que ça fait** :
- Au lieu de SSH → Utilise l'API Docker
- Au lieu de `ssh user@host` → Utilise `docker exec container`

### Équivalence

**Commande Ansible** :
```bash
ansible -i inventories/apache2.yml apache1 -m command -a "hostname"
```

**Équivalent Docker** :
```bash
docker exec apache-server-1 hostname
```

**Pourquoi c'est transparent ?**
- Ansible abstrait la connexion
- Le reste du code est identique
- En prod, changez juste `ansible_connection: ssh`

---

## 🔐 Bonnes pratiques appliquées

### ✅ 1. Organisation claire
```
correction/
├── group_vars/      # Global
├── inventories/     # Serveurs
├── playbooks/       # Orchestration
└── roles/           # Logique
```

### ✅ 2. Nommage descriptif
- `play-apache2.yml` (pas `playbook1.yml`)
- `apache_servers` (pas `group1`)
- `restart apache2` (pas `handler1`)

### ✅ 3. Variables réutilisables
```yaml
apache_package: apache2
```
Permet de changer facilement pour `httpd` sur RedHat.

### ✅ 4. Templates pour la configuration
- Pas de fichiers statiques
- Configuration dynamique
- Adapte selon le serveur

### ✅ 5. Handlers pour l'efficacité
- Redémarre uniquement si nécessaire
- Exécuté une seule fois

### ✅ 6. Idempotence garantie
- Modules Ansible idempotents (`apt`, `service`, etc.)
- Peut être ré-exécuté sans risque

### ✅ 7. Séparation des environnements
- Inventaires distincts = déploiements indépendants
- Facilite la gestion multi-environnement (dev/staging/prod)

---

## 💡 Pourquoi cette architecture ?

### Scalabilité
```bash
# Ajouter 10 serveurs Nginx ?
# → Juste ajouter les entrées dans inventories/nginx.yml
# → Le playbook et les rôles restent identiques
```

### Réutilisabilité
```bash
# Utiliser le rôle Apache sur un autre projet ?
# → Copier roles/apache2/ dans le nouveau projet
# → Ajuster les variables
```

### Maintenabilité
```bash
# Modifier la config Apache ?
# → Un seul fichier : roles/apache2/templates/apache2.conf.j2
# → S'applique automatiquement à tous les serveurs
```

### Testabilité
```bash
# Tester en local avec Docker
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml

# Déployer en prod avec SSH
# → Changer ansible_connection: ssh dans group_vars/
# → Même playbook, même rôles
```

---

## 🎓 Exercices de compréhension

### Exercice 1 : Modifier le port Apache
1. Changer `apache_port: 80` → `apache_port: 8888` dans `group_vars/all.yml`
2. Ré-exécuter le playbook
3. Observer que le handler est déclenché
4. Vérifier la nouvelle config dans le container

### Exercice 2 : Ajouter une variable
1. Ajouter `company: "MonEntreprise"` dans `group_vars/all.yml`
2. Modifier `roles/apache2/templates/index.html.j2` pour afficher la variable
3. Ré-exécuter le playbook
4. Vérifier la page web

### Exercice 3 : Créer un nouveau rôle
1. Créer `roles/mysql/` avec la même structure
2. Créer un inventaire `inventories/mysql.yml`
3. Créer un playbook `playbooks/play-mysql.yml`
4. Tester

---

## 📚 Pour aller plus loin

### Concepts non couverts ici
- **Ansible Vault** : Chiffrement des secrets
- **Tags** : Exécution sélective de tasks
- **Blocks et error handling** : Gestion d'erreurs avancée
- **Delegation** : Exécuter des tasks sur un autre host
- **Lookups et filters** : Manipulation avancée de données

### Ressources
- [Documentation Ansible officielle](https://docs.ansible.com)
- [Ansible Galaxy](https://galaxy.ansible.com) : Rôles communautaires
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

---

✅ **Vous comprenez maintenant chaque élément de cette correction et pourquoi il est organisé ainsi !**
