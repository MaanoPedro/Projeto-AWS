# 🌐 Infraestrutura Web na AWS com Terraform

Este projeto provisiona uma infraestrutura básica na AWS com uma instância EC2 rodando Nginx pelo sistema operacional Ubuntu 22.04.4 LTS, uma página HTML personalizada e um sistema de monitoramento com alertas via webhook do Discord.

## ✅ Pré-requisitos

- Conta na AWS com permissões básicas
- AWS CLI configurado (`aws configure`)
- Terraform instalado
- Chave SSH

## ⚙️ Passo a Passo

### 1. Clone o repositório

```bash
git clone https://github.com/seuusuario/seurepo.git
cd seu/diretorio/infra
```

### 2. Configure o webhook no `user_data.sh`

Substitua a linha:

```bash
WEBHOOK_URL= "<WEBHOOK_URL>"
```

Pelo seu Webhook real do Discord.

### 3. Gere uma chave SSH (caso ainda não tenha)

```bash
ssh-keygen -t rsa -b 4096 -f projeto1
mv projeto1 projeto1.pem
chmod 400 projeto1.pem
```

### 4. Inicialize o Terraform

```bash
terraform init
```

### 5. Verifique o plano antes de aplicar e se estiver sem erros aplique logo em seguida

```bash
terraform plan
terraform apply
```

### 6. Acesse a página via navegador

Use o IP público exibido pelo Terraform:

```
http://<IP_PÚBLICO>
```

### 7. Acesse a EC2 via SSH (opcional)

```bash
ssh -i projeto1 ubuntu@<IP_PÚBLICO>
```

## 🛠️ Recursos Criados

- VPC com 4 sub-redes (2 públicas e 2 privadas)
- Internet Gateway e tabela de rotas
- Security Group para HTTP e SSH
- Instância EC2 com IP público e Elastic IP
- Página HTML personalizada
- Monitoramento com cron + webhook Discord
