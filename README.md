# Unofficial Ansible playbook for installing sys-audio AppVM for QubesOS

Version 1 (unstable).

Use at your own risk.

# (DRAFT) HOW TO USE
1. Clone repository with submodules ( `--recursive` option) on some AppVM
```bash
# AppVM
git clone --recursive https://github.com/bartlomiejkida/ansible-qubes-sys-audio
```
2. Place content in archive
```bash
# AppVM
tar -cf ansible-qubes-sys-audio.tar ansible-qubes-sys-audio
```
3. Copy archive from AppVM to dom0 and unpack
```bash
# dom0
qvm-run --pass-io YOUR_APPVM "cat /path/to/ansible-qubes-sys-audio.tar" > ansible-qubes-sys-audio.tar
tar xf ansible-qubes-sys-audio.tar
```
4. Make sure you have ansible installed on dom0
```bash
qubes-dom0-update ansible
```
5. Check your inventory and change variables if you should have fedora instead debian
```bash
cd ansible-qubes-sys-audio
cat inventory/sys-audio.ini
```
6. Run playbook
```bash
ansible-playbook site.yml
```


## TODO:
- Add variables for tasks
- Extend README and write how-to
- Add git submodule for qubes ansible ( https://github.com/kushaldas/qubes_ansible )
