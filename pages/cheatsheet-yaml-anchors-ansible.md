---
routeAlias: 'cheatsheet-yaml-anchors'
---

# Ancrages YAML (`&`) et alias (`*`) dans Ansible 📎

YAML permet de **nommer un nœud** avec **`&nom`** et de le **réutiliser** avec **`*nom`** — pratique pour éviter de **copier-coller** les mêmes clés (tags, `become`, petits blocs de variables).

**Attention** : pour une grosse logique répétée, Ansible préfère en général les **rôles**, `include_tasks` / `import_tasks`, ou des **fichiers de vars** — les ancrages restent un **complément** utile.

---

# Ancre `&` et alias `*`

**`&identifiant`** définit l’ancre sur un mapping ou une séquence ; **`*identifiant`** insère une **copie** de ce nœud à un autre endroit du même fichier (ou d’un fichier inclus tel quel).

```yaml
- hosts: webservers
  vars:
    tags_web: &tags_web
      - nginx
      - web

  tasks:
    - name: Déployer la config
      template:
        src: site.conf.j2
        dest: /etc/nginx/conf.d/site.conf
      tags: *tags_web
```

---

# Fusion avec `<<:` (merge key)

**`<<: *ancre`** fusionne un **mapping** (pas une simple liste) dans un autre mapping. Très utile pour **`environment`**, des **sous-arbres `vars`**, ou des structures dans `group_vars`.

```yaml
- hosts: webservers
  vars:
    base_env: &base_env
      LANG: C.UTF-8
      LC_ALL: C.UTF-8

  tasks:
    - name: Commande avec socle d’environnement + surcharge
      command: date
      environment:
        <<: *base_env
        TZ: Europe/Paris
```

---

# Même idée dans `group_vars` (DRY)

Souvent, un **socle commun** et des **clés spécifiques** par application :

```yaml
app_base: &app_base
  user: www-data
  group: www-data
  mode: "0755"

apps:
  frontend:
    <<: *app_base
    root: /var/www/frontend
  api:
    <<: *app_base
    root: /var/www/api
```

---

# Limites et bonnes réflexes

- Les ancrages restent **locaux au YAML** : peu lisibles si le fichier **grossit** 

— extrayez plutôt vers **`group_vars`**, **`host_vars`** ou un **rôle**.

- **`<<:`** ne remplace pas un **playbook structuré** : un même enchaînement de 10 tâches vaut souvent un **`role`** ou un **`block`** avec `rescue`/`always`.


- Pour les **listes de tâches** identiques sur plusieurs hôtes, l’**inventaire** et les **rôles** restent la source de vérité habituelle.
