\newpage

# How do I deploy PHP web applications?

Deployment of web applications has never been easy.

Even there are many good tools which help a lot doing it right, like [Capistrano](https://github.com/capistrano/capistrano) or [Fabric](http://www.fabfile.org).

But why you should learn another tool if Ansible can do the job even better? I want to show you, how I deploy PHP web applications:

## Solution

One characteristic of a web application is, that most of the time we are dealing with intepreted scripting languages, like PHP, Python or Ruby. So one solution to deploy an application is to checkout the code from your source code management tool and run some installation sciprts like database migration.

### Application source from git repo

This would be too easy right?

~~~yaml
# filename: app-deployment.yml
---
- hosts: appservers
  vars:
    app_version: v1.0.0
  tasks:
  - name: Checkout the application from git
    git: repo=git://github.com/example/repo.git dest=/srv/www/myapp version={{ app_version }}
    register: app_checkout_result

  - name: Update dependencies
    command: php composer.phar install --no-dev

  - name: Run migration job
    command: php artisan migrate
    when: app_checkout_result.changed
~~~

But wait, what about database backup? Monitoring downtime? Inform team members? As simple as that.

~~~yaml
# filename: app-deployment.yml
---
- hosts: appservers
  vars:
    app_version: v1.0.0
  tasks:
  - name: inform team members about start
    local_action: jabber
                  user=deployment@example.net password=secret
                  to=friend@example.net
                  msg="Deployment of App version {{ app_version }} started"

  - name: Set monitroing Downtime
    local_action: nagios action=downtime minutes=10 service=app host={{ inventory_hostname }}

  - name: Checkout the application from git
    git: repo=git://github.com/example/repo.git dest=/srv/www/myapp version={{ app_version }}
    register: app_checkout_result

  - name: Backup the database
    command: mysqldump myapp  --result-file=backup-{{ ansible_date_time.epoch }}.sql
    when: app_checkout_result.changed

  - name: Update dependencies
    command: php composer.phar install --no-dev

  - name: Run migration job
    command: php artisan migrate
    when: app_checkout_result.changed

  - name: inform team members about end
    local_action: jabber
                  user=deployment@example.net password=secret
                  to=friend@example.net
                  msg="Deployment of App version {{ app_version }} ended"
~~~

My applications are usually in a git repo. This git repo may be a private repo, so you even have to authenticate for read access. Further git is a dependency of our installation. We may or can not have git installed on the webservers. In this case, we just checkout the repo locally and sync the files using rsync or [git-ftp](https://github.com/git-ftp/git-ftp):

~~~yaml
# filename: app-deployment.yml
---
- hosts: appservers
  vars:
    app_version: v1.0.0
  tasks:
  ...
  - name: Checkout the application from git
    local_action: git repo=git://github.com/example/repo.git dest=/srv/www/myapp version={{ app_version }}
    register: app_checkout_result
  
  - name: Sync the applications
    local_action: command rsync --ignore .git ...
    
  ...
~~~

## Explanation
