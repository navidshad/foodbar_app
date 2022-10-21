### links
- [Foodbar user website](http://ec2co-ecsel-1gp3cytj0gkr7-2119626231.us-east-1.elb.amazonaws.com/user)
- [Foodbar admin website](http://ec2co-ecsel-1gp3cytj0gkr7-2119626231.us-east-1.elb.amazonaws.com/admin)
### Build and run image
```
docker build -t foodbar-server .
docker run -dp 2005:80 --link mongo:mongo --name foodbar-server foodbar-server
```

Flutter version: `2.7.0-3.0.pre`
