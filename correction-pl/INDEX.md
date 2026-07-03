# 📚 Indeks rozwiązania - Ćwiczenie grupowe Ansible

## 🎯 Przegląd

To kompletne rozwiązanie ilustruje profesjonalną infrastrukturę Ansible z 4 serwerami (2 Apache2 + 2 Nginx), zarządzanymi przez dedykowane playbooki, role, inwentarze i szablony.

---

## 📖 Dostępna dokumentacja

### 🚀 Przewodniki startowe

| Plik | Opis | Czas czytania |
|---------|-------------|------------------|
| **QUICKSTART.md** | Ultra-szybki start (4 polecenia) | 2 min |
| **README.md** | Pełna dokumentacja projektu | 10 min |
| **COMMANDS.md** | Referencja wszystkich poleceń | 15 min |
| **EXPLICATIONS.md** | Szczegółowe koncepcje i architektura | 30 min |
| **INDEX.md** | Ten plik (przegląd) | 5 min |

---

## 🗂️ Struktura plików

### Pliki konfiguracyjne
```
correction-pl/
├── ansible.cfg                 # Konfiguracja Ansible (ścieżki ról)
├── group_vars/all.yml          # Zmienne globalne (ansible_connection: docker)
├── .gitignore                  # Pliki do ignorowania
└── docker-compose.yml          # Infrastruktura Docker (4 kontenery)
```

### Inwentarze
```
inventories/
├── apache2.yml                 # 2 serwery Apache (apache1, apache2)
└── nginx.yml                   # 2 serwery Nginx (nginx1, nginx2)
```

### Playbooki
```
playbooks/
├── play-apache2.yml            # Wdrożenie Apache2
└── play-nginx.yml              # Wdrożenie Nginx
```

### Rola Apache2
```
roles/apache2/
├── tasks/main.yml              # Instalacja i konfiguracja
├── handlers/main.yml           # Restart/reload
├── vars/main.yml               # Zmienne roli
└── templates/
    ├── apache2.conf.j2         # Konfiguracja Apache
    └── index.html.j2           # Spersonalizowana strona główna
```

### Rola Nginx
```
roles/nginx/
├── tasks/main.yml              # Instalacja i konfiguracja
├── handlers/main.yml           # Restart/reload
├── vars/main.yml               # Zmienne roli
└── templates/
    ├── nginx.conf.j2           # Konfiguracja Nginx
    └── index.html.j2           # Spersonalizowana strona główna
```

### Skrypty i narzędzia
```
test.sh                         # Automatyczny skrypt testowy
```

---

## 🎓 Od czego zacząć?

### Poziom początkujący
1. **Przeczytaj**: `QUICKSTART.md` aby szybko zacząć
2. **Uruchom**: `./test.sh` aby zobaczyć rozwiązanie w akcji
3. **Eksploruj**: Otwórz http://localhost:8080 i http://localhost:8081
4. **Przeczytaj**: `README.md` aby zrozumieć strukturę

### Poziom średniozaawansowany
1. **Przeczytaj**: `EXPLICATIONS.md` aby zrozumieć koncepcje
2. **Ćwicz**: Modyfikuj szablony i uruchamiaj ponownie
3. **Eksperymentuj**: Dodaj 3. serwer
4. **Sprawdź**: `COMMANDS.md` dla zaawansowanych poleceń

### Poziom zaawansowany
1. **Analizuj**: Architekturę i wybory projektowe
2. **Optymalizuj**: Wydajność i bezpieczeństwo
3. **Rozszerzaj**: Dodaj nowe role (MySQL, Redis itd.)
4. **Integruj**: CI/CD, monitoring, logowanie

---

## 🚀 Quick Start (przypomnienie)

```bash
cd correction-pl
docker-compose up -d
sleep 5
./test.sh
```

**Wynik**: Kompletna działająca infrastruktura w 1 minutę!

---

## 🔍 Ważne pliki

### Konfiguracja globalna
- **ansible.cfg**: Konfiguracja Ansible projektu
  - Ścieżka ról: `./roles`
  - Opcje wyświetlania i połączenia
- **group_vars/all.yml**: Zmienne wspólne dla wszystkich serwerów
  - `ansible_connection: docker`
  - Domyślne porty (apache: 80, nginx: 8080)
  - Email administratora

### Inwentarze
- **inventories/apache2.yml**: Definiuje apache1 i apache2
- **inventories/nginx.yml**: Definiuje nginx1 i nginx2

### Playbooki
- **playbooks/play-apache2.yml**: Stosuje rolę apache2 na apache_servers
- **playbooks/play-nginx.yml**: Stosuje rolę nginx na nginx_servers

### Role
- **roles/apache2/**: Wszystko potrzebne do instalacji i konfiguracji Apache
- **roles/nginx/**: Wszystko potrzebne do instalacji i konfiguracji Nginx

---

## 📊 Omówione koncepcje Ansible

### ✅ Poziom 1: Podstawy
- [x] Inwentarze (hosty i grupy)
- [x] Playbooki (orkiestracja)
- [x] Tasks (akcje)
- [x] Moduły (apt, service, file, template)

### ✅ Poziom 2: Średniozaawansowany
- [x] Role (organizacja wielokrotnego użycia)
- [x] Zmienne (group_vars, vars)
- [x] Szablony (Jinja2)
- [x] Handlery (zarządzanie restartami)

### ✅ Poziom 3: Zaawansowany
- [x] Idempotencja (ponowne uruchomienia bez efektów ubocznych)
- [x] Rozdzielenie odpowiedzialności (Clean Architecture)
- [x] Infrastructure as Code
- [x] Docker jako cel Ansible

---

## 🧪 Dostępne testy

### Kompletny test automatyczny
```bash
./test.sh
```
Weryfikuje:
- ✓ Kontenery działają
- ✓ Połączenie Ansible
- ✓ Wykonanie playbooków
- ✓ Aktywne usługi
- ✓ Dostępne strony www
- ✓ Idempotencja

### Testy ręczne
```bash
# Test połączenia
ansible -i inventories/apache2.yml all -m ping

# Sprawdź usługę
docker exec apache-server-1 service apache2 status

# Przetestuj stronę www
curl http://localhost:8080
```

---

## 🌐 Dostęp do aplikacji

### Z przeglądarki
- **Nginx Server 1**: http://localhost:8080
- **Nginx Server 2**: http://localhost:8081

### Z kontenerów
```bash
# Apache
docker exec apache-server-1 curl http://localhost
docker exec apache-server-2 curl http://localhost

# Nginx
docker exec nginx-server-1 curl http://localhost:8080
docker exec nginx-server-2 curl http://localhost:8080
```

---

## 💡 FAQ

### P: Dlaczego 2 oddzielne inwentarze?
**O:** Pozwala wdrażać Apache i Nginx niezależnie. W produkcji możesz mieć oddzielne środowiska (dev, staging, prod).

### P: Dlaczego role, a nie tylko tasks?
**O:** Role umożliwiają ponowne użycie, organizację i przenośność kodu.

### P: Dlaczego Docker, a nie SSH?
**O:** Do szkolenia Docker jest szybszy i lżejszy. W produkcji wystarczy zmienić `ansible_connection: ssh`.

### P: Jak dostosować do produkcji?
**O:** 
1. Zamień `ansible_connection: docker` na `ansible_connection: ssh`
2. Wstaw prawdziwe IP w inwentarzach
3. Skonfiguruj klucze SSH
4. Dodaj Ansible Vault dla sekretów

### P: Czy mogę dodać więcej serwerów?
**O:** Tak! Dodaj je w:
1. `docker-compose.yml` (kontener)
2. `inventories/*.yml` (inwentarz)
3. Uruchom ponownie playbook

---

## 🎯 Proponowane ćwiczenia

### Ćwiczenie 1: Zmień zmienną
1. Zmień `apache_port` w `group_vars/all.yml`
2. Uruchom ponownie playbook Apache
3. Sprawdź, czy handler został uruchomiony

### Ćwiczenie 2: Personalizuj szablony
1. Zmodyfikuj `roles/apache2/templates/index.html.j2`
2. Dodaj własny komunikat lub styl CSS
3. Wdróż i zweryfikuj

### Ćwiczenie 3: Dodaj serwer
1. Dodaj `apache3` w `inventories/apache2.yml`
2. Dodaj usługę w `docker-compose.yml`
3. Uruchom `docker-compose up -d`
4. Wdróż z `--limit apache3`

### Ćwiczenie 4: Utwórz nową rolę
1. Utwórz `roles/mysql/` z tą samą strukturą
2. Zaimplementuj instalację MySQL
3. Utwórz playbook i inwentarz
4. Przetestuj

### Ćwiczenie 5: Tryb check i diff
1. Zmodyfikuj zmienną
2. Uruchom z `--check --diff`
3. Obserwuj planowane zmiany bez ich stosowania

---

## 🔧 Niezbędne polecenia (przypomnienie)

```bash
# Infrastruktura
docker-compose up -d                    # Uruchom
docker-compose down                     # Zatrzymaj

# Ansible
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml

# Testy
./test.sh                               # Kompletny test
ansible -i inventories/apache2.yml all -m ping    # Test połączenia

# Debug
docker exec -it apache-server-1 bash    # Wejdź do kontenera
docker logs apache-server-1             # Zobacz logi
```

---

## 📚 Zasoby zewnętrzne

### Oficjalna dokumentacja
- [Ansible Docs](https://docs.ansible.com)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Ansible Galaxy](https://galaxy.ansible.com)

### Użyte moduły
- [apt module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html)
- [service module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/service_module.html)
- [template module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html)
- [file module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html)

---

## ✅ Lista kontrolna zrozumienia

Po przejrzeniu tego rozwiązania powinieneś umieć:

- [ ] Wyjaśnić różnicę między playbookiem a rolą
- [ ] Utworzyć inwentarz z wieloma grupami
- [ ] Napisać playbook używający roli
- [ ] Utworzyć kompletną rolę (tasks, handlers, vars, templates)
- [ ] Używać zmiennych i facts w szablonach
- [ ] Zrozumieć działanie handlerów
- [ ] Przetestować idempotencję playbooka
- [ ] Debugować problem wdrożenia
- [ ] Dostosować tę strukturę do nowego projektu

---

## 🎉 Podsumowanie

To rozwiązanie reprezentuje **profesjonalną architekturę Ansible**, którą możesz użyć jako bazę dla własnych projektów.

**Mocne strony**:
✅ Przejrzysta i skalowalna organizacja
✅ Maksymalna możliwość ponownego użycia
✅ Zastosowane dobre praktyki
✅ Kompletna dokumentacja
✅ Zautomatyzowane testy
✅ Gotowe do produkcji (z adaptacjami)

**Następne kroki**:
1. Zrozum każdy plik
2. Modyfikuj i eksperymentuj
3. Twórz własne role
4. Wdrażaj na prawdziwych serwerach

---

📧 **Pytania lub sugestie?** Nie wahaj się pytać podczas szkolenia!

🚀 **Powodzenia we wdrożeniach z Ansible 2026!**
