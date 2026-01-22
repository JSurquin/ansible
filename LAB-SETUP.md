# 🚀 Guide de démarrage du Lab Ansible

Ce guide vous permet de démarrer rapidement votre environnement de test pour la formation Ansible.

## 🎯 Objectif

Créer 10 serveurs Linux simulés avec Docker pour pratiquer Ansible sans avoir besoin de vraies machines virtuelles.

## 📋 Prérequis

- Docker et Docker Compose installés
- Ansible installé (`pip install ansible`)
- Collection Docker pour Ansible : `ansible-galaxy collection install community.docker`

## 🔧 Installation rapide

### 1. Démarrer l'infrastructure

```bash
# Lancer les 10 "serveurs" de test
docker-compose -f docker-compose-lab.yml up -d

# Vérifier que tous les containers sont up
docker ps
```

Vous devriez voir 10 containers :
- 3 serveurs web (web01, web02, web03)
- 2 serveurs de base de données (db01, db02)
- 3 serveurs applicatifs (app01, app02, app03)
- 2 serveurs de monitoring (monitor01, monitor02)

### 2. Tester la connexion Ansible

```bash
# Ping tous les serveurs avec Ansible
ansible -i inventory-lab.yml all -m ping

# Lister l'inventaire
ansible-inventory -i inventory-lab.yml --graph

# Tester une commande sur tous les serveurs web
ansible -i inventory-lab.yml webservers -m command -a "hostname"
```

### 3. Premier playbook de test

```bash
# Créer un fichier test.yml
cat > test.yml << 'EOF'
---
- name: Test de connexion
  hosts: all
  tasks:
    - name: Afficher le hostname
      command: hostname
      register: result
    
    - name: Montrer le résultat
      debug:
        msg: "Serveur: {{ inventory_hostname }} - Hostname: {{ result.stdout }}"
EOF

# Exécuter le playbook
ansible-playbook -i inventory-lab.yml test.yml
```

## 🎓 Structure de l'infrastructure

```
┌─────────────────────────────────────────┐
│         Ansible Control Node            │
│         (Votre machine)                  │
└────────────────┬────────────────────────┘
                 │
         ┌───────┴───────┐
         │ Docker Network │
         └───────┬────────┘
                 │
    ┌────────────┼────────────┐
    │            │            │
┌───▼───┐   ┌───▼───┐   ┌───▼────┐
│ Web   │   │  DB   │   │  App   │
│Servers│   │Servers│   │Servers │
│(3)    │   │(2)    │   │(3)     │
└───────┘   └───────┘   └────────┘
```

## 📚 Groupes disponibles

- **webservers** : web01, web02, web03
- **databases** : db01, db02
- **appservers** : app01, app02, app03
- **monitoring** : monitor01, monitor02
- **production** : webservers + databases + appservers
- **infrastructure** : monitoring

## 🧪 Exemples de commandes utiles

```bash
# Mettre à jour tous les serveurs
ansible -i inventory-lab.yml all -m apt -a "update_cache=yes" -b

# Installer un package sur les serveurs web
ansible -i inventory-lab.yml webservers -m apt -a "name=nginx state=present" -b

# Vérifier l'espace disque
ansible -i inventory-lab.yml all -m command -a "df -h"

# Redémarrer tous les serveurs de base de données
ansible -i inventory-lab.yml databases -m reboot -b
```

## 🛑 Arrêter le lab

```bash
# Arrêter tous les containers
docker-compose -f docker-compose-lab.yml down

# Arrêter ET supprimer les volumes (reset complet)
docker-compose -f docker-compose-lab.yml down -v
```

## 🐛 Dépannage

### Les containers ne démarrent pas
```bash
# Vérifier les logs
docker-compose -f docker-compose-lab.yml logs

# Redémarrer un container spécifique
docker restart ansible-lab-web01
```

### Ansible ne se connecte pas
```bash
# Vérifier que les containers sont up
docker ps | grep ansible-lab

# Se connecter manuellement à un container
docker exec -it ansible-lab-web01 bash

# Vérifier Python dans un container
docker exec ansible-lab-web01 python3 --version
```

### Reset complet
```bash
# Tout supprimer et recommencer
docker-compose -f docker-compose-lab.yml down -v
docker-compose -f docker-compose-lab.yml up -d
```

## 💡 Conseils

- **Destructible** : N'hésitez pas à tout casser ! Vous pouvez tout recréer en 30 secondes
- **Pratique** : Testez vos playbooks sur quelques serveurs avant de les appliquer à tous
- **Groupes** : Utilisez les groupes pour cibler des ensembles de serveurs
- **Logs** : `docker logs ansible-lab-web01` pour déboguer

## 🎯 Prêt pour la formation !

Votre environnement est maintenant prêt. Vous pouvez :
1. Suivre les exercices de la formation
2. Expérimenter avec vos propres playbooks
3. Tester des configurations sans risque

**Bon apprentissage avec Ansible !** 🚀
