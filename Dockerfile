# build environment
FROM node:16-slim as build

WORKDIR /app

COPY . .

RUN npm install

RUN npm run build

# production environment

FROM nginx:alpine

COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]