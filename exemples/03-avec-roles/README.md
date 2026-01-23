# Exemple 3 : Avec Rôles

## 📖 Description

Exemple avancé montrant l'organisation du code avec des rôles réutilisables.

## 📁 Structure

```
03-avec-roles/
├── README.md
├── inventory.yml
├── playbook.yml
└── roles/
    └── nginx/
        ├── tasks/
        │   └── main.yml       # Tâches du rôle
        ├── handlers/
        │   └── main.yml       # Handlers du rôle
        ├── templates/
        │   ├── nginx.conf.j2
        │   └── vhost.conf.j2
        ├── defaults/
        │   └── main.yml       # Variables par défaut
        └── meta/
            └── main.yml       # Métadonnées du rôle
```

## 🎯 Objectif

Apprendre à :
- Créer un rôle Ansible
- Organiser le code de manière modulaire
- Réutiliser des rôles dans plusieurs playbooks
- Définir des variables par défaut

## 🚀 Utilisation

```bash
# Exécuter le playbook
ansible-playbook -i inventory.yml playbook.yml

# Lister les rôles disponibles
tree roles/

# Utiliser le rôle dans un autre playbook
# roles:
#   - nginx
```

## 📚 Concepts abordés

- ✅ Structure de rôle Ansible
- ✅ Organisation modulaire
- ✅ Variables par défaut (`defaults/main.yml`)
- ✅ Métadonnées de rôle (`meta/main.yml`)
- ✅ Réutilisabilité du code
- ✅ Dépendances entre rôles
