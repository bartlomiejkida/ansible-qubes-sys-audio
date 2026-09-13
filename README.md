# Unofficial Ansible playbook for installing sys-audio AppVM for QubesOS

Version 1 (unstable).

Use at your own risk.

Requires **Qubes OS 4.3+** — the playbook uses the official
[qubes-ansible](https://github.com/QubesOS/qubes-ansible) collections
(`qubesos.core` connection plugin, `qubesos.security.qubes_proxy` strategy),
which are only available starting with Qubes 4.3.

# HOW TO USE
1. Clone repository on some AppVM (no submodules needed)
```bash
# AppVM
git clone https://github.com/bartlomiejkida/ansible-qubes-sys-audio
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
4. Make sure you have ansible and the qubes-ansible package installed on dom0
```bash
# dom0
cd ansible-qubes-sys-audio
./install_ansible_first.sh
# or manually:
qubes-dom0-update -y ansible qubes-ansible
# Debian-based dom0 additionally needs: qubes-dom0-update -y qubes-ansible-admin
```
5. Check your inventory and change variables if you should have fedora instead debian
```bash
cat inventory/sys-audio.ini
```
6. Run playbook (as root on dom0)
```bash
ansible-playbook site.yml
```

## How it works
- Plays targeting `dom0` (`localhost`) run locally.
- Plays targeting the template / AppVM run through the `qubes_proxy`
  strategy: each qube is managed from its own management DispVM, which is
  created from the qube's `management_dispvm` template.
- The playbook installs `qubes-ansible-vm` into the sys-audio template
  (required for the management DispVM to run Ansible) and points the
  `management_dispvm` property of the sys-audio qubes to that template.

## TODO:
- Add variables for tasks
- Extend README and write how-to
