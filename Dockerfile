### Application React
FROM node:18-alpine as build
# set working directory
WORKDIR /app


# install app dependencies
#copies package.json and package-lock.json to Docker environment
COPY mon-app/package.json ./

# Installs all node packages
RUN npm install 


# Copies everything over to Docker environment
COPY mon-app/. ./
RUN npm run build

### Serveur Nginx pour l'application
FROM nginx:alpine

#copies React to the container directory
# Set working directory to nginx resources directory
WORKDIR /usr/share/nginx/html
# Remove default nginx static resources
RUN rm -rf ./*
# Copies static resources from builder stage
COPY --from=build /app/build .
# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]