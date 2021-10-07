
format PE GUI 4.0
entry start

;include 'win32a.inc'
include "include/win32a.inc"

include 'riched32.inc'

section '.text' code readable executable

  start:	
	invoke	WSAStartup,0101h,wsadata
	
	invoke inet_addr, ip_address ;IP 192.168.8.100
	mov	[saddr.sin_addr],eax
	mov	[saddr.sin_family],PF_INET

	mov eax, [port] ; Puerto 4444
	xchg	ah,al
	mov	[saddr.sin_port],ax
	
	invoke	socket,AF_INET,SOCK_STREAM,0
	mov	[sock],eax
	invoke	connect,[sock],saddr,sizeof.sockaddr_in
	
	mov eax, 12d
	invoke	send,[sock],buffer,eax,0

	invoke	closesocket,[sock]

section '.data' data readable writeable

  ip_address db "192.168.8.100", 0
  port dd 4444d
  
  sock dd ?
  buffer db "Hola Mundo",13,10,0
  
  wsadata WSADATA
  saddr sockaddr_in

section '.idata' import data readable writeable

  library kernel,'KERNEL32.DLL',\
	  user,'USER32.DLL',\
	  comctl,'COMCTL32.DLL',\
	  winsock,'WSOCK32.DLL'

  import kernel,\
	 GetModuleHandle,'GetModuleHandleA',\
	 LoadLibrary,'LoadLibraryA',\
	 ExitProcess,'ExitProcess'

  import winsock,\
	 WSAStartup,'WSAStartup',\
	 WSACleanup,'WSACleanup',\
	 WSAAsyncSelect,'WSAAsyncSelect',\
	 gethostbyname,'gethostbyname',\
	 socket,'socket',\
	 bind,'bind',\
	 listen,'listen',\
	 accept,'accept',\
	 connect,'connect',\
	 recv,'recv',\
	 send,'send',\
	 inet_addr, 'inet_addr',\
	 closesocket,'closesocket'
