## Initialization after OS reboot

```sh
op get item 'shqld/ops credentials' && \
op get item 'shqld/ops credentials' \
| jq -r .details.notesPlain \
| ssh -o StrictHostKeyChecking=no root@tk2-259-39467.vs.sakura.ne.jp "cat - > /etc/environment"

fd | xargs tar -c | ssh -o StrictHostKeyChecking=no root@tk2-259-39467.vs.sakura.ne.jp "cat | tar -xf - && rm -rf /ops && mkdir /ops && mv * /ops/ && sh /ops/setup/init.sh"
```
