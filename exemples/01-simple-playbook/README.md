# Exemple 1 : Playbook Simple

## 📖 Description

Exemple le plus basique d'Ansible : un inventaire et un playbook pour installer et configurer Nginx.

## 📁 Structure

```
01-simple-playbook/
├── README.md
├── inventory.yml      # Liste des serveurs
└── playbook.yml       # Tâches à exécuter
```

## 🎯 Objectif

Apprendre les bases d'Ansible :
- Définir un inventaire de serveurs
- Écrire un playbook simple
- Installer un package
- Démarrer un service

## 🚀 Utilisation

```bash
# Tester la connexion aux serveurs
ansible -i inventory.yml all -m ping

# Exécuter le playbook
ansible-playbook -i inventory.yml playbook.yml

# Vérifier que Nginx fonctionne
curl http://localhost
```

## 📚 Concepts abordés

- ✅ Inventaire YAML
- ✅ Playbook basique
- ✅ Module `apt`
- ✅ Module `service`
- ✅ Variables simples
