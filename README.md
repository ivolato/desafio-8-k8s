# kompose ---> kubernetes

## Clonar el repositorio.
```
git clone https://github.com/ivolato/desafio-8-k8s.git
cd desafio-8-k8s
```

## Instalar kompose
```
curl -L https://github.com/kubernetes/kompose/releases/download/v1.37.0/kompose-linux-amd64 -o kompose
chmod +x kompose
sudo mv ./kompose /usr/local/bin/kompose
kompose version
```

## Creamos la imagen de nestjs y la importamos a k8s.
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
Agregar debajo la linea
imagePullPolicy: IfNotPresent
```
nano kubernetes/nestjs-deployment.yaml
```

## Parchear nestjs-service
Agregamos la linea justo debajo de spec: para enrutar fuera de killercoda.
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
## Reseteamos el Deploy de Nestjs para que la imagen cargue correctamente.
Esperar unos minutos para lanzar el siguiente comando de reset.
```
kubectl rollout restart deployment nestjs
```