FROM node:current-alpine3.16

# Build server
WORKDIR /app
COPY /server/package.json .
RUN yarn install
RUN yarn global add pm2

COPY ["/server/app.js", "/server/config.js", "/server/data_insertion.js", "/server/middlewares.js", "./"]
COPY ecosystem.config.js ecosystem.config.js
COPY /server/class ./class
COPY /server/services ./services

# Put static contents
COPY /admin_app/build/web ./web_admin
COPY /user_app/build/web ./web_user

# Run
WORKDIR /app
CMD ["pm2-runtime", "ecosystem.config.js"]
EXPOSE 80 1001 1002