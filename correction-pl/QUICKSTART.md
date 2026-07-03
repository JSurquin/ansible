# 🚀 Szybki start - 2 minuty

## Wymagania
- Docker zainstalowany i uruchomiony
- Ansible zainstalowany (`pip install ansible`)

## W 4 poleceniach

```bash
# 1. Przejdź do folderu correction-pl
cd correction-pl

# 2. Uruchom infrastrukturę (4 kontenery)
docker-compose up -d

# 3. Poczekaj 5 sekund, aż kontenery będą gotowe
sleep 5

# 4. Uruchom automatyczny skrypt testowy
./test.sh
```

## ✅ Oczekiwany wynik

Powinieneś zobaczyć:
- ✓ Infrastruktura uruchomiona (4 kontenery)
- ✓ Połączenie Ansible OK
- ✓ Playbook Apache2 wykonany
- ✓ Playbook Nginx wykonany
- ✓ Usługi aktywne
- ✓ Strony www dostępne

## 🌐 Test w przeglądarce

Otwórz te adresy URL:
- http://localhost:8080 → Nginx Server 1
- http://localhost:8081 → Nginx Server 2

## 🎯 Ręczne wykonanie

Jeśli wolisz uruchomić playbooki ręcznie:

```bash
# Uruchom infrastrukturę
docker-compose up -d

# Wdróż Apache2 (na apache1 i apache2)
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml

# Wdróż Nginx (na nginx1 i nginx2)
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml

# Sprawdź, czy Apache działa
docker exec apache-server-1 curl http://localhost

# Sprawdź, czy Nginx działa
docker exec nginx-server-1 curl http://localhost:8080
```

## 🔍 Weryfikacja usług

```bash
# Apache
docker exec apache-server-1 service apache2 status
docker exec apache-server-2 service apache2 status

# Nginx
docker exec nginx-server-1 service nginx status
docker exec nginx-server-2 service nginx status
```

## 🧹 Czyszczenie

```bash
# Zatrzymaj i usuń wszystko
docker-compose down
```

## 📚 Idź dalej

- Przeczytaj `README.md` dla pełnej dokumentacji
- Sprawdź `COMMANDS.md` dla wszystkich dostępnych poleceń
- Modyfikuj szablony w `roles/*/templates/`
- Dodaj zmienne w `group_vars/all.yml`

## ⚠️ Typowe problemy

### "Cannot connect to the Docker daemon"
```bash
# Uruchom Docker
# macOS: Uruchom Docker Desktop
# Linux: sudo systemctl start docker
```

### "Connection refused" podczas ping Ansible
```bash
# Poczekaj, aż kontenery w pełni się uruchomią
docker ps  # Sprawdź, czy wszystkie 4 kontenery mają status "Up"
sleep 10   # Poczekaj trochę dłużej
```

### "Module not found" dla Ansible
```bash
# Zainstaluj Ansible
pip install ansible
# lub
pip3 install ansible
```

---

🎉 **To wszystko! Masz działającą kompletną infrastrukturę Ansible!**
