
_echo:     file format elf32-i386


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
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  for(i = 1; i < argc; i++)
  14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1b:	eb 33                	jmp    50 <main+0x50>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	40                   	inc    %eax
  21:	3b 03                	cmp    (%ebx),%eax
  23:	7d 07                	jge    2c <main+0x2c>
  25:	b8 a8 07 00 00       	mov    $0x7a8,%eax
  2a:	eb 05                	jmp    31 <main+0x31>
  2c:	b8 aa 07 00 00       	mov    $0x7aa,%eax
  31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  34:	c1 e2 02             	shl    $0x2,%edx
  37:	03 53 04             	add    0x4(%ebx),%edx
  3a:	8b 12                	mov    (%edx),%edx
  3c:	50                   	push   %eax
  3d:	52                   	push   %edx
  3e:	68 ac 07 00 00       	push   $0x7ac
  43:	6a 01                	push   $0x1
  45:	e8 b5 03 00 00       	call   3ff <printf>
  4a:	83 c4 10             	add    $0x10,%esp
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  4d:	ff 45 f4             	incl   -0xc(%ebp)
  50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  53:	3b 03                	cmp    (%ebx),%eax
  55:	7c c6                	jl     1d <main+0x1d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  57:	e8 34 02 00 00       	call   290 <exit>

0000005c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	57                   	push   %edi
  60:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  64:	8b 55 10             	mov    0x10(%ebp),%edx
  67:	8b 45 0c             	mov    0xc(%ebp),%eax
  6a:	89 cb                	mov    %ecx,%ebx
  6c:	89 df                	mov    %ebx,%edi
  6e:	89 d1                	mov    %edx,%ecx
  70:	fc                   	cld    
  71:	f3 aa                	rep stos %al,%es:(%edi)
  73:	89 ca                	mov    %ecx,%edx
  75:	89 fb                	mov    %edi,%ebx
  77:	89 5d 08             	mov    %ebx,0x8(%ebp)
  7a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  7d:	5b                   	pop    %ebx
  7e:	5f                   	pop    %edi
  7f:	c9                   	leave  
  80:	c3                   	ret    

00000081 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  81:	55                   	push   %ebp
  82:	89 e5                	mov    %esp,%ebp
  84:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  87:	8b 45 08             	mov    0x8(%ebp),%eax
  8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  8d:	90                   	nop
  8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  91:	8a 10                	mov    (%eax),%dl
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	88 10                	mov    %dl,(%eax)
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	8a 00                	mov    (%eax),%al
  9d:	84 c0                	test   %al,%al
  9f:	0f 95 c0             	setne  %al
  a2:	ff 45 08             	incl   0x8(%ebp)
  a5:	ff 45 0c             	incl   0xc(%ebp)
  a8:	84 c0                	test   %al,%al
  aa:	75 e2                	jne    8e <strcpy+0xd>
    ;
  return os;
  ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  af:	c9                   	leave  
  b0:	c3                   	ret    

000000b1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b1:	55                   	push   %ebp
  b2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  b4:	eb 06                	jmp    bc <strcmp+0xb>
    p++, q++;
  b6:	ff 45 08             	incl   0x8(%ebp)
  b9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  bc:	8b 45 08             	mov    0x8(%ebp),%eax
  bf:	8a 00                	mov    (%eax),%al
  c1:	84 c0                	test   %al,%al
  c3:	74 0e                	je     d3 <strcmp+0x22>
  c5:	8b 45 08             	mov    0x8(%ebp),%eax
  c8:	8a 10                	mov    (%eax),%dl
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	8a 00                	mov    (%eax),%al
  cf:	38 c2                	cmp    %al,%dl
  d1:	74 e3                	je     b6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	8a 00                	mov    (%eax),%al
  d8:	0f b6 d0             	movzbl %al,%edx
  db:	8b 45 0c             	mov    0xc(%ebp),%eax
  de:	8a 00                	mov    (%eax),%al
  e0:	0f b6 c0             	movzbl %al,%eax
  e3:	89 d1                	mov    %edx,%ecx
  e5:	29 c1                	sub    %eax,%ecx
  e7:	89 c8                	mov    %ecx,%eax
}
  e9:	c9                   	leave  
  ea:	c3                   	ret    

000000eb <strlen>:

uint
strlen(char *s)
{
  eb:	55                   	push   %ebp
  ec:	89 e5                	mov    %esp,%ebp
  ee:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  f8:	eb 03                	jmp    fd <strlen+0x12>
  fa:	ff 45 fc             	incl   -0x4(%ebp)
  fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 100:	03 45 08             	add    0x8(%ebp),%eax
 103:	8a 00                	mov    (%eax),%al
 105:	84 c0                	test   %al,%al
 107:	75 f1                	jne    fa <strlen+0xf>
    ;
  return n;
 109:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 10c:	c9                   	leave  
 10d:	c3                   	ret    

0000010e <memset>:

void*
memset(void *dst, int c, uint n)
{
 10e:	55                   	push   %ebp
 10f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 111:	8b 45 10             	mov    0x10(%ebp),%eax
 114:	50                   	push   %eax
 115:	ff 75 0c             	pushl  0xc(%ebp)
 118:	ff 75 08             	pushl  0x8(%ebp)
 11b:	e8 3c ff ff ff       	call   5c <stosb>
 120:	83 c4 0c             	add    $0xc,%esp
  return dst;
 123:	8b 45 08             	mov    0x8(%ebp),%eax
}
 126:	c9                   	leave  
 127:	c3                   	ret    

00000128 <strchr>:

char*
strchr(const char *s, char c)
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	83 ec 04             	sub    $0x4,%esp
 12e:	8b 45 0c             	mov    0xc(%ebp),%eax
 131:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 134:	eb 12                	jmp    148 <strchr+0x20>
    if(*s == c)
 136:	8b 45 08             	mov    0x8(%ebp),%eax
 139:	8a 00                	mov    (%eax),%al
 13b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 13e:	75 05                	jne    145 <strchr+0x1d>
      return (char*)s;
 140:	8b 45 08             	mov    0x8(%ebp),%eax
 143:	eb 11                	jmp    156 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 145:	ff 45 08             	incl   0x8(%ebp)
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	8a 00                	mov    (%eax),%al
 14d:	84 c0                	test   %al,%al
 14f:	75 e5                	jne    136 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 151:	b8 00 00 00 00       	mov    $0x0,%eax
}
 156:	c9                   	leave  
 157:	c3                   	ret    

00000158 <gets>:

char*
gets(char *buf, int max)
{
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
 15b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 165:	eb 38                	jmp    19f <gets+0x47>
    cc = read(0, &c, 1);
 167:	83 ec 04             	sub    $0x4,%esp
 16a:	6a 01                	push   $0x1
 16c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 16f:	50                   	push   %eax
 170:	6a 00                	push   $0x0
 172:	e8 31 01 00 00       	call   2a8 <read>
 177:	83 c4 10             	add    $0x10,%esp
 17a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 17d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 181:	7e 27                	jle    1aa <gets+0x52>
      break;
    buf[i++] = c;
 183:	8b 45 f4             	mov    -0xc(%ebp),%eax
 186:	03 45 08             	add    0x8(%ebp),%eax
 189:	8a 55 ef             	mov    -0x11(%ebp),%dl
 18c:	88 10                	mov    %dl,(%eax)
 18e:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 191:	8a 45 ef             	mov    -0x11(%ebp),%al
 194:	3c 0a                	cmp    $0xa,%al
 196:	74 13                	je     1ab <gets+0x53>
 198:	8a 45 ef             	mov    -0x11(%ebp),%al
 19b:	3c 0d                	cmp    $0xd,%al
 19d:	74 0c                	je     1ab <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a2:	40                   	inc    %eax
 1a3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1a6:	7c bf                	jl     167 <gets+0xf>
 1a8:	eb 01                	jmp    1ab <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1aa:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ae:	03 45 08             	add    0x8(%ebp),%eax
 1b1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1b7:	c9                   	leave  
 1b8:	c3                   	ret    

000001b9 <stat>:

int
stat(char *n, struct stat *st)
{
 1b9:	55                   	push   %ebp
 1ba:	89 e5                	mov    %esp,%ebp
 1bc:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1bf:	83 ec 08             	sub    $0x8,%esp
 1c2:	6a 00                	push   $0x0
 1c4:	ff 75 08             	pushl  0x8(%ebp)
 1c7:	e8 04 01 00 00       	call   2d0 <open>
 1cc:	83 c4 10             	add    $0x10,%esp
 1cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1d6:	79 07                	jns    1df <stat+0x26>
    return -1;
 1d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1dd:	eb 25                	jmp    204 <stat+0x4b>
  r = fstat(fd, st);
 1df:	83 ec 08             	sub    $0x8,%esp
 1e2:	ff 75 0c             	pushl  0xc(%ebp)
 1e5:	ff 75 f4             	pushl  -0xc(%ebp)
 1e8:	e8 fb 00 00 00       	call   2e8 <fstat>
 1ed:	83 c4 10             	add    $0x10,%esp
 1f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1f3:	83 ec 0c             	sub    $0xc,%esp
 1f6:	ff 75 f4             	pushl  -0xc(%ebp)
 1f9:	e8 ba 00 00 00       	call   2b8 <close>
 1fe:	83 c4 10             	add    $0x10,%esp
  return r;
 201:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 204:	c9                   	leave  
 205:	c3                   	ret    

00000206 <atoi>:

int
atoi(const char *s)
{
 206:	55                   	push   %ebp
 207:	89 e5                	mov    %esp,%ebp
 209:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 20c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 213:	eb 22                	jmp    237 <atoi+0x31>
    n = n*10 + *s++ - '0';
 215:	8b 55 fc             	mov    -0x4(%ebp),%edx
 218:	89 d0                	mov    %edx,%eax
 21a:	c1 e0 02             	shl    $0x2,%eax
 21d:	01 d0                	add    %edx,%eax
 21f:	d1 e0                	shl    %eax
 221:	89 c2                	mov    %eax,%edx
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	8a 00                	mov    (%eax),%al
 228:	0f be c0             	movsbl %al,%eax
 22b:	8d 04 02             	lea    (%edx,%eax,1),%eax
 22e:	83 e8 30             	sub    $0x30,%eax
 231:	89 45 fc             	mov    %eax,-0x4(%ebp)
 234:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	8a 00                	mov    (%eax),%al
 23c:	3c 2f                	cmp    $0x2f,%al
 23e:	7e 09                	jle    249 <atoi+0x43>
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	8a 00                	mov    (%eax),%al
 245:	3c 39                	cmp    $0x39,%al
 247:	7e cc                	jle    215 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 249:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 25a:	8b 45 0c             	mov    0xc(%ebp),%eax
 25d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 260:	eb 10                	jmp    272 <memmove+0x24>
    *dst++ = *src++;
 262:	8b 45 f8             	mov    -0x8(%ebp),%eax
 265:	8a 10                	mov    (%eax),%dl
 267:	8b 45 fc             	mov    -0x4(%ebp),%eax
 26a:	88 10                	mov    %dl,(%eax)
 26c:	ff 45 fc             	incl   -0x4(%ebp)
 26f:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 272:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 276:	0f 9f c0             	setg   %al
 279:	ff 4d 10             	decl   0x10(%ebp)
 27c:	84 c0                	test   %al,%al
 27e:	75 e2                	jne    262 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 280:	8b 45 08             	mov    0x8(%ebp),%eax
}
 283:	c9                   	leave  
 284:	c3                   	ret    
 285:	90                   	nop
 286:	90                   	nop
 287:	90                   	nop

00000288 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 288:	b8 01 00 00 00       	mov    $0x1,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <exit>:
SYSCALL(exit)
 290:	b8 02 00 00 00       	mov    $0x2,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <wait>:
SYSCALL(wait)
 298:	b8 03 00 00 00       	mov    $0x3,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <pipe>:
SYSCALL(pipe)
 2a0:	b8 04 00 00 00       	mov    $0x4,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <read>:
SYSCALL(read)
 2a8:	b8 05 00 00 00       	mov    $0x5,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <write>:
SYSCALL(write)
 2b0:	b8 10 00 00 00       	mov    $0x10,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <close>:
SYSCALL(close)
 2b8:	b8 15 00 00 00       	mov    $0x15,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <kill>:
SYSCALL(kill)
 2c0:	b8 06 00 00 00       	mov    $0x6,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <exec>:
SYSCALL(exec)
 2c8:	b8 07 00 00 00       	mov    $0x7,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <open>:
SYSCALL(open)
 2d0:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <mknod>:
SYSCALL(mknod)
 2d8:	b8 11 00 00 00       	mov    $0x11,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <unlink>:
SYSCALL(unlink)
 2e0:	b8 12 00 00 00       	mov    $0x12,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <fstat>:
SYSCALL(fstat)
 2e8:	b8 08 00 00 00       	mov    $0x8,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <link>:
SYSCALL(link)
 2f0:	b8 13 00 00 00       	mov    $0x13,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <mkdir>:
SYSCALL(mkdir)
 2f8:	b8 14 00 00 00       	mov    $0x14,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <chdir>:
SYSCALL(chdir)
 300:	b8 09 00 00 00       	mov    $0x9,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <dup>:
SYSCALL(dup)
 308:	b8 0a 00 00 00       	mov    $0xa,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <getpid>:
SYSCALL(getpid)
 310:	b8 0b 00 00 00       	mov    $0xb,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <sbrk>:
SYSCALL(sbrk)
 318:	b8 0c 00 00 00       	mov    $0xc,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <sleep>:
SYSCALL(sleep)
 320:	b8 0d 00 00 00       	mov    $0xd,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <uptime>:
SYSCALL(uptime)
 328:	b8 0e 00 00 00       	mov    $0xe,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	83 ec 18             	sub    $0x18,%esp
 336:	8b 45 0c             	mov    0xc(%ebp),%eax
 339:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 33c:	83 ec 04             	sub    $0x4,%esp
 33f:	6a 01                	push   $0x1
 341:	8d 45 f4             	lea    -0xc(%ebp),%eax
 344:	50                   	push   %eax
 345:	ff 75 08             	pushl  0x8(%ebp)
 348:	e8 63 ff ff ff       	call   2b0 <write>
 34d:	83 c4 10             	add    $0x10,%esp
}
 350:	c9                   	leave  
 351:	c3                   	ret    

00000352 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 352:	55                   	push   %ebp
 353:	89 e5                	mov    %esp,%ebp
 355:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 358:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 35f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 363:	74 17                	je     37c <printint+0x2a>
 365:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 369:	79 11                	jns    37c <printint+0x2a>
    neg = 1;
 36b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 372:	8b 45 0c             	mov    0xc(%ebp),%eax
 375:	f7 d8                	neg    %eax
 377:	89 45 ec             	mov    %eax,-0x14(%ebp)
 37a:	eb 06                	jmp    382 <printint+0x30>
  } else {
    x = xx;
 37c:	8b 45 0c             	mov    0xc(%ebp),%eax
 37f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 382:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 389:	8b 4d 10             	mov    0x10(%ebp),%ecx
 38c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 38f:	ba 00 00 00 00       	mov    $0x0,%edx
 394:	f7 f1                	div    %ecx
 396:	89 d0                	mov    %edx,%eax
 398:	8a 90 b8 07 00 00    	mov    0x7b8(%eax),%dl
 39e:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3a1:	03 45 f4             	add    -0xc(%ebp),%eax
 3a4:	88 10                	mov    %dl,(%eax)
 3a6:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3a9:	8b 45 10             	mov    0x10(%ebp),%eax
 3ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3af:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b2:	ba 00 00 00 00       	mov    $0x0,%edx
 3b7:	f7 75 d4             	divl   -0x2c(%ebp)
 3ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3c1:	75 c6                	jne    389 <printint+0x37>
  if(neg)
 3c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3c7:	74 2a                	je     3f3 <printint+0xa1>
    buf[i++] = '-';
 3c9:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3cc:	03 45 f4             	add    -0xc(%ebp),%eax
 3cf:	c6 00 2d             	movb   $0x2d,(%eax)
 3d2:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 3d5:	eb 1d                	jmp    3f4 <printint+0xa2>
    putc(fd, buf[i]);
 3d7:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3da:	03 45 f4             	add    -0xc(%ebp),%eax
 3dd:	8a 00                	mov    (%eax),%al
 3df:	0f be c0             	movsbl %al,%eax
 3e2:	83 ec 08             	sub    $0x8,%esp
 3e5:	50                   	push   %eax
 3e6:	ff 75 08             	pushl  0x8(%ebp)
 3e9:	e8 42 ff ff ff       	call   330 <putc>
 3ee:	83 c4 10             	add    $0x10,%esp
 3f1:	eb 01                	jmp    3f4 <printint+0xa2>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3f3:	90                   	nop
 3f4:	ff 4d f4             	decl   -0xc(%ebp)
 3f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3fb:	79 da                	jns    3d7 <printint+0x85>
    putc(fd, buf[i]);
}
 3fd:	c9                   	leave  
 3fe:	c3                   	ret    

000003ff <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3ff:	55                   	push   %ebp
 400:	89 e5                	mov    %esp,%ebp
 402:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 405:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 40c:	8d 45 0c             	lea    0xc(%ebp),%eax
 40f:	83 c0 04             	add    $0x4,%eax
 412:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 415:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 41c:	e9 58 01 00 00       	jmp    579 <printf+0x17a>
    c = fmt[i] & 0xff;
 421:	8b 55 0c             	mov    0xc(%ebp),%edx
 424:	8b 45 f0             	mov    -0x10(%ebp),%eax
 427:	8d 04 02             	lea    (%edx,%eax,1),%eax
 42a:	8a 00                	mov    (%eax),%al
 42c:	0f be c0             	movsbl %al,%eax
 42f:	25 ff 00 00 00       	and    $0xff,%eax
 434:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 437:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 43b:	75 2c                	jne    469 <printf+0x6a>
      if(c == '%'){
 43d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 441:	75 0c                	jne    44f <printf+0x50>
        state = '%';
 443:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 44a:	e9 27 01 00 00       	jmp    576 <printf+0x177>
      } else {
        putc(fd, c);
 44f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 452:	0f be c0             	movsbl %al,%eax
 455:	83 ec 08             	sub    $0x8,%esp
 458:	50                   	push   %eax
 459:	ff 75 08             	pushl  0x8(%ebp)
 45c:	e8 cf fe ff ff       	call   330 <putc>
 461:	83 c4 10             	add    $0x10,%esp
 464:	e9 0d 01 00 00       	jmp    576 <printf+0x177>
      }
    } else if(state == '%'){
 469:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 46d:	0f 85 03 01 00 00    	jne    576 <printf+0x177>
      if(c == 'd'){
 473:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 477:	75 1e                	jne    497 <printf+0x98>
        printint(fd, *ap, 10, 1);
 479:	8b 45 e8             	mov    -0x18(%ebp),%eax
 47c:	8b 00                	mov    (%eax),%eax
 47e:	6a 01                	push   $0x1
 480:	6a 0a                	push   $0xa
 482:	50                   	push   %eax
 483:	ff 75 08             	pushl  0x8(%ebp)
 486:	e8 c7 fe ff ff       	call   352 <printint>
 48b:	83 c4 10             	add    $0x10,%esp
        ap++;
 48e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 492:	e9 d8 00 00 00       	jmp    56f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 497:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 49b:	74 06                	je     4a3 <printf+0xa4>
 49d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4a1:	75 1e                	jne    4c1 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4a6:	8b 00                	mov    (%eax),%eax
 4a8:	6a 00                	push   $0x0
 4aa:	6a 10                	push   $0x10
 4ac:	50                   	push   %eax
 4ad:	ff 75 08             	pushl  0x8(%ebp)
 4b0:	e8 9d fe ff ff       	call   352 <printint>
 4b5:	83 c4 10             	add    $0x10,%esp
        ap++;
 4b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4bc:	e9 ae 00 00 00       	jmp    56f <printf+0x170>
      } else if(c == 's'){
 4c1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4c5:	75 43                	jne    50a <printf+0x10b>
        s = (char*)*ap;
 4c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ca:	8b 00                	mov    (%eax),%eax
 4cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d7:	75 25                	jne    4fe <printf+0xff>
          s = "(null)";
 4d9:	c7 45 f4 b1 07 00 00 	movl   $0x7b1,-0xc(%ebp)
        while(*s != 0){
 4e0:	eb 1d                	jmp    4ff <printf+0x100>
          putc(fd, *s);
 4e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e5:	8a 00                	mov    (%eax),%al
 4e7:	0f be c0             	movsbl %al,%eax
 4ea:	83 ec 08             	sub    $0x8,%esp
 4ed:	50                   	push   %eax
 4ee:	ff 75 08             	pushl  0x8(%ebp)
 4f1:	e8 3a fe ff ff       	call   330 <putc>
 4f6:	83 c4 10             	add    $0x10,%esp
          s++;
 4f9:	ff 45 f4             	incl   -0xc(%ebp)
 4fc:	eb 01                	jmp    4ff <printf+0x100>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4fe:	90                   	nop
 4ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 502:	8a 00                	mov    (%eax),%al
 504:	84 c0                	test   %al,%al
 506:	75 da                	jne    4e2 <printf+0xe3>
 508:	eb 65                	jmp    56f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 50a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 50e:	75 1d                	jne    52d <printf+0x12e>
        putc(fd, *ap);
 510:	8b 45 e8             	mov    -0x18(%ebp),%eax
 513:	8b 00                	mov    (%eax),%eax
 515:	0f be c0             	movsbl %al,%eax
 518:	83 ec 08             	sub    $0x8,%esp
 51b:	50                   	push   %eax
 51c:	ff 75 08             	pushl  0x8(%ebp)
 51f:	e8 0c fe ff ff       	call   330 <putc>
 524:	83 c4 10             	add    $0x10,%esp
        ap++;
 527:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52b:	eb 42                	jmp    56f <printf+0x170>
      } else if(c == '%'){
 52d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 531:	75 17                	jne    54a <printf+0x14b>
        putc(fd, c);
 533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 536:	0f be c0             	movsbl %al,%eax
 539:	83 ec 08             	sub    $0x8,%esp
 53c:	50                   	push   %eax
 53d:	ff 75 08             	pushl  0x8(%ebp)
 540:	e8 eb fd ff ff       	call   330 <putc>
 545:	83 c4 10             	add    $0x10,%esp
 548:	eb 25                	jmp    56f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 54a:	83 ec 08             	sub    $0x8,%esp
 54d:	6a 25                	push   $0x25
 54f:	ff 75 08             	pushl  0x8(%ebp)
 552:	e8 d9 fd ff ff       	call   330 <putc>
 557:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 55a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 55d:	0f be c0             	movsbl %al,%eax
 560:	83 ec 08             	sub    $0x8,%esp
 563:	50                   	push   %eax
 564:	ff 75 08             	pushl  0x8(%ebp)
 567:	e8 c4 fd ff ff       	call   330 <putc>
 56c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 56f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 576:	ff 45 f0             	incl   -0x10(%ebp)
 579:	8b 55 0c             	mov    0xc(%ebp),%edx
 57c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 57f:	8d 04 02             	lea    (%edx,%eax,1),%eax
 582:	8a 00                	mov    (%eax),%al
 584:	84 c0                	test   %al,%al
 586:	0f 85 95 fe ff ff    	jne    421 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 58c:	c9                   	leave  
 58d:	c3                   	ret    
 58e:	90                   	nop
 58f:	90                   	nop

00000590 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 596:	8b 45 08             	mov    0x8(%ebp),%eax
 599:	83 e8 08             	sub    $0x8,%eax
 59c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 59f:	a1 d4 07 00 00       	mov    0x7d4,%eax
 5a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5a7:	eb 24                	jmp    5cd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ac:	8b 00                	mov    (%eax),%eax
 5ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5b1:	77 12                	ja     5c5 <free+0x35>
 5b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5b9:	77 24                	ja     5df <free+0x4f>
 5bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5be:	8b 00                	mov    (%eax),%eax
 5c0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5c3:	77 1a                	ja     5df <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5c8:	8b 00                	mov    (%eax),%eax
 5ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5d0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5d3:	76 d4                	jbe    5a9 <free+0x19>
 5d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d8:	8b 00                	mov    (%eax),%eax
 5da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5dd:	76 ca                	jbe    5a9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e2:	8b 40 04             	mov    0x4(%eax),%eax
 5e5:	c1 e0 03             	shl    $0x3,%eax
 5e8:	89 c2                	mov    %eax,%edx
 5ea:	03 55 f8             	add    -0x8(%ebp),%edx
 5ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f0:	8b 00                	mov    (%eax),%eax
 5f2:	39 c2                	cmp    %eax,%edx
 5f4:	75 24                	jne    61a <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 5f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f9:	8b 50 04             	mov    0x4(%eax),%edx
 5fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ff:	8b 00                	mov    (%eax),%eax
 601:	8b 40 04             	mov    0x4(%eax),%eax
 604:	01 c2                	add    %eax,%edx
 606:	8b 45 f8             	mov    -0x8(%ebp),%eax
 609:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 60c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60f:	8b 00                	mov    (%eax),%eax
 611:	8b 10                	mov    (%eax),%edx
 613:	8b 45 f8             	mov    -0x8(%ebp),%eax
 616:	89 10                	mov    %edx,(%eax)
 618:	eb 0a                	jmp    624 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 61a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61d:	8b 10                	mov    (%eax),%edx
 61f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 622:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 624:	8b 45 fc             	mov    -0x4(%ebp),%eax
 627:	8b 40 04             	mov    0x4(%eax),%eax
 62a:	c1 e0 03             	shl    $0x3,%eax
 62d:	03 45 fc             	add    -0x4(%ebp),%eax
 630:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 633:	75 20                	jne    655 <free+0xc5>
    p->s.size += bp->s.size;
 635:	8b 45 fc             	mov    -0x4(%ebp),%eax
 638:	8b 50 04             	mov    0x4(%eax),%edx
 63b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63e:	8b 40 04             	mov    0x4(%eax),%eax
 641:	01 c2                	add    %eax,%edx
 643:	8b 45 fc             	mov    -0x4(%ebp),%eax
 646:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 649:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64c:	8b 10                	mov    (%eax),%edx
 64e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 651:	89 10                	mov    %edx,(%eax)
 653:	eb 08                	jmp    65d <free+0xcd>
  } else
    p->s.ptr = bp;
 655:	8b 45 fc             	mov    -0x4(%ebp),%eax
 658:	8b 55 f8             	mov    -0x8(%ebp),%edx
 65b:	89 10                	mov    %edx,(%eax)
  freep = p;
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	a3 d4 07 00 00       	mov    %eax,0x7d4
}
 665:	c9                   	leave  
 666:	c3                   	ret    

00000667 <morecore>:

static Header*
morecore(uint nu)
{
 667:	55                   	push   %ebp
 668:	89 e5                	mov    %esp,%ebp
 66a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 66d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 674:	77 07                	ja     67d <morecore+0x16>
    nu = 4096;
 676:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 67d:	8b 45 08             	mov    0x8(%ebp),%eax
 680:	c1 e0 03             	shl    $0x3,%eax
 683:	83 ec 0c             	sub    $0xc,%esp
 686:	50                   	push   %eax
 687:	e8 8c fc ff ff       	call   318 <sbrk>
 68c:	83 c4 10             	add    $0x10,%esp
 68f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 692:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 696:	75 07                	jne    69f <morecore+0x38>
    return 0;
 698:	b8 00 00 00 00       	mov    $0x0,%eax
 69d:	eb 26                	jmp    6c5 <morecore+0x5e>
  hp = (Header*)p;
 69f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a8:	8b 55 08             	mov    0x8(%ebp),%edx
 6ab:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b1:	83 c0 08             	add    $0x8,%eax
 6b4:	83 ec 0c             	sub    $0xc,%esp
 6b7:	50                   	push   %eax
 6b8:	e8 d3 fe ff ff       	call   590 <free>
 6bd:	83 c4 10             	add    $0x10,%esp
  return freep;
 6c0:	a1 d4 07 00 00       	mov    0x7d4,%eax
}
 6c5:	c9                   	leave  
 6c6:	c3                   	ret    

000006c7 <malloc>:

void*
malloc(uint nbytes)
{
 6c7:	55                   	push   %ebp
 6c8:	89 e5                	mov    %esp,%ebp
 6ca:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6cd:	8b 45 08             	mov    0x8(%ebp),%eax
 6d0:	83 c0 07             	add    $0x7,%eax
 6d3:	c1 e8 03             	shr    $0x3,%eax
 6d6:	40                   	inc    %eax
 6d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6da:	a1 d4 07 00 00       	mov    0x7d4,%eax
 6df:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6e6:	75 23                	jne    70b <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 6e8:	c7 45 f0 cc 07 00 00 	movl   $0x7cc,-0x10(%ebp)
 6ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f2:	a3 d4 07 00 00       	mov    %eax,0x7d4
 6f7:	a1 d4 07 00 00       	mov    0x7d4,%eax
 6fc:	a3 cc 07 00 00       	mov    %eax,0x7cc
    base.s.size = 0;
 701:	c7 05 d0 07 00 00 00 	movl   $0x0,0x7d0
 708:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 70b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70e:	8b 00                	mov    (%eax),%eax
 710:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 713:	8b 45 f4             	mov    -0xc(%ebp),%eax
 716:	8b 40 04             	mov    0x4(%eax),%eax
 719:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 71c:	72 4d                	jb     76b <malloc+0xa4>
      if(p->s.size == nunits)
 71e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 721:	8b 40 04             	mov    0x4(%eax),%eax
 724:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 727:	75 0c                	jne    735 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 729:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72c:	8b 10                	mov    (%eax),%edx
 72e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 731:	89 10                	mov    %edx,(%eax)
 733:	eb 26                	jmp    75b <malloc+0x94>
      else {
        p->s.size -= nunits;
 735:	8b 45 f4             	mov    -0xc(%ebp),%eax
 738:	8b 40 04             	mov    0x4(%eax),%eax
 73b:	89 c2                	mov    %eax,%edx
 73d:	2b 55 ec             	sub    -0x14(%ebp),%edx
 740:	8b 45 f4             	mov    -0xc(%ebp),%eax
 743:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 746:	8b 45 f4             	mov    -0xc(%ebp),%eax
 749:	8b 40 04             	mov    0x4(%eax),%eax
 74c:	c1 e0 03             	shl    $0x3,%eax
 74f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 752:	8b 45 f4             	mov    -0xc(%ebp),%eax
 755:	8b 55 ec             	mov    -0x14(%ebp),%edx
 758:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 75b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75e:	a3 d4 07 00 00       	mov    %eax,0x7d4
      return (void*)(p + 1);
 763:	8b 45 f4             	mov    -0xc(%ebp),%eax
 766:	83 c0 08             	add    $0x8,%eax
 769:	eb 3b                	jmp    7a6 <malloc+0xdf>
    }
    if(p == freep)
 76b:	a1 d4 07 00 00       	mov    0x7d4,%eax
 770:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 773:	75 1e                	jne    793 <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 775:	83 ec 0c             	sub    $0xc,%esp
 778:	ff 75 ec             	pushl  -0x14(%ebp)
 77b:	e8 e7 fe ff ff       	call   667 <morecore>
 780:	83 c4 10             	add    $0x10,%esp
 783:	89 45 f4             	mov    %eax,-0xc(%ebp)
 786:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 78a:	75 07                	jne    793 <malloc+0xcc>
        return 0;
 78c:	b8 00 00 00 00       	mov    $0x0,%eax
 791:	eb 13                	jmp    7a6 <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 793:	8b 45 f4             	mov    -0xc(%ebp),%eax
 796:	89 45 f0             	mov    %eax,-0x10(%ebp)
 799:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79c:	8b 00                	mov    (%eax),%eax
 79e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7a1:	e9 6d ff ff ff       	jmp    713 <malloc+0x4c>
}
 7a6:	c9                   	leave  
 7a7:	c3                   	ret    
