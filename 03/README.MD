# Домашнее задание к занятию 3 «Использование Ansible»

## Подготовка к выполнению

1. Для выполнения ДЗ создано 3 виртуальные машины в Yandex.Cloud.

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.

[Playbook](https://github.com/PatKolzin/Ansible/tree/main/03/playbook)

[Terraform](https://github.com/PatKolzin/Ansible/tree/main/03/playbook) 

2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.
4. Подготовьте свой inventory-файл `prod.yml`.
5. Запустите ansible-lint site.yml и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

## Решение

1-3. Дописал еще один play, который устанавливает LightHouse. Использую модули  `get_url`, `template`, `yum`, `service`, `file`. Происходит установка и конфигурирование веб-сервера Nginx, установка и конфигурирование LightHouse, запуск служб Nginx и LightHouse.

4. Подготовил свой inventory-файл `prod.yml`:

![monitoring](https://github.com/PatKolzin/Ansible/blob/main/03/Image/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA.png)


5. Запустил ansible-lint site.yml. Были ошибки в использовании старых наименований модулей, отсутствии прав на скачиваемые или создаваемые файлы. Ошибки исправлены.

6. Запустил playbook с флагом `--check`. Выполнение playbook завершилось с ошибкой, т.к. этот флаг не вносит изменения в системы, а выполнение playbook требует скачивания и установки пакетов приложений.

7. Запущен playbook на `prod.yml` окружении с флагом `--diff`. Изменения в систему внесены:

<details>
   <summary>ansible-playbook -i inventory/prod.yml site.yml --diff</summary>

```shell

pat@yubunta:~/ansible/Ansible/03/playbook$ ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Ping] ***************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************
The authenticity of host '158.160.127.42 (158.160.127.42)' can't be established.
ED25519 key fingerprint is SHA256:i+qEgpsz0JdEMFqz/8hNe9q09wqi0LlNABM5OZbZfQs.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [clickhouse-01]
ok: [lighthouse-01]
ok: [vector-01]

TASK [Check availability servers] *****************************************************************************************************************************************************
ok: [vector-01]
ok: [clickhouse-01]
ok: [lighthouse-01]

PLAY [Install Clickhouse] *************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *********************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *********************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] ****************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Enable remote connections to clickhouse server] *********************************************************************************************************************************
--- before: /etc/clickhouse-server/config.xml (content)
+++ after: /etc/clickhouse-server/config.xml (content)
@@ -176,7 +176,7 @@
          - users without password have readonly access.
          See also: https://www.shodan.io/search?query=clickhouse
       -->
-    <!-- <listen_host>::</listen_host> -->
+<listen_host>::</listen_host>
 
 
     <!-- Same for hosts without support for IPv6: -->

changed: [clickhouse-01]

TASK [Flush handlers] *****************************************************************************************************************************************************************

RUNNING HANDLER [Start clickhouse service] ********************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Create database] ****************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Create table] *******************************************************************************************************************************************************************
changed: [clickhouse-01]

PLAY [Install Vector] *****************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] *************************************************************************************************************************************************************
changed: [vector-01]

TASK [Install vector package] *********************************************************************************************************************************************************
changed: [vector-01]

TASK [Redefine vector config name] ****************************************************************************************************************************************************
--- before: /etc/default/vector (content)
+++ after: /etc/default/vector (content)
@@ -2,3 +2,4 @@
 # This file can theoretically contain a bunch of environment variables
 # for Vector.  See https://vector.dev/docs/setup/configuration/#environment-variables
 # for details.
+VECTOR_CONFIG=/etc/vector/config.yaml

changed: [vector-01]

TASK [Create vector config] ***********************************************************************************************************************************************************
--- before
+++ after: /home/pat/.ansible/tmp/ansible-local-274397rimk6aw/tmpee02wupw
@@ -0,0 +1,27 @@
+api:
+  address: 0.0.0.0:8686
+  enabled: true
+sinks:
+  to_clickhouse:
+    compression: gzip
+    database: vector_logs
+    endpoint: http://51.250.80.98:8123
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

changed: [vector-01]

TASK [Flush handlers] *****************************************************************************************************************************************************************

RUNNING HANDLER [Start Vector service] ************************************************************************************************************************************************
changed: [vector-01]

PLAY [Install lighthouse] *************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [add repo nginx] *****************************************************************************************************************************************************************
--- before
+++ after: /home/pat/.ansible/tmp/ansible-local-274397rimk6aw/tmp0d1nxd4n
@@ -0,0 +1,5 @@
+[nginx]
+name=nginx repo
+baseurl=https://nginx.org/packages/centos/$releasever/$basearch/
+gpgcheck=0
+enabled=1

changed: [lighthouse-01]

TASK [install nginx and git] **********************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [Get lighthouse from git] ********************************************************************************************************************************************************
>> Newly checked out d701335c25cd1bb9b5155711190bad8ab852c2ce
changed: [lighthouse-01]

TASK [Configure nginx from template] **************************************************************************************************************************************************
--- before: /etc/nginx/conf.d/default.conf
+++ after: /home/pat/.ansible/tmp/ansible-local-274397rimk6aw/tmpvq6h18t3/lighthouse.conf.j2
@@ -2,43 +2,14 @@
     listen       80;
     server_name  localhost;
 
-    #access_log  /var/log/nginx/host.access.log  main;
-
     location / {
-        root   /usr/share/nginx/html;
+        root   /usr/share/nginx/html/lighthouse;
         index  index.html index.htm;
     }
 
-    #error_page  404              /404.html;
-
-    # redirect server error pages to the static page /50x.html
-    #
     error_page   500 502 503 504  /50x.html;
     location = /50x.html {
         root   /usr/share/nginx/html;
     }
-
-    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
-    #
-    #location ~ \.php$ {
-    #    proxy_pass   http://127.0.0.1;
-    #}
-
-    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
-    #
-    #location ~ \.php$ {
-    #    root           html;
-    #    fastcgi_pass   127.0.0.1:9000;
-    #    fastcgi_index  index.php;
-    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
-    #    include        fastcgi_params;
-    #}
-
-    # deny access to .htaccess files, if Apache's document root
-    # concurs with nginx's one
-    #
-    #location ~ /\.ht {
-    #    deny  all;
-    #}
 }
 

changed: [lighthouse-01]

TASK [Flush handlers] *****************************************************************************************************************************************************************

RUNNING HANDLER [restarted nginx service] *********************************************************************************************************************************************
changed: [lighthouse-01]

PLAY RECAP ****************************************************************************************************************************************************************************
clickhouse-01              : ok=9    changed=6    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=8    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=8    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
</details>

8. Повторно запущен playbook с флагом `--diff`. Playbook идемпотентен, изменения связаны с перезапуском сервиса Vector:

<details>
    <summary>ansible-playbook -i inventory/prod.yml site.yml --diff</summary>

```shell
pat@yubunta:~/ansible/Ansible/03/playbook$ ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Ping] ***************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************
ok: [lighthouse-01]
ok: [clickhouse-01]
ok: [vector-01]

TASK [Check availability servers] *****************************************************************************************************************************************************
ok: [vector-01]
ok: [clickhouse-01]
ok: [lighthouse-01]

PLAY [Install Clickhouse] *************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *********************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "centos", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "centos", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *********************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ****************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Enable remote connections to clickhouse server] *********************************************************************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] *****************************************************************************************************************************************************************

TASK [Create database] ****************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create table] *******************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector] *****************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] *************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install vector package] *********************************************************************************************************************************************************
ok: [vector-01]

TASK [Redefine vector config name] ****************************************************************************************************************************************************
ok: [vector-01]

TASK [Create vector config] ***********************************************************************************************************************************************************
ok: [vector-01]

TASK [Flush handlers] *****************************************************************************************************************************************************************

PLAY [Install lighthouse] *************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [add repo nginx] *****************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [install nginx and git] **********************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Get lighthouse from git] ********************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Configure nginx from template] **************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Flush handlers] *****************************************************************************************************************************************************************

PLAY RECAP ****************************************************************************************************************************************************************************
clickhouse-01              : ok=8    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```
</details>


