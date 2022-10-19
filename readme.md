Build and run image
```
docker build -t foodbar-server .
docker run -dp 2005:80 --link mongo:mongo --name foodbar-server foodbar-server
```