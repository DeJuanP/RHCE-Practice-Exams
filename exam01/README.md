This is my first practice exam attempt. This exam was created by Grok.
The exam is as follows:

Task 1: Install and Configure Ansible Control Node

Install Ansible (and dependencies) on the control node. Configure ansible.cfg in your working directory with:

Inventory file at /home/automation/inventory
Disable host key checking
Use privilege escalation by default
Set retry files off

Create a static inventory with:

Host node1 in webservers
Host node2 in databases
Host node3 in webservers
Group prod as parent of webservers and databases
Add variables: http_port=80 for webservers, db_package=mariadb for databases.

Task 2: Ad-Hoc Commands

Using ad-hoc commands only:

Ping all hosts.
Install tree package on webservers.
Gather facts from databases group and save to /tmp/facts.json on control node.
Run uptime on all hosts as a specific user.

Task 3: Basic Playbook - MOTD and Users

Create a playbook users_motd.yml that:

Runs on all hosts.
Creates a user automation with password devops (use ansible vault for password if sensitive), sudo privileges (no password), and adds to wheel group.
Sets a custom MOTD: "Welcome to {{ ansible_hostname }} - Managed by Ansible" on all hosts; for databases group, append "Database Server".
Ensures the changes persist.

Section 2: System Administration Automation (Tasks 4-7)
Task 4: Storage Configuration

Create a playbook storage.yml for the databases group:

Use LVM to create a volume group vg_db from an additional disk (e.g., /dev/vdb).
Create logical volume lv_data (size 5G), format with XFS, mount persistently at /var/lib/mysql.
Install and start MariaDB/MySQL, ensure service enables on boot.

Task 5: Web Server Deployment

Create webserver.yml for webservers group:

Install httpd, mod_ssl.
Deploy a custom index.html with "RHCE Practice Web Server - {{ inventory_hostname }}".
Configure firewall to allow http/https.
Ensure service is started/enabled and SELinux contexts are correct.
Use a loop for multiple virtual hosts if time allows.

Task 6: Security and SELinux

Create security.yml:

Set SELinux to enforcing mode persistently on all hosts.
Allow httpd to connect to network (httpd_can_network_connect).
Manage firewalld services via Ansible.
Use ansible-vault to encrypt a file containing sensitive vars (e.g., certificates).

Task 7: Facts, Variables, and Conditionals

Create report.yml:

Gather facts.
Use conditionals: Install httpd only if memory > 1GB; create a custom fact.
Generate a report file on control node with host details (hostname, IP, memory, OS version) using templates or template module + delegate_to.

Section 3: Advanced Topics - Roles, Loops, Error Handling (Tasks 8-10)
Task 8: Create and Use a Role

Create a role common (in roles/common/):

Install common packages (vim, curl, git).
Configure NTP/chrony.
Set timezone to UTC.
Apply the role to all hosts in a playbook. Use Ansible Galaxy/collections if applicable (e.g., ansible.posix).

Task 9: Loops and Handlers

Create services.yml:

Use loops to manage multiple services (httpd, mariadb, firewalld).
Notify handlers to restart services on config changes.
Handle failures gracefully (e.g., ignore_errors or failed_when for non-critical tasks).

Task 10: Comprehensive Playbook and Verification

Create a main playbook site.yml that includes previous playbooks/roles.

Use tags for selective runs.
Ensure all services are running, files are in place, and configs persist after simulated reboot.
Bonus: Create a dynamic inventory script or use add_host module
