# 📚 Exemples Ansible - Formation 2025

Ce dossier contient **4 exemples progressifs** d'utilisation d'Ansible, du plus simple au plus complexe.

## 🎯 Vue d'ensemble

| Exemple | Niveau | Description | Concepts |
|---------|--------|-------------|----------|
| [01-simple-playbook](./01-simple-playbook/) | 🟢 Débutant | Inventaire + Playbook basique | Inventaire, playbook, modules apt/service |
| [02-variables-templates](./02-variables-templates/) | 🟡 Intermédiaire | Variables et templates Jinja2 | Variables, templates, group_vars |
| [03-avec-roles](./03-avec-roles/) | 🟠 Avancé | Organisation avec rôles | Rôles, structure modulaire, réutilisabilité |
| [04-projet-production](./04-projet-production/) | 🔴 Expert | Projet production complet | Multi-env, vault, bonnes pratiques |

## 📖 Guide d'utilisation

### Prérequis

```bash
# 1. Démarrer le lab Docker
cd ../  # Retour à la racine du projet
docker-compose -f docker-compose-lab.yml up -d

# 2. Vérifier que les containers sont up
docker ps | grep ansible-lab

# 3. Installer Ansible et les collections
pip install ansible
ansible-galaxy collection install community.docker
```

### Navigation dans les exemples

```bash
# Aller dans un exemple
cd exemples/01-simple-playbook/

# Lire le README de l'exemple
cat README.md

# Exécuter l'exemple
ansible-playbook -i inventory.yml playbook.yml
```

## 🟢 Exemple 1 : Simple Playbook

**Objectif** : Premiers pas avec Ansible

```bash
cd 01-simple-playbook/
ansible-playbook -i inventory.yml playbook.yml
```

**Ce que vous apprenez** :
- ✅ Définir un inventaire
- ✅ Écrire un playbook
- ✅ Utiliser les modules de base
- ✅ Installer et gérer des services

## 🟡 Exemple 2 : Variables et Templates

**Objectif** : Personnalisation avec variables et templates

```bash
cd 02-variables-templates/
ansible-playbook -i inventory.yml playbook.yml
```

**Ce que vous apprenez** :
- ✅ Organiser les variables dans `group_vars/`
- ✅ Créer des templates Jinja2
- ✅ Générer des fichiers dynamiquement
- ✅ Utiliser les handlers

**Fichiers clés** :
- `group_vars/all.yml` : Variables globales
- `templates/*.j2` : Templates Jinja2

## 🟠 Exemple 3 : Avec Rôles

**Objectif** : Code modulaire et réutilisable

```bash
cd 03-avec-roles/
ansible-playbook -i inventory.yml playbook.yml
```

**Ce que vous apprenez** :
- ✅ Créer un rôle Ansible
- ✅ Structure standardisée
- ✅ Variables par défaut
- ✅ Métadonnées de rôle
- ✅ Réutilisation du code

**Structure d'un rôle** :
```
roles/nginx/
├── tasks/       # Tâches à exécuter
├── handlers/    # Actions déclenchées
├── templates/   # Templates Jinja2
├── defaults/    # Variables par défaut
└── meta/        # Métadonnées
```

## 🔴 Exemple 4 : Projet Production

**Objectif** : Projet professionnel complet

```bash
cd 04-projet-production/

# Staging
ansible-playbook -i inventories/staging site.yml

# Production
ansible-playbook -i inventories/production site.yml

# Avec Vault
ansible-playbook -i inventories/production site.yml --ask-vault-pass
```

**Ce que vous apprenez** :
- ✅ Structure projet production
- ✅ Multi-environnements (staging/prod)
- ✅ Ansible Vault pour les secrets
- ✅ Configuration centralisée (`ansible.cfg`)
- ✅ Playbooks spécialisés
- ✅ Tags pour exécution sélective

**Fichiers importants** :
- `ansible.cfg` : Configuration du projet
- `site.yml` : Playbook principal
- `inventories/` : Un par environnement
- `group_vars/` : Variables par environnement
- `secrets.yml` : Secrets chiffrés (Vault)
- `playbooks/` : Playbooks spécifiques

## 🔐 Utiliser Ansible Vault

```bash
# Dans l'exemple 4
cd 04-projet-production/

# Chiffrer le fichier secrets
ansible-vault encrypt secrets.yml

# Éditer le fichier chiffré
ansible-vault edit secrets.yml

# Déchiffrer pour voir le contenu
ansible-vault decrypt secrets.yml

# Utiliser avec un playbook
ansible-playbook site.yml --ask-vault-pass
```

## 🎨 Personnalisation

Chaque exemple peut être personnalisé :

1. **Modifier l'inventaire** : Ajoutez vos propres serveurs
2. **Adapter les variables** : Changez les valeurs dans `group_vars/`
3. **Étendre les rôles** : Ajoutez des tâches supplémentaires
4. **Créer vos templates** : Personnalisez les configurations

## 💡 Conseils

### Pour bien apprendre :

1. **Commencez par l'exemple 1** et progressez dans l'ordre
2. **Lisez les README** de chaque exemple
3. **Modifiez les fichiers** pour expérimenter
4. **Cassez et réparez** : C'est en pratiquant qu'on apprend !

### Debuggage :

```bash
# Mode verbose
ansible-playbook playbook.yml -vvv

# Tester la connexion
ansible -i inventory.yml all -m ping

# Dry-run (simulation)
ansible-playbook playbook.yml --check

# Lister les tasks
ansible-playbook playbook.yml --list-tasks

# Lister les tags
ansible-playbook playbook.yml --list-tags
```

## 📚 Ressources

- [Documentation Ansible](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/)
- [Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

## 🆘 Problèmes courants

### Les containers ne sont pas accessibles

```bash
# Vérifier les containers
docker ps | grep ansible-lab

# Redémarrer le lab
docker-compose -f ../docker-compose-lab.yml restart
```

### Erreur de connexion Ansible

```bash
# Vérifier la connexion
ansible -i inventory.yml all -m ping

# Vérifier Python dans les containers
docker exec ansible-lab-web01 python3 --version
```

### Module introuvable

```bash
# Installer les collections
ansible-galaxy collection install community.general community.docker
```

## 🚀 Prochaines étapes

Après avoir parcouru ces exemples :

1. **Créez votre propre projet** Ansible
2. **Publiez vos rôles** sur Ansible Galaxy
3. **Intégrez Ansible** dans votre CI/CD
4. **Explorez les collections** avancées

**Bonne pratique avec Ansible !** 🎉
