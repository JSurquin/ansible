# Commandes essentielles - Correction exercice Ansible

## 🚀 Démarrage rapide

```bash
# 1. Lancer l'infrastructure
docker-compose up -d

# 2. Déployer Apache2
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml

# 3. Déployer Nginx
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml

# 4. Lancer tous les tests automatiques
./test.sh
```

## 📋 Commandes détaillées

### Gestion Docker

```bash
# Démarrer les containers
docker-compose up -d

# Voir les logs
docker-compose logs -f

# Arrêter les containers
docker-compose stop

# Arrêter et supprimer
docker-compose down

# Liste des containers
docker ps

# Entrer dans un container
docker exec -it apache-server-1 bash
docker exec -it nginx-server-1 bash
```

### Ansible - Inventaires

```bash
# Lister tous les hosts Apache
ansible -i inventories/apache2.yml all --list-hosts

# Lister tous les hosts Nginx
ansible -i inventories/nginx.yml all --list-hosts

# Afficher l'inventaire en détail
ansible-inventory -i inventories/apache2.yml --list
ansible-inventory -i inventories/nginx.yml --graph
```

### Ansible - Tests de connectivité

```bash
# Ping tous les serveurs Apache
ansible -i inventories/apache2.yml all -m ping

# Ping tous les serveurs Nginx
ansible -i inventories/nginx.yml all -m ping

# Tester une commande ad-hoc
ansible -i inventories/apache2.yml all -m command -a "hostname"
```

### Ansible - Exécution des playbooks

```bash
# Mode normal
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml

# Mode check (dry-run, ne fait rien)
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml --check

# Mode diff (affiche les changements)
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml --diff

# Mode verbose (-v, -vv, -vvv, -vvvv)
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml -v
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml -vvv

# Cibler un seul host
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml --limit apache1

# Démarrer à partir d'une task spécifique
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml --start-at-task="Installer Nginx"
```

### Ansible - Variables

```bash
# Afficher toutes les variables d'un host
ansible -i inventories/apache2.yml apache1 -m debug -a "var=hostvars[inventory_hostname]"

# Afficher les facts
ansible -i inventories/apache2.yml apache1 -m setup

# Afficher une variable spécifique
ansible -i inventories/apache2.yml apache1 -m debug -a "var=ansible_hostname"
```

### Vérification des services

```bash
# Apache
docker exec apache-server-1 service apache2 status
docker exec apache-server-1 curl http://localhost

# Nginx
docker exec nginx-server-1 service nginx status
docker exec nginx-server-1 curl http://localhost:8080

# Voir les logs
docker exec apache-server-1 cat /var/log/apache2/error.log
docker exec nginx-server-1 cat /var/log/nginx/error.log
```

### Tests depuis l'hôte

```bash
# Accéder aux pages Nginx depuis votre machine
curl http://localhost:8080  # Nginx 1
curl http://localhost:8081  # Nginx 2

# Ou ouvrir dans le navigateur
open http://localhost:8080  # macOS
xdg-open http://localhost:8080  # Linux
```

### Commandes utiles pour déboguer

```bash
# Vérifier la syntaxe du playbook
ansible-playbook --syntax-check -i inventories/apache2.yml playbooks/play-apache2.yml

# Lister les tasks sans les exécuter
ansible-playbook --list-tasks -i inventories/nginx.yml playbooks/play-nginx.yml

# Afficher les hosts ciblés
ansible-playbook --list-hosts -i inventories/apache2.yml playbooks/play-apache2.yml

# Exécuter en mode step by step
ansible-playbook --step -i inventories/nginx.yml playbooks/play-nginx.yml
```

### Gestion des rôles

```bash
# Lister les rôles disponibles
ls -la roles/

# Structure d'un rôle
tree roles/apache2/
tree roles/nginx/

# Tester uniquement un rôle
ansible -i inventories/apache2.yml apache1 -m include_role -a name=apache2
```

### Nettoyage

```bash
# Supprimer tous les containers
docker-compose down

# Supprimer containers + volumes
docker-compose down -v

# Nettoyer les images Docker non utilisées
docker system prune -a
```

## 🔧 Tests d'idempotence

```bash
# Première exécution (doit faire des changements)
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml

# Deuxième exécution (ne doit rien changer)
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml

# Vérifier le résultat : "changed=0" = idempotent ✅
```

## 📊 Analyse des performances

```bash
# Mesurer le temps d'exécution
time ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml

# Profiler les tasks (plus lentes en premier)
ANSIBLE_CALLBACK_WHITELIST=profile_tasks ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml
```

## 🎯 Scénarios de test

### Scénario 1 : Déploiement initial
```bash
docker-compose up -d
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml
```

### Scénario 2 : Modification de configuration
```bash
# Modifier group_vars/all.yml (ex: changer apache_port)
# Ré-exécuter le playbook
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml
# Vérifier que le handler a été déclenché
```

### Scénario 3 : Ajout d'un nouveau serveur
```bash
# Ajouter apache3 dans inventories/apache2.yml
# Ajouter le service dans docker-compose.yml
docker-compose up -d
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml --limit apache3
```

### Scénario 4 : Recovery après suppression
```bash
# Supprimer Apache d'un container
docker exec apache-server-1 apt-get remove -y apache2
# Ré-exécuter le playbook pour restaurer
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml --limit apache1
```

## 💡 Astuces

```bash
# Créer un alias pour les commandes longues
alias ap-apache='ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml'
alias ap-nginx='ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml'

# Utiliser
ap-apache
ap-nginx

# Variable d'environnement pour le mode verbose permanent
export ANSIBLE_STDOUT_CALLBACK=yaml
export ANSIBLE_VERBOSITY=1
```

---

📝 **Note** : Toutes ces commandes doivent être exécutées depuis le dossier `correction/`
