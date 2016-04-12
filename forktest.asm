
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
  write(fd, s, strlen(s));
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	ff 75 0c             	pushl  0xc(%ebp)
   c:	e8 92 01 00 00       	call   1a3 <strlen>
  11:	83 c4 10             	add    $0x10,%esp
  14:	83 ec 04             	sub    $0x4,%esp
  17:	50                   	push   %eax
  18:	ff 75 0c             	pushl  0xc(%ebp)
  1b:	ff 75 08             	pushl  0x8(%ebp)
  1e:	e8 45 03 00 00       	call   368 <write>
  23:	83 c4 10             	add    $0x10,%esp
}
  26:	c9                   	leave  
  27:	c3                   	ret    

00000028 <forktest>:

void
forktest(void)
{
  28:	55                   	push   %ebp
  29:	89 e5                	mov    %esp,%ebp
  2b:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
  2e:	83 ec 08             	sub    $0x8,%esp
  31:	68 e8 03 00 00       	push   $0x3e8
  36:	6a 01                	push   $0x1
  38:	e8 c3 ff ff ff       	call   0 <printf>
  3d:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<N; n++){
  40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  47:	eb 1c                	jmp    65 <forktest+0x3d>
    pid = fork();
  49:	e8 f2 02 00 00       	call   340 <fork>
  4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
  51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  55:	78 19                	js     70 <forktest+0x48>
      break;
    if(pid == 0)
  57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  5b:	75 05                	jne    62 <forktest+0x3a>
      exit();
  5d:	e8 e6 02 00 00       	call   348 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<N; n++){
  62:	ff 45 f4             	incl   -0xc(%ebp)
  65:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  6c:	7e db                	jle    49 <forktest+0x21>
  6e:	eb 01                	jmp    71 <forktest+0x49>
    pid = fork();
    if(pid < 0)
      break;
  70:	90                   	nop
    if(pid == 0)
      exit();
  }
  
  if(n == N){
  71:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
  78:	75 41                	jne    bb <forktest+0x93>
    printf(1, "fork claimed to work N times!\n", N);
  7a:	83 ec 04             	sub    $0x4,%esp
  7d:	68 e8 03 00 00       	push   $0x3e8
  82:	68 f4 03 00 00       	push   $0x3f4
  87:	6a 01                	push   $0x1
  89:	e8 72 ff ff ff       	call   0 <printf>
  8e:	83 c4 10             	add    $0x10,%esp
    exit();
  91:	e8 b2 02 00 00       	call   348 <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
  96:	e8 b5 02 00 00       	call   350 <wait>
  9b:	85 c0                	test   %eax,%eax
  9d:	79 17                	jns    b6 <forktest+0x8e>
      printf(1, "wait stopped early\n");
  9f:	83 ec 08             	sub    $0x8,%esp
  a2:	68 13 04 00 00       	push   $0x413
  a7:	6a 01                	push   $0x1
  a9:	e8 52 ff ff ff       	call   0 <printf>
  ae:	83 c4 10             	add    $0x10,%esp
      exit();
  b1:	e8 92 02 00 00       	call   348 <exit>
  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }
  
  for(; n > 0; n--){
  b6:	ff 4d f4             	decl   -0xc(%ebp)
  b9:	eb 01                	jmp    bc <forktest+0x94>
  bb:	90                   	nop
  bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  c0:	7f d4                	jg     96 <forktest+0x6e>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
  c2:	e8 89 02 00 00       	call   350 <wait>
  c7:	83 f8 ff             	cmp    $0xffffffff,%eax
  ca:	74 17                	je     e3 <forktest+0xbb>
    printf(1, "wait got too many\n");
  cc:	83 ec 08             	sub    $0x8,%esp
  cf:	68 27 04 00 00       	push   $0x427
  d4:	6a 01                	push   $0x1
  d6:	e8 25 ff ff ff       	call   0 <printf>
  db:	83 c4 10             	add    $0x10,%esp
    exit();
  de:	e8 65 02 00 00       	call   348 <exit>
  }
  
  printf(1, "fork test OK\n");
  e3:	83 ec 08             	sub    $0x8,%esp
  e6:	68 3a 04 00 00       	push   $0x43a
  eb:	6a 01                	push   $0x1
  ed:	e8 0e ff ff ff       	call   0 <printf>
  f2:	83 c4 10             	add    $0x10,%esp
}
  f5:	c9                   	leave  
  f6:	c3                   	ret    

000000f7 <main>:

int
main(void)
{
  f7:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  fb:	83 e4 f0             	and    $0xfffffff0,%esp
  fe:	ff 71 fc             	pushl  -0x4(%ecx)
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	51                   	push   %ecx
 105:	83 ec 04             	sub    $0x4,%esp
  forktest();
 108:	e8 1b ff ff ff       	call   28 <forktest>
  exit();
 10d:	e8 36 02 00 00       	call   348 <exit>
 112:	90                   	nop
 113:	90                   	nop

00000114 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 119:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11c:	8b 55 10             	mov    0x10(%ebp),%edx
 11f:	8b 45 0c             	mov    0xc(%ebp),%eax
 122:	89 cb                	mov    %ecx,%ebx
 124:	89 df                	mov    %ebx,%edi
 126:	89 d1                	mov    %edx,%ecx
 128:	fc                   	cld    
 129:	f3 aa                	rep stos %al,%es:(%edi)
 12b:	89 ca                	mov    %ecx,%edx
 12d:	89 fb                	mov    %edi,%ebx
 12f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 132:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 135:	5b                   	pop    %ebx
 136:	5f                   	pop    %edi
 137:	c9                   	leave  
 138:	c3                   	ret    

00000139 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 139:	55                   	push   %ebp
 13a:	89 e5                	mov    %esp,%ebp
 13c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 145:	90                   	nop
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	8a 10                	mov    (%eax),%dl
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	88 10                	mov    %dl,(%eax)
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	8a 00                	mov    (%eax),%al
 155:	84 c0                	test   %al,%al
 157:	0f 95 c0             	setne  %al
 15a:	ff 45 08             	incl   0x8(%ebp)
 15d:	ff 45 0c             	incl   0xc(%ebp)
 160:	84 c0                	test   %al,%al
 162:	75 e2                	jne    146 <strcpy+0xd>
    ;
  return os;
 164:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 167:	c9                   	leave  
 168:	c3                   	ret    

00000169 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 169:	55                   	push   %ebp
 16a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 16c:	eb 06                	jmp    174 <strcmp+0xb>
    p++, q++;
 16e:	ff 45 08             	incl   0x8(%ebp)
 171:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	8a 00                	mov    (%eax),%al
 179:	84 c0                	test   %al,%al
 17b:	74 0e                	je     18b <strcmp+0x22>
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	8a 10                	mov    (%eax),%dl
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	8a 00                	mov    (%eax),%al
 187:	38 c2                	cmp    %al,%dl
 189:	74 e3                	je     16e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	8a 00                	mov    (%eax),%al
 190:	0f b6 d0             	movzbl %al,%edx
 193:	8b 45 0c             	mov    0xc(%ebp),%eax
 196:	8a 00                	mov    (%eax),%al
 198:	0f b6 c0             	movzbl %al,%eax
 19b:	89 d1                	mov    %edx,%ecx
 19d:	29 c1                	sub    %eax,%ecx
 19f:	89 c8                	mov    %ecx,%eax
}
 1a1:	c9                   	leave  
 1a2:	c3                   	ret    

000001a3 <strlen>:

uint
strlen(char *s)
{
 1a3:	55                   	push   %ebp
 1a4:	89 e5                	mov    %esp,%ebp
 1a6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b0:	eb 03                	jmp    1b5 <strlen+0x12>
 1b2:	ff 45 fc             	incl   -0x4(%ebp)
 1b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1b8:	03 45 08             	add    0x8(%ebp),%eax
 1bb:	8a 00                	mov    (%eax),%al
 1bd:	84 c0                	test   %al,%al
 1bf:	75 f1                	jne    1b2 <strlen+0xf>
    ;
  return n;
 1c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c4:	c9                   	leave  
 1c5:	c3                   	ret    

000001c6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c6:	55                   	push   %ebp
 1c7:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1c9:	8b 45 10             	mov    0x10(%ebp),%eax
 1cc:	50                   	push   %eax
 1cd:	ff 75 0c             	pushl  0xc(%ebp)
 1d0:	ff 75 08             	pushl  0x8(%ebp)
 1d3:	e8 3c ff ff ff       	call   114 <stosb>
 1d8:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1de:	c9                   	leave  
 1df:	c3                   	ret    

000001e0 <strchr>:

char*
strchr(const char *s, char c)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	83 ec 04             	sub    $0x4,%esp
 1e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e9:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1ec:	eb 12                	jmp    200 <strchr+0x20>
    if(*s == c)
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	8a 00                	mov    (%eax),%al
 1f3:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1f6:	75 05                	jne    1fd <strchr+0x1d>
      return (char*)s;
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
 1fb:	eb 11                	jmp    20e <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1fd:	ff 45 08             	incl   0x8(%ebp)
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	8a 00                	mov    (%eax),%al
 205:	84 c0                	test   %al,%al
 207:	75 e5                	jne    1ee <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 209:	b8 00 00 00 00       	mov    $0x0,%eax
}
 20e:	c9                   	leave  
 20f:	c3                   	ret    

00000210 <gets>:

char*
gets(char *buf, int max)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 216:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 21d:	eb 38                	jmp    257 <gets+0x47>
    cc = read(0, &c, 1);
 21f:	83 ec 04             	sub    $0x4,%esp
 222:	6a 01                	push   $0x1
 224:	8d 45 ef             	lea    -0x11(%ebp),%eax
 227:	50                   	push   %eax
 228:	6a 00                	push   $0x0
 22a:	e8 31 01 00 00       	call   360 <read>
 22f:	83 c4 10             	add    $0x10,%esp
 232:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 235:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 239:	7e 27                	jle    262 <gets+0x52>
      break;
    buf[i++] = c;
 23b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 23e:	03 45 08             	add    0x8(%ebp),%eax
 241:	8a 55 ef             	mov    -0x11(%ebp),%dl
 244:	88 10                	mov    %dl,(%eax)
 246:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 249:	8a 45 ef             	mov    -0x11(%ebp),%al
 24c:	3c 0a                	cmp    $0xa,%al
 24e:	74 13                	je     263 <gets+0x53>
 250:	8a 45 ef             	mov    -0x11(%ebp),%al
 253:	3c 0d                	cmp    $0xd,%al
 255:	74 0c                	je     263 <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 257:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25a:	40                   	inc    %eax
 25b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 25e:	7c bf                	jl     21f <gets+0xf>
 260:	eb 01                	jmp    263 <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 262:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 263:	8b 45 f4             	mov    -0xc(%ebp),%eax
 266:	03 45 08             	add    0x8(%ebp),%eax
 269:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26f:	c9                   	leave  
 270:	c3                   	ret    

00000271 <stat>:

int
stat(char *n, struct stat *st)
{
 271:	55                   	push   %ebp
 272:	89 e5                	mov    %esp,%ebp
 274:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 277:	83 ec 08             	sub    $0x8,%esp
 27a:	6a 00                	push   $0x0
 27c:	ff 75 08             	pushl  0x8(%ebp)
 27f:	e8 04 01 00 00       	call   388 <open>
 284:	83 c4 10             	add    $0x10,%esp
 287:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 28a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 28e:	79 07                	jns    297 <stat+0x26>
    return -1;
 290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 295:	eb 25                	jmp    2bc <stat+0x4b>
  r = fstat(fd, st);
 297:	83 ec 08             	sub    $0x8,%esp
 29a:	ff 75 0c             	pushl  0xc(%ebp)
 29d:	ff 75 f4             	pushl  -0xc(%ebp)
 2a0:	e8 fb 00 00 00       	call   3a0 <fstat>
 2a5:	83 c4 10             	add    $0x10,%esp
 2a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2ab:	83 ec 0c             	sub    $0xc,%esp
 2ae:	ff 75 f4             	pushl  -0xc(%ebp)
 2b1:	e8 ba 00 00 00       	call   370 <close>
 2b6:	83 c4 10             	add    $0x10,%esp
  return r;
 2b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2bc:	c9                   	leave  
 2bd:	c3                   	ret    

000002be <atoi>:

int
atoi(const char *s)
{
 2be:	55                   	push   %ebp
 2bf:	89 e5                	mov    %esp,%ebp
 2c1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2cb:	eb 22                	jmp    2ef <atoi+0x31>
    n = n*10 + *s++ - '0';
 2cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d0:	89 d0                	mov    %edx,%eax
 2d2:	c1 e0 02             	shl    $0x2,%eax
 2d5:	01 d0                	add    %edx,%eax
 2d7:	d1 e0                	shl    %eax
 2d9:	89 c2                	mov    %eax,%edx
 2db:	8b 45 08             	mov    0x8(%ebp),%eax
 2de:	8a 00                	mov    (%eax),%al
 2e0:	0f be c0             	movsbl %al,%eax
 2e3:	8d 04 02             	lea    (%edx,%eax,1),%eax
 2e6:	83 e8 30             	sub    $0x30,%eax
 2e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 2ec:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
 2f2:	8a 00                	mov    (%eax),%al
 2f4:	3c 2f                	cmp    $0x2f,%al
 2f6:	7e 09                	jle    301 <atoi+0x43>
 2f8:	8b 45 08             	mov    0x8(%ebp),%eax
 2fb:	8a 00                	mov    (%eax),%al
 2fd:	3c 39                	cmp    $0x39,%al
 2ff:	7e cc                	jle    2cd <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 301:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 304:	c9                   	leave  
 305:	c3                   	ret    

00000306 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 306:	55                   	push   %ebp
 307:	89 e5                	mov    %esp,%ebp
 309:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 30c:	8b 45 08             	mov    0x8(%ebp),%eax
 30f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 312:	8b 45 0c             	mov    0xc(%ebp),%eax
 315:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 318:	eb 10                	jmp    32a <memmove+0x24>
    *dst++ = *src++;
 31a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 31d:	8a 10                	mov    (%eax),%dl
 31f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 322:	88 10                	mov    %dl,(%eax)
 324:	ff 45 fc             	incl   -0x4(%ebp)
 327:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 32a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 32e:	0f 9f c0             	setg   %al
 331:	ff 4d 10             	decl   0x10(%ebp)
 334:	84 c0                	test   %al,%al
 336:	75 e2                	jne    31a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 338:	8b 45 08             	mov    0x8(%ebp),%eax
}
 33b:	c9                   	leave  
 33c:	c3                   	ret    
 33d:	90                   	nop
 33e:	90                   	nop
 33f:	90                   	nop

00000340 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 340:	b8 01 00 00 00       	mov    $0x1,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <exit>:
SYSCALL(exit)
 348:	b8 02 00 00 00       	mov    $0x2,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <wait>:
SYSCALL(wait)
 350:	b8 03 00 00 00       	mov    $0x3,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <pipe>:
SYSCALL(pipe)
 358:	b8 04 00 00 00       	mov    $0x4,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <read>:
SYSCALL(read)
 360:	b8 05 00 00 00       	mov    $0x5,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <write>:
SYSCALL(write)
 368:	b8 10 00 00 00       	mov    $0x10,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <close>:
SYSCALL(close)
 370:	b8 15 00 00 00       	mov    $0x15,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <kill>:
SYSCALL(kill)
 378:	b8 06 00 00 00       	mov    $0x6,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <exec>:
SYSCALL(exec)
 380:	b8 07 00 00 00       	mov    $0x7,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <open>:
SYSCALL(open)
 388:	b8 0f 00 00 00       	mov    $0xf,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <mknod>:
SYSCALL(mknod)
 390:	b8 11 00 00 00       	mov    $0x11,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <unlink>:
SYSCALL(unlink)
 398:	b8 12 00 00 00       	mov    $0x12,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <fstat>:
SYSCALL(fstat)
 3a0:	b8 08 00 00 00       	mov    $0x8,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <link>:
SYSCALL(link)
 3a8:	b8 13 00 00 00       	mov    $0x13,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <mkdir>:
SYSCALL(mkdir)
 3b0:	b8 14 00 00 00       	mov    $0x14,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <chdir>:
SYSCALL(chdir)
 3b8:	b8 09 00 00 00       	mov    $0x9,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <dup>:
SYSCALL(dup)
 3c0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <getpid>:
SYSCALL(getpid)
 3c8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <sbrk>:
SYSCALL(sbrk)
 3d0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <sleep>:
SYSCALL(sleep)
 3d8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <uptime>:
SYSCALL(uptime)
 3e0:	b8 0e 00 00 00       	mov    $0xe,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    
