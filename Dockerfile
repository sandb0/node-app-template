# Node application builder stage.
FROM node:18.13.0-alpine3.17 AS node-builder

WORKDIR /node-application

COPY package*.json yarn.lock ./
RUN yarn

COPY . .
RUN yarn build

# Node application runtime stage.
FROM alpine:latest

RUN addgroup -S nodegroup && adduser -S nodeuser -G nodegroup

WORKDIR /node-application

RUN apk add --update nodejs

COPY --from=node-builder /node-application/dist ./dist
COPY --from=node-builder /node-application/entrypoint.sh ./

RUN chmod +x entrypoint.sh
USER nodeuser

ENTRYPOINT [ "./entrypoint.sh" ]
