\newpage

## How do I store private data in git for Ansible?

### Solution

Requirements: GnuPG

1. Create a password file for ansible-vault and add it to .gitignore.

~~~
$ pwgen 12 1 > vault-password.txt
$ echo vault-password.txt >> .gitignore
$ git add .gitignore
$ git commit -m "ignore vault-password.txt"
~~~

2. Use GnuPG to encrypt the password file used for `ansible-vault`:

~~~
$ gpg --recipient 42FF42FF \
--recipient 12345678 \
--recipient FEFEFEFE \
--recipient EFEFEFEF \
--encrypt-files vault-password.txt
~~~

The above command will create an encrypted version of our password file in a new file vault-password.txt.gpg. 

3. Add the file vault-password.txt.gpg to your git repository.

~~~
$ git add vault-password.txt.gpg
$ git commit -m "store encrypted password"
~~~

4. If you did it right, you can now decrypt vault-password.txt.gpg and run it

~~~
$ gpg --decrypt vault-password.txt.gpg
$ ansible-playbook --vault-password-file vault-password.txt ...
~~~

5. Create an alias `ansible-playbook-vault` for your daily usage.

This alias will automatically decrypt the vault-password.txt.gpg if necessary and uses the encrypted file with option `--vault-password-file`:

$ alias ansible-playbook-vault='test -e vault-password.txt || gpg --decrypt-files vault-password.txt.gpg; ansible-playbook --vault-password-file vault-password.txt $@'

### Explanation

Ansible has a tool for encryption of var files like `group_vars` and `host_vars` sind version 1.5, [ansible-vault](http://docs.ansible.com/playbooks_vault.html).

However, with ansible-vault you can only encrypt and decrypt var files. Another downside is you have to remember the password and this password must be shared accross your team members.

That is why `ansible-playbook` has an other option for letting you write the password in a file and pass `--vault-password-file <filename>` to `ansible-playbook`. So you do not have to writing it over and over again every time you run a playbook or also meant for automated execution of ansible.

But as you can guess, the password is stored in plain text in a file and we likely want this file to be in a public git repo.

That is the part where asymetric cryptology and PGP comes into the game. PGP lets you encrypt any file without shareing a password, even for a group of people.s
