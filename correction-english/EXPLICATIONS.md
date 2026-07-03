# 📖 Detailed explanations of the solution

## Overview

This solution illustrates a complete and professional Ansible architecture. Here is why each element is organized this way.

---

## 🗂️ Project structure

### 1. `group_vars/all.yml` - Global variables

```yaml
ansible_connection: docker
apache_port: 80
nginx_port: 8080
```

**Why here?**
- ✅ Variables common to **all** servers
- ✅ Single place to modify a global config
- ✅ `ansible_connection: docker` applies to all hosts

**Possible alternative**:
- Variables in each inventory (less DRY)
- Variables in playbooks (less reusable)

---

### 2. `inventories/` - Separate inventories

**Why 2 distinct inventories?**

```
inventories/
├── apache2.yml  → Apache servers only
└── nginx.yml    → Nginx servers only
```

**Advantages**:
- ✅ Independent deployment: `ansible-playbook -i inventories/apache2.yml ...`
- ✅ Logical groups: `apache_servers` vs `nginx_servers`
- ✅ Flexibility: Different variables per group

**Real scenario**:
```bash
# Deploy only web servers in production
ansible-playbook -i inventories/nginx.yml playbooks/play-nginx.yml

# Deploy only API servers
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml
```

**Inventory structure**:
```yaml
all:
  children:
    apache_servers:      # Group name
      hosts:
        apache1:         # Logical name
          ansible_host: apache-server-1  # Docker container name
          server_id: 1   # Host-specific variable
```

---

### 3. `playbooks/` - Dedicated playbooks

**Why one playbook per server type?**

```
playbooks/
├── play-apache2.yml  → Configure Apache
└── play-nginx.yml    → Configure Nginx
```

**Advantages**:
- ✅ Single Responsibility Principle
- ✅ Reusability
- ✅ Simplified maintenance

**Playbook structure**:
```yaml
- name: Configure Apache2 servers
  hosts: apache_servers    # Targets the inventory group
  become: yes              # Run with sudo
  roles:
    - apache2              # Apply the apache2 role
```

**Why `become: yes`?**
- Package installation → Requires root privileges
- Modifying `/etc/` → Requires root privileges
- Starting services → Requires root privileges

---

### 4. `roles/` - Role organization

**Role architecture**:
```
roles/apache2/
├── tasks/          → What to do
├── handlers/       → Reactions to changes
├── templates/      → Dynamic files
└── vars/           → Role variables
```

#### 4.1 `tasks/main.yml` - Actions

```yaml
- name: Install Apache2
  apt:
    name: "{{ apache_package }}"
    state: present

- name: Deploy configuration
  template:
    src: apache2.conf.j2
    dest: "{{ apache_config_path }}"
  notify: restart apache2  # ← Triggers the handler
```

**Key concepts**:
- **Execution order**: Top to bottom
- **Idempotence**: Can be re-run without side effects
- **Modules**: `apt`, `template`, `service`, `file`
- **Notify**: Triggers a handler if changed

#### 4.2 `handlers/main.yml` - Reactions

```yaml
- name: restart apache2
  service:
    name: "{{ apache_service }}"
    state: restarted
```

**Why handlers?**
- ✅ Restarts ONLY if config modified
- ✅ Executed ONCE at the end (even if notified multiple times)
- ✅ Optimized performance

**Example**:
```
1. Modification of apache2.conf → notify "restart apache2"
2. Modification of index.html → (no notify)
3. End of playbook → Handler "restart apache2" executed ONCE
```

#### 4.3 `templates/` - Dynamic files

**Jinja2 template** (`apache2.conf.j2`):
```apache
<VirtualHost *:{{ apache_port }}>
    ServerName {{ apache_server_name }}
    DocumentRoot {{ apache_document_root }}
    # Hostname: {{ ansible_hostname }}
</VirtualHost>
```

**Advantages**:
- ✅ Dynamic configuration per server
- ✅ Uses Ansible variables
- ✅ Access to facts (`ansible_hostname`, etc.)

**Rendered on apache1**:
```apache
<VirtualHost *:80>
    ServerName apache.local
    DocumentRoot /var/www/html
    # Hostname: apache1
</VirtualHost>
```

**Rendered on apache2**:
```apache
<VirtualHost *:80>
    ServerName apache.local
    DocumentRoot /var/www/html
    # Hostname: apache2
</VirtualHost>
```

#### 4.4 `vars/main.yml` - Role variables

```yaml
apache_package: apache2
apache_service: apache2
apache_document_root: /var/www/html
```

**Why here and not in `group_vars/`?**
- ✅ Variables specific to the Apache role
- ✅ Portability: The role can be reused elsewhere
- ✅ Encapsulation: Internal role details stay in the role

**Variable hierarchy** (from least to most priority):
1. `roles/*/vars/main.yml`
2. `group_vars/all.yml`
3. `inventories/*/hosts` (host variables)
4. Command-line variables: `-e "apache_port=8080"`

---

## 🔄 Complete execution flow

When you run:
```bash
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml
```

**Here is what happens**:

### Step 1: Read inventory
```
inventories/apache2.yml
↓
Load hosts: apache1, apache2
Read ansible_host: apache-server-1, apache-server-2
```

### Step 2: Read global variables
```
group_vars/all.yml
↓
ansible_connection: docker
apache_port: 80
nginx_port: 8080
```

### Step 3: Read playbook
```
playbooks/play-apache2.yml
↓
Target: apache_servers
Role to apply: apache2
```

### Step 4: Load role
```
roles/apache2/
↓
Load vars/main.yml (variables)
Load tasks/main.yml (actions)
Load handlers/main.yml (reactions)
Prepare templates/ (dynamic files)
```

### Step 5: Execute tasks on apache1
```
1. Update APT
2. Install Apache2
3. Create /var/www/html
4. Generate apache2.conf from template
   → If modified: note "restart apache2" in queue
5. Generate index.html from template
6. Start Apache2
```

### Step 6: Execute tasks on apache2
```
(Same process as apache1)
```

### Step 7: Execute handlers
```
If "restart apache2" was notified:
  → Restart Apache on affected servers
```

---

## 🎯 Ansible concepts illustrated

### 1. Idempotence

**First execution**:
```
TASK [apache2 : Install Apache2]
changed: [apache1]
changed: [apache2]
```

**Second execution**:
```
TASK [apache2 : Install Apache2]
ok: [apache1]  ← Already installed, nothing to do
ok: [apache2]  ← Already installed, nothing to do
```

### 2. Variables and facts

**Defined variables**:
- `apache_port: 80` (group_vars)
- `server_id: 1` (inventory)

**Automatically collected facts**:
- `ansible_hostname`: "apache1"
- `ansible_distribution`: "Ubuntu"
- `ansible_distribution_version`: "22.04"

**Usage in templates**:
```jinja
<h1>Server {{ ansible_hostname }}</h1>
<p>Port: {{ apache_port }}</p>
<p>ID: {{ server_id }}</p>
```

### 3. Separation of concerns

```
group_vars/     → Global configuration
inventories/    → Server definitions
playbooks/      → Orchestration
roles/          → Business logic
  ├── tasks/    → Actions
  ├── handlers/ → Reactions
  ├── templates/→ Dynamic files
  └── vars/     → Role configuration
```

---

## 🐳 Docker integration

### Configuration in `group_vars/all.yml`

```yaml
ansible_connection: docker
```

**What it does**:
- Instead of SSH → Uses Docker API
- Instead of `ssh user@host` → Uses `docker exec container`

### Equivalence

**Ansible command**:
```bash
ansible -i inventories/apache2.yml apache1 -m command -a "hostname"
```

**Docker equivalent**:
```bash
docker exec apache-server-1 hostname
```

**Why is it transparent?**
- Ansible abstracts the connection
- The rest of the code is identical
- In production, just change `ansible_connection: ssh`

---

## 🔐 Best practices applied

### ✅ 1. Clear organization
```
correction-english/
├── group_vars/      # Global
├── inventories/     # Servers
├── playbooks/       # Orchestration
└── roles/           # Logic
```

### ✅ 2. Descriptive naming
- `play-apache2.yml` (not `playbook1.yml`)
- `apache_servers` (not `group1`)
- `restart apache2` (not `handler1`)

### ✅ 3. Reusable variables
```yaml
apache_package: apache2
```
Allows easy change to `httpd` on RedHat.

### ✅ 4. Templates for configuration
- No static files
- Dynamic configuration
- Adapts per server

### ✅ 5. Handlers for efficiency
- Restarts only when necessary
- Executed once

### ✅ 6. Guaranteed idempotence
- Idempotent Ansible modules (`apt`, `service`, etc.)
- Can be re-run without risk

### ✅ 7. Environment separation
- Distinct inventories = independent deployments
- Facilitates multi-environment management (dev/staging/prod)

---

## 💡 Why this architecture?

### Scalability
```bash
# Add 10 Nginx servers?
# → Just add entries in inventories/nginx.yml
# → Playbook and roles remain identical
```

### Reusability
```bash
# Use the Apache role on another project?
# → Copy roles/apache2/ to the new project
# → Adjust variables
```

### Maintainability
```bash
# Modify Apache config?
# → Single file: roles/apache2/templates/apache2.conf.j2
# → Automatically applies to all servers
```

### Testability
```bash
# Test locally with Docker
ansible-playbook -i inventories/apache2.yml playbooks/play-apache2.yml

# Deploy to prod with SSH
# → Change ansible_connection: ssh in group_vars/
# → Same playbook, same roles
```

---

## 🎓 Comprehension exercises

### Exercise 1: Modify Apache port
1. Change `apache_port: 80` → `apache_port: 8888` in `group_vars/all.yml`
2. Re-run the playbook
3. Observe the handler being triggered
4. Verify the new config in the container

### Exercise 2: Add a variable
1. Add `company: "MyCompany"` in `group_vars/all.yml`
2. Modify `roles/apache2/templates/index.html.j2` to display the variable
3. Re-run the playbook
4. Verify the web page

### Exercise 3: Create a new role
1. Create `roles/mysql/` with the same structure
2. Create an inventory `inventories/mysql.yml`
3. Create a playbook `playbooks/play-mysql.yml`
4. Test

---

## 📚 Go further

### Concepts not covered here
- **Ansible Vault**: Secret encryption
- **Tags**: Selective task execution
- **Blocks and error handling**: Advanced error management
- **Delegation**: Execute tasks on another host
- **Lookups and filters**: Advanced data manipulation

### Resources
- [Official Ansible documentation](https://docs.ansible.com)
- [Ansible Galaxy](https://galaxy.ansible.com): Community roles
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

---

✅ **You now understand each element of this solution and why it is organized this way!**
