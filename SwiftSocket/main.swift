/*
Copyright (c) <2014>, skysent
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
3. All advertising materials mentioning features or use of this software
must display the following acknowledgement:
This product includes software developed by skysent.
4. Neither the name of the skysent nor the
names of its contributors may be used to endorse or promote products
derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY skysent ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL skysent BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
import Foundation
import Darwin.C
func testtcpclient(){
    //创建socket
    let client:TCPClient = TCPClient(address: "ixy.io", port: 80)
    //连接
    var (success,errmsg)=client.connect(timeout: 1)
    if success{
        //发送数据
        var (success,errmsg)=client.send(string: "GET / HTTP/1.0\n\n")
        if success{
            //读取数据
            let data=client.read(1024*10)
            if let d=data{
                if let str=String(bytes: d, encoding: String.Encoding.utf8){
                    print(str)
                }
            }
        }else{
            print(errmsg)
        }
    }else{
        print(errmsg)
    }
}
func echoService(client c:TCPClient){
    print("newclient from:\(c.address)[\(c.port)]")
    let d=c.read(1024*10)
    c.send(data: d!)
    c.close()
}
func testtcpserver(){
    let server:TCPServer = TCPServer(address: "127.0.0.1", port: 8080)
    var (success,msg)=server.listen()
    if success{
        while true{
            if let client=server.accept(){
                echoService(client: client)
            }else{
                print("accept error")
            }
        }
    }else{
        print(msg)
    }
}
//testclient()
func testudpserver() {
    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async(execute: { () -> Void in
        let server: UDPServer = UDPServer(address:"127.0.0.1",port:8080)
        let run = true
        while run{
            var (data,remoteip,remoteport)=server.recv(1024)
            print("recive")
            if let d=data{
                if let str=String(bytes: d, encoding: String.Encoding.utf8){
                    print(str)
                }
            }
            print(remoteip)
            server.close()
            break
        }
    })
}
func testudpclient(){
    let client = UDPClient(address: "localhost", port: 8080)
    print("send hello world")
    client.send(str: "hello world")
    client.close()
}
//testudpBroadcastclient()
func testudpBroadcastserver(){
    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async(execute: { () -> Void in
        //turn the server to broadcast mode with the address 255.255.255.255 or empty string
        let server = UDPServer(address:"",port:8080)
        let run = true
        print("server.started")
        while run {
            let (data,remoteip,remoteport) = server.recv(1024)
            print("recive\(remoteip);\(remoteport)")
            if let data = data {
                if let str = String(bytes: data, encoding: String.Encoding.utf8) {
                    print(str)
                }
            }
            print(remoteip)
        }
        print("server.close")
        server.close()
    })
}
func testudpBroadcastclient(){
    //wait a few second till server will ready
    sleep(2)
    print("Broadcastclient.send...")
    let clientB = UDPClient(address: "255.255.255.255", port: 8080)
    clientB.enableBroadcast()
    clientB.send(str: "test hello from broadcast")
    clientB.close()
}
//testudpserver()
//testudpclient()

testudpBroadcastserver()
testudpBroadcastclient()

var stdinput=FileHandle.standardInput
stdinput.readDataToEndOfFile()

