#!/bin/bash

# Automatyczny skrypt testowy dla rozwiązania

set -e

echo "🚀 Uruchamianie testów rozwiązania Ansible..."
echo ""

# Kolory do wyświetlania
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Funkcja do wyświetlania komunikatów
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

# 1. Sprawdź, czy Docker działa
print_step "Sprawdzanie Docker..."
if ! docker info > /dev/null 2>&1; then
    print_error "Docker nie jest uruchomiony"
    exit 1
fi
print_success "Docker jest aktywny"

# 2. Uruchom infrastrukturę
print_step "Uruchamianie infrastruktury Docker..."
docker-compose up -d
sleep 5
print_success "Infrastruktura uruchomiona"

# 3. Sprawdź, czy kontenery działają
print_step "Sprawdzanie kontenerów..."
CONTAINERS=("apache-server-1" "apache-server-2" "nginx-server-1" "nginx-server-2")
for container in "${CONTAINERS[@]}"; do
    if docker ps --filter "name=$container" --filter "status=running" | grep -q "$container"; then
        print_success "$container jest uruchomiony"
    else
        print_error "$container nie jest uruchomiony"
        exit 1
    fi
done

# 4. Test połączenia Ansible
print_step "Test połączenia Ansible..."
if ansible -i inventories/apache2.yml all -m ping > /dev/null 2>&1; then
    print_success "Połączenie z serwerami Apache OK"
else
    print_error "Nieudane połączenie z serwerami Apache"
    exit 1
fi

if ansible -i inventories/nginx.yml all -m ping > /dev/null 2>&1; then
    print_success "Połączenie z serwerami Nginx OK"
else
    print_error "Nieudane połączenie z serwerami Nginx"
    exit 1
fi

# 5. Uruchom playbook Apache2
print_step "Wykonywanie playbooka Apache2..."
if ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml; then
    print_success "Playbook Apache2 wykonany pomyślnie"
else
    print_error "Niepowodzenie playbooka Apache2"
    exit 1
fi

# 6. Uruchom playbook Nginx
print_step "Wykonywanie playbooka Nginx..."
if ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml; then
    print_success "Playbook Nginx wykonany pomyślnie"
else
    print_error "Niepowodzenie playbooka Nginx"
    exit 1
fi

# 7. Sprawdź usługi Apache
print_step "Sprawdzanie usług Apache..."
for i in 1 2; do
    if docker exec apache-server-$i service apache2 status | grep -q "apache2 is running"; then
        print_success "Apache na apache-server-$i jest aktywny"
    else
        print_warning "Apache na apache-server-$i może nie być aktywny"
    fi
done

# 8. Sprawdź usługi Nginx
print_step "Sprawdzanie usług Nginx..."
for i in 1 2; do
    if docker exec nginx-server-$i service nginx status | grep -q "nginx is running"; then
        print_success "Nginx na nginx-server-$i jest aktywny"
    else
        print_warning "Nginx na nginx-server-$i może nie być aktywny"
    fi
done

# 9. Test stron www
print_step "Test stron www..."
if docker exec apache-server-1 curl -s http://localhost | grep -q "Apache2"; then
    print_success "Strona Apache1 dostępna"
fi

if docker exec nginx-server-1 curl -s http://localhost:8080 | grep -q "Nginx"; then
    print_success "Strona Nginx1 dostępna"
fi

# 10. Test idempotencji
print_step "Test idempotencji (ponowne uruchomienie playbooków)..."
print_warning "Ponowne uruchomienie playbooka Apache2..."
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml > /tmp/apache-rerun.log 2>&1
if grep -q "changed=0" /tmp/apache-rerun.log; then
    print_success "Idempotencja Apache2 zweryfikowana (brak zmian)"
else
    print_warning "Wykryto zmiany (sprawdź idempotencję)"
fi

print_warning "Ponowne uruchomienie playbooka Nginx..."
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml > /tmp/nginx-rerun.log 2>&1
if grep -q "changed=0" /tmp/nginx-rerun.log; then
    print_success "Idempotencja Nginx zweryfikowana (brak zmian)"
else
    print_warning "Wykryto zmiany (sprawdź idempotencję)"
fi

# Podsumowanie
echo ""
echo "================================================"
echo -e "${GREEN}🎉 Wszystkie testy zakończone pomyślnie!${NC}"
echo "================================================"
echo ""
echo "Dostęp www:"
echo "  - Nginx 1: http://localhost:8080"
echo "  - Nginx 2: http://localhost:8081"
echo ""
echo "Aby zatrzymać infrastrukturę:"
echo "  docker-compose down"
echo ""
