
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 8b 0e 00 00       	call   e9c <exit>
  
  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 e0 13 00 00 	mov    0x13e0(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	83 ec 0c             	sub    $0xc,%esp
      27:	68 b4 13 00 00       	push   $0x13b4
      2c:	e8 69 03 00 00       	call   39a <panic>
      31:	83 c4 10             	add    $0x10,%esp

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      34:	8b 45 08             	mov    0x8(%ebp),%eax
      37:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
      3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
      3d:	8b 40 04             	mov    0x4(%eax),%eax
      40:	85 c0                	test   %eax,%eax
      42:	75 05                	jne    49 <runcmd+0x49>
      exit();
      44:	e8 53 0e 00 00       	call   e9c <exit>
    exec(ecmd->argv[0], ecmd->argv);
      49:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4c:	8d 50 04             	lea    0x4(%eax),%edx
      4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
      52:	8b 40 04             	mov    0x4(%eax),%eax
      55:	83 ec 08             	sub    $0x8,%esp
      58:	52                   	push   %edx
      59:	50                   	push   %eax
      5a:	e8 75 0e 00 00       	call   ed4 <exec>
      5f:	83 c4 10             	add    $0x10,%esp
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      62:	8b 45 f4             	mov    -0xc(%ebp),%eax
      65:	8b 40 04             	mov    0x4(%eax),%eax
      68:	83 ec 04             	sub    $0x4,%esp
      6b:	50                   	push   %eax
      6c:	68 bb 13 00 00       	push   $0x13bb
      71:	6a 02                	push   $0x2
      73:	e8 93 0f 00 00       	call   100b <printf>
      78:	83 c4 10             	add    $0x10,%esp
    break;
      7b:	e9 c8 01 00 00       	jmp    248 <runcmd+0x248>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
      86:	8b 45 f0             	mov    -0x10(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	83 ec 0c             	sub    $0xc,%esp
      8f:	50                   	push   %eax
      90:	e8 2f 0e 00 00       	call   ec4 <close>
      95:	83 c4 10             	add    $0x10,%esp
    if(open(rcmd->file, rcmd->mode) < 0){
      98:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9b:	8b 50 10             	mov    0x10(%eax),%edx
      9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
      a1:	8b 40 08             	mov    0x8(%eax),%eax
      a4:	83 ec 08             	sub    $0x8,%esp
      a7:	52                   	push   %edx
      a8:	50                   	push   %eax
      a9:	e8 2e 0e 00 00       	call   edc <open>
      ae:	83 c4 10             	add    $0x10,%esp
      b1:	85 c0                	test   %eax,%eax
      b3:	79 1e                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b8:	8b 40 08             	mov    0x8(%eax),%eax
      bb:	83 ec 04             	sub    $0x4,%esp
      be:	50                   	push   %eax
      bf:	68 cb 13 00 00       	push   $0x13cb
      c4:	6a 02                	push   $0x2
      c6:	e8 40 0f 00 00       	call   100b <printf>
      cb:	83 c4 10             	add    $0x10,%esp
      exit();
      ce:	e8 c9 0d 00 00       	call   e9c <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	83 ec 0c             	sub    $0xc,%esp
      dc:	50                   	push   %eax
      dd:	e8 1e ff ff ff       	call   0 <runcmd>
      e2:	83 c4 10             	add    $0x10,%esp
    break;
      e5:	e9 5e 01 00 00       	jmp    248 <runcmd+0x248>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      ea:	8b 45 08             	mov    0x8(%ebp),%eax
      ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
      f0:	e8 c5 02 00 00       	call   3ba <fork1>
      f5:	85 c0                	test   %eax,%eax
      f7:	75 12                	jne    10b <runcmd+0x10b>
      runcmd(lcmd->left);
      f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
      fc:	8b 40 04             	mov    0x4(%eax),%eax
      ff:	83 ec 0c             	sub    $0xc,%esp
     102:	50                   	push   %eax
     103:	e8 f8 fe ff ff       	call   0 <runcmd>
     108:	83 c4 10             	add    $0x10,%esp
    wait();
     10b:	e8 94 0d 00 00       	call   ea4 <wait>
    runcmd(lcmd->right);
     110:	8b 45 ec             	mov    -0x14(%ebp),%eax
     113:	8b 40 08             	mov    0x8(%eax),%eax
     116:	83 ec 0c             	sub    $0xc,%esp
     119:	50                   	push   %eax
     11a:	e8 e1 fe ff ff       	call   0 <runcmd>
     11f:	83 c4 10             	add    $0x10,%esp
    break;
     122:	e9 21 01 00 00       	jmp    248 <runcmd+0x248>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     127:	8b 45 08             	mov    0x8(%ebp),%eax
     12a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     12d:	83 ec 0c             	sub    $0xc,%esp
     130:	8d 45 dc             	lea    -0x24(%ebp),%eax
     133:	50                   	push   %eax
     134:	e8 73 0d 00 00       	call   eac <pipe>
     139:	83 c4 10             	add    $0x10,%esp
     13c:	85 c0                	test   %eax,%eax
     13e:	79 10                	jns    150 <runcmd+0x150>
      panic("pipe");
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	68 db 13 00 00       	push   $0x13db
     148:	e8 4d 02 00 00       	call   39a <panic>
     14d:	83 c4 10             	add    $0x10,%esp
    if(fork1() == 0){
     150:	e8 65 02 00 00       	call   3ba <fork1>
     155:	85 c0                	test   %eax,%eax
     157:	75 4c                	jne    1a5 <runcmd+0x1a5>
      close(1);
     159:	83 ec 0c             	sub    $0xc,%esp
     15c:	6a 01                	push   $0x1
     15e:	e8 61 0d 00 00       	call   ec4 <close>
     163:	83 c4 10             	add    $0x10,%esp
      dup(p[1]);
     166:	8b 45 e0             	mov    -0x20(%ebp),%eax
     169:	83 ec 0c             	sub    $0xc,%esp
     16c:	50                   	push   %eax
     16d:	e8 a2 0d 00 00       	call   f14 <dup>
     172:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     175:	8b 45 dc             	mov    -0x24(%ebp),%eax
     178:	83 ec 0c             	sub    $0xc,%esp
     17b:	50                   	push   %eax
     17c:	e8 43 0d 00 00       	call   ec4 <close>
     181:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     184:	8b 45 e0             	mov    -0x20(%ebp),%eax
     187:	83 ec 0c             	sub    $0xc,%esp
     18a:	50                   	push   %eax
     18b:	e8 34 0d 00 00       	call   ec4 <close>
     190:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->left);
     193:	8b 45 e8             	mov    -0x18(%ebp),%eax
     196:	8b 40 04             	mov    0x4(%eax),%eax
     199:	83 ec 0c             	sub    $0xc,%esp
     19c:	50                   	push   %eax
     19d:	e8 5e fe ff ff       	call   0 <runcmd>
     1a2:	83 c4 10             	add    $0x10,%esp
    }
    if(fork1() == 0){
     1a5:	e8 10 02 00 00       	call   3ba <fork1>
     1aa:	85 c0                	test   %eax,%eax
     1ac:	75 4c                	jne    1fa <runcmd+0x1fa>
      close(0);
     1ae:	83 ec 0c             	sub    $0xc,%esp
     1b1:	6a 00                	push   $0x0
     1b3:	e8 0c 0d 00 00       	call   ec4 <close>
     1b8:	83 c4 10             	add    $0x10,%esp
      dup(p[0]);
     1bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1be:	83 ec 0c             	sub    $0xc,%esp
     1c1:	50                   	push   %eax
     1c2:	e8 4d 0d 00 00       	call   f14 <dup>
     1c7:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     1ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1cd:	83 ec 0c             	sub    $0xc,%esp
     1d0:	50                   	push   %eax
     1d1:	e8 ee 0c 00 00       	call   ec4 <close>
     1d6:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     1d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1dc:	83 ec 0c             	sub    $0xc,%esp
     1df:	50                   	push   %eax
     1e0:	e8 df 0c 00 00       	call   ec4 <close>
     1e5:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->right);
     1e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1eb:	8b 40 08             	mov    0x8(%eax),%eax
     1ee:	83 ec 0c             	sub    $0xc,%esp
     1f1:	50                   	push   %eax
     1f2:	e8 09 fe ff ff       	call   0 <runcmd>
     1f7:	83 c4 10             	add    $0x10,%esp
    }
    close(p[0]);
     1fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1fd:	83 ec 0c             	sub    $0xc,%esp
     200:	50                   	push   %eax
     201:	e8 be 0c 00 00       	call   ec4 <close>
     206:	83 c4 10             	add    $0x10,%esp
    close(p[1]);
     209:	8b 45 e0             	mov    -0x20(%ebp),%eax
     20c:	83 ec 0c             	sub    $0xc,%esp
     20f:	50                   	push   %eax
     210:	e8 af 0c 00 00       	call   ec4 <close>
     215:	83 c4 10             	add    $0x10,%esp
    wait();
     218:	e8 87 0c 00 00       	call   ea4 <wait>
    wait();
     21d:	e8 82 0c 00 00       	call   ea4 <wait>
    break;
     222:	eb 24                	jmp    248 <runcmd+0x248>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     224:	8b 45 08             	mov    0x8(%ebp),%eax
     227:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     22a:	e8 8b 01 00 00       	call   3ba <fork1>
     22f:	85 c0                	test   %eax,%eax
     231:	75 14                	jne    247 <runcmd+0x247>
      runcmd(bcmd->cmd);
     233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     236:	8b 40 04             	mov    0x4(%eax),%eax
     239:	83 ec 0c             	sub    $0xc,%esp
     23c:	50                   	push   %eax
     23d:	e8 be fd ff ff       	call   0 <runcmd>
     242:	83 c4 10             	add    $0x10,%esp
    break;
     245:	eb 01                	jmp    248 <runcmd+0x248>
     247:	90                   	nop
  }
  exit();
     248:	e8 4f 0c 00 00       	call   e9c <exit>

0000024d <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     24d:	55                   	push   %ebp
     24e:	89 e5                	mov    %esp,%ebp
     250:	83 ec 08             	sub    $0x8,%esp
  printf(2, "$ ");
     253:	83 ec 08             	sub    $0x8,%esp
     256:	68 f8 13 00 00       	push   $0x13f8
     25b:	6a 02                	push   $0x2
     25d:	e8 a9 0d 00 00       	call   100b <printf>
     262:	83 c4 10             	add    $0x10,%esp
  memset(buf, 0, nbuf);
     265:	8b 45 0c             	mov    0xc(%ebp),%eax
     268:	83 ec 04             	sub    $0x4,%esp
     26b:	50                   	push   %eax
     26c:	6a 00                	push   $0x0
     26e:	ff 75 08             	pushl  0x8(%ebp)
     271:	e8 a4 0a 00 00       	call   d1a <memset>
     276:	83 c4 10             	add    $0x10,%esp
  gets(buf, nbuf);
     279:	83 ec 08             	sub    $0x8,%esp
     27c:	ff 75 0c             	pushl  0xc(%ebp)
     27f:	ff 75 08             	pushl  0x8(%ebp)
     282:	e8 dd 0a 00 00       	call   d64 <gets>
     287:	83 c4 10             	add    $0x10,%esp
  if(buf[0] == 0) // EOF
     28a:	8b 45 08             	mov    0x8(%ebp),%eax
     28d:	8a 00                	mov    (%eax),%al
     28f:	84 c0                	test   %al,%al
     291:	75 07                	jne    29a <getcmd+0x4d>
    return -1;
     293:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     298:	eb 05                	jmp    29f <getcmd+0x52>
  return 0;
     29a:	b8 00 00 00 00       	mov    $0x0,%eax
}
     29f:	c9                   	leave  
     2a0:	c3                   	ret    

000002a1 <main>:

int
main(void)
{
     2a1:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     2a5:	83 e4 f0             	and    $0xfffffff0,%esp
     2a8:	ff 71 fc             	pushl  -0x4(%ecx)
     2ab:	55                   	push   %ebp
     2ac:	89 e5                	mov    %esp,%ebp
     2ae:	51                   	push   %ecx
     2af:	83 ec 14             	sub    $0x14,%esp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     2b2:	eb 1a                	jmp    2ce <main+0x2d>
    if(fd >= 3){
     2b4:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
     2b8:	7e 14                	jle    2ce <main+0x2d>
      close(fd);
     2ba:	83 ec 0c             	sub    $0xc,%esp
     2bd:	ff 75 f4             	pushl  -0xc(%ebp)
     2c0:	e8 ff 0b 00 00       	call   ec4 <close>
     2c5:	83 c4 10             	add    $0x10,%esp
      break;
     2c8:	90                   	nop
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2c9:	e9 ad 00 00 00       	jmp    37b <main+0xda>
{
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     2ce:	83 ec 08             	sub    $0x8,%esp
     2d1:	6a 02                	push   $0x2
     2d3:	68 fb 13 00 00       	push   $0x13fb
     2d8:	e8 ff 0b 00 00       	call   edc <open>
     2dd:	83 c4 10             	add    $0x10,%esp
     2e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
     2e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2e7:	79 cb                	jns    2b4 <main+0x13>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2e9:	e9 8d 00 00 00       	jmp    37b <main+0xda>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     2ee:	a0 e0 14 00 00       	mov    0x14e0,%al
     2f3:	3c 63                	cmp    $0x63,%al
     2f5:	75 57                	jne    34e <main+0xad>
     2f7:	a0 e1 14 00 00       	mov    0x14e1,%al
     2fc:	3c 64                	cmp    $0x64,%al
     2fe:	75 4e                	jne    34e <main+0xad>
     300:	a0 e2 14 00 00       	mov    0x14e2,%al
     305:	3c 20                	cmp    $0x20,%al
     307:	75 45                	jne    34e <main+0xad>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     309:	83 ec 0c             	sub    $0xc,%esp
     30c:	68 e0 14 00 00       	push   $0x14e0
     311:	e8 e1 09 00 00       	call   cf7 <strlen>
     316:	83 c4 10             	add    $0x10,%esp
     319:	48                   	dec    %eax
     31a:	c6 80 e0 14 00 00 00 	movb   $0x0,0x14e0(%eax)
      if(chdir(buf+3) < 0)
     321:	83 ec 0c             	sub    $0xc,%esp
     324:	68 e3 14 00 00       	push   $0x14e3
     329:	e8 de 0b 00 00       	call   f0c <chdir>
     32e:	83 c4 10             	add    $0x10,%esp
     331:	85 c0                	test   %eax,%eax
     333:	79 45                	jns    37a <main+0xd9>
        printf(2, "cannot cd %s\n", buf+3);
     335:	83 ec 04             	sub    $0x4,%esp
     338:	68 e3 14 00 00       	push   $0x14e3
     33d:	68 03 14 00 00       	push   $0x1403
     342:	6a 02                	push   $0x2
     344:	e8 c2 0c 00 00       	call   100b <printf>
     349:	83 c4 10             	add    $0x10,%esp
      continue;
     34c:	eb 2d                	jmp    37b <main+0xda>
    }
    if(fork1() == 0)
     34e:	e8 67 00 00 00       	call   3ba <fork1>
     353:	85 c0                	test   %eax,%eax
     355:	75 1c                	jne    373 <main+0xd2>
      runcmd(parsecmd(buf));
     357:	83 ec 0c             	sub    $0xc,%esp
     35a:	68 e0 14 00 00       	push   $0x14e0
     35f:	e8 9a 03 00 00       	call   6fe <parsecmd>
     364:	83 c4 10             	add    $0x10,%esp
     367:	83 ec 0c             	sub    $0xc,%esp
     36a:	50                   	push   %eax
     36b:	e8 90 fc ff ff       	call   0 <runcmd>
     370:	83 c4 10             	add    $0x10,%esp
    wait();
     373:	e8 2c 0b 00 00       	call   ea4 <wait>
     378:	eb 01                	jmp    37b <main+0xda>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
     37a:	90                   	nop
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     37b:	83 ec 08             	sub    $0x8,%esp
     37e:	6a 64                	push   $0x64
     380:	68 e0 14 00 00       	push   $0x14e0
     385:	e8 c3 fe ff ff       	call   24d <getcmd>
     38a:	83 c4 10             	add    $0x10,%esp
     38d:	85 c0                	test   %eax,%eax
     38f:	0f 89 59 ff ff ff    	jns    2ee <main+0x4d>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     395:	e8 02 0b 00 00       	call   e9c <exit>

0000039a <panic>:
}

void
panic(char *s)
{
     39a:	55                   	push   %ebp
     39b:	89 e5                	mov    %esp,%ebp
     39d:	83 ec 08             	sub    $0x8,%esp
  printf(2, "%s\n", s);
     3a0:	83 ec 04             	sub    $0x4,%esp
     3a3:	ff 75 08             	pushl  0x8(%ebp)
     3a6:	68 11 14 00 00       	push   $0x1411
     3ab:	6a 02                	push   $0x2
     3ad:	e8 59 0c 00 00       	call   100b <printf>
     3b2:	83 c4 10             	add    $0x10,%esp
  exit();
     3b5:	e8 e2 0a 00 00       	call   e9c <exit>

000003ba <fork1>:
}

int
fork1(void)
{
     3ba:	55                   	push   %ebp
     3bb:	89 e5                	mov    %esp,%ebp
     3bd:	83 ec 18             	sub    $0x18,%esp
  int pid;
  
  pid = fork();
     3c0:	e8 cf 0a 00 00       	call   e94 <fork>
     3c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     3c8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     3cc:	75 10                	jne    3de <fork1+0x24>
    panic("fork");
     3ce:	83 ec 0c             	sub    $0xc,%esp
     3d1:	68 15 14 00 00       	push   $0x1415
     3d6:	e8 bf ff ff ff       	call   39a <panic>
     3db:	83 c4 10             	add    $0x10,%esp
  return pid;
     3de:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3e1:	c9                   	leave  
     3e2:	c3                   	ret    

000003e3 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3e3:	55                   	push   %ebp
     3e4:	89 e5                	mov    %esp,%ebp
     3e6:	83 ec 18             	sub    $0x18,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3e9:	83 ec 0c             	sub    $0xc,%esp
     3ec:	6a 54                	push   $0x54
     3ee:	e8 e0 0e 00 00       	call   12d3 <malloc>
     3f3:	83 c4 10             	add    $0x10,%esp
     3f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3f9:	83 ec 04             	sub    $0x4,%esp
     3fc:	6a 54                	push   $0x54
     3fe:	6a 00                	push   $0x0
     400:	ff 75 f4             	pushl  -0xc(%ebp)
     403:	e8 12 09 00 00       	call   d1a <memset>
     408:	83 c4 10             	add    $0x10,%esp
  cmd->type = EXEC;
     40b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     40e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     414:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     417:	c9                   	leave  
     418:	c3                   	ret    

00000419 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     419:	55                   	push   %ebp
     41a:	89 e5                	mov    %esp,%ebp
     41c:	83 ec 18             	sub    $0x18,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     41f:	83 ec 0c             	sub    $0xc,%esp
     422:	6a 18                	push   $0x18
     424:	e8 aa 0e 00 00       	call   12d3 <malloc>
     429:	83 c4 10             	add    $0x10,%esp
     42c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     42f:	83 ec 04             	sub    $0x4,%esp
     432:	6a 18                	push   $0x18
     434:	6a 00                	push   $0x0
     436:	ff 75 f4             	pushl  -0xc(%ebp)
     439:	e8 dc 08 00 00       	call   d1a <memset>
     43e:	83 c4 10             	add    $0x10,%esp
  cmd->type = REDIR;
     441:	8b 45 f4             	mov    -0xc(%ebp),%eax
     444:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     44a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     44d:	8b 55 08             	mov    0x8(%ebp),%edx
     450:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     453:	8b 45 f4             	mov    -0xc(%ebp),%eax
     456:	8b 55 0c             	mov    0xc(%ebp),%edx
     459:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     45c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     45f:	8b 55 10             	mov    0x10(%ebp),%edx
     462:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     465:	8b 45 f4             	mov    -0xc(%ebp),%eax
     468:	8b 55 14             	mov    0x14(%ebp),%edx
     46b:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     46e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     471:	8b 55 18             	mov    0x18(%ebp),%edx
     474:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     477:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     47a:	c9                   	leave  
     47b:	c3                   	ret    

0000047c <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     47c:	55                   	push   %ebp
     47d:	89 e5                	mov    %esp,%ebp
     47f:	83 ec 18             	sub    $0x18,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     482:	83 ec 0c             	sub    $0xc,%esp
     485:	6a 0c                	push   $0xc
     487:	e8 47 0e 00 00       	call   12d3 <malloc>
     48c:	83 c4 10             	add    $0x10,%esp
     48f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     492:	83 ec 04             	sub    $0x4,%esp
     495:	6a 0c                	push   $0xc
     497:	6a 00                	push   $0x0
     499:	ff 75 f4             	pushl  -0xc(%ebp)
     49c:	e8 79 08 00 00       	call   d1a <memset>
     4a1:	83 c4 10             	add    $0x10,%esp
  cmd->type = PIPE;
     4a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4a7:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     4ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4b0:	8b 55 08             	mov    0x8(%ebp),%edx
     4b3:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4b9:	8b 55 0c             	mov    0xc(%ebp),%edx
     4bc:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     4bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4c2:	c9                   	leave  
     4c3:	c3                   	ret    

000004c4 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     4c4:	55                   	push   %ebp
     4c5:	89 e5                	mov    %esp,%ebp
     4c7:	83 ec 18             	sub    $0x18,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4ca:	83 ec 0c             	sub    $0xc,%esp
     4cd:	6a 0c                	push   $0xc
     4cf:	e8 ff 0d 00 00       	call   12d3 <malloc>
     4d4:	83 c4 10             	add    $0x10,%esp
     4d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4da:	83 ec 04             	sub    $0x4,%esp
     4dd:	6a 0c                	push   $0xc
     4df:	6a 00                	push   $0x0
     4e1:	ff 75 f4             	pushl  -0xc(%ebp)
     4e4:	e8 31 08 00 00       	call   d1a <memset>
     4e9:	83 c4 10             	add    $0x10,%esp
  cmd->type = LIST;
     4ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ef:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     4f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4f8:	8b 55 08             	mov    0x8(%ebp),%edx
     4fb:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
     501:	8b 55 0c             	mov    0xc(%ebp),%edx
     504:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     507:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     50a:	c9                   	leave  
     50b:	c3                   	ret    

0000050c <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     50c:	55                   	push   %ebp
     50d:	89 e5                	mov    %esp,%ebp
     50f:	83 ec 18             	sub    $0x18,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     512:	83 ec 0c             	sub    $0xc,%esp
     515:	6a 08                	push   $0x8
     517:	e8 b7 0d 00 00       	call   12d3 <malloc>
     51c:	83 c4 10             	add    $0x10,%esp
     51f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     522:	83 ec 04             	sub    $0x4,%esp
     525:	6a 08                	push   $0x8
     527:	6a 00                	push   $0x0
     529:	ff 75 f4             	pushl  -0xc(%ebp)
     52c:	e8 e9 07 00 00       	call   d1a <memset>
     531:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     534:	8b 45 f4             	mov    -0xc(%ebp),%eax
     537:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     53d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     540:	8b 55 08             	mov    0x8(%ebp),%edx
     543:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     546:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     549:	c9                   	leave  
     54a:	c3                   	ret    

0000054b <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     54b:	55                   	push   %ebp
     54c:	89 e5                	mov    %esp,%ebp
     54e:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int ret;
  
  s = *ps;
     551:	8b 45 08             	mov    0x8(%ebp),%eax
     554:	8b 00                	mov    (%eax),%eax
     556:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     559:	eb 03                	jmp    55e <gettoken+0x13>
    s++;
     55b:	ff 45 f4             	incl   -0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     55e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     561:	3b 45 0c             	cmp    0xc(%ebp),%eax
     564:	73 1d                	jae    583 <gettoken+0x38>
     566:	8b 45 f4             	mov    -0xc(%ebp),%eax
     569:	8a 00                	mov    (%eax),%al
     56b:	0f be c0             	movsbl %al,%eax
     56e:	83 ec 08             	sub    $0x8,%esp
     571:	50                   	push   %eax
     572:	68 ac 14 00 00       	push   $0x14ac
     577:	e8 b8 07 00 00       	call   d34 <strchr>
     57c:	83 c4 10             	add    $0x10,%esp
     57f:	85 c0                	test   %eax,%eax
     581:	75 d8                	jne    55b <gettoken+0x10>
    s++;
  if(q)
     583:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     587:	74 08                	je     591 <gettoken+0x46>
    *q = s;
     589:	8b 45 10             	mov    0x10(%ebp),%eax
     58c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     58f:	89 10                	mov    %edx,(%eax)
  ret = *s;
     591:	8b 45 f4             	mov    -0xc(%ebp),%eax
     594:	8a 00                	mov    (%eax),%al
     596:	0f be c0             	movsbl %al,%eax
     599:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     59c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     59f:	8a 00                	mov    (%eax),%al
     5a1:	0f be c0             	movsbl %al,%eax
     5a4:	83 f8 3c             	cmp    $0x3c,%eax
     5a7:	7f 1a                	jg     5c3 <gettoken+0x78>
     5a9:	83 f8 3b             	cmp    $0x3b,%eax
     5ac:	7d 1f                	jge    5cd <gettoken+0x82>
     5ae:	83 f8 29             	cmp    $0x29,%eax
     5b1:	7f 37                	jg     5ea <gettoken+0x9f>
     5b3:	83 f8 28             	cmp    $0x28,%eax
     5b6:	7d 15                	jge    5cd <gettoken+0x82>
     5b8:	85 c0                	test   %eax,%eax
     5ba:	74 7e                	je     63a <gettoken+0xef>
     5bc:	83 f8 26             	cmp    $0x26,%eax
     5bf:	74 0c                	je     5cd <gettoken+0x82>
     5c1:	eb 27                	jmp    5ea <gettoken+0x9f>
     5c3:	83 f8 3e             	cmp    $0x3e,%eax
     5c6:	74 0a                	je     5d2 <gettoken+0x87>
     5c8:	83 f8 7c             	cmp    $0x7c,%eax
     5cb:	75 1d                	jne    5ea <gettoken+0x9f>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5cd:	ff 45 f4             	incl   -0xc(%ebp)
    break;
     5d0:	eb 72                	jmp    644 <gettoken+0xf9>
  case '>':
    s++;
     5d2:	ff 45 f4             	incl   -0xc(%ebp)
    if(*s == '>'){
     5d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5d8:	8a 00                	mov    (%eax),%al
     5da:	3c 3e                	cmp    $0x3e,%al
     5dc:	75 5f                	jne    63d <gettoken+0xf2>
      ret = '+';
     5de:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     5e5:	ff 45 f4             	incl   -0xc(%ebp)
    }
    break;
     5e8:	eb 5a                	jmp    644 <gettoken+0xf9>
  default:
    ret = 'a';
     5ea:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5f1:	eb 03                	jmp    5f6 <gettoken+0xab>
      s++;
     5f3:	ff 45 f4             	incl   -0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5f9:	3b 45 0c             	cmp    0xc(%ebp),%eax
     5fc:	73 42                	jae    640 <gettoken+0xf5>
     5fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
     601:	8a 00                	mov    (%eax),%al
     603:	0f be c0             	movsbl %al,%eax
     606:	83 ec 08             	sub    $0x8,%esp
     609:	50                   	push   %eax
     60a:	68 ac 14 00 00       	push   $0x14ac
     60f:	e8 20 07 00 00       	call   d34 <strchr>
     614:	83 c4 10             	add    $0x10,%esp
     617:	85 c0                	test   %eax,%eax
     619:	75 28                	jne    643 <gettoken+0xf8>
     61b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     61e:	8a 00                	mov    (%eax),%al
     620:	0f be c0             	movsbl %al,%eax
     623:	83 ec 08             	sub    $0x8,%esp
     626:	50                   	push   %eax
     627:	68 b2 14 00 00       	push   $0x14b2
     62c:	e8 03 07 00 00       	call   d34 <strchr>
     631:	83 c4 10             	add    $0x10,%esp
     634:	85 c0                	test   %eax,%eax
     636:	74 bb                	je     5f3 <gettoken+0xa8>
      s++;
    break;
     638:	eb 0a                	jmp    644 <gettoken+0xf9>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     63a:	90                   	nop
     63b:	eb 07                	jmp    644 <gettoken+0xf9>
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    }
    break;
     63d:	90                   	nop
     63e:	eb 04                	jmp    644 <gettoken+0xf9>
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
     640:	90                   	nop
     641:	eb 01                	jmp    644 <gettoken+0xf9>
     643:	90                   	nop
  }
  if(eq)
     644:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     648:	74 0f                	je     659 <gettoken+0x10e>
    *eq = s;
     64a:	8b 45 14             	mov    0x14(%ebp),%eax
     64d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     650:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     652:	eb 06                	jmp    65a <gettoken+0x10f>
    s++;
     654:	ff 45 f4             	incl   -0xc(%ebp)
     657:	eb 01                	jmp    65a <gettoken+0x10f>
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     659:	90                   	nop
     65a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     65d:	3b 45 0c             	cmp    0xc(%ebp),%eax
     660:	73 1d                	jae    67f <gettoken+0x134>
     662:	8b 45 f4             	mov    -0xc(%ebp),%eax
     665:	8a 00                	mov    (%eax),%al
     667:	0f be c0             	movsbl %al,%eax
     66a:	83 ec 08             	sub    $0x8,%esp
     66d:	50                   	push   %eax
     66e:	68 ac 14 00 00       	push   $0x14ac
     673:	e8 bc 06 00 00       	call   d34 <strchr>
     678:	83 c4 10             	add    $0x10,%esp
     67b:	85 c0                	test   %eax,%eax
     67d:	75 d5                	jne    654 <gettoken+0x109>
    s++;
  *ps = s;
     67f:	8b 45 08             	mov    0x8(%ebp),%eax
     682:	8b 55 f4             	mov    -0xc(%ebp),%edx
     685:	89 10                	mov    %edx,(%eax)
  return ret;
     687:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     68a:	c9                   	leave  
     68b:	c3                   	ret    

0000068c <peek>:

int
peek(char **ps, char *es, char *toks)
{
     68c:	55                   	push   %ebp
     68d:	89 e5                	mov    %esp,%ebp
     68f:	83 ec 18             	sub    $0x18,%esp
  char *s;
  
  s = *ps;
     692:	8b 45 08             	mov    0x8(%ebp),%eax
     695:	8b 00                	mov    (%eax),%eax
     697:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     69a:	eb 03                	jmp    69f <peek+0x13>
    s++;
     69c:	ff 45 f4             	incl   -0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     69f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6a2:	3b 45 0c             	cmp    0xc(%ebp),%eax
     6a5:	73 1d                	jae    6c4 <peek+0x38>
     6a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6aa:	8a 00                	mov    (%eax),%al
     6ac:	0f be c0             	movsbl %al,%eax
     6af:	83 ec 08             	sub    $0x8,%esp
     6b2:	50                   	push   %eax
     6b3:	68 ac 14 00 00       	push   $0x14ac
     6b8:	e8 77 06 00 00       	call   d34 <strchr>
     6bd:	83 c4 10             	add    $0x10,%esp
     6c0:	85 c0                	test   %eax,%eax
     6c2:	75 d8                	jne    69c <peek+0x10>
    s++;
  *ps = s;
     6c4:	8b 45 08             	mov    0x8(%ebp),%eax
     6c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6ca:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     6cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6cf:	8a 00                	mov    (%eax),%al
     6d1:	84 c0                	test   %al,%al
     6d3:	74 22                	je     6f7 <peek+0x6b>
     6d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6d8:	8a 00                	mov    (%eax),%al
     6da:	0f be c0             	movsbl %al,%eax
     6dd:	83 ec 08             	sub    $0x8,%esp
     6e0:	50                   	push   %eax
     6e1:	ff 75 10             	pushl  0x10(%ebp)
     6e4:	e8 4b 06 00 00       	call   d34 <strchr>
     6e9:	83 c4 10             	add    $0x10,%esp
     6ec:	85 c0                	test   %eax,%eax
     6ee:	74 07                	je     6f7 <peek+0x6b>
     6f0:	b8 01 00 00 00       	mov    $0x1,%eax
     6f5:	eb 05                	jmp    6fc <peek+0x70>
     6f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
     6fc:	c9                   	leave  
     6fd:	c3                   	ret    

000006fe <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     6fe:	55                   	push   %ebp
     6ff:	89 e5                	mov    %esp,%ebp
     701:	53                   	push   %ebx
     702:	83 ec 14             	sub    $0x14,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     705:	8b 5d 08             	mov    0x8(%ebp),%ebx
     708:	8b 45 08             	mov    0x8(%ebp),%eax
     70b:	83 ec 0c             	sub    $0xc,%esp
     70e:	50                   	push   %eax
     70f:	e8 e3 05 00 00       	call   cf7 <strlen>
     714:	83 c4 10             	add    $0x10,%esp
     717:	8d 04 03             	lea    (%ebx,%eax,1),%eax
     71a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     71d:	83 ec 08             	sub    $0x8,%esp
     720:	ff 75 f4             	pushl  -0xc(%ebp)
     723:	8d 45 08             	lea    0x8(%ebp),%eax
     726:	50                   	push   %eax
     727:	e8 61 00 00 00       	call   78d <parseline>
     72c:	83 c4 10             	add    $0x10,%esp
     72f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     732:	83 ec 04             	sub    $0x4,%esp
     735:	68 1a 14 00 00       	push   $0x141a
     73a:	ff 75 f4             	pushl  -0xc(%ebp)
     73d:	8d 45 08             	lea    0x8(%ebp),%eax
     740:	50                   	push   %eax
     741:	e8 46 ff ff ff       	call   68c <peek>
     746:	83 c4 10             	add    $0x10,%esp
  if(s != es){
     749:	8b 45 08             	mov    0x8(%ebp),%eax
     74c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     74f:	74 26                	je     777 <parsecmd+0x79>
    printf(2, "leftovers: %s\n", s);
     751:	8b 45 08             	mov    0x8(%ebp),%eax
     754:	83 ec 04             	sub    $0x4,%esp
     757:	50                   	push   %eax
     758:	68 1b 14 00 00       	push   $0x141b
     75d:	6a 02                	push   $0x2
     75f:	e8 a7 08 00 00       	call   100b <printf>
     764:	83 c4 10             	add    $0x10,%esp
    panic("syntax");
     767:	83 ec 0c             	sub    $0xc,%esp
     76a:	68 2a 14 00 00       	push   $0x142a
     76f:	e8 26 fc ff ff       	call   39a <panic>
     774:	83 c4 10             	add    $0x10,%esp
  }
  nulterminate(cmd);
     777:	83 ec 0c             	sub    $0xc,%esp
     77a:	ff 75 f0             	pushl  -0x10(%ebp)
     77d:	e8 ea 03 00 00       	call   b6c <nulterminate>
     782:	83 c4 10             	add    $0x10,%esp
  return cmd;
     785:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     788:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     78b:	c9                   	leave  
     78c:	c3                   	ret    

0000078d <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     78d:	55                   	push   %ebp
     78e:	89 e5                	mov    %esp,%ebp
     790:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     793:	83 ec 08             	sub    $0x8,%esp
     796:	ff 75 0c             	pushl  0xc(%ebp)
     799:	ff 75 08             	pushl  0x8(%ebp)
     79c:	e8 99 00 00 00       	call   83a <parsepipe>
     7a1:	83 c4 10             	add    $0x10,%esp
     7a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     7a7:	eb 23                	jmp    7cc <parseline+0x3f>
    gettoken(ps, es, 0, 0);
     7a9:	6a 00                	push   $0x0
     7ab:	6a 00                	push   $0x0
     7ad:	ff 75 0c             	pushl  0xc(%ebp)
     7b0:	ff 75 08             	pushl  0x8(%ebp)
     7b3:	e8 93 fd ff ff       	call   54b <gettoken>
     7b8:	83 c4 10             	add    $0x10,%esp
    cmd = backcmd(cmd);
     7bb:	83 ec 0c             	sub    $0xc,%esp
     7be:	ff 75 f4             	pushl  -0xc(%ebp)
     7c1:	e8 46 fd ff ff       	call   50c <backcmd>
     7c6:	83 c4 10             	add    $0x10,%esp
     7c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     7cc:	83 ec 04             	sub    $0x4,%esp
     7cf:	68 31 14 00 00       	push   $0x1431
     7d4:	ff 75 0c             	pushl  0xc(%ebp)
     7d7:	ff 75 08             	pushl  0x8(%ebp)
     7da:	e8 ad fe ff ff       	call   68c <peek>
     7df:	83 c4 10             	add    $0x10,%esp
     7e2:	85 c0                	test   %eax,%eax
     7e4:	75 c3                	jne    7a9 <parseline+0x1c>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     7e6:	83 ec 04             	sub    $0x4,%esp
     7e9:	68 33 14 00 00       	push   $0x1433
     7ee:	ff 75 0c             	pushl  0xc(%ebp)
     7f1:	ff 75 08             	pushl  0x8(%ebp)
     7f4:	e8 93 fe ff ff       	call   68c <peek>
     7f9:	83 c4 10             	add    $0x10,%esp
     7fc:	85 c0                	test   %eax,%eax
     7fe:	74 35                	je     835 <parseline+0xa8>
    gettoken(ps, es, 0, 0);
     800:	6a 00                	push   $0x0
     802:	6a 00                	push   $0x0
     804:	ff 75 0c             	pushl  0xc(%ebp)
     807:	ff 75 08             	pushl  0x8(%ebp)
     80a:	e8 3c fd ff ff       	call   54b <gettoken>
     80f:	83 c4 10             	add    $0x10,%esp
    cmd = listcmd(cmd, parseline(ps, es));
     812:	83 ec 08             	sub    $0x8,%esp
     815:	ff 75 0c             	pushl  0xc(%ebp)
     818:	ff 75 08             	pushl  0x8(%ebp)
     81b:	e8 6d ff ff ff       	call   78d <parseline>
     820:	83 c4 10             	add    $0x10,%esp
     823:	83 ec 08             	sub    $0x8,%esp
     826:	50                   	push   %eax
     827:	ff 75 f4             	pushl  -0xc(%ebp)
     82a:	e8 95 fc ff ff       	call   4c4 <listcmd>
     82f:	83 c4 10             	add    $0x10,%esp
     832:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     835:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     838:	c9                   	leave  
     839:	c3                   	ret    

0000083a <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     83a:	55                   	push   %ebp
     83b:	89 e5                	mov    %esp,%ebp
     83d:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     840:	83 ec 08             	sub    $0x8,%esp
     843:	ff 75 0c             	pushl  0xc(%ebp)
     846:	ff 75 08             	pushl  0x8(%ebp)
     849:	e8 ec 01 00 00       	call   a3a <parseexec>
     84e:	83 c4 10             	add    $0x10,%esp
     851:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     854:	83 ec 04             	sub    $0x4,%esp
     857:	68 35 14 00 00       	push   $0x1435
     85c:	ff 75 0c             	pushl  0xc(%ebp)
     85f:	ff 75 08             	pushl  0x8(%ebp)
     862:	e8 25 fe ff ff       	call   68c <peek>
     867:	83 c4 10             	add    $0x10,%esp
     86a:	85 c0                	test   %eax,%eax
     86c:	74 35                	je     8a3 <parsepipe+0x69>
    gettoken(ps, es, 0, 0);
     86e:	6a 00                	push   $0x0
     870:	6a 00                	push   $0x0
     872:	ff 75 0c             	pushl  0xc(%ebp)
     875:	ff 75 08             	pushl  0x8(%ebp)
     878:	e8 ce fc ff ff       	call   54b <gettoken>
     87d:	83 c4 10             	add    $0x10,%esp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     880:	83 ec 08             	sub    $0x8,%esp
     883:	ff 75 0c             	pushl  0xc(%ebp)
     886:	ff 75 08             	pushl  0x8(%ebp)
     889:	e8 ac ff ff ff       	call   83a <parsepipe>
     88e:	83 c4 10             	add    $0x10,%esp
     891:	83 ec 08             	sub    $0x8,%esp
     894:	50                   	push   %eax
     895:	ff 75 f4             	pushl  -0xc(%ebp)
     898:	e8 df fb ff ff       	call   47c <pipecmd>
     89d:	83 c4 10             	add    $0x10,%esp
     8a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     8a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8a6:	c9                   	leave  
     8a7:	c3                   	ret    

000008a8 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     8a8:	55                   	push   %ebp
     8a9:	89 e5                	mov    %esp,%ebp
     8ab:	83 ec 18             	sub    $0x18,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     8ae:	e9 b6 00 00 00       	jmp    969 <parseredirs+0xc1>
    tok = gettoken(ps, es, 0, 0);
     8b3:	6a 00                	push   $0x0
     8b5:	6a 00                	push   $0x0
     8b7:	ff 75 10             	pushl  0x10(%ebp)
     8ba:	ff 75 0c             	pushl  0xc(%ebp)
     8bd:	e8 89 fc ff ff       	call   54b <gettoken>
     8c2:	83 c4 10             	add    $0x10,%esp
     8c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     8c8:	8d 45 ec             	lea    -0x14(%ebp),%eax
     8cb:	50                   	push   %eax
     8cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
     8cf:	50                   	push   %eax
     8d0:	ff 75 10             	pushl  0x10(%ebp)
     8d3:	ff 75 0c             	pushl  0xc(%ebp)
     8d6:	e8 70 fc ff ff       	call   54b <gettoken>
     8db:	83 c4 10             	add    $0x10,%esp
     8de:	83 f8 61             	cmp    $0x61,%eax
     8e1:	74 10                	je     8f3 <parseredirs+0x4b>
      panic("missing file for redirection");
     8e3:	83 ec 0c             	sub    $0xc,%esp
     8e6:	68 37 14 00 00       	push   $0x1437
     8eb:	e8 aa fa ff ff       	call   39a <panic>
     8f0:	83 c4 10             	add    $0x10,%esp
    switch(tok){
     8f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8f6:	83 f8 3c             	cmp    $0x3c,%eax
     8f9:	74 0c                	je     907 <parseredirs+0x5f>
     8fb:	83 f8 3e             	cmp    $0x3e,%eax
     8fe:	74 26                	je     926 <parseredirs+0x7e>
     900:	83 f8 2b             	cmp    $0x2b,%eax
     903:	74 43                	je     948 <parseredirs+0xa0>
     905:	eb 62                	jmp    969 <parseredirs+0xc1>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     907:	8b 55 ec             	mov    -0x14(%ebp),%edx
     90a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     90d:	83 ec 0c             	sub    $0xc,%esp
     910:	6a 00                	push   $0x0
     912:	6a 00                	push   $0x0
     914:	52                   	push   %edx
     915:	50                   	push   %eax
     916:	ff 75 08             	pushl  0x8(%ebp)
     919:	e8 fb fa ff ff       	call   419 <redircmd>
     91e:	83 c4 20             	add    $0x20,%esp
     921:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     924:	eb 43                	jmp    969 <parseredirs+0xc1>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     926:	8b 55 ec             	mov    -0x14(%ebp),%edx
     929:	8b 45 f0             	mov    -0x10(%ebp),%eax
     92c:	83 ec 0c             	sub    $0xc,%esp
     92f:	6a 01                	push   $0x1
     931:	68 01 02 00 00       	push   $0x201
     936:	52                   	push   %edx
     937:	50                   	push   %eax
     938:	ff 75 08             	pushl  0x8(%ebp)
     93b:	e8 d9 fa ff ff       	call   419 <redircmd>
     940:	83 c4 20             	add    $0x20,%esp
     943:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     946:	eb 21                	jmp    969 <parseredirs+0xc1>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     948:	8b 55 ec             	mov    -0x14(%ebp),%edx
     94b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     94e:	83 ec 0c             	sub    $0xc,%esp
     951:	6a 01                	push   $0x1
     953:	68 01 02 00 00       	push   $0x201
     958:	52                   	push   %edx
     959:	50                   	push   %eax
     95a:	ff 75 08             	pushl  0x8(%ebp)
     95d:	e8 b7 fa ff ff       	call   419 <redircmd>
     962:	83 c4 20             	add    $0x20,%esp
     965:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     968:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     969:	83 ec 04             	sub    $0x4,%esp
     96c:	68 54 14 00 00       	push   $0x1454
     971:	ff 75 10             	pushl  0x10(%ebp)
     974:	ff 75 0c             	pushl  0xc(%ebp)
     977:	e8 10 fd ff ff       	call   68c <peek>
     97c:	83 c4 10             	add    $0x10,%esp
     97f:	85 c0                	test   %eax,%eax
     981:	0f 85 2c ff ff ff    	jne    8b3 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     987:	8b 45 08             	mov    0x8(%ebp),%eax
}
     98a:	c9                   	leave  
     98b:	c3                   	ret    

0000098c <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     98c:	55                   	push   %ebp
     98d:	89 e5                	mov    %esp,%ebp
     98f:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     992:	83 ec 04             	sub    $0x4,%esp
     995:	68 57 14 00 00       	push   $0x1457
     99a:	ff 75 0c             	pushl  0xc(%ebp)
     99d:	ff 75 08             	pushl  0x8(%ebp)
     9a0:	e8 e7 fc ff ff       	call   68c <peek>
     9a5:	83 c4 10             	add    $0x10,%esp
     9a8:	85 c0                	test   %eax,%eax
     9aa:	75 10                	jne    9bc <parseblock+0x30>
    panic("parseblock");
     9ac:	83 ec 0c             	sub    $0xc,%esp
     9af:	68 59 14 00 00       	push   $0x1459
     9b4:	e8 e1 f9 ff ff       	call   39a <panic>
     9b9:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     9bc:	6a 00                	push   $0x0
     9be:	6a 00                	push   $0x0
     9c0:	ff 75 0c             	pushl  0xc(%ebp)
     9c3:	ff 75 08             	pushl  0x8(%ebp)
     9c6:	e8 80 fb ff ff       	call   54b <gettoken>
     9cb:	83 c4 10             	add    $0x10,%esp
  cmd = parseline(ps, es);
     9ce:	83 ec 08             	sub    $0x8,%esp
     9d1:	ff 75 0c             	pushl  0xc(%ebp)
     9d4:	ff 75 08             	pushl  0x8(%ebp)
     9d7:	e8 b1 fd ff ff       	call   78d <parseline>
     9dc:	83 c4 10             	add    $0x10,%esp
     9df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     9e2:	83 ec 04             	sub    $0x4,%esp
     9e5:	68 64 14 00 00       	push   $0x1464
     9ea:	ff 75 0c             	pushl  0xc(%ebp)
     9ed:	ff 75 08             	pushl  0x8(%ebp)
     9f0:	e8 97 fc ff ff       	call   68c <peek>
     9f5:	83 c4 10             	add    $0x10,%esp
     9f8:	85 c0                	test   %eax,%eax
     9fa:	75 10                	jne    a0c <parseblock+0x80>
    panic("syntax - missing )");
     9fc:	83 ec 0c             	sub    $0xc,%esp
     9ff:	68 66 14 00 00       	push   $0x1466
     a04:	e8 91 f9 ff ff       	call   39a <panic>
     a09:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     a0c:	6a 00                	push   $0x0
     a0e:	6a 00                	push   $0x0
     a10:	ff 75 0c             	pushl  0xc(%ebp)
     a13:	ff 75 08             	pushl  0x8(%ebp)
     a16:	e8 30 fb ff ff       	call   54b <gettoken>
     a1b:	83 c4 10             	add    $0x10,%esp
  cmd = parseredirs(cmd, ps, es);
     a1e:	83 ec 04             	sub    $0x4,%esp
     a21:	ff 75 0c             	pushl  0xc(%ebp)
     a24:	ff 75 08             	pushl  0x8(%ebp)
     a27:	ff 75 f4             	pushl  -0xc(%ebp)
     a2a:	e8 79 fe ff ff       	call   8a8 <parseredirs>
     a2f:	83 c4 10             	add    $0x10,%esp
     a32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     a38:	c9                   	leave  
     a39:	c3                   	ret    

00000a3a <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     a3a:	55                   	push   %ebp
     a3b:	89 e5                	mov    %esp,%ebp
     a3d:	83 ec 28             	sub    $0x28,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     a40:	83 ec 04             	sub    $0x4,%esp
     a43:	68 57 14 00 00       	push   $0x1457
     a48:	ff 75 0c             	pushl  0xc(%ebp)
     a4b:	ff 75 08             	pushl  0x8(%ebp)
     a4e:	e8 39 fc ff ff       	call   68c <peek>
     a53:	83 c4 10             	add    $0x10,%esp
     a56:	85 c0                	test   %eax,%eax
     a58:	74 16                	je     a70 <parseexec+0x36>
    return parseblock(ps, es);
     a5a:	83 ec 08             	sub    $0x8,%esp
     a5d:	ff 75 0c             	pushl  0xc(%ebp)
     a60:	ff 75 08             	pushl  0x8(%ebp)
     a63:	e8 24 ff ff ff       	call   98c <parseblock>
     a68:	83 c4 10             	add    $0x10,%esp
     a6b:	e9 fa 00 00 00       	jmp    b6a <parseexec+0x130>

  ret = execcmd();
     a70:	e8 6e f9 ff ff       	call   3e3 <execcmd>
     a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a7b:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     a7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     a85:	83 ec 04             	sub    $0x4,%esp
     a88:	ff 75 0c             	pushl  0xc(%ebp)
     a8b:	ff 75 08             	pushl  0x8(%ebp)
     a8e:	ff 75 f0             	pushl  -0x10(%ebp)
     a91:	e8 12 fe ff ff       	call   8a8 <parseredirs>
     a96:	83 c4 10             	add    $0x10,%esp
     a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     a9c:	e9 86 00 00 00       	jmp    b27 <parseexec+0xed>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     aa1:	8d 45 e0             	lea    -0x20(%ebp),%eax
     aa4:	50                   	push   %eax
     aa5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     aa8:	50                   	push   %eax
     aa9:	ff 75 0c             	pushl  0xc(%ebp)
     aac:	ff 75 08             	pushl  0x8(%ebp)
     aaf:	e8 97 fa ff ff       	call   54b <gettoken>
     ab4:	83 c4 10             	add    $0x10,%esp
     ab7:	89 45 e8             	mov    %eax,-0x18(%ebp)
     aba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     abe:	0f 84 83 00 00 00    	je     b47 <parseexec+0x10d>
      break;
    if(tok != 'a')
     ac4:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     ac8:	74 10                	je     ada <parseexec+0xa0>
      panic("syntax");
     aca:	83 ec 0c             	sub    $0xc,%esp
     acd:	68 2a 14 00 00       	push   $0x142a
     ad2:	e8 c3 f8 ff ff       	call   39a <panic>
     ad7:	83 c4 10             	add    $0x10,%esp
    cmd->argv[argc] = q;
     ada:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     add:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ae0:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ae3:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     ae7:	8b 55 e0             	mov    -0x20(%ebp),%edx
     aea:	8b 45 ec             	mov    -0x14(%ebp),%eax
     aed:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     af0:	83 c1 08             	add    $0x8,%ecx
     af3:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     af7:	ff 45 f4             	incl   -0xc(%ebp)
    if(argc >= MAXARGS)
     afa:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     afe:	7e 10                	jle    b10 <parseexec+0xd6>
      panic("too many args");
     b00:	83 ec 0c             	sub    $0xc,%esp
     b03:	68 79 14 00 00       	push   $0x1479
     b08:	e8 8d f8 ff ff       	call   39a <panic>
     b0d:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
     b10:	83 ec 04             	sub    $0x4,%esp
     b13:	ff 75 0c             	pushl  0xc(%ebp)
     b16:	ff 75 08             	pushl  0x8(%ebp)
     b19:	ff 75 f0             	pushl  -0x10(%ebp)
     b1c:	e8 87 fd ff ff       	call   8a8 <parseredirs>
     b21:	83 c4 10             	add    $0x10,%esp
     b24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     b27:	83 ec 04             	sub    $0x4,%esp
     b2a:	68 87 14 00 00       	push   $0x1487
     b2f:	ff 75 0c             	pushl  0xc(%ebp)
     b32:	ff 75 08             	pushl  0x8(%ebp)
     b35:	e8 52 fb ff ff       	call   68c <peek>
     b3a:	83 c4 10             	add    $0x10,%esp
     b3d:	85 c0                	test   %eax,%eax
     b3f:	0f 84 5c ff ff ff    	je     aa1 <parseexec+0x67>
     b45:	eb 01                	jmp    b48 <parseexec+0x10e>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
     b47:	90                   	nop
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     b48:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b4e:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     b55:	00 
  cmd->eargv[argc] = 0;
     b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b5c:	83 c2 08             	add    $0x8,%edx
     b5f:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     b66:	00 
  return ret;
     b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     b6a:	c9                   	leave  
     b6b:	c3                   	ret    

00000b6c <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     b6c:	55                   	push   %ebp
     b6d:	89 e5                	mov    %esp,%ebp
     b6f:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     b72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     b76:	75 0a                	jne    b82 <nulterminate+0x16>
    return 0;
     b78:	b8 00 00 00 00       	mov    $0x0,%eax
     b7d:	e9 e3 00 00 00       	jmp    c65 <nulterminate+0xf9>
  
  switch(cmd->type){
     b82:	8b 45 08             	mov    0x8(%ebp),%eax
     b85:	8b 00                	mov    (%eax),%eax
     b87:	83 f8 05             	cmp    $0x5,%eax
     b8a:	0f 87 d2 00 00 00    	ja     c62 <nulterminate+0xf6>
     b90:	8b 04 85 8c 14 00 00 	mov    0x148c(,%eax,4),%eax
     b97:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     b99:	8b 45 08             	mov    0x8(%ebp),%eax
     b9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     b9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     ba6:	eb 13                	jmp    bbb <nulterminate+0x4f>
      *ecmd->eargv[i] = 0;
     ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bab:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bae:	83 c2 08             	add    $0x8,%edx
     bb1:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     bb5:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     bb8:	ff 45 f4             	incl   -0xc(%ebp)
     bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bc1:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     bc5:	85 c0                	test   %eax,%eax
     bc7:	75 df                	jne    ba8 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     bc9:	e9 94 00 00 00       	jmp    c62 <nulterminate+0xf6>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     bce:	8b 45 08             	mov    0x8(%ebp),%eax
     bd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bd7:	8b 40 04             	mov    0x4(%eax),%eax
     bda:	83 ec 0c             	sub    $0xc,%esp
     bdd:	50                   	push   %eax
     bde:	e8 89 ff ff ff       	call   b6c <nulterminate>
     be3:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     be6:	8b 45 ec             	mov    -0x14(%ebp),%eax
     be9:	8b 40 0c             	mov    0xc(%eax),%eax
     bec:	c6 00 00             	movb   $0x0,(%eax)
    break;
     bef:	eb 71                	jmp    c62 <nulterminate+0xf6>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     bf1:	8b 45 08             	mov    0x8(%ebp),%eax
     bf4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     bf7:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bfa:	8b 40 04             	mov    0x4(%eax),%eax
     bfd:	83 ec 0c             	sub    $0xc,%esp
     c00:	50                   	push   %eax
     c01:	e8 66 ff ff ff       	call   b6c <nulterminate>
     c06:	83 c4 10             	add    $0x10,%esp
    nulterminate(pcmd->right);
     c09:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c0c:	8b 40 08             	mov    0x8(%eax),%eax
     c0f:	83 ec 0c             	sub    $0xc,%esp
     c12:	50                   	push   %eax
     c13:	e8 54 ff ff ff       	call   b6c <nulterminate>
     c18:	83 c4 10             	add    $0x10,%esp
    break;
     c1b:	eb 45                	jmp    c62 <nulterminate+0xf6>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
     c1d:	8b 45 08             	mov    0x8(%ebp),%eax
     c20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     c23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c26:	8b 40 04             	mov    0x4(%eax),%eax
     c29:	83 ec 0c             	sub    $0xc,%esp
     c2c:	50                   	push   %eax
     c2d:	e8 3a ff ff ff       	call   b6c <nulterminate>
     c32:	83 c4 10             	add    $0x10,%esp
    nulterminate(lcmd->right);
     c35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c38:	8b 40 08             	mov    0x8(%eax),%eax
     c3b:	83 ec 0c             	sub    $0xc,%esp
     c3e:	50                   	push   %eax
     c3f:	e8 28 ff ff ff       	call   b6c <nulterminate>
     c44:	83 c4 10             	add    $0x10,%esp
    break;
     c47:	eb 19                	jmp    c62 <nulterminate+0xf6>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     c49:	8b 45 08             	mov    0x8(%ebp),%eax
     c4c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     c4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
     c52:	8b 40 04             	mov    0x4(%eax),%eax
     c55:	83 ec 0c             	sub    $0xc,%esp
     c58:	50                   	push   %eax
     c59:	e8 0e ff ff ff       	call   b6c <nulterminate>
     c5e:	83 c4 10             	add    $0x10,%esp
    break;
     c61:	90                   	nop
  }
  return cmd;
     c62:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c65:	c9                   	leave  
     c66:	c3                   	ret    
     c67:	90                   	nop

00000c68 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     c68:	55                   	push   %ebp
     c69:	89 e5                	mov    %esp,%ebp
     c6b:	57                   	push   %edi
     c6c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     c6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
     c70:	8b 55 10             	mov    0x10(%ebp),%edx
     c73:	8b 45 0c             	mov    0xc(%ebp),%eax
     c76:	89 cb                	mov    %ecx,%ebx
     c78:	89 df                	mov    %ebx,%edi
     c7a:	89 d1                	mov    %edx,%ecx
     c7c:	fc                   	cld    
     c7d:	f3 aa                	rep stos %al,%es:(%edi)
     c7f:	89 ca                	mov    %ecx,%edx
     c81:	89 fb                	mov    %edi,%ebx
     c83:	89 5d 08             	mov    %ebx,0x8(%ebp)
     c86:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     c89:	5b                   	pop    %ebx
     c8a:	5f                   	pop    %edi
     c8b:	c9                   	leave  
     c8c:	c3                   	ret    

00000c8d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     c8d:	55                   	push   %ebp
     c8e:	89 e5                	mov    %esp,%ebp
     c90:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     c93:	8b 45 08             	mov    0x8(%ebp),%eax
     c96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     c99:	90                   	nop
     c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
     c9d:	8a 10                	mov    (%eax),%dl
     c9f:	8b 45 08             	mov    0x8(%ebp),%eax
     ca2:	88 10                	mov    %dl,(%eax)
     ca4:	8b 45 08             	mov    0x8(%ebp),%eax
     ca7:	8a 00                	mov    (%eax),%al
     ca9:	84 c0                	test   %al,%al
     cab:	0f 95 c0             	setne  %al
     cae:	ff 45 08             	incl   0x8(%ebp)
     cb1:	ff 45 0c             	incl   0xc(%ebp)
     cb4:	84 c0                	test   %al,%al
     cb6:	75 e2                	jne    c9a <strcpy+0xd>
    ;
  return os;
     cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     cbb:	c9                   	leave  
     cbc:	c3                   	ret    

00000cbd <strcmp>:

int
strcmp(const char *p, const char *q)
{
     cbd:	55                   	push   %ebp
     cbe:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     cc0:	eb 06                	jmp    cc8 <strcmp+0xb>
    p++, q++;
     cc2:	ff 45 08             	incl   0x8(%ebp)
     cc5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     cc8:	8b 45 08             	mov    0x8(%ebp),%eax
     ccb:	8a 00                	mov    (%eax),%al
     ccd:	84 c0                	test   %al,%al
     ccf:	74 0e                	je     cdf <strcmp+0x22>
     cd1:	8b 45 08             	mov    0x8(%ebp),%eax
     cd4:	8a 10                	mov    (%eax),%dl
     cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
     cd9:	8a 00                	mov    (%eax),%al
     cdb:	38 c2                	cmp    %al,%dl
     cdd:	74 e3                	je     cc2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     cdf:	8b 45 08             	mov    0x8(%ebp),%eax
     ce2:	8a 00                	mov    (%eax),%al
     ce4:	0f b6 d0             	movzbl %al,%edx
     ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
     cea:	8a 00                	mov    (%eax),%al
     cec:	0f b6 c0             	movzbl %al,%eax
     cef:	89 d1                	mov    %edx,%ecx
     cf1:	29 c1                	sub    %eax,%ecx
     cf3:	89 c8                	mov    %ecx,%eax
}
     cf5:	c9                   	leave  
     cf6:	c3                   	ret    

00000cf7 <strlen>:

uint
strlen(char *s)
{
     cf7:	55                   	push   %ebp
     cf8:	89 e5                	mov    %esp,%ebp
     cfa:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     cfd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     d04:	eb 03                	jmp    d09 <strlen+0x12>
     d06:	ff 45 fc             	incl   -0x4(%ebp)
     d09:	8b 45 fc             	mov    -0x4(%ebp),%eax
     d0c:	03 45 08             	add    0x8(%ebp),%eax
     d0f:	8a 00                	mov    (%eax),%al
     d11:	84 c0                	test   %al,%al
     d13:	75 f1                	jne    d06 <strlen+0xf>
    ;
  return n;
     d15:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d18:	c9                   	leave  
     d19:	c3                   	ret    

00000d1a <memset>:

void*
memset(void *dst, int c, uint n)
{
     d1a:	55                   	push   %ebp
     d1b:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
     d1d:	8b 45 10             	mov    0x10(%ebp),%eax
     d20:	50                   	push   %eax
     d21:	ff 75 0c             	pushl  0xc(%ebp)
     d24:	ff 75 08             	pushl  0x8(%ebp)
     d27:	e8 3c ff ff ff       	call   c68 <stosb>
     d2c:	83 c4 0c             	add    $0xc,%esp
  return dst;
     d2f:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d32:	c9                   	leave  
     d33:	c3                   	ret    

00000d34 <strchr>:

char*
strchr(const char *s, char c)
{
     d34:	55                   	push   %ebp
     d35:	89 e5                	mov    %esp,%ebp
     d37:	83 ec 04             	sub    $0x4,%esp
     d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
     d3d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     d40:	eb 12                	jmp    d54 <strchr+0x20>
    if(*s == c)
     d42:	8b 45 08             	mov    0x8(%ebp),%eax
     d45:	8a 00                	mov    (%eax),%al
     d47:	3a 45 fc             	cmp    -0x4(%ebp),%al
     d4a:	75 05                	jne    d51 <strchr+0x1d>
      return (char*)s;
     d4c:	8b 45 08             	mov    0x8(%ebp),%eax
     d4f:	eb 11                	jmp    d62 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     d51:	ff 45 08             	incl   0x8(%ebp)
     d54:	8b 45 08             	mov    0x8(%ebp),%eax
     d57:	8a 00                	mov    (%eax),%al
     d59:	84 c0                	test   %al,%al
     d5b:	75 e5                	jne    d42 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
     d62:	c9                   	leave  
     d63:	c3                   	ret    

00000d64 <gets>:

char*
gets(char *buf, int max)
{
     d64:	55                   	push   %ebp
     d65:	89 e5                	mov    %esp,%ebp
     d67:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     d71:	eb 38                	jmp    dab <gets+0x47>
    cc = read(0, &c, 1);
     d73:	83 ec 04             	sub    $0x4,%esp
     d76:	6a 01                	push   $0x1
     d78:	8d 45 ef             	lea    -0x11(%ebp),%eax
     d7b:	50                   	push   %eax
     d7c:	6a 00                	push   $0x0
     d7e:	e8 31 01 00 00       	call   eb4 <read>
     d83:	83 c4 10             	add    $0x10,%esp
     d86:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     d89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d8d:	7e 27                	jle    db6 <gets+0x52>
      break;
    buf[i++] = c;
     d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d92:	03 45 08             	add    0x8(%ebp),%eax
     d95:	8a 55 ef             	mov    -0x11(%ebp),%dl
     d98:	88 10                	mov    %dl,(%eax)
     d9a:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
     d9d:	8a 45 ef             	mov    -0x11(%ebp),%al
     da0:	3c 0a                	cmp    $0xa,%al
     da2:	74 13                	je     db7 <gets+0x53>
     da4:	8a 45 ef             	mov    -0x11(%ebp),%al
     da7:	3c 0d                	cmp    $0xd,%al
     da9:	74 0c                	je     db7 <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dae:	40                   	inc    %eax
     daf:	3b 45 0c             	cmp    0xc(%ebp),%eax
     db2:	7c bf                	jl     d73 <gets+0xf>
     db4:	eb 01                	jmp    db7 <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     db6:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dba:	03 45 08             	add    0x8(%ebp),%eax
     dbd:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     dc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
     dc3:	c9                   	leave  
     dc4:	c3                   	ret    

00000dc5 <stat>:

int
stat(char *n, struct stat *st)
{
     dc5:	55                   	push   %ebp
     dc6:	89 e5                	mov    %esp,%ebp
     dc8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     dcb:	83 ec 08             	sub    $0x8,%esp
     dce:	6a 00                	push   $0x0
     dd0:	ff 75 08             	pushl  0x8(%ebp)
     dd3:	e8 04 01 00 00       	call   edc <open>
     dd8:	83 c4 10             	add    $0x10,%esp
     ddb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     dde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     de2:	79 07                	jns    deb <stat+0x26>
    return -1;
     de4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     de9:	eb 25                	jmp    e10 <stat+0x4b>
  r = fstat(fd, st);
     deb:	83 ec 08             	sub    $0x8,%esp
     dee:	ff 75 0c             	pushl  0xc(%ebp)
     df1:	ff 75 f4             	pushl  -0xc(%ebp)
     df4:	e8 fb 00 00 00       	call   ef4 <fstat>
     df9:	83 c4 10             	add    $0x10,%esp
     dfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     dff:	83 ec 0c             	sub    $0xc,%esp
     e02:	ff 75 f4             	pushl  -0xc(%ebp)
     e05:	e8 ba 00 00 00       	call   ec4 <close>
     e0a:	83 c4 10             	add    $0x10,%esp
  return r;
     e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     e10:	c9                   	leave  
     e11:	c3                   	ret    

00000e12 <atoi>:

int
atoi(const char *s)
{
     e12:	55                   	push   %ebp
     e13:	89 e5                	mov    %esp,%ebp
     e15:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     e18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     e1f:	eb 22                	jmp    e43 <atoi+0x31>
    n = n*10 + *s++ - '0';
     e21:	8b 55 fc             	mov    -0x4(%ebp),%edx
     e24:	89 d0                	mov    %edx,%eax
     e26:	c1 e0 02             	shl    $0x2,%eax
     e29:	01 d0                	add    %edx,%eax
     e2b:	d1 e0                	shl    %eax
     e2d:	89 c2                	mov    %eax,%edx
     e2f:	8b 45 08             	mov    0x8(%ebp),%eax
     e32:	8a 00                	mov    (%eax),%al
     e34:	0f be c0             	movsbl %al,%eax
     e37:	8d 04 02             	lea    (%edx,%eax,1),%eax
     e3a:	83 e8 30             	sub    $0x30,%eax
     e3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
     e40:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     e43:	8b 45 08             	mov    0x8(%ebp),%eax
     e46:	8a 00                	mov    (%eax),%al
     e48:	3c 2f                	cmp    $0x2f,%al
     e4a:	7e 09                	jle    e55 <atoi+0x43>
     e4c:	8b 45 08             	mov    0x8(%ebp),%eax
     e4f:	8a 00                	mov    (%eax),%al
     e51:	3c 39                	cmp    $0x39,%al
     e53:	7e cc                	jle    e21 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     e58:	c9                   	leave  
     e59:	c3                   	ret    

00000e5a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     e5a:	55                   	push   %ebp
     e5b:	89 e5                	mov    %esp,%ebp
     e5d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     e60:	8b 45 08             	mov    0x8(%ebp),%eax
     e63:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     e66:	8b 45 0c             	mov    0xc(%ebp),%eax
     e69:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     e6c:	eb 10                	jmp    e7e <memmove+0x24>
    *dst++ = *src++;
     e6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e71:	8a 10                	mov    (%eax),%dl
     e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e76:	88 10                	mov    %dl,(%eax)
     e78:	ff 45 fc             	incl   -0x4(%ebp)
     e7b:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     e7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     e82:	0f 9f c0             	setg   %al
     e85:	ff 4d 10             	decl   0x10(%ebp)
     e88:	84 c0                	test   %al,%al
     e8a:	75 e2                	jne    e6e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     e8c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e8f:	c9                   	leave  
     e90:	c3                   	ret    
     e91:	90                   	nop
     e92:	90                   	nop
     e93:	90                   	nop

00000e94 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     e94:	b8 01 00 00 00       	mov    $0x1,%eax
     e99:	cd 40                	int    $0x40
     e9b:	c3                   	ret    

00000e9c <exit>:
SYSCALL(exit)
     e9c:	b8 02 00 00 00       	mov    $0x2,%eax
     ea1:	cd 40                	int    $0x40
     ea3:	c3                   	ret    

00000ea4 <wait>:
SYSCALL(wait)
     ea4:	b8 03 00 00 00       	mov    $0x3,%eax
     ea9:	cd 40                	int    $0x40
     eab:	c3                   	ret    

00000eac <pipe>:
SYSCALL(pipe)
     eac:	b8 04 00 00 00       	mov    $0x4,%eax
     eb1:	cd 40                	int    $0x40
     eb3:	c3                   	ret    

00000eb4 <read>:
SYSCALL(read)
     eb4:	b8 05 00 00 00       	mov    $0x5,%eax
     eb9:	cd 40                	int    $0x40
     ebb:	c3                   	ret    

00000ebc <write>:
SYSCALL(write)
     ebc:	b8 10 00 00 00       	mov    $0x10,%eax
     ec1:	cd 40                	int    $0x40
     ec3:	c3                   	ret    

00000ec4 <close>:
SYSCALL(close)
     ec4:	b8 15 00 00 00       	mov    $0x15,%eax
     ec9:	cd 40                	int    $0x40
     ecb:	c3                   	ret    

00000ecc <kill>:
SYSCALL(kill)
     ecc:	b8 06 00 00 00       	mov    $0x6,%eax
     ed1:	cd 40                	int    $0x40
     ed3:	c3                   	ret    

00000ed4 <exec>:
SYSCALL(exec)
     ed4:	b8 07 00 00 00       	mov    $0x7,%eax
     ed9:	cd 40                	int    $0x40
     edb:	c3                   	ret    

00000edc <open>:
SYSCALL(open)
     edc:	b8 0f 00 00 00       	mov    $0xf,%eax
     ee1:	cd 40                	int    $0x40
     ee3:	c3                   	ret    

00000ee4 <mknod>:
SYSCALL(mknod)
     ee4:	b8 11 00 00 00       	mov    $0x11,%eax
     ee9:	cd 40                	int    $0x40
     eeb:	c3                   	ret    

00000eec <unlink>:
SYSCALL(unlink)
     eec:	b8 12 00 00 00       	mov    $0x12,%eax
     ef1:	cd 40                	int    $0x40
     ef3:	c3                   	ret    

00000ef4 <fstat>:
SYSCALL(fstat)
     ef4:	b8 08 00 00 00       	mov    $0x8,%eax
     ef9:	cd 40                	int    $0x40
     efb:	c3                   	ret    

00000efc <link>:
SYSCALL(link)
     efc:	b8 13 00 00 00       	mov    $0x13,%eax
     f01:	cd 40                	int    $0x40
     f03:	c3                   	ret    

00000f04 <mkdir>:
SYSCALL(mkdir)
     f04:	b8 14 00 00 00       	mov    $0x14,%eax
     f09:	cd 40                	int    $0x40
     f0b:	c3                   	ret    

00000f0c <chdir>:
SYSCALL(chdir)
     f0c:	b8 09 00 00 00       	mov    $0x9,%eax
     f11:	cd 40                	int    $0x40
     f13:	c3                   	ret    

00000f14 <dup>:
SYSCALL(dup)
     f14:	b8 0a 00 00 00       	mov    $0xa,%eax
     f19:	cd 40                	int    $0x40
     f1b:	c3                   	ret    

00000f1c <getpid>:
SYSCALL(getpid)
     f1c:	b8 0b 00 00 00       	mov    $0xb,%eax
     f21:	cd 40                	int    $0x40
     f23:	c3                   	ret    

00000f24 <sbrk>:
SYSCALL(sbrk)
     f24:	b8 0c 00 00 00       	mov    $0xc,%eax
     f29:	cd 40                	int    $0x40
     f2b:	c3                   	ret    

00000f2c <sleep>:
SYSCALL(sleep)
     f2c:	b8 0d 00 00 00       	mov    $0xd,%eax
     f31:	cd 40                	int    $0x40
     f33:	c3                   	ret    

00000f34 <uptime>:
SYSCALL(uptime)
     f34:	b8 0e 00 00 00       	mov    $0xe,%eax
     f39:	cd 40                	int    $0x40
     f3b:	c3                   	ret    

00000f3c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     f3c:	55                   	push   %ebp
     f3d:	89 e5                	mov    %esp,%ebp
     f3f:	83 ec 18             	sub    $0x18,%esp
     f42:	8b 45 0c             	mov    0xc(%ebp),%eax
     f45:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     f48:	83 ec 04             	sub    $0x4,%esp
     f4b:	6a 01                	push   $0x1
     f4d:	8d 45 f4             	lea    -0xc(%ebp),%eax
     f50:	50                   	push   %eax
     f51:	ff 75 08             	pushl  0x8(%ebp)
     f54:	e8 63 ff ff ff       	call   ebc <write>
     f59:	83 c4 10             	add    $0x10,%esp
}
     f5c:	c9                   	leave  
     f5d:	c3                   	ret    

00000f5e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f5e:	55                   	push   %ebp
     f5f:	89 e5                	mov    %esp,%ebp
     f61:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     f64:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     f6b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     f6f:	74 17                	je     f88 <printint+0x2a>
     f71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     f75:	79 11                	jns    f88 <printint+0x2a>
    neg = 1;
     f77:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
     f81:	f7 d8                	neg    %eax
     f83:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f86:	eb 06                	jmp    f8e <printint+0x30>
  } else {
    x = xx;
     f88:	8b 45 0c             	mov    0xc(%ebp),%eax
     f8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     f8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     f95:	8b 4d 10             	mov    0x10(%ebp),%ecx
     f98:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f9b:	ba 00 00 00 00       	mov    $0x0,%edx
     fa0:	f7 f1                	div    %ecx
     fa2:	89 d0                	mov    %edx,%eax
     fa4:	8a 90 bc 14 00 00    	mov    0x14bc(%eax),%dl
     faa:	8d 45 dc             	lea    -0x24(%ebp),%eax
     fad:	03 45 f4             	add    -0xc(%ebp),%eax
     fb0:	88 10                	mov    %dl,(%eax)
     fb2:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
     fb5:	8b 45 10             	mov    0x10(%ebp),%eax
     fb8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     fbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
     fbe:	ba 00 00 00 00       	mov    $0x0,%edx
     fc3:	f7 75 d4             	divl   -0x2c(%ebp)
     fc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fc9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fcd:	75 c6                	jne    f95 <printint+0x37>
  if(neg)
     fcf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     fd3:	74 2a                	je     fff <printint+0xa1>
    buf[i++] = '-';
     fd5:	8d 45 dc             	lea    -0x24(%ebp),%eax
     fd8:	03 45 f4             	add    -0xc(%ebp),%eax
     fdb:	c6 00 2d             	movb   $0x2d,(%eax)
     fde:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
     fe1:	eb 1d                	jmp    1000 <printint+0xa2>
    putc(fd, buf[i]);
     fe3:	8d 45 dc             	lea    -0x24(%ebp),%eax
     fe6:	03 45 f4             	add    -0xc(%ebp),%eax
     fe9:	8a 00                	mov    (%eax),%al
     feb:	0f be c0             	movsbl %al,%eax
     fee:	83 ec 08             	sub    $0x8,%esp
     ff1:	50                   	push   %eax
     ff2:	ff 75 08             	pushl  0x8(%ebp)
     ff5:	e8 42 ff ff ff       	call   f3c <putc>
     ffa:	83 c4 10             	add    $0x10,%esp
     ffd:	eb 01                	jmp    1000 <printint+0xa2>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     fff:	90                   	nop
    1000:	ff 4d f4             	decl   -0xc(%ebp)
    1003:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1007:	79 da                	jns    fe3 <printint+0x85>
    putc(fd, buf[i]);
}
    1009:	c9                   	leave  
    100a:	c3                   	ret    

0000100b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    100b:	55                   	push   %ebp
    100c:	89 e5                	mov    %esp,%ebp
    100e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1011:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1018:	8d 45 0c             	lea    0xc(%ebp),%eax
    101b:	83 c0 04             	add    $0x4,%eax
    101e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1021:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1028:	e9 58 01 00 00       	jmp    1185 <printf+0x17a>
    c = fmt[i] & 0xff;
    102d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1030:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1033:	8d 04 02             	lea    (%edx,%eax,1),%eax
    1036:	8a 00                	mov    (%eax),%al
    1038:	0f be c0             	movsbl %al,%eax
    103b:	25 ff 00 00 00       	and    $0xff,%eax
    1040:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1043:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1047:	75 2c                	jne    1075 <printf+0x6a>
      if(c == '%'){
    1049:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    104d:	75 0c                	jne    105b <printf+0x50>
        state = '%';
    104f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1056:	e9 27 01 00 00       	jmp    1182 <printf+0x177>
      } else {
        putc(fd, c);
    105b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    105e:	0f be c0             	movsbl %al,%eax
    1061:	83 ec 08             	sub    $0x8,%esp
    1064:	50                   	push   %eax
    1065:	ff 75 08             	pushl  0x8(%ebp)
    1068:	e8 cf fe ff ff       	call   f3c <putc>
    106d:	83 c4 10             	add    $0x10,%esp
    1070:	e9 0d 01 00 00       	jmp    1182 <printf+0x177>
      }
    } else if(state == '%'){
    1075:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1079:	0f 85 03 01 00 00    	jne    1182 <printf+0x177>
      if(c == 'd'){
    107f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1083:	75 1e                	jne    10a3 <printf+0x98>
        printint(fd, *ap, 10, 1);
    1085:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1088:	8b 00                	mov    (%eax),%eax
    108a:	6a 01                	push   $0x1
    108c:	6a 0a                	push   $0xa
    108e:	50                   	push   %eax
    108f:	ff 75 08             	pushl  0x8(%ebp)
    1092:	e8 c7 fe ff ff       	call   f5e <printint>
    1097:	83 c4 10             	add    $0x10,%esp
        ap++;
    109a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    109e:	e9 d8 00 00 00       	jmp    117b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    10a3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    10a7:	74 06                	je     10af <printf+0xa4>
    10a9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    10ad:	75 1e                	jne    10cd <printf+0xc2>
        printint(fd, *ap, 16, 0);
    10af:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10b2:	8b 00                	mov    (%eax),%eax
    10b4:	6a 00                	push   $0x0
    10b6:	6a 10                	push   $0x10
    10b8:	50                   	push   %eax
    10b9:	ff 75 08             	pushl  0x8(%ebp)
    10bc:	e8 9d fe ff ff       	call   f5e <printint>
    10c1:	83 c4 10             	add    $0x10,%esp
        ap++;
    10c4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    10c8:	e9 ae 00 00 00       	jmp    117b <printf+0x170>
      } else if(c == 's'){
    10cd:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    10d1:	75 43                	jne    1116 <printf+0x10b>
        s = (char*)*ap;
    10d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10d6:	8b 00                	mov    (%eax),%eax
    10d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    10db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    10df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10e3:	75 25                	jne    110a <printf+0xff>
          s = "(null)";
    10e5:	c7 45 f4 a4 14 00 00 	movl   $0x14a4,-0xc(%ebp)
        while(*s != 0){
    10ec:	eb 1d                	jmp    110b <printf+0x100>
          putc(fd, *s);
    10ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10f1:	8a 00                	mov    (%eax),%al
    10f3:	0f be c0             	movsbl %al,%eax
    10f6:	83 ec 08             	sub    $0x8,%esp
    10f9:	50                   	push   %eax
    10fa:	ff 75 08             	pushl  0x8(%ebp)
    10fd:	e8 3a fe ff ff       	call   f3c <putc>
    1102:	83 c4 10             	add    $0x10,%esp
          s++;
    1105:	ff 45 f4             	incl   -0xc(%ebp)
    1108:	eb 01                	jmp    110b <printf+0x100>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    110a:	90                   	nop
    110b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    110e:	8a 00                	mov    (%eax),%al
    1110:	84 c0                	test   %al,%al
    1112:	75 da                	jne    10ee <printf+0xe3>
    1114:	eb 65                	jmp    117b <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1116:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    111a:	75 1d                	jne    1139 <printf+0x12e>
        putc(fd, *ap);
    111c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    111f:	8b 00                	mov    (%eax),%eax
    1121:	0f be c0             	movsbl %al,%eax
    1124:	83 ec 08             	sub    $0x8,%esp
    1127:	50                   	push   %eax
    1128:	ff 75 08             	pushl  0x8(%ebp)
    112b:	e8 0c fe ff ff       	call   f3c <putc>
    1130:	83 c4 10             	add    $0x10,%esp
        ap++;
    1133:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1137:	eb 42                	jmp    117b <printf+0x170>
      } else if(c == '%'){
    1139:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    113d:	75 17                	jne    1156 <printf+0x14b>
        putc(fd, c);
    113f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1142:	0f be c0             	movsbl %al,%eax
    1145:	83 ec 08             	sub    $0x8,%esp
    1148:	50                   	push   %eax
    1149:	ff 75 08             	pushl  0x8(%ebp)
    114c:	e8 eb fd ff ff       	call   f3c <putc>
    1151:	83 c4 10             	add    $0x10,%esp
    1154:	eb 25                	jmp    117b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1156:	83 ec 08             	sub    $0x8,%esp
    1159:	6a 25                	push   $0x25
    115b:	ff 75 08             	pushl  0x8(%ebp)
    115e:	e8 d9 fd ff ff       	call   f3c <putc>
    1163:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    1166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1169:	0f be c0             	movsbl %al,%eax
    116c:	83 ec 08             	sub    $0x8,%esp
    116f:	50                   	push   %eax
    1170:	ff 75 08             	pushl  0x8(%ebp)
    1173:	e8 c4 fd ff ff       	call   f3c <putc>
    1178:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    117b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1182:	ff 45 f0             	incl   -0x10(%ebp)
    1185:	8b 55 0c             	mov    0xc(%ebp),%edx
    1188:	8b 45 f0             	mov    -0x10(%ebp),%eax
    118b:	8d 04 02             	lea    (%edx,%eax,1),%eax
    118e:	8a 00                	mov    (%eax),%al
    1190:	84 c0                	test   %al,%al
    1192:	0f 85 95 fe ff ff    	jne    102d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1198:	c9                   	leave  
    1199:	c3                   	ret    
    119a:	90                   	nop
    119b:	90                   	nop

0000119c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    119c:	55                   	push   %ebp
    119d:	89 e5                	mov    %esp,%ebp
    119f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11a2:	8b 45 08             	mov    0x8(%ebp),%eax
    11a5:	83 e8 08             	sub    $0x8,%eax
    11a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11ab:	a1 4c 15 00 00       	mov    0x154c,%eax
    11b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    11b3:	eb 24                	jmp    11d9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11b8:	8b 00                	mov    (%eax),%eax
    11ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    11bd:	77 12                	ja     11d1 <free+0x35>
    11bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11c2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    11c5:	77 24                	ja     11eb <free+0x4f>
    11c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11ca:	8b 00                	mov    (%eax),%eax
    11cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    11cf:	77 1a                	ja     11eb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11d4:	8b 00                	mov    (%eax),%eax
    11d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    11d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    11df:	76 d4                	jbe    11b5 <free+0x19>
    11e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11e4:	8b 00                	mov    (%eax),%eax
    11e6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    11e9:	76 ca                	jbe    11b5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    11eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11ee:	8b 40 04             	mov    0x4(%eax),%eax
    11f1:	c1 e0 03             	shl    $0x3,%eax
    11f4:	89 c2                	mov    %eax,%edx
    11f6:	03 55 f8             	add    -0x8(%ebp),%edx
    11f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11fc:	8b 00                	mov    (%eax),%eax
    11fe:	39 c2                	cmp    %eax,%edx
    1200:	75 24                	jne    1226 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    1202:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1205:	8b 50 04             	mov    0x4(%eax),%edx
    1208:	8b 45 fc             	mov    -0x4(%ebp),%eax
    120b:	8b 00                	mov    (%eax),%eax
    120d:	8b 40 04             	mov    0x4(%eax),%eax
    1210:	01 c2                	add    %eax,%edx
    1212:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1215:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1218:	8b 45 fc             	mov    -0x4(%ebp),%eax
    121b:	8b 00                	mov    (%eax),%eax
    121d:	8b 10                	mov    (%eax),%edx
    121f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1222:	89 10                	mov    %edx,(%eax)
    1224:	eb 0a                	jmp    1230 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    1226:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1229:	8b 10                	mov    (%eax),%edx
    122b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    122e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1230:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1233:	8b 40 04             	mov    0x4(%eax),%eax
    1236:	c1 e0 03             	shl    $0x3,%eax
    1239:	03 45 fc             	add    -0x4(%ebp),%eax
    123c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    123f:	75 20                	jne    1261 <free+0xc5>
    p->s.size += bp->s.size;
    1241:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1244:	8b 50 04             	mov    0x4(%eax),%edx
    1247:	8b 45 f8             	mov    -0x8(%ebp),%eax
    124a:	8b 40 04             	mov    0x4(%eax),%eax
    124d:	01 c2                	add    %eax,%edx
    124f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1252:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1255:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1258:	8b 10                	mov    (%eax),%edx
    125a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    125d:	89 10                	mov    %edx,(%eax)
    125f:	eb 08                	jmp    1269 <free+0xcd>
  } else
    p->s.ptr = bp;
    1261:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1264:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1267:	89 10                	mov    %edx,(%eax)
  freep = p;
    1269:	8b 45 fc             	mov    -0x4(%ebp),%eax
    126c:	a3 4c 15 00 00       	mov    %eax,0x154c
}
    1271:	c9                   	leave  
    1272:	c3                   	ret    

00001273 <morecore>:

static Header*
morecore(uint nu)
{
    1273:	55                   	push   %ebp
    1274:	89 e5                	mov    %esp,%ebp
    1276:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1279:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1280:	77 07                	ja     1289 <morecore+0x16>
    nu = 4096;
    1282:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1289:	8b 45 08             	mov    0x8(%ebp),%eax
    128c:	c1 e0 03             	shl    $0x3,%eax
    128f:	83 ec 0c             	sub    $0xc,%esp
    1292:	50                   	push   %eax
    1293:	e8 8c fc ff ff       	call   f24 <sbrk>
    1298:	83 c4 10             	add    $0x10,%esp
    129b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    129e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    12a2:	75 07                	jne    12ab <morecore+0x38>
    return 0;
    12a4:	b8 00 00 00 00       	mov    $0x0,%eax
    12a9:	eb 26                	jmp    12d1 <morecore+0x5e>
  hp = (Header*)p;
    12ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    12b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12b4:	8b 55 08             	mov    0x8(%ebp),%edx
    12b7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    12ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12bd:	83 c0 08             	add    $0x8,%eax
    12c0:	83 ec 0c             	sub    $0xc,%esp
    12c3:	50                   	push   %eax
    12c4:	e8 d3 fe ff ff       	call   119c <free>
    12c9:	83 c4 10             	add    $0x10,%esp
  return freep;
    12cc:	a1 4c 15 00 00       	mov    0x154c,%eax
}
    12d1:	c9                   	leave  
    12d2:	c3                   	ret    

000012d3 <malloc>:

void*
malloc(uint nbytes)
{
    12d3:	55                   	push   %ebp
    12d4:	89 e5                	mov    %esp,%ebp
    12d6:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12d9:	8b 45 08             	mov    0x8(%ebp),%eax
    12dc:	83 c0 07             	add    $0x7,%eax
    12df:	c1 e8 03             	shr    $0x3,%eax
    12e2:	40                   	inc    %eax
    12e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    12e6:	a1 4c 15 00 00       	mov    0x154c,%eax
    12eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    12ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    12f2:	75 23                	jne    1317 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    12f4:	c7 45 f0 44 15 00 00 	movl   $0x1544,-0x10(%ebp)
    12fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12fe:	a3 4c 15 00 00       	mov    %eax,0x154c
    1303:	a1 4c 15 00 00       	mov    0x154c,%eax
    1308:	a3 44 15 00 00       	mov    %eax,0x1544
    base.s.size = 0;
    130d:	c7 05 48 15 00 00 00 	movl   $0x0,0x1548
    1314:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1317:	8b 45 f0             	mov    -0x10(%ebp),%eax
    131a:	8b 00                	mov    (%eax),%eax
    131c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    131f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1322:	8b 40 04             	mov    0x4(%eax),%eax
    1325:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1328:	72 4d                	jb     1377 <malloc+0xa4>
      if(p->s.size == nunits)
    132a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    132d:	8b 40 04             	mov    0x4(%eax),%eax
    1330:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1333:	75 0c                	jne    1341 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    1335:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1338:	8b 10                	mov    (%eax),%edx
    133a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    133d:	89 10                	mov    %edx,(%eax)
    133f:	eb 26                	jmp    1367 <malloc+0x94>
      else {
        p->s.size -= nunits;
    1341:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1344:	8b 40 04             	mov    0x4(%eax),%eax
    1347:	89 c2                	mov    %eax,%edx
    1349:	2b 55 ec             	sub    -0x14(%ebp),%edx
    134c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    134f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1352:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1355:	8b 40 04             	mov    0x4(%eax),%eax
    1358:	c1 e0 03             	shl    $0x3,%eax
    135b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    135e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1361:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1364:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1367:	8b 45 f0             	mov    -0x10(%ebp),%eax
    136a:	a3 4c 15 00 00       	mov    %eax,0x154c
      return (void*)(p + 1);
    136f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1372:	83 c0 08             	add    $0x8,%eax
    1375:	eb 3b                	jmp    13b2 <malloc+0xdf>
    }
    if(p == freep)
    1377:	a1 4c 15 00 00       	mov    0x154c,%eax
    137c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    137f:	75 1e                	jne    139f <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
    1381:	83 ec 0c             	sub    $0xc,%esp
    1384:	ff 75 ec             	pushl  -0x14(%ebp)
    1387:	e8 e7 fe ff ff       	call   1273 <morecore>
    138c:	83 c4 10             	add    $0x10,%esp
    138f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1392:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1396:	75 07                	jne    139f <malloc+0xcc>
        return 0;
    1398:	b8 00 00 00 00       	mov    $0x0,%eax
    139d:	eb 13                	jmp    13b2 <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    139f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    13a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13a8:	8b 00                	mov    (%eax),%eax
    13aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    13ad:	e9 6d ff ff ff       	jmp    131f <malloc+0x4c>
}
    13b2:	c9                   	leave  
    13b3:	c3                   	ret    
