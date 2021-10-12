# ARCHITECTURE

## Overview

TBD

## Directories

```
/Taskfile.yml
/setup
  |- packages
  |- users
  |- Taskfile.yml
/system
  |- nginx
  |- Taskfile.yml
/app
  |- varnish
  |- www
  |- Taskfile.yml
```

https://github.com/shqld/ops/tree/main/

## Setup

TBD

## Application

Every application is a docker container and run by `docker-compose`.

Applications are placed under `/system` and `/app`.

-   `/system`
    -   maintained in this repo
    -   daemon-like app e.g. nginx, which are originally intended to be run by `systemd`
-   `/app`
    -   maintained in other repos
    -   typical app e.g. nodejs

## Task Management

As we can see in the tree, most directories have `Taskfile.yml` which is for `task` (see https://taskfile.dev) instead of `make` + `Makefile`

`task` nicely works for tasks with complex dependency and conditions. For example, see https://github.com/shqld/ops/tree/main/setup and https://github.com/shqld/ops/actions for how unnecessary tasks are controlled.
