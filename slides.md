---
theme: ./
colorSchema: "auto"
layout: intro
highlighter: shiki
# https://sli.dev/custom/highlighters.html
title: Formation Ansible 2026
# download: true
#transition: slide-left
# remoteAssets: false
# export:
#   zoom: 1
#   format: pdf
#   timeout: 300000000
#   pdfOptions:
#     format: A4
download: "https://ansible.andromed.fr/slides.pdf"
themeConfig:
  logoHeader: "/avatar.png"
  eventLogo: "https://img2.storyblok.com/352x414/f/84560/2388x414/23d8eb4b8d/vue-amsterdam-with-name.png"
  eventUrl: "https://vuejs.amsterdam/"
---

# Ansible 2026

🤖 Une formation présentée par Andromed.

<div class="pt-12">
  <span @click="next" class="px-2 p-1 rounded cursor-pointer hover:bg-white hover:bg-opacity-10">
    Appuyez sur espace pour la page suivante <carbon:arrow-right class="inline"/>
  </span>
</div>

---
layout: presenter
eventLogo: 'https://img2.storyblok.com/352x0/f/84560/2388x414/23d8eb4b8d/vue-amsterdam-with-name.png'
eventUrl: 'https://vuejs.amsterdam/'
twitter: '@jimmylansrq'

twitterUrl: 'https://twitter.com/jimmylansrq'
presenterImage: 'https://legacy.andromed.fr/images/fondator.jpg'
---

# Jimmylan Surquin

Fondateur <a  href="https://www.andromed.fr/"><logos-storyblok-icon  mr-1/>Andromed</a>

- Lille, France 🇫🇷
- Création de contenu sur <a href="https://www.youtube.com/channel/jimmylansrq"> <logos-youtube-icon mr-1 /> jimmylansrq </a>
- Blog & Portfolio <a href="https://jimmylan.fr"> jimmylan.fr </a>

---
layout: text-image
media: 'https://i.pinimg.com/originals/f5/5e/80/f55e8059ea945abfd6804b887dd4a0af.gif'
caption: 'ANSIBLE'
---

# Vous connaissez Puppet ? Parfait ! 🎭

### Vous avez déjà les bons réflexes

- ✅ Infrastructure as Code
- ✅ Idempotence
- ✅ Automatisation

**Les différences clés avec Ansible** :
- 🚀 **Agentless** : Pas d'agent à installer (juste SSH)
- 📝 **YAML** : Plus simple que le DSL Puppet
- ⚡ **Push** : Exécution à la demande (vs pull)
- 🎯 **Séquentiel** : Ordre naturel (vs dépendances explicites)

---
layout: two-cols
---

# Comparaison rapide ⚖️

### DSL Puppet

```puppet
class apache {
  package { 'apache2':
    ensure => installed,
  }
  
  service { 'apache2':
    ensure => running,
    enable => true,
    require => Package['apache2'],
  }
}
```

::right::

### YAML Ansible

```yaml
- name: Apache
  hosts: webservers
  tasks:
    - name: Install
      apt:
        name: apache2
        state: present
    
    - name: Start
      service:
        name: apache2
        state: started
```

---

#### Transposition Puppet → Ansible 🔄

<small>

| Puppet | Ansible |
|--------|---------|
| Manifests | Playbooks |
| Classes | Roles |
| Modules | Modules |
| Hiera | Variables/Vault |
| Templates (ERB) | Templates (Jinja2) |
| Facts | Facts |
| Forge | Galaxy |
| Puppet Master | Pas besoin ! |

**Bonne nouvelle** : Les concepts sont les mêmes, seule la syntaxe change ! 🎉

</small>

---

# DISCLAIMER 🐧

### Dans cette formation nous allons voir les commandes principales et les bonnes pratiques d'Ansible en 2026.

---
layout: text-image
media: 'https://media.giphy.com/media/3o7qDEq2bMbcbPRQ2c/giphy.gif'
---

# Pourquoi Docker dans cette formation Ansible ? 🤔

### Docker = Notre infrastructure de test

**Le défi** : Pour apprendre Ansible, il faut plusieurs serveurs à gérer.

**Solutions classiques** :
- ❌ 10 machines virtuelles → Lourd, lent, coûteux
- ❌ Cloud providers → Coûte de l'argent  
- ❌ Vagrant → Encore une techno à installer

---

# Notre solution : Docker comme lab 🐳

### Approche pratique et moderne

**Notre choix** :
- ✅ Docker Compose = 10 containers en 30 secondes
- ✅ Chaque container = Un serveur Linux simulé
- ✅ Ansible les gère comme de vrais serveurs
- ✅ Léger, gratuit, destructible à volonté

**💡 Important** : Docker est juste l'infrastructure de test, **pas le sujet principal** !

En production, vous remplacerez ces containers par de vrais serveurs (VMs, cloud, bare metal).

---

# Setup de notre lab 🔧

### Notre environnement d'entraînement

```yaml
# docker-compose-lab.yml - Infrastructure pour les exercices
version: '3.8'
services:
  web-server-1:
    image: ubuntu:22.04
    hostname: web01
    command: sleep infinity
  
  web-server-2:
    image: ubuntu:22.04
    hostname: web02
    command: sleep infinity
  
  db-server-1:
    image: ubuntu:22.04
    hostname: db01
    command: sleep infinity
  
  # ... Jusqu'à 10 serveurs selon les besoins
```

---

# Lancement du lab 🚀

### Démarrage rapide de l'infrastructure

```bash
# 1. Lancer tous nos "serveurs" de test
docker-compose -f docker-compose-lab.yml up -d

# 2. Vérifier que tout est up
docker ps

# 3. Tester la connexion à un serveur
docker exec -it web-server-1 bash

# 4. Voilà ! Vous avez 10 serveurs prêts pour Ansible
```

**Résultat** : Infrastructure multi-serveurs opérationnelle en quelques secondes ! 🎉

**Analogie** : C'est comme avoir un datacenter miniature sur votre laptop.

---

# Ansible voit des serveurs, pas des containers 🎯

### La magie de l'abstraction

```yaml
# inventory.yml - Ansible ne sait même pas que ce sont des containers !
all:
  children:
    webservers:
      hosts:
        web01: {ansible_host: web-server-1}
        web02: {ansible_host: web-server-2}
    databases:
      hosts:
        db01: {ansible_host: db-server-1}
```

**Pour Ansible** : Ce sont de vrais serveurs.

**Pour nous** : Ce sont des containers pratiques pour apprendre.

**En prod** : Ce seront vos vraies machines !

---
layout: two-cols
routeAlias: 'sommaire'
---

<a name="SOMMAIRE" id="sommaire"></a>

# SOMMAIRE ANSIBLE 📜

<br>

<div class="flex flex-col gap-2">
<Link to="intro-ansible">🚀 1. Introduction à Ansible</Link>
<Link to="installation-setup">⚙️ 2. Installation et Setup 2026</Link>
<Link to="ci-cd-integration">🔄 3. Intégration CI/CD</Link>
<Link to="inventaires">📋 4. Inventaires et serveurs</Link>
<Link to="playbooks">🎭 5. Playbooks</Link>
<Link to="modules">📦 6. Modules essentiels</Link>
<Link to="variables">🔧 7. Variables</Link>
<Link to="templates">📄 8. Templates Jinja2</Link>
</div>

::right::

<div class="flex flex-col gap-2">
<Link to="handlers">🎯 9. Handlers</Link>
<Link to="roles">📦 10. Rôles</Link>
<Link to="collections">🌐 11. Collections</Link>
<Link to="vault">🔐 12. Ansible Vault</Link>
<Link to="debugging">🐛 13. Debugging & Troubleshooting</Link>
<Link to="bonnes-pratiques">🚀 14. Optimisation & Bonnes pratiques</Link>
<Link to="tags">🏷️ 15. Tags et exécution sélective</Link>
<br/>
<Link to="exercices-ansible">🎯 Exercices pratiques</Link>
<Link to="qcm-ansible">✅ QCM de validation</Link>
<Link to="cheatsheet">📝 Cheatsheet - Référence rapide</Link>
<Link to="github" href="https://github.com/JSurquin/ansible">📝 Github - Le lien de la formation</Link>
</div>

---
layout: two-cols
---

#### PROGRAMME 2 JOURS 📅

> 💡 **Note** : Docker sert uniquement d'infrastructure de test pour simuler plusieurs serveurs. En production, vous utiliserez de vraies machines !

**Jour 1 - Fondamentaux Ansible**

- Introduction à Ansible
- Architecture et concepts
- Installation et configuration
- Inventaires et groupes
- Modules essentiels
- Premiers playbooks
- Variables et facts
- Exercices pratiques niveau 1 & 2

::right::

**Jour 2 - Ansible avancé**

- Roles et organisation
- Templates Jinja2
- Handlers et notifications
- Ansible Vault
- Bonnes pratiques 2026
- Exercices pratiques niveau 3
- Projet final
- QCM de validation

---
src: './pages/ansible.md'
---

---
src: './pages/14-exercices-ansible.md'
---

---
src: './pages/ansible-qcm.md'
---

---
routeAlias: 'cheatsheet'
---

# Cheatsheet Ansible 📝

### Référence rapide des concepts clés

Une aide-mémoire pour retrouver rapidement les concepts essentiels !

---

# Playbook

**Décrit quoi faire et sur quelles machines**

```yaml
- hosts: web
  tasks:
    - name: Installer nginx
      apt: name=nginx state=present
```

---

# Inventory

**Liste des machines ciblées**

```ini
[web]
192.168.1.10
```

---

# Task

**Action unique exécutée par Ansible**

```yaml
- apt: name=nginx state=present
```

---

# Module

**Outil utilisé par une task**

```yaml
- service: name=nginx state=started
```

---

# Role

**Organisation réutilisable de configuration**

```
roles/nginx/tasks/main.yml
```

```yaml
- apt: name=nginx state=present
```

---

# Handler

**Action déclenchée après un changement**

```yaml
- name: restart nginx
  service: name=nginx state=restarted
```

---

# Variable

**Valeur paramétrable**

```yaml
nginx_port: 80
```

---

# Facts

**Infos système automatiques**

```jinja
{{ ansible_hostname }}
```

---

# Template

**Fichier généré dynamiquement**

```nginx
server {
  listen {{ nginx_port }};
}
```

---

# Vault

**Secret chiffré**

```yaml
db_password: !vault |
  $ANSIBLE_VAULT;1.1;AES256
```

---

# Fin de la formation 🎉

### Merci et bon déploiement avec Ansible !

N'oubliez pas : l'automatisation est votre meilleur ami ! 🚀

