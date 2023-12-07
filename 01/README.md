# Домашнее задание к занятию 1 «Введение в Ansible»

## Подготовка к выполнению

1. Установите Ansible версии 2.10 или выше.
2. Создайте свой публичный репозиторий на GitHub с произвольным именем.
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть

1. Запустил playbook на окружении из `test.yml`, зафиксировал значение '12', которое имеет факт `some_fact` для указанного хоста при выполнении playbook.

![Снимок экрана от 2023-12-01 12-12-07](https://github.com/PatKolzin/Ansible/assets/75835363/b18a0305-859d-4c9b-8e44-7750794cb7f5)

2. Нашёл файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменял его на `all default fact`.
3. Воспользовался подготовленным (используется `docker`) окружением для проведения дальнейших испытаний.
4. Провёл запуск playbook на окружении из `prod.yml`. Зафиксировал полученные значения `some_fact` для каждого из `managed host`.

![Снимок экрана от 2023-12-01 12-39-20](https://github.com/PatKolzin/Ansible/assets/75835363/6c929809-9d09-4e50-baf2-fb6536015e2a)

5. Добавил факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.
6.  Повторил запуск playbook на окружении `prod.yml`. Убедился, что выдаются корректные значения для всех хостов.

![Снимок экрана от 2023-12-01 12-42-50](https://github.com/PatKolzin/Ansible/assets/75835363/fa9ce9ac-f168-4fa3-993c-ec08877f3371)

7. При помощи `ansible-vault` зашифровал факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

![Снимок экрана от 2023-12-01 12-57-53](https://github.com/PatKolzin/Ansible/assets/75835363/8eddff8b-116c-44ad-9b59-1591a593f746)

8. Запустил playbook на окружении `prod.yml`. При запуске `ansible` должен запросить пароль. Убедился в работоспособности.

![Снимок экрана от 2023-12-01 12-59-35](https://github.com/PatKolzin/Ansible/assets/75835363/9b8bb88e-b240-4368-a463-2ad74c59fa32)

9. Посмотрел при помощи `ansible-doc` список плагинов для подключения. Выбрал подходящий для работы на `control node`.

![Снимок экрана от 2023-12-01 13-15-38](https://github.com/PatKolzin/Ansible/assets/75835363/f8fa48e0-f7c4-4bc7-9d86-1031f17931f4)

10. В `prod.yml` добавил новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
11. Запустил playbook на окружении `prod.yml`. При запуске `ansible` должен запросил пароль. Убедился, что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

![Снимок экрана от 2023-12-01 13-19-22](https://github.com/PatKolzin/Ansible/assets/75835363/1ce55df3-4a82-42e5-b43b-af2688a82b87)

12. Заполнил `README.md` ответами на вопросы. Сделал `git push` в ветку `main`. 


## Необязательная часть

1. При помощи `ansible-vault` расшифровал все зашифрованные файлы с переменными.

![Снимок экрана от 2023-12-01 15-47-09](https://github.com/PatKolzin/Ansible/assets/75835363/aeed8528-066f-4675-aa80-d19ff742e114)

2. Зашифровал отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавил полученное значение в `group_vars/all/exmp.yml`.
3. Запустил `playbook`, убедился, что для нужных хостов применился новый `fact`.

![Снимок экрана от 2023-12-01 17-08-18](https://github.com/PatKolzin/Ansible/assets/75835363/d55405b9-20e7-47be-b210-958fb3ef8af6)

4. Добавил новую группу хостов `fedora`. 
5. Написал скрипт на bash: автоматизировал поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.

```
#!/bin/bash
NAME1=centos7
NAME2=ubuntu
NAME3=fedora
IMAGE1=pycontribs/centos:7
IMAGE2=pycontribs/ubuntu:latest
IMAGE3=pycontribs/fedora:latest

docker run -dit --name $NAME1 $IMAGE1
docker run -dit --name $NAME2 $IMAGE2
docker run -dit --name $NAME3 $IMAGE3

docker start $NAME1
docker start $NAME2
docker start $NAME3

ansible-playbook -i inventory/prod.yml site.yml --vault-password-file ~/ansible/ansible/password

docker stop $NAME1
docker stop $NAME2
docker stop $NAME3

```
6. Все изменения отправлены в личный репозиторий.

---

