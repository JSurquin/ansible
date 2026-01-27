# 🚀 Démarrage rapide - 2 minutes

## Prérequis
- Docker installé et en cours d'exécution
- Ansible installé (`pip install ansible`)

## En 4 commandes

```bash
# 1. Se placer dans le dossier correction
cd correction

# 2. Lancer l'infrastructure (4 containers)
docker-compose up -d

# 3. Attendre 5 secondes que les containers soient prêts
sleep 5

# 4. Lancer le script de test automatique
./test.sh
```

## ✅ Résultat attendu

Vous devriez voir :
- ✓ Infrastructure lancée (4 containers)
- ✓ Connexion Ansible OK
- ✓ Playbook Apache2 exécuté
- ✓ Playbook Nginx exécuté
- ✓ Services actifs
- ✓ Pages web accessibles

## 🌐 Tester dans le navigateur

Ouvrez ces URLs :
- http://localhost:8080 → Nginx Server 1
- http://localhost:8081 → Nginx Server 2

## 🎯 Exécution manuelle

Si vous préférez lancer les playbooks manuellement :

```bash
# Lancer l'infra
docker-compose up -d

# Déployer Apache2 (sur apache1 et apache2)
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml

# Déployer Nginx (sur nginx1 et nginx2)
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml

# Vérifier qu'Apache fonctionne
docker exec apache-server-1 curl http://localhost

# Vérifier que Nginx fonctionne
docker exec nginx-server-1 curl http://localhost:8080
```

## 🔍 Vérification des services

```bash
# Apache
docker exec apache-server-1 service apache2 status
docker exec apache-server-2 service apache2 status

# Nginx
docker exec nginx-server-1 service nginx status
docker exec nginx-server-2 service nginx status
```

## 🧹 Nettoyage

```bash
# Arrêter et supprimer tout
docker-compose down
```

## 📚 Pour aller plus loin

- Lire le `README.md` pour la documentation complète
- Consulter `COMMANDS.md` pour toutes les commandes disponibles
- Modifier les templates dans `roles/*/templates/`
- Ajouter des variables dans `group_vars/all.yml`

## ⚠️ Problèmes courants

### "Cannot connect to the Docker daemon"
```bash
# Démarrer Docker
# macOS: Lancer Docker Desktop
# Linux: sudo systemctl start docker
```

### "Connection refused" lors du ping Ansible
```bash
# Attendre que les containers soient complètement démarrés
docker ps  # Vérifier que les 4 containers sont "Up"
sleep 10   # Attendre un peu plus
```

### "Module not found" pour Ansible
```bash
# Installer Ansible
pip install ansible
# ou
pip3 install ansible
```

---

🎉 **C'est tout ! Vous avez une infrastructure Ansible complète qui tourne !**
