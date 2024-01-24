# Домашнее задание к занятию 4 «Работа с roles»

## Основная часть

Ваша цель — разбить ваш playbook на отдельные roles. 

Задача — сделать roles для ClickHouse, Vector и LightHouse и написать playbook для использования этих ролей. 

Ожидаемый результат — существуют три ваших репозитория: два с roles и один с playbook.

**Что нужно сделать**

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.13"
       name: clickhouse 
   ```

2. При помощи `ansible-galaxy` скачайте себе эту роль.
3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Опишите в `README.md` обе роли и их параметры. Пример качественной документации ansible role [по ссылке](https://github.com/cloudalchemy/ansible-prometheus).
7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.
9. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---

## Решение основной части

1. В старом playbook создал файл requirements.yml с указанным содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.13"
       name: clickhouse 
   ```

2. Скачал роль с помощью `ansible-galaxy`, появилась директория `roles` с субдиректорией `clickhouse`, в которой находится playbook для установки роли clickhouse.

3. С помощью `ansible-galaxy role init vector-role` создал роль `vector-role`.

4. Заполнил новую роль, разнес переменные по соответствующим директориям.

5. Перенес шаблоны конфигов в `templates` роли.

6. Сделал описание для созданных ролей в файлах `README.md`.

7. Повторил все шаги для роли `lighthouse-role`.

8. Выложил роли в репозитории. Ссылки на репозитории ролей:

[vector-role](https://github.com/12sergey12/vector-role)

[lighthouse-role](https://github.com/12sergey12/lighthouse-role)

9. Изменил playbook на использование roles.

10. Выложил playbook в репозиторий. Ссылка на playbook: [playbook](https://github.com/12sergey12/8.4_ansible_role/tree/main/playbook)

---
