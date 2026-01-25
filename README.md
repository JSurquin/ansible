# Formation Ansible 2026 avec Slidev

![Ansible Logo](https://docs.ansible.com/ansible/latest/_static/images/logo_invert.png)

## 🤖 À propos de cette formation

Formation complète sur **Ansible 2026** pour l'automatisation et la gestion d'infrastructure moderne. Cette formation de **2 jours** utilise [Slidev](https://github.com/slidevjs/slidev) pour offrir une expérience d'apprentissage interactive.

### 🎯 Objectifs pédagogiques

- Maîtriser les fondamentaux d'Ansible (playbooks, inventaires, modules)
- Automatiser le déploiement d'infrastructure
- Gérer la configuration de serveurs à grande échelle
- Appliquer les bonnes pratiques DevOps 2026
- Intégrer Ansible dans des pipelines CI/CD

## 📚 Contenu de la formation

### Jour 1 - Fondamentaux Ansible (7h)

**Matin : Concepts de base**
- 🚀 Introduction à Ansible et architecture
- 📋 Inventaires et gestion de serveurs
- 🎭 Playbooks et syntaxe YAML
- 📦 Modules essentiels
- 🔧 Variables et facts

**Après-midi : Pratique**
- 🎯 Exercices niveau simple
- 🎯 Exercices niveau intermédiaire (étapes 1-2)
- 💻 Templates Jinja2
- 🔄 Handlers et notifications

### Jour 2 - Ansible avancé (7h)

**Matin : Concepts avancés**
- 🗂️ Rôles et organisation de code
- 🔐 Ansible Vault et gestion des secrets
- 🌐 Collections et écosystème
- 🏷️ Tags et exécution sélective
- 📊 Intégration CI/CD (GitHub Actions, GitLab)

**Après-midi : Projet final**
- 🎯 Exercices niveau intermédiaire (étape 3)
- 🚀 Exercice avancé : Stack production complète
- ✅ QCM de validation
- 💡 Bonnes pratiques et optimisation

## 🐳 Infrastructure de test

**Pourquoi Docker dans cette formation ?**

Cette formation utilise **Docker comme infrastructure de test** pour simuler un environnement multi-serveurs sans avoir besoin de machines virtuelles coûteuses.

### Avantages de cette approche

- ✅ **10 serveurs Ubuntu** simulés en 30 secondes
- ✅ **Léger et rapide** : Pas de VMs lourdes
- ✅ **Réaliste** : Ansible gère les containers comme de vrais serveurs
- ✅ **Destructible** : Testez, cassez, recommencez
- ✅ **Gratuit** : Aucun coût cloud

### Architecture du lab

```
┌─────────────────────────────────────────┐
│      Ansible Control Node               │
│      (Votre machine locale)              │
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
│x3     │   │x2     │   │x3      │
└───────┘   └───────┘   └────────┘
```

**10 containers Ubuntu** organisés en groupes :
- 3 serveurs web
- 2 serveurs de base de données
- 3 serveurs applicatifs
- 2 serveurs de monitoring

## 📋 Prérequis techniques

### Logiciels requis

- **Docker** & **Docker Compose** (pour le lab de test)
- **Python 3.8+** (pour Ansible)
- **Ansible 2.15+** (installé via pip)
- **Git** (pour cloner le repo)
- Un éditeur de code (VS Code recommandé)

### Connaissances préalables

- ✅ Bases de Linux (commandes shell, SSH)
- ✅ Notions de YAML
- ✅ Concepts de serveurs et réseaux
- ❌ Aucune expérience Ansible requise !

## 🚀 Installation rapide

### 1. Cloner le dépôt

```bash
git clone https://github.com/JSurquin/ansible.git
cd ansible
```

### 2. Installer Ansible

```bash
# Via pip (recommandé)
python3 -m pip install --user ansible

# Vérifier l'installation
ansible --version

# Installer les collections essentielles
ansible-galaxy collection install community.general ansible.posix community.docker
```

### 3. Démarrer le lab Docker

```bash
# Lancer l'infrastructure de test (10 containers)
docker-compose -f docker-compose-lab.yml up -d

# Vérifier que tout est up
docker ps

# Tester la connexion Ansible
ansible -i inventory-lab.yml all -m ping
```

📖 **Guide complet** : Voir [LAB-SETUP.md](./LAB-SETUP.md) pour plus de détails.

### 4. Lancer les slides de formation

```bash
# Installer les dépendances Slidev
pnpm install --frozen-lockfile

# Lancer le serveur de développement
pnpm run dev
```

Les slides seront accessibles sur `http://localhost:3030`

## 📖 Structure du projet

```
ansible/
├── slides.md                    # Slides principales de la formation
├── pages/                       # Contenu des slides par section
│   ├── ansible.md              # Théorie Ansible
│   ├── 14-exercices-ansible.md # Exercices pratiques
│   └── ansible-qcm.md          # QCM d'évaluation
├── docker-compose-lab.yml       # Infrastructure de test (10 containers)
├── inventory-lab.yml            # Inventaire Ansible pour le lab
├── LAB-SETUP.md                 # Guide complet du lab
├── layouts/                     # Layouts personnalisés pour Slidev
├── components/                  # Composants Vue.js
└── public/                      # Assets (images, logos, etc.)
```

## 🎓 Exercices pratiques

La formation comprend **3 niveaux d'exercices** progressifs :

### 🟢 Niveau Simple
- Installation Docker avec Ansible
- Premier playbook
- Commandes de base

### 🟡 Niveau Intermédiaire
- Déploiement de containers
- Variables et templates
- Docker Compose avec Ansible
- Création de rôles

### 🔴 Niveau Avancé
- Stack production complète (Nginx + App + MySQL)
- Scripts de backup et monitoring
- Gestion multi-environnements
- Bonnes pratiques DevOps

## ✅ QCM de validation

**13 questions** couvrant tous les concepts :
- Fondamentaux Ansible
- Modules et rôles
- Bonnes pratiques
- Scénarios avancés

## 🎨 Caractéristiques des slides

- 🎨 Design moderne et responsive
- 🌙 Mode sombre/clair automatique
- 📝 Support Markdown + Vue.js
- 🎨 Coloration syntaxique (Shiki)
- 📊 Diagrammes Mermaid intégrés
- 🖼️ Support images et GIFs
- 🎥 Export PDF disponible
- 🔗 Navigation inter-slides

## 📚 Ressources supplémentaires

### Documentation officielle
- [Ansible Documentation](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/tips_tricks/ansible_tips_tricks.html)

### Collections utiles
- [community.general](https://galaxy.ansible.com/community/general)
- [community.docker](https://galaxy.ansible.com/community/docker)
- [ansible.posix](https://galaxy.ansible.com/ansible/posix)

### Outils complémentaires
- [Ansible Lint](https://github.com/ansible/ansible-lint) - Linter pour playbooks
- [Molecule](https://molecule.readthedocs.io/) - Framework de test
- [Ansible Vault](https://docs.ansible.com/ansible/latest/vault_guide/index.html) - Gestion des secrets

## 🛠️ Commandes utiles

### Slides

```bash
# Développement
pnpm run dev

# Build production
pnpm run build

# Export PDF
pnpm run export

# Preview du build
pnpm run preview
```

### Lab Ansible

```bash
# Démarrer le lab
docker-compose -f docker-compose-lab.yml up -d

# Tester Ansible
ansible -i inventory-lab.yml all -m ping

# Lister l'inventaire
ansible-inventory -i inventory-lab.yml --graph

# Arrêter le lab
docker-compose -f docker-compose-lab.yml down
```

## 🐛 Dépannage

### Ansible ne se connecte pas aux containers

```bash
# Vérifier que les containers sont up
docker ps | grep ansible-lab

# Vérifier Python dans les containers
docker exec ansible-lab-web01 python3 --version

# Installer la collection Docker
ansible-galaxy collection install community.docker
```

### Problèmes avec Slidev

```bash
# Nettoyer le cache
rm -rf node_modules .slidev
pnpm install

# Relancer
pnpm run dev
```

## 👨‍🏫 Formateur

**Jimmylan Surquin**
- Fondateur [Andromed](https://www.andromed.fr/)
- Lille, France 🇫🇷
- YouTube : [jimmylansrq](https://www.youtube.com/channel/jimmylansrq)
- Portfolio : [jimmylan.fr](https://jimmylan.fr)

## 📄 Licence

MIT

---

**🚀 Prêt à automatiser votre infrastructure avec Ansible ?**

Démarrez le lab et suivez la formation ! En 2 jours, vous maîtriserez l'automatisation DevOps moderne.
