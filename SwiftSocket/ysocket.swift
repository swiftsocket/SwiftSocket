/*
* Copyright (c) 2014, 小p
* All rights reserved.
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of the University of California, Berkeley nor the
*       names of its contributors may be used to endorse or promote products
*       derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS" AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
//
//  ysocket.swift
//  SwiftSocket
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
    /*
     * connect to server
     * return success or fail with message
     */
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
    /*
    * close socket
    * return success or fail with message
    */
    func close()->(Bool,String){
        if let fd:Int32=self.fd{
            c_ysocket_close(fd)
            return (true,"close success")
        }else{
            return (false,"socket not open")
        }
    }
    /*
    * send data
    * return success or fail with message
    */
    func send(data d:[Int8])->(Bool,String){
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
    /*
    * send string
    * return success or fail with message
    */
    func send(str s:String)->(Bool,String){
        if let fd:Int32=self.fd{
            var sendsize:Int32=c_ysocket_send(fd, s, Int32(strlen(s)))
            if sendsize==Int32(strlen(s)){
                return (true,"send success")
            }else{
                return (false,"send error")
            }
        }else{
            return (false,"socket not open")
        }
    }
    /*
    * read data with expect length
    * return success or fail with message
    */
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