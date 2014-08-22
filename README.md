# a simple socket library for  apple swift lang
# uaage
> drag ysocket.c and ysocket.swift to your project
> just use apis in YSocket class

# api usage
## create client socket
``` swift
	//create a socket connect to google.com and port at 80
	var socket:YSocket = YSocket(addr: "www.google.com", port: 80)
```
## connect
``` swift
var (success,errmsg)=socket.connect()
```

## send data
``` swift
var (success,errmsg)=socket.send(str:"GET / HTTP/1.0\n\n" )
//or you can send binnary data
//socket.send(data:[Int8])
```

## read data
``` swift
var data=socket.read(1024*10) //return optional [Int8]
```

## close socket
``` swift
var (success,errormsg)=socket.close()
```

# example
``` swift
//创建socket
var socket:YSocket = YSocket(addr: "www.google.com", port: 80)
//连接
var (success,errmsg)=socket.connect()
if success{
    //发送数据
    var (success,errmsg)=socket.send(str:"GET / HTTP/1.0\n\n" )
    if success{
        //读取数据
        var data=socket.read(1024*10)
        if let d=data{
            if let str=String.stringWithUTF8String(d){
                println(str)
            }
        }
    }else{
        println(errmsg)
    }
}else{
    println(errmsg)
}
```