# 📖 Szczegółowe wyjaśnienia rozwiązania

## Przegląd

To rozwiązanie ilustruje kompletną i profesjonalną architekturę Ansible. Oto dlaczego każdy element jest zorganizowany w ten sposób.

---

## 🗂️ Struktura projektu

### 1. `group_vars/all.yml` - Zmienne globalne

```yaml
ansible_connection: docker
apache_port: 80
nginx_port: 8080
```

**Dlaczego tutaj?**
- ✅ Zmienne wspólne dla **wszystkich** serwerów
- ✅ Jedno miejsce do modyfikacji globalnej konfiguracji
- ✅ `ansible_connection: docker` dotyczy wszystkich hostów

**Możliwa alternatywa**:
- Zmienne w każdym inwentarzu (mniej DRY)
- Zmienne w playbookach (mniej wielokrotnego użycia)

---

### 2. `inventories/` - Oddzielne inwentarze

**Dlaczego 2 oddzielne inwentarze?**

```
inventories/
├── apache2.yml  → Tylko serwery Apache
└── nginx.yml    → Tylko serwery Nginx
```

**Zalety**:
- ✅ Niezależne wdrożenie: `ansible-playbook -i inventories/apache2.yml ...`
- ✅ Logiczne grupy: `apache_servers` vs `nginx_servers`
- ✅ Elastyczność: Różne zmienne per grupa

**Rzeczywisty scenariusz**:
```bash
# Wdróż tylko serwery web w produkcji
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml

# Wdróż tylko serwery API
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml
```

**Struktura inwentarzy**:
```yaml
all:
  children:
    apache_servers:      # Nazwa grupy
      hosts:
        apache1:         # Nazwa logiczna
          ansible_host: apache-server-1  # Nazwa kontenera Docker
          server_id: 1   # Zmienna specyficzna dla hosta
```

---

### 3. `playbooks/` - Dedykowane playbooki

**Dlaczego jeden playbook na typ serwera?**

```
playbooks/
├── play-apache2.yml  → Konfiguruje Apache
└── play-nginx.yml    → Konfiguruje Nginx
```

**Zalety**:
- ✅ Zasada pojedynczej odpowiedzialności (Single Responsibility Principle)
- ✅ Możliwość ponownego użycia
- ✅ Uproszczona konserwacja

**Struktura playbooka**:
```yaml
- name: Konfiguracja serwerów Apache2
  hosts: apache_servers    # Celuje w grupę z inwentarza
  become: yes              # Wykonuje z sudo
  roles:
    - apache2              # Stosuje rolę apache2
```

**Dlaczego `become: yes`?**
- Instalacja pakietów → Wymaga uprawnień root
- Modyfikacja `/etc/` → Wymaga uprawnień root
- Uruchamianie usług → Wymaga uprawnień root

---

### 4. `roles/` - Organizacja w rolach

**Architektura roli**:
```
roles/apache2/
├── tasks/          → Co robić
├── handlers/       → Reakcje na zmiany
├── templates/      → Pliki dynamiczne
└── vars/           → Zmienne roli
```

#### 4.1 `tasks/main.yml` - Akcje

```yaml
- name: Install Apache2
  apt:
    name: "{{ apache_package }}"
    state: present

- name: Deploy configuration
  template:
    src: apache2.conf.j2
    dest: "{{ apache_config_path }}"
  notify: restart apache2  # ← Uruchamia handler
```

**Kluczowe koncepcje**:
- **Kolejność wykonania**: Od góry do dołu
- **Idempotencja**: Można uruchomić ponownie bez efektów ubocznych
- **Moduły**: `apt`, `template`, `service`, `file`
- **Notify**: Uruchamia handler przy zmianie

#### 4.2 `handlers/main.yml` - Reakcje

```yaml
- name: restart apache2
  service:
    name: "{{ apache_service }}"
    state: restarted
```

**Dlaczego handlery?**
- ✅ Restartuje TYLKO jeśli konfiguracja zmieniona
- ✅ Wykonany RAZ na końcu (nawet jeśli powiadomiony wielokrotnie)
- ✅ Zoptymalizowana wydajność

**Przykład**:
```
1. Modyfikacja apache2.conf → notify "restart apache2"
2. Modyfikacja index.html → (brak notify)
3. Koniec playbooka → Handler "restart apache2" wykonany RAZ
```

#### 4.3 `templates/` - Pliki dynamiczne

**Szablon Jinja2** (`apache2.conf.j2`):
```apache
<VirtualHost *:{{ apache_port }}>
    ServerName {{ apache_server_name }}
    DocumentRoot {{ apache_document_root }}
    # Hostname: {{ ansible_hostname }}
</VirtualHost>
```

**Zalety**:
- ✅ Dynamiczna konfiguracja per serwer
- ✅ Używa zmiennych Ansible
- ✅ Dostęp do facts (`ansible_hostname` itd.)

**Renderowanie na apache1**:
```apache
<VirtualHost *:80>
    ServerName apache.local
    DocumentRoot /var/www/html
    # Hostname: apache1
</VirtualHost>
```

**Renderowanie na apache2**:
```apache
<VirtualHost *:80>
    ServerName apache.local
    DocumentRoot /var/www/html
    # Hostname: apache2
</VirtualHost>
```

#### 4.4 `vars/main.yml` - Zmienne roli

```yaml
apache_package: apache2
apache_service: apache2
apache_document_root: /var/www/html
```

**Dlaczego tutaj, a nie w `group_vars/`?**
- ✅ Zmienne specyficzne dla roli Apache
- ✅ Przenośność: Rola może być użyta gdzie indziej
- ✅ Enkapsulacja: Wewnętrzne szczegóły roli pozostają w roli

**Hierarchia zmiennych** (od najmniej do najbardziej priorytetowej):
1. `roles/*/vars/main.yml`
2. `group_vars/all.yml`
3. `inventories/*/hosts` (zmienne hosta)
4. Zmienne z linii poleceń: `-e "apache_port=8080"`

---

## 🔄 Kompletny przepływ wykonania

Gdy uruchamiasz:
```bash
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml
```

**Oto co się dzieje**:

### Krok 1: Odczyt inwentarza
```
inventories/apache2.yml
↓
Ładuje hosty: apache1, apache2
Czyta ansible_host: apache-server-1, apache-server-2
```

### Krok 2: Odczyt zmiennych globalnych
```
group_vars/all.yml
↓
ansible_connection: docker
apache_port: 80
nginx_port: 8080
```

### Krok 3: Odczyt playbooka
```
playbooks/play-apache2.yml
↓
Cel: apache_servers
Rola do zastosowania: apache2
```

### Krok 4: Ładowanie roli
```
roles/apache2/
↓
Ładuje vars/main.yml (zmienne)
Ładuje tasks/main.yml (akcje)
Ładuje handlers/main.yml (reakcje)
Przygotowuje templates/ (pliki dynamiczne)
```

### Krok 5: Wykonanie tasków na apache1
```
1. Aktualizacja APT
2. Instalacja Apache2
3. Utworzenie /var/www/html
4. Generowanie apache2.conf z szablonu
   → Jeśli zmieniony: zapis "restart apache2" w kolejce
5. Generowanie index.html z szablonu
6. Uruchomienie Apache2
```

### Krok 6: Wykonanie tasków na apache2
```
(Ten sam proces co apache1)
```

### Krok 7: Wykonanie handlerów
```
Jeśli "restart apache2" został powiadomiony:
  → Restart Apache na dotkniętych serwerach
```

---

## 🎯 Ilustrowane koncepcje Ansible

### 1. Idempotencja

**Pierwsze wykonanie**:
```
TASK [apache2 : Install Apache2]
changed: [apache1]
changed: [apache2]
```

**Drugie wykonanie**:
```
TASK [apache2 : Install Apache2]
ok: [apache1]  ← Już zainstalowany, nic do zrobienia
ok: [apache2]  ← Już zainstalowany, nic do zrobienia
```

### 2. Zmienne i facts

**Zdefiniowane zmienne**:
- `apache_port: 80` (group_vars)
- `server_id: 1` (inwentarz)

**Automatycznie zbierane facts**:
- `ansible_hostname`: "apache1"
- `ansible_distribution`: "Ubuntu"
- `ansible_distribution_version`: "22.04"

**Użycie w szablonach**:
```jinja
<h1>Serwer {{ ansible_hostname }}</h1>
<p>Port: {{ apache_port }}</p>
<p>ID: {{ server_id }}</p>
```

### 3. Rozdzielenie odpowiedzialności

```
group_vars/     → Konfiguracja globalna
inventories/    → Definicja serwerów
playbooks/      → Orkiestracja
roles/          → Logika biznesowa
  ├── tasks/    → Akcje
  ├── handlers/ → Reakcje
  ├── templates/→ Pliki dynamiczne
  └── vars/     → Konfiguracja roli
```

---

## 🐳 Integracja Docker

### Konfiguracja w `group_vars/all.yml`

```yaml
ansible_connection: docker
```

**Co to robi**:
- Zamiast SSH → Używa API Docker
- Zamiast `ssh user@host` → Używa `docker exec container`

### Równoważność

**Polecenie Ansible**:
```bash
ansible -i inventories/apache2.yml apache1 -m command -a "hostname"
```

**Równoważnik Docker**:
```bash
docker exec apache-server-1 hostname
```

**Dlaczego jest to transparentne?**
- Ansible abstrahuje połączenie
- Reszta kodu jest identyczna
- W produkcji wystarczy zmienić `ansible_connection: ssh`

---

## 🔐 Zastosowane dobre praktyki

### ✅ 1. Przejrzysta organizacja
```
correction-pl/
├── group_vars/      # Globalne
├── inventories/     # Serwery
├── playbooks/       # Orkiestracja
└── roles/           # Logika
```

### ✅ 2. Opisowe nazewnictwo
- `play-apache2.yml` (nie `playbook1.yml`)
- `apache_servers` (nie `group1`)
- `restart apache2` (nie `handler1`)

### ✅ 3. Zmienne wielokrotnego użycia
```yaml
apache_package: apache2
```
Pozwala łatwo zmienić na `httpd` na RedHat.

### ✅ 4. Szablony dla konfiguracji
- Brak plików statycznych
- Dynamiczna konfiguracja
- Dostosowanie per serwer

### ✅ 5. Handlery dla wydajności
- Restart tylko gdy konieczny
- Wykonany raz

### ✅ 6. Gwarantowana idempotencja
- Idempotentne moduły Ansible (`apt`, `service` itd.)
- Można uruchomić ponownie bez ryzyka

### ✅ 7. Rozdzielenie środowisk
- Oddzielne inwentarze = niezależne wdrożenia
- Ułatwia zarządzanie wieloma środowiskami (dev/staging/prod)

---

## 💡 Dlaczego ta architektura?

### Skalowalność
```bash
# Dodać 10 serwerów Nginx?
# → Wystarczy dodać wpisy w inventories/nginx.yml
# → Playbook i role pozostają identyczne
```

### Możliwość ponownego użycia
```bash
# Użyć roli Apache w innym projekcie?
# → Skopiuj roles/apache2/ do nowego projektu
# → Dostosuj zmienne
```

### Utrzymywalność
```bash
# Zmodyfikować konfigurację Apache?
# → Jeden plik: roles/apache2/templates/apache2.conf.j2
# → Automatycznie stosuje się do wszystkich serwerów
```

### Testowalność
```bash
# Testuj lokalnie z Docker
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml

# Wdróż na prod z SSH
# → Zmień ansible_connection: ssh w group_vars/
# → Ten sam playbook, te same role
```

---

## 🎓 Ćwiczenia ze zrozumienia

### Ćwiczenie 1: Zmień port Apache
1. Zmień `apache_port: 80` → `apache_port: 8888` w `group_vars/all.yml`
2. Uruchom ponownie playbook
3. Obserwuj uruchomienie handlera
4. Zweryfikuj nową konfigurację w kontenerze

### Ćwiczenie 2: Dodaj zmienną
1. Dodaj `company: "MojaFirma"` w `group_vars/all.yml`
2. Zmodyfikuj `roles/apache2/templates/index.html.j2` aby wyświetlić zmienną
3. Uruchom ponownie playbook
4. Zweryfikuj stronę www

### Ćwiczenie 3: Utwórz nową rolę
1. Utwórz `roles/mysql/` z tą samą strukturą
2. Utwórz inwentarz `inventories/mysql.yml`
3. Utwórz playbook `playbooks/play-mysql.yml`
4. Przetestuj

---

## 📚 Idź dalej

### Koncepcje nieomówione tutaj
- **Ansible Vault**: Szyfrowanie sekretów
- **Tags**: Selektywne wykonywanie tasków
- **Blocks i error handling**: Zaawansowane zarządzanie błędami
- **Delegation**: Wykonywanie tasków na innym hoście
- **Lookups i filters**: Zaawansowana manipulacja danymi

### Zasoby
- [Oficjalna dokumentacja Ansible](https://docs.ansible.com)
- [Ansible Galaxy](https://galaxy.ansible.com): Role społeczności
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

---

✅ **Rozumiesz teraz każdy element tego rozwiązania i dlaczego jest tak zorganizowany!**
