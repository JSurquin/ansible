# Correction — Variables Ansible + template Jinja2 (`nginx.conf`)

Ce document décrit la **correction de référence** et comment la **valider** contre le lab `docker-compose-lab.yml` à la racine du dépôt.

---

## Fichiers fournis

L’arborescence exécutable est dans :

`exo/correction-nginx-jinja/`

| Fichier | Rôle |
|--------|------|
| `inventory.yml` | Groupe `webservers` → conteneurs `ansible-lab-web01` … `web03`, connexion `docker` |
| `group_vars/webservers.yml` | Variables consommées par le template |
| `templates/nginx.conf.j2` | Template Jinja2 (conditions, boucles, `ansible_managed`) |
| `playbook.yml` | Installation, déploiement du template, cycle de vie de Nginx dans le conteneur |
| `test-lab.sh` | Script de non-régression (playbook + `nginx -t` + HTTP) |

---

## Détails de conception

- **Port 8080** : `nginx_listen_port` vaut `8080` pour limiter les conflits avec un autre service éventuellement présent sur le port 80 (ex. exercices Apache sur le même lab). Les élèves peuvent rester sur 80 sur un lab vierge ; la consigne insiste sur une variable de port pour cette raison.
- **Template** : `{% if nginx_enable_gzip %}` pour le bloc gzip ; boucles sur `nginx_index_files`, `nginx_gzip_types`, et `nginx_extra_headers.items()`.
- **`server_name`** : `{{ inventory_hostname }}.lab.local` pour différencier les trois nœuds sans dupliquer l’inventaire.
- **Playbook** : arrêt des processus `nginx`, suppression résiduelle de `/run/nginx.pid`, `nginx -t`, puis `nginx` — pattern robuste dans ces conteneurs sans systemd, après remplacement complet de `nginx.conf`.
- **Validation à la copie** : option `validate: nginx -t -c %s` du module `template`.

---

## Test exécuté (statut)

La correction a été jouée avec succès avec :

1. `docker compose -f docker-compose-lab.yml up -d` (depuis la racine du dépôt) ;
2. `cd exo/correction-nginx-jinja && ./test-lab.sh` ;

résultat : **playbook OK** sur `web01`–`web03`, **`nginx -t` OK**, **HTTP 200** sur `http://127.0.0.1:8080` dans chaque conteneur.

---

## Rejouer le test localement

```bash
# Racine du dépôt
docker compose -f docker-compose-lab.yml up -d

cd exo/correction-nginx-jinja
chmod +x test-lab.sh   # une seule fois si besoin
./test-lab.sh
```

---

## Contenu de référence (copie)

### `inventory.yml`

```yaml
---
# Inventaire aligné sur docker-compose-lab.yml (groupe webservers).
all:
  vars:
    ansible_connection: docker
    ansible_user: root
    ansible_python_interpreter: /usr/bin/python3
  children:
    webservers:
      hosts:
        web01:
          ansible_host: ansible-lab-web01
        web02:
          ansible_host: ansible-lab-web02
        web03:
          ansible_host: ansible-lab-web03
```

### `group_vars/webservers.yml`

```yaml
---
# Variables du groupe : utilisées par templates/nginx.conf.j2
nginx_worker_connections: 2048
# 8080 évite le conflit si Apache (autres exercices) occupe déjà le port 80 sur le lab
nginx_listen_port: 8080
# server_name dépend du nœud (hostname Ansible)
nginx_server_name: "{{ inventory_hostname }}.lab.local"
nginx_docroot: /var/www/html
nginx_index_files:
  - index.html
  - index.htm
nginx_enable_gzip: true
nginx_gzip_types:
  - text/plain
  - text/css
  - application/javascript
  - application/json
nginx_client_max_body_size: 2m
# En-têtes optionnels (boucle Jinja dans le template)
nginx_extra_headers:
  X-Lab-Exercise: "nginx-jinja"
  X-Frame-Options: "SAMEORIGIN"
```

### `templates/nginx.conf.j2`

```nginx
# {{ ansible_managed }}
user www-data;
worker_processes auto;
pid /run/nginx.pid;
error_log /var/log/nginx/error.log warn;

events {
    worker_connections {{ nginx_worker_connections }};
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    access_log /var/log/nginx/access.log;
    sendfile on;
    keepalive_timeout 65;
    client_max_body_size {{ nginx_client_max_body_size }};

{% if nginx_enable_gzip %}
    gzip on;
    gzip_vary on;
    gzip_min_length 256;
    gzip_types {% for t in nginx_gzip_types %}{{ t }}{% if not loop.last %} {% endif %}{% endfor %};
{% endif %}

    server {
        listen {{ nginx_listen_port }};
        server_name {{ nginx_server_name }};
        root {{ nginx_docroot }};
        index {% for f in nginx_index_files %}{{ f }}{% if not loop.last %} {% endif %}{% endfor %};

{% for header_name, header_value in nginx_extra_headers.items() %}
        add_header {{ header_name }} "{{ header_value }}";
{% endfor %}

        location / {
            try_files $uri $uri/ =404;
        }
    }
}
```

### `playbook.yml`

```yaml
---
- name: Nginx via variables et template Jinja2
  hosts: webservers
  gather_facts: true
  become: false

  tasks:
    - name: Paquets nginx
      ansible.builtin.apt:
        name: nginx
        state: present
        update_cache: true

    - name: Répertoire document root
      ansible.builtin.file:
        path: "{{ nginx_docroot }}"
        state: directory
        mode: "0755"

    - name: Page d'accueil (contenu minimal)
      ansible.builtin.copy:
        dest: "{{ nginx_docroot }}/index.html"
        mode: "0644"
        content: |
          <!DOCTYPE html>
          <html lang="fr"><head><meta charset="utf-8"><title>{{ inventory_hostname }}</title></head>
          <body><h1>{{ inventory_hostname }}</h1><p>Lab nginx + Jinja2</p></body></html>

    - name: Déployer nginx.conf depuis le template
      ansible.builtin.template:
        src: nginx.conf.j2
        dest: /etc/nginx/nginx.conf
        mode: "0644"
        validate: nginx -t -c %s

    - name: "Arrêter nginx (pidfile souvent incohérent dans le conteneur après changement de conf)"
      ansible.builtin.shell: pkill -x nginx
      failed_when: false
      changed_when: false

    - name: Retirer un éventuel pidfile résiduel
      ansible.builtin.file:
        path: /run/nginx.pid
        state: absent

    - name: Vérifier la syntaxe nginx
      ansible.builtin.command:
        cmd: nginx -t
      changed_when: false

    - name: Démarrer nginx
      ansible.builtin.command: nginx
```

---

## Variante pédagogique

Pour forcer l’usage du port 80 sur un lab neuf, remettez `nginx_listen_port: 80` dans `group_vars/webservers.yml` et adaptez l’URL dans `test-lab.sh` (ou arrêtez tout service concurrent sur 80 avant le test).
