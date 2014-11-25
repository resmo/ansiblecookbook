\newpage

# How do I use all hosts data in my play or template?

## Solution

In a task:

    ---
    hosts: webservers
    tasks: 
    - debug: msg="{{ item }}"
      with_items: groups.all

In a template:

    {% for host in groups['all'] %}
      {{ host }}
    {% endfor %}
  
Access host variables dynamically:

    {% for host in groups['all'] %}
      {{ hostvars[host]['your_varibable_name'] }}
    {% endfor %}

## Explanation

Often you want to use every host in inventory, like for a monitoring play or for a dns zone file. The first thing you see is to set the scope to all hosts in inventory e.g. `hosts: all` and then use `delegate_to` in the tasks.

This might work in some cases but it looks not the right way. The more elegant way is to tool over the special group `all` containing all hosts.
