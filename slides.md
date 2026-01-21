---
theme: ./
colorSchema: "auto"
layout: intro
highlighter: shiki
# https://sli.dev/custom/highlighters.html
title: Formation Ansible 2025
# download: true
#transition: slide-left
# remoteAssets: false
# export:
#   zoom: 1
#   format: pdf
#   timeout: 300000000
#   pdfOptions:
#     format: A4
download: "https://docker.andromed.fr/slides.pdf"
themeConfig:
  logoHeader: "/avatar.png"
  eventLogo: "https://img2.storyblok.com/352x414/f/84560/2388x414/23d8eb4b8d/vue-amsterdam-with-name.png"
  eventUrl: "https://vuejs.amsterdam/"
---

# Ansible 2025

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

# DISCLAIMER 🐧

### Dans cette formation nous allons voir les commandes principales et les bonnes pratiques d'Ansible en 2025.

---
layout: two-cols
routeAlias: 'sommaire'
---

<a name="SOMMAIRE" id="sommaire"></a>

# SOMMAIRE ANSIBLE 📜

### Formation pratique en 2 jours

<br>

<div class="flex flex-col gap-2">
<Link to="fondamentaux-ansible">🤖 Fondamentaux Ansible</Link>
<Link to="exercices-ansible">🎯 Exercices Ansible</Link>
<Link to="qcm-ansible">✅ QCM Ansible</Link>
</div>

::right::

## PROGRAMME 2 JOURS 📅

### Structure pédagogique optimisée

**Jour 1 - Fondamentaux Ansible**

- Introduction à Ansible
- Architecture et concepts
- Installation et configuration
- Inventaires et groupes
- Modules essentiels
- Premiers playbooks
- Variables et facts
- Exercices pratiques niveau 1 & 2

**Jour 2 - Ansible avancé**

- Roles et organisation
- Templates Jinja2
- Handlers et notifications
- Ansible Vault
- Bonnes pratiques 2025
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
