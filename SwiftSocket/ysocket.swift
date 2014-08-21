//
//  ysocket.swift
//  SwiftC
//
//  Created by pengyunchou on 14-8-21.
//  Copyright (c) 2014年 swift. All rights reserved.
//
import Foundation


@asmname("ysocket_connect") func c_ysocket_connect(host:ConstUnsafePointer<Int8>,port:Int32) -> Int32
@asmname("ysocket_close") func c_ysocket_close(fd:Int32) -> Int32
@asmname("ysocket_send") func c_ysocket_send(fd:Int32,ConstUnsafePointer<Int8>,len:Int32) -> Int32
@asmname("ysocket_pull") func c_ysocket_pull(fd:Int32,UnsafePointer<Int8>,len:Int32) -> Int32


class YSocket{
    var addr:String
    var port:Int
    var fd:Int32?
    init(){
        self.addr=""
        self.port=0
    }
    init(addr a:String,port p:Int){
        self.addr=a
        self.port=p
    }
    func connect()->(Bool,String){
        var rs:Int32=c_ysocket_connect(self.addr, Int32(self.port))
        if rs>0{
            self.fd=rs
            return (true,"connect success")
        }else{
            switch rs{
            case -1:
                return (false,"qeury server fail")
            case -2:
                return (false,"connection closed")
            case -3:
                return (false,"connect timeout")
            default:
                return (false,"unknow err.")
            }
        }
    }
    func close()->(Bool,String){
        if let fd:Int32=self.fd{
            c_ysocket_close(fd)
            return (true,"close success")
        }else{
            return (false,"socket not open")
        }
    }
    func send(data d:[CChar])->(Bool,String){
        if let fd:Int32=self.fd{
            var sendsize:Int32=c_ysocket_send(fd, d, Int32(d.count))
            if Int(sendsize)==d.count{
               return (true,"send success")
            }else{
                return (false,"send error")
            }
        }else{
            return (false,"socket not open")
        }
    }
    func send(str s:String)->(Bool,String){
        if let fd:Int32=self.fd{
            var sendsize:Int32=c_ysocket_send(fd, s, Int32(strlen(s)))
            if Int(sendsize)==Int(strlen(s)){
                return (true,"send success")
            }else{
                return (false,"send error")
            }
        }else{
            return (false,"socket not open")
        }
    }
    func read(expectlen:Int)->[Int8]?{
        if let fd:Int32 = self.fd{
            var buff:[Int8] = [Int8](count:expectlen,repeatedValue:0x0)
            var readLen:Int32=c_ysocket_pull(fd, &buff, Int32(expectlen))
            var rs=buff[0...Int(readLen)]
            return Array(rs)
        }
       return nil
    }
}