FROM docker.io/node:16 AS build

WORKDIR /app

COPY package.json ./
RUN npm install

COPY public ./public
COPY src ./src

RUN npm run build

FROM docker.io/nginx:alpine

COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
