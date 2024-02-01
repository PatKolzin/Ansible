# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

1. Установите molecule и его драйвера: `pip3 install "molecule molecule_docker molecule_podman`.
2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

## Основная часть

Ваша цель — настроить тестирование ваших ролей. 

Задача — сделать сценарии тестирования для vector. 

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s ubuntu_xenial` (или с любым другим сценарием, не имеет значения) внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками или не отработать вовсе, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу И из чего может состоять сценарий тестирования.

<details><summary>molecule test -s ubuntu_bionic</summary>

```
pat@olZion:~/1home/Ansible/05/playbook/roles/clickhouse$ molecule test -s ubuntu_bionic
WARNING  Driver docker does not provide a schema.
CRITICAL Failed to validate /home/pat/1home/Ansible/05/playbook/roles/clickhouse/molecule/ubuntu_bionic/molecule.yml

["Additional properties are not allowed ('playbooks' was unexpected)"]
pat@olZion:~/1home/Ansible/05/playbook/roles/clickhouse$

```
</details>

2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.

```
pat@olZion:~/1home/Ansible_old/05/playbook/roles/vector-role$ molecule init scenario --driver-name=docker
INFO     Initializing new scenario default...

PLAY [Create a new molecule scenario] ******************************************

TASK [Check if destination folder exists] **************************************
changed: [localhost]

TASK [Check if destination folder is empty] ************************************
ok: [localhost]

TASK [Fail if destination folder is not empty] *********************************
skipping: [localhost]

TASK [Expand templates] ********************************************************
changed: [localhost] => (item=molecule/default/create.yml)
changed: [localhost] => (item=molecule/default/destroy.yml)
changed: [localhost] => (item=molecule/default/converge.yml)
changed: [localhost] => (item=molecule/default/molecule.yml)

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Initialized scenario in /home/pat/1home/Ansible_old/05/playbook/roles/vector-role/molecule/123 successfully.
```

3. Добавьте несколько разных дистрибутивов для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.

<details><summary>molecule test</summary>

```
pat@olZion:~/1home/Ansible_old/05/playbook/roles/vector-role$ molecule test
WARNING  Driver docker does not provide a schema.
INFO     default scenario test matrix: dependency, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos7)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
ok: [localhost] => (item=centos7)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/pat/1home/Ansible_old/05/playbook/roles/vector-role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None)
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})
skipping: [localhost]

TASK [Synchronization the context] *********************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})
skipping: [localhost]

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'false_condition': 'not item.pre_build_image | default(false)', 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:7)
skipping: [localhost]

TASK [Create docker network(s)] ************************************************
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos7)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (299 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j763163268109.5885', 'results_file': '/home/pat/.ansible_async/j763163268109.5885', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=2    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos7]

TASK [Detect python3 version] **************************************************
ok: [centos7]

TASK [Set python version of script to 3] ***************************************
skipping: [centos7]

TASK [Download SystemD replacer v3] ********************************************
skipping: [centos7]

TASK [Download SystemD replacer v2] ********************************************
changed: [centos7]

TASK [Create systemd directories] **********************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/run/systemd/system",
-    "state": "absent"
+    "state": "directory"
 }

changed: [centos7] => (item=/run/systemd/system)
ok: [centos7] => (item=/usr/lib/systemd/system)

TASK [Replace systemctl] *******************************************************
changed: [centos7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Get vector distrib] ****************************************
changed: [centos7]

TASK [vector-role : Install vector package] ************************************
changed: [centos7]

TASK [vector-role : Redefine vector config name] *******************************
--- before: /etc/default/vector (content)
+++ after: /etc/default/vector (content)
@@ -2,3 +2,4 @@
 # This file can theoretically contain a bunch of environment variables
 # for Vector.  See https://vector.dev/docs/setup/configuration/#environment-variables
 # for details.
+VECTOR_CONFIG=/etc/vector/config.yaml

changed: [centos7]

TASK [vector-role : Create vector config] **************************************
--- before
+++ after: /etc/vector/config.yaml
@@ -0,0 +1,27 @@
+api:
+  address: 0.0.0.0:8686
+  enabled: true
+sinks:
+  to_clickhouse:
+    compression: gzip
+    database: vector_logs
+    endpoint: http://localhost:8123
+    inputs:
+    - parse_logs
+    table: logs_logs
+    type: clickhouse
+sources:
+  logs_logs:
+    format: syslog
+    interval: 1
+    type: demo_logs
+transforms:
+  parse_logs:
+    inputs:
+    - logs_logs
+    source: '. = parse_syslog!(string!(.message))
+
+      .timestamp = to_string(.timestamp)
+
+      .timestamp = slice!(.timestamp, start:0, end: -1)'
+    type: remap

changed: [centos7]

TASK [vector-role : Flush handlers] ********************************************

PLAY RECAP *********************************************************************
centos7                    : ok=9    changed=7    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos7]

TASK [Detect python3 version] **************************************************
ok: [centos7]

TASK [Set python version of script to 3] ***************************************
skipping: [centos7]

TASK [Download SystemD replacer v3] ********************************************
skipping: [centos7]

TASK [Download SystemD replacer v2] ********************************************
ok: [centos7]

TASK [Create systemd directories] **********************************************
ok: [centos7] => (item=/run/systemd/system)
ok: [centos7] => (item=/usr/lib/systemd/system)

TASK [Replace systemctl] *******************************************************
ok: [centos7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Get vector distrib] ****************************************
ok: [centos7]

TASK [vector-role : Install vector package] ************************************
ok: [centos7]

TASK [vector-role : Redefine vector config name] *******************************
ok: [centos7]

TASK [vector-role : Create vector config] **************************************
ok: [centos7]

TASK [vector-role : Flush handlers] ********************************************

PLAY RECAP *********************************************************************
centos7                    : ok=9    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier
WARNING  Skipping, verify action has no playbook.
INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos7)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos7)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory

```
</details>

4. Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.). 


```
---
# This is an example playbook to execute Ansible tests.

- name: Verify
  hosts: all
  gather_facts: false
  tasks:
  - name: Example assertion
    ansible.builtin.assert:
      that: true
  - name: Get Vector version
    ansible.builtin.command: "vector --version"
    changed_when: false
    register: vector_version
  - name: Assert Vector installation
    ansible.builtin.assert:
      that: { vector_version.rc == '0' }

```

5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.

<details><summary>molecule test</summary>

```

pat@olZion:~/1home/Ansible/05/playbook/roles/vector-role$ molecule test
WARNING  Driver docker does not provide a schema.
INFO     default scenario test matrix: dependency, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos7)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
ok: [localhost] => (item=centos7)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/pat/1home/Ansible/05/playbook/roles/vector-role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None)
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})
skipping: [localhost]

TASK [Synchronization the context] *********************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})
skipping: [localhost]

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'false_condition': 'not item.pre_build_image | default(false)', 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:7)
skipping: [localhost]

TASK [Create docker network(s)] ************************************************
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos7)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (299 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j486094830910.1319', 'results_file': '/home/pat/.ansible_async/j486094830910.1319', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=2    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos7]

TASK [Detect python3 version] **************************************************
ok: [centos7]

TASK [Set python version of script to 3] ***************************************
skipping: [centos7]

TASK [Download SystemD replacer v3] ********************************************
skipping: [centos7]

TASK [Download SystemD replacer v2] ********************************************
changed: [centos7]

TASK [Create systemd directories] **********************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/run/systemd/system",
-    "state": "absent"
+    "state": "directory"
 }

changed: [centos7] => (item=/run/systemd/system)
ok: [centos7] => (item=/usr/lib/systemd/system)

TASK [Replace systemctl] *******************************************************
changed: [centos7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Get vector distrib] ****************************************
changed: [centos7]

TASK [vector-role : Install vector package] ************************************
changed: [centos7]

TASK [vector-role : Redefine vector config name] *******************************
--- before: /etc/default/vector (content)
+++ after: /etc/default/vector (content)
@@ -2,3 +2,4 @@
 # This file can theoretically contain a bunch of environment variables
 # for Vector.  See https://vector.dev/docs/setup/configuration/#environment-variables
 # for details.
+VECTOR_CONFIG=/etc/vector/config.yaml

changed: [centos7]

TASK [vector-role : Create vector config] **************************************
--- before
+++ after: /etc/vector/config.yaml
@@ -0,0 +1,27 @@
+api:
+  address: 0.0.0.0:8686
+  enabled: true
+sinks:
+  to_clickhouse:
+    compression: gzip
+    database: vector_logs
+    endpoint: http://localhost:8123
+    inputs:
+    - parse_logs
+    table: logs_logs
+    type: clickhouse
+sources:
+  logs_logs:
+    format: syslog
+    interval: 1
+    type: demo_logs
+transforms:
+  parse_logs:
+    inputs:
+    - logs_logs
+    source: '. = parse_syslog!(string!(.message))
+
+      .timestamp = to_string(.timestamp)
+
+      .timestamp = slice!(.timestamp, start:0, end: -1)'
+    type: remap

changed: [centos7]

TASK [vector-role : Flush handlers] ********************************************

PLAY RECAP *********************************************************************
centos7                    : ok=9    changed=7    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos7]

TASK [Detect python3 version] **************************************************
ok: [centos7]

TASK [Set python version of script to 3] ***************************************
skipping: [centos7]

TASK [Download SystemD replacer v3] ********************************************
skipping: [centos7]

TASK [Download SystemD replacer v2] ********************************************
ok: [centos7]

TASK [Create systemd directories] **********************************************
ok: [centos7] => (item=/run/systemd/system)
ok: [centos7] => (item=/usr/lib/systemd/system)

TASK [Replace systemctl] *******************************************************
ok: [centos7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Get vector distrib] ****************************************
ok: [centos7]

TASK [vector-role : Install vector package] ************************************
ok: [centos7]

TASK [vector-role : Redefine vector config name] *******************************
ok: [centos7]

TASK [vector-role : Create vector config] **************************************
ok: [centos7]

TASK [vector-role : Flush handlers] ********************************************

PLAY RECAP *********************************************************************
centos7                    : ok=9    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Example assertion] *******************************************************
ok: [centos7] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Get Vector version] ******************************************************
ok: [centos7]

TASK [Assert Vector installation] **********************************************
ok: [centos7] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos7)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos7)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory

```

</details>

5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

[1.1.0](https://github.com/PatKolzin/Ansible/releases/tag/1.1.0)

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.

<details><summary>docker run</summary>

```
pat@olZion:~/1home/Ansible/05/playbook/roles/vector-role$ docker run --privileged=True -v ~/1home/Ansible/05/playbook/roles/vector-role:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash
[root@ce1185463924 vector-role]# tox
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,arrow==1.2.3,bcrypt==4.1.2,binaryornot==0.4.4,cached-property==1.5.2,Cerberus==1.3.5,certifi==2023.11.17,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.3.2,click==8.1.7,click-help-colors==0.9.4,cookiecutter==2.5.0,cryptography==42.0.2,distro==1.9.0,enrich==1.2.7,idna==3.6,importlib-metadata==6.7.0,Jinja2==3.1.3,jmespath==1.0.1,lxml==5.1.0,markdown-it-py==2.2.0,MarkupSafe==2.1.4,mdurl==0.1.2,molecule==3.6.1,molecule-podman==1.1.0,packaging==23.2,paramiko==2.12.0,pluggy==1.2.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.3,PyYAML==6.0.1,requests==2.31.0,rich==13.7.0,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='811643572'
py37-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,arrow==1.2.3,bcrypt==4.1.2,binaryornot==0.4.4,cached-property==1.5.2,Cerberus==1.3.5,certifi==2023.11.17,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.3.2,click==8.1.7,click-help-colors==0.9.4,cookiecutter==2.5.0,cryptography==42.0.2,distro==1.9.0,enrich==1.2.7,idna==3.6,importlib-metadata==6.7.0,Jinja2==3.1.3,jmespath==1.0.1,lxml==5.1.0,markdown-it-py==2.2.0,MarkupSafe==2.1.4,mdurl==0.1.2,molecule==3.6.1,molecule-podman==1.1.0,packaging==23.2,paramiko==2.12.0,pluggy==1.2.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.3,PyYAML==6.0.1,requests==2.31.0,rich==13.7.0,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,zipp==3.15.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='811643572'
py37-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==4.1.11,ansible-core==2.15.9,ansible-lint==5.1.3,arrow==1.3.0,attrs==23.2.0,bcrypt==4.1.2,binaryornot==0.4.4,bracex==2.4,Cerberus==1.3.5,certifi==2023.11.17,cffi==1.16.0,chardet==5.2.0,charset-normalizer==3.3.2,click==8.1.7,click-help-colors==0.9.4,cookiecutter==2.5.0,cryptography==42.0.2,distro==1.9.0,enrich==1.2.7,idna==3.6,importlib-resources==5.0.7,Jinja2==3.1.3,jmespath==1.0.1,jsonschema==4.21.1,jsonschema-specifications==2023.12.1,lxml==5.1.0,markdown-it-py==3.0.0,MarkupSafe==2.1.4,mdurl==0.1.2,molecule==3.5.2,molecule-podman==2.0.0,packaging==23.2,paramiko==2.12.0,pathspec==0.12.1,pluggy==1.4.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.3,PyYAML==5.4.1,referencing==0.33.0,requests==2.31.0,resolvelib==1.0.1,rich==13.7.0,rpds-py==0.17.1,ruamel.yaml==0.18.5,ruamel.yaml.clib==0.2.8,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.3,text-unidecode==1.3,types-python-dateutil==2.8.19.20240106,typing_extensions==4.9.0,urllib3==2.2.0,wcmatch==8.5,yamllint==1.26.3
py39-ansible210 run-test-pre: PYTHONHASHSEED='811643572'
py39-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==4.1.11,ansible-core==2.15.9,ansible-lint==5.1.3,arrow==1.3.0,attrs==23.2.0,bcrypt==4.1.2,binaryornot==0.4.4,bracex==2.4,Cerberus==1.3.5,certifi==2023.11.17,cffi==1.16.0,chardet==5.2.0,charset-normalizer==3.3.2,click==8.1.7,click-help-colors==0.9.4,cookiecutter==2.5.0,cryptography==42.0.2,distro==1.9.0,enrich==1.2.7,idna==3.6,importlib-resources==5.0.7,Jinja2==3.1.3,jmespath==1.0.1,jsonschema==4.21.1,jsonschema-specifications==2023.12.1,lxml==5.1.0,markdown-it-py==3.0.0,MarkupSafe==2.1.4,mdurl==0.1.2,molecule==3.5.2,molecule-podman==2.0.0,packaging==23.2,paramiko==2.12.0,pathspec==0.12.1,pluggy==1.4.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.3,PyYAML==5.4.1,referencing==0.33.0,requests==2.31.0,resolvelib==1.0.1,rich==13.7.0,rpds-py==0.17.1,ruamel.yaml==0.18.5,ruamel.yaml.clib==0.2.8,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.3,text-unidecode==1.3,types-python-dateutil==2.8.19.20240106,typing_extensions==4.9.0,urllib3==2.2.0,wcmatch==8.5,yamllint==1.26.3
py39-ansible30 run-test-pre: PYTHONHASHSEED='811643572'
py39-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
____________________________________________________________________________________________________ summary ____________________________________________________________________________________________________
ERROR:   py37-ansible210: commands failed
ERROR:   py37-ansible30: commands failed
ERROR:   py39-ansible210: commands failed
ERROR:   py39-ansible30: commands failed

```

</details>

5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.

```
*---
dependency:
  name: galaxy
role_name_check: 1
driver:
  name: podman
lint: |
  ansible-lint .
  yamllint .
platforms:
  - name: centos7
    image: docker.io/pycontribs/centos:7
    pre_build_image: true
provisioner:
  name: ansible
verifier:
  name: ansible
scenario:
  test_sequence:
    - destroy
    - create
    - converge
    - destroy*
```


6. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.

```
[tox]
minversion = 1.8
basepython = python3.6
envlist = py{37}-ansible{210,30}
skipsdist = true

[testenv]
passenv = *
deps =
    -r tox-requirements.txt
    ansible210: ansible<3.0
    ansible30: ansible<3.1
commands =
    {posargs:molecule test -s tox --destroy always}
```

8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.

<details><summary>[root@1895d5bda8a3 vector-role]# tox</summary>

```
pat@olZion:~/1home/Ansible/05/playbook/roles/vector-role$ docker run --privileged=True -v ~/1home/Ansible/05/playbook/roles/vector-role:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash
[root@1895d5bda8a3 vector-role]# tox
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,arrow==1.2.3,bcrypt==4.1.2,binaryornot==0.4.4,cached-property==1.5.2,Cerberus==1.3.5,certifi==2023.11.17,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.3.2,click==8.1.7,click-help-colors==0.9.4,cookiecutter==2.5.0,cryptography==42.0.2,distro==1.9.0,enrich==1.2.7,idna==3.6,importlib-metadata==6.7.0,Jinja2==3.1.3,jmespath==1.0.1,lxml==5.1.0,markdown-it-py==2.2.0,MarkupSafe==2.1.4,mdurl==0.1.2,molecule==3.6.1,molecule-podman==1.1.0,packaging==23.2,paramiko==2.12.0,pluggy==1.2.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.3,PyYAML==6.0.1,requests==2.31.0,rich==13.7.0,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='2932585159'
py37-ansible210 run-test: commands[0] | molecule test -s tox --destroy always
INFO     tox scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/b984a4/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/b984a4/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/b984a4/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /root/.ansible/roles/sergey.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running tox > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running tox > create

PLAY [Create] ******************************************************************

TASK [Populate instance config dict] *******************************************
skipping: [localhost]

TASK [Convert instance config dict to a list] **********************************
skipping: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=0    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

INFO     Running tox > converge

PLAY [Converge] ****************************************************************

TASK [Include vector-role] *****************************************************

TASK [vector-role : Get vector distrib] ****************************************
fatal: [centos7]: UNREACHABLE! => {"changed": false, "msg": "Failed to create temporary directory.In some cases, you may have been able to authenticate and did not have permissions on the target directory. Consider changing the remote tmp path in ansible.cfg to a path rooted in \"/tmp\", for more error information use -vvv. Failed command was: ( umask 77 && mkdir -p \"` echo ~/.ansible/tmp `\"&& mkdir \"` echo ~/.ansible/tmp/ansible-tmp-1706814548.096507-81-77989662139748 `\" && echo ansible-tmp-1706814548.096507-81-77989662139748=\"` echo ~/.ansible/tmp/ansible-tmp-1706814548.096507-81-77989662139748 `\" ), exited with result 125", "unreachable": true}

PLAY RECAP *********************************************************************
centos7                    : ok=0    changed=0    unreachable=1    failed=0    skipped=0    rescued=0    ignored=0

WARNING  Retrying execution failure 4 of: ansible-playbook -D --inventory /root/.cache/molecule/vector-role/tox/inventory --skip-tags molecule-notest,notest /opt/vector-role/molecule/tox/converge.yml
CRITICAL Ansible return code was 4, command was: ['ansible-playbook', '-D', '--inventory', '/root/.cache/molecule/vector-role/tox/inventory', '--skip-tags', 'molecule-notest,notest', '/opt/vector-role/molecule/tox/converge.yml']
WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running tox > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running tox > destroy

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible210/bin/molecule test -s tox --destroy always (exited with code 1)
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,arrow==1.2.3,bcrypt==4.1.2,binaryornot==0.4.4,cached-property==1.5.2,Cerberus==1.3.5,certifi==2023.11.17,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.3.2,click==8.1.7,click-help-colors==0.9.4,cookiecutter==2.5.0,cryptography==42.0.2,distro==1.9.0,enrich==1.2.7,idna==3.6,importlib-metadata==6.7.0,Jinja2==3.1.3,jmespath==1.0.1,lxml==5.1.0,markdown-it-py==2.2.0,MarkupSafe==2.1.4,mdurl==0.1.2,molecule==3.6.1,molecule-podman==1.1.0,packaging==23.2,paramiko==2.12.0,pluggy==1.2.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.3,PyYAML==6.0.1,requests==2.31.0,rich==13.7.0,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,zipp==3.15.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='2932585159'
py37-ansible30 run-test: commands[0] | molecule test -s tox --destroy always
INFO     tox scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/b984a4/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/b984a4/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/b984a4/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /root/.ansible/roles/sergey.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running tox > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running tox > create

PLAY [Create] ******************************************************************

TASK [Populate instance config dict] *******************************************
skipping: [localhost]

TASK [Convert instance config dict to a list] **********************************
skipping: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=0    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

INFO     Running tox > converge

PLAY [Converge] ****************************************************************

TASK [Include vector-role] *****************************************************

TASK [vector-role : Get vector distrib] ****************************************
fatal: [centos7]: UNREACHABLE! => {"changed": false, "msg": "Failed to create temporary directory.In some cases, you may have been able to authenticate and did not have permissions on the target directory. Consider changing the remote tmp path in ansible.cfg to a path rooted in \"/tmp\", for more error information use -vvv. Failed command was: ( umask 77 && mkdir -p \"` echo ~/.ansible/tmp `\"&& mkdir \"` echo ~/.ansible/tmp/ansible-tmp-1706814559.430742-206-193985988713379 `\" && echo ansible-tmp-1706814559.430742-206-193985988713379=\"` echo ~/.ansible/tmp/ansible-tmp-1706814559.430742-206-193985988713379 `\" ), exited with result 125", "unreachable": true}

PLAY RECAP *********************************************************************
centos7                    : ok=0    changed=0    unreachable=1    failed=0    skipped=0    rescued=0    ignored=0

WARNING  Retrying execution failure 4 of: ansible-playbook -D --inventory /root/.cache/molecule/vector-role/tox/inventory --skip-tags molecule-notest,notest /opt/vector-role/molecule/tox/converge.yml
CRITICAL Ansible return code was 4, command was: ['ansible-playbook', '-D', '--inventory', '/root/.cache/molecule/vector-role/tox/inventory', '--skip-tags', 'molecule-notest,notest', '/opt/vector-role/molecule/tox/converge.yml']
WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running tox > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running tox > destroy

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible30/bin/molecule test -s tox --destroy always (exited with code 1)
____________________________________________________________________________________________________ summary ____________________________________________________________________________________________________
ERROR:   py37-ansible210: commands failed
ERROR:   py37-ansible30: commands failed
[root@1895d5bda8a3 vector-role]#
```

</details>

9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

[1.2.0](https://github.com/PatKolzin/Ansible/releases/tag/1.2.0)

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания. 

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.
