# 🚀 Guide de démarrage du Lab Ansible

Ce guide vous permet de démarrer rapidement votre environnement de test pour la formation Ansible.

## 🎯 Objectif

Créer 10 serveurs Linux simulés avec Docker pour pratiquer Ansible sans avoir besoin de vraies machines virtuelles.

## 📋 Prérequis

- Docker et Docker Compose installés
- Ansible installé (`pip install ansible`)
- Collection Docker pour Ansible : `ansible-galaxy collection install community.docker`

## 🔧 Installation rapide

⚠️ **IMPORTANT** : L'installation des containers peut prendre **5 à 10 minutes** au premier démarrage (installation de SSH, Python3, sudo). Le temps varie selon votre connexion internet.

### Option 1 : Script automatique (Recommandé)

```bash
# Utiliser le script qui attend automatiquement
chmod +x wait-for-lab.sh
./wait-for-lab.sh

# Le script:
# - Lance les 10 containers
# - Attend qu'ils soient tous prêts
# - Affiche le temps total
```

### Option 2 : Démarrage manuel

```bash
# 1. Lancer les 10 "serveurs" de test
docker-compose -f docker-compose-lab.yml up -d

# 2. Attendre 5-10 minutes (installation en cours)
# Vous pouvez suivre l'installation:
docker logs -f ansible-lab-web01

# 3. Vérifier que tous les containers sont up
docker ps
```

Vous devriez voir 10 containers :
- 3 serveurs web (web01, web02, web03)
- 2 serveurs de base de données (db01, db02)
- 3 serveurs applicatifs (app01, app02, app03)
- 2 serveurs de monitoring (monitor01, monitor02)

### 2. Vérifier que les containers sont PRÊTS

⚠️ **CRITIQUE** : Les containers doivent avoir fini d'installer Python3/SSH

```bash
# Tester la connexion Ansible (DOIT RÉUSSIR sur tous)
ansible -i inventory-lab.yml all -m ping

# ❌ Si vous voyez "python3: not found" :
#    → Les containers installent encore les packages
#    → Attendez 2-3 minutes et réessayez

# ✅ Si tous répondent "SUCCESS => pong" :
#    → Le lab est prêt !
```

**Combien de temps attendre ?**
- 1ère fois : **5-10 minutes** (dépend du réseau)
- Fois suivantes : **2-3 minutes** (si cache Docker)
- Avec images pré-construites : **<30 secondes**

### 3. Commandes de vérification

```bash
# Lister l'inventaire
ansible-inventory -i inventory-lab.yml --graph

# Tester une commande sur tous les serveurs web
ansible -i inventory-lab.yml webservers -m command -a "hostname"

# Vérifier Python3 dans un container
docker exec ansible-lab-web01 python3 --version
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
