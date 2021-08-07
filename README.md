## Initialization after OS reboot

```sh
op get item 'shqld/ops credentials' && \
op get item 'shqld/ops credentials' \
| jq -r .details.notesPlain \
| ssh -o StrictHostKeyChecking=no root@tk2-259-39467.vs.sakura.ne.jp "cat - > /etc/environment"

scp -o StrictHostKeyChecking=no -r . root@tk2-259-39467.vs.sakura.ne.jp:/ops
ssh -o StrictHostKeyChecking=no root@tk2-259-39467.vs.sakura.ne.jp "sh /ops/setup/init.sh"
```
