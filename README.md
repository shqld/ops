## Create passwords

```sh
ssh-keygen -t ed25519 -b 4096 -m pem -C "me@shqld.dev"
```

## Initialization after OS reboot

```sh
op get item 'shqld/ops credentials' && \
op get item 'shqld/ops credentials' \
| jq -r .details.notesPlain \
| ssh -o StrictHostKeyChecking=no root@shqld.dev "cat - > /etc/environment"

ls | xargs tar -c | ssh root@shqld.dev "cat | tar -xf - && rm -rf /ops && mkdir /ops && mv * /ops/ && /ops/setup/init"
```
