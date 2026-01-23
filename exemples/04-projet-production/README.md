# Exemple 4 : Projet Production Complet

## 📖 Description

Projet complet prêt pour la production avec :
- Structure professionnelle
- Plusieurs environnements (staging/production)
- Plusieurs rôles organisés
- Ansible Vault pour les secrets
- Bonnes pratiques DevOps

## 📁 Structure

```
04-projet-production/
├── README.md
├── ansible.cfg                    # Configuration Ansible
├── site.yml                       # Playbook principal
├── inventories/                   # Inventaires par environnement
│   ├── production/
│   │   └── hosts.yml
│   └── staging/
│       └── hosts.yml
├── group_vars/                    # Variables par groupe
│   ├── all.yml                    # Variables globales
│   ├── production.yml             # Variables production
│   └── staging.yml                # Variables staging
├── host_vars/                     # Variables par serveur
│   └── web01.yml
├── playbooks/                     # Playbooks spécifiques
│   ├── deploy.yml
│   ├── backup.yml
│   └── monitoring.yml
├── roles/                         # Rôles réutilisables
│   ├── common/                    # Configuration commune
│   ├── nginx/                     # Serveur web
│   ├── app/                       # Application
│   └── monitoring/                # Monitoring
└── secrets.yml                    # Secrets chiffrés (Vault)
```

## 🎯 Objectifs

Montrer une organisation complète :
- ✅ Séparation des environnements
- ✅ Variables hiérarchiques
- ✅ Rôles modulaires
- ✅ Gestion des secrets
- ✅ Playbooks spécialisés
- ✅ Configuration centralisée

## 🚀 Utilisation

```bash
# Déploiement en staging
ansible-playbook -i inventories/staging site.yml

# Déploiement en production
ansible-playbook -i inventories/production site.yml

# Déploiement avec tags
ansible-playbook -i inventories/staging site.yml --tags "nginx,app"

# Playbook spécifique
ansible-playbook -i inventories/production playbooks/deploy.yml

# Avec secrets Vault
ansible-playbook -i inventories/production site.yml --ask-vault-pass
```

## 📚 Concepts abordés

- ✅ Structure projet production
- ✅ Multi-environnements
- ✅ Hiérarchie des variables
- ✅ Ansible Vault
- ✅ Tags pour exécution sélective
- ✅ Playbooks spécialisés
- ✅ Configuration centralisée (ansible.cfg)
- ✅ Rôles avec dépendances
