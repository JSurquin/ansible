# 📚 Index de la correction - Exercice de groupe Ansible

## 🎯 Vue d'ensemble

Cette correction complète illustre une infrastructure Ansible professionnelle avec 4 serveurs (2 Apache2 + 2 Nginx), gérés par des playbooks, rôles, inventaires et templates dédiés.

---

## 📖 Documentation disponible

### 🚀 Guides de démarrage

| Fichier | Description | Temps de lecture |
|---------|-------------|------------------|
| **QUICKSTART.md** | Démarrage ultra-rapide (4 commandes) | 2 min |
| **README.md** | Documentation complète du projet | 10 min |
| **COMMANDS.md** | Référence de toutes les commandes | 15 min |
| **EXPLICATIONS.md** | Concepts détaillés et architecture | 30 min |
| **INDEX.md** | Ce fichier (vue d'ensemble) | 5 min |

---

## 🗂️ Structure des fichiers

### Fichiers de configuration
```
correction/
├── ansible.cfg                 # Configuration Ansible (chemins des rôles)
├── group_vars/all.yml          # Variables globales (ansible_connection: docker)
├── .gitignore                  # Fichiers à ignorer
└── docker-compose.yml          # Infrastructure Docker (4 containers)
```

### Inventaires
```
inventories/
├── apache2.yml                 # 2 serveurs Apache (apache1, apache2)
└── nginx.yml                   # 2 serveurs Nginx (nginx1, nginx2)
```

### Playbooks
```
playbooks/
├── play-apache2.yml            # Déploiement Apache2
└── play-nginx.yml              # Déploiement Nginx
```

### Rôle Apache2
```
roles/apache2/
├── tasks/main.yml              # Installation et configuration
├── handlers/main.yml           # Restart/reload
├── vars/main.yml               # Variables du rôle
└── templates/
    ├── apache2.conf.j2         # Configuration Apache
    └── index.html.j2           # Page d'accueil personnalisée
```

### Rôle Nginx
```
roles/nginx/
├── tasks/main.yml              # Installation et configuration
├── handlers/main.yml           # Restart/reload
├── vars/main.yml               # Variables du rôle
└── templates/
    ├── nginx.conf.j2           # Configuration Nginx
    └── index.html.j2           # Page d'accueil personnalisée
```

### Scripts et outils
```
test.sh                         # Script de test automatique
```

---

## 🎓 Par où commencer ?

### Niveau débutant
1. **Lire** : `QUICKSTART.md` pour lancer rapidement
2. **Exécuter** : `./test.sh` pour voir la correction en action
3. **Explorer** : Ouvrir http://localhost:8080 et http://localhost:8081
4. **Lire** : `README.md` pour comprendre la structure

### Niveau intermédiaire
1. **Lire** : `EXPLICATIONS.md` pour comprendre les concepts
2. **Pratiquer** : Modifier les templates et ré-exécuter
3. **Expérimenter** : Ajouter un 3ème serveur
4. **Consulter** : `COMMANDS.md` pour les commandes avancées

### Niveau avancé
1. **Analyser** : Architecture et choix de conception
2. **Optimiser** : Performance et sécurité
3. **Étendre** : Ajouter de nouveaux rôles (MySQL, Redis, etc.)
4. **Intégrer** : CI/CD, monitoring, logging

---

## 🚀 Quick Start (rappel)

```bash
cd correction
docker-compose up -d
sleep 5
./test.sh
```

**Résultat** : Infrastructure complète opérationnelle en 1 minute !

---

## 🔍 Fichiers importants

### Configuration globale
- **ansible.cfg** : Configuration Ansible du projet
  - Chemin des rôles : `./roles`
  - Options d'affichage et de connexion
- **group_vars/all.yml** : Variables communes à tous les serveurs
  - `ansible_connection: docker`
  - Ports par défaut (apache: 80, nginx: 8080)
  - Email admin

### Inventaires
- **inventories/apache2.yml** : Définit apache1 et apache2
- **inventories/nginx.yml** : Définit nginx1 et nginx2

### Playbooks
- **playbooks/play-apache2.yml** : Applique le rôle apache2 aux apache_servers
- **playbooks/play-nginx.yml** : Applique le rôle nginx aux nginx_servers

### Rôles
- **roles/apache2/** : Tout le nécessaire pour installer et configurer Apache
- **roles/nginx/** : Tout le nécessaire pour installer et configurer Nginx

---

## 📊 Concepts Ansible couverts

### ✅ Niveau 1 : Fondamentaux
- [x] Inventaires (hosts et groupes)
- [x] Playbooks (orchestration)
- [x] Tasks (actions)
- [x] Modules (apt, service, file, template)

### ✅ Niveau 2 : Intermédiaire
- [x] Rôles (organisation réutilisable)
- [x] Variables (group_vars, vars)
- [x] Templates (Jinja2)
- [x] Handlers (gestion des redémarrages)

### ✅ Niveau 3 : Avancé
- [x] Idempotence (ré-exécutions sans effets de bord)
- [x] Séparation des responsabilités (Clean Architecture)
- [x] Infrastructure as Code
- [x] Docker comme cible Ansible

---

## 🧪 Tests disponibles

### Test automatique complet
```bash
./test.sh
```
Vérifie :
- ✓ Containers en cours d'exécution
- ✓ Connexion Ansible
- ✓ Exécution des playbooks
- ✓ Services actifs
- ✓ Pages web accessibles
- ✓ Idempotence

### Tests manuels
```bash
# Tester la connexion
ansible -i inventories/apache2.yml all -m ping

# Vérifier un service
docker exec apache-server-1 service apache2 status

# Tester une page web
curl http://localhost:8080
```

---

## 🌐 Accès aux applications

### Depuis le navigateur
- **Nginx Server 1** : http://localhost:8080
- **Nginx Server 2** : http://localhost:8081

### Depuis les containers
```bash
# Apache
docker exec apache-server-1 curl http://localhost
docker exec apache-server-2 curl http://localhost

# Nginx
docker exec nginx-server-1 curl http://localhost:8080
docker exec nginx-server-2 curl http://localhost:8080
```

---

## 💡 FAQ

### Q: Pourquoi 2 inventaires séparés ?
**R:** Permet de déployer Apache et Nginx indépendamment. En production, vous pourriez avoir des environnements séparés (dev, staging, prod).

### Q: Pourquoi des rôles et pas juste des tasks ?
**R:** Les rôles permettent la réutilisation, l'organisation et la portabilité du code.

### Q: Pourquoi Docker et pas SSH ?
**R:** Pour la formation, Docker est plus rapide et léger. En production, changez juste `ansible_connection: ssh`.

### Q: Comment adapter pour la production ?
**R:** 
1. Remplacer `ansible_connection: docker` par `ansible_connection: ssh`
2. Mettre les vraies IPs dans les inventaires
3. Configurer les clés SSH
4. Ajouter Ansible Vault pour les secrets

### Q: Puis-je ajouter d'autres serveurs ?
**R:** Oui ! Ajoutez-les dans :
1. `docker-compose.yml` (container)
2. `inventories/*.yml` (inventaire)
3. Ré-exécutez le playbook

---

## 🎯 Exercices proposés

### Exercice 1 : Modifier une variable
1. Changer `apache_port` dans `group_vars/all.yml`
2. Ré-exécuter le playbook Apache
3. Vérifier que le handler a été déclenché

### Exercice 2 : Personnaliser les templates
1. Modifier `roles/apache2/templates/index.html.j2`
2. Ajouter votre propre message ou style CSS
3. Déployer et vérifier

### Exercice 3 : Ajouter un serveur
1. Ajouter `apache3` dans `inventories/apache2.yml`
2. Ajouter le service dans `docker-compose.yml`
3. Lancer `docker-compose up -d`
4. Déployer avec `--limit apache3`

### Exercice 4 : Créer un nouveau rôle
1. Créer `roles/mysql/` avec la même structure
2. Implémenter l'installation de MySQL
3. Créer un playbook et un inventaire
4. Tester

### Exercice 5 : Mode check et diff
1. Modifier une variable
2. Lancer avec `--check --diff`
3. Observer les changements prévus sans les appliquer

---

## 🔧 Commandes essentielles (rappel)

```bash
# Infrastructure
docker-compose up -d                    # Lancer
docker-compose down                     # Arrêter

# Ansible
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml

# Tests
./test.sh                               # Test complet
ansible -i inventories/apache2.yml all -m ping    # Test connexion

# Debug
docker exec -it apache-server-1 bash    # Entrer dans le container
docker logs apache-server-1             # Voir les logs
```

---

## 📚 Ressources externes

### Documentation officielle
- [Ansible Docs](https://docs.ansible.com)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Ansible Galaxy](https://galaxy.ansible.com)

### Modules utilisés
- [apt module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html)
- [service module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/service_module.html)
- [template module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html)
- [file module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html)

---

## ✅ Checklist de compréhension

Après avoir parcouru cette correction, vous devriez pouvoir :

- [ ] Expliquer la différence entre playbook et rôle
- [ ] Créer un inventaire avec plusieurs groupes
- [ ] Écrire un playbook qui utilise un rôle
- [ ] Créer un rôle complet (tasks, handlers, vars, templates)
- [ ] Utiliser des variables et des facts dans les templates
- [ ] Comprendre le fonctionnement des handlers
- [ ] Tester l'idempotence d'un playbook
- [ ] Déboguer un problème de déploiement
- [ ] Adapter cette structure pour un nouveau projet

---

## 🎉 Conclusion

Cette correction représente une **architecture Ansible professionnelle** que vous pouvez utiliser comme base pour vos propres projets.

**Points forts** :
✅ Organisation claire et scalable
✅ Réutilisabilité maximale
✅ Bonnes pratiques appliquées
✅ Documentation complète
✅ Tests automatisés
✅ Prêt pour la production (avec adaptations)

**Prochaines étapes** :
1. Comprendre chaque fichier
2. Modifier et expérimenter
3. Créer vos propres rôles
4. Déployer sur de vrais serveurs

---

📧 **Questions ou suggestions ?** N'hésitez pas à poser vos questions lors de la formation !

🚀 **Bon déploiement avec Ansible 2026 !**
