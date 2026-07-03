# Rozwiązanie - Ćwiczenie grupowe Ansible

## 📋 Opis

To rozwiązanie wdraża kompletną infrastrukturę Ansible z:
- **2 serwerami Apache2** (apache1, apache2)
- **2 serwerami Nginx** (nginx1, nginx2)
- Dedykowanymi playbookami dla każdego typu serwera
- Kompletnymi rolami z tasks, handlers, templates i zmiennymi
- Konfiguracją Docker do testów

## 🏗️ Struktura projektu

```
correction-pl/
├── ansible.cfg                 # Konfiguracja Ansible (ścieżki ról)
├── group_vars/
│   └── all.yml                 # Zmienne globalne (ansible_connection: docker)
├── inventories/
│   ├── apache2.yml             # Inwentarz serwerów Apache2
│   └── nginx.yml               # Inwentarz serwerów Nginx
├── playbooks/
│   ├── play-apache2.yml        # Playbook Apache2
│   └── play-nginx.yml          # Playbook Nginx
├── roles/
│   ├── apache2/
│   │   ├── tasks/main.yml
│   │   ├── handlers/main.yml
│   │   ├── templates/
│   │   │   ├── apache2.conf.j2
│   │   │   └── index.html.j2
│   │   └── vars/main.yml
│   └── nginx/
│       ├── tasks/main.yml
│       ├── handlers/main.yml
│       ├── templates/
│       │   ├── nginx.conf.j2
│       │   └── index.html.j2
│       └── vars/main.yml
├── docker-compose.yml          # Infrastruktura testowa
└── README.md                   # Ten plik
```

## 🚀 Instalacja i testowanie

### 1. Uruchom infrastrukturę Docker

```bash
# Z folderu correction-pl/
docker-compose up -d

# Sprawdź, czy wszystkie 4 kontenery działają
docker ps
```

### 2. Uruchom playbooki Apache2

```bash
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml
```

### 3. Uruchom playbooki Nginx

```bash
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml
```

### 4. Zweryfikuj wdrożenia

#### Test Apache2
```bash
# Wejdź do kontenera Apache
docker exec -it apache-server-1 bash

# Sprawdź usługę
service apache2 status

# Przetestuj stronę www
curl http://localhost

# Wyjdź z kontenera
exit
```

#### Test Nginx
```bash
# Wejdź do kontenera Nginx
docker exec -it nginx-server-1 bash

# Sprawdź usługę
service nginx status

# Przetestuj stronę www
curl http://localhost:8080

# Wyjdź z kontenera
exit
```

#### Dostęp z przeglądarki
- Nginx 1: http://localhost:8080
- Nginx 2: http://localhost:8081

## 🎯 Kluczowe elementy rozwiązania

### 1. Konfiguracja Ansible (ansible.cfg)
```ini
[defaults]
roles_path = ./roles
host_key_checking = False
stdout_callback = yaml
```
Definiuje ścieżki i opcje Ansible dla projektu.

### 2. Konfiguracja Docker (group_vars/all.yml)
```yaml
ansible_connection: docker
```
Ta konfiguracja pozwala Ansible zarządzać kontenerami jak serwerami.

### 3. Oddzielne inwentarze
- **apache2.yml**: Definiuje grupę `apache_servers` z apache1 i apache2
- **nginx.yml**: Definiuje grupę `nginx_servers` z nginx1 i nginx2

### 4. Dedykowane playbooki
- **play-apache2.yml**: Celuje w `apache_servers` i stosuje rolę `apache2`
- **play-nginx.yml**: Celuje w `nginx_servers` i stosuje rolę `nginx`

### 5. Kompletne role
Każda rola zawiera:
- **tasks/main.yml**: Instalacja i konfiguracja usługi
- **handlers/main.yml**: Zarządzanie restartem/przeładowaniem
- **templates/**: Dynamiczne konfiguracje z Jinja2
- **vars/main.yml**: Zmienne specyficzne dla roli

### 6. Szablony Jinja2
Szablony używają zmiennych do:
- Personalizacji konfiguracji (porty, ścieżki itd.)
- Wyświetlania dynamicznych informacji (hostname, IP itd.)
- Tworzenia spersonalizowanych stron HTML dla każdego serwera

### 7. Handlery
Handlery są uruchamiane tylko wtedy, gdy wykryto zmianę (idempotencja).

## 🔧 Przydatne polecenia

### Test inwentarza
```bash
# Lista hostów Apache
ansible -i inventories/apache2.yml all --list-hosts

# Lista hostów Nginx
ansible -i inventories/nginx.yml all --list-hosts

# Test połączenia
ansible -i inventories/apache2.yml all -m ping
```

### Tryb check (dry-run)
```bash
# Test bez stosowania zmian
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml --check
```

### Tryb verbose
```bash
# Pokaż więcej szczegółów
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml -v
```

## 🧹 Czyszczenie

```bash
# Zatrzymaj i usuń wszystkie kontenery
docker-compose down

# Usuń również wolumeny
docker-compose down -v
```

## 📚 Użyte koncepcje Ansible

1. **Inwentarze**: Organizacja serwerów w grupy
2. **Playbooki**: Orkiestracja wdrożeń
3. **Role**: Ponowne użycie i organizacja kodu
4. **Zmienne**: Personalizacja konfiguracji
5. **Szablony**: Dynamiczne generowanie plików
6. **Handlery**: Zarządzanie restartami
7. **Moduły**: apt, service, file, template
8. **Idempotencja**: Wielokrotne uruchomienia bez efektów ubocznych

## 💡 Ważne uwagi

- Kontenery muszą być uruchomione **przed** wykonaniem playbooków
- Python3 jest automatycznie instalowany w kontenerach przy starcie
- `ansible_connection: docker` jest zdefiniowane w `group_vars/all.yml`
- Porty Nginx są wystawione do testów z przeglądarki
- Apache nasłuchuje na porcie 80 (wewnątrz kontenerów)
- Nginx nasłuchuje na porcie 8080 (mapowany na hosta)

## 🎓 Dodatkowe ćwiczenia

1. Dodaj zmienną dla komunikatu powitalnego na stronach HTML
2. Utwórz nową rolę do instalacji MySQL
3. Dodaj tasks do zarządzania logami
4. Zaimplementuj zarządzanie certyfikatami SSL
5. Utwórz playbook, który wdraża obie role jednocześnie

---

✅ **Rozwiązanie zweryfikowane i przetestowane z Ansible 2026 i Docker**
