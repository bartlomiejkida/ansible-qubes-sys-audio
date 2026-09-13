# Unofficial Ansible playbook for installing sys-audio AppVM for QubesOS

Version 1 (unstable).

Use at your own risk.

Requires **Qubes OS 4.3+** — the playbook uses the official
[qubes-ansible](https://github.com/QubesOS/qubes-ansible) collections
(`qubesos.core` connection plugin, `qubesos.security.qubes_proxy` strategy),
which are only available starting with Qubes 4.3.

## What it does

Creates a dedicated audio AppVM (`sys-audio`) with its own TemplateVM
(`<base_template>-sys-audio`):

- **TemplateVM** — cloned from `base_template` (Debian or Fedora), installs
  the audio stack (pipewire/wireplumber, qubes-audio-daemon, bluetooth),
  `qubes-ansible-vm` (required by the management mechanism, see below) and
  disables powersave for the `snd_hda_intel` kernel module.
- **AppVM** — HVM, no network, tagged `audiovm-sys-audio`, registered as the
  `audiovm` service; enables Qubes hotfix for wireplumber, makes Bluetooth
  fast-connectable (with bind dirs so the setting survives template updates)
  and autostarts `qvm-start-daemon` and `blueman-manager`.
- **dom0** — installs `qubes-audio-dom0`, sets `sys-audio` as the default
  audio device, adds the Qubes RPC policy, disables audio on other sys VMs
  and (optionally) installs a libvirt hook that starts `sys-audio` when a
  USB device is attached to `sys-usb`.

## How it works

- Plays targeting `dom0` (`localhost`) run locally.
- Plays targeting the TemplateVM / AppVM run through the `qubes_proxy`
  strategy: each qube is managed from its own management DispVM, which is
  created from the qube's `management_dispvm` template.
- The playbook bootstraps that mechanism: it installs `qubes-ansible-vm`
  into the sys-audio TemplateVM and points the `management_dispvm` property
  of the sys-audio qubes to that TemplateVM.

## HOW TO USE

1. Clone the repository on some AppVM
```bash
# AppVM
git clone https://github.com/bartlomiejkida/ansible-qubes-sys-audio
```
2. Place content in archive
```bash
# AppVM
tar -cf ansible-qubes-sys-audio.tar ansible-qubes-sys-audio
```
3. Copy the archive from AppVM to dom0 and unpack
```bash
# dom0
qvm-run --pass-io YOUR_APPVM "cat /path/to/ansible-qubes-sys-audio.tar" > ansible-qubes-sys-audio.tar
tar xf ansible-qubes-sys-audio.tar
```
4. Make sure ansible and the qubes-ansible package are installed on dom0
```bash
# dom0
cd ansible-qubes-sys-audio
./install_ansible_first.sh
# or manually:
qubes-dom0-update -y ansible qubes-ansible
# Debian-based dom0 additionally needs: qubes-dom0-update -y qubes-ansible-admin
```
5. Check the inventory and adjust it if you want fedora instead of debian
```bash
cat inventory/sys-audio.ini
```
6. Run the playbook (as root on dom0).
   The first run downloads the base template and can take several minutes.
```bash
ansible-playbook site.yml
```

The playbook is idempotent — you can re-run it after template updates or
config changes to re-apply the roles. Use `--tags` to run a part of it
(`templatevm`, `appvm`, `dom0`), e.g.:

```bash
ansible-playbook site.yml --tags appvm
```

## Configuration

All values are variables — override them in `inventory/sys-audio.ini`
(`[dom0:vars]`) or `group_vars/all.yml`:

| Variable                 | Default                                  | Description                                    |
| ------------------------ | ---------------------------------------- | ---------------------------------------------- |
| `base_template`          | `debian-13-xfce`                         | base template to clone from (fedora: `fedora-44-xfce`) |
| `appvm_sys_audio`        | `sys-audio`                              | name of the audio AppVM                        |
| `templatevm_sys_audio`   | `{{ base_template }}-sys-audio`          | name of the dedicated TemplateVM               |
| `appvm_label`            | `black`                                  | AppVM window label                             |
| `appvm_maxmemory`        | `700`                                    | AppVM initial memory (MB)                      |
| `appvm_vcpus`            | `1`                                      | AppVM vCPU count                               |
| `appvm_menu_items`       | `blueman-manager.desktop ...`            | desktop files in the AppVM Applications menu   |
| `dom0_packages`          | `qubes-audio-dom0`                       | packages installed on dom0                     |
| `sys_vms_no_audio`       | `sys-firewall`, `sys-net`, `sys-usb`     | sys VMs with audio explicitly disabled         |
| `default_user`           | `user`                                   | user inside the VMs                            |
| `enable_usb_auto_attach` | `false`                                  | install the libxl hook that starts `sys-audio` on USB attach in `sys-usb` |

Package lists for the TemplateVM live in `roles/templatevm/vars/main.yml`
(`templatevm_packages_fedora` / `templatevm_packages_debian`).

## Known limitations

- PCI audio devices are not attached automatically (the `sys-audio` VM must
  be attached to them manually or via a separate task); USB audio works out
  of the box.
- The first run starts the sys-audio qubes and leaves them stopped;
  `sys-audio` is configured to autostart at dom0 boot.
