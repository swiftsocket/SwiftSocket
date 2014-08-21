//
//  main.swift
//  SwiftC
//
//  Created by pengyunchou on 14-8-19.
//  Copyright (c) 2014年 swift. All rights reserved.
//
var socket:YSocket = YSocket(addr: "www.google.com", port: 80)
socket.connect()
socket.send(str: "GET / HTTP/1.0\n\n")
var data=socket.read(1024*10)
if let d=data{
    if let str=String.stringWithUTF8String(d){
        println(str)
    }
}
