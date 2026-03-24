#!/usr/bin/env bash
# Teste la correction contre docker-compose-lab.yml (racine du dépôt).
# Usage : depuis la racine du repo → docker compose -f docker-compose-lab.yml up -d
#         puis : cd exo/correction-nginx-jinja && ./test-lab.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$(dirname "$0")"

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}==>${NC} Vérification Docker..."
docker info >/dev/null 2>&1 || { echo -e "${RED}Docker indisponible${NC}"; exit 1; }

for c in ansible-lab-web01 ansible-lab-web02 ansible-lab-web03; do
  if ! docker ps --format '{{.Names}}' | grep -Fxq "$c"; then
    echo -e "${RED}Conteneur $c absent. Lancez : docker compose -f $ROOT/docker-compose-lab.yml up -d${NC}"
    exit 1
  fi
done
echo -e "${GREEN}✓${NC} Conteneurs web du lab présents"

echo -e "${BLUE}==>${NC} ansible-playbook..."
ansible-playbook -i inventory.yml playbook.yml

echo -e "${BLUE}==>${NC} Vérifications dans les conteneurs..."
for c in ansible-lab-web01 ansible-lab-web02 ansible-lab-web03; do
  docker exec "$c" nginx -t
  code="$(docker exec "$c" python3 -c "import urllib.request; r=urllib.request.urlopen('http://127.0.0.1:8080'); print(r.status)")"
  if [[ "$code" != "200" ]]; then
    echo -e "${RED}HTTP $code sur $c${NC}"
    exit 1
  fi
  echo -e "${GREEN}✓${NC} $c : nginx -t OK, HTTP 200"
done

echo -e "${GREEN}Tous les tests sont passés.${NC}"
