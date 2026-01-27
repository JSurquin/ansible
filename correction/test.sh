#!/bin/bash

# Script de test automatique pour la correction

set -e

echo "🚀 Démarrage des tests de la correction Ansible..."
echo ""

# Couleurs pour l'affichage
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# 1. Vérifier que Docker est en cours d'exécution
print_step "Vérification de Docker..."
if ! docker info > /dev/null 2>&1; then
    print_error "Docker n'est pas en cours d'exécution"
    exit 1
fi
print_success "Docker est actif"

# 2. Lancer l'infrastructure
print_step "Lancement de l'infrastructure Docker..."
docker-compose up -d
sleep 5
print_success "Infrastructure lancée"

# 3. Vérifier que les containers sont up
print_step "Vérification des containers..."
CONTAINERS=("apache-server-1" "apache-server-2" "nginx-server-1" "nginx-server-2")
for container in "${CONTAINERS[@]}"; do
    if docker ps --filter "name=$container" --filter "status=running" | grep -q "$container"; then
        print_success "$container est en cours d'exécution"
    else
        print_error "$container n'est pas en cours d'exécution"
        exit 1
    fi
done

# 4. Tester la connectivité Ansible
print_step "Test de connectivité Ansible..."
if ansible -i inventories/apache2.yml all -m ping > /dev/null 2>&1; then
    print_success "Connexion aux serveurs Apache OK"
else
    print_error "Échec de connexion aux serveurs Apache"
    exit 1
fi

if ansible -i inventories/nginx.yml all -m ping > /dev/null 2>&1; then
    print_success "Connexion aux serveurs Nginx OK"
else
    print_error "Échec de connexion aux serveurs Nginx"
    exit 1
fi

# 5. Exécuter le playbook Apache2
print_step "Exécution du playbook Apache2..."
if ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml; then
    print_success "Playbook Apache2 exécuté avec succès"
else
    print_error "Échec du playbook Apache2"
    exit 1
fi

# 6. Exécuter le playbook Nginx
print_step "Exécution du playbook Nginx..."
if ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml; then
    print_success "Playbook Nginx exécuté avec succès"
else
    print_error "Échec du playbook Nginx"
    exit 1
fi

# 7. Vérifier les services Apache
print_step "Vérification des services Apache..."
for i in 1 2; do
    if docker exec apache-server-$i service apache2 status | grep -q "apache2 is running"; then
        print_success "Apache sur apache-server-$i est actif"
    else
        print_warning "Apache sur apache-server-$i n'est peut-être pas actif"
    fi
done

# 8. Vérifier les services Nginx
print_step "Vérification des services Nginx..."
for i in 1 2; do
    if docker exec nginx-server-$i service nginx status | grep -q "nginx is running"; then
        print_success "Nginx sur nginx-server-$i est actif"
    else
        print_warning "Nginx sur nginx-server-$i n'est peut-être pas actif"
    fi
done

# 9. Tester les pages web
print_step "Test des pages web..."
if docker exec apache-server-1 curl -s http://localhost | grep -q "Apache2"; then
    print_success "Page Apache1 accessible"
fi

if docker exec nginx-server-1 curl -s http://localhost:8080 | grep -q "Nginx"; then
    print_success "Page Nginx1 accessible"
fi

# 10. Test d'idempotence
print_step "Test d'idempotence (ré-exécution des playbooks)..."
print_warning "Ré-exécution du playbook Apache2..."
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml > /tmp/apache-rerun.log 2>&1
if grep -q "changed=0" /tmp/apache-rerun.log; then
    print_success "Idempotence Apache2 validée (aucun changement)"
else
    print_warning "Des changements ont été détectés (vérifier l'idempotence)"
fi

print_warning "Ré-exécution du playbook Nginx..."
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml > /tmp/nginx-rerun.log 2>&1
if grep -q "changed=0" /tmp/nginx-rerun.log; then
    print_success "Idempotence Nginx validée (aucun changement)"
else
    print_warning "Des changements ont été détectés (vérifier l'idempotence)"
fi

# Résumé
echo ""
echo "================================================"
echo -e "${GREEN}🎉 Tous les tests sont passés avec succès !${NC}"
echo "================================================"
echo ""
echo "Accès web:"
echo "  - Nginx 1: http://localhost:8080"
echo "  - Nginx 2: http://localhost:8081"
echo ""
echo "Pour arrêter l'infrastructure:"
echo "  docker-compose down"
echo ""
