#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 

void error(const char *msg)
{
    perror(msg);
    exit(0);
}

int sockfd, portno, n;
struct sockaddr_in serv_addr;
struct hostent *server;

void initSocketForSending(char* address, unsigned short port) {
	printf("%s %u\n",address, port);
    portno = port;
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) 
        error("ERROR opening socket");
    server = gethostbyname(address);
    if(server == NULL) {
        fprintf(stderr,"ERROR, no such host\n");
        exit(0);
    }
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy((char *)server->h_addr, 
         (char *)&serv_addr.sin_addr.s_addr,
         server->h_length);
    serv_addr.sin_port = htons(portno);
    if (connect(sockfd,(struct sockaddr *) &serv_addr,sizeof(serv_addr)) < 0) {
        error("ERROR connecting");
	}
}

int writeSocketForSending(void* buffer, int bufferLen) {
    n = write(sockfd,buffer,bufferLen);
    if (n < 0)  {
         error("ERROR writing to socket");
	}
	return n;
}

int readSocketForSending(void* buffer, int bufferLen) {
    n = read(sockfd,(char*)buffer,bufferLen);
	printf("%p %d %d\n", buffer, bufferLen, n);
    if (n < 0) {
         error("ERROR reading from socket");
	}
    return n;
}

void closeSocketForSending() {
    close(sockfd);
}
