//
//  Copyright (c) <2014>, skysent
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  3. All advertising materials mentioning features or use of this software
//  must display the following acknowledgement:
//  This product includes software developed by skysent.
//  4. Neither the name of the skysent nor the
//  names of its contributors may be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY skysent ''AS IS'' AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL skysent BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

import Foundation

@_silgen_name("ytcpsocket_listen") private func c_ytcpsocket_listen(_ address:UnsafePointer<Int8>,port:Int32)->Int32
@_silgen_name("ytcpsocket_accept") private func c_ytcpsocket_accept(_ onsocketfd:Int32,ip:UnsafePointer<Int8>,port:UnsafePointer<Int32>) -> Int32
@_silgen_name("ytcpsocket_port") private func c_ytcpsocket_port(_ fd:Int32) -> Int32
@_silgen_name("ytcpsocket_close") private func c_ytcpsocket_close(_ fd:Int32) -> Int32

open class TCPServer: Socket {

    open func listen() -> Result {
        let fd = c_ytcpsocket_listen(self.address, port: Int32(self.port))
        if fd > 0 {
            self.fd = fd
            
            // If port 0 is used, get the actual port number which the server is listening to
            if (self.port == 0) {
                let p = c_ytcpsocket_port(fd)
                if (p == -1) {
                    return .failure(SocketError.unknownError)
                } else {
                    self.port = p
                }
            }
            
            return .success
        } else {
            return .failure(SocketError.unknownError)
        }
    }
    
    open func accept() -> TCPClient? {
        guard let serferfd = self.fd else { return nil }
        
        var buff: [Int8] = [Int8](repeating: 0x0,count: 16)
        var port: Int32 = 0
        let clientfd: Int32 = c_ytcpsocket_accept(serferfd, ip: &buff, port: &port)
        
        guard clientfd >= 0 else { return nil }
        guard let address = String(cString: buff, encoding: String.Encoding.utf8) else { return nil }
        
        let client = TCPClient(address: address, port: port)
        client.fd = clientfd
            
        return client
    }
    
    open func close() {
        guard let fd: Int32=self.fd else { return }
      
        _ = c_ytcpsocket_close(fd)
        self.fd = nil
    }
}
