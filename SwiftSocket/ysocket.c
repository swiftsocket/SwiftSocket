//
//  ysocket.cpp
//  GQYDataManager
//
//  Created by pengyunchou on 14-7-20.
//  Copyright (c) 2014年 skysent. All rights reserved.
//
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <dirent.h>
#include <netdb.h>
#include <unistd.h>
#include <fcntl.h>
#include <signal.h>
static void signal_function(int signal) {
    fprintf(stderr, "%s=>singnal:%d\n",__FUNCTION__,signal);
}
void socket_set_block(int socket,int on) {
    int flags;
    flags = fcntl(socket,F_GETFL,0);
    if (on==0) {
        fcntl(socket, F_SETFL, flags | O_NONBLOCK);
    }else{
        flags &= ~ O_NONBLOCK;
        fcntl(socket, F_SETFL, flags);
    }
}
int ysocket_connect(const char *host,int port){
    signal(SIGPIPE, signal_function);
    struct sockaddr_in sa;
    struct hostent *hp;
    int sockfd = -1;
    hp = gethostbyname(host);
    if(hp==NULL){
        return -1;
    }
    bcopy((char *)hp->h_addr, (char *)&sa.sin_addr, hp->h_length);
    sa.sin_family = hp->h_addrtype;
    sa.sin_port = htons(port);
    sockfd = socket(hp->h_addrtype, SOCK_STREAM, 0);
    socket_set_block(sockfd,0);
    connect(sockfd, (struct sockaddr *)&sa, sizeof(sa));
    fd_set          fdwrite;
    struct timeval  tvSelect;
    FD_ZERO(&fdwrite);
    FD_SET(sockfd, &fdwrite);
    tvSelect.tv_sec = 15;
    tvSelect.tv_usec = 0;
    int retval = select(sockfd + 1,NULL, &fdwrite, NULL, &tvSelect);
    if (retval<0) {
        return -2;
    }else if(retval==0){//timeout
        return -3;
    }else{
        socket_set_block(sockfd, 1);
        int set = 1;
        setsockopt(sockfd, SOL_SOCKET, SO_NOSIGPIPE, (void *)&set, sizeof(int));
        return sockfd;
    }
}
int ysocket_close(int socketfd){
    return close(socketfd);
}
int ysocket_pull(int socketfd,char *data,int len){
    return (int)read(socketfd,data,len);
}
int ysocket_send(int socketfd,const char *data,int len){
    int byteswrite=0;
    while (len-byteswrite>0) {
        int writelen=(int)write(socketfd, data+byteswrite, len-byteswrite);
        if (writelen<0) {
            return -1;
        }
        byteswrite+=writelen;
    }
    return 0;
}