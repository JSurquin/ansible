# Niezbędne polecenia - Rozwiązanie ćwiczenia Ansible

## 🚀 Szybki start

```bash
# 1. Uruchom infrastrukturę
docker-compose up -d

# 2. Wdróż Apache2
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml

# 3. Wdróż Nginx
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml

# 4. Uruchom wszystkie automatyczne testy
./test.sh
```

## 📋 Szczegółowe polecenia

### Zarządzanie Docker

```bash
# Uruchom kontenery
docker-compose up -d

# Zobacz logi
docker-compose logs -f

# Zatrzymaj kontenery
docker-compose stop

# Zatrzymaj i usuń
docker-compose down

# Lista kontenerów
docker ps

# Wejdź do kontenera
docker exec -it apache-server-1 bash
docker exec -it nginx-server-1 bash
```

### Ansible - Inwentarze

```bash
# Lista wszystkich hostów Apache
ansible -i inventories/apache2.yml all --list-hosts

# Lista wszystkich hostów Nginx
ansible -i inventories/nginx.yml all --list-hosts

# Wyświetl inwentarz szczegółowo
ansible-inventory -i inventories/apache2.yml --list
ansible-inventory -i inventories/nginx.yml --graph
```

### Ansible - Testy łączności

```bash
# Ping wszystkich serwerów Apache
ansible -i inventories/apache2.yml all -m ping

# Ping wszystkich serwerów Nginx
ansible -i inventories/nginx.yml all -m ping

# Test polecenia ad-hoc
ansible -i inventories/apache2.yml all -m command -a "hostname"
```

### Ansible - Wykonywanie playbooków

```bash
# Tryb normalny
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml

# Tryb check (dry-run, nic nie robi)
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml --check

# Tryb diff (pokazuje zmiany)
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml --diff

# Tryb verbose (-v, -vv, -vvv, -vvvv)
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml -v
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml -vvv

# Celuj w jeden host
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml --limit apache1

# Zacznij od konkretnego taska
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml --start-at-task="Install Nginx"
```

### Ansible - Zmienne

```bash
# Wyświetl wszystkie zmienne hosta
ansible -i inventories/apache2.yml apache1 -m debug -a "var=hostvars[inventory_hostname]"

# Wyświetl facts
ansible -i inventories/apache2.yml apache1 -m setup

# Wyświetl konkretną zmienną
ansible -i inventories/apache2.yml apache1 -m debug -a "var=ansible_hostname"
```

### Weryfikacja usług

```bash
# Apache
docker exec apache-server-1 service apache2 status
docker exec apache-server-1 curl http://localhost

# Nginx
docker exec nginx-server-1 service nginx status
docker exec nginx-server-1 curl http://localhost:8080

# Zobacz logi
docker exec apache-server-1 cat /var/log/apache2/error.log
docker exec nginx-server-1 cat /var/log/nginx/error.log
```

### Testy z hosta

```bash
# Dostęp do stron Nginx z Twojej maszyny
curl http://localhost:8080  # Nginx 1
curl http://localhost:8081  # Nginx 2

# Lub otwórz w przeglądarce
open http://localhost:8080  # macOS
xdg-open http://localhost:8080  # Linux
```

### Przydatne polecenia debugowania

```bash
# Sprawdź składnię playbooka
ansible-playbook --syntax-check -i inventories/apache2.yml playbooks/play-apache2.yml

# Lista tasków bez wykonywania
ansible-playbook --list-tasks -i inventories/nginx.yml playbooks/play-nginx.yml

# Wyświetl docelowe hosty
ansible-playbook --list-hosts -i inventories/apache2.yml playbooks/play-apache2.yml

# Wykonaj w trybie krok po kroku
ansible-playbook --step -i inventories/nginx.yml playbooks/play-nginx.yml
```

### Zarządzanie rolami

```bash
# Lista dostępnych ról
ls -la roles/

# Struktura roli
tree roles/apache2/
tree roles/nginx/

# Testuj tylko jedną rolę
ansible -i inventories/apache2.yml apache1 -m include_role -a name=apache2
```

### Czyszczenie

```bash
# Usuń wszystkie kontenery
docker-compose down

# Usuń kontenery + wolumeny
docker-compose down -v

# Wyczyść nieużywane obrazy Docker
docker system prune -a
```

## 🔧 Testy idempotencji

```bash
# Pierwsze wykonanie (powinno wprowadzić zmiany)
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml

# Drugie wykonanie (nie powinno nic zmieniać)
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml

# Sprawdź wynik: "changed=0" = idempotentne ✅
```

## 📊 Analiza wydajności

```bash
# Zmierz czas wykonania
time ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml

# Profiluj taski (najwolniejsze na początku)
ANSIBLE_CALLBACK_WHITELIST=profile_tasks ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml
```

## 🎯 Scenariusze testowe

### Scenariusz 1: Wdrożenie początkowe
```bash
docker-compose up -d
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml
```

### Scenariusz 2: Zmiana konfiguracji
```bash
# Zmodyfikuj group_vars/all.yml (np. zmień apache_port)
# Uruchom ponownie playbook
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml
# Sprawdź, czy handler został uruchomiony
```

### Scenariusz 3: Dodanie nowego serwera
```bash
# Dodaj apache3 w inventories/apache2.yml
# Dodaj usługę w docker-compose.yml
docker-compose up -d
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml --limit apache3
```

### Scenariusz 4: Odtworzenie po usunięciu
```bash
# Usuń Apache z kontenera
docker exec apache-server-1 apt-get remove -y apache2
# Uruchom ponownie playbook, aby przywrócić
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml --limit apache1
```

## 💡 Wskazówki

```bash
# Utwórz aliasy dla długich poleceń
alias ap-apache='ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml'
alias ap-nginx='ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml'

# Użyj
ap-apache
ap-nginx

# Zmienna środowiskowa dla stałego trybu verbose
export ANSIBLE_STDOUT_CALLBACK=yaml
export ANSIBLE_VERBOSITY=1
```

---

📝 **Uwaga**: Wszystkie te polecenia należy wykonywać z folderu `correction-pl/`
