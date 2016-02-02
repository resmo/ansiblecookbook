\newpage

# How do I calculate the quorum for a cluster?

## Solution

In the inventory we defined a group `mesos-masters` having some members:

~~~ini
; filename: inventory 
[mesos-masters]
cluster-1.example.com
cluster-2.example.com
cluster-2.example.com
~~~

Calculate the quorum

~~~yaml
quorum: "{{ (( 1 + ( groups['mesos-masters'] | count )) / 2 ) | round(0, 'ceil') | int }}"
~~~

## Explanation

The quorum for a cluster with 3 members would be 2. If we would have 4 members, the qorum would be 3.
