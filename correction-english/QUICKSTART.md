# 🚀 Quick start - 2 minutes

## Prerequisites
- Docker installed and running
- Ansible installed (`pip install ansible`)

## In 4 commands

```bash
# 1. Go to the correction-english folder
cd correction-english

# 2. Start the infrastructure (4 containers)
docker-compose up -d

# 3. Wait 5 seconds for containers to be ready
sleep 5

# 4. Run the automated test script
./test.sh
```

## ✅ Expected result

You should see:
- ✓ Infrastructure started (4 containers)
- ✓ Ansible connection OK
- ✓ Apache2 playbook executed
- ✓ Nginx playbook executed
- ✓ Services active
- ✓ Web pages accessible

## 🌐 Test in the browser

Open these URLs:
- http://localhost:8080 → Nginx Server 1
- http://localhost:8081 → Nginx Server 2

## 🎯 Manual execution

If you prefer to run the playbooks manually:

```bash
# Start the infrastructure
docker-compose up -d

# Deploy Apache2 (on apache1 and apache2)
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml

# Deploy Nginx (on nginx1 and nginx2)
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml

# Verify Apache is working
docker exec apache-server-1 curl http://localhost

# Verify Nginx is working
docker exec nginx-server-1 curl http://localhost:8080
```

## 🔍 Service verification

```bash
# Apache
docker exec apache-server-1 service apache2 status
docker exec apache-server-2 service apache2 status

# Nginx
docker exec nginx-server-1 service nginx status
docker exec nginx-server-2 service nginx status
```

## 🧹 Cleanup

```bash
# Stop and remove everything
docker-compose down
```

## 📚 Go further

- Read `README.md` for complete documentation
- Check `COMMANDS.md` for all available commands
- Modify templates in `roles/*/templates/`
- Add variables in `group_vars/all.yml`

## ⚠️ Common issues

### "Cannot connect to the Docker daemon"
```bash
# Start Docker
# macOS: Launch Docker Desktop
# Linux: sudo systemctl start docker
```

### "Connection refused" during Ansible ping
```bash
# Wait for containers to be fully started
docker ps  # Verify all 4 containers are "Up"
sleep 10   # Wait a bit longer
```

### "Module not found" for Ansible
```bash
# Install Ansible
pip install ansible
# or
pip3 install ansible
```

---

🎉 **That's it! You have a complete Ansible infrastructure running!**
