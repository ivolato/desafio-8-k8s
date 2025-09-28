#Imagen base.
FROM node:18-alpine

#Establecemos el directorio de trabajo.
WORKDIR /app

#Copiamos la configuración inicial.
COPY package*.json ./

#Instalamos las dependencias.
RUN npm install

#Copiamos todo el contenido al directorio /app
COPY . .

#Compilamos, es requerido para el modo productivo.
RUN npm run build

#Abrimos el puerto.
EXPOSE 3000

#Iniciamos nestjs.
CMD ["npm", "run", "start:prod"]
