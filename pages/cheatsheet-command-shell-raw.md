---
routeAlias: 'cheatsheet-command-shell-raw'
---

# `command`, `shell` et `raw` 🔧

Ce sont trois façons d’**exécuter du texte comme commande** sur la cible — avec des garde-fous, un shell, ou une exécution « brute » très proche de SSH.

Le module **`command`** correspond à ce que beaucoup appellent « cmd » dans d’autres outils : une commande **sans** interpréteur shell (pas de `|`, `>`, `&&` interprétés par `/bin/sh`).

---

# Tableau comparatif

| | **`command`** | **`shell`** | **`raw`** |
| --- | --- | --- | --- |
| **Passe par un shell ?** | Non (exécutable + args) | Oui (`/bin/sh -c` sur Linux) | Non côté Ansible : chaîne envoyée telle quelle |
| **Pipes, `>`, `&&`, variables shell** | Non (sauf contournements) | Oui | Dépend de ce que la cible exécute |
| **Python sur la cible** | Requis (module Ansible) | Requis | **Non** requis pour ce module |
| **Cas typique** | Idempotence, scripts simples | One-liners shell | Bootstrap, appliances, Cisco-like |

---

# `command` — sans shell

Chaque argument est passé tel quel : pratique pour **éviter les surprises** et pour l’**idempotence** (`creates`, `removes`).

```yaml
- name: Compiler si le binaire n’existe pas encore
  command: make install
  args:
    chdir: /opt/app/src
    creates: /usr/local/bin/monapp
```

---

# `shell` — avec `/bin/sh`

Utile quand vous avez **besoin** du shell : redirections, pipes, `&&`, expansion `$VAR` **côté machine distante**.

```yaml
- name: Compter les lignes et garder le résultat dans un fichier
  shell: grep -R "ERROR" /var/log | wc -l > /tmp/error_count.txt
  args:
    executable: /bin/bash
```

---

# `raw` — chaîne brute (souvent sans Python)

Envoyé **presque tel quel** sur la connexion : utile pour **amorcer** une machine (installer Python), ou pour des **équipements** qui ne parlent pas le protocole module habituel.

```yaml
- name: Amorçage — installer Python minimal sur Debian/Ubuntu
  raw: test -e /usr/bin/python3 || (apt-get update && apt-get install -y python3)
```

---

# Comment choisir (règle pratique)

- **`command`** dès que possible : moins ambigu, meilleure base pour **`changed_when`** / **`creates`**.
- **`shell`** si vous **devez** avoir un interpréteur shell (pipe, redirection, script inline court).
- **`raw`** pour **bootstrap** ou cibles **sans** environnement Python Ansible classique ; sinon, préférez un module dédié (`apt`, `package`, `user`, etc.).
