FROM node:current-alpine3.16

# Build server
RUN npm -g install static-server

# Put static contents
COPY /user_app/build/web ./web_user

# Run
CMD ["static-server", "-p", "80", "web_user"]