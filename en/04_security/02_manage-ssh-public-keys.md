\newpage

# How do I manage root's authorized_keys file with Ansible?

## Solution

###  Public git repo containing all the ssh public keys

We usually create a separate repo for all ssh public keys. So everyone can send pull request for updating their ssh public key. Of course you should verify them. :)

The repo looks like this below:

~~~
.
├── user1.pub
├── user2.pub
├── user3.pub
└── user4.pub
~~~

### Playbook to get latest ssh public keys

To make sure we always use the latest version of this repo. We set up a playbook, in which we checkout the lastest state to our local workstation.

~~~yaml
# filename: sshkeys.yml
---
- hosts: localhost
  connection: local
  tasks:
  - name: check out latest ssh public keys
    git: repo=https://github.com/example/ssh-pubkeys.git dest=./files/ssh-public-keys/
~~~


### Define who can access where

The next step is to setup the vars. Here we define, who should have access to all host by creating the vars section in `group_vars/all`: 

~~~yaml
# group_vars/all
---
ssh_root_users:
  - key: "{{ lookup('file', './files/sshkeys/user1.pub') }}"
  - key: "{{ lookup('file', './files/sshkeys/user2.pub') }}"
  - key: "{{ lookup('file', './files/sshkeys/user3.pub') }}"
  - key: "{{ lookup('file', './files/sshkeys/user4.pub') }}"
~~~

For webservers, we only give these 2 users access:

~~~yaml
# group_vars/webservers
---
ssh_root_users:
  - key: "{{ lookup('file', './files/sshkeys/user1.pub') }}"
  - key: "{{ lookup('file', './files/sshkeys/user2.pub') }}"
~~~

### Play for authorized_key deployment

Finally, we extend the playbook for the final deployment of authorized_key:

~~~yaml
# filename: sshkeys.yml
---
- hosts: localhost
  connection: local
  tasks:
  - name: check out latest ssh public keys
    git: repo=https://github.com/example/ssh-pubkeys.git dest=./files/sshkeys/

- hosts: all
  remote_user: root
  tasks:
  - name: add ssh root keys
    authorized_key: user="root" key="{{ item.key }}"
    with_items: ssh_root_users
~~~

## Explanation

The easiest way is to have a single authorized_keys file and use the copy task, of course.

However, often we can not reuse the same authorized_keys on every machine or group of machines. I wanted to have something which has the maximum of flexibily, but to be simple and comprehensible at the same time.

The above solution is a typical example how you can achive this with Ansible.
