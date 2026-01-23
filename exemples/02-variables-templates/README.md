# Exemple 2 : Variables et Templates

## 📖 Description

Exemple intermédiaire montrant l'utilisation de variables et templates Jinja2 pour personnaliser la configuration.

## 📁 Structure

```
02-variables-templates/
├── README.md
├── inventory.yml           # Inventaire avec groupes
├── playbook.yml            # Playbook utilisant des templates
├── group_vars/
│   └── all.yml            # Variables globales
└── templates/
    ├── nginx.conf.j2      # Template de configuration Nginx
    └── index.html.j2      # Template de page HTML
```

## 🎯 Objectif

Apprendre à utiliser :
- Variables organisées dans `group_vars/`
- Templates Jinja2 (`.j2`)
- Génération dynamique de fichiers de configuration
- Module `template`

## 🚀 Utilisation

```bash
# Exécuter le playbook
ansible-playbook -i inventory.yml playbook.yml

# Vérifier la page web générée
curl http://localhost
```

## 📚 Concepts abordés

- ✅ Organisation des variables dans `group_vars/`
- ✅ Templates Jinja2
- ✅ Module `template`
- ✅ Génération dynamique de configuration
- ✅ Variables d'inventaire (`inventory_hostname`, `ansible_default_ipv4`)
