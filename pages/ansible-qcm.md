---
routeAlias: 'qcm-ansible'
---

<a name="QCM_ANSIBLE" id="QCM_ANSIBLE"></a>

# QCM : Évaluation Ansible

### Testez vos connaissances par module

---

# Module 1 : Fondamentaux Ansible

### Question 1

Quel est le principe fondamental d'Ansible ?

A) Ansible nécessite des agents sur tous les serveurs cibles

B) Ansible fonctionne en mode "push" sans agent

C) Ansible utilise uniquement le protocole HTTP

D) Ansible remplace complètement SSH

---

### Question 2

Quels sont les composants principaux d'Ansible ?

A) Control Node, Managed Nodes, Playbooks

B) Master, Workers, Registry

C) Client, Server, Database

D) Controller, Executors, Storage

---

### Question 3

Que signifie "idempotent" dans le contexte Ansible ?

A) Les tâches s'exécutent toujours plus rapidement à la deuxième fois

B) Exécuter un playbook plusieurs fois produit le même résultat

C) Les erreurs sont automatiquement corrigées

D) Les tâches sont exécutées en parallèle

---

# Module 2 : Inventaires et Playbooks

### Question 4

Qu'est-ce qu'un inventaire Ansible ?

A) La liste des playbooks disponibles

B) La liste des serveurs et groupes gérés par Ansible

C) L'historique des exécutions

D) Le catalogue des modules disponibles

---

### Question 5

Dans quel format sont écrits les playbooks Ansible ?

A) JSON

B) XML

C) YAML

D) TOML

---

### Question 6

Comment exécuter un playbook avec un inventaire spécifique ?

A) `ansible-playbook playbook.yml -i inventory.yml`

B) `ansible playbook.yml --inventory inventory.yml`

C) `ansible-run -p playbook.yml -i inventory.yml`

D) `ansible execute playbook.yml inventory.yml`

---

# Module 3 : Modules et Variables

### Question 7

Quelle est la différence entre un module et un rôle ?

A) Un module est réutilisable, un rôle ne l'est pas

B) Un module exécute une tâche spécifique, un rôle est un ensemble de tâches organisées

C) Un rôle est plus rapide qu'un module

D) Il n'y a pas de différence

---

### Question 8

Quelle commande exécute une tâche ad-hoc sur tous les serveurs web ?

A) `ansible webservers -m ping`

B) `ansible-playbook -i webservers ping.yml`

C) `ansible all -m webservers -a ping`

D) `ansible run webservers ping`

---

### Question 9

Comment définir une variable dans un playbook ?

A) `set var_name: value`

B) `vars: var_name = value`

C) `vars:` suivi de `var_name: value`

D) `define: var_name value`

---

# Module 4 : Templates et Handlers

### Question 10

Quel langage de template utilise Ansible ?

A) Mustache

B) Jinja2

C) Handlebars

D) EJS

---

### Question 11

Quand un handler est-il exécuté ?

A) Immédiatement quand il est appelé

B) À la fin du playbook, seulement si notifié et que la tâche a changé quelque chose

C) Au début de chaque play

D) Uniquement en cas d'erreur

---

### Question 12

Comment appeler un handler depuis une tâche ?

A) `trigger: handler_name`

B) `call: handler_name`

C) `notify: handler_name`

D) `execute: handler_name`

---

# Module 5 : Rôles et Collections

### Question 13

Quelle est la structure standard d'un rôle Ansible ?

A) `tasks/, handlers/, vars/, files/`

B) `src/, build/, test/, deploy/`

C) `main/, config/, scripts/, docs/`

D) `playbooks/, inventories/, modules/, plugins/`

---

### Question 14

Comment installer une collection Ansible depuis Galaxy ?

A) `ansible install collection community.docker`

B) `ansible-galaxy collection install community.docker`

C) `ansible-galaxy install community.docker`

D) `ansible add-collection community.docker`

---

### Question 15

Où sont stockés les rôles téléchargés depuis Ansible Galaxy par défaut ?

A) `~/.ansible/roles/`

B) `/etc/ansible/roles/`

C) `./roles/`

D) `/usr/share/ansible/roles/`

---

# Module 6 : Ansible Vault et Sécurité

### Question 16

À quoi sert Ansible Vault ?

A) Stocker les playbooks de manière sécurisée

B) Chiffrer les données sensibles comme les mots de passe

C) Sauvegarder l'inventaire

D) Gérer les versions des playbooks

---

### Question 17

Comment créer un fichier chiffré avec Ansible Vault ?

A) `ansible-vault encrypt fichier.yml`

B) `ansible-vault create fichier.yml`

C) `ansible vault new fichier.yml`

D) `ansible-encrypt fichier.yml`

---

### Question 18

Quelle n'est PAS une bonne pratique de sécurité avec Ansible ?

A) Utiliser Ansible Vault pour les secrets

B) Stocker les clés SSH dans les playbooks

C) Limiter les privilèges avec `become_user`

D) Utiliser des connexions SSH avec clés

---

# Module 7 : Gestion des erreurs et Tags

### Question 19

Comment ignorer les erreurs pour une tâche spécifique ?

A) `ignore_errors: true`

B) `failed_when: false`

C) `error_handling: ignore`

D) `skip_errors: yes`

---

### Question 20

À quoi servent les tags dans Ansible ?

A) Identifier les versions des playbooks

B) Exécuter seulement certaines tâches d'un playbook

C) Catégoriser les serveurs dans l'inventaire

D) Marquer les erreurs dans les logs

---

### Question 21

Comment exécuter uniquement les tâches avec le tag "config" ?

A) `ansible-playbook playbook.yml --tag config`

B) `ansible-playbook playbook.yml --tags config`

C) `ansible-playbook playbook.yml -t config`

D) Les réponses B et C sont correctes

---

# Module 8 : Bonnes pratiques et CI/CD

### Question 22

Comment implémenter un déploiement blue-green avec Ansible ?

A) Utiliser des groupes d'inventaire distincts et des variables conditionnelles

B) Créer deux playbooks séparés

C) Utiliser uniquement des rôles

D) Impossible avec Ansible seul

---

### Question 23

Quelle est la meilleure façon d'organiser un projet Ansible en production ?

A) Tout mettre dans un seul fichier playbook.yml

B) Utiliser une structure avec roles/, inventories/, group_vars/

C) Créer un fichier par serveur

D) Utiliser uniquement des commandes ad-hoc

---

### Question 24

Dans quel contexte utilise-t-on `delegate_to` ?

A) Pour déléguer une tâche à un autre serveur que celui de l'hôte actuel

B) Pour donner des permissions sudo

C) Pour transférer des fichiers

D) Pour exécuter des tâches en parallèle

---

### Question 25

Quelle directive permet de continuer l'exécution même si une tâche échoue sur certains hôtes ?

A) `continue_on_failure: true`

B) `any_errors_fatal: false`

C) `ignore_all_errors: true`

D) `force_continue: true`

---

# 📊 Réponses - Tous les modules

### Corrections complètes

**Module 1 : Fondamentaux**
- Question 1 : **B** - Ansible fonctionne en mode "push" sans agent
- Question 2 : **A** - Control Node, Managed Nodes, Playbooks
- Question 3 : **B** - Exécuter un playbook plusieurs fois produit le même résultat

**Module 2 : Inventaires et Playbooks**
- Question 4 : **B** - La liste des serveurs et groupes gérés par Ansible
- Question 5 : **C** - YAML
- Question 6 : **A** - `ansible-playbook playbook.yml -i inventory.yml`

**Module 3 : Modules et Variables**
- Question 7 : **B** - Un module exécute une tâche spécifique, un rôle est un ensemble de tâches organisées
- Question 8 : **A** - `ansible webservers -m ping`
- Question 9 : **C** - `vars:` suivi de `var_name: value`

---

# 📊 Réponses (suite)

**Module 4 : Templates et Handlers**
- Question 10 : **B** - Jinja2
- Question 11 : **B** - À la fin du playbook, seulement si notifié et que la tâche a changé quelque chose
- Question 12 : **C** - `notify: handler_name`

**Module 5 : Rôles et Collections**
- Question 13 : **A** - `tasks/, handlers/, vars/, files/`
- Question 14 : **B** - `ansible-galaxy collection install community.docker`
- Question 15 : **A** - `~/.ansible/roles/`

**Module 6 : Ansible Vault et Sécurité**
- Question 16 : **B** - Chiffrer les données sensibles comme les mots de passe
- Question 17 : **B** - `ansible-vault create fichier.yml`
- Question 18 : **B** - Stocker les clés SSH dans les playbooks

---

# 📊 Réponses (fin)

**Module 7 : Gestion des erreurs et Tags**
- Question 19 : **A** - `ignore_errors: true`
- Question 20 : **B** - Exécuter seulement certaines tâches d'un playbook
- Question 21 : **D** - Les réponses B et C sont correctes

**Module 8 : Bonnes pratiques et CI/CD**
- Question 22 : **A** - Utiliser des groupes d'inventaire distincts et des variables conditionnelles
- Question 23 : **B** - Utiliser une structure avec roles/, inventories/, group_vars/
- Question 24 : **A** - Pour déléguer une tâche à un autre serveur que celui de l'hôte actuel
- Question 25 : **B** - `any_errors_fatal: false`

---

# 🎯 Barème de notation

### Évaluez votre niveau

- **23-25 bonnes réponses** : 🏆 Expert Ansible ! Vous maîtrisez parfaitement
- **20-22 bonnes réponses** : 🥇 Niveau avancé - Excellent travail
- **16-19 bonnes réponses** : 🥈 Bon niveau - Quelques révisions recommandées
- **12-15 bonnes réponses** : 🥉 Niveau intermédiaire - Continuez à pratiquer
- **< 12 bonnes réponses** : 📚 Revoir les fondamentaux

---

# 💡 Points clés à retenir

### Concepts essentiels

✅ **Idempotence** : Ansible garantit le même résultat à chaque exécution

✅ **Sans agent** : Utilise SSH, pas besoin d'installer d'agent sur les serveurs cibles

✅ **YAML** : Format standard pour les playbooks, lisible et simple

✅ **Jinja2** : Moteur de templates pour générer des configurations dynamiques

✅ **Vault** : Chiffrement des données sensibles (mots de passe, clés API)

✅ **Rôles** : Organisation modulaire et réutilisable du code

✅ **Tags** : Exécution sélective de parties d'un playbook

✅ **Handlers** : Actions déclenchées uniquement si une tâche change quelque chose

---

# 🚀 Prochaines étapes

### Pour aller plus loin

**Approfondissement**
- 📖 Documentation officielle Ansible
- 🎥 Ansible YouTube channel
- 🌟 Ansible Galaxy pour les rôles communautaires

**Outils avancés**
- **Ansible Tower/AWX** : Interface web et orchestration
- **Molecule** : Tests automatisés des rôles
- **Ansible Lint** : Vérification de la qualité du code

**Intégrations**
- **CI/CD** : GitLab, Jenkins, GitHub Actions
- **Kubernetes** : Ansible Operator
- **Cloud** : AWS, Azure, GCP modules

**💡 Conseil** : Pratiquez en créant vos propres rôles et contribuez à la communauté !
