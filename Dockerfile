FROM node:14.4.0-alpine3.12
RUN apk add git

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

COPY run.sh ./
CMD ["./run.sh"]
