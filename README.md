# kompose ---> kubernetes
En este trabajo pasamos el desafío 5 a kubernetes con la aplicación Kompose.
Recordemos que en el desafío 5 a partir de una aplicación (Nestjs) se construye la imagen con Docker y el manifiesto docker-compose.yaml que despliega los contenedores NestJS y la base MongoDB para poder desplegarla con contenedores.
Kompose traduce el manifiesto docker-compose.yaml a varios manifiestos de Kubernetes, deployment, replicaset, pvc y servicios para poder desplegar todo el entorno.

## Clonar el repositorio.
```
git clone https://github.com/ivolato/desafio-8-k8s.git
cd desafio-8-k8s
```

## Instalar Kompose
```
curl -L https://github.com/kubernetes/kompose/releases/download/v1.37.0/kompose-linux-amd64 -o kompose
chmod +x kompose
sudo mv ./kompose /usr/local/bin/kompose
kompose version
```

## Creamos la imagen de NestJS y la importamos a k8s.
```
docker build --tag nestjs . && docker save nestjs -o nestjs.tar
sudo ctr -n k8s.io images import nestjs.tar
```

## Traducir el manifiesto
```
mkdir kubernetes
kompose convert -f docker-compose.yaml -o kubernetes
```

## Parchear nestjs-deployment.yaml
cambiar el nombre del la imagen
image: docker.io/library/nestjs:latest
Agregar debajo la línea
imagePullPolicy: IfNotPresent
```
nano kubernetes/nestjs-deployment.yaml
```

## Parchear nestjs-service
Agregamos la línea justo debajo de spec: para enrutar fuera de Killercoda.
  type: NodePort
```
nano kubernetes/nestjs-service.yaml
```

## Creamos el pv necesario para generar el pvc de mongo.
```
kubectl apply -f mongo-pv.yaml
```

## Aplicamos los manifiesto de Kubernetes.
```
kubectl apply -f ./kubernetes
```
## Reseteamos el Deploy de NestJS para que la imagen cargue correctamente.
Esperar unos minutos para lanzar el siguiente comando de reset.
```
kubectl rollout restart deployment nestjs
```