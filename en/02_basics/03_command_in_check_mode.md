\newpage

# How to make a command or shell run in check mode ?

## Solution

Use `always_run: yes` in the task.

Example use case:

~~~yaml   
# This tasks would be skippped without always_run
- name: check if vmware tools are installed
  shell: rpm -qa | grep foo
  always_run: yes
~~~

## Explanation

Commands and shell actions are skipped in check mode. If you want to force exection you can use `always_run: yes`. Also useful in this case is to add `changed_when: false` to always get a `ok` response instead of `changed`. 
