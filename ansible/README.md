# Ansible — homelab-platform

> **CI:** Os workflows usam `runs-on: [self-hosted, homelab]`. Até os runners estarem registados com a label `homelab` (este playbook), os jobs ficam à espera. Para transição, podes usar temporariamente só `self-hosted` nos YAML em `.github/workflows/`.

## GitHub Actions self-hosted runners

1. **Terraform** (`terraform/envs/runners`): dois providers Proxmox (`pve1` e `pve2`). Um `terraform apply` no teu notebook cria a VM em **cada** servidor (credenciais em `terraform.tfvars`). Ajusta `locals.tf` (IP, VMID, nome do nó — em host único costuma ser `pve`).
2. **Inventário**: edita `inventory/hosts.yml` para coincidir com os IPs reais após o `terraform apply`.
3. **Repositório alvo**: `inventory/group_vars/runners.yml` define `github_actions_runner_github_owner` e `github_actions_runner_github_repo`.
4. **PAT**: cria um token clássico com scope `repo` (repositório privado) ou fine-grained com permissão de **Administration** no repositório, suficiente para `POST .../actions/runners/registration-token`. **Não** commites o token.

5. **CI (GitHub Actions)**: para o plan/apply do stack `runners`, define no repositório os secrets `PROXMOX_PVE1_ENDPOINT`, `PROXMOX_PVE1_API_TOKEN`, `PROXMOX_PVE2_ENDPOINT`, `PROXMOX_PVE2_API_TOKEN` (além de `SSH_PUBLIC_KEY`). O stack `homelab` continua a usar `PROXMOX_ENDPOINT` e `PROXMOX_API_TOKEN` se forem um único alvo. O workflow **Build Ubuntu Proxmox Template** reutiliza os mesmos `PROXMOX_PVE{1,2}_*` e só o secret `PACKER_SSH_PASSWORD` (o hash para `user-data` é gerado no runner com `openssl passwd -6`; ver `.github/workflows/packer-build-ubuntu.yaml`).

### Comandos

Na pasta `ansible/`:

```bash
# Opcional: validação de sintaxe (requer ansible-core instalado)
ansible-playbook --syntax-check -i inventory playbooks/github-runners.yml

# Registo e serviço (exporta o token no ambiente ou usa -e)
export GITHUB_TOKEN=ghp_xxxx
ansible-playbook -i inventory playbooks/github-runners.yml -e "github_token=${GITHUB_TOKEN}"
```

`--check` não é fiável para esta role (transferências, API GitHub, `config.sh`).

### Re-registar um runner

Define `github_actions_runner_force_reregister: true` no host ou em extra-vars **e** fornece `github_token`. Remove o runner na UI do GitHub se ficar órfão.

### Troubleshooting

| Problema | O que verificar |
|----------|-----------------|
| `401` na API | PAT expirado ou sem permissão no repositório. |
| Token de registo | Expira em minutos; o playbook obtém um novo a cada corrida que regista. |
| Job não arranca | O workflow precisa de `runs-on: [self-hosted, homelab]` e o runner tem de ter a label `homelab`. |
| SSH falha | Chave em `terraform.tfvars` igual à usada pelo Ansible; `ansible_user` no inventário. |
