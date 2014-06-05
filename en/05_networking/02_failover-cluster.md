\newpage

# How do I make manage config of a failover cluster?

## Solution

Make use of serial keyword in you play. This also called [Rolling Update](http://docs.ansible.com/playbooks_delegation.html#rolling-update-batch-size) in Ansible's Docs.

~~~yaml
---
- hosts: database-cluster
  serial: 1
~~~

## Explanation

A failover cluster often consist of 2 nodes only, so we set `serial: 1` to make sure, we do all tasks on one node after the other.
