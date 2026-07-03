# Solution - Ansible Group Exercise

## 📋 Description

This solution sets up a complete Ansible infrastructure with:
- **2 Apache2 servers** (apache1, apache2)
- **2 Nginx servers** (nginx1, nginx2)
- Dedicated playbooks for each server type
- Complete roles with tasks, handlers, templates, and variables
- Docker configuration for testing

## 🏗️ Project structure

```
correction-english/
├── ansible.cfg                 # Ansible configuration (role paths)
├── group_vars/
│   └── all.yml                 # Global variables (ansible_connection: docker)
├── inventories/
│   ├── apache2.yml             # Apache2 server inventory
│   └── nginx.yml               # Nginx server inventory
├── playbooks/
│   ├── play-apache2.yml        # Apache2 playbook
│   └── play-nginx.yml          # Nginx playbook
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
├── docker-compose.yml          # Test infrastructure
└── README.md                   # This file
```

## 🚀 Installation and testing

### 1. Start the Docker infrastructure

```bash
# From the correction-english/ folder
docker-compose up -d

# Verify that all 4 containers are running
docker ps
```

### 2. Run the Apache2 playbooks

```bash
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml
```

### 3. Run the Nginx playbooks

```bash
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml
```

### 4. Verify deployments

#### Test Apache2
```bash
# Enter an Apache container
docker exec -it apache-server-1 bash

# Check the service
service apache2 status

# Test the web page
curl http://localhost

# Exit the container
exit
```

#### Test Nginx
```bash
# Enter a Nginx container
docker exec -it nginx-server-1 bash

# Check the service
service nginx status

# Test the web page
curl http://localhost:8080

# Exit the container
exit
```

#### Access from your browser
- Nginx 1: http://localhost:8080
- Nginx 2: http://localhost:8081

## 🎯 Key points of the solution

### 1. Ansible configuration (ansible.cfg)
```ini
[defaults]
roles_path = ./roles
host_key_checking = False
stdout_callback = yaml
```
Defines Ansible paths and options for the project.

### 2. Docker configuration (group_vars/all.yml)
```yaml
ansible_connection: docker
```
This configuration allows Ansible to manage containers as servers.

### 3. Separate inventories
- **apache2.yml**: Defines the `apache_servers` group with apache1 and apache2
- **nginx.yml**: Defines the `nginx_servers` group with nginx1 and nginx2

### 4. Dedicated playbooks
- **play-apache2.yml**: Targets `apache_servers` and applies the `apache2` role
- **play-nginx.yml**: Targets `nginx_servers` and applies the `nginx` role

### 5. Complete roles
Each role contains:
- **tasks/main.yml**: Service installation and configuration
- **handlers/main.yml**: Restart/reload management
- **templates/**: Dynamic configurations with Jinja2
- **vars/main.yml**: Role-specific variables

### 6. Jinja2 templates
Templates use variables to:
- Customize configurations (ports, paths, etc.)
- Display dynamic information (hostname, IP, etc.)
- Create customized HTML pages per server

### 7. Handlers
Handlers are triggered only when a change is detected (idempotence).

## 🔧 Useful commands

### Test the inventory
```bash
# List Apache hosts
ansible -i inventories/apache2.yml all --list-hosts

# List Nginx hosts
ansible -i inventories/nginx.yml all --list-hosts

# Test connectivity
ansible -i inventories/apache2.yml all -m ping
```

### Check mode (dry-run)
```bash
# Test without applying changes
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml --check
```

### Verbose mode
```bash
# Show more details
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml -v
```

## 🧹 Cleanup

```bash
# Stop and remove all containers
docker-compose down

# Also remove volumes
docker-compose down -v
```

## 📚 Ansible concepts used

1. **Inventories**: Organizing servers into groups
2. **Playbooks**: Deployment orchestration
3. **Roles**: Code reuse and organization
4. **Variables**: Configuration customization
5. **Templates**: Dynamic file generation
6. **Handlers**: Restart management
7. **Modules**: apt, service, file, template
8. **Idempotence**: Repeated runs without side effects

## 💡 Important notes

- Containers must be started **before** running the playbooks
- Python3 is automatically installed in containers at startup
- `ansible_connection: docker` is defined in `group_vars/all.yml`
- Nginx ports are exposed for browser testing
- Apache listens on port 80 (internal to containers)
- Nginx listens on port 8080 (mapped to the host)

## 🎓 Additional exercises

1. Add a variable for the welcome message in the HTML pages
2. Create a new role to install MySQL
3. Add tasks to manage logs
4. Implement SSL certificate management
5. Create a playbook that deploys both roles simultaneously

---

✅ **Solution validated and tested with Ansible 2026 and Docker**
