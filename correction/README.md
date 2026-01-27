# Correction - Exercice de groupe Ansible

## 📋 Description

Cette correction met en place une infrastructure Ansible complète avec :
- **2 serveurs Apache2** (apache1, apache2)
- **2 serveurs Nginx** (nginx1, nginx2)
- Des playbooks dédiés pour chaque type de serveur
- Des rôles complets avec tasks, handlers, templates et variables
- Configuration Docker pour tests

## 🏗️ Structure du projet

```
correction/
├── ansible.cfg                 # Configuration Ansible (chemins des rôles)
├── group_vars/
│   └── all.yml                 # Variables globales (ansible_connection: docker)
├── inventories/
│   ├── apache2.yml             # Inventaire des serveurs Apache2
│   └── nginx.yml               # Inventaire des serveurs Nginx
├── playbooks/
│   ├── play-apache2.yml        # Playbook Apache2
│   └── play-nginx.yml          # Playbook Nginx
├── roles/
│   ├── apache2/
│   │   ├── tasks/main.yml
│   │   ├── handlers/main.yml
│   │   ├── templates/
│   │   │   ├── apache2.conf.j2
│   │   │   └── index.html.j2
│   │   └── vars/main.yml
│   └── nginx/
│       ├── tasks/main.yml
│       ├── handlers/main.yml
│       ├── templates/
│       │   ├── nginx.conf.j2
│       │   └── index.html.j2
│       └── vars/main.yml
├── docker-compose.yml          # Infrastructure de test
└── README.md                   # Ce fichier
```

## 🚀 Installation et test

### 1. Lancer l'infrastructure Docker

```bash
# Depuis le dossier correction/
docker-compose up -d

# Vérifier que les 4 containers sont en cours d'exécution
docker ps
```

### 2. Exécuter les playbooks Apache2

```bash
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml
```

### 3. Exécuter les playbooks Nginx

```bash
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml
```

### 4. Vérifier les déploiements

#### Tester Apache2
```bash
# Entrer dans un container Apache
docker exec -it apache-server-1 bash

# Vérifier le service
service apache2 status

# Tester la page web
curl http://localhost

# Sortir du container
exit
```

#### Tester Nginx
```bash
# Entrer dans un container Nginx
docker exec -it nginx-server-1 bash

# Vérifier le service
service nginx status

# Tester la page web
curl http://localhost:8080

# Sortir du container
exit
```

#### Accéder depuis votre navigateur
- Nginx 1: http://localhost:8080
- Nginx 2: http://localhost:8081

## 🎯 Points clés de la correction

### 1. Configuration Ansible (ansible.cfg)
```ini
[defaults]
roles_path = ./roles
host_key_checking = False
stdout_callback = yaml
```
Définit les chemins et options Ansible pour le projet.

### 2. Configuration Docker (group_vars/all.yml)
```yaml
ansible_connection: docker
```
Cette configuration permet à Ansible de gérer les containers comme des serveurs.

### 3. Inventaires séparés
- **apache2.yml** : Définit le groupe `apache_servers` avec apache1 et apache2
- **nginx.yml** : Définit le groupe `nginx_servers` avec nginx1 et nginx2

### 4. Playbooks dédiés
- **play-apache2.yml** : Cible `apache_servers` et applique le rôle `apache2`
- **play-nginx.yml** : Cible `nginx_servers` et applique le rôle `nginx`

### 5. Rôles complets
Chaque rôle contient :
- **tasks/main.yml** : Installation et configuration du service
- **handlers/main.yml** : Gestion du redémarrage/rechargement
- **templates/** : Configurations dynamiques avec Jinja2
- **vars/main.yml** : Variables spécifiques au rôle

### 6. Templates Jinja2
Les templates utilisent des variables pour :
- Personnaliser les configurations (ports, chemins, etc.)
- Afficher des informations dynamiques (hostname, IP, etc.)
- Créer des pages HTML personnalisées par serveur

### 7. Handlers
Les handlers sont déclenchés uniquement si un changement est détecté (idempotence).

## 🔧 Commandes utiles

### Tester l'inventaire
```bash
# Lister les hosts Apache
ansible -i inventories/apache2.yml all --list-hosts

# Lister les hosts Nginx
ansible -i inventories/nginx.yml all --list-hosts

# Tester la connexion
ansible -i inventories/apache2.yml all -m ping
```

### Mode check (dry-run)
```bash
# Tester sans appliquer les changements
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml --check
```

### Mode verbose
```bash
# Afficher plus de détails
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml -v
```

## 🧹 Nettoyage

```bash
# Arrêter et supprimer tous les containers
docker-compose down

# Supprimer également les volumes
docker-compose down -v
```

## 📚 Concepts Ansible utilisés

1. **Inventaires** : Organisation des serveurs en groupes
2. **Playbooks** : Orchestration des déploiements
3. **Rôles** : Réutilisation et organisation du code
4. **Variables** : Personnalisation des configurations
5. **Templates** : Génération dynamique de fichiers
6. **Handlers** : Gestion des redémarrages
7. **Modules** : apt, service, file, template
8. **Idempotence** : Exécutions répétées sans effets de bord

## 💡 Points d'attention

- Les containers doivent être lancés **avant** l'exécution des playbooks
- Python3 est automatiquement installé dans les containers au démarrage
- `ansible_connection: docker` est défini dans `group_vars/all.yml`
- Les ports Nginx sont exposés pour test depuis le navigateur
- Apache écoute sur le port 80 (interne aux containers)
- Nginx écoute sur le port 8080 (mappé vers l'hôte)

## 🎓 Exercices complémentaires

1. Ajouter une variable pour le message de bienvenue dans les pages HTML
2. Créer un nouveau rôle pour installer MySQL
3. Ajouter des tasks pour gérer les logs
4. Implémenter la gestion des certificats SSL
5. Créer un playbook qui déploie les deux rôles simultanément

---

✅ **Correction validée et testée avec Ansible 2026 et Docker**
