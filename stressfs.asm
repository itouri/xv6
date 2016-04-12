
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	81 ec 28 02 00 00    	sub    $0x228,%esp
  int fd, i;
  char path[] = "stressfs0";
  17:	8d 55 d6             	lea    -0x2a(%ebp),%edx
  1a:	bb c3 08 00 00       	mov    $0x8c3,%ebx
  1f:	b8 0a 00 00 00       	mov    $0xa,%eax
  24:	89 d7                	mov    %edx,%edi
  26:	89 de                	mov    %ebx,%esi
  28:	89 c1                	mov    %eax,%ecx
  2a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  char data[512];

  printf(1, "stressfs starting\n");
  2c:	83 ec 08             	sub    $0x8,%esp
  2f:	68 a0 08 00 00       	push   $0x8a0
  34:	6a 01                	push   $0x1
  36:	e8 bc 04 00 00       	call   4f7 <printf>
  3b:	83 c4 10             	add    $0x10,%esp
  memset(data, 'a', sizeof(data));
  3e:	83 ec 04             	sub    $0x4,%esp
  41:	68 00 02 00 00       	push   $0x200
  46:	6a 61                	push   $0x61
  48:	8d 85 d6 fd ff ff    	lea    -0x22a(%ebp),%eax
  4e:	50                   	push   %eax
  4f:	e8 b2 01 00 00       	call   206 <memset>
  54:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  57:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  5e:	eb 0c                	jmp    6c <main+0x6c>
    if(fork() > 0)
  60:	e8 1b 03 00 00       	call   380 <fork>
  65:	85 c0                	test   %eax,%eax
  67:	7f 0b                	jg     74 <main+0x74>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  69:	ff 45 e4             	incl   -0x1c(%ebp)
  6c:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  70:	7e ee                	jle    60 <main+0x60>
  72:	eb 01                	jmp    75 <main+0x75>
    if(fork() > 0)
      break;
  74:	90                   	nop

  printf(1, "write %d\n", i);
  75:	83 ec 04             	sub    $0x4,%esp
  78:	ff 75 e4             	pushl  -0x1c(%ebp)
  7b:	68 b3 08 00 00       	push   $0x8b3
  80:	6a 01                	push   $0x1
  82:	e8 70 04 00 00       	call   4f7 <printf>
  87:	83 c4 10             	add    $0x10,%esp

  path[8] += i;
  8a:	8a 45 de             	mov    -0x22(%ebp),%al
  8d:	88 c2                	mov    %al,%dl
  8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  92:	8d 04 02             	lea    (%edx,%eax,1),%eax
  95:	88 45 de             	mov    %al,-0x22(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  98:	83 ec 08             	sub    $0x8,%esp
  9b:	68 02 02 00 00       	push   $0x202
  a0:	8d 45 d6             	lea    -0x2a(%ebp),%eax
  a3:	50                   	push   %eax
  a4:	e8 1f 03 00 00       	call   3c8 <open>
  a9:	83 c4 10             	add    $0x10,%esp
  ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < 20; i++)
  af:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  b6:	eb 1d                	jmp    d5 <main+0xd5>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  b8:	83 ec 04             	sub    $0x4,%esp
  bb:	68 00 02 00 00       	push   $0x200
  c0:	8d 85 d6 fd ff ff    	lea    -0x22a(%ebp),%eax
  c6:	50                   	push   %eax
  c7:	ff 75 e0             	pushl  -0x20(%ebp)
  ca:	e8 d9 02 00 00       	call   3a8 <write>
  cf:	83 c4 10             	add    $0x10,%esp

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
  d2:	ff 45 e4             	incl   -0x1c(%ebp)
  d5:	83 7d e4 13          	cmpl   $0x13,-0x1c(%ebp)
  d9:	7e dd                	jle    b8 <main+0xb8>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
  db:	83 ec 0c             	sub    $0xc,%esp
  de:	ff 75 e0             	pushl  -0x20(%ebp)
  e1:	e8 ca 02 00 00       	call   3b0 <close>
  e6:	83 c4 10             	add    $0x10,%esp

  printf(1, "read\n");
  e9:	83 ec 08             	sub    $0x8,%esp
  ec:	68 bd 08 00 00       	push   $0x8bd
  f1:	6a 01                	push   $0x1
  f3:	e8 ff 03 00 00       	call   4f7 <printf>
  f8:	83 c4 10             	add    $0x10,%esp

  fd = open(path, O_RDONLY);
  fb:	83 ec 08             	sub    $0x8,%esp
  fe:	6a 00                	push   $0x0
 100:	8d 45 d6             	lea    -0x2a(%ebp),%eax
 103:	50                   	push   %eax
 104:	e8 bf 02 00 00       	call   3c8 <open>
 109:	83 c4 10             	add    $0x10,%esp
 10c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for (i = 0; i < 20; i++)
 10f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 116:	eb 1d                	jmp    135 <main+0x135>
    read(fd, data, sizeof(data));
 118:	83 ec 04             	sub    $0x4,%esp
 11b:	68 00 02 00 00       	push   $0x200
 120:	8d 85 d6 fd ff ff    	lea    -0x22a(%ebp),%eax
 126:	50                   	push   %eax
 127:	ff 75 e0             	pushl  -0x20(%ebp)
 12a:	e8 71 02 00 00       	call   3a0 <read>
 12f:	83 c4 10             	add    $0x10,%esp
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 132:	ff 45 e4             	incl   -0x1c(%ebp)
 135:	83 7d e4 13          	cmpl   $0x13,-0x1c(%ebp)
 139:	7e dd                	jle    118 <main+0x118>
    read(fd, data, sizeof(data));
  close(fd);
 13b:	83 ec 0c             	sub    $0xc,%esp
 13e:	ff 75 e0             	pushl  -0x20(%ebp)
 141:	e8 6a 02 00 00       	call   3b0 <close>
 146:	83 c4 10             	add    $0x10,%esp

  wait();
 149:	e8 42 02 00 00       	call   390 <wait>
  
  exit();
 14e:	e8 35 02 00 00       	call   388 <exit>
 153:	90                   	nop

00000154 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	57                   	push   %edi
 158:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 159:	8b 4d 08             	mov    0x8(%ebp),%ecx
 15c:	8b 55 10             	mov    0x10(%ebp),%edx
 15f:	8b 45 0c             	mov    0xc(%ebp),%eax
 162:	89 cb                	mov    %ecx,%ebx
 164:	89 df                	mov    %ebx,%edi
 166:	89 d1                	mov    %edx,%ecx
 168:	fc                   	cld    
 169:	f3 aa                	rep stos %al,%es:(%edi)
 16b:	89 ca                	mov    %ecx,%edx
 16d:	89 fb                	mov    %edi,%ebx
 16f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 172:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 175:	5b                   	pop    %ebx
 176:	5f                   	pop    %edi
 177:	c9                   	leave  
 178:	c3                   	ret    

00000179 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 179:	55                   	push   %ebp
 17a:	89 e5                	mov    %esp,%ebp
 17c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 185:	90                   	nop
 186:	8b 45 0c             	mov    0xc(%ebp),%eax
 189:	8a 10                	mov    (%eax),%dl
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	88 10                	mov    %dl,(%eax)
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	8a 00                	mov    (%eax),%al
 195:	84 c0                	test   %al,%al
 197:	0f 95 c0             	setne  %al
 19a:	ff 45 08             	incl   0x8(%ebp)
 19d:	ff 45 0c             	incl   0xc(%ebp)
 1a0:	84 c0                	test   %al,%al
 1a2:	75 e2                	jne    186 <strcpy+0xd>
    ;
  return os;
 1a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a7:	c9                   	leave  
 1a8:	c3                   	ret    

000001a9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a9:	55                   	push   %ebp
 1aa:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1ac:	eb 06                	jmp    1b4 <strcmp+0xb>
    p++, q++;
 1ae:	ff 45 08             	incl   0x8(%ebp)
 1b1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	8a 00                	mov    (%eax),%al
 1b9:	84 c0                	test   %al,%al
 1bb:	74 0e                	je     1cb <strcmp+0x22>
 1bd:	8b 45 08             	mov    0x8(%ebp),%eax
 1c0:	8a 10                	mov    (%eax),%dl
 1c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c5:	8a 00                	mov    (%eax),%al
 1c7:	38 c2                	cmp    %al,%dl
 1c9:	74 e3                	je     1ae <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1cb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ce:	8a 00                	mov    (%eax),%al
 1d0:	0f b6 d0             	movzbl %al,%edx
 1d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d6:	8a 00                	mov    (%eax),%al
 1d8:	0f b6 c0             	movzbl %al,%eax
 1db:	89 d1                	mov    %edx,%ecx
 1dd:	29 c1                	sub    %eax,%ecx
 1df:	89 c8                	mov    %ecx,%eax
}
 1e1:	c9                   	leave  
 1e2:	c3                   	ret    

000001e3 <strlen>:

uint
strlen(char *s)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1f0:	eb 03                	jmp    1f5 <strlen+0x12>
 1f2:	ff 45 fc             	incl   -0x4(%ebp)
 1f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1f8:	03 45 08             	add    0x8(%ebp),%eax
 1fb:	8a 00                	mov    (%eax),%al
 1fd:	84 c0                	test   %al,%al
 1ff:	75 f1                	jne    1f2 <strlen+0xf>
    ;
  return n;
 201:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 204:	c9                   	leave  
 205:	c3                   	ret    

00000206 <memset>:

void*
memset(void *dst, int c, uint n)
{
 206:	55                   	push   %ebp
 207:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 209:	8b 45 10             	mov    0x10(%ebp),%eax
 20c:	50                   	push   %eax
 20d:	ff 75 0c             	pushl  0xc(%ebp)
 210:	ff 75 08             	pushl  0x8(%ebp)
 213:	e8 3c ff ff ff       	call   154 <stosb>
 218:	83 c4 0c             	add    $0xc,%esp
  return dst;
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 21e:	c9                   	leave  
 21f:	c3                   	ret    

00000220 <strchr>:

char*
strchr(const char *s, char c)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	83 ec 04             	sub    $0x4,%esp
 226:	8b 45 0c             	mov    0xc(%ebp),%eax
 229:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 22c:	eb 12                	jmp    240 <strchr+0x20>
    if(*s == c)
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
 231:	8a 00                	mov    (%eax),%al
 233:	3a 45 fc             	cmp    -0x4(%ebp),%al
 236:	75 05                	jne    23d <strchr+0x1d>
      return (char*)s;
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	eb 11                	jmp    24e <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 23d:	ff 45 08             	incl   0x8(%ebp)
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	8a 00                	mov    (%eax),%al
 245:	84 c0                	test   %al,%al
 247:	75 e5                	jne    22e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 249:	b8 00 00 00 00       	mov    $0x0,%eax
}
 24e:	c9                   	leave  
 24f:	c3                   	ret    

00000250 <gets>:

char*
gets(char *buf, int max)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 256:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 25d:	eb 38                	jmp    297 <gets+0x47>
    cc = read(0, &c, 1);
 25f:	83 ec 04             	sub    $0x4,%esp
 262:	6a 01                	push   $0x1
 264:	8d 45 ef             	lea    -0x11(%ebp),%eax
 267:	50                   	push   %eax
 268:	6a 00                	push   $0x0
 26a:	e8 31 01 00 00       	call   3a0 <read>
 26f:	83 c4 10             	add    $0x10,%esp
 272:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 275:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 279:	7e 27                	jle    2a2 <gets+0x52>
      break;
    buf[i++] = c;
 27b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27e:	03 45 08             	add    0x8(%ebp),%eax
 281:	8a 55 ef             	mov    -0x11(%ebp),%dl
 284:	88 10                	mov    %dl,(%eax)
 286:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 289:	8a 45 ef             	mov    -0x11(%ebp),%al
 28c:	3c 0a                	cmp    $0xa,%al
 28e:	74 13                	je     2a3 <gets+0x53>
 290:	8a 45 ef             	mov    -0x11(%ebp),%al
 293:	3c 0d                	cmp    $0xd,%al
 295:	74 0c                	je     2a3 <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 297:	8b 45 f4             	mov    -0xc(%ebp),%eax
 29a:	40                   	inc    %eax
 29b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 29e:	7c bf                	jl     25f <gets+0xf>
 2a0:	eb 01                	jmp    2a3 <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2a2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a6:	03 45 08             	add    0x8(%ebp),%eax
 2a9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2af:	c9                   	leave  
 2b0:	c3                   	ret    

000002b1 <stat>:

int
stat(char *n, struct stat *st)
{
 2b1:	55                   	push   %ebp
 2b2:	89 e5                	mov    %esp,%ebp
 2b4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b7:	83 ec 08             	sub    $0x8,%esp
 2ba:	6a 00                	push   $0x0
 2bc:	ff 75 08             	pushl  0x8(%ebp)
 2bf:	e8 04 01 00 00       	call   3c8 <open>
 2c4:	83 c4 10             	add    $0x10,%esp
 2c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2ce:	79 07                	jns    2d7 <stat+0x26>
    return -1;
 2d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2d5:	eb 25                	jmp    2fc <stat+0x4b>
  r = fstat(fd, st);
 2d7:	83 ec 08             	sub    $0x8,%esp
 2da:	ff 75 0c             	pushl  0xc(%ebp)
 2dd:	ff 75 f4             	pushl  -0xc(%ebp)
 2e0:	e8 fb 00 00 00       	call   3e0 <fstat>
 2e5:	83 c4 10             	add    $0x10,%esp
 2e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2eb:	83 ec 0c             	sub    $0xc,%esp
 2ee:	ff 75 f4             	pushl  -0xc(%ebp)
 2f1:	e8 ba 00 00 00       	call   3b0 <close>
 2f6:	83 c4 10             	add    $0x10,%esp
  return r;
 2f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2fc:	c9                   	leave  
 2fd:	c3                   	ret    

000002fe <atoi>:

int
atoi(const char *s)
{
 2fe:	55                   	push   %ebp
 2ff:	89 e5                	mov    %esp,%ebp
 301:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 304:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 30b:	eb 22                	jmp    32f <atoi+0x31>
    n = n*10 + *s++ - '0';
 30d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 310:	89 d0                	mov    %edx,%eax
 312:	c1 e0 02             	shl    $0x2,%eax
 315:	01 d0                	add    %edx,%eax
 317:	d1 e0                	shl    %eax
 319:	89 c2                	mov    %eax,%edx
 31b:	8b 45 08             	mov    0x8(%ebp),%eax
 31e:	8a 00                	mov    (%eax),%al
 320:	0f be c0             	movsbl %al,%eax
 323:	8d 04 02             	lea    (%edx,%eax,1),%eax
 326:	83 e8 30             	sub    $0x30,%eax
 329:	89 45 fc             	mov    %eax,-0x4(%ebp)
 32c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 32f:	8b 45 08             	mov    0x8(%ebp),%eax
 332:	8a 00                	mov    (%eax),%al
 334:	3c 2f                	cmp    $0x2f,%al
 336:	7e 09                	jle    341 <atoi+0x43>
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	8a 00                	mov    (%eax),%al
 33d:	3c 39                	cmp    $0x39,%al
 33f:	7e cc                	jle    30d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 341:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 344:	c9                   	leave  
 345:	c3                   	ret    

00000346 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 346:	55                   	push   %ebp
 347:	89 e5                	mov    %esp,%ebp
 349:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 34c:	8b 45 08             	mov    0x8(%ebp),%eax
 34f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 352:	8b 45 0c             	mov    0xc(%ebp),%eax
 355:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 358:	eb 10                	jmp    36a <memmove+0x24>
    *dst++ = *src++;
 35a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 35d:	8a 10                	mov    (%eax),%dl
 35f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 362:	88 10                	mov    %dl,(%eax)
 364:	ff 45 fc             	incl   -0x4(%ebp)
 367:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 36a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 36e:	0f 9f c0             	setg   %al
 371:	ff 4d 10             	decl   0x10(%ebp)
 374:	84 c0                	test   %al,%al
 376:	75 e2                	jne    35a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 378:	8b 45 08             	mov    0x8(%ebp),%eax
}
 37b:	c9                   	leave  
 37c:	c3                   	ret    
 37d:	90                   	nop
 37e:	90                   	nop
 37f:	90                   	nop

00000380 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 380:	b8 01 00 00 00       	mov    $0x1,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <exit>:
SYSCALL(exit)
 388:	b8 02 00 00 00       	mov    $0x2,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <wait>:
SYSCALL(wait)
 390:	b8 03 00 00 00       	mov    $0x3,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <pipe>:
SYSCALL(pipe)
 398:	b8 04 00 00 00       	mov    $0x4,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <read>:
SYSCALL(read)
 3a0:	b8 05 00 00 00       	mov    $0x5,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <write>:
SYSCALL(write)
 3a8:	b8 10 00 00 00       	mov    $0x10,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <close>:
SYSCALL(close)
 3b0:	b8 15 00 00 00       	mov    $0x15,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <kill>:
SYSCALL(kill)
 3b8:	b8 06 00 00 00       	mov    $0x6,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <exec>:
SYSCALL(exec)
 3c0:	b8 07 00 00 00       	mov    $0x7,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <open>:
SYSCALL(open)
 3c8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <mknod>:
SYSCALL(mknod)
 3d0:	b8 11 00 00 00       	mov    $0x11,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <unlink>:
SYSCALL(unlink)
 3d8:	b8 12 00 00 00       	mov    $0x12,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <fstat>:
SYSCALL(fstat)
 3e0:	b8 08 00 00 00       	mov    $0x8,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <link>:
SYSCALL(link)
 3e8:	b8 13 00 00 00       	mov    $0x13,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <mkdir>:
SYSCALL(mkdir)
 3f0:	b8 14 00 00 00       	mov    $0x14,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <chdir>:
SYSCALL(chdir)
 3f8:	b8 09 00 00 00       	mov    $0x9,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <dup>:
SYSCALL(dup)
 400:	b8 0a 00 00 00       	mov    $0xa,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <getpid>:
SYSCALL(getpid)
 408:	b8 0b 00 00 00       	mov    $0xb,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <sbrk>:
SYSCALL(sbrk)
 410:	b8 0c 00 00 00       	mov    $0xc,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <sleep>:
SYSCALL(sleep)
 418:	b8 0d 00 00 00       	mov    $0xd,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <uptime>:
SYSCALL(uptime)
 420:	b8 0e 00 00 00       	mov    $0xe,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 428:	55                   	push   %ebp
 429:	89 e5                	mov    %esp,%ebp
 42b:	83 ec 18             	sub    $0x18,%esp
 42e:	8b 45 0c             	mov    0xc(%ebp),%eax
 431:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 434:	83 ec 04             	sub    $0x4,%esp
 437:	6a 01                	push   $0x1
 439:	8d 45 f4             	lea    -0xc(%ebp),%eax
 43c:	50                   	push   %eax
 43d:	ff 75 08             	pushl  0x8(%ebp)
 440:	e8 63 ff ff ff       	call   3a8 <write>
 445:	83 c4 10             	add    $0x10,%esp
}
 448:	c9                   	leave  
 449:	c3                   	ret    

0000044a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44a:	55                   	push   %ebp
 44b:	89 e5                	mov    %esp,%ebp
 44d:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 450:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 457:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 45b:	74 17                	je     474 <printint+0x2a>
 45d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 461:	79 11                	jns    474 <printint+0x2a>
    neg = 1;
 463:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 46a:	8b 45 0c             	mov    0xc(%ebp),%eax
 46d:	f7 d8                	neg    %eax
 46f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 472:	eb 06                	jmp    47a <printint+0x30>
  } else {
    x = xx;
 474:	8b 45 0c             	mov    0xc(%ebp),%eax
 477:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 47a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 481:	8b 4d 10             	mov    0x10(%ebp),%ecx
 484:	8b 45 ec             	mov    -0x14(%ebp),%eax
 487:	ba 00 00 00 00       	mov    $0x0,%edx
 48c:	f7 f1                	div    %ecx
 48e:	89 d0                	mov    %edx,%eax
 490:	8a 90 d4 08 00 00    	mov    0x8d4(%eax),%dl
 496:	8d 45 dc             	lea    -0x24(%ebp),%eax
 499:	03 45 f4             	add    -0xc(%ebp),%eax
 49c:	88 10                	mov    %dl,(%eax)
 49e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 4a1:	8b 45 10             	mov    0x10(%ebp),%eax
 4a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4aa:	ba 00 00 00 00       	mov    $0x0,%edx
 4af:	f7 75 d4             	divl   -0x2c(%ebp)
 4b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b9:	75 c6                	jne    481 <printint+0x37>
  if(neg)
 4bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4bf:	74 2a                	je     4eb <printint+0xa1>
    buf[i++] = '-';
 4c1:	8d 45 dc             	lea    -0x24(%ebp),%eax
 4c4:	03 45 f4             	add    -0xc(%ebp),%eax
 4c7:	c6 00 2d             	movb   $0x2d,(%eax)
 4ca:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 4cd:	eb 1d                	jmp    4ec <printint+0xa2>
    putc(fd, buf[i]);
 4cf:	8d 45 dc             	lea    -0x24(%ebp),%eax
 4d2:	03 45 f4             	add    -0xc(%ebp),%eax
 4d5:	8a 00                	mov    (%eax),%al
 4d7:	0f be c0             	movsbl %al,%eax
 4da:	83 ec 08             	sub    $0x8,%esp
 4dd:	50                   	push   %eax
 4de:	ff 75 08             	pushl  0x8(%ebp)
 4e1:	e8 42 ff ff ff       	call   428 <putc>
 4e6:	83 c4 10             	add    $0x10,%esp
 4e9:	eb 01                	jmp    4ec <printint+0xa2>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4eb:	90                   	nop
 4ec:	ff 4d f4             	decl   -0xc(%ebp)
 4ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f3:	79 da                	jns    4cf <printint+0x85>
    putc(fd, buf[i]);
}
 4f5:	c9                   	leave  
 4f6:	c3                   	ret    

000004f7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4f7:	55                   	push   %ebp
 4f8:	89 e5                	mov    %esp,%ebp
 4fa:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 504:	8d 45 0c             	lea    0xc(%ebp),%eax
 507:	83 c0 04             	add    $0x4,%eax
 50a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 50d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 514:	e9 58 01 00 00       	jmp    671 <printf+0x17a>
    c = fmt[i] & 0xff;
 519:	8b 55 0c             	mov    0xc(%ebp),%edx
 51c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 51f:	8d 04 02             	lea    (%edx,%eax,1),%eax
 522:	8a 00                	mov    (%eax),%al
 524:	0f be c0             	movsbl %al,%eax
 527:	25 ff 00 00 00       	and    $0xff,%eax
 52c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 52f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 533:	75 2c                	jne    561 <printf+0x6a>
      if(c == '%'){
 535:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 539:	75 0c                	jne    547 <printf+0x50>
        state = '%';
 53b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 542:	e9 27 01 00 00       	jmp    66e <printf+0x177>
      } else {
        putc(fd, c);
 547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54a:	0f be c0             	movsbl %al,%eax
 54d:	83 ec 08             	sub    $0x8,%esp
 550:	50                   	push   %eax
 551:	ff 75 08             	pushl  0x8(%ebp)
 554:	e8 cf fe ff ff       	call   428 <putc>
 559:	83 c4 10             	add    $0x10,%esp
 55c:	e9 0d 01 00 00       	jmp    66e <printf+0x177>
      }
    } else if(state == '%'){
 561:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 565:	0f 85 03 01 00 00    	jne    66e <printf+0x177>
      if(c == 'd'){
 56b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 56f:	75 1e                	jne    58f <printf+0x98>
        printint(fd, *ap, 10, 1);
 571:	8b 45 e8             	mov    -0x18(%ebp),%eax
 574:	8b 00                	mov    (%eax),%eax
 576:	6a 01                	push   $0x1
 578:	6a 0a                	push   $0xa
 57a:	50                   	push   %eax
 57b:	ff 75 08             	pushl  0x8(%ebp)
 57e:	e8 c7 fe ff ff       	call   44a <printint>
 583:	83 c4 10             	add    $0x10,%esp
        ap++;
 586:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58a:	e9 d8 00 00 00       	jmp    667 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 58f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 593:	74 06                	je     59b <printf+0xa4>
 595:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 599:	75 1e                	jne    5b9 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 59b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59e:	8b 00                	mov    (%eax),%eax
 5a0:	6a 00                	push   $0x0
 5a2:	6a 10                	push   $0x10
 5a4:	50                   	push   %eax
 5a5:	ff 75 08             	pushl  0x8(%ebp)
 5a8:	e8 9d fe ff ff       	call   44a <printint>
 5ad:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b4:	e9 ae 00 00 00       	jmp    667 <printf+0x170>
      } else if(c == 's'){
 5b9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5bd:	75 43                	jne    602 <printf+0x10b>
        s = (char*)*ap;
 5bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c2:	8b 00                	mov    (%eax),%eax
 5c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5c7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5cf:	75 25                	jne    5f6 <printf+0xff>
          s = "(null)";
 5d1:	c7 45 f4 cd 08 00 00 	movl   $0x8cd,-0xc(%ebp)
        while(*s != 0){
 5d8:	eb 1d                	jmp    5f7 <printf+0x100>
          putc(fd, *s);
 5da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5dd:	8a 00                	mov    (%eax),%al
 5df:	0f be c0             	movsbl %al,%eax
 5e2:	83 ec 08             	sub    $0x8,%esp
 5e5:	50                   	push   %eax
 5e6:	ff 75 08             	pushl  0x8(%ebp)
 5e9:	e8 3a fe ff ff       	call   428 <putc>
 5ee:	83 c4 10             	add    $0x10,%esp
          s++;
 5f1:	ff 45 f4             	incl   -0xc(%ebp)
 5f4:	eb 01                	jmp    5f7 <printf+0x100>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5f6:	90                   	nop
 5f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5fa:	8a 00                	mov    (%eax),%al
 5fc:	84 c0                	test   %al,%al
 5fe:	75 da                	jne    5da <printf+0xe3>
 600:	eb 65                	jmp    667 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 602:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 606:	75 1d                	jne    625 <printf+0x12e>
        putc(fd, *ap);
 608:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60b:	8b 00                	mov    (%eax),%eax
 60d:	0f be c0             	movsbl %al,%eax
 610:	83 ec 08             	sub    $0x8,%esp
 613:	50                   	push   %eax
 614:	ff 75 08             	pushl  0x8(%ebp)
 617:	e8 0c fe ff ff       	call   428 <putc>
 61c:	83 c4 10             	add    $0x10,%esp
        ap++;
 61f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 623:	eb 42                	jmp    667 <printf+0x170>
      } else if(c == '%'){
 625:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 629:	75 17                	jne    642 <printf+0x14b>
        putc(fd, c);
 62b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62e:	0f be c0             	movsbl %al,%eax
 631:	83 ec 08             	sub    $0x8,%esp
 634:	50                   	push   %eax
 635:	ff 75 08             	pushl  0x8(%ebp)
 638:	e8 eb fd ff ff       	call   428 <putc>
 63d:	83 c4 10             	add    $0x10,%esp
 640:	eb 25                	jmp    667 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 642:	83 ec 08             	sub    $0x8,%esp
 645:	6a 25                	push   $0x25
 647:	ff 75 08             	pushl  0x8(%ebp)
 64a:	e8 d9 fd ff ff       	call   428 <putc>
 64f:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 652:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 655:	0f be c0             	movsbl %al,%eax
 658:	83 ec 08             	sub    $0x8,%esp
 65b:	50                   	push   %eax
 65c:	ff 75 08             	pushl  0x8(%ebp)
 65f:	e8 c4 fd ff ff       	call   428 <putc>
 664:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 667:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 66e:	ff 45 f0             	incl   -0x10(%ebp)
 671:	8b 55 0c             	mov    0xc(%ebp),%edx
 674:	8b 45 f0             	mov    -0x10(%ebp),%eax
 677:	8d 04 02             	lea    (%edx,%eax,1),%eax
 67a:	8a 00                	mov    (%eax),%al
 67c:	84 c0                	test   %al,%al
 67e:	0f 85 95 fe ff ff    	jne    519 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 684:	c9                   	leave  
 685:	c3                   	ret    
 686:	90                   	nop
 687:	90                   	nop

00000688 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 688:	55                   	push   %ebp
 689:	89 e5                	mov    %esp,%ebp
 68b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 68e:	8b 45 08             	mov    0x8(%ebp),%eax
 691:	83 e8 08             	sub    $0x8,%eax
 694:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 697:	a1 f0 08 00 00       	mov    0x8f0,%eax
 69c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69f:	eb 24                	jmp    6c5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a9:	77 12                	ja     6bd <free+0x35>
 6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b1:	77 24                	ja     6d7 <free+0x4f>
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	8b 00                	mov    (%eax),%eax
 6b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6bb:	77 1a                	ja     6d7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cb:	76 d4                	jbe    6a1 <free+0x19>
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d5:	76 ca                	jbe    6a1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6da:	8b 40 04             	mov    0x4(%eax),%eax
 6dd:	c1 e0 03             	shl    $0x3,%eax
 6e0:	89 c2                	mov    %eax,%edx
 6e2:	03 55 f8             	add    -0x8(%ebp),%edx
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	39 c2                	cmp    %eax,%edx
 6ec:	75 24                	jne    712 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	8b 50 04             	mov    0x4(%eax),%edx
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	8b 00                	mov    (%eax),%eax
 6f9:	8b 40 04             	mov    0x4(%eax),%eax
 6fc:	01 c2                	add    %eax,%edx
 6fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 701:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	8b 00                	mov    (%eax),%eax
 709:	8b 10                	mov    (%eax),%edx
 70b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70e:	89 10                	mov    %edx,(%eax)
 710:	eb 0a                	jmp    71c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 712:	8b 45 fc             	mov    -0x4(%ebp),%eax
 715:	8b 10                	mov    (%eax),%edx
 717:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 71c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71f:	8b 40 04             	mov    0x4(%eax),%eax
 722:	c1 e0 03             	shl    $0x3,%eax
 725:	03 45 fc             	add    -0x4(%ebp),%eax
 728:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 72b:	75 20                	jne    74d <free+0xc5>
    p->s.size += bp->s.size;
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 50 04             	mov    0x4(%eax),%edx
 733:	8b 45 f8             	mov    -0x8(%ebp),%eax
 736:	8b 40 04             	mov    0x4(%eax),%eax
 739:	01 c2                	add    %eax,%edx
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 741:	8b 45 f8             	mov    -0x8(%ebp),%eax
 744:	8b 10                	mov    (%eax),%edx
 746:	8b 45 fc             	mov    -0x4(%ebp),%eax
 749:	89 10                	mov    %edx,(%eax)
 74b:	eb 08                	jmp    755 <free+0xcd>
  } else
    p->s.ptr = bp;
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	8b 55 f8             	mov    -0x8(%ebp),%edx
 753:	89 10                	mov    %edx,(%eax)
  freep = p;
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	a3 f0 08 00 00       	mov    %eax,0x8f0
}
 75d:	c9                   	leave  
 75e:	c3                   	ret    

0000075f <morecore>:

static Header*
morecore(uint nu)
{
 75f:	55                   	push   %ebp
 760:	89 e5                	mov    %esp,%ebp
 762:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 765:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 76c:	77 07                	ja     775 <morecore+0x16>
    nu = 4096;
 76e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 775:	8b 45 08             	mov    0x8(%ebp),%eax
 778:	c1 e0 03             	shl    $0x3,%eax
 77b:	83 ec 0c             	sub    $0xc,%esp
 77e:	50                   	push   %eax
 77f:	e8 8c fc ff ff       	call   410 <sbrk>
 784:	83 c4 10             	add    $0x10,%esp
 787:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 78a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 78e:	75 07                	jne    797 <morecore+0x38>
    return 0;
 790:	b8 00 00 00 00       	mov    $0x0,%eax
 795:	eb 26                	jmp    7bd <morecore+0x5e>
  hp = (Header*)p;
 797:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 79d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a0:	8b 55 08             	mov    0x8(%ebp),%edx
 7a3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a9:	83 c0 08             	add    $0x8,%eax
 7ac:	83 ec 0c             	sub    $0xc,%esp
 7af:	50                   	push   %eax
 7b0:	e8 d3 fe ff ff       	call   688 <free>
 7b5:	83 c4 10             	add    $0x10,%esp
  return freep;
 7b8:	a1 f0 08 00 00       	mov    0x8f0,%eax
}
 7bd:	c9                   	leave  
 7be:	c3                   	ret    

000007bf <malloc>:

void*
malloc(uint nbytes)
{
 7bf:	55                   	push   %ebp
 7c0:	89 e5                	mov    %esp,%ebp
 7c2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c5:	8b 45 08             	mov    0x8(%ebp),%eax
 7c8:	83 c0 07             	add    $0x7,%eax
 7cb:	c1 e8 03             	shr    $0x3,%eax
 7ce:	40                   	inc    %eax
 7cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7d2:	a1 f0 08 00 00       	mov    0x8f0,%eax
 7d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7de:	75 23                	jne    803 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 7e0:	c7 45 f0 e8 08 00 00 	movl   $0x8e8,-0x10(%ebp)
 7e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ea:	a3 f0 08 00 00       	mov    %eax,0x8f0
 7ef:	a1 f0 08 00 00       	mov    0x8f0,%eax
 7f4:	a3 e8 08 00 00       	mov    %eax,0x8e8
    base.s.size = 0;
 7f9:	c7 05 ec 08 00 00 00 	movl   $0x0,0x8ec
 800:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 803:	8b 45 f0             	mov    -0x10(%ebp),%eax
 806:	8b 00                	mov    (%eax),%eax
 808:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 80b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80e:	8b 40 04             	mov    0x4(%eax),%eax
 811:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 814:	72 4d                	jb     863 <malloc+0xa4>
      if(p->s.size == nunits)
 816:	8b 45 f4             	mov    -0xc(%ebp),%eax
 819:	8b 40 04             	mov    0x4(%eax),%eax
 81c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 81f:	75 0c                	jne    82d <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 821:	8b 45 f4             	mov    -0xc(%ebp),%eax
 824:	8b 10                	mov    (%eax),%edx
 826:	8b 45 f0             	mov    -0x10(%ebp),%eax
 829:	89 10                	mov    %edx,(%eax)
 82b:	eb 26                	jmp    853 <malloc+0x94>
      else {
        p->s.size -= nunits;
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	8b 40 04             	mov    0x4(%eax),%eax
 833:	89 c2                	mov    %eax,%edx
 835:	2b 55 ec             	sub    -0x14(%ebp),%edx
 838:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 83e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 841:	8b 40 04             	mov    0x4(%eax),%eax
 844:	c1 e0 03             	shl    $0x3,%eax
 847:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 84a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 850:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 853:	8b 45 f0             	mov    -0x10(%ebp),%eax
 856:	a3 f0 08 00 00       	mov    %eax,0x8f0
      return (void*)(p + 1);
 85b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85e:	83 c0 08             	add    $0x8,%eax
 861:	eb 3b                	jmp    89e <malloc+0xdf>
    }
    if(p == freep)
 863:	a1 f0 08 00 00       	mov    0x8f0,%eax
 868:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 86b:	75 1e                	jne    88b <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 86d:	83 ec 0c             	sub    $0xc,%esp
 870:	ff 75 ec             	pushl  -0x14(%ebp)
 873:	e8 e7 fe ff ff       	call   75f <morecore>
 878:	83 c4 10             	add    $0x10,%esp
 87b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 87e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 882:	75 07                	jne    88b <malloc+0xcc>
        return 0;
 884:	b8 00 00 00 00       	mov    $0x0,%eax
 889:	eb 13                	jmp    89e <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 891:	8b 45 f4             	mov    -0xc(%ebp),%eax
 894:	8b 00                	mov    (%eax),%eax
 896:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 899:	e9 6d ff ff ff       	jmp    80b <malloc+0x4c>
}
 89e:	c9                   	leave  
 89f:	c3                   	ret    
