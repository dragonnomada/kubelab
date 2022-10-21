echo "INSTALANDO DOCKER..."

sudo snap install docker

sudo groupadd docker

sudo usermod -aG docker $USER

sudo snap disable docker

sudo snap enable docker

echo "DOCKER INSTALADO"

echo "CIERRA LA SESIÓN 😪 Y EJECUTA bash pipe.2.sh"