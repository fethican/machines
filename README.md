Copy instance templates from conf directory to $HOME/.machines folder.

```bash
$ cp -R conf $HOME/.machines
```

Copy machine.sh to /usr/local/bin and make it executable.

```bash
$ sudo cp machine.sh /usr/local/bin/machine
$ sudo chmod +x /usr/local/bin/machine
```

Create AWS API key file under /etc/aws

```bash
$ sudo mkdir -p /etc/aws
$ cat << 'EOF' > /etc/aws/keys
AWS_ACCESS_KEY=
AWS_SECRET_KEY=
EOF
```
