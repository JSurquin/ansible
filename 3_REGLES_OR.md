# 🎯 Les 3 Règles d'Or - Ansible 2026

## Pour ne JAMAIS oublier l'essentiel

---

## 1️⃣ VARIABLES : La hiérarchie (du + faible au + fort)

```
┌─────────────────────────────────────────────────────────────┐
│                    PRÉCÉDENCE DES VARIABLES                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. role defaults/     📦 Config par défaut du rôle        │
│     (+ faible)            "Utilisateur PEUT changer"        │
│                                                             │
│  2. group_vars/        🌍 Config par environnement         │
│                           "dev vs prod"                     │
│                                                             │
│  3. playbook vars:     📝 Config dans le play              │
│                           "Ponctuel"                        │
│                                                             │
│  4. role vars/         🔒 Constantes du rôle               │
│     (+ fort)              "NE DOIT PAS changer"            │
│                           ⚠️ Plus fort que group_vars !     │
│                                                             │
│  5. extra-vars (-e)    👑 Override TOTAL                   │
│     (++ fort)             "Surcharge TOUT"                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 💡 Mnémotechnique : "DGPRE"

**D**efaults → **G**roup_vars → **P**laybook → **R**ole vars → **E**xtra-vars

### ⚠️ Piège fréquent

```yaml
# group_vars/production.yml
nginx_user: nginx  # Je veux changer l'utilisateur

# roles/nginx/vars/main.yml
nginx_user: www-data  # ⚠️ GAGNE car vars/ > group_vars !

# Résultat : www-data (pas nginx)
```

**Solution** : Mettre `nginx_user` dans `defaults/` au lieu de `vars/`

### ✅ Règle à retenir

- **defaults/** = Ce que l'utilisateur **PEUT** changer (ports, configs)
- **vars/** = Ce que l'utilisateur **NE DOIT PAS** changer (chemins, packages)
- **Si doute** → mettre dans **defaults/** (plus flexible)

---

## 2️⃣ HANDLERS : L'idempotence est la clé

```
┌─────────────────────────────────────────────────────────────┐
│               QUAND UN HANDLER SE DÉCLENCHE                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Condition UNIQUE : changed: true                           │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  1ère exécution                                     │   │
│  │  ──────────────                                     │   │
│  │  TASK [Config nginx] *** changed: true              │   │
│  │  RUNNING HANDLER [restart nginx] *** ✅             │   │
│  │                                                     │   │
│  │  2ème exécution (fichier identique)                 │   │
│  │  ───────────────────────────────                    │   │
│  │  TASK [Config nginx] *** ok (pas de changed)        │   │
│  │  (pas de handler) ✅ C'EST NORMAL !                │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  💡 "Si rien ne change, pourquoi redémarrer ?"             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 🐛 Les 4 raisons d'échec

```
┌───┬─────────────────────────┬─────────────────────────────┐
│ # │ Problème                │ Solution                    │
├───┼─────────────────────────┼─────────────────────────────┤
│ 1 │ Nom différent           │ Vérifier casse et espaces   │
│   │ notify: restart nginx   │ notify = nom handler        │
│   │ name: Restart nginx ❌  │ EXACTEMENT                  │
├───┼─────────────────────────┼─────────────────────────────┤
│ 2 │ changed: false          │ C'est normal !              │
│   │ (idempotence)           │ Vérifier si vraiment changé │
├───┼─────────────────────────┼─────────────────────────────┤
│ 3 │ Playbook échoué         │ --force-handlers            │
│   │ avant la fin            │ (force même si erreur)      │
├───┼─────────────────────────┼─────────────────────────────┤
│ 4 │ Mode --check            │ C'est normal !              │
│   │ (dry-run)               │ Pas d'exécution en --check  │
└───┴─────────────────────────┴─────────────────────────────┘
```

### ✅ Règle à retenir

1. **Nom identique** : `notify` = nom exact du handler (casse !)
2. **Idempotence** : Handler SE DOIT de ne pas se déclencher si rien ne change
3. **Fin de play** : Handlers s'exécutent à la FIN (même notifiés au début)
4. **Une seule fois** : Notifié 10x = s'exécute 1x

### 🧪 Test d'idempotence (à faire en démo)

```bash
# 1ère fois → changed: true → handler ✅
ansible-playbook play.yml -v | grep "RUNNING HANDLER"

# 2ème fois → ok (pas changed) → pas de handler ✅
ansible-playbook play.yml -v | grep "RUNNING HANDLER"
# Aucune sortie = c'est parfait !
```

---

## 3️⃣ RÔLES : defaults/ vs vars/

```
┌─────────────────────────────────────────────────────────────┐
│                 RÔLES : DEUX TYPES DE VARIABLES             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  roles/nginx/                                               │
│  │                                                          │
│  ├── defaults/main.yml  📝 Configuration                    │
│  │   │                     • Ports                          │
│  │   │                     • Timeouts                       │
│  │   │                     • Features on/off                │
│  │   └─ ✅ PEUT être surchargé par group_vars              │
│  │                                                          │
│  └── vars/main.yml      🔒 Constantes                       │
│      │                     • Nom du package                 │
│      │                     • Nom du service                 │
│      │                     • Chemins config                 │
│      └─ ⚠️ NE PEUT PAS être surchargé (priorité forte)     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 📋 Tableau de décision

```
┌────────────────────────┬──────────────┬─────────────┐
│ Type de variable       │ Emplacement  │ Exemple     │
├────────────────────────┼──────────────┼─────────────┤
│ Port                   │ defaults/    │ 80, 443     │
│ Domaine                │ defaults/    │ example.com │
│ Timeout                │ defaults/    │ 30s         │
│ Workers                │ defaults/    │ auto, 4     │
│ Feature on/off         │ defaults/    │ true/false  │
├────────────────────────┼──────────────┼─────────────┤
│ Nom du package         │ vars/        │ nginx       │
│ Nom du service         │ vars/        │ nginx       │
│ Chemin config          │ vars/        │ /etc/nginx  │
│ Utilisateur système    │ vars/        │ www-data    │
│ Chemins logs           │ vars/        │ /var/log    │
└────────────────────────┴──────────────┴─────────────┘
```

### 🎯 Exemples concrets

**✅ BON : Configuration personnalisable**

```yaml
# roles/nginx/defaults/main.yml
nginx_port: 80              # ← L'utilisateur peut vouloir 443
nginx_worker_processes: auto # ← Dépend du serveur
nginx_enable_gzip: true     # ← Feature configurable
```

**✅ BON : Constantes système**

```yaml
# roles/nginx/vars/main.yml
nginx_package: nginx        # ← Ne change jamais
nginx_service: nginx        # ← Nom du service système
nginx_config_path: /etc/nginx/nginx.conf  # ← Chemin fixe
```

**❌ MAUVAIS : Port dans vars/**

```yaml
# roles/nginx/vars/main.yml
nginx_port: 80  # ❌ Mauvais emplacement !

# Conséquence :
# group_vars/production.yml
nginx_port: 443  # ❌ N'aura AUCUN EFFET (vars/ prioritaire)
```

### ✅ Règle à retenir

**Question** : "Où mettre ma variable ?"

```
┌─────────────────────────────────────────────────┐
│                                                 │
│  L'utilisateur doit-il pouvoir la changer ?     │
│                                                 │
│         OUI                    NON              │
│          ↓                      ↓               │
│     defaults/               vars/               │
│                                                 │
└─────────────────────────────────────────────────┘
```

**Si tu hésites** → `defaults/` (plus flexible, peut toujours être surchargé)

---

## 📝 Aide-mémoire rapide

### Les 3 commandes de debug essentielles

```bash
# 1. Vérifier quelle valeur est utilisée
ansible -m debug -a "var=ma_variable" all

# 2. Tester l'idempotence (2 exécutions)
ansible-playbook play.yml && ansible-playbook play.yml

# 3. Forcer les handlers même en cas d'erreur
ansible-playbook play.yml --force-handlers
```

### Les 3 pièges les plus fréquents

```
🪤 Piège 1 : Mettre un port dans vars/ au lieu de defaults/
   → Ne pourra pas être surchargé par group_vars

🪤 Piège 2 : Handler avec majuscule différente
   → notify: restart nginx ≠ name: Restart nginx

🪤 Piège 3 : Croire qu'un handler défaillant est un bug
   → Si rien ne change, c'est NORMAL qu'il ne se déclenche pas
```

---

## 🎓 Les 3 phrases à dire en formation

### Sur les variables
> **"role vars est plus fort que group_vars, c'est pour ça qu'on y met les constantes système qui ne doivent jamais être changées accidentellement"**

### Sur les handlers
> **"Si un handler ne se déclenche pas la 2ème fois, ce n'est pas un bug, c'est l'idempotence : rien n'a changé, donc pourquoi redémarrer ?"**

### Sur les rôles
> **"defaults/ pour ce que l'utilisateur peut changer, vars/ pour ce qu'il ne doit pas changer. Si vous hésitez, mettez dans defaults/"**

---

## ✅ Checklist minute avant formation

```
[ ] Docker up : cd correction && docker-compose up -d
[ ] Ansible OK : ansible --version
[ ] Test idempotence : 2x le même playbook
[ ] Préparer démo extra-vars : -e "var=value"
[ ] Avoir tree roles/nginx/ prêt
```

---

## 🚀 C'est parti !

**Ces 3 règles représentent 80% des problèmes rencontrés en production.**

**Maîtrisez-les = Maîtrisez Ansible.**

---

**Formation Ansible 2026**  
Mis à jour le : 22 mars 2026
