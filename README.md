# Objetivo

Implantar uma infraestrutura básica e funcional na AWS, com servidor web Nginx hospedando uma página HTML simples, além de um sistema de monitoramento automatizado com alertas via Discord webhook e registro de logs no servidor.

# DOCUMENTAÇÃO TÉCNICA - Infraestrutura AWS com Terraform

## 1. variables.tf

Define os parâmetros do projeto, facilitando reuso e manutenção.

- Define variáveis como região AWS (`region`), nome da chave SSH (`key_name`), caminho da chave pública (`public_key_path`), AMI utilizada (`ami_id`) e tipo de instância (`instance_type`).
- Permite alterar rapidamente configurações sem modificar outros arquivos.

---

## 2. main.tf

Criação dos recursos AWS.

- **Provider:** Inicializa o provedor AWS usando a região definida em `variables.tf`.
- **aws_key_pair:** Importa a chave pública para acesso SSH à EC2.
- **aws_vpc:** Cria uma VPC isolada para os recursos.
- **aws_subnet:** Provisiona subnets públicas e privadas, distribuídas em zonas de disponibilidade.
- **aws_internet_gateway:** Permite acesso externo à VPC.
- **aws_route_table & association:** Configura rotas para permitir saída à internet nas subnets públicas.
- **aws_security_group:** Define regras de firewall para liberar portas 22 (SSH) e 80 (HTTP).
- **aws_instance:** Cria a EC2, associando chave SSH, grupo de segurança, subnet pública e script de inicialização (`user_data.sh`).
- **aws_eip:** Aloca e associa um IP público fixo à instância.

---

## 3. user_data.sh

Automatiza a configuração da instância EC2 no momento do boot.

- Atualiza pacotes e instala NGINX e CURL.
- Substitui a página padrão do NGINX por um HTML explicativo do projeto.
- Remove arquivos desnecessários do NGINX.
- Cria script de monitoramento (`monitor_site.sh`) que verifica a disponibilidade do serviço web e envia notificações via webhook.
- Configura o monitoramento para rodar a cada minuto via cron.

---

## 4. outputs.tf

Expõe informações para o usuário após o provisionamento.

- **instance_url:** Exibe a URL pública para acessar o serviço web hospedado na EC2.
- **ssh_command:** Gera o comando SSH completo para acesso remoto, parametrizando o nome da chave e IP público.

---

## 5. projeto1.pub / projeto1.pem

Gerencia credenciais de acesso à instância.

- **projeto1.pub:** Chave pública utilizada para autenticação SSH.
- **projeto1.pem:** Chave privada correspondente.
