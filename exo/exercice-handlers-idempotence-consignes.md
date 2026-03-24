# Exercice — Handlers et idempotence

## Objectif

Écrire un **playbook Ansible** qui met à jour un **fichier de configuration** sur un hôte du lab et n’exécute une **action de suite** (rechargement, redémarrage, ou autre logique métier) **que lorsque ce fichier a réellement changé**. La **deuxième exécution** du playbook, sans modification des entrées, ne doit **pas** se comporter comme la première du point de vue de cette action de suite.

**Durée indicative** : 45 à 60 minutes.

---

## Prérequis

- Lab du dépôt démarré :

```bash
docker compose -f docker-compose-lab.yml up -d
```

- Conteneur **`ansible-lab-web01`** joignable (comme dans les autres exercices « connexion docker »).
- Ansible installé localement.

---

## Rappels (volontairement courts)

- La documentation Ansible décrit des blocs nommés exécutés **à la fin du play** lorsqu’une tâche les **notifie** — cherchez le mot-clé adapté dans la section *Handlers*.
- L’**idempotence** signifie qu’une nouvelle exécution sans changement de contexte ne refait pas inutilement le travail : les modules « bien utilisés » annoncent souvent `ok` plutôt que `changed` lorsque l’état cible est déjà atteint.

---

## Contraintes de réalisation

1. Ciblez **au moins un** hôte du lab (vous pouvez n’en prendre qu’un pour clarifier la lecture du résumé de fin de playbook).
2. Le fichier déployé doit **dépendre d’au moins une variable** (inventaire, `group_vars`, `host_vars` ou extra-vars).
3. Utilisez un mécanisme Ansible **standard** pour enchaîner une action **après** modification du fichier — pas un simple enchaînement de deux tâches indépendantes sans lien de cause à effet.
4. Montrez **vous-même** l’idempotence : **deux exécutions consécutives** du même playbook, sans rien modifier entre les deux, doivent donner un résumé final où la machine concernée affiche **`changed=0`** (ou équivalent compréhensible si vous avez plusieurs tâches, mais le comportement attendu doit rester clair pour un correcteur).
5. Prévoyez un moyen **observable** (fichier journal, message, service, etc.) de constater que l’action de suite **ne s’est pas reproduite** au second passage, alors qu’elle **s’est produite** au premier.

---

## Bonus (optionnel)

- Troisième exécution : changez la valeur d’une variable (par exemple via **extra-vars** en ligne de commande) de façon à modifier le contenu du fichier déployé ; l’action de suite doit **à nouveau** avoir lieu.

---

## Livrables

- Un inventaire (ou extrait) cohérent avec le lab.
- Un playbook (éventuellement des fichiers `templates/` ou `group_vars/`).
- Une courte note pour vous (ou le formateur) expliquant comment vous vérifiez les points 4 et 5.

La correction de référence : `exo/exercice-handlers-idempotence-correction.md` (à ouvrir après tentative).
