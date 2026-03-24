# Correction — Handlers et idempotence

## Emplacement

Projet Ansible de référence : **`exo/correction-handlers-idempotence/`**

| Fichier | Rôle |
|--------|------|
| `inventory.yml` | Groupe `handler_lab` → `ansible-lab-web01` (connexion `docker`) |
| `group_vars/handler_lab.yml` | Variable `lab_banner` pour le template |
| `templates/lab-handlers.conf.j2` | Fichier de configuration généré |
| `playbook.yml` | Tâche `template` + `notify` + section `handlers` |
| `test.sh` | Validation automatique (3 exécutions de playbook) |

---

## Principe

- La tâche **`ansible.builtin.template`** dépose `/etc/lab-handlers-test.conf` et **notifie** le handler uniquement lorsqu’Ansible considère que le fichier a changé.
- Le handler **append** une ligne horodatée dans `/tmp/lab_handler_audit.log` : preuve visible qu’il s’est exécuté.
- **2ᵉ run** : fichier inchangé → pas de notification → pas de ligne supplémentaire ; `changed=0` sur l’hôte dans le récapitulatif (hors cas où d’autres tâches non idempotentes auraient été ajoutées par l’élève).
- **3ᵉ run** (test automatique) : `-e lab_banner=...` change le rendu du template → nouvelle notification → deuxième ligne dans le journal.

`gather_facts: false` pour garder le playbook minimal ; le handler utilise la date du shell cible.

---

## Test exécuté

Depuis la racine du dépôt, avec le lab déjà démarré :

```bash
docker compose -f docker-compose-lab.yml up -d
cd exo/correction-handlers-idempotence
chmod +x test.sh   # si besoin
./test.sh
```

Résultat obtenu lors de la préparation : **tous les tests OK** (handler au 1er et 3e run, pas au 2e ; journal à 1 puis 2 lignes).

---

## Fichiers (copie)

### `inventory.yml`

```yaml
---
# Un seul nœud du lab pour simplifier la lecture du récapitulatif et du journal de handler.
all:
  vars:
    ansible_connection: docker
    ansible_user: root
    ansible_python_interpreter: /usr/bin/python3
  children:
    handler_lab:
      hosts:
        lab01:
          ansible_host: ansible-lab-web01
```

### `group_vars/handler_lab.yml`

```yaml
---
lab_banner: "lab-handlers-v1"
```

### `templates/lab-handlers.conf.j2`

```
# {{ ansible_managed }}
# Fichier de démonstration handlers + idempotence
LAB_BANNER={{ lab_banner }}
```

### `playbook.yml`

```yaml
---
# Playbook minimal : une ressource fichier + un handler (preuve d’exécution dans /tmp).
- name: Lab handlers et idempotence
  hosts: handler_lab
  gather_facts: false

  tasks:
    - name: Déposer la configuration depuis le template
      ansible.builtin.template:
        src: lab-handlers.conf.j2
        dest: /etc/lab-handlers-test.conf
        mode: "0644"
      notify: Journaliser passage du handler

  handlers:
    - name: Journaliser passage du handler
      ansible.builtin.shell:
        cmd: 'printf "%s handler-fired\n" "$(date -Iseconds)" >> /tmp/lab_handler_audit.log'
        executable: /bin/bash
```

---

## Variantes pédagogiques

- Remplacer le handler par **`systemctl reload nginx`** (sur une VM avec systemd) ou par un rechargement réel d’un service déjà traité dans la formation.
- Étendre à **plusieurs hôtes** : chaque machine possède son propre `/tmp/lab_handler_audit.log` ; adapter le script de test en bouclant sur les conteneurs.
- Faire écrire aux élèves un **`test.sh`** minimal reprenant la logique des trois passes (nettoyage, run, assertions).
