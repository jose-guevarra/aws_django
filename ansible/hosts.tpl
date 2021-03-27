all:
    hosts:
        HOST_PUBLIC_IP1:
        HOST_PUBLIC_IP2:
    vars:
        ansible_user: ubuntu
        ansible_ssh_private_key_file: FULL_PATH_TO_KEYS/keyname.pem
        home_dir: /var/www
        django_dir: "{{ home_dir }}/django-hitcount/example_project"
        static_dir: "{{ home_dir }}/static"
        django_project: example_project
        clb_dns_name: AWS_LOADBALANCER_DNS_NAME_GOES_HERE
        aws_db_dns_name: AWS_DB_DNS_NAME_GOES_HERE
        aws_db_username: AWS_DB_USERNAME_GOES_HERE
        aws_db_password: AWS_DB_PASSWORD_GOES_HERE
