## Initialization after OS reboot

```sh
op get item 'shqld/ops credentials' | jq -r .details.notesPlain | ssh root@tk2-259-39467.vs.sakura.ne.jp "cat - > /etc/environment"
scp -r ./setup root@tk2-259-39467.vs.sakura.ne.jp:~/setup
ssh root@tk2-259-39467.vs.sakura.ne.jp "sh ~/setup/init.sh"
```
