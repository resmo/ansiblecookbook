\newpage

# How do use all hosts in the host group except the current host ?

## Solution

In a task:
    
    - hosts: webservers
      tasks:
      - debug: msg="{{ item }}"
        with_items: groups.webservers
        when: "item != inventory_hostname"

In a template:

    {% for host in groups['webservers'] %}
      {% if host == inventory_hostname %}
        {{ host }}
      {% endif%}
    {% endfor %}


## Explanation

In many cluster management you need to set all other nodes in the cluster. This can be done dynamically using `with_items` and `when` or similar logic in a template.
