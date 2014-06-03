\newpage

## How do I run Puppet agent by Ansible?

### Solution

Create a playbook having the following content:

~~~yaml
# filename: run-puppet.yml
---
- hosts: all
  remote_user: root
  serial: 3
  tasks:
    - command: puppet agent --test --no-noop creates=/var/lib/puppet/state/agent_catalog_run.lock
      register: puppet_result
      changed_when: puppet_result.rc == 2
      failed_when: puppet_result.rc == 1
~~~

### Explanation

The playbook has target to all hosts, but of course you can limit it using `--limit` e.g.:

~~~
$ ansible-playbook run-puppet.yml --limit webservers
~~~

The Puppet agent returns code 1 on failure, and 2 on change. That is why
we must use `register` to grap the return code.

We also use `serial` to perform a [Rolling Update](http://docs.ansible.com/playbooks_delegation.html#rolling-update-batch-size) 
and make sure to skip the command if Puppet agent is already running.
