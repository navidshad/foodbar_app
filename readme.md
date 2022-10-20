### links
- [Foodbar user website](http://ec2co-ecsel-1op6zyha6a2pa-1320295553.us-east-1.elb.amazonaws.com/)
- [Foodbar admin website](http://ec2co-ecsel-1op6zyha6a2pa-1320295553.us-east-1.elb.amazonaws.com/admin)
### Build and run image
```
docker build -t foodbar-server .
docker run -dp 2005:80 --link mongo:mongo --name foodbar-server foodbar-server
```

Flutter version: `2.7.0-3.0.pre`