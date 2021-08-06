## Initialization after OS reboot

```sh
op get item 'shqld/ops credentials' | jq -r .details.notesPlain | ssh root@tk2-259-39467.vs.sakura.ne.jp "cat - > /etc/environment"
scp -o StrictHostKeyChecking=no -r ./setup root@tk2-259-39467.vs.sakura.ne.jp:~/setup
ssh -o StrictHostKeyChecking=no root@tk2-259-39467.vs.sakura.ne.jp "sh ~/setup/init.sh"
```
