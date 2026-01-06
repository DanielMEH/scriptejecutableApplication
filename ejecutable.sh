#!/bin/bash
echo "limiando entorno de trabajo, redsocial,postredsocial"
echo " clonando redsocial.."
git clone https://github.com/DanielMEH/redsocial.git
echo " clonado exitosamente.."

echo " clonando post redsocial.."
git clone https://github.com/DanielMEH/postredsocial.git
echo " clonado exitosamente.."

echo " Iniciando despliegue de RedSocial..."

echo " Limpiando contenedores y volúmenes antiguos..."
docker-compose down -v

echo "e Construyendo y levantando servicios..."
docker-compose up --build -d

echo " Proceso terminado. Estado de los contenedores:"
docker-compose ps

rm -rf ./redsocial 
rm -rf ./postredsocial 
echo " Para ver los logs ejecuta: docker-compose logs -f"