
_rm:     file format elf32-i386


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

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "Usage: rm files...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 d0 07 00 00       	push   $0x7d0
  21:	6a 02                	push   $0x2
  23:	e8 ff 03 00 00       	call   427 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 88 02 00 00       	call   2b8 <exit>
  }

  for(i = 1; i < argc; i++){
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 3e                	jmp    77 <main+0x77>
    if(unlink(argv[i]) < 0){
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	c1 e0 02             	shl    $0x2,%eax
  3f:	03 43 04             	add    0x4(%ebx),%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	83 ec 0c             	sub    $0xc,%esp
  47:	50                   	push   %eax
  48:	e8 bb 02 00 00       	call   308 <unlink>
  4d:	83 c4 10             	add    $0x10,%esp
  50:	85 c0                	test   %eax,%eax
  52:	79 20                	jns    74 <main+0x74>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  57:	c1 e0 02             	shl    $0x2,%eax
  5a:	03 43 04             	add    0x4(%ebx),%eax
  5d:	8b 00                	mov    (%eax),%eax
  5f:	83 ec 04             	sub    $0x4,%esp
  62:	50                   	push   %eax
  63:	68 e4 07 00 00       	push   $0x7e4
  68:	6a 02                	push   $0x2
  6a:	e8 b8 03 00 00       	call   427 <printf>
  6f:	83 c4 10             	add    $0x10,%esp
      break;
  72:	eb 0a                	jmp    7e <main+0x7e>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  74:	ff 45 f4             	incl   -0xc(%ebp)
  77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  7a:	3b 03                	cmp    (%ebx),%eax
  7c:	7c bb                	jl     39 <main+0x39>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  7e:	e8 35 02 00 00       	call   2b8 <exit>
  83:	90                   	nop

00000084 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	57                   	push   %edi
  88:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8c:	8b 55 10             	mov    0x10(%ebp),%edx
  8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  92:	89 cb                	mov    %ecx,%ebx
  94:	89 df                	mov    %ebx,%edi
  96:	89 d1                	mov    %edx,%ecx
  98:	fc                   	cld    
  99:	f3 aa                	rep stos %al,%es:(%edi)
  9b:	89 ca                	mov    %ecx,%edx
  9d:	89 fb                	mov    %edi,%ebx
  9f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  a2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  a5:	5b                   	pop    %ebx
  a6:	5f                   	pop    %edi
  a7:	c9                   	leave  
  a8:	c3                   	ret    

000000a9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a9:	55                   	push   %ebp
  aa:	89 e5                	mov    %esp,%ebp
  ac:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  af:	8b 45 08             	mov    0x8(%ebp),%eax
  b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  b5:	90                   	nop
  b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  b9:	8a 10                	mov    (%eax),%dl
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	88 10                	mov    %dl,(%eax)
  c0:	8b 45 08             	mov    0x8(%ebp),%eax
  c3:	8a 00                	mov    (%eax),%al
  c5:	84 c0                	test   %al,%al
  c7:	0f 95 c0             	setne  %al
  ca:	ff 45 08             	incl   0x8(%ebp)
  cd:	ff 45 0c             	incl   0xc(%ebp)
  d0:	84 c0                	test   %al,%al
  d2:	75 e2                	jne    b6 <strcpy+0xd>
    ;
  return os;
  d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d7:	c9                   	leave  
  d8:	c3                   	ret    

000000d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d9:	55                   	push   %ebp
  da:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  dc:	eb 06                	jmp    e4 <strcmp+0xb>
    p++, q++;
  de:	ff 45 08             	incl   0x8(%ebp)
  e1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e4:	8b 45 08             	mov    0x8(%ebp),%eax
  e7:	8a 00                	mov    (%eax),%al
  e9:	84 c0                	test   %al,%al
  eb:	74 0e                	je     fb <strcmp+0x22>
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	8a 10                	mov    (%eax),%dl
  f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  f5:	8a 00                	mov    (%eax),%al
  f7:	38 c2                	cmp    %al,%dl
  f9:	74 e3                	je     de <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	8a 00                	mov    (%eax),%al
 100:	0f b6 d0             	movzbl %al,%edx
 103:	8b 45 0c             	mov    0xc(%ebp),%eax
 106:	8a 00                	mov    (%eax),%al
 108:	0f b6 c0             	movzbl %al,%eax
 10b:	89 d1                	mov    %edx,%ecx
 10d:	29 c1                	sub    %eax,%ecx
 10f:	89 c8                	mov    %ecx,%eax
}
 111:	c9                   	leave  
 112:	c3                   	ret    

00000113 <strlen>:

uint
strlen(char *s)
{
 113:	55                   	push   %ebp
 114:	89 e5                	mov    %esp,%ebp
 116:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 119:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 120:	eb 03                	jmp    125 <strlen+0x12>
 122:	ff 45 fc             	incl   -0x4(%ebp)
 125:	8b 45 fc             	mov    -0x4(%ebp),%eax
 128:	03 45 08             	add    0x8(%ebp),%eax
 12b:	8a 00                	mov    (%eax),%al
 12d:	84 c0                	test   %al,%al
 12f:	75 f1                	jne    122 <strlen+0xf>
    ;
  return n;
 131:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 134:	c9                   	leave  
 135:	c3                   	ret    

00000136 <memset>:

void*
memset(void *dst, int c, uint n)
{
 136:	55                   	push   %ebp
 137:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 139:	8b 45 10             	mov    0x10(%ebp),%eax
 13c:	50                   	push   %eax
 13d:	ff 75 0c             	pushl  0xc(%ebp)
 140:	ff 75 08             	pushl  0x8(%ebp)
 143:	e8 3c ff ff ff       	call   84 <stosb>
 148:	83 c4 0c             	add    $0xc,%esp
  return dst;
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 14e:	c9                   	leave  
 14f:	c3                   	ret    

00000150 <strchr>:

char*
strchr(const char *s, char c)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	83 ec 04             	sub    $0x4,%esp
 156:	8b 45 0c             	mov    0xc(%ebp),%eax
 159:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 15c:	eb 12                	jmp    170 <strchr+0x20>
    if(*s == c)
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	8a 00                	mov    (%eax),%al
 163:	3a 45 fc             	cmp    -0x4(%ebp),%al
 166:	75 05                	jne    16d <strchr+0x1d>
      return (char*)s;
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	eb 11                	jmp    17e <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 16d:	ff 45 08             	incl   0x8(%ebp)
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	8a 00                	mov    (%eax),%al
 175:	84 c0                	test   %al,%al
 177:	75 e5                	jne    15e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 179:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17e:	c9                   	leave  
 17f:	c3                   	ret    

00000180 <gets>:

char*
gets(char *buf, int max)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 186:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18d:	eb 38                	jmp    1c7 <gets+0x47>
    cc = read(0, &c, 1);
 18f:	83 ec 04             	sub    $0x4,%esp
 192:	6a 01                	push   $0x1
 194:	8d 45 ef             	lea    -0x11(%ebp),%eax
 197:	50                   	push   %eax
 198:	6a 00                	push   $0x0
 19a:	e8 31 01 00 00       	call   2d0 <read>
 19f:	83 c4 10             	add    $0x10,%esp
 1a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a9:	7e 27                	jle    1d2 <gets+0x52>
      break;
    buf[i++] = c;
 1ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ae:	03 45 08             	add    0x8(%ebp),%eax
 1b1:	8a 55 ef             	mov    -0x11(%ebp),%dl
 1b4:	88 10                	mov    %dl,(%eax)
 1b6:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1b9:	8a 45 ef             	mov    -0x11(%ebp),%al
 1bc:	3c 0a                	cmp    $0xa,%al
 1be:	74 13                	je     1d3 <gets+0x53>
 1c0:	8a 45 ef             	mov    -0x11(%ebp),%al
 1c3:	3c 0d                	cmp    $0xd,%al
 1c5:	74 0c                	je     1d3 <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ca:	40                   	inc    %eax
 1cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ce:	7c bf                	jl     18f <gets+0xf>
 1d0:	eb 01                	jmp    1d3 <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1d2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d6:	03 45 08             	add    0x8(%ebp),%eax
 1d9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1df:	c9                   	leave  
 1e0:	c3                   	ret    

000001e1 <stat>:

int
stat(char *n, struct stat *st)
{
 1e1:	55                   	push   %ebp
 1e2:	89 e5                	mov    %esp,%ebp
 1e4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e7:	83 ec 08             	sub    $0x8,%esp
 1ea:	6a 00                	push   $0x0
 1ec:	ff 75 08             	pushl  0x8(%ebp)
 1ef:	e8 04 01 00 00       	call   2f8 <open>
 1f4:	83 c4 10             	add    $0x10,%esp
 1f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fe:	79 07                	jns    207 <stat+0x26>
    return -1;
 200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 205:	eb 25                	jmp    22c <stat+0x4b>
  r = fstat(fd, st);
 207:	83 ec 08             	sub    $0x8,%esp
 20a:	ff 75 0c             	pushl  0xc(%ebp)
 20d:	ff 75 f4             	pushl  -0xc(%ebp)
 210:	e8 fb 00 00 00       	call   310 <fstat>
 215:	83 c4 10             	add    $0x10,%esp
 218:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 21b:	83 ec 0c             	sub    $0xc,%esp
 21e:	ff 75 f4             	pushl  -0xc(%ebp)
 221:	e8 ba 00 00 00       	call   2e0 <close>
 226:	83 c4 10             	add    $0x10,%esp
  return r;
 229:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 22c:	c9                   	leave  
 22d:	c3                   	ret    

0000022e <atoi>:

int
atoi(const char *s)
{
 22e:	55                   	push   %ebp
 22f:	89 e5                	mov    %esp,%ebp
 231:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 234:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 23b:	eb 22                	jmp    25f <atoi+0x31>
    n = n*10 + *s++ - '0';
 23d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 240:	89 d0                	mov    %edx,%eax
 242:	c1 e0 02             	shl    $0x2,%eax
 245:	01 d0                	add    %edx,%eax
 247:	d1 e0                	shl    %eax
 249:	89 c2                	mov    %eax,%edx
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
 24e:	8a 00                	mov    (%eax),%al
 250:	0f be c0             	movsbl %al,%eax
 253:	8d 04 02             	lea    (%edx,%eax,1),%eax
 256:	83 e8 30             	sub    $0x30,%eax
 259:	89 45 fc             	mov    %eax,-0x4(%ebp)
 25c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	8a 00                	mov    (%eax),%al
 264:	3c 2f                	cmp    $0x2f,%al
 266:	7e 09                	jle    271 <atoi+0x43>
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	8a 00                	mov    (%eax),%al
 26d:	3c 39                	cmp    $0x39,%al
 26f:	7e cc                	jle    23d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 271:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 274:	c9                   	leave  
 275:	c3                   	ret    

00000276 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 276:	55                   	push   %ebp
 277:	89 e5                	mov    %esp,%ebp
 279:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 282:	8b 45 0c             	mov    0xc(%ebp),%eax
 285:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 288:	eb 10                	jmp    29a <memmove+0x24>
    *dst++ = *src++;
 28a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 28d:	8a 10                	mov    (%eax),%dl
 28f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 292:	88 10                	mov    %dl,(%eax)
 294:	ff 45 fc             	incl   -0x4(%ebp)
 297:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 29e:	0f 9f c0             	setg   %al
 2a1:	ff 4d 10             	decl   0x10(%ebp)
 2a4:	84 c0                	test   %al,%al
 2a6:	75 e2                	jne    28a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ab:	c9                   	leave  
 2ac:	c3                   	ret    
 2ad:	90                   	nop
 2ae:	90                   	nop
 2af:	90                   	nop

000002b0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b0:	b8 01 00 00 00       	mov    $0x1,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <exit>:
SYSCALL(exit)
 2b8:	b8 02 00 00 00       	mov    $0x2,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <wait>:
SYSCALL(wait)
 2c0:	b8 03 00 00 00       	mov    $0x3,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <pipe>:
SYSCALL(pipe)
 2c8:	b8 04 00 00 00       	mov    $0x4,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <read>:
SYSCALL(read)
 2d0:	b8 05 00 00 00       	mov    $0x5,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <write>:
SYSCALL(write)
 2d8:	b8 10 00 00 00       	mov    $0x10,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <close>:
SYSCALL(close)
 2e0:	b8 15 00 00 00       	mov    $0x15,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <kill>:
SYSCALL(kill)
 2e8:	b8 06 00 00 00       	mov    $0x6,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <exec>:
SYSCALL(exec)
 2f0:	b8 07 00 00 00       	mov    $0x7,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <open>:
SYSCALL(open)
 2f8:	b8 0f 00 00 00       	mov    $0xf,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <mknod>:
SYSCALL(mknod)
 300:	b8 11 00 00 00       	mov    $0x11,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <unlink>:
SYSCALL(unlink)
 308:	b8 12 00 00 00       	mov    $0x12,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <fstat>:
SYSCALL(fstat)
 310:	b8 08 00 00 00       	mov    $0x8,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <link>:
SYSCALL(link)
 318:	b8 13 00 00 00       	mov    $0x13,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <mkdir>:
SYSCALL(mkdir)
 320:	b8 14 00 00 00       	mov    $0x14,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <chdir>:
SYSCALL(chdir)
 328:	b8 09 00 00 00       	mov    $0x9,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <dup>:
SYSCALL(dup)
 330:	b8 0a 00 00 00       	mov    $0xa,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <getpid>:
SYSCALL(getpid)
 338:	b8 0b 00 00 00       	mov    $0xb,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <sbrk>:
SYSCALL(sbrk)
 340:	b8 0c 00 00 00       	mov    $0xc,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <sleep>:
SYSCALL(sleep)
 348:	b8 0d 00 00 00       	mov    $0xd,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <uptime>:
SYSCALL(uptime)
 350:	b8 0e 00 00 00       	mov    $0xe,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	83 ec 18             	sub    $0x18,%esp
 35e:	8b 45 0c             	mov    0xc(%ebp),%eax
 361:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 364:	83 ec 04             	sub    $0x4,%esp
 367:	6a 01                	push   $0x1
 369:	8d 45 f4             	lea    -0xc(%ebp),%eax
 36c:	50                   	push   %eax
 36d:	ff 75 08             	pushl  0x8(%ebp)
 370:	e8 63 ff ff ff       	call   2d8 <write>
 375:	83 c4 10             	add    $0x10,%esp
}
 378:	c9                   	leave  
 379:	c3                   	ret    

0000037a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 37a:	55                   	push   %ebp
 37b:	89 e5                	mov    %esp,%ebp
 37d:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 380:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 387:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 38b:	74 17                	je     3a4 <printint+0x2a>
 38d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 391:	79 11                	jns    3a4 <printint+0x2a>
    neg = 1;
 393:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 39a:	8b 45 0c             	mov    0xc(%ebp),%eax
 39d:	f7 d8                	neg    %eax
 39f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3a2:	eb 06                	jmp    3aa <printint+0x30>
  } else {
    x = xx;
 3a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b7:	ba 00 00 00 00       	mov    $0x0,%edx
 3bc:	f7 f1                	div    %ecx
 3be:	89 d0                	mov    %edx,%eax
 3c0:	8a 90 04 08 00 00    	mov    0x804(%eax),%dl
 3c6:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3c9:	03 45 f4             	add    -0xc(%ebp),%eax
 3cc:	88 10                	mov    %dl,(%eax)
 3ce:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3d1:	8b 45 10             	mov    0x10(%ebp),%eax
 3d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3da:	ba 00 00 00 00       	mov    $0x0,%edx
 3df:	f7 75 d4             	divl   -0x2c(%ebp)
 3e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3e9:	75 c6                	jne    3b1 <printint+0x37>
  if(neg)
 3eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3ef:	74 2a                	je     41b <printint+0xa1>
    buf[i++] = '-';
 3f1:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3f4:	03 45 f4             	add    -0xc(%ebp),%eax
 3f7:	c6 00 2d             	movb   $0x2d,(%eax)
 3fa:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 3fd:	eb 1d                	jmp    41c <printint+0xa2>
    putc(fd, buf[i]);
 3ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
 402:	03 45 f4             	add    -0xc(%ebp),%eax
 405:	8a 00                	mov    (%eax),%al
 407:	0f be c0             	movsbl %al,%eax
 40a:	83 ec 08             	sub    $0x8,%esp
 40d:	50                   	push   %eax
 40e:	ff 75 08             	pushl  0x8(%ebp)
 411:	e8 42 ff ff ff       	call   358 <putc>
 416:	83 c4 10             	add    $0x10,%esp
 419:	eb 01                	jmp    41c <printint+0xa2>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 41b:	90                   	nop
 41c:	ff 4d f4             	decl   -0xc(%ebp)
 41f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 423:	79 da                	jns    3ff <printint+0x85>
    putc(fd, buf[i]);
}
 425:	c9                   	leave  
 426:	c3                   	ret    

00000427 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 427:	55                   	push   %ebp
 428:	89 e5                	mov    %esp,%ebp
 42a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 42d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 434:	8d 45 0c             	lea    0xc(%ebp),%eax
 437:	83 c0 04             	add    $0x4,%eax
 43a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 43d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 444:	e9 58 01 00 00       	jmp    5a1 <printf+0x17a>
    c = fmt[i] & 0xff;
 449:	8b 55 0c             	mov    0xc(%ebp),%edx
 44c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 44f:	8d 04 02             	lea    (%edx,%eax,1),%eax
 452:	8a 00                	mov    (%eax),%al
 454:	0f be c0             	movsbl %al,%eax
 457:	25 ff 00 00 00       	and    $0xff,%eax
 45c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 45f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 463:	75 2c                	jne    491 <printf+0x6a>
      if(c == '%'){
 465:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 469:	75 0c                	jne    477 <printf+0x50>
        state = '%';
 46b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 472:	e9 27 01 00 00       	jmp    59e <printf+0x177>
      } else {
        putc(fd, c);
 477:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 47a:	0f be c0             	movsbl %al,%eax
 47d:	83 ec 08             	sub    $0x8,%esp
 480:	50                   	push   %eax
 481:	ff 75 08             	pushl  0x8(%ebp)
 484:	e8 cf fe ff ff       	call   358 <putc>
 489:	83 c4 10             	add    $0x10,%esp
 48c:	e9 0d 01 00 00       	jmp    59e <printf+0x177>
      }
    } else if(state == '%'){
 491:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 495:	0f 85 03 01 00 00    	jne    59e <printf+0x177>
      if(c == 'd'){
 49b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 49f:	75 1e                	jne    4bf <printf+0x98>
        printint(fd, *ap, 10, 1);
 4a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4a4:	8b 00                	mov    (%eax),%eax
 4a6:	6a 01                	push   $0x1
 4a8:	6a 0a                	push   $0xa
 4aa:	50                   	push   %eax
 4ab:	ff 75 08             	pushl  0x8(%ebp)
 4ae:	e8 c7 fe ff ff       	call   37a <printint>
 4b3:	83 c4 10             	add    $0x10,%esp
        ap++;
 4b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ba:	e9 d8 00 00 00       	jmp    597 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4bf:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4c3:	74 06                	je     4cb <printf+0xa4>
 4c5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4c9:	75 1e                	jne    4e9 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ce:	8b 00                	mov    (%eax),%eax
 4d0:	6a 00                	push   $0x0
 4d2:	6a 10                	push   $0x10
 4d4:	50                   	push   %eax
 4d5:	ff 75 08             	pushl  0x8(%ebp)
 4d8:	e8 9d fe ff ff       	call   37a <printint>
 4dd:	83 c4 10             	add    $0x10,%esp
        ap++;
 4e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e4:	e9 ae 00 00 00       	jmp    597 <printf+0x170>
      } else if(c == 's'){
 4e9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4ed:	75 43                	jne    532 <printf+0x10b>
        s = (char*)*ap;
 4ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f2:	8b 00                	mov    (%eax),%eax
 4f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4f7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ff:	75 25                	jne    526 <printf+0xff>
          s = "(null)";
 501:	c7 45 f4 fd 07 00 00 	movl   $0x7fd,-0xc(%ebp)
        while(*s != 0){
 508:	eb 1d                	jmp    527 <printf+0x100>
          putc(fd, *s);
 50a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50d:	8a 00                	mov    (%eax),%al
 50f:	0f be c0             	movsbl %al,%eax
 512:	83 ec 08             	sub    $0x8,%esp
 515:	50                   	push   %eax
 516:	ff 75 08             	pushl  0x8(%ebp)
 519:	e8 3a fe ff ff       	call   358 <putc>
 51e:	83 c4 10             	add    $0x10,%esp
          s++;
 521:	ff 45 f4             	incl   -0xc(%ebp)
 524:	eb 01                	jmp    527 <printf+0x100>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 526:	90                   	nop
 527:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52a:	8a 00                	mov    (%eax),%al
 52c:	84 c0                	test   %al,%al
 52e:	75 da                	jne    50a <printf+0xe3>
 530:	eb 65                	jmp    597 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 532:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 536:	75 1d                	jne    555 <printf+0x12e>
        putc(fd, *ap);
 538:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53b:	8b 00                	mov    (%eax),%eax
 53d:	0f be c0             	movsbl %al,%eax
 540:	83 ec 08             	sub    $0x8,%esp
 543:	50                   	push   %eax
 544:	ff 75 08             	pushl  0x8(%ebp)
 547:	e8 0c fe ff ff       	call   358 <putc>
 54c:	83 c4 10             	add    $0x10,%esp
        ap++;
 54f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 553:	eb 42                	jmp    597 <printf+0x170>
      } else if(c == '%'){
 555:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 559:	75 17                	jne    572 <printf+0x14b>
        putc(fd, c);
 55b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 55e:	0f be c0             	movsbl %al,%eax
 561:	83 ec 08             	sub    $0x8,%esp
 564:	50                   	push   %eax
 565:	ff 75 08             	pushl  0x8(%ebp)
 568:	e8 eb fd ff ff       	call   358 <putc>
 56d:	83 c4 10             	add    $0x10,%esp
 570:	eb 25                	jmp    597 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 572:	83 ec 08             	sub    $0x8,%esp
 575:	6a 25                	push   $0x25
 577:	ff 75 08             	pushl  0x8(%ebp)
 57a:	e8 d9 fd ff ff       	call   358 <putc>
 57f:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 585:	0f be c0             	movsbl %al,%eax
 588:	83 ec 08             	sub    $0x8,%esp
 58b:	50                   	push   %eax
 58c:	ff 75 08             	pushl  0x8(%ebp)
 58f:	e8 c4 fd ff ff       	call   358 <putc>
 594:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 597:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 59e:	ff 45 f0             	incl   -0x10(%ebp)
 5a1:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a7:	8d 04 02             	lea    (%edx,%eax,1),%eax
 5aa:	8a 00                	mov    (%eax),%al
 5ac:	84 c0                	test   %al,%al
 5ae:	0f 85 95 fe ff ff    	jne    449 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5b4:	c9                   	leave  
 5b5:	c3                   	ret    
 5b6:	90                   	nop
 5b7:	90                   	nop

000005b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b8:	55                   	push   %ebp
 5b9:	89 e5                	mov    %esp,%ebp
 5bb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5be:	8b 45 08             	mov    0x8(%ebp),%eax
 5c1:	83 e8 08             	sub    $0x8,%eax
 5c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c7:	a1 20 08 00 00       	mov    0x820,%eax
 5cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5cf:	eb 24                	jmp    5f5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d4:	8b 00                	mov    (%eax),%eax
 5d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5d9:	77 12                	ja     5ed <free+0x35>
 5db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e1:	77 24                	ja     607 <free+0x4f>
 5e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e6:	8b 00                	mov    (%eax),%eax
 5e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5eb:	77 1a                	ja     607 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f0:	8b 00                	mov    (%eax),%eax
 5f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5fb:	76 d4                	jbe    5d1 <free+0x19>
 5fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 600:	8b 00                	mov    (%eax),%eax
 602:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 605:	76 ca                	jbe    5d1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 607:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60a:	8b 40 04             	mov    0x4(%eax),%eax
 60d:	c1 e0 03             	shl    $0x3,%eax
 610:	89 c2                	mov    %eax,%edx
 612:	03 55 f8             	add    -0x8(%ebp),%edx
 615:	8b 45 fc             	mov    -0x4(%ebp),%eax
 618:	8b 00                	mov    (%eax),%eax
 61a:	39 c2                	cmp    %eax,%edx
 61c:	75 24                	jne    642 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 61e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 621:	8b 50 04             	mov    0x4(%eax),%edx
 624:	8b 45 fc             	mov    -0x4(%ebp),%eax
 627:	8b 00                	mov    (%eax),%eax
 629:	8b 40 04             	mov    0x4(%eax),%eax
 62c:	01 c2                	add    %eax,%edx
 62e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 631:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 634:	8b 45 fc             	mov    -0x4(%ebp),%eax
 637:	8b 00                	mov    (%eax),%eax
 639:	8b 10                	mov    (%eax),%edx
 63b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63e:	89 10                	mov    %edx,(%eax)
 640:	eb 0a                	jmp    64c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 642:	8b 45 fc             	mov    -0x4(%ebp),%eax
 645:	8b 10                	mov    (%eax),%edx
 647:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	8b 40 04             	mov    0x4(%eax),%eax
 652:	c1 e0 03             	shl    $0x3,%eax
 655:	03 45 fc             	add    -0x4(%ebp),%eax
 658:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65b:	75 20                	jne    67d <free+0xc5>
    p->s.size += bp->s.size;
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	8b 50 04             	mov    0x4(%eax),%edx
 663:	8b 45 f8             	mov    -0x8(%ebp),%eax
 666:	8b 40 04             	mov    0x4(%eax),%eax
 669:	01 c2                	add    %eax,%edx
 66b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 671:	8b 45 f8             	mov    -0x8(%ebp),%eax
 674:	8b 10                	mov    (%eax),%edx
 676:	8b 45 fc             	mov    -0x4(%ebp),%eax
 679:	89 10                	mov    %edx,(%eax)
 67b:	eb 08                	jmp    685 <free+0xcd>
  } else
    p->s.ptr = bp;
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	8b 55 f8             	mov    -0x8(%ebp),%edx
 683:	89 10                	mov    %edx,(%eax)
  freep = p;
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	a3 20 08 00 00       	mov    %eax,0x820
}
 68d:	c9                   	leave  
 68e:	c3                   	ret    

0000068f <morecore>:

static Header*
morecore(uint nu)
{
 68f:	55                   	push   %ebp
 690:	89 e5                	mov    %esp,%ebp
 692:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 695:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 69c:	77 07                	ja     6a5 <morecore+0x16>
    nu = 4096;
 69e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6a5:	8b 45 08             	mov    0x8(%ebp),%eax
 6a8:	c1 e0 03             	shl    $0x3,%eax
 6ab:	83 ec 0c             	sub    $0xc,%esp
 6ae:	50                   	push   %eax
 6af:	e8 8c fc ff ff       	call   340 <sbrk>
 6b4:	83 c4 10             	add    $0x10,%esp
 6b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6ba:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6be:	75 07                	jne    6c7 <morecore+0x38>
    return 0;
 6c0:	b8 00 00 00 00       	mov    $0x0,%eax
 6c5:	eb 26                	jmp    6ed <morecore+0x5e>
  hp = (Header*)p;
 6c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d0:	8b 55 08             	mov    0x8(%ebp),%edx
 6d3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d9:	83 c0 08             	add    $0x8,%eax
 6dc:	83 ec 0c             	sub    $0xc,%esp
 6df:	50                   	push   %eax
 6e0:	e8 d3 fe ff ff       	call   5b8 <free>
 6e5:	83 c4 10             	add    $0x10,%esp
  return freep;
 6e8:	a1 20 08 00 00       	mov    0x820,%eax
}
 6ed:	c9                   	leave  
 6ee:	c3                   	ret    

000006ef <malloc>:

void*
malloc(uint nbytes)
{
 6ef:	55                   	push   %ebp
 6f0:	89 e5                	mov    %esp,%ebp
 6f2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f5:	8b 45 08             	mov    0x8(%ebp),%eax
 6f8:	83 c0 07             	add    $0x7,%eax
 6fb:	c1 e8 03             	shr    $0x3,%eax
 6fe:	40                   	inc    %eax
 6ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 702:	a1 20 08 00 00       	mov    0x820,%eax
 707:	89 45 f0             	mov    %eax,-0x10(%ebp)
 70a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 70e:	75 23                	jne    733 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 710:	c7 45 f0 18 08 00 00 	movl   $0x818,-0x10(%ebp)
 717:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71a:	a3 20 08 00 00       	mov    %eax,0x820
 71f:	a1 20 08 00 00       	mov    0x820,%eax
 724:	a3 18 08 00 00       	mov    %eax,0x818
    base.s.size = 0;
 729:	c7 05 1c 08 00 00 00 	movl   $0x0,0x81c
 730:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 733:	8b 45 f0             	mov    -0x10(%ebp),%eax
 736:	8b 00                	mov    (%eax),%eax
 738:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 73b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73e:	8b 40 04             	mov    0x4(%eax),%eax
 741:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 744:	72 4d                	jb     793 <malloc+0xa4>
      if(p->s.size == nunits)
 746:	8b 45 f4             	mov    -0xc(%ebp),%eax
 749:	8b 40 04             	mov    0x4(%eax),%eax
 74c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 74f:	75 0c                	jne    75d <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 751:	8b 45 f4             	mov    -0xc(%ebp),%eax
 754:	8b 10                	mov    (%eax),%edx
 756:	8b 45 f0             	mov    -0x10(%ebp),%eax
 759:	89 10                	mov    %edx,(%eax)
 75b:	eb 26                	jmp    783 <malloc+0x94>
      else {
        p->s.size -= nunits;
 75d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 760:	8b 40 04             	mov    0x4(%eax),%eax
 763:	89 c2                	mov    %eax,%edx
 765:	2b 55 ec             	sub    -0x14(%ebp),%edx
 768:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 76e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 771:	8b 40 04             	mov    0x4(%eax),%eax
 774:	c1 e0 03             	shl    $0x3,%eax
 777:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 77a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 780:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 783:	8b 45 f0             	mov    -0x10(%ebp),%eax
 786:	a3 20 08 00 00       	mov    %eax,0x820
      return (void*)(p + 1);
 78b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78e:	83 c0 08             	add    $0x8,%eax
 791:	eb 3b                	jmp    7ce <malloc+0xdf>
    }
    if(p == freep)
 793:	a1 20 08 00 00       	mov    0x820,%eax
 798:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 79b:	75 1e                	jne    7bb <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 79d:	83 ec 0c             	sub    $0xc,%esp
 7a0:	ff 75 ec             	pushl  -0x14(%ebp)
 7a3:	e8 e7 fe ff ff       	call   68f <morecore>
 7a8:	83 c4 10             	add    $0x10,%esp
 7ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7b2:	75 07                	jne    7bb <malloc+0xcc>
        return 0;
 7b4:	b8 00 00 00 00       	mov    $0x0,%eax
 7b9:	eb 13                	jmp    7ce <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7be:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c4:	8b 00                	mov    (%eax),%eax
 7c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7c9:	e9 6d ff ff ff       	jmp    73b <malloc+0x4c>
}
 7ce:	c9                   	leave  
 7cf:	c3                   	ret    
