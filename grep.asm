
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 b8 00 00 00       	jmp    ca <grep+0xca>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1b:	05 e0 0a 00 00       	add    $0xae0,%eax
  20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  23:	c7 45 f0 e0 0a 00 00 	movl   $0xae0,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2a:	eb 48                	jmp    74 <grep+0x74>
      *q = 0;
  2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  32:	83 ec 08             	sub    $0x8,%esp
  35:	ff 75 f0             	pushl  -0x10(%ebp)
  38:	ff 75 08             	pushl  0x8(%ebp)
  3b:	e8 91 01 00 00       	call   1d1 <match>
  40:	83 c4 10             	add    $0x10,%esp
  43:	85 c0                	test   %eax,%eax
  45:	74 26                	je     6d <grep+0x6d>
        *q = '\n';
  47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4a:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  50:	40                   	inc    %eax
  51:	89 c2                	mov    %eax,%edx
  53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  56:	89 d1                	mov    %edx,%ecx
  58:	29 c1                	sub    %eax,%ecx
  5a:	89 c8                	mov    %ecx,%eax
  5c:	83 ec 04             	sub    $0x4,%esp
  5f:	50                   	push   %eax
  60:	ff 75 f0             	pushl  -0x10(%ebp)
  63:	6a 01                	push   $0x1
  65:	e8 06 05 00 00       	call   570 <write>
  6a:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  70:	40                   	inc    %eax
  71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    m += n;
    buf[m] = '\0';
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  74:	83 ec 08             	sub    $0x8,%esp
  77:	6a 0a                	push   $0xa
  79:	ff 75 f0             	pushl  -0x10(%ebp)
  7c:	e8 67 03 00 00       	call   3e8 <strchr>
  81:	83 c4 10             	add    $0x10,%esp
  84:	89 45 e8             	mov    %eax,-0x18(%ebp)
  87:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8b:	75 9f                	jne    2c <grep+0x2c>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  8d:	81 7d f0 e0 0a 00 00 	cmpl   $0xae0,-0x10(%ebp)
  94:	75 07                	jne    9d <grep+0x9d>
      m = 0;
  96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a1:	7e 27                	jle    ca <grep+0xca>
      m -= p - buf;
  a3:	ba e0 0a 00 00       	mov    $0xae0,%edx
  a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ab:	89 d1                	mov    %edx,%ecx
  ad:	29 c1                	sub    %eax,%ecx
  af:	89 c8                	mov    %ecx,%eax
  b1:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b4:	83 ec 04             	sub    $0x4,%esp
  b7:	ff 75 f4             	pushl  -0xc(%ebp)
  ba:	ff 75 f0             	pushl  -0x10(%ebp)
  bd:	68 e0 0a 00 00       	push   $0xae0
  c2:	e8 47 04 00 00       	call   50e <memmove>
  c7:	83 c4 10             	add    $0x10,%esp
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  cd:	ba ff 03 00 00       	mov    $0x3ff,%edx
  d2:	89 d1                	mov    %edx,%ecx
  d4:	29 c1                	sub    %eax,%ecx
  d6:	89 c8                	mov    %ecx,%eax
  d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  db:	81 c2 e0 0a 00 00    	add    $0xae0,%edx
  e1:	83 ec 04             	sub    $0x4,%esp
  e4:	50                   	push   %eax
  e5:	52                   	push   %edx
  e6:	ff 75 0c             	pushl  0xc(%ebp)
  e9:	e8 7a 04 00 00       	call   568 <read>
  ee:	83 c4 10             	add    $0x10,%esp
  f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  f8:	0f 8f 14 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
  fe:	c9                   	leave  
  ff:	c3                   	ret    

00000100 <main>:

int
main(int argc, char *argv[])
{
 100:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 104:	83 e4 f0             	and    $0xfffffff0,%esp
 107:	ff 71 fc             	pushl  -0x4(%ecx)
 10a:	55                   	push   %ebp
 10b:	89 e5                	mov    %esp,%ebp
 10d:	53                   	push   %ebx
 10e:	51                   	push   %ecx
 10f:	83 ec 10             	sub    $0x10,%esp
 112:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 114:	83 3b 01             	cmpl   $0x1,(%ebx)
 117:	7f 17                	jg     130 <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
 119:	83 ec 08             	sub    $0x8,%esp
 11c:	68 68 0a 00 00       	push   $0xa68
 121:	6a 02                	push   $0x2
 123:	e8 97 05 00 00       	call   6bf <printf>
 128:	83 c4 10             	add    $0x10,%esp
    exit();
 12b:	e8 20 04 00 00       	call   550 <exit>
  }
  pattern = argv[1];
 130:	8b 43 04             	mov    0x4(%ebx),%eax
 133:	83 c0 04             	add    $0x4,%eax
 136:	8b 00                	mov    (%eax),%eax
 138:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  if(argc <= 2){
 13b:	83 3b 02             	cmpl   $0x2,(%ebx)
 13e:	7f 15                	jg     155 <main+0x55>
    grep(pattern, 0);
 140:	83 ec 08             	sub    $0x8,%esp
 143:	6a 00                	push   $0x0
 145:	ff 75 f0             	pushl  -0x10(%ebp)
 148:	e8 b3 fe ff ff       	call   0 <grep>
 14d:	83 c4 10             	add    $0x10,%esp
    exit();
 150:	e8 fb 03 00 00       	call   550 <exit>
  }

  for(i = 2; i < argc; i++){
 155:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 15c:	eb 67                	jmp    1c5 <main+0xc5>
    if((fd = open(argv[i], 0)) < 0){
 15e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 161:	c1 e0 02             	shl    $0x2,%eax
 164:	03 43 04             	add    0x4(%ebx),%eax
 167:	8b 00                	mov    (%eax),%eax
 169:	83 ec 08             	sub    $0x8,%esp
 16c:	6a 00                	push   $0x0
 16e:	50                   	push   %eax
 16f:	e8 1c 04 00 00       	call   590 <open>
 174:	83 c4 10             	add    $0x10,%esp
 177:	89 45 ec             	mov    %eax,-0x14(%ebp)
 17a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 17e:	79 23                	jns    1a3 <main+0xa3>
      printf(1, "grep: cannot open %s\n", argv[i]);
 180:	8b 45 f4             	mov    -0xc(%ebp),%eax
 183:	c1 e0 02             	shl    $0x2,%eax
 186:	03 43 04             	add    0x4(%ebx),%eax
 189:	8b 00                	mov    (%eax),%eax
 18b:	83 ec 04             	sub    $0x4,%esp
 18e:	50                   	push   %eax
 18f:	68 88 0a 00 00       	push   $0xa88
 194:	6a 01                	push   $0x1
 196:	e8 24 05 00 00       	call   6bf <printf>
 19b:	83 c4 10             	add    $0x10,%esp
      exit();
 19e:	e8 ad 03 00 00       	call   550 <exit>
    }
    grep(pattern, fd);
 1a3:	83 ec 08             	sub    $0x8,%esp
 1a6:	ff 75 ec             	pushl  -0x14(%ebp)
 1a9:	ff 75 f0             	pushl  -0x10(%ebp)
 1ac:	e8 4f fe ff ff       	call   0 <grep>
 1b1:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1b4:	83 ec 0c             	sub    $0xc,%esp
 1b7:	ff 75 ec             	pushl  -0x14(%ebp)
 1ba:	e8 b9 03 00 00       	call   578 <close>
 1bf:	83 c4 10             	add    $0x10,%esp
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1c2:	ff 45 f4             	incl   -0xc(%ebp)
 1c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c8:	3b 03                	cmp    (%ebx),%eax
 1ca:	7c 92                	jl     15e <main+0x5e>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1cc:	e8 7f 03 00 00       	call   550 <exit>

000001d1 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1d1:	55                   	push   %ebp
 1d2:	89 e5                	mov    %esp,%ebp
 1d4:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1d7:	8b 45 08             	mov    0x8(%ebp),%eax
 1da:	8a 00                	mov    (%eax),%al
 1dc:	3c 5e                	cmp    $0x5e,%al
 1de:	75 15                	jne    1f5 <match+0x24>
    return matchhere(re+1, text);
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	40                   	inc    %eax
 1e4:	83 ec 08             	sub    $0x8,%esp
 1e7:	ff 75 0c             	pushl  0xc(%ebp)
 1ea:	50                   	push   %eax
 1eb:	e8 39 00 00 00       	call   229 <matchhere>
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	eb 32                	jmp    227 <match+0x56>
  do{  // must look at empty string
    if(matchhere(re, text))
 1f5:	83 ec 08             	sub    $0x8,%esp
 1f8:	ff 75 0c             	pushl  0xc(%ebp)
 1fb:	ff 75 08             	pushl  0x8(%ebp)
 1fe:	e8 26 00 00 00       	call   229 <matchhere>
 203:	83 c4 10             	add    $0x10,%esp
 206:	85 c0                	test   %eax,%eax
 208:	74 07                	je     211 <match+0x40>
      return 1;
 20a:	b8 01 00 00 00       	mov    $0x1,%eax
 20f:	eb 16                	jmp    227 <match+0x56>
  }while(*text++ != '\0');
 211:	8b 45 0c             	mov    0xc(%ebp),%eax
 214:	8a 00                	mov    (%eax),%al
 216:	84 c0                	test   %al,%al
 218:	0f 95 c0             	setne  %al
 21b:	ff 45 0c             	incl   0xc(%ebp)
 21e:	84 c0                	test   %al,%al
 220:	75 d3                	jne    1f5 <match+0x24>
  return 0;
 222:	b8 00 00 00 00       	mov    $0x0,%eax
}
 227:	c9                   	leave  
 228:	c3                   	ret    

00000229 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 229:	55                   	push   %ebp
 22a:	89 e5                	mov    %esp,%ebp
 22c:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	8a 00                	mov    (%eax),%al
 234:	84 c0                	test   %al,%al
 236:	75 0a                	jne    242 <matchhere+0x19>
    return 1;
 238:	b8 01 00 00 00       	mov    $0x1,%eax
 23d:	e9 8a 00 00 00       	jmp    2cc <matchhere+0xa3>
  if(re[1] == '*')
 242:	8b 45 08             	mov    0x8(%ebp),%eax
 245:	40                   	inc    %eax
 246:	8a 00                	mov    (%eax),%al
 248:	3c 2a                	cmp    $0x2a,%al
 24a:	75 20                	jne    26c <matchhere+0x43>
    return matchstar(re[0], re+2, text);
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	8d 50 02             	lea    0x2(%eax),%edx
 252:	8b 45 08             	mov    0x8(%ebp),%eax
 255:	8a 00                	mov    (%eax),%al
 257:	0f be c0             	movsbl %al,%eax
 25a:	83 ec 04             	sub    $0x4,%esp
 25d:	ff 75 0c             	pushl  0xc(%ebp)
 260:	52                   	push   %edx
 261:	50                   	push   %eax
 262:	e8 67 00 00 00       	call   2ce <matchstar>
 267:	83 c4 10             	add    $0x10,%esp
 26a:	eb 60                	jmp    2cc <matchhere+0xa3>
  if(re[0] == '$' && re[1] == '\0')
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	8a 00                	mov    (%eax),%al
 271:	3c 24                	cmp    $0x24,%al
 273:	75 19                	jne    28e <matchhere+0x65>
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	40                   	inc    %eax
 279:	8a 00                	mov    (%eax),%al
 27b:	84 c0                	test   %al,%al
 27d:	75 0f                	jne    28e <matchhere+0x65>
    return *text == '\0';
 27f:	8b 45 0c             	mov    0xc(%ebp),%eax
 282:	8a 00                	mov    (%eax),%al
 284:	84 c0                	test   %al,%al
 286:	0f 94 c0             	sete   %al
 289:	0f b6 c0             	movzbl %al,%eax
 28c:	eb 3e                	jmp    2cc <matchhere+0xa3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 28e:	8b 45 0c             	mov    0xc(%ebp),%eax
 291:	8a 00                	mov    (%eax),%al
 293:	84 c0                	test   %al,%al
 295:	74 30                	je     2c7 <matchhere+0x9e>
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	8a 00                	mov    (%eax),%al
 29c:	3c 2e                	cmp    $0x2e,%al
 29e:	74 0e                	je     2ae <matchhere+0x85>
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	8a 10                	mov    (%eax),%dl
 2a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a8:	8a 00                	mov    (%eax),%al
 2aa:	38 c2                	cmp    %al,%dl
 2ac:	75 19                	jne    2c7 <matchhere+0x9e>
    return matchhere(re+1, text+1);
 2ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b1:	8d 50 01             	lea    0x1(%eax),%edx
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	40                   	inc    %eax
 2b8:	83 ec 08             	sub    $0x8,%esp
 2bb:	52                   	push   %edx
 2bc:	50                   	push   %eax
 2bd:	e8 67 ff ff ff       	call   229 <matchhere>
 2c2:	83 c4 10             	add    $0x10,%esp
 2c5:	eb 05                	jmp    2cc <matchhere+0xa3>
  return 0;
 2c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2cc:	c9                   	leave  
 2cd:	c3                   	ret    

000002ce <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2ce:	55                   	push   %ebp
 2cf:	89 e5                	mov    %esp,%ebp
 2d1:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2d4:	83 ec 08             	sub    $0x8,%esp
 2d7:	ff 75 10             	pushl  0x10(%ebp)
 2da:	ff 75 0c             	pushl  0xc(%ebp)
 2dd:	e8 47 ff ff ff       	call   229 <matchhere>
 2e2:	83 c4 10             	add    $0x10,%esp
 2e5:	85 c0                	test   %eax,%eax
 2e7:	74 07                	je     2f0 <matchstar+0x22>
      return 1;
 2e9:	b8 01 00 00 00       	mov    $0x1,%eax
 2ee:	eb 29                	jmp    319 <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
 2f0:	8b 45 10             	mov    0x10(%ebp),%eax
 2f3:	8a 00                	mov    (%eax),%al
 2f5:	84 c0                	test   %al,%al
 2f7:	74 1b                	je     314 <matchstar+0x46>
 2f9:	8b 45 10             	mov    0x10(%ebp),%eax
 2fc:	8a 00                	mov    (%eax),%al
 2fe:	0f be c0             	movsbl %al,%eax
 301:	3b 45 08             	cmp    0x8(%ebp),%eax
 304:	0f 94 c0             	sete   %al
 307:	ff 45 10             	incl   0x10(%ebp)
 30a:	84 c0                	test   %al,%al
 30c:	75 c6                	jne    2d4 <matchstar+0x6>
 30e:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 312:	74 c0                	je     2d4 <matchstar+0x6>
  return 0;
 314:	b8 00 00 00 00       	mov    $0x0,%eax
}
 319:	c9                   	leave  
 31a:	c3                   	ret    
 31b:	90                   	nop

0000031c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 31c:	55                   	push   %ebp
 31d:	89 e5                	mov    %esp,%ebp
 31f:	57                   	push   %edi
 320:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 321:	8b 4d 08             	mov    0x8(%ebp),%ecx
 324:	8b 55 10             	mov    0x10(%ebp),%edx
 327:	8b 45 0c             	mov    0xc(%ebp),%eax
 32a:	89 cb                	mov    %ecx,%ebx
 32c:	89 df                	mov    %ebx,%edi
 32e:	89 d1                	mov    %edx,%ecx
 330:	fc                   	cld    
 331:	f3 aa                	rep stos %al,%es:(%edi)
 333:	89 ca                	mov    %ecx,%edx
 335:	89 fb                	mov    %edi,%ebx
 337:	89 5d 08             	mov    %ebx,0x8(%ebp)
 33a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 33d:	5b                   	pop    %ebx
 33e:	5f                   	pop    %edi
 33f:	c9                   	leave  
 340:	c3                   	ret    

00000341 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 341:	55                   	push   %ebp
 342:	89 e5                	mov    %esp,%ebp
 344:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 347:	8b 45 08             	mov    0x8(%ebp),%eax
 34a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 34d:	90                   	nop
 34e:	8b 45 0c             	mov    0xc(%ebp),%eax
 351:	8a 10                	mov    (%eax),%dl
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	88 10                	mov    %dl,(%eax)
 358:	8b 45 08             	mov    0x8(%ebp),%eax
 35b:	8a 00                	mov    (%eax),%al
 35d:	84 c0                	test   %al,%al
 35f:	0f 95 c0             	setne  %al
 362:	ff 45 08             	incl   0x8(%ebp)
 365:	ff 45 0c             	incl   0xc(%ebp)
 368:	84 c0                	test   %al,%al
 36a:	75 e2                	jne    34e <strcpy+0xd>
    ;
  return os;
 36c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 36f:	c9                   	leave  
 370:	c3                   	ret    

00000371 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 371:	55                   	push   %ebp
 372:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 374:	eb 06                	jmp    37c <strcmp+0xb>
    p++, q++;
 376:	ff 45 08             	incl   0x8(%ebp)
 379:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 37c:	8b 45 08             	mov    0x8(%ebp),%eax
 37f:	8a 00                	mov    (%eax),%al
 381:	84 c0                	test   %al,%al
 383:	74 0e                	je     393 <strcmp+0x22>
 385:	8b 45 08             	mov    0x8(%ebp),%eax
 388:	8a 10                	mov    (%eax),%dl
 38a:	8b 45 0c             	mov    0xc(%ebp),%eax
 38d:	8a 00                	mov    (%eax),%al
 38f:	38 c2                	cmp    %al,%dl
 391:	74 e3                	je     376 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 393:	8b 45 08             	mov    0x8(%ebp),%eax
 396:	8a 00                	mov    (%eax),%al
 398:	0f b6 d0             	movzbl %al,%edx
 39b:	8b 45 0c             	mov    0xc(%ebp),%eax
 39e:	8a 00                	mov    (%eax),%al
 3a0:	0f b6 c0             	movzbl %al,%eax
 3a3:	89 d1                	mov    %edx,%ecx
 3a5:	29 c1                	sub    %eax,%ecx
 3a7:	89 c8                	mov    %ecx,%eax
}
 3a9:	c9                   	leave  
 3aa:	c3                   	ret    

000003ab <strlen>:

uint
strlen(char *s)
{
 3ab:	55                   	push   %ebp
 3ac:	89 e5                	mov    %esp,%ebp
 3ae:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3b8:	eb 03                	jmp    3bd <strlen+0x12>
 3ba:	ff 45 fc             	incl   -0x4(%ebp)
 3bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3c0:	03 45 08             	add    0x8(%ebp),%eax
 3c3:	8a 00                	mov    (%eax),%al
 3c5:	84 c0                	test   %al,%al
 3c7:	75 f1                	jne    3ba <strlen+0xf>
    ;
  return n;
 3c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3cc:	c9                   	leave  
 3cd:	c3                   	ret    

000003ce <memset>:

void*
memset(void *dst, int c, uint n)
{
 3ce:	55                   	push   %ebp
 3cf:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3d1:	8b 45 10             	mov    0x10(%ebp),%eax
 3d4:	50                   	push   %eax
 3d5:	ff 75 0c             	pushl  0xc(%ebp)
 3d8:	ff 75 08             	pushl  0x8(%ebp)
 3db:	e8 3c ff ff ff       	call   31c <stosb>
 3e0:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3e6:	c9                   	leave  
 3e7:	c3                   	ret    

000003e8 <strchr>:

char*
strchr(const char *s, char c)
{
 3e8:	55                   	push   %ebp
 3e9:	89 e5                	mov    %esp,%ebp
 3eb:	83 ec 04             	sub    $0x4,%esp
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3f4:	eb 12                	jmp    408 <strchr+0x20>
    if(*s == c)
 3f6:	8b 45 08             	mov    0x8(%ebp),%eax
 3f9:	8a 00                	mov    (%eax),%al
 3fb:	3a 45 fc             	cmp    -0x4(%ebp),%al
 3fe:	75 05                	jne    405 <strchr+0x1d>
      return (char*)s;
 400:	8b 45 08             	mov    0x8(%ebp),%eax
 403:	eb 11                	jmp    416 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 405:	ff 45 08             	incl   0x8(%ebp)
 408:	8b 45 08             	mov    0x8(%ebp),%eax
 40b:	8a 00                	mov    (%eax),%al
 40d:	84 c0                	test   %al,%al
 40f:	75 e5                	jne    3f6 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 411:	b8 00 00 00 00       	mov    $0x0,%eax
}
 416:	c9                   	leave  
 417:	c3                   	ret    

00000418 <gets>:

char*
gets(char *buf, int max)
{
 418:	55                   	push   %ebp
 419:	89 e5                	mov    %esp,%ebp
 41b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 41e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 425:	eb 38                	jmp    45f <gets+0x47>
    cc = read(0, &c, 1);
 427:	83 ec 04             	sub    $0x4,%esp
 42a:	6a 01                	push   $0x1
 42c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 42f:	50                   	push   %eax
 430:	6a 00                	push   $0x0
 432:	e8 31 01 00 00       	call   568 <read>
 437:	83 c4 10             	add    $0x10,%esp
 43a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 43d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 441:	7e 27                	jle    46a <gets+0x52>
      break;
    buf[i++] = c;
 443:	8b 45 f4             	mov    -0xc(%ebp),%eax
 446:	03 45 08             	add    0x8(%ebp),%eax
 449:	8a 55 ef             	mov    -0x11(%ebp),%dl
 44c:	88 10                	mov    %dl,(%eax)
 44e:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 451:	8a 45 ef             	mov    -0x11(%ebp),%al
 454:	3c 0a                	cmp    $0xa,%al
 456:	74 13                	je     46b <gets+0x53>
 458:	8a 45 ef             	mov    -0x11(%ebp),%al
 45b:	3c 0d                	cmp    $0xd,%al
 45d:	74 0c                	je     46b <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 45f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 462:	40                   	inc    %eax
 463:	3b 45 0c             	cmp    0xc(%ebp),%eax
 466:	7c bf                	jl     427 <gets+0xf>
 468:	eb 01                	jmp    46b <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 46a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 46b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46e:	03 45 08             	add    0x8(%ebp),%eax
 471:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 474:	8b 45 08             	mov    0x8(%ebp),%eax
}
 477:	c9                   	leave  
 478:	c3                   	ret    

00000479 <stat>:

int
stat(char *n, struct stat *st)
{
 479:	55                   	push   %ebp
 47a:	89 e5                	mov    %esp,%ebp
 47c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 47f:	83 ec 08             	sub    $0x8,%esp
 482:	6a 00                	push   $0x0
 484:	ff 75 08             	pushl  0x8(%ebp)
 487:	e8 04 01 00 00       	call   590 <open>
 48c:	83 c4 10             	add    $0x10,%esp
 48f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 492:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 496:	79 07                	jns    49f <stat+0x26>
    return -1;
 498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 49d:	eb 25                	jmp    4c4 <stat+0x4b>
  r = fstat(fd, st);
 49f:	83 ec 08             	sub    $0x8,%esp
 4a2:	ff 75 0c             	pushl  0xc(%ebp)
 4a5:	ff 75 f4             	pushl  -0xc(%ebp)
 4a8:	e8 fb 00 00 00       	call   5a8 <fstat>
 4ad:	83 c4 10             	add    $0x10,%esp
 4b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4b3:	83 ec 0c             	sub    $0xc,%esp
 4b6:	ff 75 f4             	pushl  -0xc(%ebp)
 4b9:	e8 ba 00 00 00       	call   578 <close>
 4be:	83 c4 10             	add    $0x10,%esp
  return r;
 4c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4c4:	c9                   	leave  
 4c5:	c3                   	ret    

000004c6 <atoi>:

int
atoi(const char *s)
{
 4c6:	55                   	push   %ebp
 4c7:	89 e5                	mov    %esp,%ebp
 4c9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4d3:	eb 22                	jmp    4f7 <atoi+0x31>
    n = n*10 + *s++ - '0';
 4d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4d8:	89 d0                	mov    %edx,%eax
 4da:	c1 e0 02             	shl    $0x2,%eax
 4dd:	01 d0                	add    %edx,%eax
 4df:	d1 e0                	shl    %eax
 4e1:	89 c2                	mov    %eax,%edx
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	8a 00                	mov    (%eax),%al
 4e8:	0f be c0             	movsbl %al,%eax
 4eb:	8d 04 02             	lea    (%edx,%eax,1),%eax
 4ee:	83 e8 30             	sub    $0x30,%eax
 4f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 4f4:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4f7:	8b 45 08             	mov    0x8(%ebp),%eax
 4fa:	8a 00                	mov    (%eax),%al
 4fc:	3c 2f                	cmp    $0x2f,%al
 4fe:	7e 09                	jle    509 <atoi+0x43>
 500:	8b 45 08             	mov    0x8(%ebp),%eax
 503:	8a 00                	mov    (%eax),%al
 505:	3c 39                	cmp    $0x39,%al
 507:	7e cc                	jle    4d5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 509:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 50c:	c9                   	leave  
 50d:	c3                   	ret    

0000050e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 50e:	55                   	push   %ebp
 50f:	89 e5                	mov    %esp,%ebp
 511:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 514:	8b 45 08             	mov    0x8(%ebp),%eax
 517:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 51a:	8b 45 0c             	mov    0xc(%ebp),%eax
 51d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 520:	eb 10                	jmp    532 <memmove+0x24>
    *dst++ = *src++;
 522:	8b 45 f8             	mov    -0x8(%ebp),%eax
 525:	8a 10                	mov    (%eax),%dl
 527:	8b 45 fc             	mov    -0x4(%ebp),%eax
 52a:	88 10                	mov    %dl,(%eax)
 52c:	ff 45 fc             	incl   -0x4(%ebp)
 52f:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 532:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 536:	0f 9f c0             	setg   %al
 539:	ff 4d 10             	decl   0x10(%ebp)
 53c:	84 c0                	test   %al,%al
 53e:	75 e2                	jne    522 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 540:	8b 45 08             	mov    0x8(%ebp),%eax
}
 543:	c9                   	leave  
 544:	c3                   	ret    
 545:	90                   	nop
 546:	90                   	nop
 547:	90                   	nop

00000548 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 548:	b8 01 00 00 00       	mov    $0x1,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <exit>:
SYSCALL(exit)
 550:	b8 02 00 00 00       	mov    $0x2,%eax
 555:	cd 40                	int    $0x40
 557:	c3                   	ret    

00000558 <wait>:
SYSCALL(wait)
 558:	b8 03 00 00 00       	mov    $0x3,%eax
 55d:	cd 40                	int    $0x40
 55f:	c3                   	ret    

00000560 <pipe>:
SYSCALL(pipe)
 560:	b8 04 00 00 00       	mov    $0x4,%eax
 565:	cd 40                	int    $0x40
 567:	c3                   	ret    

00000568 <read>:
SYSCALL(read)
 568:	b8 05 00 00 00       	mov    $0x5,%eax
 56d:	cd 40                	int    $0x40
 56f:	c3                   	ret    

00000570 <write>:
SYSCALL(write)
 570:	b8 10 00 00 00       	mov    $0x10,%eax
 575:	cd 40                	int    $0x40
 577:	c3                   	ret    

00000578 <close>:
SYSCALL(close)
 578:	b8 15 00 00 00       	mov    $0x15,%eax
 57d:	cd 40                	int    $0x40
 57f:	c3                   	ret    

00000580 <kill>:
SYSCALL(kill)
 580:	b8 06 00 00 00       	mov    $0x6,%eax
 585:	cd 40                	int    $0x40
 587:	c3                   	ret    

00000588 <exec>:
SYSCALL(exec)
 588:	b8 07 00 00 00       	mov    $0x7,%eax
 58d:	cd 40                	int    $0x40
 58f:	c3                   	ret    

00000590 <open>:
SYSCALL(open)
 590:	b8 0f 00 00 00       	mov    $0xf,%eax
 595:	cd 40                	int    $0x40
 597:	c3                   	ret    

00000598 <mknod>:
SYSCALL(mknod)
 598:	b8 11 00 00 00       	mov    $0x11,%eax
 59d:	cd 40                	int    $0x40
 59f:	c3                   	ret    

000005a0 <unlink>:
SYSCALL(unlink)
 5a0:	b8 12 00 00 00       	mov    $0x12,%eax
 5a5:	cd 40                	int    $0x40
 5a7:	c3                   	ret    

000005a8 <fstat>:
SYSCALL(fstat)
 5a8:	b8 08 00 00 00       	mov    $0x8,%eax
 5ad:	cd 40                	int    $0x40
 5af:	c3                   	ret    

000005b0 <link>:
SYSCALL(link)
 5b0:	b8 13 00 00 00       	mov    $0x13,%eax
 5b5:	cd 40                	int    $0x40
 5b7:	c3                   	ret    

000005b8 <mkdir>:
SYSCALL(mkdir)
 5b8:	b8 14 00 00 00       	mov    $0x14,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <chdir>:
SYSCALL(chdir)
 5c0:	b8 09 00 00 00       	mov    $0x9,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <dup>:
SYSCALL(dup)
 5c8:	b8 0a 00 00 00       	mov    $0xa,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <getpid>:
SYSCALL(getpid)
 5d0:	b8 0b 00 00 00       	mov    $0xb,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <sbrk>:
SYSCALL(sbrk)
 5d8:	b8 0c 00 00 00       	mov    $0xc,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <sleep>:
SYSCALL(sleep)
 5e0:	b8 0d 00 00 00       	mov    $0xd,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <uptime>:
SYSCALL(uptime)
 5e8:	b8 0e 00 00 00       	mov    $0xe,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	83 ec 18             	sub    $0x18,%esp
 5f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5fc:	83 ec 04             	sub    $0x4,%esp
 5ff:	6a 01                	push   $0x1
 601:	8d 45 f4             	lea    -0xc(%ebp),%eax
 604:	50                   	push   %eax
 605:	ff 75 08             	pushl  0x8(%ebp)
 608:	e8 63 ff ff ff       	call   570 <write>
 60d:	83 c4 10             	add    $0x10,%esp
}
 610:	c9                   	leave  
 611:	c3                   	ret    

00000612 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 612:	55                   	push   %ebp
 613:	89 e5                	mov    %esp,%ebp
 615:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 618:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 61f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 623:	74 17                	je     63c <printint+0x2a>
 625:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 629:	79 11                	jns    63c <printint+0x2a>
    neg = 1;
 62b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 632:	8b 45 0c             	mov    0xc(%ebp),%eax
 635:	f7 d8                	neg    %eax
 637:	89 45 ec             	mov    %eax,-0x14(%ebp)
 63a:	eb 06                	jmp    642 <printint+0x30>
  } else {
    x = xx;
 63c:	8b 45 0c             	mov    0xc(%ebp),%eax
 63f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 642:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 649:	8b 4d 10             	mov    0x10(%ebp),%ecx
 64c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 64f:	ba 00 00 00 00       	mov    $0x0,%edx
 654:	f7 f1                	div    %ecx
 656:	89 d0                	mov    %edx,%eax
 658:	8a 90 a8 0a 00 00    	mov    0xaa8(%eax),%dl
 65e:	8d 45 dc             	lea    -0x24(%ebp),%eax
 661:	03 45 f4             	add    -0xc(%ebp),%eax
 664:	88 10                	mov    %dl,(%eax)
 666:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 669:	8b 45 10             	mov    0x10(%ebp),%eax
 66c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 66f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 672:	ba 00 00 00 00       	mov    $0x0,%edx
 677:	f7 75 d4             	divl   -0x2c(%ebp)
 67a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 67d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 681:	75 c6                	jne    649 <printint+0x37>
  if(neg)
 683:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 687:	74 2a                	je     6b3 <printint+0xa1>
    buf[i++] = '-';
 689:	8d 45 dc             	lea    -0x24(%ebp),%eax
 68c:	03 45 f4             	add    -0xc(%ebp),%eax
 68f:	c6 00 2d             	movb   $0x2d,(%eax)
 692:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 695:	eb 1d                	jmp    6b4 <printint+0xa2>
    putc(fd, buf[i]);
 697:	8d 45 dc             	lea    -0x24(%ebp),%eax
 69a:	03 45 f4             	add    -0xc(%ebp),%eax
 69d:	8a 00                	mov    (%eax),%al
 69f:	0f be c0             	movsbl %al,%eax
 6a2:	83 ec 08             	sub    $0x8,%esp
 6a5:	50                   	push   %eax
 6a6:	ff 75 08             	pushl  0x8(%ebp)
 6a9:	e8 42 ff ff ff       	call   5f0 <putc>
 6ae:	83 c4 10             	add    $0x10,%esp
 6b1:	eb 01                	jmp    6b4 <printint+0xa2>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6b3:	90                   	nop
 6b4:	ff 4d f4             	decl   -0xc(%ebp)
 6b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6bb:	79 da                	jns    697 <printint+0x85>
    putc(fd, buf[i]);
}
 6bd:	c9                   	leave  
 6be:	c3                   	ret    

000006bf <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6bf:	55                   	push   %ebp
 6c0:	89 e5                	mov    %esp,%ebp
 6c2:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6cc:	8d 45 0c             	lea    0xc(%ebp),%eax
 6cf:	83 c0 04             	add    $0x4,%eax
 6d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6dc:	e9 58 01 00 00       	jmp    839 <printf+0x17a>
    c = fmt[i] & 0xff;
 6e1:	8b 55 0c             	mov    0xc(%ebp),%edx
 6e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e7:	8d 04 02             	lea    (%edx,%eax,1),%eax
 6ea:	8a 00                	mov    (%eax),%al
 6ec:	0f be c0             	movsbl %al,%eax
 6ef:	25 ff 00 00 00       	and    $0xff,%eax
 6f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6fb:	75 2c                	jne    729 <printf+0x6a>
      if(c == '%'){
 6fd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 701:	75 0c                	jne    70f <printf+0x50>
        state = '%';
 703:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 70a:	e9 27 01 00 00       	jmp    836 <printf+0x177>
      } else {
        putc(fd, c);
 70f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 712:	0f be c0             	movsbl %al,%eax
 715:	83 ec 08             	sub    $0x8,%esp
 718:	50                   	push   %eax
 719:	ff 75 08             	pushl  0x8(%ebp)
 71c:	e8 cf fe ff ff       	call   5f0 <putc>
 721:	83 c4 10             	add    $0x10,%esp
 724:	e9 0d 01 00 00       	jmp    836 <printf+0x177>
      }
    } else if(state == '%'){
 729:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 72d:	0f 85 03 01 00 00    	jne    836 <printf+0x177>
      if(c == 'd'){
 733:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 737:	75 1e                	jne    757 <printf+0x98>
        printint(fd, *ap, 10, 1);
 739:	8b 45 e8             	mov    -0x18(%ebp),%eax
 73c:	8b 00                	mov    (%eax),%eax
 73e:	6a 01                	push   $0x1
 740:	6a 0a                	push   $0xa
 742:	50                   	push   %eax
 743:	ff 75 08             	pushl  0x8(%ebp)
 746:	e8 c7 fe ff ff       	call   612 <printint>
 74b:	83 c4 10             	add    $0x10,%esp
        ap++;
 74e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 752:	e9 d8 00 00 00       	jmp    82f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 757:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 75b:	74 06                	je     763 <printf+0xa4>
 75d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 761:	75 1e                	jne    781 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 763:	8b 45 e8             	mov    -0x18(%ebp),%eax
 766:	8b 00                	mov    (%eax),%eax
 768:	6a 00                	push   $0x0
 76a:	6a 10                	push   $0x10
 76c:	50                   	push   %eax
 76d:	ff 75 08             	pushl  0x8(%ebp)
 770:	e8 9d fe ff ff       	call   612 <printint>
 775:	83 c4 10             	add    $0x10,%esp
        ap++;
 778:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 77c:	e9 ae 00 00 00       	jmp    82f <printf+0x170>
      } else if(c == 's'){
 781:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 785:	75 43                	jne    7ca <printf+0x10b>
        s = (char*)*ap;
 787:	8b 45 e8             	mov    -0x18(%ebp),%eax
 78a:	8b 00                	mov    (%eax),%eax
 78c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 78f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 793:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 797:	75 25                	jne    7be <printf+0xff>
          s = "(null)";
 799:	c7 45 f4 9e 0a 00 00 	movl   $0xa9e,-0xc(%ebp)
        while(*s != 0){
 7a0:	eb 1d                	jmp    7bf <printf+0x100>
          putc(fd, *s);
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	8a 00                	mov    (%eax),%al
 7a7:	0f be c0             	movsbl %al,%eax
 7aa:	83 ec 08             	sub    $0x8,%esp
 7ad:	50                   	push   %eax
 7ae:	ff 75 08             	pushl  0x8(%ebp)
 7b1:	e8 3a fe ff ff       	call   5f0 <putc>
 7b6:	83 c4 10             	add    $0x10,%esp
          s++;
 7b9:	ff 45 f4             	incl   -0xc(%ebp)
 7bc:	eb 01                	jmp    7bf <printf+0x100>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7be:	90                   	nop
 7bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c2:	8a 00                	mov    (%eax),%al
 7c4:	84 c0                	test   %al,%al
 7c6:	75 da                	jne    7a2 <printf+0xe3>
 7c8:	eb 65                	jmp    82f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7ca:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7ce:	75 1d                	jne    7ed <printf+0x12e>
        putc(fd, *ap);
 7d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d3:	8b 00                	mov    (%eax),%eax
 7d5:	0f be c0             	movsbl %al,%eax
 7d8:	83 ec 08             	sub    $0x8,%esp
 7db:	50                   	push   %eax
 7dc:	ff 75 08             	pushl  0x8(%ebp)
 7df:	e8 0c fe ff ff       	call   5f0 <putc>
 7e4:	83 c4 10             	add    $0x10,%esp
        ap++;
 7e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7eb:	eb 42                	jmp    82f <printf+0x170>
      } else if(c == '%'){
 7ed:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7f1:	75 17                	jne    80a <printf+0x14b>
        putc(fd, c);
 7f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7f6:	0f be c0             	movsbl %al,%eax
 7f9:	83 ec 08             	sub    $0x8,%esp
 7fc:	50                   	push   %eax
 7fd:	ff 75 08             	pushl  0x8(%ebp)
 800:	e8 eb fd ff ff       	call   5f0 <putc>
 805:	83 c4 10             	add    $0x10,%esp
 808:	eb 25                	jmp    82f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 80a:	83 ec 08             	sub    $0x8,%esp
 80d:	6a 25                	push   $0x25
 80f:	ff 75 08             	pushl  0x8(%ebp)
 812:	e8 d9 fd ff ff       	call   5f0 <putc>
 817:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 81a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 81d:	0f be c0             	movsbl %al,%eax
 820:	83 ec 08             	sub    $0x8,%esp
 823:	50                   	push   %eax
 824:	ff 75 08             	pushl  0x8(%ebp)
 827:	e8 c4 fd ff ff       	call   5f0 <putc>
 82c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 82f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 836:	ff 45 f0             	incl   -0x10(%ebp)
 839:	8b 55 0c             	mov    0xc(%ebp),%edx
 83c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83f:	8d 04 02             	lea    (%edx,%eax,1),%eax
 842:	8a 00                	mov    (%eax),%al
 844:	84 c0                	test   %al,%al
 846:	0f 85 95 fe ff ff    	jne    6e1 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 84c:	c9                   	leave  
 84d:	c3                   	ret    
 84e:	90                   	nop
 84f:	90                   	nop

00000850 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 850:	55                   	push   %ebp
 851:	89 e5                	mov    %esp,%ebp
 853:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 856:	8b 45 08             	mov    0x8(%ebp),%eax
 859:	83 e8 08             	sub    $0x8,%eax
 85c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85f:	a1 c8 0a 00 00       	mov    0xac8,%eax
 864:	89 45 fc             	mov    %eax,-0x4(%ebp)
 867:	eb 24                	jmp    88d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 869:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86c:	8b 00                	mov    (%eax),%eax
 86e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 871:	77 12                	ja     885 <free+0x35>
 873:	8b 45 f8             	mov    -0x8(%ebp),%eax
 876:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 879:	77 24                	ja     89f <free+0x4f>
 87b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87e:	8b 00                	mov    (%eax),%eax
 880:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 883:	77 1a                	ja     89f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 885:	8b 45 fc             	mov    -0x4(%ebp),%eax
 888:	8b 00                	mov    (%eax),%eax
 88a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 88d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 890:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 893:	76 d4                	jbe    869 <free+0x19>
 895:	8b 45 fc             	mov    -0x4(%ebp),%eax
 898:	8b 00                	mov    (%eax),%eax
 89a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 89d:	76 ca                	jbe    869 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 89f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a2:	8b 40 04             	mov    0x4(%eax),%eax
 8a5:	c1 e0 03             	shl    $0x3,%eax
 8a8:	89 c2                	mov    %eax,%edx
 8aa:	03 55 f8             	add    -0x8(%ebp),%edx
 8ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b0:	8b 00                	mov    (%eax),%eax
 8b2:	39 c2                	cmp    %eax,%edx
 8b4:	75 24                	jne    8da <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 8b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b9:	8b 50 04             	mov    0x4(%eax),%edx
 8bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bf:	8b 00                	mov    (%eax),%eax
 8c1:	8b 40 04             	mov    0x4(%eax),%eax
 8c4:	01 c2                	add    %eax,%edx
 8c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cf:	8b 00                	mov    (%eax),%eax
 8d1:	8b 10                	mov    (%eax),%edx
 8d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d6:	89 10                	mov    %edx,(%eax)
 8d8:	eb 0a                	jmp    8e4 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 8da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8dd:	8b 10                	mov    (%eax),%edx
 8df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e7:	8b 40 04             	mov    0x4(%eax),%eax
 8ea:	c1 e0 03             	shl    $0x3,%eax
 8ed:	03 45 fc             	add    -0x4(%ebp),%eax
 8f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8f3:	75 20                	jne    915 <free+0xc5>
    p->s.size += bp->s.size;
 8f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f8:	8b 50 04             	mov    0x4(%eax),%edx
 8fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fe:	8b 40 04             	mov    0x4(%eax),%eax
 901:	01 c2                	add    %eax,%edx
 903:	8b 45 fc             	mov    -0x4(%ebp),%eax
 906:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 909:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90c:	8b 10                	mov    (%eax),%edx
 90e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 911:	89 10                	mov    %edx,(%eax)
 913:	eb 08                	jmp    91d <free+0xcd>
  } else
    p->s.ptr = bp;
 915:	8b 45 fc             	mov    -0x4(%ebp),%eax
 918:	8b 55 f8             	mov    -0x8(%ebp),%edx
 91b:	89 10                	mov    %edx,(%eax)
  freep = p;
 91d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 920:	a3 c8 0a 00 00       	mov    %eax,0xac8
}
 925:	c9                   	leave  
 926:	c3                   	ret    

00000927 <morecore>:

static Header*
morecore(uint nu)
{
 927:	55                   	push   %ebp
 928:	89 e5                	mov    %esp,%ebp
 92a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 92d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 934:	77 07                	ja     93d <morecore+0x16>
    nu = 4096;
 936:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 93d:	8b 45 08             	mov    0x8(%ebp),%eax
 940:	c1 e0 03             	shl    $0x3,%eax
 943:	83 ec 0c             	sub    $0xc,%esp
 946:	50                   	push   %eax
 947:	e8 8c fc ff ff       	call   5d8 <sbrk>
 94c:	83 c4 10             	add    $0x10,%esp
 94f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 952:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 956:	75 07                	jne    95f <morecore+0x38>
    return 0;
 958:	b8 00 00 00 00       	mov    $0x0,%eax
 95d:	eb 26                	jmp    985 <morecore+0x5e>
  hp = (Header*)p;
 95f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 962:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 965:	8b 45 f0             	mov    -0x10(%ebp),%eax
 968:	8b 55 08             	mov    0x8(%ebp),%edx
 96b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 96e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 971:	83 c0 08             	add    $0x8,%eax
 974:	83 ec 0c             	sub    $0xc,%esp
 977:	50                   	push   %eax
 978:	e8 d3 fe ff ff       	call   850 <free>
 97d:	83 c4 10             	add    $0x10,%esp
  return freep;
 980:	a1 c8 0a 00 00       	mov    0xac8,%eax
}
 985:	c9                   	leave  
 986:	c3                   	ret    

00000987 <malloc>:

void*
malloc(uint nbytes)
{
 987:	55                   	push   %ebp
 988:	89 e5                	mov    %esp,%ebp
 98a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 98d:	8b 45 08             	mov    0x8(%ebp),%eax
 990:	83 c0 07             	add    $0x7,%eax
 993:	c1 e8 03             	shr    $0x3,%eax
 996:	40                   	inc    %eax
 997:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 99a:	a1 c8 0a 00 00       	mov    0xac8,%eax
 99f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9a6:	75 23                	jne    9cb <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 9a8:	c7 45 f0 c0 0a 00 00 	movl   $0xac0,-0x10(%ebp)
 9af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b2:	a3 c8 0a 00 00       	mov    %eax,0xac8
 9b7:	a1 c8 0a 00 00       	mov    0xac8,%eax
 9bc:	a3 c0 0a 00 00       	mov    %eax,0xac0
    base.s.size = 0;
 9c1:	c7 05 c4 0a 00 00 00 	movl   $0x0,0xac4
 9c8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ce:	8b 00                	mov    (%eax),%eax
 9d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d6:	8b 40 04             	mov    0x4(%eax),%eax
 9d9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9dc:	72 4d                	jb     a2b <malloc+0xa4>
      if(p->s.size == nunits)
 9de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e1:	8b 40 04             	mov    0x4(%eax),%eax
 9e4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9e7:	75 0c                	jne    9f5 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 9e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ec:	8b 10                	mov    (%eax),%edx
 9ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f1:	89 10                	mov    %edx,(%eax)
 9f3:	eb 26                	jmp    a1b <malloc+0x94>
      else {
        p->s.size -= nunits;
 9f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f8:	8b 40 04             	mov    0x4(%eax),%eax
 9fb:	89 c2                	mov    %eax,%edx
 9fd:	2b 55 ec             	sub    -0x14(%ebp),%edx
 a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a03:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a09:	8b 40 04             	mov    0x4(%eax),%eax
 a0c:	c1 e0 03             	shl    $0x3,%eax
 a0f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a15:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a18:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1e:	a3 c8 0a 00 00       	mov    %eax,0xac8
      return (void*)(p + 1);
 a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a26:	83 c0 08             	add    $0x8,%eax
 a29:	eb 3b                	jmp    a66 <malloc+0xdf>
    }
    if(p == freep)
 a2b:	a1 c8 0a 00 00       	mov    0xac8,%eax
 a30:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a33:	75 1e                	jne    a53 <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 a35:	83 ec 0c             	sub    $0xc,%esp
 a38:	ff 75 ec             	pushl  -0x14(%ebp)
 a3b:	e8 e7 fe ff ff       	call   927 <morecore>
 a40:	83 c4 10             	add    $0x10,%esp
 a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a4a:	75 07                	jne    a53 <malloc+0xcc>
        return 0;
 a4c:	b8 00 00 00 00       	mov    $0x0,%eax
 a51:	eb 13                	jmp    a66 <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5c:	8b 00                	mov    (%eax),%eax
 a5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a61:	e9 6d ff ff ff       	jmp    9d3 <malloc+0x4c>
}
 a66:	c9                   	leave  
 a67:	c3                   	ret    
