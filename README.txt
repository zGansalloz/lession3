Автоматическое развертывание 4 виртуальных машин на облаке yandex cloud
1. VM proxy (Ubuntu 20.04, SUB IP: 10.0.10.3)
 - Автоматическая установка Nginx с настройкой проксирования на (WEB MAIN и WEB MIRROR по внутреннему интерфейсу)

2. WEB MAIN (Ubuntu 22.04 SUB IP: 10.0.10.10)
3. WEB MIRROR (Ubuntu 22.04 SUB IP: 10.0.10.11)
 - Автоматическая установка PHP8.1, Nginx.
 - Выканичвание и распаковка последней версии WORDPRESS
 (Вам потребуется задать только пароли для входа в админку через барузер используй IP адрес VM PROXY)


4. MYSQL Mariadb10.11 (Ubuntu 22.04 SUB IP: 10.0.10.6)
 - Автоматическая установка MariaDB 10.11 последней ревизии из репозитария MariaDB
 - Случайный сгенерированный пароль для root (можете посмотреть в /root/.my.cnf) и удаление анонимных пользователей и базы данных test


Требование:
На хосте откуда будет производиться запуск Terraform должно быть установлено следующее программногое обеспечение
==========================
Terraform v1.7.1 и выше
ansible-core 2.15.3 и выше
Python3

А так же дополнительные пакеты.
ansible-galaxy collection install community.mysql
ansible-galaxy collection install community.general
==========================
Отредактируйте файл provider.tf и внесите данные со своего личного кабинета

cloud_id
folder_id

До запуска скрипта установите переменные
export YC_TOKEN=$(ВАШ ТОКЕН)
export TF_VAR_yc_token=$YC_TOKEN

Создайте файл сервис аккаунта (если его нет). yc iam key create --service-account-name my-robot --output key.json export YC_SERVICE_ACCOUNT_KEY_FILE=/home/user/authorized_key.json

Настройка переменных

(variables.tf) Укажите расположение приватного ключа в variable "private_key" по умолчанию: ~/.ssh/id_rsa
(main.tf) Укажите расположения публичного ключа в metadata. По умолчанию: ~/.ssh/id_rsa.pub

После установки вы получите 4 IP адреса в консоли, воспользуйтесь тем под которым увидите "Proxy".
Далее Вам потребуется внести авторизационные данный для работы с WP.