#!/bin/bash
set -e

apt update -y
apt install -y nginx curl

systemctl start nginx
systemctl enable nginx

echo "<!DOCTYPE html>
<html>
<head>
<title>Projeto 1</title>
<style>
html { color-scheme: light dark; }
body { width: 35em;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Infraestrutura Web na AWS com Monitoramento Automatizado</h1>
<p><strong>Para chegar no resultado segui a seguinte linha de execucao:</strong><br><br>
Criei uma VPC definindo o IPv4 10.0.0.0/16 para um maior range de IPs;<br><br>
Criei todas as SubNets associadas a VPC definidas pelo documento:<br>
SubNet Publica 1a: Zona sa-east-1a; IPv4 10.0.0.0/24<br>
SubNet Privada 1a: Zona sa-east-1a; IPv4 10.0.1.0/24<br>
SubNet Publica 1b: Zona sa-east-1b; IPv4 10.0.2.0/24<br>
SubNet Privada 1b: Zona sa-east-1b; IPv4 10.0.3.0/24<br><br>
Criei uma Internet Gateway vinculada a VPC;<br><br>
Defini a rota para as SubNets, ligando as SubNets Publicas com a Internet Gateway criada anteriormente;<br>
</p>
<p><strong>Apos isso eu criei as EC2</strong><br><br>
Com as tags necessarias;<br><br>
Sistema operacional Ubuntu;<br><br>
Instancia t2.micro;<br><br>
Defini em configuracoes de rede:<br>
SubNet Publica<br>
Habilitar IP publico automatico<br>
Criei grupo de seguranca para permitir trafego HTTP e SSH<br>
</p>
<p>Com a maquina criada e tudo configurado eu acessei a EC2 com a chave de acesso e IPv4 publico, fiz a instalacao do NGINX, fiz o arquivo HTML para teste da pagina e acessei a pagina pelo link http://ip_publico_EC2</p>
</body>
</html>" > /var/www/html/index.html

rm /var/www/html/index.nginx-debian.html

cat << 'EOF' > /usr/local/bin/monitor_site.sh
#!/bin/bash
set -x

SITE="http://localhost"
WEBHOOK_URL= "<WEBHOOK_URL>"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$SITE")

if [ "$HTTP_STATUS" -ne 200 ]; then
    MSG="[$TIMESTAMP] Servidor fora do ar! Código HTTP: $HTTP_STATUS"
else
    MSG="[$TIMESTAMP] Servidor online. Código HTTP: $HTTP_STATUS"
fi

echo "Enviando para o Discord: $MSG" >> "$LOGFILE"

curl -v -H "Content-Type: application/json" \
     -X POST \
     -d "{\"content\": \"$MSG\"}" \
     "$WEBHOOK_URL" >> "$LOGFILE" 2>&1

echo "$MSG" >> "$LOGFILE"
EOF

touch /var/log/monitoramento.log

chmod +x /usr/local/bin/monitor_site.sh

echo "* * * * * /usr/local/bin/monitor_site.sh" | sudo crontab -