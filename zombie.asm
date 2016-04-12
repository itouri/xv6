
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 42 02 00 00       	call   258 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 cc 02 00 00       	call   2f0 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 34 02 00 00       	call   260 <exit>

0000002c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld    
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4d:	5b                   	pop    %ebx
  4e:	5f                   	pop    %edi
  4f:	c9                   	leave  
  50:	c3                   	ret    

00000051 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  51:	55                   	push   %ebp
  52:	89 e5                	mov    %esp,%ebp
  54:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  57:	8b 45 08             	mov    0x8(%ebp),%eax
  5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5d:	90                   	nop
  5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  61:	8a 10                	mov    (%eax),%dl
  63:	8b 45 08             	mov    0x8(%ebp),%eax
  66:	88 10                	mov    %dl,(%eax)
  68:	8b 45 08             	mov    0x8(%ebp),%eax
  6b:	8a 00                	mov    (%eax),%al
  6d:	84 c0                	test   %al,%al
  6f:	0f 95 c0             	setne  %al
  72:	ff 45 08             	incl   0x8(%ebp)
  75:	ff 45 0c             	incl   0xc(%ebp)
  78:	84 c0                	test   %al,%al
  7a:	75 e2                	jne    5e <strcpy+0xd>
    ;
  return os;
  7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7f:	c9                   	leave  
  80:	c3                   	ret    

00000081 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  81:	55                   	push   %ebp
  82:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  84:	eb 06                	jmp    8c <strcmp+0xb>
    p++, q++;
  86:	ff 45 08             	incl   0x8(%ebp)
  89:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8c:	8b 45 08             	mov    0x8(%ebp),%eax
  8f:	8a 00                	mov    (%eax),%al
  91:	84 c0                	test   %al,%al
  93:	74 0e                	je     a3 <strcmp+0x22>
  95:	8b 45 08             	mov    0x8(%ebp),%eax
  98:	8a 10                	mov    (%eax),%dl
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	8a 00                	mov    (%eax),%al
  9f:	38 c2                	cmp    %al,%dl
  a1:	74 e3                	je     86 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a3:	8b 45 08             	mov    0x8(%ebp),%eax
  a6:	8a 00                	mov    (%eax),%al
  a8:	0f b6 d0             	movzbl %al,%edx
  ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  ae:	8a 00                	mov    (%eax),%al
  b0:	0f b6 c0             	movzbl %al,%eax
  b3:	89 d1                	mov    %edx,%ecx
  b5:	29 c1                	sub    %eax,%ecx
  b7:	89 c8                	mov    %ecx,%eax
}
  b9:	c9                   	leave  
  ba:	c3                   	ret    

000000bb <strlen>:

uint
strlen(char *s)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  be:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c8:	eb 03                	jmp    cd <strlen+0x12>
  ca:	ff 45 fc             	incl   -0x4(%ebp)
  cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  d0:	03 45 08             	add    0x8(%ebp),%eax
  d3:	8a 00                	mov    (%eax),%al
  d5:	84 c0                	test   %al,%al
  d7:	75 f1                	jne    ca <strlen+0xf>
    ;
  return n;
  d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  dc:	c9                   	leave  
  dd:	c3                   	ret    

000000de <memset>:

void*
memset(void *dst, int c, uint n)
{
  de:	55                   	push   %ebp
  df:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  e1:	8b 45 10             	mov    0x10(%ebp),%eax
  e4:	50                   	push   %eax
  e5:	ff 75 0c             	pushl  0xc(%ebp)
  e8:	ff 75 08             	pushl  0x8(%ebp)
  eb:	e8 3c ff ff ff       	call   2c <stosb>
  f0:	83 c4 0c             	add    $0xc,%esp
  return dst;
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  f6:	c9                   	leave  
  f7:	c3                   	ret    

000000f8 <strchr>:

char*
strchr(const char *s, char c)
{
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	83 ec 04             	sub    $0x4,%esp
  fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 101:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 104:	eb 12                	jmp    118 <strchr+0x20>
    if(*s == c)
 106:	8b 45 08             	mov    0x8(%ebp),%eax
 109:	8a 00                	mov    (%eax),%al
 10b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 10e:	75 05                	jne    115 <strchr+0x1d>
      return (char*)s;
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	eb 11                	jmp    126 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 115:	ff 45 08             	incl   0x8(%ebp)
 118:	8b 45 08             	mov    0x8(%ebp),%eax
 11b:	8a 00                	mov    (%eax),%al
 11d:	84 c0                	test   %al,%al
 11f:	75 e5                	jne    106 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 121:	b8 00 00 00 00       	mov    $0x0,%eax
}
 126:	c9                   	leave  
 127:	c3                   	ret    

00000128 <gets>:

char*
gets(char *buf, int max)
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 135:	eb 38                	jmp    16f <gets+0x47>
    cc = read(0, &c, 1);
 137:	83 ec 04             	sub    $0x4,%esp
 13a:	6a 01                	push   $0x1
 13c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 13f:	50                   	push   %eax
 140:	6a 00                	push   $0x0
 142:	e8 31 01 00 00       	call   278 <read>
 147:	83 c4 10             	add    $0x10,%esp
 14a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 14d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 151:	7e 27                	jle    17a <gets+0x52>
      break;
    buf[i++] = c;
 153:	8b 45 f4             	mov    -0xc(%ebp),%eax
 156:	03 45 08             	add    0x8(%ebp),%eax
 159:	8a 55 ef             	mov    -0x11(%ebp),%dl
 15c:	88 10                	mov    %dl,(%eax)
 15e:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 161:	8a 45 ef             	mov    -0x11(%ebp),%al
 164:	3c 0a                	cmp    $0xa,%al
 166:	74 13                	je     17b <gets+0x53>
 168:	8a 45 ef             	mov    -0x11(%ebp),%al
 16b:	3c 0d                	cmp    $0xd,%al
 16d:	74 0c                	je     17b <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 172:	40                   	inc    %eax
 173:	3b 45 0c             	cmp    0xc(%ebp),%eax
 176:	7c bf                	jl     137 <gets+0xf>
 178:	eb 01                	jmp    17b <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 17a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 17b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17e:	03 45 08             	add    0x8(%ebp),%eax
 181:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 184:	8b 45 08             	mov    0x8(%ebp),%eax
}
 187:	c9                   	leave  
 188:	c3                   	ret    

00000189 <stat>:

int
stat(char *n, struct stat *st)
{
 189:	55                   	push   %ebp
 18a:	89 e5                	mov    %esp,%ebp
 18c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18f:	83 ec 08             	sub    $0x8,%esp
 192:	6a 00                	push   $0x0
 194:	ff 75 08             	pushl  0x8(%ebp)
 197:	e8 04 01 00 00       	call   2a0 <open>
 19c:	83 c4 10             	add    $0x10,%esp
 19f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1a6:	79 07                	jns    1af <stat+0x26>
    return -1;
 1a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1ad:	eb 25                	jmp    1d4 <stat+0x4b>
  r = fstat(fd, st);
 1af:	83 ec 08             	sub    $0x8,%esp
 1b2:	ff 75 0c             	pushl  0xc(%ebp)
 1b5:	ff 75 f4             	pushl  -0xc(%ebp)
 1b8:	e8 fb 00 00 00       	call   2b8 <fstat>
 1bd:	83 c4 10             	add    $0x10,%esp
 1c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1c3:	83 ec 0c             	sub    $0xc,%esp
 1c6:	ff 75 f4             	pushl  -0xc(%ebp)
 1c9:	e8 ba 00 00 00       	call   288 <close>
 1ce:	83 c4 10             	add    $0x10,%esp
  return r;
 1d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1d4:	c9                   	leave  
 1d5:	c3                   	ret    

000001d6 <atoi>:

int
atoi(const char *s)
{
 1d6:	55                   	push   %ebp
 1d7:	89 e5                	mov    %esp,%ebp
 1d9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1e3:	eb 22                	jmp    207 <atoi+0x31>
    n = n*10 + *s++ - '0';
 1e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1e8:	89 d0                	mov    %edx,%eax
 1ea:	c1 e0 02             	shl    $0x2,%eax
 1ed:	01 d0                	add    %edx,%eax
 1ef:	d1 e0                	shl    %eax
 1f1:	89 c2                	mov    %eax,%edx
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	8a 00                	mov    (%eax),%al
 1f8:	0f be c0             	movsbl %al,%eax
 1fb:	8d 04 02             	lea    (%edx,%eax,1),%eax
 1fe:	83 e8 30             	sub    $0x30,%eax
 201:	89 45 fc             	mov    %eax,-0x4(%ebp)
 204:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	8a 00                	mov    (%eax),%al
 20c:	3c 2f                	cmp    $0x2f,%al
 20e:	7e 09                	jle    219 <atoi+0x43>
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	8a 00                	mov    (%eax),%al
 215:	3c 39                	cmp    $0x39,%al
 217:	7e cc                	jle    1e5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 219:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 21c:	c9                   	leave  
 21d:	c3                   	ret    

0000021e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
 221:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 22a:	8b 45 0c             	mov    0xc(%ebp),%eax
 22d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 230:	eb 10                	jmp    242 <memmove+0x24>
    *dst++ = *src++;
 232:	8b 45 f8             	mov    -0x8(%ebp),%eax
 235:	8a 10                	mov    (%eax),%dl
 237:	8b 45 fc             	mov    -0x4(%ebp),%eax
 23a:	88 10                	mov    %dl,(%eax)
 23c:	ff 45 fc             	incl   -0x4(%ebp)
 23f:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 242:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 246:	0f 9f c0             	setg   %al
 249:	ff 4d 10             	decl   0x10(%ebp)
 24c:	84 c0                	test   %al,%al
 24e:	75 e2                	jne    232 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 250:	8b 45 08             	mov    0x8(%ebp),%eax
}
 253:	c9                   	leave  
 254:	c3                   	ret    
 255:	90                   	nop
 256:	90                   	nop
 257:	90                   	nop

00000258 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 258:	b8 01 00 00 00       	mov    $0x1,%eax
 25d:	cd 40                	int    $0x40
 25f:	c3                   	ret    

00000260 <exit>:
SYSCALL(exit)
 260:	b8 02 00 00 00       	mov    $0x2,%eax
 265:	cd 40                	int    $0x40
 267:	c3                   	ret    

00000268 <wait>:
SYSCALL(wait)
 268:	b8 03 00 00 00       	mov    $0x3,%eax
 26d:	cd 40                	int    $0x40
 26f:	c3                   	ret    

00000270 <pipe>:
SYSCALL(pipe)
 270:	b8 04 00 00 00       	mov    $0x4,%eax
 275:	cd 40                	int    $0x40
 277:	c3                   	ret    

00000278 <read>:
SYSCALL(read)
 278:	b8 05 00 00 00       	mov    $0x5,%eax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret    

00000280 <write>:
SYSCALL(write)
 280:	b8 10 00 00 00       	mov    $0x10,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <close>:
SYSCALL(close)
 288:	b8 15 00 00 00       	mov    $0x15,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <kill>:
SYSCALL(kill)
 290:	b8 06 00 00 00       	mov    $0x6,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <exec>:
SYSCALL(exec)
 298:	b8 07 00 00 00       	mov    $0x7,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <open>:
SYSCALL(open)
 2a0:	b8 0f 00 00 00       	mov    $0xf,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <mknod>:
SYSCALL(mknod)
 2a8:	b8 11 00 00 00       	mov    $0x11,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <unlink>:
SYSCALL(unlink)
 2b0:	b8 12 00 00 00       	mov    $0x12,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <fstat>:
SYSCALL(fstat)
 2b8:	b8 08 00 00 00       	mov    $0x8,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <link>:
SYSCALL(link)
 2c0:	b8 13 00 00 00       	mov    $0x13,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <mkdir>:
SYSCALL(mkdir)
 2c8:	b8 14 00 00 00       	mov    $0x14,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <chdir>:
SYSCALL(chdir)
 2d0:	b8 09 00 00 00       	mov    $0x9,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <dup>:
SYSCALL(dup)
 2d8:	b8 0a 00 00 00       	mov    $0xa,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <getpid>:
SYSCALL(getpid)
 2e0:	b8 0b 00 00 00       	mov    $0xb,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <sbrk>:
SYSCALL(sbrk)
 2e8:	b8 0c 00 00 00       	mov    $0xc,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <sleep>:
SYSCALL(sleep)
 2f0:	b8 0d 00 00 00       	mov    $0xd,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <uptime>:
SYSCALL(uptime)
 2f8:	b8 0e 00 00 00       	mov    $0xe,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	83 ec 18             	sub    $0x18,%esp
 306:	8b 45 0c             	mov    0xc(%ebp),%eax
 309:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 30c:	83 ec 04             	sub    $0x4,%esp
 30f:	6a 01                	push   $0x1
 311:	8d 45 f4             	lea    -0xc(%ebp),%eax
 314:	50                   	push   %eax
 315:	ff 75 08             	pushl  0x8(%ebp)
 318:	e8 63 ff ff ff       	call   280 <write>
 31d:	83 c4 10             	add    $0x10,%esp
}
 320:	c9                   	leave  
 321:	c3                   	ret    

00000322 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 322:	55                   	push   %ebp
 323:	89 e5                	mov    %esp,%ebp
 325:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 328:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 32f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 333:	74 17                	je     34c <printint+0x2a>
 335:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 339:	79 11                	jns    34c <printint+0x2a>
    neg = 1;
 33b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 342:	8b 45 0c             	mov    0xc(%ebp),%eax
 345:	f7 d8                	neg    %eax
 347:	89 45 ec             	mov    %eax,-0x14(%ebp)
 34a:	eb 06                	jmp    352 <printint+0x30>
  } else {
    x = xx;
 34c:	8b 45 0c             	mov    0xc(%ebp),%eax
 34f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 352:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 359:	8b 4d 10             	mov    0x10(%ebp),%ecx
 35c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 35f:	ba 00 00 00 00       	mov    $0x0,%edx
 364:	f7 f1                	div    %ecx
 366:	89 d0                	mov    %edx,%eax
 368:	8a 90 80 07 00 00    	mov    0x780(%eax),%dl
 36e:	8d 45 dc             	lea    -0x24(%ebp),%eax
 371:	03 45 f4             	add    -0xc(%ebp),%eax
 374:	88 10                	mov    %dl,(%eax)
 376:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 379:	8b 45 10             	mov    0x10(%ebp),%eax
 37c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 37f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 382:	ba 00 00 00 00       	mov    $0x0,%edx
 387:	f7 75 d4             	divl   -0x2c(%ebp)
 38a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 38d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 391:	75 c6                	jne    359 <printint+0x37>
  if(neg)
 393:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 397:	74 2a                	je     3c3 <printint+0xa1>
    buf[i++] = '-';
 399:	8d 45 dc             	lea    -0x24(%ebp),%eax
 39c:	03 45 f4             	add    -0xc(%ebp),%eax
 39f:	c6 00 2d             	movb   $0x2d,(%eax)
 3a2:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 3a5:	eb 1d                	jmp    3c4 <printint+0xa2>
    putc(fd, buf[i]);
 3a7:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3aa:	03 45 f4             	add    -0xc(%ebp),%eax
 3ad:	8a 00                	mov    (%eax),%al
 3af:	0f be c0             	movsbl %al,%eax
 3b2:	83 ec 08             	sub    $0x8,%esp
 3b5:	50                   	push   %eax
 3b6:	ff 75 08             	pushl  0x8(%ebp)
 3b9:	e8 42 ff ff ff       	call   300 <putc>
 3be:	83 c4 10             	add    $0x10,%esp
 3c1:	eb 01                	jmp    3c4 <printint+0xa2>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3c3:	90                   	nop
 3c4:	ff 4d f4             	decl   -0xc(%ebp)
 3c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3cb:	79 da                	jns    3a7 <printint+0x85>
    putc(fd, buf[i]);
}
 3cd:	c9                   	leave  
 3ce:	c3                   	ret    

000003cf <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
 3d2:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 3d5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 3dc:	8d 45 0c             	lea    0xc(%ebp),%eax
 3df:	83 c0 04             	add    $0x4,%eax
 3e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 3e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 3ec:	e9 58 01 00 00       	jmp    549 <printf+0x17a>
    c = fmt[i] & 0xff;
 3f1:	8b 55 0c             	mov    0xc(%ebp),%edx
 3f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3f7:	8d 04 02             	lea    (%edx,%eax,1),%eax
 3fa:	8a 00                	mov    (%eax),%al
 3fc:	0f be c0             	movsbl %al,%eax
 3ff:	25 ff 00 00 00       	and    $0xff,%eax
 404:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 407:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 40b:	75 2c                	jne    439 <printf+0x6a>
      if(c == '%'){
 40d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 411:	75 0c                	jne    41f <printf+0x50>
        state = '%';
 413:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 41a:	e9 27 01 00 00       	jmp    546 <printf+0x177>
      } else {
        putc(fd, c);
 41f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 422:	0f be c0             	movsbl %al,%eax
 425:	83 ec 08             	sub    $0x8,%esp
 428:	50                   	push   %eax
 429:	ff 75 08             	pushl  0x8(%ebp)
 42c:	e8 cf fe ff ff       	call   300 <putc>
 431:	83 c4 10             	add    $0x10,%esp
 434:	e9 0d 01 00 00       	jmp    546 <printf+0x177>
      }
    } else if(state == '%'){
 439:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 43d:	0f 85 03 01 00 00    	jne    546 <printf+0x177>
      if(c == 'd'){
 443:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 447:	75 1e                	jne    467 <printf+0x98>
        printint(fd, *ap, 10, 1);
 449:	8b 45 e8             	mov    -0x18(%ebp),%eax
 44c:	8b 00                	mov    (%eax),%eax
 44e:	6a 01                	push   $0x1
 450:	6a 0a                	push   $0xa
 452:	50                   	push   %eax
 453:	ff 75 08             	pushl  0x8(%ebp)
 456:	e8 c7 fe ff ff       	call   322 <printint>
 45b:	83 c4 10             	add    $0x10,%esp
        ap++;
 45e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 462:	e9 d8 00 00 00       	jmp    53f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 467:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 46b:	74 06                	je     473 <printf+0xa4>
 46d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 471:	75 1e                	jne    491 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 473:	8b 45 e8             	mov    -0x18(%ebp),%eax
 476:	8b 00                	mov    (%eax),%eax
 478:	6a 00                	push   $0x0
 47a:	6a 10                	push   $0x10
 47c:	50                   	push   %eax
 47d:	ff 75 08             	pushl  0x8(%ebp)
 480:	e8 9d fe ff ff       	call   322 <printint>
 485:	83 c4 10             	add    $0x10,%esp
        ap++;
 488:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 48c:	e9 ae 00 00 00       	jmp    53f <printf+0x170>
      } else if(c == 's'){
 491:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 495:	75 43                	jne    4da <printf+0x10b>
        s = (char*)*ap;
 497:	8b 45 e8             	mov    -0x18(%ebp),%eax
 49a:	8b 00                	mov    (%eax),%eax
 49c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 49f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4a7:	75 25                	jne    4ce <printf+0xff>
          s = "(null)";
 4a9:	c7 45 f4 78 07 00 00 	movl   $0x778,-0xc(%ebp)
        while(*s != 0){
 4b0:	eb 1d                	jmp    4cf <printf+0x100>
          putc(fd, *s);
 4b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b5:	8a 00                	mov    (%eax),%al
 4b7:	0f be c0             	movsbl %al,%eax
 4ba:	83 ec 08             	sub    $0x8,%esp
 4bd:	50                   	push   %eax
 4be:	ff 75 08             	pushl  0x8(%ebp)
 4c1:	e8 3a fe ff ff       	call   300 <putc>
 4c6:	83 c4 10             	add    $0x10,%esp
          s++;
 4c9:	ff 45 f4             	incl   -0xc(%ebp)
 4cc:	eb 01                	jmp    4cf <printf+0x100>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4ce:	90                   	nop
 4cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d2:	8a 00                	mov    (%eax),%al
 4d4:	84 c0                	test   %al,%al
 4d6:	75 da                	jne    4b2 <printf+0xe3>
 4d8:	eb 65                	jmp    53f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4da:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 4de:	75 1d                	jne    4fd <printf+0x12e>
        putc(fd, *ap);
 4e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e3:	8b 00                	mov    (%eax),%eax
 4e5:	0f be c0             	movsbl %al,%eax
 4e8:	83 ec 08             	sub    $0x8,%esp
 4eb:	50                   	push   %eax
 4ec:	ff 75 08             	pushl  0x8(%ebp)
 4ef:	e8 0c fe ff ff       	call   300 <putc>
 4f4:	83 c4 10             	add    $0x10,%esp
        ap++;
 4f7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4fb:	eb 42                	jmp    53f <printf+0x170>
      } else if(c == '%'){
 4fd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 501:	75 17                	jne    51a <printf+0x14b>
        putc(fd, c);
 503:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 506:	0f be c0             	movsbl %al,%eax
 509:	83 ec 08             	sub    $0x8,%esp
 50c:	50                   	push   %eax
 50d:	ff 75 08             	pushl  0x8(%ebp)
 510:	e8 eb fd ff ff       	call   300 <putc>
 515:	83 c4 10             	add    $0x10,%esp
 518:	eb 25                	jmp    53f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 51a:	83 ec 08             	sub    $0x8,%esp
 51d:	6a 25                	push   $0x25
 51f:	ff 75 08             	pushl  0x8(%ebp)
 522:	e8 d9 fd ff ff       	call   300 <putc>
 527:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 52a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 52d:	0f be c0             	movsbl %al,%eax
 530:	83 ec 08             	sub    $0x8,%esp
 533:	50                   	push   %eax
 534:	ff 75 08             	pushl  0x8(%ebp)
 537:	e8 c4 fd ff ff       	call   300 <putc>
 53c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 53f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 546:	ff 45 f0             	incl   -0x10(%ebp)
 549:	8b 55 0c             	mov    0xc(%ebp),%edx
 54c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 54f:	8d 04 02             	lea    (%edx,%eax,1),%eax
 552:	8a 00                	mov    (%eax),%al
 554:	84 c0                	test   %al,%al
 556:	0f 85 95 fe ff ff    	jne    3f1 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 55c:	c9                   	leave  
 55d:	c3                   	ret    
 55e:	90                   	nop
 55f:	90                   	nop

00000560 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 566:	8b 45 08             	mov    0x8(%ebp),%eax
 569:	83 e8 08             	sub    $0x8,%eax
 56c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 56f:	a1 9c 07 00 00       	mov    0x79c,%eax
 574:	89 45 fc             	mov    %eax,-0x4(%ebp)
 577:	eb 24                	jmp    59d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 579:	8b 45 fc             	mov    -0x4(%ebp),%eax
 57c:	8b 00                	mov    (%eax),%eax
 57e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 581:	77 12                	ja     595 <free+0x35>
 583:	8b 45 f8             	mov    -0x8(%ebp),%eax
 586:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 589:	77 24                	ja     5af <free+0x4f>
 58b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 58e:	8b 00                	mov    (%eax),%eax
 590:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 593:	77 1a                	ja     5af <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 595:	8b 45 fc             	mov    -0x4(%ebp),%eax
 598:	8b 00                	mov    (%eax),%eax
 59a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 59d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5a0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5a3:	76 d4                	jbe    579 <free+0x19>
 5a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5a8:	8b 00                	mov    (%eax),%eax
 5aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5ad:	76 ca                	jbe    579 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5b2:	8b 40 04             	mov    0x4(%eax),%eax
 5b5:	c1 e0 03             	shl    $0x3,%eax
 5b8:	89 c2                	mov    %eax,%edx
 5ba:	03 55 f8             	add    -0x8(%ebp),%edx
 5bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5c0:	8b 00                	mov    (%eax),%eax
 5c2:	39 c2                	cmp    %eax,%edx
 5c4:	75 24                	jne    5ea <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 5c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5c9:	8b 50 04             	mov    0x4(%eax),%edx
 5cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5cf:	8b 00                	mov    (%eax),%eax
 5d1:	8b 40 04             	mov    0x4(%eax),%eax
 5d4:	01 c2                	add    %eax,%edx
 5d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5d9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 5dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5df:	8b 00                	mov    (%eax),%eax
 5e1:	8b 10                	mov    (%eax),%edx
 5e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e6:	89 10                	mov    %edx,(%eax)
 5e8:	eb 0a                	jmp    5f4 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 5ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ed:	8b 10                	mov    (%eax),%edx
 5ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 5f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f7:	8b 40 04             	mov    0x4(%eax),%eax
 5fa:	c1 e0 03             	shl    $0x3,%eax
 5fd:	03 45 fc             	add    -0x4(%ebp),%eax
 600:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 603:	75 20                	jne    625 <free+0xc5>
    p->s.size += bp->s.size;
 605:	8b 45 fc             	mov    -0x4(%ebp),%eax
 608:	8b 50 04             	mov    0x4(%eax),%edx
 60b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60e:	8b 40 04             	mov    0x4(%eax),%eax
 611:	01 c2                	add    %eax,%edx
 613:	8b 45 fc             	mov    -0x4(%ebp),%eax
 616:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 619:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61c:	8b 10                	mov    (%eax),%edx
 61e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 621:	89 10                	mov    %edx,(%eax)
 623:	eb 08                	jmp    62d <free+0xcd>
  } else
    p->s.ptr = bp;
 625:	8b 45 fc             	mov    -0x4(%ebp),%eax
 628:	8b 55 f8             	mov    -0x8(%ebp),%edx
 62b:	89 10                	mov    %edx,(%eax)
  freep = p;
 62d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 630:	a3 9c 07 00 00       	mov    %eax,0x79c
}
 635:	c9                   	leave  
 636:	c3                   	ret    

00000637 <morecore>:

static Header*
morecore(uint nu)
{
 637:	55                   	push   %ebp
 638:	89 e5                	mov    %esp,%ebp
 63a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 63d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 644:	77 07                	ja     64d <morecore+0x16>
    nu = 4096;
 646:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 64d:	8b 45 08             	mov    0x8(%ebp),%eax
 650:	c1 e0 03             	shl    $0x3,%eax
 653:	83 ec 0c             	sub    $0xc,%esp
 656:	50                   	push   %eax
 657:	e8 8c fc ff ff       	call   2e8 <sbrk>
 65c:	83 c4 10             	add    $0x10,%esp
 65f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 662:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 666:	75 07                	jne    66f <morecore+0x38>
    return 0;
 668:	b8 00 00 00 00       	mov    $0x0,%eax
 66d:	eb 26                	jmp    695 <morecore+0x5e>
  hp = (Header*)p;
 66f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 672:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 675:	8b 45 f0             	mov    -0x10(%ebp),%eax
 678:	8b 55 08             	mov    0x8(%ebp),%edx
 67b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 67e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 681:	83 c0 08             	add    $0x8,%eax
 684:	83 ec 0c             	sub    $0xc,%esp
 687:	50                   	push   %eax
 688:	e8 d3 fe ff ff       	call   560 <free>
 68d:	83 c4 10             	add    $0x10,%esp
  return freep;
 690:	a1 9c 07 00 00       	mov    0x79c,%eax
}
 695:	c9                   	leave  
 696:	c3                   	ret    

00000697 <malloc>:

void*
malloc(uint nbytes)
{
 697:	55                   	push   %ebp
 698:	89 e5                	mov    %esp,%ebp
 69a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 69d:	8b 45 08             	mov    0x8(%ebp),%eax
 6a0:	83 c0 07             	add    $0x7,%eax
 6a3:	c1 e8 03             	shr    $0x3,%eax
 6a6:	40                   	inc    %eax
 6a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6aa:	a1 9c 07 00 00       	mov    0x79c,%eax
 6af:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6b6:	75 23                	jne    6db <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 6b8:	c7 45 f0 94 07 00 00 	movl   $0x794,-0x10(%ebp)
 6bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c2:	a3 9c 07 00 00       	mov    %eax,0x79c
 6c7:	a1 9c 07 00 00       	mov    0x79c,%eax
 6cc:	a3 94 07 00 00       	mov    %eax,0x794
    base.s.size = 0;
 6d1:	c7 05 98 07 00 00 00 	movl   $0x0,0x798
 6d8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6de:	8b 00                	mov    (%eax),%eax
 6e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 6e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e6:	8b 40 04             	mov    0x4(%eax),%eax
 6e9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 6ec:	72 4d                	jb     73b <malloc+0xa4>
      if(p->s.size == nunits)
 6ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f1:	8b 40 04             	mov    0x4(%eax),%eax
 6f4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 6f7:	75 0c                	jne    705 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 6f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6fc:	8b 10                	mov    (%eax),%edx
 6fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 701:	89 10                	mov    %edx,(%eax)
 703:	eb 26                	jmp    72b <malloc+0x94>
      else {
        p->s.size -= nunits;
 705:	8b 45 f4             	mov    -0xc(%ebp),%eax
 708:	8b 40 04             	mov    0x4(%eax),%eax
 70b:	89 c2                	mov    %eax,%edx
 70d:	2b 55 ec             	sub    -0x14(%ebp),%edx
 710:	8b 45 f4             	mov    -0xc(%ebp),%eax
 713:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 716:	8b 45 f4             	mov    -0xc(%ebp),%eax
 719:	8b 40 04             	mov    0x4(%eax),%eax
 71c:	c1 e0 03             	shl    $0x3,%eax
 71f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 722:	8b 45 f4             	mov    -0xc(%ebp),%eax
 725:	8b 55 ec             	mov    -0x14(%ebp),%edx
 728:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 72b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72e:	a3 9c 07 00 00       	mov    %eax,0x79c
      return (void*)(p + 1);
 733:	8b 45 f4             	mov    -0xc(%ebp),%eax
 736:	83 c0 08             	add    $0x8,%eax
 739:	eb 3b                	jmp    776 <malloc+0xdf>
    }
    if(p == freep)
 73b:	a1 9c 07 00 00       	mov    0x79c,%eax
 740:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 743:	75 1e                	jne    763 <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 745:	83 ec 0c             	sub    $0xc,%esp
 748:	ff 75 ec             	pushl  -0x14(%ebp)
 74b:	e8 e7 fe ff ff       	call   637 <morecore>
 750:	83 c4 10             	add    $0x10,%esp
 753:	89 45 f4             	mov    %eax,-0xc(%ebp)
 756:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 75a:	75 07                	jne    763 <malloc+0xcc>
        return 0;
 75c:	b8 00 00 00 00       	mov    $0x0,%eax
 761:	eb 13                	jmp    776 <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 763:	8b 45 f4             	mov    -0xc(%ebp),%eax
 766:	89 45 f0             	mov    %eax,-0x10(%ebp)
 769:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76c:	8b 00                	mov    (%eax),%eax
 76e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 771:	e9 6d ff ff ff       	jmp    6e3 <malloc+0x4c>
}
 776:	c9                   	leave  
 777:	c3                   	ret    
