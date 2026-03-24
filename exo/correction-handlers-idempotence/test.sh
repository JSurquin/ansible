#!/usr/bin/env bash
# Valide la correction « handlers + idempotence » contre docker-compose-lab.yml.
# Prérequis : depuis la racine du dépôt → docker compose -f docker-compose-lab.yml up -d
# Puis : cd exo/correction-handlers-idempotence && ./test.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$(dirname "$0")"

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

die() { echo -e "${RED}✗${NC} $*" >&2; exit 1; }
ok() { echo -e "${GREEN}✓${NC} $*"; }
step() { echo -e "${BLUE}==>${NC} $*"; }

step "Vérification Docker..."
docker info >/dev/null 2>&1 || die "Docker indisponible"

CONTAINER="ansible-lab-web01"
docker ps --format '{{.Names}}' | grep -Fxq "$CONTAINER" || die "Conteneur $CONTAINER absent — lancez : docker compose -f $ROOT/docker-compose-lab.yml up -d"
ok "Conteneur $CONTAINER présent"

INV="inventory.yml"
PB="playbook.yml"

step "Réinitialisation des fichiers de test dans le conteneur..."
ansible -i "$INV" handler_lab -m ansible.builtin.file -a "path=/tmp/lab_handler_audit.log state=absent" >/dev/null
ansible -i "$INV" handler_lab -m ansible.builtin.file -a "path=/etc/lab-handlers-test.conf state=absent" >/dev/null
ok "Fichiers nettoyés"

step "1er ansible-playbook (attendu : tâche « changed » + exécution du handler)..."
OUT1="$(mktemp)"
ansible-playbook -i "$INV" "$PB" 2>&1 | tee "$OUT1"
grep -q "RUNNING HANDLER \[Journaliser passage du handler\]" "$OUT1" || die "Le handler n’a pas été exécuté au 1er run"
grep -E 'lab01\s+:\s+.*\bchanged=[1-9][0-9]*\b' "$OUT1" | head -1 | grep -q . || die "1er run : attendu changed > 0 pour lab01 dans PLAY RECAP"

LINES1="$(docker exec "$CONTAINER" sh -c 'wc -l < /tmp/lab_handler_audit.log' | tr -d '[:space:]')"
[[ "$LINES1" == "1" ]] || die "Après 1er run : attendu 1 ligne dans /tmp/lab_handler_audit.log, obtenu : $LINES1"
ok "1er run OK (handler une fois, journal à 1 ligne)"

step "2e ansible-playbook (attendu : idempotence, pas de handler)..."
OUT2="$(mktemp)"
ansible-playbook -i "$INV" "$PB" 2>&1 | tee "$OUT2"
grep -q "RUNNING HANDLER \[Journaliser passage du handler\]" "$OUT2" && die "Le handler ne devrait pas s’exécuter au 2e run"
grep -E 'lab01\s+:\s+.*\bchanged=0\b' "$OUT2" | head -1 | grep -q . || die "2e run : attendu changed=0 pour lab01 dans PLAY RECAP"

LINES2="$(docker exec "$CONTAINER" sh -c 'wc -l < /tmp/lab_handler_audit.log' | tr -d '[:space:]')"
[[ "$LINES2" == "1" ]] || die "Après 2e run : attendu toujours 1 ligne dans le journal, obtenu : $LINES2"
ok "2e run OK (idempotence, handler non relancé)"

step "3e run avec variable modifiée (attendu : re-changed + handler à nouveau)..."
OUT3="$(mktemp)"
ansible-playbook -i "$INV" "$PB" -e 'lab_banner=lab-handlers-v2-trigger' 2>&1 | tee "$OUT3"
grep -q "RUNNING HANDLER \[Journaliser passage du handler\]" "$OUT3" || die "Le handler devrait s’exécuter quand la config change (3e run)"
grep -E 'lab01\s+:\s+.*\bchanged=[1-9][0-9]*\b' "$OUT3" | head -1 | grep -q . || die "3e run : attendu changed > 0 pour lab01"

LINES3="$(docker exec "$CONTAINER" sh -c 'wc -l < /tmp/lab_handler_audit.log' | tr -d '[:space:]')"
[[ "$LINES3" == "2" ]] || die "Après 3e run : attendu 2 lignes dans le journal, obtenu : $LINES3"
ok "3e run OK (changement de variable → handler relancé)"

rm -f "$OUT1" "$OUT2" "$OUT3"
echo -e "${GREEN}Tous les tests sont passés.${NC}"
