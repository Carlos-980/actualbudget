###################################################
# This Dockerfile is used by the docker-compose.yml
# file to build the development container.
# Do not make any changes here unless you know what
# you are doing.
###################################################

FROM node:20-bullseye as dev
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y openssl
WORKDIR /app
CMD ["sh", "./bin/docker-start"]

# Usamos node 18
FROM node:18

# Carpeta de trabajo
WORKDIR /app

# Copiamos package.json y lockfile para instalar deps
COPY package.json pnpm-lock.yaml ./

# Instalamos pnpm global y dependencias
RUN npm install -g pnpm
RUN pnpm install --frozen-lockfile

# Copiamos todo el código
COPY . .

# Construimos la app
RUN pnpm run build

# Puerto que usará Actual Budget
ENV PORT=5006

# Exponemos el puerto
EXPOSE 5006

# Comando para arrancar el servidor
CMD ["pnpm", "run", "start"]
