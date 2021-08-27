## Initialization

```sh
ssh root@shqld.dev "
  yum install -y git \
  && rm -rf /ops \
  && git clone https://github.com/shqld/ops.git /ops \
  && make -C /ops setup
"
```
