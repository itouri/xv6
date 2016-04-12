
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 63                	jmp    85 <wc+0x85>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 52                	jmp    7d <wc+0x7d>
      c++;
  2b:	ff 45 e8             	incl   -0x18(%ebp)
      if(buf[i] == '\n')
  2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  31:	05 60 09 00 00       	add    $0x960,%eax
  36:	8a 00                	mov    (%eax),%al
  38:	3c 0a                	cmp    $0xa,%al
  3a:	75 03                	jne    3f <wc+0x3f>
        l++;
  3c:	ff 45 f0             	incl   -0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  42:	05 60 09 00 00       	add    $0x960,%eax
  47:	8a 00                	mov    (%eax),%al
  49:	0f be c0             	movsbl %al,%eax
  4c:	83 ec 08             	sub    $0x8,%esp
  4f:	50                   	push   %eax
  50:	68 e8 08 00 00       	push   $0x8e8
  55:	e8 0e 02 00 00       	call   268 <strchr>
  5a:	83 c4 10             	add    $0x10,%esp
  5d:	85 c0                	test   %eax,%eax
  5f:	74 09                	je     6a <wc+0x6a>
        inword = 0;
  61:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  68:	eb 10                	jmp    7a <wc+0x7a>
      else if(!inword){
  6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  6e:	75 0a                	jne    7a <wc+0x7a>
        w++;
  70:	ff 45 ec             	incl   -0x14(%ebp)
        inword = 1;
  73:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7a:	ff 45 f4             	incl   -0xc(%ebp)
  7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  83:	7c a6                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  85:	83 ec 04             	sub    $0x4,%esp
  88:	68 00 02 00 00       	push   $0x200
  8d:	68 60 09 00 00       	push   $0x960
  92:	ff 75 08             	pushl  0x8(%ebp)
  95:	e8 4e 03 00 00       	call   3e8 <read>
  9a:	83 c4 10             	add    $0x10,%esp
  9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  a4:	0f 8f 78 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  ae:	79 17                	jns    c7 <wc+0xc7>
    printf(1, "wc: read error\n");
  b0:	83 ec 08             	sub    $0x8,%esp
  b3:	68 ee 08 00 00       	push   $0x8ee
  b8:	6a 01                	push   $0x1
  ba:	e8 80 04 00 00       	call   53f <printf>
  bf:	83 c4 10             	add    $0x10,%esp
    exit();
  c2:	e8 09 03 00 00       	call   3d0 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  c7:	83 ec 08             	sub    $0x8,%esp
  ca:	ff 75 0c             	pushl  0xc(%ebp)
  cd:	ff 75 e8             	pushl  -0x18(%ebp)
  d0:	ff 75 ec             	pushl  -0x14(%ebp)
  d3:	ff 75 f0             	pushl  -0x10(%ebp)
  d6:	68 fe 08 00 00       	push   $0x8fe
  db:	6a 01                	push   $0x1
  dd:	e8 5d 04 00 00       	call   53f <printf>
  e2:	83 c4 20             	add    $0x20,%esp
}
  e5:	c9                   	leave  
  e6:	c3                   	ret    

000000e7 <main>:

int
main(int argc, char *argv[])
{
  e7:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  eb:	83 e4 f0             	and    $0xfffffff0,%esp
  ee:	ff 71 fc             	pushl  -0x4(%ecx)
  f1:	55                   	push   %ebp
  f2:	89 e5                	mov    %esp,%ebp
  f4:	53                   	push   %ebx
  f5:	51                   	push   %ecx
  f6:	83 ec 10             	sub    $0x10,%esp
  f9:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  fb:	83 3b 01             	cmpl   $0x1,(%ebx)
  fe:	7f 17                	jg     117 <main+0x30>
    wc(0, "");
 100:	83 ec 08             	sub    $0x8,%esp
 103:	68 0b 09 00 00       	push   $0x90b
 108:	6a 00                	push   $0x0
 10a:	e8 f1 fe ff ff       	call   0 <wc>
 10f:	83 c4 10             	add    $0x10,%esp
    exit();
 112:	e8 b9 02 00 00       	call   3d0 <exit>
  }

  for(i = 1; i < argc; i++){
 117:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 11e:	eb 70                	jmp    190 <main+0xa9>
    if((fd = open(argv[i], 0)) < 0){
 120:	8b 45 f4             	mov    -0xc(%ebp),%eax
 123:	c1 e0 02             	shl    $0x2,%eax
 126:	03 43 04             	add    0x4(%ebx),%eax
 129:	8b 00                	mov    (%eax),%eax
 12b:	83 ec 08             	sub    $0x8,%esp
 12e:	6a 00                	push   $0x0
 130:	50                   	push   %eax
 131:	e8 da 02 00 00       	call   410 <open>
 136:	83 c4 10             	add    $0x10,%esp
 139:	89 45 f0             	mov    %eax,-0x10(%ebp)
 13c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 140:	79 23                	jns    165 <main+0x7e>
      printf(1, "wc: cannot open %s\n", argv[i]);
 142:	8b 45 f4             	mov    -0xc(%ebp),%eax
 145:	c1 e0 02             	shl    $0x2,%eax
 148:	03 43 04             	add    0x4(%ebx),%eax
 14b:	8b 00                	mov    (%eax),%eax
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	50                   	push   %eax
 151:	68 0c 09 00 00       	push   $0x90c
 156:	6a 01                	push   $0x1
 158:	e8 e2 03 00 00       	call   53f <printf>
 15d:	83 c4 10             	add    $0x10,%esp
      exit();
 160:	e8 6b 02 00 00       	call   3d0 <exit>
    }
    wc(fd, argv[i]);
 165:	8b 45 f4             	mov    -0xc(%ebp),%eax
 168:	c1 e0 02             	shl    $0x2,%eax
 16b:	03 43 04             	add    0x4(%ebx),%eax
 16e:	8b 00                	mov    (%eax),%eax
 170:	83 ec 08             	sub    $0x8,%esp
 173:	50                   	push   %eax
 174:	ff 75 f0             	pushl  -0x10(%ebp)
 177:	e8 84 fe ff ff       	call   0 <wc>
 17c:	83 c4 10             	add    $0x10,%esp
    close(fd);
 17f:	83 ec 0c             	sub    $0xc,%esp
 182:	ff 75 f0             	pushl  -0x10(%ebp)
 185:	e8 6e 02 00 00       	call   3f8 <close>
 18a:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 18d:	ff 45 f4             	incl   -0xc(%ebp)
 190:	8b 45 f4             	mov    -0xc(%ebp),%eax
 193:	3b 03                	cmp    (%ebx),%eax
 195:	7c 89                	jl     120 <main+0x39>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 197:	e8 34 02 00 00       	call   3d0 <exit>

0000019c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
 19f:	57                   	push   %edi
 1a0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1a4:	8b 55 10             	mov    0x10(%ebp),%edx
 1a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1aa:	89 cb                	mov    %ecx,%ebx
 1ac:	89 df                	mov    %ebx,%edi
 1ae:	89 d1                	mov    %edx,%ecx
 1b0:	fc                   	cld    
 1b1:	f3 aa                	rep stos %al,%es:(%edi)
 1b3:	89 ca                	mov    %ecx,%edx
 1b5:	89 fb                	mov    %edi,%ebx
 1b7:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1ba:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1bd:	5b                   	pop    %ebx
 1be:	5f                   	pop    %edi
 1bf:	c9                   	leave  
 1c0:	c3                   	ret    

000001c1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1c1:	55                   	push   %ebp
 1c2:	89 e5                	mov    %esp,%ebp
 1c4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1cd:	90                   	nop
 1ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d1:	8a 10                	mov    (%eax),%dl
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	88 10                	mov    %dl,(%eax)
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
 1db:	8a 00                	mov    (%eax),%al
 1dd:	84 c0                	test   %al,%al
 1df:	0f 95 c0             	setne  %al
 1e2:	ff 45 08             	incl   0x8(%ebp)
 1e5:	ff 45 0c             	incl   0xc(%ebp)
 1e8:	84 c0                	test   %al,%al
 1ea:	75 e2                	jne    1ce <strcpy+0xd>
    ;
  return os;
 1ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1f4:	eb 06                	jmp    1fc <strcmp+0xb>
    p++, q++;
 1f6:	ff 45 08             	incl   0x8(%ebp)
 1f9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	8a 00                	mov    (%eax),%al
 201:	84 c0                	test   %al,%al
 203:	74 0e                	je     213 <strcmp+0x22>
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	8a 10                	mov    (%eax),%dl
 20a:	8b 45 0c             	mov    0xc(%ebp),%eax
 20d:	8a 00                	mov    (%eax),%al
 20f:	38 c2                	cmp    %al,%dl
 211:	74 e3                	je     1f6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	8a 00                	mov    (%eax),%al
 218:	0f b6 d0             	movzbl %al,%edx
 21b:	8b 45 0c             	mov    0xc(%ebp),%eax
 21e:	8a 00                	mov    (%eax),%al
 220:	0f b6 c0             	movzbl %al,%eax
 223:	89 d1                	mov    %edx,%ecx
 225:	29 c1                	sub    %eax,%ecx
 227:	89 c8                	mov    %ecx,%eax
}
 229:	c9                   	leave  
 22a:	c3                   	ret    

0000022b <strlen>:

uint
strlen(char *s)
{
 22b:	55                   	push   %ebp
 22c:	89 e5                	mov    %esp,%ebp
 22e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 231:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 238:	eb 03                	jmp    23d <strlen+0x12>
 23a:	ff 45 fc             	incl   -0x4(%ebp)
 23d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 240:	03 45 08             	add    0x8(%ebp),%eax
 243:	8a 00                	mov    (%eax),%al
 245:	84 c0                	test   %al,%al
 247:	75 f1                	jne    23a <strlen+0xf>
    ;
  return n;
 249:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <memset>:

void*
memset(void *dst, int c, uint n)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 251:	8b 45 10             	mov    0x10(%ebp),%eax
 254:	50                   	push   %eax
 255:	ff 75 0c             	pushl  0xc(%ebp)
 258:	ff 75 08             	pushl  0x8(%ebp)
 25b:	e8 3c ff ff ff       	call   19c <stosb>
 260:	83 c4 0c             	add    $0xc,%esp
  return dst;
 263:	8b 45 08             	mov    0x8(%ebp),%eax
}
 266:	c9                   	leave  
 267:	c3                   	ret    

00000268 <strchr>:

char*
strchr(const char *s, char c)
{
 268:	55                   	push   %ebp
 269:	89 e5                	mov    %esp,%ebp
 26b:	83 ec 04             	sub    $0x4,%esp
 26e:	8b 45 0c             	mov    0xc(%ebp),%eax
 271:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 274:	eb 12                	jmp    288 <strchr+0x20>
    if(*s == c)
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	8a 00                	mov    (%eax),%al
 27b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 27e:	75 05                	jne    285 <strchr+0x1d>
      return (char*)s;
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	eb 11                	jmp    296 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 285:	ff 45 08             	incl   0x8(%ebp)
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	8a 00                	mov    (%eax),%al
 28d:	84 c0                	test   %al,%al
 28f:	75 e5                	jne    276 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 291:	b8 00 00 00 00       	mov    $0x0,%eax
}
 296:	c9                   	leave  
 297:	c3                   	ret    

00000298 <gets>:

char*
gets(char *buf, int max)
{
 298:	55                   	push   %ebp
 299:	89 e5                	mov    %esp,%ebp
 29b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 29e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2a5:	eb 38                	jmp    2df <gets+0x47>
    cc = read(0, &c, 1);
 2a7:	83 ec 04             	sub    $0x4,%esp
 2aa:	6a 01                	push   $0x1
 2ac:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2af:	50                   	push   %eax
 2b0:	6a 00                	push   $0x0
 2b2:	e8 31 01 00 00       	call   3e8 <read>
 2b7:	83 c4 10             	add    $0x10,%esp
 2ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2c1:	7e 27                	jle    2ea <gets+0x52>
      break;
    buf[i++] = c;
 2c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c6:	03 45 08             	add    0x8(%ebp),%eax
 2c9:	8a 55 ef             	mov    -0x11(%ebp),%dl
 2cc:	88 10                	mov    %dl,(%eax)
 2ce:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 2d1:	8a 45 ef             	mov    -0x11(%ebp),%al
 2d4:	3c 0a                	cmp    $0xa,%al
 2d6:	74 13                	je     2eb <gets+0x53>
 2d8:	8a 45 ef             	mov    -0x11(%ebp),%al
 2db:	3c 0d                	cmp    $0xd,%al
 2dd:	74 0c                	je     2eb <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2e2:	40                   	inc    %eax
 2e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2e6:	7c bf                	jl     2a7 <gets+0xf>
 2e8:	eb 01                	jmp    2eb <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2ea:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ee:	03 45 08             	add    0x8(%ebp),%eax
 2f1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f7:	c9                   	leave  
 2f8:	c3                   	ret    

000002f9 <stat>:

int
stat(char *n, struct stat *st)
{
 2f9:	55                   	push   %ebp
 2fa:	89 e5                	mov    %esp,%ebp
 2fc:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ff:	83 ec 08             	sub    $0x8,%esp
 302:	6a 00                	push   $0x0
 304:	ff 75 08             	pushl  0x8(%ebp)
 307:	e8 04 01 00 00       	call   410 <open>
 30c:	83 c4 10             	add    $0x10,%esp
 30f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 312:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 316:	79 07                	jns    31f <stat+0x26>
    return -1;
 318:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 31d:	eb 25                	jmp    344 <stat+0x4b>
  r = fstat(fd, st);
 31f:	83 ec 08             	sub    $0x8,%esp
 322:	ff 75 0c             	pushl  0xc(%ebp)
 325:	ff 75 f4             	pushl  -0xc(%ebp)
 328:	e8 fb 00 00 00       	call   428 <fstat>
 32d:	83 c4 10             	add    $0x10,%esp
 330:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 333:	83 ec 0c             	sub    $0xc,%esp
 336:	ff 75 f4             	pushl  -0xc(%ebp)
 339:	e8 ba 00 00 00       	call   3f8 <close>
 33e:	83 c4 10             	add    $0x10,%esp
  return r;
 341:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 344:	c9                   	leave  
 345:	c3                   	ret    

00000346 <atoi>:

int
atoi(const char *s)
{
 346:	55                   	push   %ebp
 347:	89 e5                	mov    %esp,%ebp
 349:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 34c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 353:	eb 22                	jmp    377 <atoi+0x31>
    n = n*10 + *s++ - '0';
 355:	8b 55 fc             	mov    -0x4(%ebp),%edx
 358:	89 d0                	mov    %edx,%eax
 35a:	c1 e0 02             	shl    $0x2,%eax
 35d:	01 d0                	add    %edx,%eax
 35f:	d1 e0                	shl    %eax
 361:	89 c2                	mov    %eax,%edx
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	8a 00                	mov    (%eax),%al
 368:	0f be c0             	movsbl %al,%eax
 36b:	8d 04 02             	lea    (%edx,%eax,1),%eax
 36e:	83 e8 30             	sub    $0x30,%eax
 371:	89 45 fc             	mov    %eax,-0x4(%ebp)
 374:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 377:	8b 45 08             	mov    0x8(%ebp),%eax
 37a:	8a 00                	mov    (%eax),%al
 37c:	3c 2f                	cmp    $0x2f,%al
 37e:	7e 09                	jle    389 <atoi+0x43>
 380:	8b 45 08             	mov    0x8(%ebp),%eax
 383:	8a 00                	mov    (%eax),%al
 385:	3c 39                	cmp    $0x39,%al
 387:	7e cc                	jle    355 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 389:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 38c:	c9                   	leave  
 38d:	c3                   	ret    

0000038e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 38e:	55                   	push   %ebp
 38f:	89 e5                	mov    %esp,%ebp
 391:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 394:	8b 45 08             	mov    0x8(%ebp),%eax
 397:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 39a:	8b 45 0c             	mov    0xc(%ebp),%eax
 39d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3a0:	eb 10                	jmp    3b2 <memmove+0x24>
    *dst++ = *src++;
 3a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3a5:	8a 10                	mov    (%eax),%dl
 3a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3aa:	88 10                	mov    %dl,(%eax)
 3ac:	ff 45 fc             	incl   -0x4(%ebp)
 3af:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 3b6:	0f 9f c0             	setg   %al
 3b9:	ff 4d 10             	decl   0x10(%ebp)
 3bc:	84 c0                	test   %al,%al
 3be:	75 e2                	jne    3a2 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3c3:	c9                   	leave  
 3c4:	c3                   	ret    
 3c5:	90                   	nop
 3c6:	90                   	nop
 3c7:	90                   	nop

000003c8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3c8:	b8 01 00 00 00       	mov    $0x1,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <exit>:
SYSCALL(exit)
 3d0:	b8 02 00 00 00       	mov    $0x2,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <wait>:
SYSCALL(wait)
 3d8:	b8 03 00 00 00       	mov    $0x3,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <pipe>:
SYSCALL(pipe)
 3e0:	b8 04 00 00 00       	mov    $0x4,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <read>:
SYSCALL(read)
 3e8:	b8 05 00 00 00       	mov    $0x5,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <write>:
SYSCALL(write)
 3f0:	b8 10 00 00 00       	mov    $0x10,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <close>:
SYSCALL(close)
 3f8:	b8 15 00 00 00       	mov    $0x15,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <kill>:
SYSCALL(kill)
 400:	b8 06 00 00 00       	mov    $0x6,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <exec>:
SYSCALL(exec)
 408:	b8 07 00 00 00       	mov    $0x7,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <open>:
SYSCALL(open)
 410:	b8 0f 00 00 00       	mov    $0xf,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <mknod>:
SYSCALL(mknod)
 418:	b8 11 00 00 00       	mov    $0x11,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <unlink>:
SYSCALL(unlink)
 420:	b8 12 00 00 00       	mov    $0x12,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <fstat>:
SYSCALL(fstat)
 428:	b8 08 00 00 00       	mov    $0x8,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <link>:
SYSCALL(link)
 430:	b8 13 00 00 00       	mov    $0x13,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <mkdir>:
SYSCALL(mkdir)
 438:	b8 14 00 00 00       	mov    $0x14,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <chdir>:
SYSCALL(chdir)
 440:	b8 09 00 00 00       	mov    $0x9,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <dup>:
SYSCALL(dup)
 448:	b8 0a 00 00 00       	mov    $0xa,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <getpid>:
SYSCALL(getpid)
 450:	b8 0b 00 00 00       	mov    $0xb,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <sbrk>:
SYSCALL(sbrk)
 458:	b8 0c 00 00 00       	mov    $0xc,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <sleep>:
SYSCALL(sleep)
 460:	b8 0d 00 00 00       	mov    $0xd,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <uptime>:
SYSCALL(uptime)
 468:	b8 0e 00 00 00       	mov    $0xe,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	83 ec 18             	sub    $0x18,%esp
 476:	8b 45 0c             	mov    0xc(%ebp),%eax
 479:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 47c:	83 ec 04             	sub    $0x4,%esp
 47f:	6a 01                	push   $0x1
 481:	8d 45 f4             	lea    -0xc(%ebp),%eax
 484:	50                   	push   %eax
 485:	ff 75 08             	pushl  0x8(%ebp)
 488:	e8 63 ff ff ff       	call   3f0 <write>
 48d:	83 c4 10             	add    $0x10,%esp
}
 490:	c9                   	leave  
 491:	c3                   	ret    

00000492 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 492:	55                   	push   %ebp
 493:	89 e5                	mov    %esp,%ebp
 495:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 498:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 49f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4a3:	74 17                	je     4bc <printint+0x2a>
 4a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4a9:	79 11                	jns    4bc <printint+0x2a>
    neg = 1;
 4ab:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b5:	f7 d8                	neg    %eax
 4b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ba:	eb 06                	jmp    4c2 <printint+0x30>
  } else {
    x = xx;
 4bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4cf:	ba 00 00 00 00       	mov    $0x0,%edx
 4d4:	f7 f1                	div    %ecx
 4d6:	89 d0                	mov    %edx,%eax
 4d8:	8a 90 28 09 00 00    	mov    0x928(%eax),%dl
 4de:	8d 45 dc             	lea    -0x24(%ebp),%eax
 4e1:	03 45 f4             	add    -0xc(%ebp),%eax
 4e4:	88 10                	mov    %dl,(%eax)
 4e6:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 4e9:	8b 45 10             	mov    0x10(%ebp),%eax
 4ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f2:	ba 00 00 00 00       	mov    $0x0,%edx
 4f7:	f7 75 d4             	divl   -0x2c(%ebp)
 4fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 501:	75 c6                	jne    4c9 <printint+0x37>
  if(neg)
 503:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 507:	74 2a                	je     533 <printint+0xa1>
    buf[i++] = '-';
 509:	8d 45 dc             	lea    -0x24(%ebp),%eax
 50c:	03 45 f4             	add    -0xc(%ebp),%eax
 50f:	c6 00 2d             	movb   $0x2d,(%eax)
 512:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 515:	eb 1d                	jmp    534 <printint+0xa2>
    putc(fd, buf[i]);
 517:	8d 45 dc             	lea    -0x24(%ebp),%eax
 51a:	03 45 f4             	add    -0xc(%ebp),%eax
 51d:	8a 00                	mov    (%eax),%al
 51f:	0f be c0             	movsbl %al,%eax
 522:	83 ec 08             	sub    $0x8,%esp
 525:	50                   	push   %eax
 526:	ff 75 08             	pushl  0x8(%ebp)
 529:	e8 42 ff ff ff       	call   470 <putc>
 52e:	83 c4 10             	add    $0x10,%esp
 531:	eb 01                	jmp    534 <printint+0xa2>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 533:	90                   	nop
 534:	ff 4d f4             	decl   -0xc(%ebp)
 537:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 53b:	79 da                	jns    517 <printint+0x85>
    putc(fd, buf[i]);
}
 53d:	c9                   	leave  
 53e:	c3                   	ret    

0000053f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 53f:	55                   	push   %ebp
 540:	89 e5                	mov    %esp,%ebp
 542:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 545:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 54c:	8d 45 0c             	lea    0xc(%ebp),%eax
 54f:	83 c0 04             	add    $0x4,%eax
 552:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 555:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 55c:	e9 58 01 00 00       	jmp    6b9 <printf+0x17a>
    c = fmt[i] & 0xff;
 561:	8b 55 0c             	mov    0xc(%ebp),%edx
 564:	8b 45 f0             	mov    -0x10(%ebp),%eax
 567:	8d 04 02             	lea    (%edx,%eax,1),%eax
 56a:	8a 00                	mov    (%eax),%al
 56c:	0f be c0             	movsbl %al,%eax
 56f:	25 ff 00 00 00       	and    $0xff,%eax
 574:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 577:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 57b:	75 2c                	jne    5a9 <printf+0x6a>
      if(c == '%'){
 57d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 581:	75 0c                	jne    58f <printf+0x50>
        state = '%';
 583:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 58a:	e9 27 01 00 00       	jmp    6b6 <printf+0x177>
      } else {
        putc(fd, c);
 58f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 592:	0f be c0             	movsbl %al,%eax
 595:	83 ec 08             	sub    $0x8,%esp
 598:	50                   	push   %eax
 599:	ff 75 08             	pushl  0x8(%ebp)
 59c:	e8 cf fe ff ff       	call   470 <putc>
 5a1:	83 c4 10             	add    $0x10,%esp
 5a4:	e9 0d 01 00 00       	jmp    6b6 <printf+0x177>
      }
    } else if(state == '%'){
 5a9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ad:	0f 85 03 01 00 00    	jne    6b6 <printf+0x177>
      if(c == 'd'){
 5b3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5b7:	75 1e                	jne    5d7 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5bc:	8b 00                	mov    (%eax),%eax
 5be:	6a 01                	push   $0x1
 5c0:	6a 0a                	push   $0xa
 5c2:	50                   	push   %eax
 5c3:	ff 75 08             	pushl  0x8(%ebp)
 5c6:	e8 c7 fe ff ff       	call   492 <printint>
 5cb:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d2:	e9 d8 00 00 00       	jmp    6af <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5d7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5db:	74 06                	je     5e3 <printf+0xa4>
 5dd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5e1:	75 1e                	jne    601 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e6:	8b 00                	mov    (%eax),%eax
 5e8:	6a 00                	push   $0x0
 5ea:	6a 10                	push   $0x10
 5ec:	50                   	push   %eax
 5ed:	ff 75 08             	pushl  0x8(%ebp)
 5f0:	e8 9d fe ff ff       	call   492 <printint>
 5f5:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fc:	e9 ae 00 00 00       	jmp    6af <printf+0x170>
      } else if(c == 's'){
 601:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 605:	75 43                	jne    64a <printf+0x10b>
        s = (char*)*ap;
 607:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60a:	8b 00                	mov    (%eax),%eax
 60c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 60f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 613:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 617:	75 25                	jne    63e <printf+0xff>
          s = "(null)";
 619:	c7 45 f4 20 09 00 00 	movl   $0x920,-0xc(%ebp)
        while(*s != 0){
 620:	eb 1d                	jmp    63f <printf+0x100>
          putc(fd, *s);
 622:	8b 45 f4             	mov    -0xc(%ebp),%eax
 625:	8a 00                	mov    (%eax),%al
 627:	0f be c0             	movsbl %al,%eax
 62a:	83 ec 08             	sub    $0x8,%esp
 62d:	50                   	push   %eax
 62e:	ff 75 08             	pushl  0x8(%ebp)
 631:	e8 3a fe ff ff       	call   470 <putc>
 636:	83 c4 10             	add    $0x10,%esp
          s++;
 639:	ff 45 f4             	incl   -0xc(%ebp)
 63c:	eb 01                	jmp    63f <printf+0x100>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 63e:	90                   	nop
 63f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 642:	8a 00                	mov    (%eax),%al
 644:	84 c0                	test   %al,%al
 646:	75 da                	jne    622 <printf+0xe3>
 648:	eb 65                	jmp    6af <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 64a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 64e:	75 1d                	jne    66d <printf+0x12e>
        putc(fd, *ap);
 650:	8b 45 e8             	mov    -0x18(%ebp),%eax
 653:	8b 00                	mov    (%eax),%eax
 655:	0f be c0             	movsbl %al,%eax
 658:	83 ec 08             	sub    $0x8,%esp
 65b:	50                   	push   %eax
 65c:	ff 75 08             	pushl  0x8(%ebp)
 65f:	e8 0c fe ff ff       	call   470 <putc>
 664:	83 c4 10             	add    $0x10,%esp
        ap++;
 667:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 66b:	eb 42                	jmp    6af <printf+0x170>
      } else if(c == '%'){
 66d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 671:	75 17                	jne    68a <printf+0x14b>
        putc(fd, c);
 673:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 676:	0f be c0             	movsbl %al,%eax
 679:	83 ec 08             	sub    $0x8,%esp
 67c:	50                   	push   %eax
 67d:	ff 75 08             	pushl  0x8(%ebp)
 680:	e8 eb fd ff ff       	call   470 <putc>
 685:	83 c4 10             	add    $0x10,%esp
 688:	eb 25                	jmp    6af <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 68a:	83 ec 08             	sub    $0x8,%esp
 68d:	6a 25                	push   $0x25
 68f:	ff 75 08             	pushl  0x8(%ebp)
 692:	e8 d9 fd ff ff       	call   470 <putc>
 697:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 69a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69d:	0f be c0             	movsbl %al,%eax
 6a0:	83 ec 08             	sub    $0x8,%esp
 6a3:	50                   	push   %eax
 6a4:	ff 75 08             	pushl  0x8(%ebp)
 6a7:	e8 c4 fd ff ff       	call   470 <putc>
 6ac:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b6:	ff 45 f0             	incl   -0x10(%ebp)
 6b9:	8b 55 0c             	mov    0xc(%ebp),%edx
 6bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bf:	8d 04 02             	lea    (%edx,%eax,1),%eax
 6c2:	8a 00                	mov    (%eax),%al
 6c4:	84 c0                	test   %al,%al
 6c6:	0f 85 95 fe ff ff    	jne    561 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6cc:	c9                   	leave  
 6cd:	c3                   	ret    
 6ce:	90                   	nop
 6cf:	90                   	nop

000006d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d6:	8b 45 08             	mov    0x8(%ebp),%eax
 6d9:	83 e8 08             	sub    $0x8,%eax
 6dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6df:	a1 48 09 00 00       	mov    0x948,%eax
 6e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e7:	eb 24                	jmp    70d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 00                	mov    (%eax),%eax
 6ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f1:	77 12                	ja     705 <free+0x35>
 6f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f9:	77 24                	ja     71f <free+0x4f>
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fe:	8b 00                	mov    (%eax),%eax
 700:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 703:	77 1a                	ja     71f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	8b 00                	mov    (%eax),%eax
 70a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 70d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 710:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 713:	76 d4                	jbe    6e9 <free+0x19>
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	8b 00                	mov    (%eax),%eax
 71a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 71d:	76 ca                	jbe    6e9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 71f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 722:	8b 40 04             	mov    0x4(%eax),%eax
 725:	c1 e0 03             	shl    $0x3,%eax
 728:	89 c2                	mov    %eax,%edx
 72a:	03 55 f8             	add    -0x8(%ebp),%edx
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	39 c2                	cmp    %eax,%edx
 734:	75 24                	jne    75a <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 736:	8b 45 f8             	mov    -0x8(%ebp),%eax
 739:	8b 50 04             	mov    0x4(%eax),%edx
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	8b 40 04             	mov    0x4(%eax),%eax
 744:	01 c2                	add    %eax,%edx
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 00                	mov    (%eax),%eax
 751:	8b 10                	mov    (%eax),%edx
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	89 10                	mov    %edx,(%eax)
 758:	eb 0a                	jmp    764 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 75a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75d:	8b 10                	mov    (%eax),%edx
 75f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 762:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 40 04             	mov    0x4(%eax),%eax
 76a:	c1 e0 03             	shl    $0x3,%eax
 76d:	03 45 fc             	add    -0x4(%ebp),%eax
 770:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 773:	75 20                	jne    795 <free+0xc5>
    p->s.size += bp->s.size;
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	8b 50 04             	mov    0x4(%eax),%edx
 77b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77e:	8b 40 04             	mov    0x4(%eax),%eax
 781:	01 c2                	add    %eax,%edx
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 789:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78c:	8b 10                	mov    (%eax),%edx
 78e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 791:	89 10                	mov    %edx,(%eax)
 793:	eb 08                	jmp    79d <free+0xcd>
  } else
    p->s.ptr = bp;
 795:	8b 45 fc             	mov    -0x4(%ebp),%eax
 798:	8b 55 f8             	mov    -0x8(%ebp),%edx
 79b:	89 10                	mov    %edx,(%eax)
  freep = p;
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	a3 48 09 00 00       	mov    %eax,0x948
}
 7a5:	c9                   	leave  
 7a6:	c3                   	ret    

000007a7 <morecore>:

static Header*
morecore(uint nu)
{
 7a7:	55                   	push   %ebp
 7a8:	89 e5                	mov    %esp,%ebp
 7aa:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7ad:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7b4:	77 07                	ja     7bd <morecore+0x16>
    nu = 4096;
 7b6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7bd:	8b 45 08             	mov    0x8(%ebp),%eax
 7c0:	c1 e0 03             	shl    $0x3,%eax
 7c3:	83 ec 0c             	sub    $0xc,%esp
 7c6:	50                   	push   %eax
 7c7:	e8 8c fc ff ff       	call   458 <sbrk>
 7cc:	83 c4 10             	add    $0x10,%esp
 7cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7d2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7d6:	75 07                	jne    7df <morecore+0x38>
    return 0;
 7d8:	b8 00 00 00 00       	mov    $0x0,%eax
 7dd:	eb 26                	jmp    805 <morecore+0x5e>
  hp = (Header*)p;
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e8:	8b 55 08             	mov    0x8(%ebp),%edx
 7eb:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f1:	83 c0 08             	add    $0x8,%eax
 7f4:	83 ec 0c             	sub    $0xc,%esp
 7f7:	50                   	push   %eax
 7f8:	e8 d3 fe ff ff       	call   6d0 <free>
 7fd:	83 c4 10             	add    $0x10,%esp
  return freep;
 800:	a1 48 09 00 00       	mov    0x948,%eax
}
 805:	c9                   	leave  
 806:	c3                   	ret    

00000807 <malloc>:

void*
malloc(uint nbytes)
{
 807:	55                   	push   %ebp
 808:	89 e5                	mov    %esp,%ebp
 80a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80d:	8b 45 08             	mov    0x8(%ebp),%eax
 810:	83 c0 07             	add    $0x7,%eax
 813:	c1 e8 03             	shr    $0x3,%eax
 816:	40                   	inc    %eax
 817:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 81a:	a1 48 09 00 00       	mov    0x948,%eax
 81f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 822:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 826:	75 23                	jne    84b <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 828:	c7 45 f0 40 09 00 00 	movl   $0x940,-0x10(%ebp)
 82f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 832:	a3 48 09 00 00       	mov    %eax,0x948
 837:	a1 48 09 00 00       	mov    0x948,%eax
 83c:	a3 40 09 00 00       	mov    %eax,0x940
    base.s.size = 0;
 841:	c7 05 44 09 00 00 00 	movl   $0x0,0x944
 848:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84e:	8b 00                	mov    (%eax),%eax
 850:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 853:	8b 45 f4             	mov    -0xc(%ebp),%eax
 856:	8b 40 04             	mov    0x4(%eax),%eax
 859:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 85c:	72 4d                	jb     8ab <malloc+0xa4>
      if(p->s.size == nunits)
 85e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 861:	8b 40 04             	mov    0x4(%eax),%eax
 864:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 867:	75 0c                	jne    875 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	8b 10                	mov    (%eax),%edx
 86e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 871:	89 10                	mov    %edx,(%eax)
 873:	eb 26                	jmp    89b <malloc+0x94>
      else {
        p->s.size -= nunits;
 875:	8b 45 f4             	mov    -0xc(%ebp),%eax
 878:	8b 40 04             	mov    0x4(%eax),%eax
 87b:	89 c2                	mov    %eax,%edx
 87d:	2b 55 ec             	sub    -0x14(%ebp),%edx
 880:	8b 45 f4             	mov    -0xc(%ebp),%eax
 883:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	8b 40 04             	mov    0x4(%eax),%eax
 88c:	c1 e0 03             	shl    $0x3,%eax
 88f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 892:	8b 45 f4             	mov    -0xc(%ebp),%eax
 895:	8b 55 ec             	mov    -0x14(%ebp),%edx
 898:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 89b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89e:	a3 48 09 00 00       	mov    %eax,0x948
      return (void*)(p + 1);
 8a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a6:	83 c0 08             	add    $0x8,%eax
 8a9:	eb 3b                	jmp    8e6 <malloc+0xdf>
    }
    if(p == freep)
 8ab:	a1 48 09 00 00       	mov    0x948,%eax
 8b0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8b3:	75 1e                	jne    8d3 <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 8b5:	83 ec 0c             	sub    $0xc,%esp
 8b8:	ff 75 ec             	pushl  -0x14(%ebp)
 8bb:	e8 e7 fe ff ff       	call   7a7 <morecore>
 8c0:	83 c4 10             	add    $0x10,%esp
 8c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8ca:	75 07                	jne    8d3 <malloc+0xcc>
        return 0;
 8cc:	b8 00 00 00 00       	mov    $0x0,%eax
 8d1:	eb 13                	jmp    8e6 <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dc:	8b 00                	mov    (%eax),%eax
 8de:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8e1:	e9 6d ff ff ff       	jmp    853 <malloc+0x4c>
}
 8e6:	c9                   	leave  
 8e7:	c3                   	ret    
