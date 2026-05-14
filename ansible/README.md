# Ansible — homelab-platform

> **CI:** Os workflows usam `runs-on: [self-hosted, homelab]`. Até os runners estarem registados com a label `homelab` (este playbook), os jobs ficam à espera. Para transição, podes usar temporariamente só `self-hosted` nos YAML em `.github/workflows/`.

## GitHub Actions self-hosted runners

1. **Terraform** (`terraform/envs/runners`): dois providers Proxmox (`pve1` e `pve2`). Um `terraform apply` no teu notebook cria a VM em **cada** servidor (credenciais em `terraform.tfvars`). Ajusta `locals.tf` (IP, VMID, nome do nó — em host único costuma ser `pve`).
2. **Inventário**: edita `inventory/hosts.yml` para coincidir com os IPs reais após o `terraform apply`.
3. **Repositório e SSH**: `inventory/group_vars/runners.yml` define `github_actions_runner_github_*` e `ansible_user` (por omissão `joaofmds`, alinhado às VMs Packer; se usares `ubuntu`, altera aí ou por host em `hosts.yml`).
4. **PAT**: cria um token clássico com scope `repo` (repositório privado) ou fine-grained com permissão de **Administration** no repositório, suficiente para `POST .../actions/runners/registration-token`. **Não** commites o token.

5. **CI (GitHub Actions)**: define no repositório `PROXMOX_PVE1_ENDPOINT`, `PROXMOX_PVE1_API_TOKEN`, `PROXMOX_PVE2_ENDPOINT`, `PROXMOX_PVE2_API_TOKEN` e `SSH_PUBLIC_KEY`. Os workflows **Terraform Plan/Apply** usam estes secrets tanto para `terraform/envs/homelab` como para `terraform/envs/runners`. O workflow **Build Ubuntu Proxmox Template** reutiliza os mesmos `PROXMOX_PVE{1,2}_*` e o secret `PACKER_SSH_PASSWORD` (o hash para `user-data` é gerado no runner com `openssl passwd -6`; ver `.github/workflows/packer-build-ubuntu.yaml`).

### Antes do playbook (rede)

1. Na **consola de cada VM runner**, corre `ip a` e anota o **IPv4** (ex.: `192.168.1.19`).
2. No **notebook**, na mesma LAN que o homelab: `ping <IP>` — tem de responder **antes** do Ansible.
3. Actualiza **`inventory/hosts.yml`** (`ansible_host`) para esses IPs.  
   Opcional: `terraform -chdir=../terraform/envs/runners output ansible_host_vars` (se o state Terraform bater com a realidade).
4. Se só uma VM estiver acessível:  
   `.venv/bin/ansible-playbook ... --limit gha-runner-pve2`

Erros `No route to host` / `Destination Host Unreachable` = **rede ou IP errado**, não PAT nem role Ansible.

### Comandos

No Ubuntu com Python 3 “externally managed” (PEP 668), o `ansible-playbook` em `~/.local/bin` pode falhar com `ModuleNotFoundError: No module named 'ansible'`. Usa um **venv** em `ansible/`:

```bash
cd ansible
python3 -m venv .venv
.venv/bin/pip install ansible-core
```

Depois, na pasta `ansible/`:

```bash
# Opcional: validação de sintaxe
.venv/bin/ansible-playbook --syntax-check -i inventory playbooks/github-runners.yml

# Registo e serviço (exporta o token no ambiente ou usa -e)
export GITHUB_TOKEN=ghp_xxxx
.venv/bin/ansible-playbook -i inventory playbooks/github-runners.yml -e "github_token=${GITHUB_TOKEN}"
```

`--check` não é fiável para esta role (transferências, API GitHub, `config.sh`).

## Kubernetes (kubeadm)

1. **Terraform** (`terraform/envs/homelab`): `terraform apply` com template Packer (VMID 9000) e `kubernetes_cloud_init_username` = `packer` (default).
2. **Inventário**: `inventory/hosts.yml` → grupo `k8s_cluster` (`k8s_control_plane` + `k8s_workers`). Ajusta `ansible_host` aos IPs reais (iguais a `locals.tf`).
3. **Versão**: `roles/kubernetes_kubeadm/defaults/main.yml` → `kubernetes_minor_version` (repo `pkgs.k8s.io`). Alinha com a [matriz de versões](https://kubernetes.io/releases/) que queres.
4. **CNI**: por omissão Flannel (`k8s_cni_manifest_url`); `k8s_pod_network_cidr` tem de ser compatível (default `10.244.0.0/16`).
5. **Ordem**: não uses `--limit` só nos workers na primeira corrida — o control-plane tem de gerar o `kubeadm join` primeiro.

```bash
cd ansible
.venv/bin/ansible-playbook --syntax-check -i inventory playbooks/kubeadm-cluster.yml
.venv/bin/ansible-playbook -i inventory playbooks/kubeadm-cluster.yml
```

No control-plane: `kubectl --kubeconfig=/etc/kubernetes/admin.conf get nodes`. No teu PC: copia `admin.conf` (com cuidado) ou SSH com `-L` para `kubectl` local.

### Re-registar um runner

Define `github_actions_runner_force_reregister: true` no host ou em extra-vars **e** fornece `github_token`. Remove o runner na UI do GitHub se ficar órfão.

### Troubleshooting

| Problema | O que verificar |
|----------|-----------------|
| `ModuleNotFoundError: ansible` | Usa `.venv/bin/ansible-playbook` (secção Comandos) ou `sudo apt install ansible-core`. |
| `401` na API | PAT expirado ou sem permissão no repositório. |
| Token de registo | Expira em minutos; o playbook obtém um novo a cada corrida que regista. |
| Job não arranca | O workflow precisa de `runs-on: [self-hosted, homelab]` e o runner tem de ter a label `homelab`. |
| `./config.sh` / `config.sh` falha (rc≠0, `no_log`) | Com `become` global, o script não pode correr como **root**. A role usa `github_actions_runner_run_user` (`ansible_user`). Corrige dono de `github_actions_runner_install_dir` e volta a correr. |
| `./svc.sh install` "Must run as sudo" | O `svc.sh` tem de correr como **root**; a role deixa de forçar `become_user` nessa tarefa. O `./config.sh` continua como `github_actions_runner_run_user`. |
| Kubeadm / workers sem `kubeadm_join` | Corre o playbook para **todo** `k8s_cluster` (inclui o control-plane). |
| `kubectl apply` CNI falha | Confirma `kubernetes_minor_version` e URL do Flannel; verifica `wait_for` 6443 no CP. |
| Workers `NotReady` | Espera o CNI; `kubectl describe node` no CP. |
