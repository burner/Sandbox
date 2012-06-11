/* A simple server in the internet domain using TCP
   The port number is passed as an argument */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>

void error(const char *msg)
{
    perror(msg);
    exit(1);
}

int sockfd, newsockfd, portno;
socklen_t clilen;
struct sockaddr_in serv_addr, cli_addr;

void initSocket(unsigned short port) {
     sockfd = socket(AF_INET, SOCK_STREAM, 0);
     if (sockfd < 0) 
        error("ERROR opening socket");
     bzero((char *) &serv_addr, sizeof(serv_addr));
     portno = port;
     serv_addr.sin_family = AF_INET;
     serv_addr.sin_addr.s_addr = INADDR_ANY;
     serv_addr.sin_port = htons(portno);
     if (bind(sockfd, (struct sockaddr *) &serv_addr,
              sizeof(serv_addr)) < 0) 
              error("ERROR on binding");
     listen(sockfd,5);
     if (newsockfd < 0) 
          error("ERROR on accept");
}

int readSocket(void* buf, int bufSize) {
     int n;
     //bzero(buf,bufSize);
     clilen = sizeof(cli_addr);
     newsockfd = accept(sockfd, 
                 (struct sockaddr *) &cli_addr, 
                 &clilen);

     if (newsockfd < 0) 
          error("ERROR on accept");
     n = read(newsockfd,buf,bufSize);
     if (n < 0) error("ERROR reading from socket");
	 return n;
}

int writeSocket(void* buf, int bufSize) {
	int n = write(newsockfd,buf,bufSize);
	if (n < 0) {
		error("ERROR writing to socket");
	}
	return n;
}

void closeSocket() {
     close(newsockfd);
     close(sockfd);
}
