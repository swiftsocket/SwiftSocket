# a simple socket library for apple swift lang
# usage
> drag ysocket.c and ysocket.swift to your project
> just use apis in YSocket class

# api usage
## create client socket
``` swift
//create a socket connect to www.apple.com and port at 80
var client:TCPClient = TCPClient(addr: "www.apple.com", port: 80)
```
## connect with timeout
``` swift
var (success, errmsg) = client.connect(timeout: 10)
```

## send data
``` swift
var (success, errmsg) = client.send(str:"GET / HTTP/1.0\n\n")
//or you can send binnary data
//socket.send(data:[Int8])
```

## read data
``` swift
var data = client.read(1024*10) //return optional [Int8]
```

## close socket
``` swift
var (success, errormsg) = client.close()
```

## create servert socket

``` swift
var server:TCPServer = TCPServer(addr: "127.0.0.1", port: 8080)
```

## listen

``` swift
var (success, msg) = server.listen()
```
### accept
``` swift
var client = server.accept() //now you can use client socket api to read and write
```

# client socket example
``` swift
//创建socket
var client:TCPClient = TCPClient(addr: "www.apple.com", port: 80)
//连接
var (success, errmsg) = client.connect(timeout: 1)
if success {
    //发送数据
    var (success, errmsg) = client.send(str:"GET / HTTP/1.0\n\n" )
    if success {
        //读取数据
        var data = client.read(1024*10)
        if let d = data {
            if let str = String.stringWithBytes(d, length: d.count, encoding: NSUTF8StringEncoding){
                println(str)
            }
        }
    }else {
        println(errmsg)
    }
} else {
    println(errmsg)
}
```

# server socket example (echo server)
``` swift
func echoService(client c:TCPClient) {
    println("newclient from:\(c.addr)[\(c.port)]")
    var d = c.read(1024*10)
    c.send(data: d!)
    c.close()
}
func testserver(){
    var server:TCPServer = TCPServer(addr: "127.0.0.1", port: 8080)
    var (success, msg) = server.listen()
    if success {
        while true {
            if var client = server.accept() {
                echoService(client: client)
            } else {
                println("accept error")
            }
        }
    } else {
        println(msg)
    }
}
```

# Copyright and License
Code released under the BSD license.

# QQ group
275935304
