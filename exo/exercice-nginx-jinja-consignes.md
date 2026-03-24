# Exercice — Variables Ansible et template Jinja2 (`nginx.conf`)

## Objectif

Déployer **Nginx** sur les trois nœuds **web** du lab Docker en pilotant la configuration via des **variables de groupe** et un fichier **`nginx.conf` généré par un template Jinja2** (`.j2`).

**Durée indicative** : 60 à 90 minutes.

---

## Prérequis

- Lab Docker du dépôt démarré :

```bash
docker compose -f docker-compose-lab.yml up -d
```

- Attendre que les conteneurs aient fini leurs installations initiales (SSH, paquets de base), puis vérifier la présence des hôtes `ansible-lab-web01`, `ansible-lab-web02`, `ansible-lab-web03`.
- Ansible installé sur la machine qui exécute les playbooks (`ansible-playbook --version`).

---

## Rappels utiles (sans tout résoudre)

- Un **template** Ansible est un fichier côté contrôleur (souvent dans `templates/`) rendu avec le moteur **Jinja2**, puis copié sur la cible (module adapté : cherchez dans la doc Ansible le module qui déploie un fichier à partir d’un modèle).
- Les variables définies pour un **groupe** d’inventaire se placent couramment dans un répertoire **`group_vars/`**, dans un fichier nommé comme le groupe (par convention).
- Dans un template, on peut utiliser des constructions Jinja2 du type **conditions** et **boucles** pour éviter de dupliquer des blocs de configuration.
- La directive **`ansible_managed`** (commentaire en tête de fichier généré) permet d’indiquer qu’un fichier est géré par Ansible ; regardez comment l’insérer proprement dans un template.

---

## Mission 1 — Inventaire

Créez un inventaire (YAML recommandé) qui :

- définit un groupe regroupant les trois serveurs web du lab (`web01`, `web02`, `web03`) ;
- pour chaque hôte, renseigne le **nom du conteneur Docker** attendu par Ansible en connexion `docker` (comme dans les exercices d’introduction du dépôt) ;
- applique les variables de connexion nécessaires au lab (`ansible_connection`, utilisateur, interpréteur Python).

Vous pouvez travailler dans un dossier dédié (par exemple `mon-exo-nginx-jinja/`).

---

## Mission 2 — Variables de groupe

Pour le groupe des serveurs web, définissez au minimum des variables pour :

- le **port d’écoute** HTTP de Nginx (pensez à le rendre configurable plutôt que figé dans le template) ;
- le **`server_name`** (idéalement **différent par machine** : une variable peut s’appuyer sur des faits ou sur le nom d’inventaire) ;
- le **répertoire racine** des fichiers servis ;
- une **liste** de noms de fichiers d’index (utilisée dans le `nginx.conf` via une boucle Jinja2) ;
- un booléen du style « activer ou non la compression gzip » et, si gzip est activé, une **liste de types MIME** à passer à la directive `gzip_types` ;
- une **taille max** du corps des requêtes client (`client_max_body_size` ou équivalent) ;
- un **dictionnaire** d’en-têtes HTTP à ajouter (nom → valeur), déployé via une **boucle** sur le dictionnaire dans le template.

Vous ajusterez les noms de variables pour qu’ils restent lisibles et cohérents avec le template.

---

## Mission 3 — Template `nginx.conf.j2`

Produisez un fichier `nginx.conf` **valide** pour Ubuntu (paquet `nginx` du dépôt officiel), en vous appuyant sur un template qui :

- inclut les fichiers `mime.types` fournis par le paquet (chemin habituel sous `/etc/nginx/`) ;
- utilise vos variables pour `worker_connections`, port d’écoute, `server_name`, `root`, `index`, gzip conditionnel, `client_max_body_size`, et les en-têtes supplémentaires ;
- reste **minimal mais fonctionnel** : un seul bloc `server` suffit pour cet exercice.

**Contrainte pédagogique** : au moins une **condition** `{% if ... %}` et au moins une **boucle** `{% for ... %}` doivent apparaître dans le template (en plus de l’usage courant de `{{ variable }}`).

---

## Mission 4 — Playbook

Écrivez un playbook qui, sur le groupe web :

- installe le paquet **nginx** (gestionnaire de paquets de la distribution des conteneurs) ;
- assure l’existence du répertoire document root et y place une **page d’accueil minimaliste** (HTML statique ou généré, au choix) ;
- déploie votre template vers **`/etc/nginx/nginx.conf`** en vérifiant la syntaxe avant de remplacer le fichier définitif (le module de template propose une option de **validation** ; consultez la doc) ;
- applique la nouvelle configuration : dans un conteneur sans *systemd* classique, il faudra réfléchir à la façon de **recharger ou redémarrer** Nginx de manière fiable (évitez les solutions « magiques » non comprises).

---

## Critères de réussite (auto-évaluation)

Sur **chaque** conteneur `ansible-lab-web01` à `ansible-lab-web03` :

- `nginx -t` se termine sans erreur ;
- une requête HTTP vers le **port que vous avez configuré** sur `127.0.0.1` depuis **l’intérieur** du conteneur retourne un code **200** (par exemple avec Python `urllib` ou un outil que vous installerez volontairement via le playbook).

---

## Pièges fréquents (réflexion, pas la solution)

- **Port 80** peut déjà être pris par un autre service si vous avez joué d’autres playbooks sur le même lab : une variable pour le port d’écoute est utile.
- Ansible interprète **Jinja2** dans les playbooks YAML : certains caractères dans une chaîne `shell` peuvent être ambigus ; la doc Ansible et le module `command` peuvent aider à simplifier.
- Après remplacement complet de `nginx.conf`, le **fichier PID** ou des processus résiduels peuvent perturber un simple « reload » ; anticipez ce cas dans un environnement conteneurisé.

---

## Livrables attendus

À rendre (structure indicative) :

- `inventory.yml` (ou équivalent) ;
- `group_vars/...` ;
- `templates/nginx.conf.j2` ;
- `playbook.yml` (nom libre si cohérent).

La correction de référence du formateur se trouve dans le dépôt sous `exo/exercice-nginx-jinja-correction.md` (ne pas consulter avant d’avoir tenté l’exercice).
