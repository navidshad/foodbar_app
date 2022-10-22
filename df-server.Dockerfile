FROM node:current-alpine3.16

# Build server
WORKDIR /app
COPY /server/package.json .
RUN yarn install

COPY ["/server/app.js", "/server/config.js", "/server/data_insertion.js", "/server/middlewares.js", "./"]
COPY /server/class ./class
COPY /server/services ./services

# Run
WORKDIR /app
CMD ["node", "app.js"]