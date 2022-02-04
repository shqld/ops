# ARCHITECTURE

## Overview

TBD

## Directories

```
/Makefile
/setup
  |- Makefile
  |- pkg.mk
  |- users.mk
/system
  |- Makefile
/app
  |- Makefile
```

https://github.com/shqld/ops/tree/main/

## Setup

TBD

## Application

Every application is a docker container and run by `docker compose`.

Applications are placed under `/system` and `/app`.

-   `/system`
    -   maintained in this repo
    -   daemon-like app e.g. nginx, varnish, which are originally intended to be run by `systemd`
-   `/app`
    -   maintained in other repos
    -   typical app e.g. nodejs

## Task Management

As we can see in the tree, most directories have `Makefile`.
