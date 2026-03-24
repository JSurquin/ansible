---
routeAlias: 'cheatsheet-changed'
---

# Cheatsheet — statut `changed` dans Ansible 📊

Lorsqu’une tâche est marquée **changed**, Ansible signale un **écart corrigé** entre l’état actuel de la cible et l’état demandé (fichier créé, service démarré, paquet installé, etc.).

Les tableaux suivants résument les cas les plus courants.

---

# Cas où une tâche est `changed` (1/2)

<div class="text-xs">

| Cas | Description | Exemple |
| --- | --- | --- |
| 🆕 **Création de ressource** | Une ressource n’existait pas et est créée. | Création d’un fichier avec `copy`, `file`, `template` |
| ✏️ **Modification de contenu** | Une ressource existe mais son contenu change. | Mise à jour d’un fichier de config |
| 🔄 **Changement d’état** | L’état demandé est différent de l’état actuel. | `state: started` sur un service arrêté |
| 📦 **Installation de paquet** | Un package est installé (ou mis à jour). | `apt install nginx` |
| ❌ **Suppression** | Une ressource existait et est supprimée. | `state: absent` |
| 🔐 **Modification de permissions** | Les droits, owner ou group changent. | `mode: 0755` |
| 🔗 **Changement de lien** | Un lien symbolique est créé ou modifié. | `state: link` |
| 🧩 **Template rendu différent** | Le rendu du template diffère du fichier existant. | `template` avec variables |

</div>

---

# Cas où une tâche est `changed` (2/2)

| Cas | Description | Exemple |
| --- | --- | --- |
| ⚙️ **Commande avec effet** | Une commande modifie quelque chose. | `command`, `shell` sans condition |
| 🔁 **Handler déclenché** | Une tâche notifie un handler suite à un changement. | `notify: restart nginx` |
| 📂 **Extraction archive** | Archive extraite et fichiers créés/modifiés. | `unarchive` |
| 🌐 **Git clone/pull** | Dépôt cloné ou mis à jour. | module `git` |
| 📥 **Download fichier** | Fichier téléchargé et différent. | `get_url` |
| 🧪 **Changed forcé** | `changed_when: true` | Override manuel |
| 🚫 **Pas idempotent** | Module/script non idempotent. | Script custom |

---

# Cas particuliers (souvent mal compris)

| Cas | Comportement |
| --- | --- |
| **`command` / `shell`** | Toujours **changed** sauf si `creates` ou `removes`. |
| **Check mode** | Peut prédire **changed** sans exécuter. |
| **`register`** | N’influence pas **changed** directement. |
| **`changed_when: false`** | Force à **ok** même si modifié. |
| **`diff` activé** | Permet de voir pourquoi c’est **changed**. |

---

# Exemple — `template` + handler

Si le rendu du template **diffère** du fichier sur la machine → **changed**, puis le handler s’exécute (souvent **changed** aussi : redémarrage / reload).

```yaml
- name: Déployer nginx.conf
  ansible.builtin.template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: Recharger nginx

handlers:
  - name: Recharger nginx
    ansible.builtin.service:
      name: nginx
      state: reloaded
```

---

# Exemple — `command` et idempotence (`creates`)

Sans `creates`, la tâche serait souvent **changed** à chaque fois. Ici : **ok** si `/tmp/app.tgz` existe déjà.

```yaml
- name: Télécharger l’archive si elle n’existe pas
  ansible.builtin.command: curl -fsSL -o /tmp/app.tgz https://example.com/app.tgz
  args:
    creates: /tmp/app.tgz
```

---

# Exemple — `register` + `changed_when`

`register` ne change pas le statut tout seul : on **recalcule** avec `changed_when` quand la tâche doit compter comme un changement (utile avec `command` / scripts).

```yaml
- name: Vérifier la présence d’une version
  ansible.builtin.command: nginx -v
  register: nginx_version
  changed_when: "'1.26' not in nginx_version.stderr | default('')"
```
