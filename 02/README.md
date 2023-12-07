
# Домашнее задание к занятию 2 «Работа с Playbook»

## Основная часть

1. Подготовьте свой inventory-файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev). Конфигурация vector должна деплоиться через template файл jinja2. От вас не требуется использовать все возможности шаблонизатора, просто вставьте стандартный конфиг в template файл. Информация по шаблонам по [ссылке](https://www.dmosk.ru/instruktions.php?object=ansible-nginx-install).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги. Пример качественной документации ansible playbook по [ссылке](https://github.com/opensearch-project/ansible-playbook).
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

## Ответ

1. Подготовил inventory-файл `prod.yml`:

![image](https://github.com/PatKolzin/Ansible/assets/75835363/42c4a4d2-2195-4c35-a1f8-38fc3a42f0b9)

Используется виртуальная машина Centos 7, созданная при помощи Vagrant.

2 - 4. Дописан playbook для установки Vector. Playbook использует модули `get_url`, `template`, `unarchive`, `file` и `shell`

Выполняется скачивание, разархивирование в указанную директорию, добавление конфигурации из файла шаблона и запуск Vector.

5. Запустил `ansible-lint site.yml`, увидел наличие ошибок. В данном случае в playbook отсутствовали права на скачиваемые и исполняемые файлы, присутствовали лишние отступы в коде, использовался устаревший синтаксис.

6. Запустил playbook с флагом `--check`. Флаг `--check` не вносит изменения в конечную систему. Выполнение плейбука невозможно с этим флагом, т.к. нет скачанных файлов дистрибутива, соответственно устанавливать нечего:

![image](https://github.com/PatKolzin/Ansible/assets/75835363/eaa64acb-88e4-43b2-8062-0f052d4f4701)

7. Запустил playbook с флагом `--diff`. Флаг позволяет отслеживать изменения в файлах на удаленных хостах, чтобы можно было видеть, какие конкретные изменения будут внесены на хостах в результате выполнения плейбука.

```
pat@olZion:~/ansible_HW/02/Ansible/02$ ansible-playbook -i inventory/prod.yml site.yml --diff
pat@olZion:~/ansible_HW/02/Ansible/02$
PLAY [Install Clickhouse] **********************************************************************************************************************
TASK [Gathering Facts] *************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ******************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "/tmp/clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ******************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] *************************************************************************************************************
changed: [clickhouse-01]

TASK [Firewall open port] **********************************************************************************************************************
changed: [clickhouse-01] => (item=9000/tcp)
changed: [clickhouse-01] => (item=8123/tcp)

RUNNING HANDLER [Start clickhouse service] *****************************************************************************************************
changed: [clickhouse-01]

PLAY [Install Vector] **************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [vector-01]

TASK [Create Vector directory] *****************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/etc/vector",
-    "state": "absent"
+    "state": "directory"
 }

changed: [vector-01]

TASK [Get Vector distrib] **********************************************************************************************************************
changed: [vector-01]

TASK [Unarchive Vector package] ****************************************************************************************************************
changed: [vector-01]

TASK [Template file] ***************************************************************************************************************************
--- before
+++ after: /home/pat/.ansible/tmp/ansible-local-31888vs38gorr/tmp9rxgi_u8/vector.toml.j2
@@ -0,0 +1,45 @@
+#TEST config from Ansible
+#                                    __   __  __
+#                                    \ \ / / / /
+#                                     \ V / / /
+#                                      \_/  \/
+#
+#                                    V E C T O R
+#                                   Configuration
+#
+# ------------------------------------------------------------------------------
+# Website: https://vector.dev
+# Docs: https://vector.dev/docs
+# Chat: https://chat.vector.dev
+# ------------------------------------------------------------------------------
+
+# Change this to use a non-default directory for Vector data storage:
+# data_dir = "/var/lib/vector"
+
+# Random Syslog-formatted logs
+[sources.dummy_logs]
+type = "demo_logs"
+format = "syslog"
+interval = 1
+
+# Parse Syslog logs
+# See the Vector Remap Language reference for more info: https://vrl.dev
+[transforms.parse_logs]
+type = "remap"
+inputs = ["dummy_logs"]
+source = '''
+. = parse_syslog!(string!(.message))
+'''
+
+# Print parsed logs to stdout
+[sinks.print]
+type = "console"
+inputs = ["parse_logs"]
+encoding.codec = "json"
+
+# Vector's GraphQL API (disabled by default)
+# Uncomment to try it out with the `vector top` command or
+# in your browser at http://localhost:8686
+#[api]
+#enabled = true
+#address = "127.0.0.1:8686"

changed: [vector-01]

TASK [Run Vector] ******************************************************************************************************************************

```

8. Повторно запускается playbook с флагом `--diff`, playbook идемпотентен, за исключением запуска Vector:

![image](https://github.com/PatKolzin/Ansible/assets/75835363/5708b93b-1bd9-4da6-a9f2-d6fc0ab805da)



