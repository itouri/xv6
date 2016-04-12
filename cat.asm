
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 15                	jmp    1d <cat+0x1d>
    write(1, buf, n);
   8:	83 ec 04             	sub    $0x4,%esp
   b:	ff 75 f4             	pushl  -0xc(%ebp)
   e:	68 c0 08 00 00       	push   $0x8c0
  13:	6a 01                	push   $0x1
  15:	e8 3e 03 00 00       	call   358 <write>
  1a:	83 c4 10             	add    $0x10,%esp
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  1d:	83 ec 04             	sub    $0x4,%esp
  20:	68 00 02 00 00       	push   $0x200
  25:	68 c0 08 00 00       	push   $0x8c0
  2a:	ff 75 08             	pushl  0x8(%ebp)
  2d:	e8 1e 03 00 00       	call   350 <read>
  32:	83 c4 10             	add    $0x10,%esp
  35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  3c:	7f ca                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  42:	79 17                	jns    5b <cat+0x5b>
    printf(1, "cat: read error\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 50 08 00 00       	push   $0x850
  4c:	6a 01                	push   $0x1
  4e:	e8 54 04 00 00       	call   4a7 <printf>
  53:	83 c4 10             	add    $0x10,%esp
    exit();
  56:	e8 dd 02 00 00       	call   338 <exit>
  }
}
  5b:	c9                   	leave  
  5c:	c3                   	ret    

0000005d <main>:

int
main(int argc, char *argv[])
{
  5d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  61:	83 e4 f0             	and    $0xfffffff0,%esp
  64:	ff 71 fc             	pushl  -0x4(%ecx)
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	53                   	push   %ebx
  6b:	51                   	push   %ecx
  6c:	83 ec 10             	sub    $0x10,%esp
  6f:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  71:	83 3b 01             	cmpl   $0x1,(%ebx)
  74:	7f 12                	jg     88 <main+0x2b>
    cat(0);
  76:	83 ec 0c             	sub    $0xc,%esp
  79:	6a 00                	push   $0x0
  7b:	e8 80 ff ff ff       	call   0 <cat>
  80:	83 c4 10             	add    $0x10,%esp
    exit();
  83:	e8 b0 02 00 00       	call   338 <exit>
  }

  for(i = 1; i < argc; i++){
  88:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  8f:	eb 64                	jmp    f5 <main+0x98>
    if((fd = open(argv[i], 0)) < 0){
  91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  94:	c1 e0 02             	shl    $0x2,%eax
  97:	03 43 04             	add    0x4(%ebx),%eax
  9a:	8b 00                	mov    (%eax),%eax
  9c:	83 ec 08             	sub    $0x8,%esp
  9f:	6a 00                	push   $0x0
  a1:	50                   	push   %eax
  a2:	e8 d1 02 00 00       	call   378 <open>
  a7:	83 c4 10             	add    $0x10,%esp
  aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  b1:	79 23                	jns    d6 <main+0x79>
      printf(1, "cat: cannot open %s\n", argv[i]);
  b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b6:	c1 e0 02             	shl    $0x2,%eax
  b9:	03 43 04             	add    0x4(%ebx),%eax
  bc:	8b 00                	mov    (%eax),%eax
  be:	83 ec 04             	sub    $0x4,%esp
  c1:	50                   	push   %eax
  c2:	68 61 08 00 00       	push   $0x861
  c7:	6a 01                	push   $0x1
  c9:	e8 d9 03 00 00       	call   4a7 <printf>
  ce:	83 c4 10             	add    $0x10,%esp
      exit();
  d1:	e8 62 02 00 00       	call   338 <exit>
    }
    cat(fd);
  d6:	83 ec 0c             	sub    $0xc,%esp
  d9:	ff 75 f0             	pushl  -0x10(%ebp)
  dc:	e8 1f ff ff ff       	call   0 <cat>
  e1:	83 c4 10             	add    $0x10,%esp
    close(fd);
  e4:	83 ec 0c             	sub    $0xc,%esp
  e7:	ff 75 f0             	pushl  -0x10(%ebp)
  ea:	e8 71 02 00 00       	call   360 <close>
  ef:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  f2:	ff 45 f4             	incl   -0xc(%ebp)
  f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  f8:	3b 03                	cmp    (%ebx),%eax
  fa:	7c 95                	jl     91 <main+0x34>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
  fc:	e8 37 02 00 00       	call   338 <exit>
 101:	90                   	nop
 102:	90                   	nop
 103:	90                   	nop

00000104 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	57                   	push   %edi
 108:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 109:	8b 4d 08             	mov    0x8(%ebp),%ecx
 10c:	8b 55 10             	mov    0x10(%ebp),%edx
 10f:	8b 45 0c             	mov    0xc(%ebp),%eax
 112:	89 cb                	mov    %ecx,%ebx
 114:	89 df                	mov    %ebx,%edi
 116:	89 d1                	mov    %edx,%ecx
 118:	fc                   	cld    
 119:	f3 aa                	rep stos %al,%es:(%edi)
 11b:	89 ca                	mov    %ecx,%edx
 11d:	89 fb                	mov    %edi,%ebx
 11f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 122:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 125:	5b                   	pop    %ebx
 126:	5f                   	pop    %edi
 127:	c9                   	leave  
 128:	c3                   	ret    

00000129 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 129:	55                   	push   %ebp
 12a:	89 e5                	mov    %esp,%ebp
 12c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 12f:	8b 45 08             	mov    0x8(%ebp),%eax
 132:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 135:	90                   	nop
 136:	8b 45 0c             	mov    0xc(%ebp),%eax
 139:	8a 10                	mov    (%eax),%dl
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	88 10                	mov    %dl,(%eax)
 140:	8b 45 08             	mov    0x8(%ebp),%eax
 143:	8a 00                	mov    (%eax),%al
 145:	84 c0                	test   %al,%al
 147:	0f 95 c0             	setne  %al
 14a:	ff 45 08             	incl   0x8(%ebp)
 14d:	ff 45 0c             	incl   0xc(%ebp)
 150:	84 c0                	test   %al,%al
 152:	75 e2                	jne    136 <strcpy+0xd>
    ;
  return os;
 154:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 157:	c9                   	leave  
 158:	c3                   	ret    

00000159 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 159:	55                   	push   %ebp
 15a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 15c:	eb 06                	jmp    164 <strcmp+0xb>
    p++, q++;
 15e:	ff 45 08             	incl   0x8(%ebp)
 161:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	8a 00                	mov    (%eax),%al
 169:	84 c0                	test   %al,%al
 16b:	74 0e                	je     17b <strcmp+0x22>
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	8a 10                	mov    (%eax),%dl
 172:	8b 45 0c             	mov    0xc(%ebp),%eax
 175:	8a 00                	mov    (%eax),%al
 177:	38 c2                	cmp    %al,%dl
 179:	74 e3                	je     15e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	8a 00                	mov    (%eax),%al
 180:	0f b6 d0             	movzbl %al,%edx
 183:	8b 45 0c             	mov    0xc(%ebp),%eax
 186:	8a 00                	mov    (%eax),%al
 188:	0f b6 c0             	movzbl %al,%eax
 18b:	89 d1                	mov    %edx,%ecx
 18d:	29 c1                	sub    %eax,%ecx
 18f:	89 c8                	mov    %ecx,%eax
}
 191:	c9                   	leave  
 192:	c3                   	ret    

00000193 <strlen>:

uint
strlen(char *s)
{
 193:	55                   	push   %ebp
 194:	89 e5                	mov    %esp,%ebp
 196:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 199:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a0:	eb 03                	jmp    1a5 <strlen+0x12>
 1a2:	ff 45 fc             	incl   -0x4(%ebp)
 1a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1a8:	03 45 08             	add    0x8(%ebp),%eax
 1ab:	8a 00                	mov    (%eax),%al
 1ad:	84 c0                	test   %al,%al
 1af:	75 f1                	jne    1a2 <strlen+0xf>
    ;
  return n;
 1b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b4:	c9                   	leave  
 1b5:	c3                   	ret    

000001b6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1b9:	8b 45 10             	mov    0x10(%ebp),%eax
 1bc:	50                   	push   %eax
 1bd:	ff 75 0c             	pushl  0xc(%ebp)
 1c0:	ff 75 08             	pushl  0x8(%ebp)
 1c3:	e8 3c ff ff ff       	call   104 <stosb>
 1c8:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ce:	c9                   	leave  
 1cf:	c3                   	ret    

000001d0 <strchr>:

char*
strchr(const char *s, char c)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	83 ec 04             	sub    $0x4,%esp
 1d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d9:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1dc:	eb 12                	jmp    1f0 <strchr+0x20>
    if(*s == c)
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
 1e1:	8a 00                	mov    (%eax),%al
 1e3:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1e6:	75 05                	jne    1ed <strchr+0x1d>
      return (char*)s;
 1e8:	8b 45 08             	mov    0x8(%ebp),%eax
 1eb:	eb 11                	jmp    1fe <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1ed:	ff 45 08             	incl   0x8(%ebp)
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	8a 00                	mov    (%eax),%al
 1f5:	84 c0                	test   %al,%al
 1f7:	75 e5                	jne    1de <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1fe:	c9                   	leave  
 1ff:	c3                   	ret    

00000200 <gets>:

char*
gets(char *buf, int max)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 206:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 20d:	eb 38                	jmp    247 <gets+0x47>
    cc = read(0, &c, 1);
 20f:	83 ec 04             	sub    $0x4,%esp
 212:	6a 01                	push   $0x1
 214:	8d 45 ef             	lea    -0x11(%ebp),%eax
 217:	50                   	push   %eax
 218:	6a 00                	push   $0x0
 21a:	e8 31 01 00 00       	call   350 <read>
 21f:	83 c4 10             	add    $0x10,%esp
 222:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 225:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 229:	7e 27                	jle    252 <gets+0x52>
      break;
    buf[i++] = c;
 22b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 22e:	03 45 08             	add    0x8(%ebp),%eax
 231:	8a 55 ef             	mov    -0x11(%ebp),%dl
 234:	88 10                	mov    %dl,(%eax)
 236:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 239:	8a 45 ef             	mov    -0x11(%ebp),%al
 23c:	3c 0a                	cmp    $0xa,%al
 23e:	74 13                	je     253 <gets+0x53>
 240:	8a 45 ef             	mov    -0x11(%ebp),%al
 243:	3c 0d                	cmp    $0xd,%al
 245:	74 0c                	je     253 <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 247:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24a:	40                   	inc    %eax
 24b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 24e:	7c bf                	jl     20f <gets+0xf>
 250:	eb 01                	jmp    253 <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 252:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 253:	8b 45 f4             	mov    -0xc(%ebp),%eax
 256:	03 45 08             	add    0x8(%ebp),%eax
 259:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 25f:	c9                   	leave  
 260:	c3                   	ret    

00000261 <stat>:

int
stat(char *n, struct stat *st)
{
 261:	55                   	push   %ebp
 262:	89 e5                	mov    %esp,%ebp
 264:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 267:	83 ec 08             	sub    $0x8,%esp
 26a:	6a 00                	push   $0x0
 26c:	ff 75 08             	pushl  0x8(%ebp)
 26f:	e8 04 01 00 00       	call   378 <open>
 274:	83 c4 10             	add    $0x10,%esp
 277:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 27a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 27e:	79 07                	jns    287 <stat+0x26>
    return -1;
 280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 285:	eb 25                	jmp    2ac <stat+0x4b>
  r = fstat(fd, st);
 287:	83 ec 08             	sub    $0x8,%esp
 28a:	ff 75 0c             	pushl  0xc(%ebp)
 28d:	ff 75 f4             	pushl  -0xc(%ebp)
 290:	e8 fb 00 00 00       	call   390 <fstat>
 295:	83 c4 10             	add    $0x10,%esp
 298:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 29b:	83 ec 0c             	sub    $0xc,%esp
 29e:	ff 75 f4             	pushl  -0xc(%ebp)
 2a1:	e8 ba 00 00 00       	call   360 <close>
 2a6:	83 c4 10             	add    $0x10,%esp
  return r;
 2a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2ac:	c9                   	leave  
 2ad:	c3                   	ret    

000002ae <atoi>:

int
atoi(const char *s)
{
 2ae:	55                   	push   %ebp
 2af:	89 e5                	mov    %esp,%ebp
 2b1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2bb:	eb 22                	jmp    2df <atoi+0x31>
    n = n*10 + *s++ - '0';
 2bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2c0:	89 d0                	mov    %edx,%eax
 2c2:	c1 e0 02             	shl    $0x2,%eax
 2c5:	01 d0                	add    %edx,%eax
 2c7:	d1 e0                	shl    %eax
 2c9:	89 c2                	mov    %eax,%edx
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	8a 00                	mov    (%eax),%al
 2d0:	0f be c0             	movsbl %al,%eax
 2d3:	8d 04 02             	lea    (%edx,%eax,1),%eax
 2d6:	83 e8 30             	sub    $0x30,%eax
 2d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 2dc:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	8a 00                	mov    (%eax),%al
 2e4:	3c 2f                	cmp    $0x2f,%al
 2e6:	7e 09                	jle    2f1 <atoi+0x43>
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
 2eb:	8a 00                	mov    (%eax),%al
 2ed:	3c 39                	cmp    $0x39,%al
 2ef:	7e cc                	jle    2bd <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f4:	c9                   	leave  
 2f5:	c3                   	ret    

000002f6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2f6:	55                   	push   %ebp
 2f7:	89 e5                	mov    %esp,%ebp
 2f9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 302:	8b 45 0c             	mov    0xc(%ebp),%eax
 305:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 308:	eb 10                	jmp    31a <memmove+0x24>
    *dst++ = *src++;
 30a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 30d:	8a 10                	mov    (%eax),%dl
 30f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 312:	88 10                	mov    %dl,(%eax)
 314:	ff 45 fc             	incl   -0x4(%ebp)
 317:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 31a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 31e:	0f 9f c0             	setg   %al
 321:	ff 4d 10             	decl   0x10(%ebp)
 324:	84 c0                	test   %al,%al
 326:	75 e2                	jne    30a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 328:	8b 45 08             	mov    0x8(%ebp),%eax
}
 32b:	c9                   	leave  
 32c:	c3                   	ret    
 32d:	90                   	nop
 32e:	90                   	nop
 32f:	90                   	nop

00000330 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 330:	b8 01 00 00 00       	mov    $0x1,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <exit>:
SYSCALL(exit)
 338:	b8 02 00 00 00       	mov    $0x2,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <wait>:
SYSCALL(wait)
 340:	b8 03 00 00 00       	mov    $0x3,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <pipe>:
SYSCALL(pipe)
 348:	b8 04 00 00 00       	mov    $0x4,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <read>:
SYSCALL(read)
 350:	b8 05 00 00 00       	mov    $0x5,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <write>:
SYSCALL(write)
 358:	b8 10 00 00 00       	mov    $0x10,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <close>:
SYSCALL(close)
 360:	b8 15 00 00 00       	mov    $0x15,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <kill>:
SYSCALL(kill)
 368:	b8 06 00 00 00       	mov    $0x6,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <exec>:
SYSCALL(exec)
 370:	b8 07 00 00 00       	mov    $0x7,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <open>:
SYSCALL(open)
 378:	b8 0f 00 00 00       	mov    $0xf,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <mknod>:
SYSCALL(mknod)
 380:	b8 11 00 00 00       	mov    $0x11,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <unlink>:
SYSCALL(unlink)
 388:	b8 12 00 00 00       	mov    $0x12,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <fstat>:
SYSCALL(fstat)
 390:	b8 08 00 00 00       	mov    $0x8,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <link>:
SYSCALL(link)
 398:	b8 13 00 00 00       	mov    $0x13,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <mkdir>:
SYSCALL(mkdir)
 3a0:	b8 14 00 00 00       	mov    $0x14,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <chdir>:
SYSCALL(chdir)
 3a8:	b8 09 00 00 00       	mov    $0x9,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <dup>:
SYSCALL(dup)
 3b0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <getpid>:
SYSCALL(getpid)
 3b8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <sbrk>:
SYSCALL(sbrk)
 3c0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <sleep>:
SYSCALL(sleep)
 3c8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <uptime>:
SYSCALL(uptime)
 3d0:	b8 0e 00 00 00       	mov    $0xe,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3d8:	55                   	push   %ebp
 3d9:	89 e5                	mov    %esp,%ebp
 3db:	83 ec 18             	sub    $0x18,%esp
 3de:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3e4:	83 ec 04             	sub    $0x4,%esp
 3e7:	6a 01                	push   $0x1
 3e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ec:	50                   	push   %eax
 3ed:	ff 75 08             	pushl  0x8(%ebp)
 3f0:	e8 63 ff ff ff       	call   358 <write>
 3f5:	83 c4 10             	add    $0x10,%esp
}
 3f8:	c9                   	leave  
 3f9:	c3                   	ret    

000003fa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3fa:	55                   	push   %ebp
 3fb:	89 e5                	mov    %esp,%ebp
 3fd:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 400:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 407:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 40b:	74 17                	je     424 <printint+0x2a>
 40d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 411:	79 11                	jns    424 <printint+0x2a>
    neg = 1;
 413:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 41a:	8b 45 0c             	mov    0xc(%ebp),%eax
 41d:	f7 d8                	neg    %eax
 41f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 422:	eb 06                	jmp    42a <printint+0x30>
  } else {
    x = xx;
 424:	8b 45 0c             	mov    0xc(%ebp),%eax
 427:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 42a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 431:	8b 4d 10             	mov    0x10(%ebp),%ecx
 434:	8b 45 ec             	mov    -0x14(%ebp),%eax
 437:	ba 00 00 00 00       	mov    $0x0,%edx
 43c:	f7 f1                	div    %ecx
 43e:	89 d0                	mov    %edx,%eax
 440:	8a 90 80 08 00 00    	mov    0x880(%eax),%dl
 446:	8d 45 dc             	lea    -0x24(%ebp),%eax
 449:	03 45 f4             	add    -0xc(%ebp),%eax
 44c:	88 10                	mov    %dl,(%eax)
 44e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 451:	8b 45 10             	mov    0x10(%ebp),%eax
 454:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 457:	8b 45 ec             	mov    -0x14(%ebp),%eax
 45a:	ba 00 00 00 00       	mov    $0x0,%edx
 45f:	f7 75 d4             	divl   -0x2c(%ebp)
 462:	89 45 ec             	mov    %eax,-0x14(%ebp)
 465:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 469:	75 c6                	jne    431 <printint+0x37>
  if(neg)
 46b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 46f:	74 2a                	je     49b <printint+0xa1>
    buf[i++] = '-';
 471:	8d 45 dc             	lea    -0x24(%ebp),%eax
 474:	03 45 f4             	add    -0xc(%ebp),%eax
 477:	c6 00 2d             	movb   $0x2d,(%eax)
 47a:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 47d:	eb 1d                	jmp    49c <printint+0xa2>
    putc(fd, buf[i]);
 47f:	8d 45 dc             	lea    -0x24(%ebp),%eax
 482:	03 45 f4             	add    -0xc(%ebp),%eax
 485:	8a 00                	mov    (%eax),%al
 487:	0f be c0             	movsbl %al,%eax
 48a:	83 ec 08             	sub    $0x8,%esp
 48d:	50                   	push   %eax
 48e:	ff 75 08             	pushl  0x8(%ebp)
 491:	e8 42 ff ff ff       	call   3d8 <putc>
 496:	83 c4 10             	add    $0x10,%esp
 499:	eb 01                	jmp    49c <printint+0xa2>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 49b:	90                   	nop
 49c:	ff 4d f4             	decl   -0xc(%ebp)
 49f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4a3:	79 da                	jns    47f <printint+0x85>
    putc(fd, buf[i]);
}
 4a5:	c9                   	leave  
 4a6:	c3                   	ret    

000004a7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a7:	55                   	push   %ebp
 4a8:	89 e5                	mov    %esp,%ebp
 4aa:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4b4:	8d 45 0c             	lea    0xc(%ebp),%eax
 4b7:	83 c0 04             	add    $0x4,%eax
 4ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4c4:	e9 58 01 00 00       	jmp    621 <printf+0x17a>
    c = fmt[i] & 0xff;
 4c9:	8b 55 0c             	mov    0xc(%ebp),%edx
 4cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4cf:	8d 04 02             	lea    (%edx,%eax,1),%eax
 4d2:	8a 00                	mov    (%eax),%al
 4d4:	0f be c0             	movsbl %al,%eax
 4d7:	25 ff 00 00 00       	and    $0xff,%eax
 4dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e3:	75 2c                	jne    511 <printf+0x6a>
      if(c == '%'){
 4e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4e9:	75 0c                	jne    4f7 <printf+0x50>
        state = '%';
 4eb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4f2:	e9 27 01 00 00       	jmp    61e <printf+0x177>
      } else {
        putc(fd, c);
 4f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4fa:	0f be c0             	movsbl %al,%eax
 4fd:	83 ec 08             	sub    $0x8,%esp
 500:	50                   	push   %eax
 501:	ff 75 08             	pushl  0x8(%ebp)
 504:	e8 cf fe ff ff       	call   3d8 <putc>
 509:	83 c4 10             	add    $0x10,%esp
 50c:	e9 0d 01 00 00       	jmp    61e <printf+0x177>
      }
    } else if(state == '%'){
 511:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 515:	0f 85 03 01 00 00    	jne    61e <printf+0x177>
      if(c == 'd'){
 51b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 51f:	75 1e                	jne    53f <printf+0x98>
        printint(fd, *ap, 10, 1);
 521:	8b 45 e8             	mov    -0x18(%ebp),%eax
 524:	8b 00                	mov    (%eax),%eax
 526:	6a 01                	push   $0x1
 528:	6a 0a                	push   $0xa
 52a:	50                   	push   %eax
 52b:	ff 75 08             	pushl  0x8(%ebp)
 52e:	e8 c7 fe ff ff       	call   3fa <printint>
 533:	83 c4 10             	add    $0x10,%esp
        ap++;
 536:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53a:	e9 d8 00 00 00       	jmp    617 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 53f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 543:	74 06                	je     54b <printf+0xa4>
 545:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 549:	75 1e                	jne    569 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 54b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54e:	8b 00                	mov    (%eax),%eax
 550:	6a 00                	push   $0x0
 552:	6a 10                	push   $0x10
 554:	50                   	push   %eax
 555:	ff 75 08             	pushl  0x8(%ebp)
 558:	e8 9d fe ff ff       	call   3fa <printint>
 55d:	83 c4 10             	add    $0x10,%esp
        ap++;
 560:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 564:	e9 ae 00 00 00       	jmp    617 <printf+0x170>
      } else if(c == 's'){
 569:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 56d:	75 43                	jne    5b2 <printf+0x10b>
        s = (char*)*ap;
 56f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 572:	8b 00                	mov    (%eax),%eax
 574:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 577:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 57b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57f:	75 25                	jne    5a6 <printf+0xff>
          s = "(null)";
 581:	c7 45 f4 76 08 00 00 	movl   $0x876,-0xc(%ebp)
        while(*s != 0){
 588:	eb 1d                	jmp    5a7 <printf+0x100>
          putc(fd, *s);
 58a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58d:	8a 00                	mov    (%eax),%al
 58f:	0f be c0             	movsbl %al,%eax
 592:	83 ec 08             	sub    $0x8,%esp
 595:	50                   	push   %eax
 596:	ff 75 08             	pushl  0x8(%ebp)
 599:	e8 3a fe ff ff       	call   3d8 <putc>
 59e:	83 c4 10             	add    $0x10,%esp
          s++;
 5a1:	ff 45 f4             	incl   -0xc(%ebp)
 5a4:	eb 01                	jmp    5a7 <printf+0x100>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5a6:	90                   	nop
 5a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5aa:	8a 00                	mov    (%eax),%al
 5ac:	84 c0                	test   %al,%al
 5ae:	75 da                	jne    58a <printf+0xe3>
 5b0:	eb 65                	jmp    617 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5b2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5b6:	75 1d                	jne    5d5 <printf+0x12e>
        putc(fd, *ap);
 5b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5bb:	8b 00                	mov    (%eax),%eax
 5bd:	0f be c0             	movsbl %al,%eax
 5c0:	83 ec 08             	sub    $0x8,%esp
 5c3:	50                   	push   %eax
 5c4:	ff 75 08             	pushl  0x8(%ebp)
 5c7:	e8 0c fe ff ff       	call   3d8 <putc>
 5cc:	83 c4 10             	add    $0x10,%esp
        ap++;
 5cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d3:	eb 42                	jmp    617 <printf+0x170>
      } else if(c == '%'){
 5d5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d9:	75 17                	jne    5f2 <printf+0x14b>
        putc(fd, c);
 5db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5de:	0f be c0             	movsbl %al,%eax
 5e1:	83 ec 08             	sub    $0x8,%esp
 5e4:	50                   	push   %eax
 5e5:	ff 75 08             	pushl  0x8(%ebp)
 5e8:	e8 eb fd ff ff       	call   3d8 <putc>
 5ed:	83 c4 10             	add    $0x10,%esp
 5f0:	eb 25                	jmp    617 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f2:	83 ec 08             	sub    $0x8,%esp
 5f5:	6a 25                	push   $0x25
 5f7:	ff 75 08             	pushl  0x8(%ebp)
 5fa:	e8 d9 fd ff ff       	call   3d8 <putc>
 5ff:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 605:	0f be c0             	movsbl %al,%eax
 608:	83 ec 08             	sub    $0x8,%esp
 60b:	50                   	push   %eax
 60c:	ff 75 08             	pushl  0x8(%ebp)
 60f:	e8 c4 fd ff ff       	call   3d8 <putc>
 614:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 617:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 61e:	ff 45 f0             	incl   -0x10(%ebp)
 621:	8b 55 0c             	mov    0xc(%ebp),%edx
 624:	8b 45 f0             	mov    -0x10(%ebp),%eax
 627:	8d 04 02             	lea    (%edx,%eax,1),%eax
 62a:	8a 00                	mov    (%eax),%al
 62c:	84 c0                	test   %al,%al
 62e:	0f 85 95 fe ff ff    	jne    4c9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 634:	c9                   	leave  
 635:	c3                   	ret    
 636:	90                   	nop
 637:	90                   	nop

00000638 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 638:	55                   	push   %ebp
 639:	89 e5                	mov    %esp,%ebp
 63b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 63e:	8b 45 08             	mov    0x8(%ebp),%eax
 641:	83 e8 08             	sub    $0x8,%eax
 644:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 647:	a1 a8 08 00 00       	mov    0x8a8,%eax
 64c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64f:	eb 24                	jmp    675 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 00                	mov    (%eax),%eax
 656:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 659:	77 12                	ja     66d <free+0x35>
 65b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 661:	77 24                	ja     687 <free+0x4f>
 663:	8b 45 fc             	mov    -0x4(%ebp),%eax
 666:	8b 00                	mov    (%eax),%eax
 668:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66b:	77 1a                	ja     687 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	8b 00                	mov    (%eax),%eax
 672:	89 45 fc             	mov    %eax,-0x4(%ebp)
 675:	8b 45 f8             	mov    -0x8(%ebp),%eax
 678:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67b:	76 d4                	jbe    651 <free+0x19>
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	8b 00                	mov    (%eax),%eax
 682:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 685:	76 ca                	jbe    651 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 687:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68a:	8b 40 04             	mov    0x4(%eax),%eax
 68d:	c1 e0 03             	shl    $0x3,%eax
 690:	89 c2                	mov    %eax,%edx
 692:	03 55 f8             	add    -0x8(%ebp),%edx
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	8b 00                	mov    (%eax),%eax
 69a:	39 c2                	cmp    %eax,%edx
 69c:	75 24                	jne    6c2 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 69e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a1:	8b 50 04             	mov    0x4(%eax),%edx
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	8b 00                	mov    (%eax),%eax
 6a9:	8b 40 04             	mov    0x4(%eax),%eax
 6ac:	01 c2                	add    %eax,%edx
 6ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b7:	8b 00                	mov    (%eax),%eax
 6b9:	8b 10                	mov    (%eax),%edx
 6bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6be:	89 10                	mov    %edx,(%eax)
 6c0:	eb 0a                	jmp    6cc <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	8b 10                	mov    (%eax),%edx
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	8b 40 04             	mov    0x4(%eax),%eax
 6d2:	c1 e0 03             	shl    $0x3,%eax
 6d5:	03 45 fc             	add    -0x4(%ebp),%eax
 6d8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6db:	75 20                	jne    6fd <free+0xc5>
    p->s.size += bp->s.size;
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	8b 50 04             	mov    0x4(%eax),%edx
 6e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e6:	8b 40 04             	mov    0x4(%eax),%eax
 6e9:	01 c2                	add    %eax,%edx
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f4:	8b 10                	mov    (%eax),%edx
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	89 10                	mov    %edx,(%eax)
 6fb:	eb 08                	jmp    705 <free+0xcd>
  } else
    p->s.ptr = bp;
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	8b 55 f8             	mov    -0x8(%ebp),%edx
 703:	89 10                	mov    %edx,(%eax)
  freep = p;
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	a3 a8 08 00 00       	mov    %eax,0x8a8
}
 70d:	c9                   	leave  
 70e:	c3                   	ret    

0000070f <morecore>:

static Header*
morecore(uint nu)
{
 70f:	55                   	push   %ebp
 710:	89 e5                	mov    %esp,%ebp
 712:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 715:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 71c:	77 07                	ja     725 <morecore+0x16>
    nu = 4096;
 71e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 725:	8b 45 08             	mov    0x8(%ebp),%eax
 728:	c1 e0 03             	shl    $0x3,%eax
 72b:	83 ec 0c             	sub    $0xc,%esp
 72e:	50                   	push   %eax
 72f:	e8 8c fc ff ff       	call   3c0 <sbrk>
 734:	83 c4 10             	add    $0x10,%esp
 737:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 73a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 73e:	75 07                	jne    747 <morecore+0x38>
    return 0;
 740:	b8 00 00 00 00       	mov    $0x0,%eax
 745:	eb 26                	jmp    76d <morecore+0x5e>
  hp = (Header*)p;
 747:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 74d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 750:	8b 55 08             	mov    0x8(%ebp),%edx
 753:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 756:	8b 45 f0             	mov    -0x10(%ebp),%eax
 759:	83 c0 08             	add    $0x8,%eax
 75c:	83 ec 0c             	sub    $0xc,%esp
 75f:	50                   	push   %eax
 760:	e8 d3 fe ff ff       	call   638 <free>
 765:	83 c4 10             	add    $0x10,%esp
  return freep;
 768:	a1 a8 08 00 00       	mov    0x8a8,%eax
}
 76d:	c9                   	leave  
 76e:	c3                   	ret    

0000076f <malloc>:

void*
malloc(uint nbytes)
{
 76f:	55                   	push   %ebp
 770:	89 e5                	mov    %esp,%ebp
 772:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 775:	8b 45 08             	mov    0x8(%ebp),%eax
 778:	83 c0 07             	add    $0x7,%eax
 77b:	c1 e8 03             	shr    $0x3,%eax
 77e:	40                   	inc    %eax
 77f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 782:	a1 a8 08 00 00       	mov    0x8a8,%eax
 787:	89 45 f0             	mov    %eax,-0x10(%ebp)
 78a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 78e:	75 23                	jne    7b3 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 790:	c7 45 f0 a0 08 00 00 	movl   $0x8a0,-0x10(%ebp)
 797:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79a:	a3 a8 08 00 00       	mov    %eax,0x8a8
 79f:	a1 a8 08 00 00       	mov    0x8a8,%eax
 7a4:	a3 a0 08 00 00       	mov    %eax,0x8a0
    base.s.size = 0;
 7a9:	c7 05 a4 08 00 00 00 	movl   $0x0,0x8a4
 7b0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b6:	8b 00                	mov    (%eax),%eax
 7b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7be:	8b 40 04             	mov    0x4(%eax),%eax
 7c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c4:	72 4d                	jb     813 <malloc+0xa4>
      if(p->s.size == nunits)
 7c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c9:	8b 40 04             	mov    0x4(%eax),%eax
 7cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7cf:	75 0c                	jne    7dd <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	8b 10                	mov    (%eax),%edx
 7d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d9:	89 10                	mov    %edx,(%eax)
 7db:	eb 26                	jmp    803 <malloc+0x94>
      else {
        p->s.size -= nunits;
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	8b 40 04             	mov    0x4(%eax),%eax
 7e3:	89 c2                	mov    %eax,%edx
 7e5:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7eb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f1:	8b 40 04             	mov    0x4(%eax),%eax
 7f4:	c1 e0 03             	shl    $0x3,%eax
 7f7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 800:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 803:	8b 45 f0             	mov    -0x10(%ebp),%eax
 806:	a3 a8 08 00 00       	mov    %eax,0x8a8
      return (void*)(p + 1);
 80b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80e:	83 c0 08             	add    $0x8,%eax
 811:	eb 3b                	jmp    84e <malloc+0xdf>
    }
    if(p == freep)
 813:	a1 a8 08 00 00       	mov    0x8a8,%eax
 818:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 81b:	75 1e                	jne    83b <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 81d:	83 ec 0c             	sub    $0xc,%esp
 820:	ff 75 ec             	pushl  -0x14(%ebp)
 823:	e8 e7 fe ff ff       	call   70f <morecore>
 828:	83 c4 10             	add    $0x10,%esp
 82b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 82e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 832:	75 07                	jne    83b <malloc+0xcc>
        return 0;
 834:	b8 00 00 00 00       	mov    $0x0,%eax
 839:	eb 13                	jmp    84e <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 841:	8b 45 f4             	mov    -0xc(%ebp),%eax
 844:	8b 00                	mov    (%eax),%eax
 846:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 849:	e9 6d ff ff ff       	jmp    7bb <malloc+0x4c>
}
 84e:	c9                   	leave  
 84f:	c3                   	ret    
