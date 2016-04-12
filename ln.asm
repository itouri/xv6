
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  11:	83 3b 03             	cmpl   $0x3,(%ebx)
  14:	74 17                	je     2d <main+0x2d>
    printf(2, "Usage: ln old new\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 c0 07 00 00       	push   $0x7c0
  1e:	6a 02                	push   $0x2
  20:	e8 f2 03 00 00       	call   417 <printf>
  25:	83 c4 10             	add    $0x10,%esp
    exit();
  28:	e8 7b 02 00 00       	call   2a8 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2d:	8b 43 04             	mov    0x4(%ebx),%eax
  30:	83 c0 08             	add    $0x8,%eax
  33:	8b 10                	mov    (%eax),%edx
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 04             	add    $0x4,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	52                   	push   %edx
  41:	50                   	push   %eax
  42:	e8 c1 02 00 00       	call   308 <link>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 21                	jns    6f <main+0x6f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	83 c0 08             	add    $0x8,%eax
  54:	8b 10                	mov    (%eax),%edx
  56:	8b 43 04             	mov    0x4(%ebx),%eax
  59:	83 c0 04             	add    $0x4,%eax
  5c:	8b 00                	mov    (%eax),%eax
  5e:	52                   	push   %edx
  5f:	50                   	push   %eax
  60:	68 d3 07 00 00       	push   $0x7d3
  65:	6a 02                	push   $0x2
  67:	e8 ab 03 00 00       	call   417 <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  exit();
  6f:	e8 34 02 00 00       	call   2a8 <exit>

00000074 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7c:	8b 55 10             	mov    0x10(%ebp),%edx
  7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  82:	89 cb                	mov    %ecx,%ebx
  84:	89 df                	mov    %ebx,%edi
  86:	89 d1                	mov    %edx,%ecx
  88:	fc                   	cld    
  89:	f3 aa                	rep stos %al,%es:(%edi)
  8b:	89 ca                	mov    %ecx,%edx
  8d:	89 fb                	mov    %edi,%ebx
  8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  92:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  95:	5b                   	pop    %ebx
  96:	5f                   	pop    %edi
  97:	c9                   	leave  
  98:	c3                   	ret    

00000099 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  99:	55                   	push   %ebp
  9a:	89 e5                	mov    %esp,%ebp
  9c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a5:	90                   	nop
  a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  a9:	8a 10                	mov    (%eax),%dl
  ab:	8b 45 08             	mov    0x8(%ebp),%eax
  ae:	88 10                	mov    %dl,(%eax)
  b0:	8b 45 08             	mov    0x8(%ebp),%eax
  b3:	8a 00                	mov    (%eax),%al
  b5:	84 c0                	test   %al,%al
  b7:	0f 95 c0             	setne  %al
  ba:	ff 45 08             	incl   0x8(%ebp)
  bd:	ff 45 0c             	incl   0xc(%ebp)
  c0:	84 c0                	test   %al,%al
  c2:	75 e2                	jne    a6 <strcpy+0xd>
    ;
  return os;
  c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c7:	c9                   	leave  
  c8:	c3                   	ret    

000000c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c9:	55                   	push   %ebp
  ca:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cc:	eb 06                	jmp    d4 <strcmp+0xb>
    p++, q++;
  ce:	ff 45 08             	incl   0x8(%ebp)
  d1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	8a 00                	mov    (%eax),%al
  d9:	84 c0                	test   %al,%al
  db:	74 0e                	je     eb <strcmp+0x22>
  dd:	8b 45 08             	mov    0x8(%ebp),%eax
  e0:	8a 10                	mov    (%eax),%dl
  e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  e5:	8a 00                	mov    (%eax),%al
  e7:	38 c2                	cmp    %al,%dl
  e9:	74 e3                	je     ce <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  eb:	8b 45 08             	mov    0x8(%ebp),%eax
  ee:	8a 00                	mov    (%eax),%al
  f0:	0f b6 d0             	movzbl %al,%edx
  f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  f6:	8a 00                	mov    (%eax),%al
  f8:	0f b6 c0             	movzbl %al,%eax
  fb:	89 d1                	mov    %edx,%ecx
  fd:	29 c1                	sub    %eax,%ecx
  ff:	89 c8                	mov    %ecx,%eax
}
 101:	c9                   	leave  
 102:	c3                   	ret    

00000103 <strlen>:

uint
strlen(char *s)
{
 103:	55                   	push   %ebp
 104:	89 e5                	mov    %esp,%ebp
 106:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 109:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 110:	eb 03                	jmp    115 <strlen+0x12>
 112:	ff 45 fc             	incl   -0x4(%ebp)
 115:	8b 45 fc             	mov    -0x4(%ebp),%eax
 118:	03 45 08             	add    0x8(%ebp),%eax
 11b:	8a 00                	mov    (%eax),%al
 11d:	84 c0                	test   %al,%al
 11f:	75 f1                	jne    112 <strlen+0xf>
    ;
  return n;
 121:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 124:	c9                   	leave  
 125:	c3                   	ret    

00000126 <memset>:

void*
memset(void *dst, int c, uint n)
{
 126:	55                   	push   %ebp
 127:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 129:	8b 45 10             	mov    0x10(%ebp),%eax
 12c:	50                   	push   %eax
 12d:	ff 75 0c             	pushl  0xc(%ebp)
 130:	ff 75 08             	pushl  0x8(%ebp)
 133:	e8 3c ff ff ff       	call   74 <stosb>
 138:	83 c4 0c             	add    $0xc,%esp
  return dst;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 13e:	c9                   	leave  
 13f:	c3                   	ret    

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	83 ec 04             	sub    $0x4,%esp
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 14c:	eb 12                	jmp    160 <strchr+0x20>
    if(*s == c)
 14e:	8b 45 08             	mov    0x8(%ebp),%eax
 151:	8a 00                	mov    (%eax),%al
 153:	3a 45 fc             	cmp    -0x4(%ebp),%al
 156:	75 05                	jne    15d <strchr+0x1d>
      return (char*)s;
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	eb 11                	jmp    16e <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 15d:	ff 45 08             	incl   0x8(%ebp)
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	8a 00                	mov    (%eax),%al
 165:	84 c0                	test   %al,%al
 167:	75 e5                	jne    14e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 169:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16e:	c9                   	leave  
 16f:	c3                   	ret    

00000170 <gets>:

char*
gets(char *buf, int max)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 176:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17d:	eb 38                	jmp    1b7 <gets+0x47>
    cc = read(0, &c, 1);
 17f:	83 ec 04             	sub    $0x4,%esp
 182:	6a 01                	push   $0x1
 184:	8d 45 ef             	lea    -0x11(%ebp),%eax
 187:	50                   	push   %eax
 188:	6a 00                	push   $0x0
 18a:	e8 31 01 00 00       	call   2c0 <read>
 18f:	83 c4 10             	add    $0x10,%esp
 192:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 195:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 199:	7e 27                	jle    1c2 <gets+0x52>
      break;
    buf[i++] = c;
 19b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19e:	03 45 08             	add    0x8(%ebp),%eax
 1a1:	8a 55 ef             	mov    -0x11(%ebp),%dl
 1a4:	88 10                	mov    %dl,(%eax)
 1a6:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1a9:	8a 45 ef             	mov    -0x11(%ebp),%al
 1ac:	3c 0a                	cmp    $0xa,%al
 1ae:	74 13                	je     1c3 <gets+0x53>
 1b0:	8a 45 ef             	mov    -0x11(%ebp),%al
 1b3:	3c 0d                	cmp    $0xd,%al
 1b5:	74 0c                	je     1c3 <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ba:	40                   	inc    %eax
 1bb:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1be:	7c bf                	jl     17f <gets+0xf>
 1c0:	eb 01                	jmp    1c3 <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1c2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c6:	03 45 08             	add    0x8(%ebp),%eax
 1c9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1cf:	c9                   	leave  
 1d0:	c3                   	ret    

000001d1 <stat>:

int
stat(char *n, struct stat *st)
{
 1d1:	55                   	push   %ebp
 1d2:	89 e5                	mov    %esp,%ebp
 1d4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d7:	83 ec 08             	sub    $0x8,%esp
 1da:	6a 00                	push   $0x0
 1dc:	ff 75 08             	pushl  0x8(%ebp)
 1df:	e8 04 01 00 00       	call   2e8 <open>
 1e4:	83 c4 10             	add    $0x10,%esp
 1e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ee:	79 07                	jns    1f7 <stat+0x26>
    return -1;
 1f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1f5:	eb 25                	jmp    21c <stat+0x4b>
  r = fstat(fd, st);
 1f7:	83 ec 08             	sub    $0x8,%esp
 1fa:	ff 75 0c             	pushl  0xc(%ebp)
 1fd:	ff 75 f4             	pushl  -0xc(%ebp)
 200:	e8 fb 00 00 00       	call   300 <fstat>
 205:	83 c4 10             	add    $0x10,%esp
 208:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 20b:	83 ec 0c             	sub    $0xc,%esp
 20e:	ff 75 f4             	pushl  -0xc(%ebp)
 211:	e8 ba 00 00 00       	call   2d0 <close>
 216:	83 c4 10             	add    $0x10,%esp
  return r;
 219:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 21c:	c9                   	leave  
 21d:	c3                   	ret    

0000021e <atoi>:

int
atoi(const char *s)
{
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
 221:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 224:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 22b:	eb 22                	jmp    24f <atoi+0x31>
    n = n*10 + *s++ - '0';
 22d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 230:	89 d0                	mov    %edx,%eax
 232:	c1 e0 02             	shl    $0x2,%eax
 235:	01 d0                	add    %edx,%eax
 237:	d1 e0                	shl    %eax
 239:	89 c2                	mov    %eax,%edx
 23b:	8b 45 08             	mov    0x8(%ebp),%eax
 23e:	8a 00                	mov    (%eax),%al
 240:	0f be c0             	movsbl %al,%eax
 243:	8d 04 02             	lea    (%edx,%eax,1),%eax
 246:	83 e8 30             	sub    $0x30,%eax
 249:	89 45 fc             	mov    %eax,-0x4(%ebp)
 24c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 24f:	8b 45 08             	mov    0x8(%ebp),%eax
 252:	8a 00                	mov    (%eax),%al
 254:	3c 2f                	cmp    $0x2f,%al
 256:	7e 09                	jle    261 <atoi+0x43>
 258:	8b 45 08             	mov    0x8(%ebp),%eax
 25b:	8a 00                	mov    (%eax),%al
 25d:	3c 39                	cmp    $0x39,%al
 25f:	7e cc                	jle    22d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 261:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 264:	c9                   	leave  
 265:	c3                   	ret    

00000266 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 266:	55                   	push   %ebp
 267:	89 e5                	mov    %esp,%ebp
 269:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 272:	8b 45 0c             	mov    0xc(%ebp),%eax
 275:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 278:	eb 10                	jmp    28a <memmove+0x24>
    *dst++ = *src++;
 27a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 27d:	8a 10                	mov    (%eax),%dl
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 282:	88 10                	mov    %dl,(%eax)
 284:	ff 45 fc             	incl   -0x4(%ebp)
 287:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 28a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 28e:	0f 9f c0             	setg   %al
 291:	ff 4d 10             	decl   0x10(%ebp)
 294:	84 c0                	test   %al,%al
 296:	75 e2                	jne    27a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 298:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29b:	c9                   	leave  
 29c:	c3                   	ret    
 29d:	90                   	nop
 29e:	90                   	nop
 29f:	90                   	nop

000002a0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2a0:	b8 01 00 00 00       	mov    $0x1,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <exit>:
SYSCALL(exit)
 2a8:	b8 02 00 00 00       	mov    $0x2,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <wait>:
SYSCALL(wait)
 2b0:	b8 03 00 00 00       	mov    $0x3,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <pipe>:
SYSCALL(pipe)
 2b8:	b8 04 00 00 00       	mov    $0x4,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <read>:
SYSCALL(read)
 2c0:	b8 05 00 00 00       	mov    $0x5,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <write>:
SYSCALL(write)
 2c8:	b8 10 00 00 00       	mov    $0x10,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <close>:
SYSCALL(close)
 2d0:	b8 15 00 00 00       	mov    $0x15,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <kill>:
SYSCALL(kill)
 2d8:	b8 06 00 00 00       	mov    $0x6,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <exec>:
SYSCALL(exec)
 2e0:	b8 07 00 00 00       	mov    $0x7,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <open>:
SYSCALL(open)
 2e8:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <mknod>:
SYSCALL(mknod)
 2f0:	b8 11 00 00 00       	mov    $0x11,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <unlink>:
SYSCALL(unlink)
 2f8:	b8 12 00 00 00       	mov    $0x12,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <fstat>:
SYSCALL(fstat)
 300:	b8 08 00 00 00       	mov    $0x8,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <link>:
SYSCALL(link)
 308:	b8 13 00 00 00       	mov    $0x13,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <mkdir>:
SYSCALL(mkdir)
 310:	b8 14 00 00 00       	mov    $0x14,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <chdir>:
SYSCALL(chdir)
 318:	b8 09 00 00 00       	mov    $0x9,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <dup>:
SYSCALL(dup)
 320:	b8 0a 00 00 00       	mov    $0xa,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <getpid>:
SYSCALL(getpid)
 328:	b8 0b 00 00 00       	mov    $0xb,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <sbrk>:
SYSCALL(sbrk)
 330:	b8 0c 00 00 00       	mov    $0xc,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <sleep>:
SYSCALL(sleep)
 338:	b8 0d 00 00 00       	mov    $0xd,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <uptime>:
SYSCALL(uptime)
 340:	b8 0e 00 00 00       	mov    $0xe,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	83 ec 18             	sub    $0x18,%esp
 34e:	8b 45 0c             	mov    0xc(%ebp),%eax
 351:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 354:	83 ec 04             	sub    $0x4,%esp
 357:	6a 01                	push   $0x1
 359:	8d 45 f4             	lea    -0xc(%ebp),%eax
 35c:	50                   	push   %eax
 35d:	ff 75 08             	pushl  0x8(%ebp)
 360:	e8 63 ff ff ff       	call   2c8 <write>
 365:	83 c4 10             	add    $0x10,%esp
}
 368:	c9                   	leave  
 369:	c3                   	ret    

0000036a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 36a:	55                   	push   %ebp
 36b:	89 e5                	mov    %esp,%ebp
 36d:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 370:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 377:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 37b:	74 17                	je     394 <printint+0x2a>
 37d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 381:	79 11                	jns    394 <printint+0x2a>
    neg = 1;
 383:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 38a:	8b 45 0c             	mov    0xc(%ebp),%eax
 38d:	f7 d8                	neg    %eax
 38f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 392:	eb 06                	jmp    39a <printint+0x30>
  } else {
    x = xx;
 394:	8b 45 0c             	mov    0xc(%ebp),%eax
 397:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 39a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3a7:	ba 00 00 00 00       	mov    $0x0,%edx
 3ac:	f7 f1                	div    %ecx
 3ae:	89 d0                	mov    %edx,%eax
 3b0:	8a 90 f0 07 00 00    	mov    0x7f0(%eax),%dl
 3b6:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3b9:	03 45 f4             	add    -0xc(%ebp),%eax
 3bc:	88 10                	mov    %dl,(%eax)
 3be:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3c1:	8b 45 10             	mov    0x10(%ebp),%eax
 3c4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ca:	ba 00 00 00 00       	mov    $0x0,%edx
 3cf:	f7 75 d4             	divl   -0x2c(%ebp)
 3d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3d9:	75 c6                	jne    3a1 <printint+0x37>
  if(neg)
 3db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3df:	74 2a                	je     40b <printint+0xa1>
    buf[i++] = '-';
 3e1:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3e4:	03 45 f4             	add    -0xc(%ebp),%eax
 3e7:	c6 00 2d             	movb   $0x2d,(%eax)
 3ea:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 3ed:	eb 1d                	jmp    40c <printint+0xa2>
    putc(fd, buf[i]);
 3ef:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3f2:	03 45 f4             	add    -0xc(%ebp),%eax
 3f5:	8a 00                	mov    (%eax),%al
 3f7:	0f be c0             	movsbl %al,%eax
 3fa:	83 ec 08             	sub    $0x8,%esp
 3fd:	50                   	push   %eax
 3fe:	ff 75 08             	pushl  0x8(%ebp)
 401:	e8 42 ff ff ff       	call   348 <putc>
 406:	83 c4 10             	add    $0x10,%esp
 409:	eb 01                	jmp    40c <printint+0xa2>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 40b:	90                   	nop
 40c:	ff 4d f4             	decl   -0xc(%ebp)
 40f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 413:	79 da                	jns    3ef <printint+0x85>
    putc(fd, buf[i]);
}
 415:	c9                   	leave  
 416:	c3                   	ret    

00000417 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 417:	55                   	push   %ebp
 418:	89 e5                	mov    %esp,%ebp
 41a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 41d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 424:	8d 45 0c             	lea    0xc(%ebp),%eax
 427:	83 c0 04             	add    $0x4,%eax
 42a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 42d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 434:	e9 58 01 00 00       	jmp    591 <printf+0x17a>
    c = fmt[i] & 0xff;
 439:	8b 55 0c             	mov    0xc(%ebp),%edx
 43c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 43f:	8d 04 02             	lea    (%edx,%eax,1),%eax
 442:	8a 00                	mov    (%eax),%al
 444:	0f be c0             	movsbl %al,%eax
 447:	25 ff 00 00 00       	and    $0xff,%eax
 44c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 44f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 453:	75 2c                	jne    481 <printf+0x6a>
      if(c == '%'){
 455:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 459:	75 0c                	jne    467 <printf+0x50>
        state = '%';
 45b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 462:	e9 27 01 00 00       	jmp    58e <printf+0x177>
      } else {
        putc(fd, c);
 467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 46a:	0f be c0             	movsbl %al,%eax
 46d:	83 ec 08             	sub    $0x8,%esp
 470:	50                   	push   %eax
 471:	ff 75 08             	pushl  0x8(%ebp)
 474:	e8 cf fe ff ff       	call   348 <putc>
 479:	83 c4 10             	add    $0x10,%esp
 47c:	e9 0d 01 00 00       	jmp    58e <printf+0x177>
      }
    } else if(state == '%'){
 481:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 485:	0f 85 03 01 00 00    	jne    58e <printf+0x177>
      if(c == 'd'){
 48b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 48f:	75 1e                	jne    4af <printf+0x98>
        printint(fd, *ap, 10, 1);
 491:	8b 45 e8             	mov    -0x18(%ebp),%eax
 494:	8b 00                	mov    (%eax),%eax
 496:	6a 01                	push   $0x1
 498:	6a 0a                	push   $0xa
 49a:	50                   	push   %eax
 49b:	ff 75 08             	pushl  0x8(%ebp)
 49e:	e8 c7 fe ff ff       	call   36a <printint>
 4a3:	83 c4 10             	add    $0x10,%esp
        ap++;
 4a6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4aa:	e9 d8 00 00 00       	jmp    587 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4af:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4b3:	74 06                	je     4bb <printf+0xa4>
 4b5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4b9:	75 1e                	jne    4d9 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4be:	8b 00                	mov    (%eax),%eax
 4c0:	6a 00                	push   $0x0
 4c2:	6a 10                	push   $0x10
 4c4:	50                   	push   %eax
 4c5:	ff 75 08             	pushl  0x8(%ebp)
 4c8:	e8 9d fe ff ff       	call   36a <printint>
 4cd:	83 c4 10             	add    $0x10,%esp
        ap++;
 4d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d4:	e9 ae 00 00 00       	jmp    587 <printf+0x170>
      } else if(c == 's'){
 4d9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4dd:	75 43                	jne    522 <printf+0x10b>
        s = (char*)*ap;
 4df:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e2:	8b 00                	mov    (%eax),%eax
 4e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ef:	75 25                	jne    516 <printf+0xff>
          s = "(null)";
 4f1:	c7 45 f4 e7 07 00 00 	movl   $0x7e7,-0xc(%ebp)
        while(*s != 0){
 4f8:	eb 1d                	jmp    517 <printf+0x100>
          putc(fd, *s);
 4fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fd:	8a 00                	mov    (%eax),%al
 4ff:	0f be c0             	movsbl %al,%eax
 502:	83 ec 08             	sub    $0x8,%esp
 505:	50                   	push   %eax
 506:	ff 75 08             	pushl  0x8(%ebp)
 509:	e8 3a fe ff ff       	call   348 <putc>
 50e:	83 c4 10             	add    $0x10,%esp
          s++;
 511:	ff 45 f4             	incl   -0xc(%ebp)
 514:	eb 01                	jmp    517 <printf+0x100>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 516:	90                   	nop
 517:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51a:	8a 00                	mov    (%eax),%al
 51c:	84 c0                	test   %al,%al
 51e:	75 da                	jne    4fa <printf+0xe3>
 520:	eb 65                	jmp    587 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 522:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 526:	75 1d                	jne    545 <printf+0x12e>
        putc(fd, *ap);
 528:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52b:	8b 00                	mov    (%eax),%eax
 52d:	0f be c0             	movsbl %al,%eax
 530:	83 ec 08             	sub    $0x8,%esp
 533:	50                   	push   %eax
 534:	ff 75 08             	pushl  0x8(%ebp)
 537:	e8 0c fe ff ff       	call   348 <putc>
 53c:	83 c4 10             	add    $0x10,%esp
        ap++;
 53f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 543:	eb 42                	jmp    587 <printf+0x170>
      } else if(c == '%'){
 545:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 549:	75 17                	jne    562 <printf+0x14b>
        putc(fd, c);
 54b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54e:	0f be c0             	movsbl %al,%eax
 551:	83 ec 08             	sub    $0x8,%esp
 554:	50                   	push   %eax
 555:	ff 75 08             	pushl  0x8(%ebp)
 558:	e8 eb fd ff ff       	call   348 <putc>
 55d:	83 c4 10             	add    $0x10,%esp
 560:	eb 25                	jmp    587 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 562:	83 ec 08             	sub    $0x8,%esp
 565:	6a 25                	push   $0x25
 567:	ff 75 08             	pushl  0x8(%ebp)
 56a:	e8 d9 fd ff ff       	call   348 <putc>
 56f:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 575:	0f be c0             	movsbl %al,%eax
 578:	83 ec 08             	sub    $0x8,%esp
 57b:	50                   	push   %eax
 57c:	ff 75 08             	pushl  0x8(%ebp)
 57f:	e8 c4 fd ff ff       	call   348 <putc>
 584:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 587:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 58e:	ff 45 f0             	incl   -0x10(%ebp)
 591:	8b 55 0c             	mov    0xc(%ebp),%edx
 594:	8b 45 f0             	mov    -0x10(%ebp),%eax
 597:	8d 04 02             	lea    (%edx,%eax,1),%eax
 59a:	8a 00                	mov    (%eax),%al
 59c:	84 c0                	test   %al,%al
 59e:	0f 85 95 fe ff ff    	jne    439 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5a4:	c9                   	leave  
 5a5:	c3                   	ret    
 5a6:	90                   	nop
 5a7:	90                   	nop

000005a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a8:	55                   	push   %ebp
 5a9:	89 e5                	mov    %esp,%ebp
 5ab:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ae:	8b 45 08             	mov    0x8(%ebp),%eax
 5b1:	83 e8 08             	sub    $0x8,%eax
 5b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b7:	a1 0c 08 00 00       	mov    0x80c,%eax
 5bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5bf:	eb 24                	jmp    5e5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5c4:	8b 00                	mov    (%eax),%eax
 5c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5c9:	77 12                	ja     5dd <free+0x35>
 5cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5d1:	77 24                	ja     5f7 <free+0x4f>
 5d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d6:	8b 00                	mov    (%eax),%eax
 5d8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5db:	77 1a                	ja     5f7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e0:	8b 00                	mov    (%eax),%eax
 5e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5eb:	76 d4                	jbe    5c1 <free+0x19>
 5ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f0:	8b 00                	mov    (%eax),%eax
 5f2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5f5:	76 ca                	jbe    5c1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5fa:	8b 40 04             	mov    0x4(%eax),%eax
 5fd:	c1 e0 03             	shl    $0x3,%eax
 600:	89 c2                	mov    %eax,%edx
 602:	03 55 f8             	add    -0x8(%ebp),%edx
 605:	8b 45 fc             	mov    -0x4(%ebp),%eax
 608:	8b 00                	mov    (%eax),%eax
 60a:	39 c2                	cmp    %eax,%edx
 60c:	75 24                	jne    632 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 60e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 611:	8b 50 04             	mov    0x4(%eax),%edx
 614:	8b 45 fc             	mov    -0x4(%ebp),%eax
 617:	8b 00                	mov    (%eax),%eax
 619:	8b 40 04             	mov    0x4(%eax),%eax
 61c:	01 c2                	add    %eax,%edx
 61e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 621:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 624:	8b 45 fc             	mov    -0x4(%ebp),%eax
 627:	8b 00                	mov    (%eax),%eax
 629:	8b 10                	mov    (%eax),%edx
 62b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62e:	89 10                	mov    %edx,(%eax)
 630:	eb 0a                	jmp    63c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 632:	8b 45 fc             	mov    -0x4(%ebp),%eax
 635:	8b 10                	mov    (%eax),%edx
 637:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 63c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63f:	8b 40 04             	mov    0x4(%eax),%eax
 642:	c1 e0 03             	shl    $0x3,%eax
 645:	03 45 fc             	add    -0x4(%ebp),%eax
 648:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64b:	75 20                	jne    66d <free+0xc5>
    p->s.size += bp->s.size;
 64d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 650:	8b 50 04             	mov    0x4(%eax),%edx
 653:	8b 45 f8             	mov    -0x8(%ebp),%eax
 656:	8b 40 04             	mov    0x4(%eax),%eax
 659:	01 c2                	add    %eax,%edx
 65b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 661:	8b 45 f8             	mov    -0x8(%ebp),%eax
 664:	8b 10                	mov    (%eax),%edx
 666:	8b 45 fc             	mov    -0x4(%ebp),%eax
 669:	89 10                	mov    %edx,(%eax)
 66b:	eb 08                	jmp    675 <free+0xcd>
  } else
    p->s.ptr = bp;
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	8b 55 f8             	mov    -0x8(%ebp),%edx
 673:	89 10                	mov    %edx,(%eax)
  freep = p;
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	a3 0c 08 00 00       	mov    %eax,0x80c
}
 67d:	c9                   	leave  
 67e:	c3                   	ret    

0000067f <morecore>:

static Header*
morecore(uint nu)
{
 67f:	55                   	push   %ebp
 680:	89 e5                	mov    %esp,%ebp
 682:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 685:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 68c:	77 07                	ja     695 <morecore+0x16>
    nu = 4096;
 68e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 695:	8b 45 08             	mov    0x8(%ebp),%eax
 698:	c1 e0 03             	shl    $0x3,%eax
 69b:	83 ec 0c             	sub    $0xc,%esp
 69e:	50                   	push   %eax
 69f:	e8 8c fc ff ff       	call   330 <sbrk>
 6a4:	83 c4 10             	add    $0x10,%esp
 6a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6aa:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6ae:	75 07                	jne    6b7 <morecore+0x38>
    return 0;
 6b0:	b8 00 00 00 00       	mov    $0x0,%eax
 6b5:	eb 26                	jmp    6dd <morecore+0x5e>
  hp = (Header*)p;
 6b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c0:	8b 55 08             	mov    0x8(%ebp),%edx
 6c3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c9:	83 c0 08             	add    $0x8,%eax
 6cc:	83 ec 0c             	sub    $0xc,%esp
 6cf:	50                   	push   %eax
 6d0:	e8 d3 fe ff ff       	call   5a8 <free>
 6d5:	83 c4 10             	add    $0x10,%esp
  return freep;
 6d8:	a1 0c 08 00 00       	mov    0x80c,%eax
}
 6dd:	c9                   	leave  
 6de:	c3                   	ret    

000006df <malloc>:

void*
malloc(uint nbytes)
{
 6df:	55                   	push   %ebp
 6e0:	89 e5                	mov    %esp,%ebp
 6e2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e5:	8b 45 08             	mov    0x8(%ebp),%eax
 6e8:	83 c0 07             	add    $0x7,%eax
 6eb:	c1 e8 03             	shr    $0x3,%eax
 6ee:	40                   	inc    %eax
 6ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6f2:	a1 0c 08 00 00       	mov    0x80c,%eax
 6f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6fe:	75 23                	jne    723 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 700:	c7 45 f0 04 08 00 00 	movl   $0x804,-0x10(%ebp)
 707:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70a:	a3 0c 08 00 00       	mov    %eax,0x80c
 70f:	a1 0c 08 00 00       	mov    0x80c,%eax
 714:	a3 04 08 00 00       	mov    %eax,0x804
    base.s.size = 0;
 719:	c7 05 08 08 00 00 00 	movl   $0x0,0x808
 720:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 723:	8b 45 f0             	mov    -0x10(%ebp),%eax
 726:	8b 00                	mov    (%eax),%eax
 728:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 72b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72e:	8b 40 04             	mov    0x4(%eax),%eax
 731:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 734:	72 4d                	jb     783 <malloc+0xa4>
      if(p->s.size == nunits)
 736:	8b 45 f4             	mov    -0xc(%ebp),%eax
 739:	8b 40 04             	mov    0x4(%eax),%eax
 73c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 73f:	75 0c                	jne    74d <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 741:	8b 45 f4             	mov    -0xc(%ebp),%eax
 744:	8b 10                	mov    (%eax),%edx
 746:	8b 45 f0             	mov    -0x10(%ebp),%eax
 749:	89 10                	mov    %edx,(%eax)
 74b:	eb 26                	jmp    773 <malloc+0x94>
      else {
        p->s.size -= nunits;
 74d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 750:	8b 40 04             	mov    0x4(%eax),%eax
 753:	89 c2                	mov    %eax,%edx
 755:	2b 55 ec             	sub    -0x14(%ebp),%edx
 758:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 75e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 761:	8b 40 04             	mov    0x4(%eax),%eax
 764:	c1 e0 03             	shl    $0x3,%eax
 767:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 76a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 770:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 773:	8b 45 f0             	mov    -0x10(%ebp),%eax
 776:	a3 0c 08 00 00       	mov    %eax,0x80c
      return (void*)(p + 1);
 77b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77e:	83 c0 08             	add    $0x8,%eax
 781:	eb 3b                	jmp    7be <malloc+0xdf>
    }
    if(p == freep)
 783:	a1 0c 08 00 00       	mov    0x80c,%eax
 788:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 78b:	75 1e                	jne    7ab <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 78d:	83 ec 0c             	sub    $0xc,%esp
 790:	ff 75 ec             	pushl  -0x14(%ebp)
 793:	e8 e7 fe ff ff       	call   67f <morecore>
 798:	83 c4 10             	add    $0x10,%esp
 79b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 79e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7a2:	75 07                	jne    7ab <malloc+0xcc>
        return 0;
 7a4:	b8 00 00 00 00       	mov    $0x0,%eax
 7a9:	eb 13                	jmp    7be <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b4:	8b 00                	mov    (%eax),%eax
 7b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7b9:	e9 6d ff ff ff       	jmp    72b <malloc+0x4c>
}
 7be:	c9                   	leave  
 7bf:	c3                   	ret    
