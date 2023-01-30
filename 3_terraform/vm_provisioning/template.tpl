#cloud-config
users:
  - default
  - name: dari
    gecos: dari
    groups: users, admin
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    lock_passwd: false
    passwd: $6$rounds=4096$RWUg9aP7cnQpfEOq$BJVOgRJx1zt8W0LAzTWKD7vPbdFH711xNhChS1RKuJKeBAghrMtZML.hFGxccJKgaUEQIF2jABZ.kqX5j2ewo0
