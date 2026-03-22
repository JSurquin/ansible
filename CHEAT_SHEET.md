# 📄 Cheat Sheet Formation - À avoir sous les yeux

## 🎯 LES 3 RÈGLES D'OR (mnémotechnique DGPRE)

```
Précédence variables (faible → fort) :
D = Defaults  →  G = Group_vars  →  P = Playbook  →  R = Role vars  →  E = Extra-vars
    📦              🌍                 📝                🔒               👑
```

**Piège** : role vars > group_vars (pas l'inverse !)

---

## 🐛 HANDLERS : Checklist de debug

```
Handler ne se déclenche pas ?
├─ 1. Nom identique ? (casse + espaces)
├─ 2. changed: true ? (si false = normal)
├─ 3. Playbook terminé ? (sinon --force-handlers)
└─ 4. Mode --check ? (pas d'exécution)
```

**Phrase clé** : "Si rien ne change, pourquoi redémarrer ?"

---

## 📦 RÔLES : defaults/ vs vars/

```
┌─────────────────────────┬─────────────┬──────────────┐
│ Question                │ Réponse     │ Emplacement  │
├─────────────────────────┼─────────────┼──────────────┤
│ Utilisateur peut changer│ OUI         │ defaults/    │
│ Utilisateur doit changer│ NON         │ vars/        │
│ En cas de doute         │ ?           │ defaults/    │
└─────────────────────────┴─────────────┴──────────────┘

Exemples :
• Port, timeout, workers  → defaults/
• Package, service, paths → vars/
```

---

## 🧪 LES 3 DÉMOS OBLIGATOIRES

```bash
# 1. Variables (Module 7) - 2 min
ansible-playbook play.yml -e "port=8080"

# 2. Handlers (Module 9) - 5 min
ansible-playbook play.yml -v  # 1ère fois → handler
ansible-playbook play.yml -v  # 2ème fois → pas de handler

# 3. Rôles (Module 10) - 3 min
tree roles/nginx/
cat roles/nginx/vars/main.yml
cat roles/nginx/defaults/main.yml
```

---

## ⏱️ TIMING MODULES

```
Module 7  : 30 min (+15 min)
Module 9  : 45 min (+25 min)
Module 10 : 60 min (+30 min)
```

---

## 💬 LES 3 PHRASES CLÉS

**Variables** :
> "role vars plus fort que group_vars : protège constantes système"

**Handlers** :
> "Pas de handler la 2ème fois = idempotence, pas un bug"

**Rôles** :
> "defaults/ = config, vars/ = constantes. Doute → defaults/"

---

## ✅ CHECKLIST TECHNIQUE (5 min)

```bash
docker ps                              # Docker OK ?
ansible --version                      # Ansible OK ?
cd correction && docker-compose up -d  # Infra OK ?
ansible-playbook ... (2x)              # Idempotence OK ?
```

---

## 📊 SLIDES CLÉS PAR MODULE

**Module 7** : "Précédence détaillée", "Tableau récap", "defaults/ vs vars/"
**Module 9** : "Troubleshooting", "Raison 2 (idempotence)", "Test pratique"
**Module 10** : "Différence cruciale", "Exemple Apache2", "Tableau récap"

---

## 🎓 POUR LES APPRENANTS

**Distribuer en fin** : `3_REGLES_OR.md`
**Format** : PDF ou Markdown
**Contenu** : Les 3 règles + aide-mémoire prod

---

**Ansible 2026 | 22 mars 2026**
