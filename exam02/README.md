This is my second RHCE exam attempt. This exam was created by chatgpt
The questions are as follows:

# EX294 Full Practice Exam #1
## Red Hat Certified Advanced System Administrator in Ansible — Practice Simulation

### Candidate Instructions

You are the administrator responsible for automating a small Linux environment.

Unless specifically stated otherwise, **all configuration changes must be made using Ansible** from the control node.

Your work must satisfy the requested end state. Merely running a command successfully does not mean the task is complete.

All playbooks must:

- Be valid YAML.
- Complete without unhandled errors.
- Be idempotent where appropriate.
- Use fully qualified collection names when practical.
- Make configurations persistent across reboot where persistence is expected.
- Operate only on the hosts specified in the task.
- Not unnecessarily modify hosts outside the requested scope.

You may use locally installed documentation including:

```bash
ansible-doc
ansible-navigator doc
ansible-navigator collections
ansible-navigator inventory
man
info
/usr/share/doc
```

You may inspect existing configuration files and examples on the systems.

Do not use Internet documentation during this simulation.

---

# Environment

The following systems are available:

```text
control.example.com
node1.example.com
node2.example.com
node3.example.com
node4.example.com
```

The managed systems are divided logically as follows:

```text
node1.example.com
node2.example.com
    Web servers

node3.example.com
    Storage/application server

node4.example.com
    Development/backup server
```

Assume:

```text
Ansible user: automation
Privilege escalation user: root
```

The managed nodes contain a second unused disk:

```text
/dev/sdb
```

where explicitly referenced by a task.

Create your exam work beneath:

```text
/home/automation/exam/
```

Do not modify `/etc/ansible/ansible.cfg` unless specifically instructed.

---

# Task 1 — Git Repository

Create your working environment.

A Git repository named:

```text
automation-exam
```

has been made available to you by your instructor or lab environment.

Clone the repository into:

```text
/home/automation/exam/
```

All files created during the examination must be stored inside this repository unless a task explicitly states otherwise.

Before finishing the examination:

1. Add all required files to Git.
2. Commit your final configuration.
3. Ensure `git status` shows no required untracked work.

Commit message:

```text
Completed automation configuration
```

---

# Task 2 — Static Inventory

Create:

```text
inventory
```

Configure the following inventory groups:

```text
web
storage
development
production
```

Membership must be:

```text
web:
    node1.example.com
    node2.example.com

storage:
    node3.example.com

development:
    node4.example.com

production:
    node1.example.com
    node2.example.com
    node3.example.com
```

Create a parent group:

```text
managed
```

containing:

```text
web
storage
development
```

Define the following host variable for `node2.example.com`:

```text
http_port=8080
```

Do not define `http_port` for the other hosts in the inventory.

Verify that Ansible interprets the inventory correctly.

---

# Task 3 — Ansible Configuration

Create:

```text
ansible.cfg
```

Configure Ansible so that:

- The inventory created in Task 2 is used automatically.
- Remote connections use the `automation` account.
- Privilege escalation is enabled by default.
- Privilege escalation uses `sudo`.
- The target privilege escalation user is `root`.
- Host key checking does not prevent connections to newly created lab hosts.
- Ansible can locate roles stored under:

```text
./roles
```

Running:

```bash
ansible all -m ping
```

from `/home/automation/exam/` must use this configuration without specifying an inventory file.

---

# Task 4 — Ansible Navigator Configuration

Create or modify:

```text
ansible-navigator.yml
```

Configure `ansible-navigator` so that:

- It uses your examination inventory.
- Playbook output is displayed directly in the terminal rather than requiring interaction with the text user interface.
- The Ansible execution environment is enabled if an appropriate execution environment is available in your lab.

Use `ansible-navigator` to inspect your inventory.

You must be able to identify the membership of the `web` group using `ansible-navigator`.

---

# Task 5 — Managed Node Access

Create a playbook:

```text
access.yml
```

Configure all members of `managed` so that:

- The group `automation` exists.
- A user named `deploy` exists.
- `deploy` uses `/bin/bash`.
- `deploy` is a member of the `automation` group.
- The user can perform administrative operations through `sudo`.
- Passwordless privilege escalation is configured for `deploy`.
- The configuration is stored in an appropriate file beneath `/etc/sudoers.d/`.
- The sudo configuration has appropriate ownership and permissions.
- An SSH public key available to you as:

```text
files/deploy_key.pub
```

is installed as an authorized key for `deploy`.

Do not replace other authorized keys that may already exist for this account.

---

# Task 6 — Common System Configuration

Create:

```text
system_config.yml
```

Configure all hosts in `managed`.

The following packages must be installed:

```text
vim-enhanced
bash-completion
tar
chrony
```

Ensure:

```text
chronyd
```

is enabled and running.

Create:

```text
/etc/motd
```

with exactly the following general format:

```text
Managed by Ansible
System: <hostname>
```

The actual inventory hostname of each managed node must be displayed on its own system.

The file must be owned by:

```text
root:root
```

and have permissions:

```text
0644
```

---

# Task 7 — Facts and Conditional Execution

Create:

```text
facts.yml
```

The playbook must run against all managed nodes.

Create:

```text
/etc/system_role
```

according to inventory membership.

On hosts in `web`, the file must contain:

```text
ROLE=web
```

On hosts in `storage`, it must contain:

```text
ROLE=storage
```

On hosts in `development`, it must contain:

```text
ROLE=development
```

Additionally, create:

```text
/etc/os_information
```

containing:

```text
HOSTNAME=<actual system hostname>
DISTRIBUTION=<distribution name>
MAJOR_VERSION=<major operating system version>
MEMORY_MB=<total memory reported by Ansible>
```

Retrieve the values from Ansible facts rather than hard-coding them.

---

# Task 8 — Command Result and Registered Variables

Create:

```text
kernel_check.yml
```

Run the following command on all managed systems:

```bash
uname -r
```

Retrieve the command result into an Ansible variable.

Using the registered result, create:

```text
/root/kernel-version.txt
```

containing:

```text
Running kernel: <result of uname -r>
```

Do not run `uname -r` manually and hard-code its result.

The playbook must not report the command task as changed merely because the command was executed.

---

# Task 9 — Users, Groups, and Loops

Create:

```text
users.yml
```

On all production systems create:

```text
Group:
ops
GID:
4000
```

Create the following users:

```text
ops_alice
ops_bob
ops_charlie
```

Each user must:

- Have a local account.
- Use `/bin/bash`.
- Have `ops` as a supplementary group.
- Have a home directory.
- Have password authentication disabled/locked.
- Not have an account expiration date.

Create the following file in each user's home directory:

```text
README
```

Contents:

```text
This account is managed by Ansible.
```

The file must be owned by the corresponding user.

Use one or more loops rather than writing three independent copies of the same user-management task.

---

# Task 10 — Web Service

Create:

```text
webserver.yml
```

Configure only members of the `web` group.

Install the software required to provide an Apache HTTP web service.

Ensure:

- The web server service starts automatically at boot.
- The web server is currently running.
- `firewalld` is installed if necessary.
- `firewalld` is enabled and running.
- HTTP traffic is permitted through the firewall persistently.

The default value of:

```text
http_port
```

must be:

```text
80
```

Recall that `node2.example.com` already has a host-specific value defined in the inventory.

Do not duplicate that host-specific value inside the playbook.

---

# Task 11 — Templates

Extend the web server configuration using a Jinja2 template.

Create:

```text
templates/index.html.j2
```

Deploy the resulting file as:

```text
/var/www/html/index.html
```

The resulting page must resemble:

```html
<h1>Automation Training</h1>
<p>Server: node1.example.com</p>
<p>Port: 80</p>
<p>Operating System: RedHat</p>
```

Values must be generated dynamically.

The server line must use the inventory hostname.

The port must use `http_port`.

The operating system must come from an Ansible fact.

The template deployment task must notify a handler that restarts the web service if the deployed file changes.

The handler must not restart the service when no relevant change occurs.

---

# Task 12 — SELinux and Alternate HTTP Port

`node2.example.com` has been assigned:

```text
http_port=8080
```

Modify your web-server automation so that node2 can provide HTTP service on TCP port `8080` while node1 continues to use port `80`.

The configuration must satisfy all of the following:

- Apache listens on the appropriate port for each host.
- The firewall permits the required TCP port.
- SELinux remains enforcing.
- The alternate port has the appropriate SELinux configuration.
- The service starts successfully after reboot.

Do not disable SELinux.

Do not place SELinux into permissive mode.

Your solution must remain idempotent.

---

# Task 13 — Storage

Create:

```text
storage.yml
```

Configure **node3 only**.

The unused disk:

```text
/dev/sdb
```

must be used to create the following storage configuration:

```text
Volume group:
data_vg

Logical volume:
data_lv
```

The logical volume must consume all currently available free space in `data_vg`.

Create an XFS filesystem on the logical volume.

Mount it persistently at:

```text
/data
```

Requirements:

- `/data` must exist.
- The filesystem must be mounted after the playbook completes.
- The filesystem must mount automatically after reboot.
- Re-running the playbook must not destroy or unnecessarily recreate an existing filesystem.

---

# Task 14 — File Management and Archiving

Create:

```text
content.yml
```

Configure `node3.example.com`.

Create the following directories:

```text
/data/app
/data/archive
```

Both directories must:

```text
Owner: root
Group: root
Mode: 0755
```

Create these files beneath `/data/app`:

```text
app.conf
database.conf
logging.conf
```

Each file must contain:

```text
Managed by Ansible
```

Create an archive:

```text
/data/archive/application-config.tar.gz
```

containing the contents of:

```text
/data/app/
```

The archive must be gzip compressed.

---

# Task 15 — Scheduled Task

Create:

```text
schedule.yml
```

On `node4.example.com`, schedule a command that runs every day at:

```text
02:30
```

The command must append:

```text
backup check
```

to:

```text
/var/log/backup-check.log
```

The scheduled job must run as:

```text
root
```

The job must have a recognizable Ansible-managed name so that subsequent playbook runs modify the existing job instead of creating duplicates.

---

# Task 16 — Error Handling

Create:

```text
error_handling.yml
```

Run it against all members of `managed`.

The playbook must attempt to determine whether this file exists:

```text
/etc/application-release
```

The absence of this file must **not** stop execution of the playbook.

After the check, every managed node must receive:

```text
/tmp/configuration-complete
```

containing:

```text
Configuration processing completed
```

Implement this using appropriate Ansible error-handling or status-checking functionality.

Do not manually create `/etc/application-release` simply to avoid the failure.

---

# Task 17 — Role Creation

Refactor your web server configuration into a role named:

```text
webserver_role
```

Use the standard role structure beneath:

```text
roles/webserver_role/
```

The role must appropriately separate:

```text
tasks
handlers
templates
defaults
```

Define the following role default:

```yaml
http_port: 80
```

The template from the earlier web-server task must be managed by the role.

The HTTP restart handler must be stored in the role.

Create:

```text
site.yml
```

Apply:

```text
webserver_role
```

only to hosts in the `web` inventory group.

`site.yml` must produce the same functional web-server configuration required by Tasks 10–12.

Do not leave duplicate copies of the full web configuration directly inside `site.yml`.

---

# Task 18 — Content Collections

Using locally available Ansible content:

1. Determine which installed collection provides modules for managing SELinux configuration.
2. Use `ansible-navigator` to inspect the documentation for at least one module from that collection.
3. Ensure your automation uses the correct fully qualified collection name for the SELinux task used in your web role.

If the required collection is provided locally but not installed, install the provided collection before running the playbook.

Your finished automation must not depend on downloading content from the Internet.

---

# Task 19 — Repository Configuration

Create:

```text
repository.yml
```

Configure `node4.example.com`.

Create the following DNF repository:

```text
Name:
training-base

Description:
Training Base Repository

Base URL:
http://repo.example.com/rhel9/BaseOS

Enabled:
yes

GPG checking:
no
```

Also create:

```text
training-appstream
```

with:

```text
Base URL:
http://repo.example.com/rhel9/AppStream
Enabled:
yes
GPG checking:
no
```

The repositories must be persistent.

Do not use shell commands to manually echo repository configuration into files if an appropriate Ansible module is available.

---

# Task 20 — Ansible Vault

Create:

```text
vault_secrets.yml
```

Encrypt it using Ansible Vault.

The encrypted file must define:

```yaml
db_admin_password: S3cr3t!
```

Use the following vault password for this practice exam:

```text
RedHat123!
```

Create:

```text
vault_password
```

containing the vault password.

Set permissions on this file so that only its owner can read and modify it.

Create:

```text
secret_test.yml
```

The playbook must load `vault_secrets.yml` and use the variable in a task.

For this examination simulation, create:

```text
/root/database-secret
```

on `node3.example.com`.

Its contents must be:

```text
S3cr3t!
```

Permissions:

```text
0600
```

Do not place the plaintext value `S3cr3t!` directly inside `secret_test.yml`.

Run the playbook while supplying the vault password file.

---

# Task 21 — Service Recovery with Blocks

Create:

```text
service_recovery.yml
```

Run against the `web` group.

Use Ansible's structured error-handling functionality to implement the following behavior:

Attempt to:

1. Verify the web-server configuration.
2. Restart the web service.

If the attempted operation fails:

- Create:

```text
/root/web-recovery-required
```

containing:

```text
Web service recovery required
```

Regardless of success or failure:

- Create:

```text
/root/web-check-completed
```

containing:

```text
Web service check completed
```

Use Ansible constructs intended for grouped task error handling rather than implementing the entire workflow through shell conditionals.

---

# Task 22 — RHCSA Automation: Permissions and Links

Create:

```text
filesystem_content.yml
```

Configure all production hosts.

Create:

```text
/opt/company
```

with:

```text
Owner: root
Group: ops
Mode: 2775
```

Create:

```text
/opt/company/README
```

containing:

```text
Production shared directory
```

Create a symbolic link:

```text
/usr/local/share/company
```

pointing to:

```text
/opt/company
```

Ensure your automation produces the specified configuration if the files or directories do not initially exist.

---

# Task 23 — Shell Script Analysis

A script named:

```text
files/system_check.sh
```

contains:

```bash
#!/bin/bash

for service in sshd chronyd firewalld
do
    systemctl is-active $service >/dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "$service: running"
    else
        echo "$service: stopped"
    fi
done
```

Without modifying the script, understand what it does.

Create:

```text
script_deployment.yml
```

which:

- Deploys the script to all managed nodes as:

```text
/usr/local/bin/system_check
```

- Sets appropriate ownership and executable permissions.
- Runs the script.
- Captures its output in a registered variable.
- Displays the resulting output during playbook execution.

The deployment must not report a change when the script on the target already matches the source.

---

# Task 24 — Final Validation Playbook

Create:

```text
verify.yml
```

The playbook must perform **non-destructive checks** for important portions of your environment.

At minimum, validate:

```text
httpd is running on web hosts
chronyd is running on all managed hosts
/data is mounted on node3
deploy exists on managed hosts
/etc/motd exists
```

The validation playbook must not alter the system merely to make a failed test pass.

Use Ansible modules and registered information where appropriate.

A failed critical validation should make it apparent that the environment does not meet the specification.

---

# Final Examination Requirements

Before declaring the examination complete:

Run your main playbooks again.

A correctly configured environment should produce few or no unnecessary changes on the second execution.

Verify the inventory using both Ansible and `ansible-navigator`.

Run appropriate syntax checks on your playbooks.

Verify encrypted data is actually encrypted:

```bash
cat vault_secrets.yml
```

must not expose:

```text
S3cr3t!
```

Run your validation playbook.

Check your Git repository.

Commit all required work.

If practical in your lab, reboot the managed nodes and verify that persistent requirements remain configured.

---

# Self-Grading Scheme

This is a **practice grading system**, not Red Hat's official scoring system.

Total:

```text
300 points
```

Suggested weighting:

| Area | Points |
|---|---:|
| Ansible configuration, inventory, navigator | 30 |
| Managed-node access | 15 |
| Packages/services/common configuration | 20 |
| Facts, variables, loops, conditionals | 30 |
| Web service/firewall/SELinux | 40 |
| Storage/filesystems | 30 |
| File/archive/scheduling tasks | 20 |
| Error handling | 20 |
| Roles | 30 |
| Collections/repositories | 20 |
| Vault | 20 |
| Git/script/validation | 25 |
| **Total** | **300** |

For practice purposes, consider:

```text
270–300    Excellent — exam-ready performance
240–269    Strong — identify weak areas and repeat
210–239    Borderline — more timed practice recommended
Below 210  Significant objectives need reinforcement
```

Do **not** award partial credit simply because a playbook looks reasonable.

Judge the **actual resulting host configuration**.

---

# Strict Grading Rules

Consider a task incorrect when:

- The required end state is not achieved.
- The playbook fails.
- The playbook modifies the wrong hosts.
- The configuration disappears after reboot when persistence was required.
- A hard-coded value defeats an explicitly required variable or fact.
- A task uses plaintext data where Vault was required.
- A role requirement was satisfied only by leaving everything in the playbook.
- A handler is defined but not actually triggered correctly.
- Firewall configuration exists but the service is unreachable.
- SELinux was disabled to make an application work.
- A storage configuration destroys data unnecessarily when rerun.
- An inventory group has incorrect membership.

For idempotency, run important playbooks twice.

The second execution should generally report:

```text
changed=0
```

unless the task inherently produces a change every time or your implementation has a defensible reason for doing so.

---

# Candidate Strategy

During the simulation, prioritize **working end states over elegant YAML**.

When you cannot remember module syntax:

```bash
ansible-doc <module>
```

or:

```bash
ansible-navigator doc <FQCN>
```

When you cannot remember the collection containing a module, inspect installed collections rather than guessing indefinitely.

When uncertain whether the inventory is behaving correctly, inspect it before troubleshooting the playbook.

When a task involves a system resource, verify the underlying system after Ansible runs.

Examples of appropriate validation include commands such as:

```bash
systemctl
findmnt
lsblk
lvs
vgs
firewall-cmd
getenforce
semanage
ss
getent
stat
curl
```

Remember: **the specification is the target, not simply a successful Ansible exit code.**