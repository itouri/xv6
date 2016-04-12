
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "iput test\n");
       6:	a1 ac 5b 00 00       	mov    0x5bac,%eax
       b:	83 ec 08             	sub    $0x8,%esp
       e:	68 ca 43 00 00       	push   $0x43ca
      13:	50                   	push   %eax
      14:	e8 f2 3f 00 00       	call   400b <printf>
      19:	83 c4 10             	add    $0x10,%esp

  if(mkdir("iputdir") < 0){
      1c:	83 ec 0c             	sub    $0xc,%esp
      1f:	68 d5 43 00 00       	push   $0x43d5
      24:	e8 db 3e 00 00       	call   3f04 <mkdir>
      29:	83 c4 10             	add    $0x10,%esp
      2c:	85 c0                	test   %eax,%eax
      2e:	79 1b                	jns    4b <iputtest+0x4b>
    printf(stdout, "mkdir failed\n");
      30:	a1 ac 5b 00 00       	mov    0x5bac,%eax
      35:	83 ec 08             	sub    $0x8,%esp
      38:	68 dd 43 00 00       	push   $0x43dd
      3d:	50                   	push   %eax
      3e:	e8 c8 3f 00 00       	call   400b <printf>
      43:	83 c4 10             	add    $0x10,%esp
    exit();
      46:	e8 51 3e 00 00       	call   3e9c <exit>
  }
  if(chdir("iputdir") < 0){
      4b:	83 ec 0c             	sub    $0xc,%esp
      4e:	68 d5 43 00 00       	push   $0x43d5
      53:	e8 b4 3e 00 00       	call   3f0c <chdir>
      58:	83 c4 10             	add    $0x10,%esp
      5b:	85 c0                	test   %eax,%eax
      5d:	79 1b                	jns    7a <iputtest+0x7a>
    printf(stdout, "chdir iputdir failed\n");
      5f:	a1 ac 5b 00 00       	mov    0x5bac,%eax
      64:	83 ec 08             	sub    $0x8,%esp
      67:	68 eb 43 00 00       	push   $0x43eb
      6c:	50                   	push   %eax
      6d:	e8 99 3f 00 00       	call   400b <printf>
      72:	83 c4 10             	add    $0x10,%esp
    exit();
      75:	e8 22 3e 00 00       	call   3e9c <exit>
  }
  if(unlink("../iputdir") < 0){
      7a:	83 ec 0c             	sub    $0xc,%esp
      7d:	68 01 44 00 00       	push   $0x4401
      82:	e8 65 3e 00 00       	call   3eec <unlink>
      87:	83 c4 10             	add    $0x10,%esp
      8a:	85 c0                	test   %eax,%eax
      8c:	79 1b                	jns    a9 <iputtest+0xa9>
    printf(stdout, "unlink ../iputdir failed\n");
      8e:	a1 ac 5b 00 00       	mov    0x5bac,%eax
      93:	83 ec 08             	sub    $0x8,%esp
      96:	68 0c 44 00 00       	push   $0x440c
      9b:	50                   	push   %eax
      9c:	e8 6a 3f 00 00       	call   400b <printf>
      a1:	83 c4 10             	add    $0x10,%esp
    exit();
      a4:	e8 f3 3d 00 00       	call   3e9c <exit>
  }
  if(chdir("/") < 0){
      a9:	83 ec 0c             	sub    $0xc,%esp
      ac:	68 26 44 00 00       	push   $0x4426
      b1:	e8 56 3e 00 00       	call   3f0c <chdir>
      b6:	83 c4 10             	add    $0x10,%esp
      b9:	85 c0                	test   %eax,%eax
      bb:	79 1b                	jns    d8 <iputtest+0xd8>
    printf(stdout, "chdir / failed\n");
      bd:	a1 ac 5b 00 00       	mov    0x5bac,%eax
      c2:	83 ec 08             	sub    $0x8,%esp
      c5:	68 28 44 00 00       	push   $0x4428
      ca:	50                   	push   %eax
      cb:	e8 3b 3f 00 00       	call   400b <printf>
      d0:	83 c4 10             	add    $0x10,%esp
    exit();
      d3:	e8 c4 3d 00 00       	call   3e9c <exit>
  }
  printf(stdout, "iput test ok\n");
      d8:	a1 ac 5b 00 00       	mov    0x5bac,%eax
      dd:	83 ec 08             	sub    $0x8,%esp
      e0:	68 38 44 00 00       	push   $0x4438
      e5:	50                   	push   %eax
      e6:	e8 20 3f 00 00       	call   400b <printf>
      eb:	83 c4 10             	add    $0x10,%esp
}
      ee:	c9                   	leave  
      ef:	c3                   	ret    

000000f0 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      f0:	55                   	push   %ebp
      f1:	89 e5                	mov    %esp,%ebp
      f3:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      f6:	a1 ac 5b 00 00       	mov    0x5bac,%eax
      fb:	83 ec 08             	sub    $0x8,%esp
      fe:	68 46 44 00 00       	push   $0x4446
     103:	50                   	push   %eax
     104:	e8 02 3f 00 00       	call   400b <printf>
     109:	83 c4 10             	add    $0x10,%esp

  pid = fork();
     10c:	e8 83 3d 00 00       	call   3e94 <fork>
     111:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     114:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     118:	79 1b                	jns    135 <exitiputtest+0x45>
    printf(stdout, "fork failed\n");
     11a:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     11f:	83 ec 08             	sub    $0x8,%esp
     122:	68 55 44 00 00       	push   $0x4455
     127:	50                   	push   %eax
     128:	e8 de 3e 00 00       	call   400b <printf>
     12d:	83 c4 10             	add    $0x10,%esp
    exit();
     130:	e8 67 3d 00 00       	call   3e9c <exit>
  }
  if(pid == 0){
     135:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     139:	0f 85 92 00 00 00    	jne    1d1 <exitiputtest+0xe1>
    if(mkdir("iputdir") < 0){
     13f:	83 ec 0c             	sub    $0xc,%esp
     142:	68 d5 43 00 00       	push   $0x43d5
     147:	e8 b8 3d 00 00       	call   3f04 <mkdir>
     14c:	83 c4 10             	add    $0x10,%esp
     14f:	85 c0                	test   %eax,%eax
     151:	79 1b                	jns    16e <exitiputtest+0x7e>
      printf(stdout, "mkdir failed\n");
     153:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     158:	83 ec 08             	sub    $0x8,%esp
     15b:	68 dd 43 00 00       	push   $0x43dd
     160:	50                   	push   %eax
     161:	e8 a5 3e 00 00       	call   400b <printf>
     166:	83 c4 10             	add    $0x10,%esp
      exit();
     169:	e8 2e 3d 00 00       	call   3e9c <exit>
    }
    if(chdir("iputdir") < 0){
     16e:	83 ec 0c             	sub    $0xc,%esp
     171:	68 d5 43 00 00       	push   $0x43d5
     176:	e8 91 3d 00 00       	call   3f0c <chdir>
     17b:	83 c4 10             	add    $0x10,%esp
     17e:	85 c0                	test   %eax,%eax
     180:	79 1b                	jns    19d <exitiputtest+0xad>
      printf(stdout, "child chdir failed\n");
     182:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     187:	83 ec 08             	sub    $0x8,%esp
     18a:	68 62 44 00 00       	push   $0x4462
     18f:	50                   	push   %eax
     190:	e8 76 3e 00 00       	call   400b <printf>
     195:	83 c4 10             	add    $0x10,%esp
      exit();
     198:	e8 ff 3c 00 00       	call   3e9c <exit>
    }
    if(unlink("../iputdir") < 0){
     19d:	83 ec 0c             	sub    $0xc,%esp
     1a0:	68 01 44 00 00       	push   $0x4401
     1a5:	e8 42 3d 00 00       	call   3eec <unlink>
     1aa:	83 c4 10             	add    $0x10,%esp
     1ad:	85 c0                	test   %eax,%eax
     1af:	79 1b                	jns    1cc <exitiputtest+0xdc>
      printf(stdout, "unlink ../iputdir failed\n");
     1b1:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     1b6:	83 ec 08             	sub    $0x8,%esp
     1b9:	68 0c 44 00 00       	push   $0x440c
     1be:	50                   	push   %eax
     1bf:	e8 47 3e 00 00       	call   400b <printf>
     1c4:	83 c4 10             	add    $0x10,%esp
      exit();
     1c7:	e8 d0 3c 00 00       	call   3e9c <exit>
    }
    exit();
     1cc:	e8 cb 3c 00 00       	call   3e9c <exit>
  }
  wait();
     1d1:	e8 ce 3c 00 00       	call   3ea4 <wait>
  printf(stdout, "exitiput test ok\n");
     1d6:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     1db:	83 ec 08             	sub    $0x8,%esp
     1de:	68 76 44 00 00       	push   $0x4476
     1e3:	50                   	push   %eax
     1e4:	e8 22 3e 00 00       	call   400b <printf>
     1e9:	83 c4 10             	add    $0x10,%esp
}
     1ec:	c9                   	leave  
     1ed:	c3                   	ret    

000001ee <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1ee:	55                   	push   %ebp
     1ef:	89 e5                	mov    %esp,%ebp
     1f1:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1f4:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     1f9:	83 ec 08             	sub    $0x8,%esp
     1fc:	68 88 44 00 00       	push   $0x4488
     201:	50                   	push   %eax
     202:	e8 04 3e 00 00       	call   400b <printf>
     207:	83 c4 10             	add    $0x10,%esp
  if(mkdir("oidir") < 0){
     20a:	83 ec 0c             	sub    $0xc,%esp
     20d:	68 97 44 00 00       	push   $0x4497
     212:	e8 ed 3c 00 00       	call   3f04 <mkdir>
     217:	83 c4 10             	add    $0x10,%esp
     21a:	85 c0                	test   %eax,%eax
     21c:	79 1b                	jns    239 <openiputtest+0x4b>
    printf(stdout, "mkdir oidir failed\n");
     21e:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     223:	83 ec 08             	sub    $0x8,%esp
     226:	68 9d 44 00 00       	push   $0x449d
     22b:	50                   	push   %eax
     22c:	e8 da 3d 00 00       	call   400b <printf>
     231:	83 c4 10             	add    $0x10,%esp
    exit();
     234:	e8 63 3c 00 00       	call   3e9c <exit>
  }
  pid = fork();
     239:	e8 56 3c 00 00       	call   3e94 <fork>
     23e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     241:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     245:	79 1b                	jns    262 <openiputtest+0x74>
    printf(stdout, "fork failed\n");
     247:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     24c:	83 ec 08             	sub    $0x8,%esp
     24f:	68 55 44 00 00       	push   $0x4455
     254:	50                   	push   %eax
     255:	e8 b1 3d 00 00       	call   400b <printf>
     25a:	83 c4 10             	add    $0x10,%esp
    exit();
     25d:	e8 3a 3c 00 00       	call   3e9c <exit>
  }
  if(pid == 0){
     262:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     266:	75 3b                	jne    2a3 <openiputtest+0xb5>
    int fd = open("oidir", O_RDWR);
     268:	83 ec 08             	sub    $0x8,%esp
     26b:	6a 02                	push   $0x2
     26d:	68 97 44 00 00       	push   $0x4497
     272:	e8 65 3c 00 00       	call   3edc <open>
     277:	83 c4 10             	add    $0x10,%esp
     27a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0){
     27d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     281:	78 1b                	js     29e <openiputtest+0xb0>
      printf(stdout, "open directory for write succeeded\n");
     283:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     288:	83 ec 08             	sub    $0x8,%esp
     28b:	68 b4 44 00 00       	push   $0x44b4
     290:	50                   	push   %eax
     291:	e8 75 3d 00 00       	call   400b <printf>
     296:	83 c4 10             	add    $0x10,%esp
      exit();
     299:	e8 fe 3b 00 00       	call   3e9c <exit>
    }
    exit();
     29e:	e8 f9 3b 00 00       	call   3e9c <exit>
  }
  sleep(1);
     2a3:	83 ec 0c             	sub    $0xc,%esp
     2a6:	6a 01                	push   $0x1
     2a8:	e8 7f 3c 00 00       	call   3f2c <sleep>
     2ad:	83 c4 10             	add    $0x10,%esp
  if(unlink("oidir") != 0){
     2b0:	83 ec 0c             	sub    $0xc,%esp
     2b3:	68 97 44 00 00       	push   $0x4497
     2b8:	e8 2f 3c 00 00       	call   3eec <unlink>
     2bd:	83 c4 10             	add    $0x10,%esp
     2c0:	85 c0                	test   %eax,%eax
     2c2:	74 1b                	je     2df <openiputtest+0xf1>
    printf(stdout, "unlink failed\n");
     2c4:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     2c9:	83 ec 08             	sub    $0x8,%esp
     2cc:	68 d8 44 00 00       	push   $0x44d8
     2d1:	50                   	push   %eax
     2d2:	e8 34 3d 00 00       	call   400b <printf>
     2d7:	83 c4 10             	add    $0x10,%esp
    exit();
     2da:	e8 bd 3b 00 00       	call   3e9c <exit>
  }
  wait();
     2df:	e8 c0 3b 00 00       	call   3ea4 <wait>
  printf(stdout, "openiput test ok\n");
     2e4:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     2e9:	83 ec 08             	sub    $0x8,%esp
     2ec:	68 e7 44 00 00       	push   $0x44e7
     2f1:	50                   	push   %eax
     2f2:	e8 14 3d 00 00       	call   400b <printf>
     2f7:	83 c4 10             	add    $0x10,%esp
}
     2fa:	c9                   	leave  
     2fb:	c3                   	ret    

000002fc <opentest>:

// simple file system tests

void
opentest(void)
{
     2fc:	55                   	push   %ebp
     2fd:	89 e5                	mov    %esp,%ebp
     2ff:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(stdout, "open test\n");
     302:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     307:	83 ec 08             	sub    $0x8,%esp
     30a:	68 f9 44 00 00       	push   $0x44f9
     30f:	50                   	push   %eax
     310:	e8 f6 3c 00 00       	call   400b <printf>
     315:	83 c4 10             	add    $0x10,%esp
  fd = open("echo", 0);
     318:	83 ec 08             	sub    $0x8,%esp
     31b:	6a 00                	push   $0x0
     31d:	68 b4 43 00 00       	push   $0x43b4
     322:	e8 b5 3b 00 00       	call   3edc <open>
     327:	83 c4 10             	add    $0x10,%esp
     32a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
     32d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     331:	79 1b                	jns    34e <opentest+0x52>
    printf(stdout, "open echo failed!\n");
     333:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     338:	83 ec 08             	sub    $0x8,%esp
     33b:	68 04 45 00 00       	push   $0x4504
     340:	50                   	push   %eax
     341:	e8 c5 3c 00 00       	call   400b <printf>
     346:	83 c4 10             	add    $0x10,%esp
    exit();
     349:	e8 4e 3b 00 00       	call   3e9c <exit>
  }
  close(fd);
     34e:	83 ec 0c             	sub    $0xc,%esp
     351:	ff 75 f4             	pushl  -0xc(%ebp)
     354:	e8 6b 3b 00 00       	call   3ec4 <close>
     359:	83 c4 10             	add    $0x10,%esp
  fd = open("doesnotexist", 0);
     35c:	83 ec 08             	sub    $0x8,%esp
     35f:	6a 00                	push   $0x0
     361:	68 17 45 00 00       	push   $0x4517
     366:	e8 71 3b 00 00       	call   3edc <open>
     36b:	83 c4 10             	add    $0x10,%esp
     36e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
     371:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     375:	78 1b                	js     392 <opentest+0x96>
    printf(stdout, "open doesnotexist succeeded!\n");
     377:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     37c:	83 ec 08             	sub    $0x8,%esp
     37f:	68 24 45 00 00       	push   $0x4524
     384:	50                   	push   %eax
     385:	e8 81 3c 00 00       	call   400b <printf>
     38a:	83 c4 10             	add    $0x10,%esp
    exit();
     38d:	e8 0a 3b 00 00       	call   3e9c <exit>
  }
  printf(stdout, "open test ok\n");
     392:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     397:	83 ec 08             	sub    $0x8,%esp
     39a:	68 42 45 00 00       	push   $0x4542
     39f:	50                   	push   %eax
     3a0:	e8 66 3c 00 00       	call   400b <printf>
     3a5:	83 c4 10             	add    $0x10,%esp
}
     3a8:	c9                   	leave  
     3a9:	c3                   	ret    

000003aa <writetest>:

void
writetest(void)
{
     3aa:	55                   	push   %ebp
     3ab:	89 e5                	mov    %esp,%ebp
     3ad:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
     3b0:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     3b5:	83 ec 08             	sub    $0x8,%esp
     3b8:	68 50 45 00 00       	push   $0x4550
     3bd:	50                   	push   %eax
     3be:	e8 48 3c 00 00       	call   400b <printf>
     3c3:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_CREATE|O_RDWR);
     3c6:	83 ec 08             	sub    $0x8,%esp
     3c9:	68 02 02 00 00       	push   $0x202
     3ce:	68 61 45 00 00       	push   $0x4561
     3d3:	e8 04 3b 00 00       	call   3edc <open>
     3d8:	83 c4 10             	add    $0x10,%esp
     3db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     3de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3e2:	78 22                	js     406 <writetest+0x5c>
    printf(stdout, "creat small succeeded; ok\n");
     3e4:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     3e9:	83 ec 08             	sub    $0x8,%esp
     3ec:	68 67 45 00 00       	push   $0x4567
     3f1:	50                   	push   %eax
     3f2:	e8 14 3c 00 00       	call   400b <printf>
     3f7:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     3fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     401:	e9 8e 00 00 00       	jmp    494 <writetest+0xea>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
     406:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     40b:	83 ec 08             	sub    $0x8,%esp
     40e:	68 82 45 00 00       	push   $0x4582
     413:	50                   	push   %eax
     414:	e8 f2 3b 00 00       	call   400b <printf>
     419:	83 c4 10             	add    $0x10,%esp
    exit();
     41c:	e8 7b 3a 00 00       	call   3e9c <exit>
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     421:	83 ec 04             	sub    $0x4,%esp
     424:	6a 0a                	push   $0xa
     426:	68 9e 45 00 00       	push   $0x459e
     42b:	ff 75 f0             	pushl  -0x10(%ebp)
     42e:	e8 89 3a 00 00       	call   3ebc <write>
     433:	83 c4 10             	add    $0x10,%esp
     436:	83 f8 0a             	cmp    $0xa,%eax
     439:	74 1e                	je     459 <writetest+0xaf>
      printf(stdout, "error: write aa %d new file failed\n", i);
     43b:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     440:	83 ec 04             	sub    $0x4,%esp
     443:	ff 75 f4             	pushl  -0xc(%ebp)
     446:	68 ac 45 00 00       	push   $0x45ac
     44b:	50                   	push   %eax
     44c:	e8 ba 3b 00 00       	call   400b <printf>
     451:	83 c4 10             	add    $0x10,%esp
      exit();
     454:	e8 43 3a 00 00       	call   3e9c <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     459:	83 ec 04             	sub    $0x4,%esp
     45c:	6a 0a                	push   $0xa
     45e:	68 d0 45 00 00       	push   $0x45d0
     463:	ff 75 f0             	pushl  -0x10(%ebp)
     466:	e8 51 3a 00 00       	call   3ebc <write>
     46b:	83 c4 10             	add    $0x10,%esp
     46e:	83 f8 0a             	cmp    $0xa,%eax
     471:	74 1e                	je     491 <writetest+0xe7>
      printf(stdout, "error: write bb %d new file failed\n", i);
     473:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     478:	83 ec 04             	sub    $0x4,%esp
     47b:	ff 75 f4             	pushl  -0xc(%ebp)
     47e:	68 dc 45 00 00       	push   $0x45dc
     483:	50                   	push   %eax
     484:	e8 82 3b 00 00       	call   400b <printf>
     489:	83 c4 10             	add    $0x10,%esp
      exit();
     48c:	e8 0b 3a 00 00       	call   3e9c <exit>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     491:	ff 45 f4             	incl   -0xc(%ebp)
     494:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     498:	7e 87                	jle    421 <writetest+0x77>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     49a:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     49f:	83 ec 08             	sub    $0x8,%esp
     4a2:	68 00 46 00 00       	push   $0x4600
     4a7:	50                   	push   %eax
     4a8:	e8 5e 3b 00 00       	call   400b <printf>
     4ad:	83 c4 10             	add    $0x10,%esp
  close(fd);
     4b0:	83 ec 0c             	sub    $0xc,%esp
     4b3:	ff 75 f0             	pushl  -0x10(%ebp)
     4b6:	e8 09 3a 00 00       	call   3ec4 <close>
     4bb:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_RDONLY);
     4be:	83 ec 08             	sub    $0x8,%esp
     4c1:	6a 00                	push   $0x0
     4c3:	68 61 45 00 00       	push   $0x4561
     4c8:	e8 0f 3a 00 00       	call   3edc <open>
     4cd:	83 c4 10             	add    $0x10,%esp
     4d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     4d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4d7:	78 3c                	js     515 <writetest+0x16b>
    printf(stdout, "open small succeeded ok\n");
     4d9:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     4de:	83 ec 08             	sub    $0x8,%esp
     4e1:	68 0b 46 00 00       	push   $0x460b
     4e6:	50                   	push   %eax
     4e7:	e8 1f 3b 00 00       	call   400b <printf>
     4ec:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     4ef:	83 ec 04             	sub    $0x4,%esp
     4f2:	68 d0 07 00 00       	push   $0x7d0
     4f7:	68 a0 83 00 00       	push   $0x83a0
     4fc:	ff 75 f0             	pushl  -0x10(%ebp)
     4ff:	e8 b0 39 00 00       	call   3eb4 <read>
     504:	83 c4 10             	add    $0x10,%esp
     507:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     50a:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     511:	74 1d                	je     530 <writetest+0x186>
     513:	eb 55                	jmp    56a <writetest+0x1c0>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
     515:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     51a:	83 ec 08             	sub    $0x8,%esp
     51d:	68 24 46 00 00       	push   $0x4624
     522:	50                   	push   %eax
     523:	e8 e3 3a 00 00       	call   400b <printf>
     528:	83 c4 10             	add    $0x10,%esp
    exit();
     52b:	e8 6c 39 00 00       	call   3e9c <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
     530:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     535:	83 ec 08             	sub    $0x8,%esp
     538:	68 3f 46 00 00       	push   $0x463f
     53d:	50                   	push   %eax
     53e:	e8 c8 3a 00 00       	call   400b <printf>
     543:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     546:	83 ec 0c             	sub    $0xc,%esp
     549:	ff 75 f0             	pushl  -0x10(%ebp)
     54c:	e8 73 39 00 00       	call   3ec4 <close>
     551:	83 c4 10             	add    $0x10,%esp

  if(unlink("small") < 0){
     554:	83 ec 0c             	sub    $0xc,%esp
     557:	68 61 45 00 00       	push   $0x4561
     55c:	e8 8b 39 00 00       	call   3eec <unlink>
     561:	83 c4 10             	add    $0x10,%esp
     564:	85 c0                	test   %eax,%eax
     566:	78 1d                	js     585 <writetest+0x1db>
     568:	eb 36                	jmp    5a0 <writetest+0x1f6>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
     56a:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     56f:	83 ec 08             	sub    $0x8,%esp
     572:	68 52 46 00 00       	push   $0x4652
     577:	50                   	push   %eax
     578:	e8 8e 3a 00 00       	call   400b <printf>
     57d:	83 c4 10             	add    $0x10,%esp
    exit();
     580:	e8 17 39 00 00       	call   3e9c <exit>
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
     585:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     58a:	83 ec 08             	sub    $0x8,%esp
     58d:	68 5f 46 00 00       	push   $0x465f
     592:	50                   	push   %eax
     593:	e8 73 3a 00 00       	call   400b <printf>
     598:	83 c4 10             	add    $0x10,%esp
    exit();
     59b:	e8 fc 38 00 00       	call   3e9c <exit>
  }
  printf(stdout, "small file test ok\n");
     5a0:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     5a5:	83 ec 08             	sub    $0x8,%esp
     5a8:	68 74 46 00 00       	push   $0x4674
     5ad:	50                   	push   %eax
     5ae:	e8 58 3a 00 00       	call   400b <printf>
     5b3:	83 c4 10             	add    $0x10,%esp
}
     5b6:	c9                   	leave  
     5b7:	c3                   	ret    

000005b8 <writetest1>:

void
writetest1(void)
{
     5b8:	55                   	push   %ebp
     5b9:	89 e5                	mov    %esp,%ebp
     5bb:	83 ec 18             	sub    $0x18,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     5be:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     5c3:	83 ec 08             	sub    $0x8,%esp
     5c6:	68 88 46 00 00       	push   $0x4688
     5cb:	50                   	push   %eax
     5cc:	e8 3a 3a 00 00       	call   400b <printf>
     5d1:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_CREATE|O_RDWR);
     5d4:	83 ec 08             	sub    $0x8,%esp
     5d7:	68 02 02 00 00       	push   $0x202
     5dc:	68 98 46 00 00       	push   $0x4698
     5e1:	e8 f6 38 00 00       	call   3edc <open>
     5e6:	83 c4 10             	add    $0x10,%esp
     5e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     5ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     5f0:	79 1b                	jns    60d <writetest1+0x55>
    printf(stdout, "error: creat big failed!\n");
     5f2:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     5f7:	83 ec 08             	sub    $0x8,%esp
     5fa:	68 9c 46 00 00       	push   $0x469c
     5ff:	50                   	push   %eax
     600:	e8 06 3a 00 00       	call   400b <printf>
     605:	83 c4 10             	add    $0x10,%esp
    exit();
     608:	e8 8f 38 00 00       	call   3e9c <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     60d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     614:	eb 4a                	jmp    660 <writetest1+0xa8>
    ((int*)buf)[0] = i;
     616:	b8 a0 83 00 00       	mov    $0x83a0,%eax
     61b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     61e:	89 10                	mov    %edx,(%eax)
    if(write(fd, buf, 512) != 512){
     620:	83 ec 04             	sub    $0x4,%esp
     623:	68 00 02 00 00       	push   $0x200
     628:	68 a0 83 00 00       	push   $0x83a0
     62d:	ff 75 ec             	pushl  -0x14(%ebp)
     630:	e8 87 38 00 00       	call   3ebc <write>
     635:	83 c4 10             	add    $0x10,%esp
     638:	3d 00 02 00 00       	cmp    $0x200,%eax
     63d:	74 1e                	je     65d <writetest1+0xa5>
      printf(stdout, "error: write big file failed\n", i);
     63f:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     644:	83 ec 04             	sub    $0x4,%esp
     647:	ff 75 f4             	pushl  -0xc(%ebp)
     64a:	68 b6 46 00 00       	push   $0x46b6
     64f:	50                   	push   %eax
     650:	e8 b6 39 00 00       	call   400b <printf>
     655:	83 c4 10             	add    $0x10,%esp
      exit();
     658:	e8 3f 38 00 00       	call   3e9c <exit>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     65d:	ff 45 f4             	incl   -0xc(%ebp)
     660:	8b 45 f4             	mov    -0xc(%ebp),%eax
     663:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     668:	76 ac                	jbe    616 <writetest1+0x5e>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     66a:	83 ec 0c             	sub    $0xc,%esp
     66d:	ff 75 ec             	pushl  -0x14(%ebp)
     670:	e8 4f 38 00 00       	call   3ec4 <close>
     675:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_RDONLY);
     678:	83 ec 08             	sub    $0x8,%esp
     67b:	6a 00                	push   $0x0
     67d:	68 98 46 00 00       	push   $0x4698
     682:	e8 55 38 00 00       	call   3edc <open>
     687:	83 c4 10             	add    $0x10,%esp
     68a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     68d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     691:	79 1b                	jns    6ae <writetest1+0xf6>
    printf(stdout, "error: open big failed!\n");
     693:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     698:	83 ec 08             	sub    $0x8,%esp
     69b:	68 d4 46 00 00       	push   $0x46d4
     6a0:	50                   	push   %eax
     6a1:	e8 65 39 00 00       	call   400b <printf>
     6a6:	83 c4 10             	add    $0x10,%esp
    exit();
     6a9:	e8 ee 37 00 00       	call   3e9c <exit>
  }

  n = 0;
     6ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     6b5:	83 ec 04             	sub    $0x4,%esp
     6b8:	68 00 02 00 00       	push   $0x200
     6bd:	68 a0 83 00 00       	push   $0x83a0
     6c2:	ff 75 ec             	pushl  -0x14(%ebp)
     6c5:	e8 ea 37 00 00       	call   3eb4 <read>
     6ca:	83 c4 10             	add    $0x10,%esp
     6cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     6d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6d4:	75 4b                	jne    721 <writetest1+0x169>
      if(n == MAXFILE - 1){
     6d6:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     6dd:	75 1e                	jne    6fd <writetest1+0x145>
        printf(stdout, "read only %d blocks from big", n);
     6df:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     6e4:	83 ec 04             	sub    $0x4,%esp
     6e7:	ff 75 f0             	pushl  -0x10(%ebp)
     6ea:	68 ed 46 00 00       	push   $0x46ed
     6ef:	50                   	push   %eax
     6f0:	e8 16 39 00 00       	call   400b <printf>
     6f5:	83 c4 10             	add    $0x10,%esp
        exit();
     6f8:	e8 9f 37 00 00       	call   3e9c <exit>
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
     6fd:	83 ec 0c             	sub    $0xc,%esp
     700:	ff 75 ec             	pushl  -0x14(%ebp)
     703:	e8 bc 37 00 00       	call   3ec4 <close>
     708:	83 c4 10             	add    $0x10,%esp
  if(unlink("big") < 0){
     70b:	83 ec 0c             	sub    $0xc,%esp
     70e:	68 98 46 00 00       	push   $0x4698
     713:	e8 d4 37 00 00       	call   3eec <unlink>
     718:	83 c4 10             	add    $0x10,%esp
     71b:	85 c0                	test   %eax,%eax
     71d:	78 60                	js     77f <writetest1+0x1c7>
     71f:	eb 79                	jmp    79a <writetest1+0x1e2>
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
     721:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     728:	74 1e                	je     748 <writetest1+0x190>
      printf(stdout, "read failed %d\n", i);
     72a:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     72f:	83 ec 04             	sub    $0x4,%esp
     732:	ff 75 f4             	pushl  -0xc(%ebp)
     735:	68 0a 47 00 00       	push   $0x470a
     73a:	50                   	push   %eax
     73b:	e8 cb 38 00 00       	call   400b <printf>
     740:	83 c4 10             	add    $0x10,%esp
      exit();
     743:	e8 54 37 00 00       	call   3e9c <exit>
    }
    if(((int*)buf)[0] != n){
     748:	b8 a0 83 00 00       	mov    $0x83a0,%eax
     74d:	8b 00                	mov    (%eax),%eax
     74f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     752:	74 23                	je     777 <writetest1+0x1bf>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     754:	b8 a0 83 00 00       	mov    $0x83a0,%eax
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
      printf(stdout, "read content of block %d is %d\n",
     759:	8b 10                	mov    (%eax),%edx
     75b:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     760:	52                   	push   %edx
     761:	ff 75 f0             	pushl  -0x10(%ebp)
     764:	68 1c 47 00 00       	push   $0x471c
     769:	50                   	push   %eax
     76a:	e8 9c 38 00 00       	call   400b <printf>
     76f:	83 c4 10             	add    $0x10,%esp
             n, ((int*)buf)[0]);
      exit();
     772:	e8 25 37 00 00       	call   3e9c <exit>
    }
    n++;
     777:	ff 45 f0             	incl   -0x10(%ebp)
  }
     77a:	e9 36 ff ff ff       	jmp    6b5 <writetest1+0xfd>
  close(fd);
  if(unlink("big") < 0){
    printf(stdout, "unlink big failed\n");
     77f:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     784:	83 ec 08             	sub    $0x8,%esp
     787:	68 3c 47 00 00       	push   $0x473c
     78c:	50                   	push   %eax
     78d:	e8 79 38 00 00       	call   400b <printf>
     792:	83 c4 10             	add    $0x10,%esp
    exit();
     795:	e8 02 37 00 00       	call   3e9c <exit>
  }
  printf(stdout, "big files ok\n");
     79a:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     79f:	83 ec 08             	sub    $0x8,%esp
     7a2:	68 4f 47 00 00       	push   $0x474f
     7a7:	50                   	push   %eax
     7a8:	e8 5e 38 00 00       	call   400b <printf>
     7ad:	83 c4 10             	add    $0x10,%esp
}
     7b0:	c9                   	leave  
     7b1:	c3                   	ret    

000007b2 <createtest>:

void
createtest(void)
{
     7b2:	55                   	push   %ebp
     7b3:	89 e5                	mov    %esp,%ebp
     7b5:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     7b8:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     7bd:	83 ec 08             	sub    $0x8,%esp
     7c0:	68 60 47 00 00       	push   $0x4760
     7c5:	50                   	push   %eax
     7c6:	e8 40 38 00 00       	call   400b <printf>
     7cb:	83 c4 10             	add    $0x10,%esp

  name[0] = 'a';
     7ce:	c6 05 a0 a3 00 00 61 	movb   $0x61,0xa3a0
  name[2] = '\0';
     7d5:	c6 05 a2 a3 00 00 00 	movb   $0x0,0xa3a2
  for(i = 0; i < 52; i++){
     7dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7e3:	eb 34                	jmp    819 <createtest+0x67>
    name[1] = '0' + i;
     7e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7e8:	83 c0 30             	add    $0x30,%eax
     7eb:	a2 a1 a3 00 00       	mov    %al,0xa3a1
    fd = open(name, O_CREATE|O_RDWR);
     7f0:	83 ec 08             	sub    $0x8,%esp
     7f3:	68 02 02 00 00       	push   $0x202
     7f8:	68 a0 a3 00 00       	push   $0xa3a0
     7fd:	e8 da 36 00 00       	call   3edc <open>
     802:	83 c4 10             	add    $0x10,%esp
     805:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     808:	83 ec 0c             	sub    $0xc,%esp
     80b:	ff 75 f0             	pushl  -0x10(%ebp)
     80e:	e8 b1 36 00 00       	call   3ec4 <close>
     813:	83 c4 10             	add    $0x10,%esp

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     816:	ff 45 f4             	incl   -0xc(%ebp)
     819:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     81d:	7e c6                	jle    7e5 <createtest+0x33>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     81f:	c6 05 a0 a3 00 00 61 	movb   $0x61,0xa3a0
  name[2] = '\0';
     826:	c6 05 a2 a3 00 00 00 	movb   $0x0,0xa3a2
  for(i = 0; i < 52; i++){
     82d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     834:	eb 1e                	jmp    854 <createtest+0xa2>
    name[1] = '0' + i;
     836:	8b 45 f4             	mov    -0xc(%ebp),%eax
     839:	83 c0 30             	add    $0x30,%eax
     83c:	a2 a1 a3 00 00       	mov    %al,0xa3a1
    unlink(name);
     841:	83 ec 0c             	sub    $0xc,%esp
     844:	68 a0 a3 00 00       	push   $0xa3a0
     849:	e8 9e 36 00 00       	call   3eec <unlink>
     84e:	83 c4 10             	add    $0x10,%esp
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     851:	ff 45 f4             	incl   -0xc(%ebp)
     854:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     858:	7e dc                	jle    836 <createtest+0x84>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     85a:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     85f:	83 ec 08             	sub    $0x8,%esp
     862:	68 88 47 00 00       	push   $0x4788
     867:	50                   	push   %eax
     868:	e8 9e 37 00 00       	call   400b <printf>
     86d:	83 c4 10             	add    $0x10,%esp
}
     870:	c9                   	leave  
     871:	c3                   	ret    

00000872 <dirtest>:

void dirtest(void)
{
     872:	55                   	push   %ebp
     873:	89 e5                	mov    %esp,%ebp
     875:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "mkdir test\n");
     878:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     87d:	83 ec 08             	sub    $0x8,%esp
     880:	68 ae 47 00 00       	push   $0x47ae
     885:	50                   	push   %eax
     886:	e8 80 37 00 00       	call   400b <printf>
     88b:	83 c4 10             	add    $0x10,%esp

  if(mkdir("dir0") < 0){
     88e:	83 ec 0c             	sub    $0xc,%esp
     891:	68 ba 47 00 00       	push   $0x47ba
     896:	e8 69 36 00 00       	call   3f04 <mkdir>
     89b:	83 c4 10             	add    $0x10,%esp
     89e:	85 c0                	test   %eax,%eax
     8a0:	79 1b                	jns    8bd <dirtest+0x4b>
    printf(stdout, "mkdir failed\n");
     8a2:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     8a7:	83 ec 08             	sub    $0x8,%esp
     8aa:	68 dd 43 00 00       	push   $0x43dd
     8af:	50                   	push   %eax
     8b0:	e8 56 37 00 00       	call   400b <printf>
     8b5:	83 c4 10             	add    $0x10,%esp
    exit();
     8b8:	e8 df 35 00 00       	call   3e9c <exit>
  }

  if(chdir("dir0") < 0){
     8bd:	83 ec 0c             	sub    $0xc,%esp
     8c0:	68 ba 47 00 00       	push   $0x47ba
     8c5:	e8 42 36 00 00       	call   3f0c <chdir>
     8ca:	83 c4 10             	add    $0x10,%esp
     8cd:	85 c0                	test   %eax,%eax
     8cf:	79 1b                	jns    8ec <dirtest+0x7a>
    printf(stdout, "chdir dir0 failed\n");
     8d1:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     8d6:	83 ec 08             	sub    $0x8,%esp
     8d9:	68 bf 47 00 00       	push   $0x47bf
     8de:	50                   	push   %eax
     8df:	e8 27 37 00 00       	call   400b <printf>
     8e4:	83 c4 10             	add    $0x10,%esp
    exit();
     8e7:	e8 b0 35 00 00       	call   3e9c <exit>
  }

  if(chdir("..") < 0){
     8ec:	83 ec 0c             	sub    $0xc,%esp
     8ef:	68 d2 47 00 00       	push   $0x47d2
     8f4:	e8 13 36 00 00       	call   3f0c <chdir>
     8f9:	83 c4 10             	add    $0x10,%esp
     8fc:	85 c0                	test   %eax,%eax
     8fe:	79 1b                	jns    91b <dirtest+0xa9>
    printf(stdout, "chdir .. failed\n");
     900:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     905:	83 ec 08             	sub    $0x8,%esp
     908:	68 d5 47 00 00       	push   $0x47d5
     90d:	50                   	push   %eax
     90e:	e8 f8 36 00 00       	call   400b <printf>
     913:	83 c4 10             	add    $0x10,%esp
    exit();
     916:	e8 81 35 00 00       	call   3e9c <exit>
  }

  if(unlink("dir0") < 0){
     91b:	83 ec 0c             	sub    $0xc,%esp
     91e:	68 ba 47 00 00       	push   $0x47ba
     923:	e8 c4 35 00 00       	call   3eec <unlink>
     928:	83 c4 10             	add    $0x10,%esp
     92b:	85 c0                	test   %eax,%eax
     92d:	79 1b                	jns    94a <dirtest+0xd8>
    printf(stdout, "unlink dir0 failed\n");
     92f:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     934:	83 ec 08             	sub    $0x8,%esp
     937:	68 e6 47 00 00       	push   $0x47e6
     93c:	50                   	push   %eax
     93d:	e8 c9 36 00 00       	call   400b <printf>
     942:	83 c4 10             	add    $0x10,%esp
    exit();
     945:	e8 52 35 00 00       	call   3e9c <exit>
  }
  printf(stdout, "mkdir test ok\n");
     94a:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     94f:	83 ec 08             	sub    $0x8,%esp
     952:	68 fa 47 00 00       	push   $0x47fa
     957:	50                   	push   %eax
     958:	e8 ae 36 00 00       	call   400b <printf>
     95d:	83 c4 10             	add    $0x10,%esp
}
     960:	c9                   	leave  
     961:	c3                   	ret    

00000962 <exectest>:

void
exectest(void)
{
     962:	55                   	push   %ebp
     963:	89 e5                	mov    %esp,%ebp
     965:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "exec test\n");
     968:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     96d:	83 ec 08             	sub    $0x8,%esp
     970:	68 09 48 00 00       	push   $0x4809
     975:	50                   	push   %eax
     976:	e8 90 36 00 00       	call   400b <printf>
     97b:	83 c4 10             	add    $0x10,%esp
  if(exec("echo", echoargv) < 0){
     97e:	83 ec 08             	sub    $0x8,%esp
     981:	68 98 5b 00 00       	push   $0x5b98
     986:	68 b4 43 00 00       	push   $0x43b4
     98b:	e8 44 35 00 00       	call   3ed4 <exec>
     990:	83 c4 10             	add    $0x10,%esp
     993:	85 c0                	test   %eax,%eax
     995:	79 1b                	jns    9b2 <exectest+0x50>
    printf(stdout, "exec echo failed\n");
     997:	a1 ac 5b 00 00       	mov    0x5bac,%eax
     99c:	83 ec 08             	sub    $0x8,%esp
     99f:	68 14 48 00 00       	push   $0x4814
     9a4:	50                   	push   %eax
     9a5:	e8 61 36 00 00       	call   400b <printf>
     9aa:	83 c4 10             	add    $0x10,%esp
    exit();
     9ad:	e8 ea 34 00 00       	call   3e9c <exit>
  }
}
     9b2:	c9                   	leave  
     9b3:	c3                   	ret    

000009b4 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     9b4:	55                   	push   %ebp
     9b5:	89 e5                	mov    %esp,%ebp
     9b7:	83 ec 28             	sub    $0x28,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     9ba:	83 ec 0c             	sub    $0xc,%esp
     9bd:	8d 45 d8             	lea    -0x28(%ebp),%eax
     9c0:	50                   	push   %eax
     9c1:	e8 e6 34 00 00       	call   3eac <pipe>
     9c6:	83 c4 10             	add    $0x10,%esp
     9c9:	85 c0                	test   %eax,%eax
     9cb:	74 17                	je     9e4 <pipe1+0x30>
    printf(1, "pipe() failed\n");
     9cd:	83 ec 08             	sub    $0x8,%esp
     9d0:	68 26 48 00 00       	push   $0x4826
     9d5:	6a 01                	push   $0x1
     9d7:	e8 2f 36 00 00       	call   400b <printf>
     9dc:	83 c4 10             	add    $0x10,%esp
    exit();
     9df:	e8 b8 34 00 00       	call   3e9c <exit>
  }
  pid = fork();
     9e4:	e8 ab 34 00 00       	call   3e94 <fork>
     9e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     9ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     9f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     9f7:	0f 85 83 00 00 00    	jne    a80 <pipe1+0xcc>
    close(fds[0]);
     9fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
     a00:	83 ec 0c             	sub    $0xc,%esp
     a03:	50                   	push   %eax
     a04:	e8 bb 34 00 00       	call   3ec4 <close>
     a09:	83 c4 10             	add    $0x10,%esp
    for(n = 0; n < 5; n++){
     a0c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     a13:	eb 60                	jmp    a75 <pipe1+0xc1>
      for(i = 0; i < 1033; i++)
     a15:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     a1c:	eb 14                	jmp    a32 <pipe1+0x7e>
        buf[i] = seq++;
     a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a21:	8b 55 f0             	mov    -0x10(%ebp),%edx
     a24:	81 c2 a0 83 00 00    	add    $0x83a0,%edx
     a2a:	88 02                	mov    %al,(%edx)
     a2c:	ff 45 f4             	incl   -0xc(%ebp)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
     a2f:	ff 45 f0             	incl   -0x10(%ebp)
     a32:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     a39:	7e e3                	jle    a1e <pipe1+0x6a>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
     a3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a3e:	83 ec 04             	sub    $0x4,%esp
     a41:	68 09 04 00 00       	push   $0x409
     a46:	68 a0 83 00 00       	push   $0x83a0
     a4b:	50                   	push   %eax
     a4c:	e8 6b 34 00 00       	call   3ebc <write>
     a51:	83 c4 10             	add    $0x10,%esp
     a54:	3d 09 04 00 00       	cmp    $0x409,%eax
     a59:	74 17                	je     a72 <pipe1+0xbe>
        printf(1, "pipe1 oops 1\n");
     a5b:	83 ec 08             	sub    $0x8,%esp
     a5e:	68 35 48 00 00       	push   $0x4835
     a63:	6a 01                	push   $0x1
     a65:	e8 a1 35 00 00       	call   400b <printf>
     a6a:	83 c4 10             	add    $0x10,%esp
        exit();
     a6d:	e8 2a 34 00 00       	call   3e9c <exit>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
     a72:	ff 45 ec             	incl   -0x14(%ebp)
     a75:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     a79:	7e 9a                	jle    a15 <pipe1+0x61>
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
     a7b:	e8 1c 34 00 00       	call   3e9c <exit>
  } else if(pid > 0){
     a80:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a84:	0f 8e f4 00 00 00    	jle    b7e <pipe1+0x1ca>
    close(fds[1]);
     a8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a8d:	83 ec 0c             	sub    $0xc,%esp
     a90:	50                   	push   %eax
     a91:	e8 2e 34 00 00       	call   3ec4 <close>
     a96:	83 c4 10             	add    $0x10,%esp
    total = 0;
     a99:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     aa0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     aa7:	eb 66                	jmp    b0f <pipe1+0x15b>
      for(i = 0; i < n; i++){
     aa9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     ab0:	eb 3b                	jmp    aed <pipe1+0x139>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ab5:	05 a0 83 00 00       	add    $0x83a0,%eax
     aba:	8a 00                	mov    (%eax),%al
     abc:	0f be c0             	movsbl %al,%eax
     abf:	33 45 f4             	xor    -0xc(%ebp),%eax
     ac2:	25 ff 00 00 00       	and    $0xff,%eax
     ac7:	85 c0                	test   %eax,%eax
     ac9:	0f 95 c0             	setne  %al
     acc:	ff 45 f4             	incl   -0xc(%ebp)
     acf:	84 c0                	test   %al,%al
     ad1:	74 17                	je     aea <pipe1+0x136>
          printf(1, "pipe1 oops 2\n");
     ad3:	83 ec 08             	sub    $0x8,%esp
     ad6:	68 43 48 00 00       	push   $0x4843
     adb:	6a 01                	push   $0x1
     add:	e8 29 35 00 00       	call   400b <printf>
     ae2:	83 c4 10             	add    $0x10,%esp
          return;
     ae5:	e9 ab 00 00 00       	jmp    b95 <pipe1+0x1e1>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
     aea:	ff 45 f0             	incl   -0x10(%ebp)
     aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
     af0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     af3:	7c bd                	jl     ab2 <pipe1+0xfe>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
     af5:	8b 45 ec             	mov    -0x14(%ebp),%eax
     af8:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     afb:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     afe:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b01:	3d 00 20 00 00       	cmp    $0x2000,%eax
     b06:	76 07                	jbe    b0f <pipe1+0x15b>
        cc = sizeof(buf);
     b08:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     b0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b12:	83 ec 04             	sub    $0x4,%esp
     b15:	ff 75 e8             	pushl  -0x18(%ebp)
     b18:	68 a0 83 00 00       	push   $0x83a0
     b1d:	50                   	push   %eax
     b1e:	e8 91 33 00 00       	call   3eb4 <read>
     b23:	83 c4 10             	add    $0x10,%esp
     b26:	89 45 ec             	mov    %eax,-0x14(%ebp)
     b29:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b2d:	0f 8f 76 ff ff ff    	jg     aa9 <pipe1+0xf5>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
     b33:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     b3a:	74 1a                	je     b56 <pipe1+0x1a2>
      printf(1, "pipe1 oops 3 total %d\n", total);
     b3c:	83 ec 04             	sub    $0x4,%esp
     b3f:	ff 75 e4             	pushl  -0x1c(%ebp)
     b42:	68 51 48 00 00       	push   $0x4851
     b47:	6a 01                	push   $0x1
     b49:	e8 bd 34 00 00       	call   400b <printf>
     b4e:	83 c4 10             	add    $0x10,%esp
      exit();
     b51:	e8 46 33 00 00       	call   3e9c <exit>
    }
    close(fds[0]);
     b56:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b59:	83 ec 0c             	sub    $0xc,%esp
     b5c:	50                   	push   %eax
     b5d:	e8 62 33 00 00       	call   3ec4 <close>
     b62:	83 c4 10             	add    $0x10,%esp
    wait();
     b65:	e8 3a 33 00 00       	call   3ea4 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     b6a:	83 ec 08             	sub    $0x8,%esp
     b6d:	68 68 48 00 00       	push   $0x4868
     b72:	6a 01                	push   $0x1
     b74:	e8 92 34 00 00       	call   400b <printf>
     b79:	83 c4 10             	add    $0x10,%esp
     b7c:	eb 17                	jmp    b95 <pipe1+0x1e1>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
     b7e:	83 ec 08             	sub    $0x8,%esp
     b81:	68 72 48 00 00       	push   $0x4872
     b86:	6a 01                	push   $0x1
     b88:	e8 7e 34 00 00       	call   400b <printf>
     b8d:	83 c4 10             	add    $0x10,%esp
    exit();
     b90:	e8 07 33 00 00       	call   3e9c <exit>
  }
  printf(1, "pipe1 ok\n");
}
     b95:	c9                   	leave  
     b96:	c3                   	ret    

00000b97 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     b97:	55                   	push   %ebp
     b98:	89 e5                	mov    %esp,%ebp
     b9a:	83 ec 28             	sub    $0x28,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     b9d:	83 ec 08             	sub    $0x8,%esp
     ba0:	68 81 48 00 00       	push   $0x4881
     ba5:	6a 01                	push   $0x1
     ba7:	e8 5f 34 00 00       	call   400b <printf>
     bac:	83 c4 10             	add    $0x10,%esp
  pid1 = fork();
     baf:	e8 e0 32 00 00       	call   3e94 <fork>
     bb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     bb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     bbb:	75 02                	jne    bbf <preempt+0x28>
    for(;;)
      ;
     bbd:	eb fe                	jmp    bbd <preempt+0x26>

  pid2 = fork();
     bbf:	e8 d0 32 00 00       	call   3e94 <fork>
     bc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     bc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bcb:	75 02                	jne    bcf <preempt+0x38>
    for(;;)
      ;
     bcd:	eb fe                	jmp    bcd <preempt+0x36>

  pipe(pfds);
     bcf:	83 ec 0c             	sub    $0xc,%esp
     bd2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     bd5:	50                   	push   %eax
     bd6:	e8 d1 32 00 00       	call   3eac <pipe>
     bdb:	83 c4 10             	add    $0x10,%esp
  pid3 = fork();
     bde:	e8 b1 32 00 00       	call   3e94 <fork>
     be3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     be6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     bea:	75 4d                	jne    c39 <preempt+0xa2>
    close(pfds[0]);
     bec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     bef:	83 ec 0c             	sub    $0xc,%esp
     bf2:	50                   	push   %eax
     bf3:	e8 cc 32 00 00       	call   3ec4 <close>
     bf8:	83 c4 10             	add    $0x10,%esp
    if(write(pfds[1], "x", 1) != 1)
     bfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bfe:	83 ec 04             	sub    $0x4,%esp
     c01:	6a 01                	push   $0x1
     c03:	68 8b 48 00 00       	push   $0x488b
     c08:	50                   	push   %eax
     c09:	e8 ae 32 00 00       	call   3ebc <write>
     c0e:	83 c4 10             	add    $0x10,%esp
     c11:	83 f8 01             	cmp    $0x1,%eax
     c14:	74 12                	je     c28 <preempt+0x91>
      printf(1, "preempt write error");
     c16:	83 ec 08             	sub    $0x8,%esp
     c19:	68 8d 48 00 00       	push   $0x488d
     c1e:	6a 01                	push   $0x1
     c20:	e8 e6 33 00 00       	call   400b <printf>
     c25:	83 c4 10             	add    $0x10,%esp
    close(pfds[1]);
     c28:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c2b:	83 ec 0c             	sub    $0xc,%esp
     c2e:	50                   	push   %eax
     c2f:	e8 90 32 00 00       	call   3ec4 <close>
     c34:	83 c4 10             	add    $0x10,%esp
    for(;;)
      ;
     c37:	eb fe                	jmp    c37 <preempt+0xa0>
  }

  close(pfds[1]);
     c39:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c3c:	83 ec 0c             	sub    $0xc,%esp
     c3f:	50                   	push   %eax
     c40:	e8 7f 32 00 00       	call   3ec4 <close>
     c45:	83 c4 10             	add    $0x10,%esp
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c4b:	83 ec 04             	sub    $0x4,%esp
     c4e:	68 00 20 00 00       	push   $0x2000
     c53:	68 a0 83 00 00       	push   $0x83a0
     c58:	50                   	push   %eax
     c59:	e8 56 32 00 00       	call   3eb4 <read>
     c5e:	83 c4 10             	add    $0x10,%esp
     c61:	83 f8 01             	cmp    $0x1,%eax
     c64:	74 14                	je     c7a <preempt+0xe3>
    printf(1, "preempt read error");
     c66:	83 ec 08             	sub    $0x8,%esp
     c69:	68 a1 48 00 00       	push   $0x48a1
     c6e:	6a 01                	push   $0x1
     c70:	e8 96 33 00 00       	call   400b <printf>
     c75:	83 c4 10             	add    $0x10,%esp
    return;
     c78:	eb 7e                	jmp    cf8 <preempt+0x161>
  }
  close(pfds[0]);
     c7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c7d:	83 ec 0c             	sub    $0xc,%esp
     c80:	50                   	push   %eax
     c81:	e8 3e 32 00 00       	call   3ec4 <close>
     c86:	83 c4 10             	add    $0x10,%esp
  printf(1, "kill... ");
     c89:	83 ec 08             	sub    $0x8,%esp
     c8c:	68 b4 48 00 00       	push   $0x48b4
     c91:	6a 01                	push   $0x1
     c93:	e8 73 33 00 00       	call   400b <printf>
     c98:	83 c4 10             	add    $0x10,%esp
  kill(pid1);
     c9b:	83 ec 0c             	sub    $0xc,%esp
     c9e:	ff 75 f4             	pushl  -0xc(%ebp)
     ca1:	e8 26 32 00 00       	call   3ecc <kill>
     ca6:	83 c4 10             	add    $0x10,%esp
  kill(pid2);
     ca9:	83 ec 0c             	sub    $0xc,%esp
     cac:	ff 75 f0             	pushl  -0x10(%ebp)
     caf:	e8 18 32 00 00       	call   3ecc <kill>
     cb4:	83 c4 10             	add    $0x10,%esp
  kill(pid3);
     cb7:	83 ec 0c             	sub    $0xc,%esp
     cba:	ff 75 ec             	pushl  -0x14(%ebp)
     cbd:	e8 0a 32 00 00       	call   3ecc <kill>
     cc2:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
     cc5:	83 ec 08             	sub    $0x8,%esp
     cc8:	68 bd 48 00 00       	push   $0x48bd
     ccd:	6a 01                	push   $0x1
     ccf:	e8 37 33 00 00       	call   400b <printf>
     cd4:	83 c4 10             	add    $0x10,%esp
  wait();
     cd7:	e8 c8 31 00 00       	call   3ea4 <wait>
  wait();
     cdc:	e8 c3 31 00 00       	call   3ea4 <wait>
  wait();
     ce1:	e8 be 31 00 00       	call   3ea4 <wait>
  printf(1, "preempt ok\n");
     ce6:	83 ec 08             	sub    $0x8,%esp
     ce9:	68 c6 48 00 00       	push   $0x48c6
     cee:	6a 01                	push   $0x1
     cf0:	e8 16 33 00 00       	call   400b <printf>
     cf5:	83 c4 10             	add    $0x10,%esp
}
     cf8:	c9                   	leave  
     cf9:	c3                   	ret    

00000cfa <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     cfa:	55                   	push   %ebp
     cfb:	89 e5                	mov    %esp,%ebp
     cfd:	83 ec 18             	sub    $0x18,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     d00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     d07:	eb 4e                	jmp    d57 <exitwait+0x5d>
    pid = fork();
     d09:	e8 86 31 00 00       	call   3e94 <fork>
     d0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     d11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d15:	79 14                	jns    d2b <exitwait+0x31>
      printf(1, "fork failed\n");
     d17:	83 ec 08             	sub    $0x8,%esp
     d1a:	68 55 44 00 00       	push   $0x4455
     d1f:	6a 01                	push   $0x1
     d21:	e8 e5 32 00 00       	call   400b <printf>
     d26:	83 c4 10             	add    $0x10,%esp
      return;
     d29:	eb 44                	jmp    d6f <exitwait+0x75>
    }
    if(pid){
     d2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d2f:	74 1e                	je     d4f <exitwait+0x55>
      if(wait() != pid){
     d31:	e8 6e 31 00 00       	call   3ea4 <wait>
     d36:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     d39:	74 19                	je     d54 <exitwait+0x5a>
        printf(1, "wait wrong pid\n");
     d3b:	83 ec 08             	sub    $0x8,%esp
     d3e:	68 d2 48 00 00       	push   $0x48d2
     d43:	6a 01                	push   $0x1
     d45:	e8 c1 32 00 00       	call   400b <printf>
     d4a:	83 c4 10             	add    $0x10,%esp
        return;
     d4d:	eb 20                	jmp    d6f <exitwait+0x75>
      }
    } else {
      exit();
     d4f:	e8 48 31 00 00       	call   3e9c <exit>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     d54:	ff 45 f4             	incl   -0xc(%ebp)
     d57:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     d5b:	7e ac                	jle    d09 <exitwait+0xf>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     d5d:	83 ec 08             	sub    $0x8,%esp
     d60:	68 e2 48 00 00       	push   $0x48e2
     d65:	6a 01                	push   $0x1
     d67:	e8 9f 32 00 00       	call   400b <printf>
     d6c:	83 c4 10             	add    $0x10,%esp
}
     d6f:	c9                   	leave  
     d70:	c3                   	ret    

00000d71 <mem>:

void
mem(void)
{
     d71:	55                   	push   %ebp
     d72:	89 e5                	mov    %esp,%ebp
     d74:	83 ec 18             	sub    $0x18,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     d77:	83 ec 08             	sub    $0x8,%esp
     d7a:	68 ef 48 00 00       	push   $0x48ef
     d7f:	6a 01                	push   $0x1
     d81:	e8 85 32 00 00       	call   400b <printf>
     d86:	83 c4 10             	add    $0x10,%esp
  ppid = getpid();
     d89:	e8 8e 31 00 00       	call   3f1c <getpid>
     d8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     d91:	e8 fe 30 00 00       	call   3e94 <fork>
     d96:	89 45 ec             	mov    %eax,-0x14(%ebp)
     d99:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     d9d:	0f 85 b7 00 00 00    	jne    e5a <mem+0xe9>
    m1 = 0;
     da3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     daa:	eb 0e                	jmp    dba <mem+0x49>
      *(char**)m2 = m1;
     dac:	8b 45 e8             	mov    -0x18(%ebp),%eax
     daf:	8b 55 f4             	mov    -0xc(%ebp),%edx
     db2:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     db4:	8b 45 e8             	mov    -0x18(%ebp),%eax
     db7:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
     dba:	83 ec 0c             	sub    $0xc,%esp
     dbd:	68 11 27 00 00       	push   $0x2711
     dc2:	e8 0c 35 00 00       	call   42d3 <malloc>
     dc7:	83 c4 10             	add    $0x10,%esp
     dca:	89 45 e8             	mov    %eax,-0x18(%ebp)
     dcd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     dd1:	75 d9                	jne    dac <mem+0x3b>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     dd3:	eb 1c                	jmp    df1 <mem+0x80>
      m2 = *(char**)m1;
     dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dd8:	8b 00                	mov    (%eax),%eax
     dda:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     ddd:	83 ec 0c             	sub    $0xc,%esp
     de0:	ff 75 f4             	pushl  -0xc(%ebp)
     de3:	e8 b4 33 00 00       	call   419c <free>
     de8:	83 c4 10             	add    $0x10,%esp
      m1 = m2;
     deb:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     df1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     df5:	75 de                	jne    dd5 <mem+0x64>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
     df7:	83 ec 0c             	sub    $0xc,%esp
     dfa:	68 00 50 00 00       	push   $0x5000
     dff:	e8 cf 34 00 00       	call   42d3 <malloc>
     e04:	83 c4 10             	add    $0x10,%esp
     e07:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     e0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e0e:	75 25                	jne    e35 <mem+0xc4>
      printf(1, "couldn't allocate mem?!!\n");
     e10:	83 ec 08             	sub    $0x8,%esp
     e13:	68 f9 48 00 00       	push   $0x48f9
     e18:	6a 01                	push   $0x1
     e1a:	e8 ec 31 00 00       	call   400b <printf>
     e1f:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
     e22:	83 ec 0c             	sub    $0xc,%esp
     e25:	ff 75 f0             	pushl  -0x10(%ebp)
     e28:	e8 9f 30 00 00       	call   3ecc <kill>
     e2d:	83 c4 10             	add    $0x10,%esp
      exit();
     e30:	e8 67 30 00 00       	call   3e9c <exit>
    }
    free(m1);
     e35:	83 ec 0c             	sub    $0xc,%esp
     e38:	ff 75 f4             	pushl  -0xc(%ebp)
     e3b:	e8 5c 33 00 00       	call   419c <free>
     e40:	83 c4 10             	add    $0x10,%esp
    printf(1, "mem ok\n");
     e43:	83 ec 08             	sub    $0x8,%esp
     e46:	68 13 49 00 00       	push   $0x4913
     e4b:	6a 01                	push   $0x1
     e4d:	e8 b9 31 00 00       	call   400b <printf>
     e52:	83 c4 10             	add    $0x10,%esp
    exit();
     e55:	e8 42 30 00 00       	call   3e9c <exit>
  } else {
    wait();
     e5a:	e8 45 30 00 00       	call   3ea4 <wait>
  }
}
     e5f:	c9                   	leave  
     e60:	c3                   	ret    

00000e61 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     e61:	55                   	push   %ebp
     e62:	89 e5                	mov    %esp,%ebp
     e64:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     e67:	83 ec 08             	sub    $0x8,%esp
     e6a:	68 1b 49 00 00       	push   $0x491b
     e6f:	6a 01                	push   $0x1
     e71:	e8 95 31 00 00       	call   400b <printf>
     e76:	83 c4 10             	add    $0x10,%esp

  unlink("sharedfd");
     e79:	83 ec 0c             	sub    $0xc,%esp
     e7c:	68 2a 49 00 00       	push   $0x492a
     e81:	e8 66 30 00 00       	call   3eec <unlink>
     e86:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", O_CREATE|O_RDWR);
     e89:	83 ec 08             	sub    $0x8,%esp
     e8c:	68 02 02 00 00       	push   $0x202
     e91:	68 2a 49 00 00       	push   $0x492a
     e96:	e8 41 30 00 00       	call   3edc <open>
     e9b:	83 c4 10             	add    $0x10,%esp
     e9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     ea1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     ea5:	79 17                	jns    ebe <sharedfd+0x5d>
    printf(1, "fstests: cannot open sharedfd for writing");
     ea7:	83 ec 08             	sub    $0x8,%esp
     eaa:	68 34 49 00 00       	push   $0x4934
     eaf:	6a 01                	push   $0x1
     eb1:	e8 55 31 00 00       	call   400b <printf>
     eb6:	83 c4 10             	add    $0x10,%esp
    return;
     eb9:	e9 7a 01 00 00       	jmp    1038 <sharedfd+0x1d7>
  }
  pid = fork();
     ebe:	e8 d1 2f 00 00       	call   3e94 <fork>
     ec3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     ec6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     eca:	75 07                	jne    ed3 <sharedfd+0x72>
     ecc:	b8 63 00 00 00       	mov    $0x63,%eax
     ed1:	eb 05                	jmp    ed8 <sharedfd+0x77>
     ed3:	b8 70 00 00 00       	mov    $0x70,%eax
     ed8:	83 ec 04             	sub    $0x4,%esp
     edb:	6a 0a                	push   $0xa
     edd:	50                   	push   %eax
     ede:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     ee1:	50                   	push   %eax
     ee2:	e8 33 2e 00 00       	call   3d1a <memset>
     ee7:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 1000; i++){
     eea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     ef1:	eb 30                	jmp    f23 <sharedfd+0xc2>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     ef3:	83 ec 04             	sub    $0x4,%esp
     ef6:	6a 0a                	push   $0xa
     ef8:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     efb:	50                   	push   %eax
     efc:	ff 75 e8             	pushl  -0x18(%ebp)
     eff:	e8 b8 2f 00 00       	call   3ebc <write>
     f04:	83 c4 10             	add    $0x10,%esp
     f07:	83 f8 0a             	cmp    $0xa,%eax
     f0a:	74 14                	je     f20 <sharedfd+0xbf>
      printf(1, "fstests: write sharedfd failed\n");
     f0c:	83 ec 08             	sub    $0x8,%esp
     f0f:	68 60 49 00 00       	push   $0x4960
     f14:	6a 01                	push   $0x1
     f16:	e8 f0 30 00 00       	call   400b <printf>
     f1b:	83 c4 10             	add    $0x10,%esp
      break;
     f1e:	eb 0c                	jmp    f2c <sharedfd+0xcb>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
  memset(buf, pid==0?'c':'p', sizeof(buf));
  for(i = 0; i < 1000; i++){
     f20:	ff 45 f4             	incl   -0xc(%ebp)
     f23:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     f2a:	7e c7                	jle    ef3 <sharedfd+0x92>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
     f2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     f30:	75 05                	jne    f37 <sharedfd+0xd6>
    exit();
     f32:	e8 65 2f 00 00       	call   3e9c <exit>
  else
    wait();
     f37:	e8 68 2f 00 00       	call   3ea4 <wait>
  close(fd);
     f3c:	83 ec 0c             	sub    $0xc,%esp
     f3f:	ff 75 e8             	pushl  -0x18(%ebp)
     f42:	e8 7d 2f 00 00       	call   3ec4 <close>
     f47:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", 0);
     f4a:	83 ec 08             	sub    $0x8,%esp
     f4d:	6a 00                	push   $0x0
     f4f:	68 2a 49 00 00       	push   $0x492a
     f54:	e8 83 2f 00 00       	call   3edc <open>
     f59:	83 c4 10             	add    $0x10,%esp
     f5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     f5f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     f63:	79 17                	jns    f7c <sharedfd+0x11b>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     f65:	83 ec 08             	sub    $0x8,%esp
     f68:	68 80 49 00 00       	push   $0x4980
     f6d:	6a 01                	push   $0x1
     f6f:	e8 97 30 00 00       	call   400b <printf>
     f74:	83 c4 10             	add    $0x10,%esp
    return;
     f77:	e9 bc 00 00 00       	jmp    1038 <sharedfd+0x1d7>
  }
  nc = np = 0;
     f7c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     f83:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f89:	eb 32                	jmp    fbd <sharedfd+0x15c>
    for(i = 0; i < sizeof(buf); i++){
     f8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f92:	eb 21                	jmp    fb5 <sharedfd+0x154>
      if(buf[i] == 'c')
     f94:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f97:	03 45 f4             	add    -0xc(%ebp),%eax
     f9a:	8a 00                	mov    (%eax),%al
     f9c:	3c 63                	cmp    $0x63,%al
     f9e:	75 03                	jne    fa3 <sharedfd+0x142>
        nc++;
     fa0:	ff 45 f0             	incl   -0x10(%ebp)
      if(buf[i] == 'p')
     fa3:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     fa6:	03 45 f4             	add    -0xc(%ebp),%eax
     fa9:	8a 00                	mov    (%eax),%al
     fab:	3c 70                	cmp    $0x70,%al
     fad:	75 03                	jne    fb2 <sharedfd+0x151>
        np++;
     faf:	ff 45 ec             	incl   -0x14(%ebp)
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
     fb2:	ff 45 f4             	incl   -0xc(%ebp)
     fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fb8:	83 f8 09             	cmp    $0x9,%eax
     fbb:	76 d7                	jbe    f94 <sharedfd+0x133>
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
     fbd:	83 ec 04             	sub    $0x4,%esp
     fc0:	6a 0a                	push   $0xa
     fc2:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     fc5:	50                   	push   %eax
     fc6:	ff 75 e8             	pushl  -0x18(%ebp)
     fc9:	e8 e6 2e 00 00       	call   3eb4 <read>
     fce:	83 c4 10             	add    $0x10,%esp
     fd1:	89 45 e0             	mov    %eax,-0x20(%ebp)
     fd4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     fd8:	7f b1                	jg     f8b <sharedfd+0x12a>
        nc++;
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
     fda:	83 ec 0c             	sub    $0xc,%esp
     fdd:	ff 75 e8             	pushl  -0x18(%ebp)
     fe0:	e8 df 2e 00 00       	call   3ec4 <close>
     fe5:	83 c4 10             	add    $0x10,%esp
  unlink("sharedfd");
     fe8:	83 ec 0c             	sub    $0xc,%esp
     feb:	68 2a 49 00 00       	push   $0x492a
     ff0:	e8 f7 2e 00 00       	call   3eec <unlink>
     ff5:	83 c4 10             	add    $0x10,%esp
  if(nc == 10000 && np == 10000){
     ff8:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
     fff:	75 1d                	jne    101e <sharedfd+0x1bd>
    1001:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
    1008:	75 14                	jne    101e <sharedfd+0x1bd>
    printf(1, "sharedfd ok\n");
    100a:	83 ec 08             	sub    $0x8,%esp
    100d:	68 ab 49 00 00       	push   $0x49ab
    1012:	6a 01                	push   $0x1
    1014:	e8 f2 2f 00 00       	call   400b <printf>
    1019:	83 c4 10             	add    $0x10,%esp
    101c:	eb 1a                	jmp    1038 <sharedfd+0x1d7>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    101e:	ff 75 ec             	pushl  -0x14(%ebp)
    1021:	ff 75 f0             	pushl  -0x10(%ebp)
    1024:	68 b8 49 00 00       	push   $0x49b8
    1029:	6a 01                	push   $0x1
    102b:	e8 db 2f 00 00       	call   400b <printf>
    1030:	83 c4 10             	add    $0x10,%esp
    exit();
    1033:	e8 64 2e 00 00       	call   3e9c <exit>
  }
}
    1038:	c9                   	leave  
    1039:	c3                   	ret    

0000103a <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    103a:	55                   	push   %ebp
    103b:	89 e5                	mov    %esp,%ebp
    103d:	57                   	push   %edi
    103e:	56                   	push   %esi
    103f:	53                   	push   %ebx
    1040:	83 ec 3c             	sub    $0x3c,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    1043:	8d 55 b8             	lea    -0x48(%ebp),%edx
    1046:	bb 80 5b 00 00       	mov    $0x5b80,%ebx
    104b:	b8 04 00 00 00       	mov    $0x4,%eax
    1050:	89 d7                	mov    %edx,%edi
    1052:	89 de                	mov    %ebx,%esi
    1054:	89 c1                	mov    %eax,%ecx
    1056:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  char *fname;

  printf(1, "fourfiles test\n");
    1058:	83 ec 08             	sub    $0x8,%esp
    105b:	68 cd 49 00 00       	push   $0x49cd
    1060:	6a 01                	push   $0x1
    1062:	e8 a4 2f 00 00       	call   400b <printf>
    1067:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    106a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
    1071:	e9 ee 00 00 00       	jmp    1164 <fourfiles+0x12a>
    fname = names[pi];
    1076:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1079:	8b 44 85 b8          	mov    -0x48(%ebp,%eax,4),%eax
    107d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unlink(fname);
    1080:	83 ec 0c             	sub    $0xc,%esp
    1083:	ff 75 d4             	pushl  -0x2c(%ebp)
    1086:	e8 61 2e 00 00       	call   3eec <unlink>
    108b:	83 c4 10             	add    $0x10,%esp

    pid = fork();
    108e:	e8 01 2e 00 00       	call   3e94 <fork>
    1093:	89 45 d0             	mov    %eax,-0x30(%ebp)
    if(pid < 0){
    1096:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    109a:	79 17                	jns    10b3 <fourfiles+0x79>
      printf(1, "fork failed\n");
    109c:	83 ec 08             	sub    $0x8,%esp
    109f:	68 55 44 00 00       	push   $0x4455
    10a4:	6a 01                	push   $0x1
    10a6:	e8 60 2f 00 00       	call   400b <printf>
    10ab:	83 c4 10             	add    $0x10,%esp
      exit();
    10ae:	e8 e9 2d 00 00       	call   3e9c <exit>
    }

    if(pid == 0){
    10b3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    10b7:	0f 85 a4 00 00 00    	jne    1161 <fourfiles+0x127>
      fd = open(fname, O_CREATE | O_RDWR);
    10bd:	83 ec 08             	sub    $0x8,%esp
    10c0:	68 02 02 00 00       	push   $0x202
    10c5:	ff 75 d4             	pushl  -0x2c(%ebp)
    10c8:	e8 0f 2e 00 00       	call   3edc <open>
    10cd:	83 c4 10             	add    $0x10,%esp
    10d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
      if(fd < 0){
    10d3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
    10d7:	79 17                	jns    10f0 <fourfiles+0xb6>
        printf(1, "create failed\n");
    10d9:	83 ec 08             	sub    $0x8,%esp
    10dc:	68 dd 49 00 00       	push   $0x49dd
    10e1:	6a 01                	push   $0x1
    10e3:	e8 23 2f 00 00       	call   400b <printf>
    10e8:	83 c4 10             	add    $0x10,%esp
        exit();
    10eb:	e8 ac 2d 00 00       	call   3e9c <exit>
      }
      
      memset(buf, '0'+pi, 512);
    10f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
    10f3:	83 c0 30             	add    $0x30,%eax
    10f6:	83 ec 04             	sub    $0x4,%esp
    10f9:	68 00 02 00 00       	push   $0x200
    10fe:	50                   	push   %eax
    10ff:	68 a0 83 00 00       	push   $0x83a0
    1104:	e8 11 2c 00 00       	call   3d1a <memset>
    1109:	83 c4 10             	add    $0x10,%esp
      for(i = 0; i < 12; i++){
    110c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    1113:	eb 41                	jmp    1156 <fourfiles+0x11c>
        if((n = write(fd, buf, 500)) != 500){
    1115:	83 ec 04             	sub    $0x4,%esp
    1118:	68 f4 01 00 00       	push   $0x1f4
    111d:	68 a0 83 00 00       	push   $0x83a0
    1122:	ff 75 cc             	pushl  -0x34(%ebp)
    1125:	e8 92 2d 00 00       	call   3ebc <write>
    112a:	83 c4 10             	add    $0x10,%esp
    112d:	89 45 c8             	mov    %eax,-0x38(%ebp)
    1130:	81 7d c8 f4 01 00 00 	cmpl   $0x1f4,-0x38(%ebp)
    1137:	74 1a                	je     1153 <fourfiles+0x119>
          printf(1, "write failed %d\n", n);
    1139:	83 ec 04             	sub    $0x4,%esp
    113c:	ff 75 c8             	pushl  -0x38(%ebp)
    113f:	68 ec 49 00 00       	push   $0x49ec
    1144:	6a 01                	push   $0x1
    1146:	e8 c0 2e 00 00       	call   400b <printf>
    114b:	83 c4 10             	add    $0x10,%esp
          exit();
    114e:	e8 49 2d 00 00       	call   3e9c <exit>
        printf(1, "create failed\n");
        exit();
      }
      
      memset(buf, '0'+pi, 512);
      for(i = 0; i < 12; i++){
    1153:	ff 45 e4             	incl   -0x1c(%ebp)
    1156:	83 7d e4 0b          	cmpl   $0xb,-0x1c(%ebp)
    115a:	7e b9                	jle    1115 <fourfiles+0xdb>
        if((n = write(fd, buf, 500)) != 500){
          printf(1, "write failed %d\n", n);
          exit();
        }
      }
      exit();
    115c:	e8 3b 2d 00 00       	call   3e9c <exit>
  char *names[] = { "f0", "f1", "f2", "f3" };
  char *fname;

  printf(1, "fourfiles test\n");

  for(pi = 0; pi < 4; pi++){
    1161:	ff 45 d8             	incl   -0x28(%ebp)
    1164:	83 7d d8 03          	cmpl   $0x3,-0x28(%ebp)
    1168:	0f 8e 08 ff ff ff    	jle    1076 <fourfiles+0x3c>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    116e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
    1175:	eb 08                	jmp    117f <fourfiles+0x145>
    wait();
    1177:	e8 28 2d 00 00       	call   3ea4 <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    117c:	ff 45 d8             	incl   -0x28(%ebp)
    117f:	83 7d d8 03          	cmpl   $0x3,-0x28(%ebp)
    1183:	7e f2                	jle    1177 <fourfiles+0x13d>
    wait();
  }

  for(i = 0; i < 2; i++){
    1185:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    118c:	e9 d1 00 00 00       	jmp    1262 <fourfiles+0x228>
    fname = names[i];
    1191:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1194:	8b 44 85 b8          	mov    -0x48(%ebp,%eax,4),%eax
    1198:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    fd = open(fname, 0);
    119b:	83 ec 08             	sub    $0x8,%esp
    119e:	6a 00                	push   $0x0
    11a0:	ff 75 d4             	pushl  -0x2c(%ebp)
    11a3:	e8 34 2d 00 00       	call   3edc <open>
    11a8:	83 c4 10             	add    $0x10,%esp
    11ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
    total = 0;
    11ae:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11b5:	eb 48                	jmp    11ff <fourfiles+0x1c5>
      for(j = 0; j < n; j++){
    11b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    11be:	eb 31                	jmp    11f1 <fourfiles+0x1b7>
        if(buf[j] != '0'+i){
    11c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11c3:	05 a0 83 00 00       	add    $0x83a0,%eax
    11c8:	8a 00                	mov    (%eax),%al
    11ca:	0f be c0             	movsbl %al,%eax
    11cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    11d0:	83 c2 30             	add    $0x30,%edx
    11d3:	39 d0                	cmp    %edx,%eax
    11d5:	74 17                	je     11ee <fourfiles+0x1b4>
          printf(1, "wrong char\n");
    11d7:	83 ec 08             	sub    $0x8,%esp
    11da:	68 fd 49 00 00       	push   $0x49fd
    11df:	6a 01                	push   $0x1
    11e1:	e8 25 2e 00 00       	call   400b <printf>
    11e6:	83 c4 10             	add    $0x10,%esp
          exit();
    11e9:	e8 ae 2c 00 00       	call   3e9c <exit>
  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
    11ee:	ff 45 e0             	incl   -0x20(%ebp)
    11f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11f4:	3b 45 c8             	cmp    -0x38(%ebp),%eax
    11f7:	7c c7                	jl     11c0 <fourfiles+0x186>
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
    11f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
    11fc:	01 45 dc             	add    %eax,-0x24(%ebp)

  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11ff:	83 ec 04             	sub    $0x4,%esp
    1202:	68 00 20 00 00       	push   $0x2000
    1207:	68 a0 83 00 00       	push   $0x83a0
    120c:	ff 75 cc             	pushl  -0x34(%ebp)
    120f:	e8 a0 2c 00 00       	call   3eb4 <read>
    1214:	83 c4 10             	add    $0x10,%esp
    1217:	89 45 c8             	mov    %eax,-0x38(%ebp)
    121a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
    121e:	7f 97                	jg     11b7 <fourfiles+0x17d>
          exit();
        }
      }
      total += n;
    }
    close(fd);
    1220:	83 ec 0c             	sub    $0xc,%esp
    1223:	ff 75 cc             	pushl  -0x34(%ebp)
    1226:	e8 99 2c 00 00       	call   3ec4 <close>
    122b:	83 c4 10             	add    $0x10,%esp
    if(total != 12*500){
    122e:	81 7d dc 70 17 00 00 	cmpl   $0x1770,-0x24(%ebp)
    1235:	74 1a                	je     1251 <fourfiles+0x217>
      printf(1, "wrong length %d\n", total);
    1237:	83 ec 04             	sub    $0x4,%esp
    123a:	ff 75 dc             	pushl  -0x24(%ebp)
    123d:	68 09 4a 00 00       	push   $0x4a09
    1242:	6a 01                	push   $0x1
    1244:	e8 c2 2d 00 00       	call   400b <printf>
    1249:	83 c4 10             	add    $0x10,%esp
      exit();
    124c:	e8 4b 2c 00 00       	call   3e9c <exit>
    }
    unlink(fname);
    1251:	83 ec 0c             	sub    $0xc,%esp
    1254:	ff 75 d4             	pushl  -0x2c(%ebp)
    1257:	e8 90 2c 00 00       	call   3eec <unlink>
    125c:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    wait();
  }

  for(i = 0; i < 2; i++){
    125f:	ff 45 e4             	incl   -0x1c(%ebp)
    1262:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
    1266:	0f 8e 25 ff ff ff    	jle    1191 <fourfiles+0x157>
      exit();
    }
    unlink(fname);
  }

  printf(1, "fourfiles ok\n");
    126c:	83 ec 08             	sub    $0x8,%esp
    126f:	68 1a 4a 00 00       	push   $0x4a1a
    1274:	6a 01                	push   $0x1
    1276:	e8 90 2d 00 00       	call   400b <printf>
    127b:	83 c4 10             	add    $0x10,%esp
}
    127e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1281:	83 c4 00             	add    $0x0,%esp
    1284:	5b                   	pop    %ebx
    1285:	5e                   	pop    %esi
    1286:	5f                   	pop    %edi
    1287:	c9                   	leave  
    1288:	c3                   	ret    

00001289 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    1289:	55                   	push   %ebp
    128a:	89 e5                	mov    %esp,%ebp
    128c:	83 ec 38             	sub    $0x38,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    128f:	83 ec 08             	sub    $0x8,%esp
    1292:	68 28 4a 00 00       	push   $0x4a28
    1297:	6a 01                	push   $0x1
    1299:	e8 6d 2d 00 00       	call   400b <printf>
    129e:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    12a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    12a8:	e9 f5 00 00 00       	jmp    13a2 <createdelete+0x119>
    pid = fork();
    12ad:	e8 e2 2b 00 00       	call   3e94 <fork>
    12b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    12b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12b9:	79 17                	jns    12d2 <createdelete+0x49>
      printf(1, "fork failed\n");
    12bb:	83 ec 08             	sub    $0x8,%esp
    12be:	68 55 44 00 00       	push   $0x4455
    12c3:	6a 01                	push   $0x1
    12c5:	e8 41 2d 00 00       	call   400b <printf>
    12ca:	83 c4 10             	add    $0x10,%esp
      exit();
    12cd:	e8 ca 2b 00 00       	call   3e9c <exit>
    }

    if(pid == 0){
    12d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12d6:	0f 85 c3 00 00 00    	jne    139f <createdelete+0x116>
      name[0] = 'p' + pi;
    12dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12df:	83 c0 70             	add    $0x70,%eax
    12e2:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    12e5:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    12e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    12f0:	e9 9b 00 00 00       	jmp    1390 <createdelete+0x107>
        name[1] = '0' + i;
    12f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f8:	83 c0 30             	add    $0x30,%eax
    12fb:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    12fe:	83 ec 08             	sub    $0x8,%esp
    1301:	68 02 02 00 00       	push   $0x202
    1306:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1309:	50                   	push   %eax
    130a:	e8 cd 2b 00 00       	call   3edc <open>
    130f:	83 c4 10             	add    $0x10,%esp
    1312:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if(fd < 0){
    1315:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1319:	79 17                	jns    1332 <createdelete+0xa9>
          printf(1, "create failed\n");
    131b:	83 ec 08             	sub    $0x8,%esp
    131e:	68 dd 49 00 00       	push   $0x49dd
    1323:	6a 01                	push   $0x1
    1325:	e8 e1 2c 00 00       	call   400b <printf>
    132a:	83 c4 10             	add    $0x10,%esp
          exit();
    132d:	e8 6a 2b 00 00       	call   3e9c <exit>
        }
        close(fd);
    1332:	83 ec 0c             	sub    $0xc,%esp
    1335:	ff 75 e8             	pushl  -0x18(%ebp)
    1338:	e8 87 2b 00 00       	call   3ec4 <close>
    133d:	83 c4 10             	add    $0x10,%esp
        if(i > 0 && (i % 2 ) == 0){
    1340:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1344:	7e 47                	jle    138d <createdelete+0x104>
    1346:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1349:	83 e0 01             	and    $0x1,%eax
    134c:	85 c0                	test   %eax,%eax
    134e:	75 3d                	jne    138d <createdelete+0x104>
          name[1] = '0' + (i / 2);
    1350:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1353:	89 c2                	mov    %eax,%edx
    1355:	c1 ea 1f             	shr    $0x1f,%edx
    1358:	8d 04 02             	lea    (%edx,%eax,1),%eax
    135b:	d1 f8                	sar    %eax
    135d:	83 c0 30             	add    $0x30,%eax
    1360:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    1363:	83 ec 0c             	sub    $0xc,%esp
    1366:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1369:	50                   	push   %eax
    136a:	e8 7d 2b 00 00       	call   3eec <unlink>
    136f:	83 c4 10             	add    $0x10,%esp
    1372:	85 c0                	test   %eax,%eax
    1374:	79 17                	jns    138d <createdelete+0x104>
            printf(1, "unlink failed\n");
    1376:	83 ec 08             	sub    $0x8,%esp
    1379:	68 d8 44 00 00       	push   $0x44d8
    137e:	6a 01                	push   $0x1
    1380:	e8 86 2c 00 00       	call   400b <printf>
    1385:	83 c4 10             	add    $0x10,%esp
            exit();
    1388:	e8 0f 2b 00 00       	call   3e9c <exit>
    }

    if(pid == 0){
      name[0] = 'p' + pi;
      name[2] = '\0';
      for(i = 0; i < N; i++){
    138d:	ff 45 f4             	incl   -0xc(%ebp)
    1390:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1394:	0f 8e 5b ff ff ff    	jle    12f5 <createdelete+0x6c>
            printf(1, "unlink failed\n");
            exit();
          }
        }
      }
      exit();
    139a:	e8 fd 2a 00 00       	call   3e9c <exit>
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");

  for(pi = 0; pi < 4; pi++){
    139f:	ff 45 f0             	incl   -0x10(%ebp)
    13a2:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13a6:	0f 8e 01 ff ff ff    	jle    12ad <createdelete+0x24>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    13ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13b3:	eb 08                	jmp    13bd <createdelete+0x134>
    wait();
    13b5:	e8 ea 2a 00 00       	call   3ea4 <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    13ba:	ff 45 f0             	incl   -0x10(%ebp)
    13bd:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13c1:	7e f2                	jle    13b5 <createdelete+0x12c>
    wait();
  }

  name[0] = name[1] = name[2] = 0;
    13c3:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    13c7:	8a 45 ca             	mov    -0x36(%ebp),%al
    13ca:	88 45 c9             	mov    %al,-0x37(%ebp)
    13cd:	8a 45 c9             	mov    -0x37(%ebp),%al
    13d0:	88 45 c8             	mov    %al,-0x38(%ebp)
  for(i = 0; i < N; i++){
    13d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13da:	e9 b0 00 00 00       	jmp    148f <createdelete+0x206>
    for(pi = 0; pi < 4; pi++){
    13df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13e6:	e9 97 00 00 00       	jmp    1482 <createdelete+0x1f9>
      name[0] = 'p' + pi;
    13eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13ee:	83 c0 70             	add    $0x70,%eax
    13f1:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    13f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13f7:	83 c0 30             	add    $0x30,%eax
    13fa:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    13fd:	83 ec 08             	sub    $0x8,%esp
    1400:	6a 00                	push   $0x0
    1402:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1405:	50                   	push   %eax
    1406:	e8 d1 2a 00 00       	call   3edc <open>
    140b:	83 c4 10             	add    $0x10,%esp
    140e:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((i == 0 || i >= N/2) && fd < 0){
    1411:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1415:	74 06                	je     141d <createdelete+0x194>
    1417:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    141b:	7e 21                	jle    143e <createdelete+0x1b5>
    141d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1421:	79 1b                	jns    143e <createdelete+0x1b5>
        printf(1, "oops createdelete %s didn't exist\n", name);
    1423:	83 ec 04             	sub    $0x4,%esp
    1426:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1429:	50                   	push   %eax
    142a:	68 3c 4a 00 00       	push   $0x4a3c
    142f:	6a 01                	push   $0x1
    1431:	e8 d5 2b 00 00       	call   400b <printf>
    1436:	83 c4 10             	add    $0x10,%esp
        exit();
    1439:	e8 5e 2a 00 00       	call   3e9c <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    143e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1442:	7e 27                	jle    146b <createdelete+0x1e2>
    1444:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1448:	7f 21                	jg     146b <createdelete+0x1e2>
    144a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    144e:	78 1b                	js     146b <createdelete+0x1e2>
        printf(1, "oops createdelete %s did exist\n", name);
    1450:	83 ec 04             	sub    $0x4,%esp
    1453:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1456:	50                   	push   %eax
    1457:	68 60 4a 00 00       	push   $0x4a60
    145c:	6a 01                	push   $0x1
    145e:	e8 a8 2b 00 00       	call   400b <printf>
    1463:	83 c4 10             	add    $0x10,%esp
        exit();
    1466:	e8 31 2a 00 00       	call   3e9c <exit>
      }
      if(fd >= 0)
    146b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    146f:	78 0e                	js     147f <createdelete+0x1f6>
        close(fd);
    1471:	83 ec 0c             	sub    $0xc,%esp
    1474:	ff 75 e8             	pushl  -0x18(%ebp)
    1477:	e8 48 2a 00 00       	call   3ec4 <close>
    147c:	83 c4 10             	add    $0x10,%esp
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    147f:	ff 45 f0             	incl   -0x10(%ebp)
    1482:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    1486:	0f 8e 5f ff ff ff    	jle    13eb <createdelete+0x162>
  for(pi = 0; pi < 4; pi++){
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    148c:	ff 45 f4             	incl   -0xc(%ebp)
    148f:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1493:	0f 8e 46 ff ff ff    	jle    13df <createdelete+0x156>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    1499:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    14a0:	eb 36                	jmp    14d8 <createdelete+0x24f>
    for(pi = 0; pi < 4; pi++){
    14a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14a9:	eb 24                	jmp    14cf <createdelete+0x246>
      name[0] = 'p' + i;
    14ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ae:	83 c0 70             	add    $0x70,%eax
    14b1:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    14b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b7:	83 c0 30             	add    $0x30,%eax
    14ba:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    14bd:	83 ec 0c             	sub    $0xc,%esp
    14c0:	8d 45 c8             	lea    -0x38(%ebp),%eax
    14c3:	50                   	push   %eax
    14c4:	e8 23 2a 00 00       	call   3eec <unlink>
    14c9:	83 c4 10             	add    $0x10,%esp
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    14cc:	ff 45 f0             	incl   -0x10(%ebp)
    14cf:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    14d3:	7e d6                	jle    14ab <createdelete+0x222>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    14d5:	ff 45 f4             	incl   -0xc(%ebp)
    14d8:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    14dc:	7e c4                	jle    14a2 <createdelete+0x219>
      name[1] = '0' + i;
      unlink(name);
    }
  }

  printf(1, "createdelete ok\n");
    14de:	83 ec 08             	sub    $0x8,%esp
    14e1:	68 80 4a 00 00       	push   $0x4a80
    14e6:	6a 01                	push   $0x1
    14e8:	e8 1e 2b 00 00       	call   400b <printf>
    14ed:	83 c4 10             	add    $0x10,%esp
}
    14f0:	c9                   	leave  
    14f1:	c3                   	ret    

000014f2 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    14f2:	55                   	push   %ebp
    14f3:	89 e5                	mov    %esp,%ebp
    14f5:	83 ec 18             	sub    $0x18,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    14f8:	83 ec 08             	sub    $0x8,%esp
    14fb:	68 91 4a 00 00       	push   $0x4a91
    1500:	6a 01                	push   $0x1
    1502:	e8 04 2b 00 00       	call   400b <printf>
    1507:	83 c4 10             	add    $0x10,%esp
  fd = open("unlinkread", O_CREATE | O_RDWR);
    150a:	83 ec 08             	sub    $0x8,%esp
    150d:	68 02 02 00 00       	push   $0x202
    1512:	68 a2 4a 00 00       	push   $0x4aa2
    1517:	e8 c0 29 00 00       	call   3edc <open>
    151c:	83 c4 10             	add    $0x10,%esp
    151f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1522:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1526:	79 17                	jns    153f <unlinkread+0x4d>
    printf(1, "create unlinkread failed\n");
    1528:	83 ec 08             	sub    $0x8,%esp
    152b:	68 ad 4a 00 00       	push   $0x4aad
    1530:	6a 01                	push   $0x1
    1532:	e8 d4 2a 00 00       	call   400b <printf>
    1537:	83 c4 10             	add    $0x10,%esp
    exit();
    153a:	e8 5d 29 00 00       	call   3e9c <exit>
  }
  write(fd, "hello", 5);
    153f:	83 ec 04             	sub    $0x4,%esp
    1542:	6a 05                	push   $0x5
    1544:	68 c7 4a 00 00       	push   $0x4ac7
    1549:	ff 75 f4             	pushl  -0xc(%ebp)
    154c:	e8 6b 29 00 00       	call   3ebc <write>
    1551:	83 c4 10             	add    $0x10,%esp
  close(fd);
    1554:	83 ec 0c             	sub    $0xc,%esp
    1557:	ff 75 f4             	pushl  -0xc(%ebp)
    155a:	e8 65 29 00 00       	call   3ec4 <close>
    155f:	83 c4 10             	add    $0x10,%esp

  fd = open("unlinkread", O_RDWR);
    1562:	83 ec 08             	sub    $0x8,%esp
    1565:	6a 02                	push   $0x2
    1567:	68 a2 4a 00 00       	push   $0x4aa2
    156c:	e8 6b 29 00 00       	call   3edc <open>
    1571:	83 c4 10             	add    $0x10,%esp
    1574:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1577:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    157b:	79 17                	jns    1594 <unlinkread+0xa2>
    printf(1, "open unlinkread failed\n");
    157d:	83 ec 08             	sub    $0x8,%esp
    1580:	68 cd 4a 00 00       	push   $0x4acd
    1585:	6a 01                	push   $0x1
    1587:	e8 7f 2a 00 00       	call   400b <printf>
    158c:	83 c4 10             	add    $0x10,%esp
    exit();
    158f:	e8 08 29 00 00       	call   3e9c <exit>
  }
  if(unlink("unlinkread") != 0){
    1594:	83 ec 0c             	sub    $0xc,%esp
    1597:	68 a2 4a 00 00       	push   $0x4aa2
    159c:	e8 4b 29 00 00       	call   3eec <unlink>
    15a1:	83 c4 10             	add    $0x10,%esp
    15a4:	85 c0                	test   %eax,%eax
    15a6:	74 17                	je     15bf <unlinkread+0xcd>
    printf(1, "unlink unlinkread failed\n");
    15a8:	83 ec 08             	sub    $0x8,%esp
    15ab:	68 e5 4a 00 00       	push   $0x4ae5
    15b0:	6a 01                	push   $0x1
    15b2:	e8 54 2a 00 00       	call   400b <printf>
    15b7:	83 c4 10             	add    $0x10,%esp
    exit();
    15ba:	e8 dd 28 00 00       	call   3e9c <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    15bf:	83 ec 08             	sub    $0x8,%esp
    15c2:	68 02 02 00 00       	push   $0x202
    15c7:	68 a2 4a 00 00       	push   $0x4aa2
    15cc:	e8 0b 29 00 00       	call   3edc <open>
    15d1:	83 c4 10             	add    $0x10,%esp
    15d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    15d7:	83 ec 04             	sub    $0x4,%esp
    15da:	6a 03                	push   $0x3
    15dc:	68 ff 4a 00 00       	push   $0x4aff
    15e1:	ff 75 f0             	pushl  -0x10(%ebp)
    15e4:	e8 d3 28 00 00       	call   3ebc <write>
    15e9:	83 c4 10             	add    $0x10,%esp
  close(fd1);
    15ec:	83 ec 0c             	sub    $0xc,%esp
    15ef:	ff 75 f0             	pushl  -0x10(%ebp)
    15f2:	e8 cd 28 00 00       	call   3ec4 <close>
    15f7:	83 c4 10             	add    $0x10,%esp

  if(read(fd, buf, sizeof(buf)) != 5){
    15fa:	83 ec 04             	sub    $0x4,%esp
    15fd:	68 00 20 00 00       	push   $0x2000
    1602:	68 a0 83 00 00       	push   $0x83a0
    1607:	ff 75 f4             	pushl  -0xc(%ebp)
    160a:	e8 a5 28 00 00       	call   3eb4 <read>
    160f:	83 c4 10             	add    $0x10,%esp
    1612:	83 f8 05             	cmp    $0x5,%eax
    1615:	74 17                	je     162e <unlinkread+0x13c>
    printf(1, "unlinkread read failed");
    1617:	83 ec 08             	sub    $0x8,%esp
    161a:	68 03 4b 00 00       	push   $0x4b03
    161f:	6a 01                	push   $0x1
    1621:	e8 e5 29 00 00       	call   400b <printf>
    1626:	83 c4 10             	add    $0x10,%esp
    exit();
    1629:	e8 6e 28 00 00       	call   3e9c <exit>
  }
  if(buf[0] != 'h'){
    162e:	a0 a0 83 00 00       	mov    0x83a0,%al
    1633:	3c 68                	cmp    $0x68,%al
    1635:	74 17                	je     164e <unlinkread+0x15c>
    printf(1, "unlinkread wrong data\n");
    1637:	83 ec 08             	sub    $0x8,%esp
    163a:	68 1a 4b 00 00       	push   $0x4b1a
    163f:	6a 01                	push   $0x1
    1641:	e8 c5 29 00 00       	call   400b <printf>
    1646:	83 c4 10             	add    $0x10,%esp
    exit();
    1649:	e8 4e 28 00 00       	call   3e9c <exit>
  }
  if(write(fd, buf, 10) != 10){
    164e:	83 ec 04             	sub    $0x4,%esp
    1651:	6a 0a                	push   $0xa
    1653:	68 a0 83 00 00       	push   $0x83a0
    1658:	ff 75 f4             	pushl  -0xc(%ebp)
    165b:	e8 5c 28 00 00       	call   3ebc <write>
    1660:	83 c4 10             	add    $0x10,%esp
    1663:	83 f8 0a             	cmp    $0xa,%eax
    1666:	74 17                	je     167f <unlinkread+0x18d>
    printf(1, "unlinkread write failed\n");
    1668:	83 ec 08             	sub    $0x8,%esp
    166b:	68 31 4b 00 00       	push   $0x4b31
    1670:	6a 01                	push   $0x1
    1672:	e8 94 29 00 00       	call   400b <printf>
    1677:	83 c4 10             	add    $0x10,%esp
    exit();
    167a:	e8 1d 28 00 00       	call   3e9c <exit>
  }
  close(fd);
    167f:	83 ec 0c             	sub    $0xc,%esp
    1682:	ff 75 f4             	pushl  -0xc(%ebp)
    1685:	e8 3a 28 00 00       	call   3ec4 <close>
    168a:	83 c4 10             	add    $0x10,%esp
  unlink("unlinkread");
    168d:	83 ec 0c             	sub    $0xc,%esp
    1690:	68 a2 4a 00 00       	push   $0x4aa2
    1695:	e8 52 28 00 00       	call   3eec <unlink>
    169a:	83 c4 10             	add    $0x10,%esp
  printf(1, "unlinkread ok\n");
    169d:	83 ec 08             	sub    $0x8,%esp
    16a0:	68 4a 4b 00 00       	push   $0x4b4a
    16a5:	6a 01                	push   $0x1
    16a7:	e8 5f 29 00 00       	call   400b <printf>
    16ac:	83 c4 10             	add    $0x10,%esp
}
    16af:	c9                   	leave  
    16b0:	c3                   	ret    

000016b1 <linktest>:

void
linktest(void)
{
    16b1:	55                   	push   %ebp
    16b2:	89 e5                	mov    %esp,%ebp
    16b4:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "linktest\n");
    16b7:	83 ec 08             	sub    $0x8,%esp
    16ba:	68 59 4b 00 00       	push   $0x4b59
    16bf:	6a 01                	push   $0x1
    16c1:	e8 45 29 00 00       	call   400b <printf>
    16c6:	83 c4 10             	add    $0x10,%esp

  unlink("lf1");
    16c9:	83 ec 0c             	sub    $0xc,%esp
    16cc:	68 63 4b 00 00       	push   $0x4b63
    16d1:	e8 16 28 00 00       	call   3eec <unlink>
    16d6:	83 c4 10             	add    $0x10,%esp
  unlink("lf2");
    16d9:	83 ec 0c             	sub    $0xc,%esp
    16dc:	68 67 4b 00 00       	push   $0x4b67
    16e1:	e8 06 28 00 00       	call   3eec <unlink>
    16e6:	83 c4 10             	add    $0x10,%esp

  fd = open("lf1", O_CREATE|O_RDWR);
    16e9:	83 ec 08             	sub    $0x8,%esp
    16ec:	68 02 02 00 00       	push   $0x202
    16f1:	68 63 4b 00 00       	push   $0x4b63
    16f6:	e8 e1 27 00 00       	call   3edc <open>
    16fb:	83 c4 10             	add    $0x10,%esp
    16fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1701:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1705:	79 17                	jns    171e <linktest+0x6d>
    printf(1, "create lf1 failed\n");
    1707:	83 ec 08             	sub    $0x8,%esp
    170a:	68 6b 4b 00 00       	push   $0x4b6b
    170f:	6a 01                	push   $0x1
    1711:	e8 f5 28 00 00       	call   400b <printf>
    1716:	83 c4 10             	add    $0x10,%esp
    exit();
    1719:	e8 7e 27 00 00       	call   3e9c <exit>
  }
  if(write(fd, "hello", 5) != 5){
    171e:	83 ec 04             	sub    $0x4,%esp
    1721:	6a 05                	push   $0x5
    1723:	68 c7 4a 00 00       	push   $0x4ac7
    1728:	ff 75 f4             	pushl  -0xc(%ebp)
    172b:	e8 8c 27 00 00       	call   3ebc <write>
    1730:	83 c4 10             	add    $0x10,%esp
    1733:	83 f8 05             	cmp    $0x5,%eax
    1736:	74 17                	je     174f <linktest+0x9e>
    printf(1, "write lf1 failed\n");
    1738:	83 ec 08             	sub    $0x8,%esp
    173b:	68 7e 4b 00 00       	push   $0x4b7e
    1740:	6a 01                	push   $0x1
    1742:	e8 c4 28 00 00       	call   400b <printf>
    1747:	83 c4 10             	add    $0x10,%esp
    exit();
    174a:	e8 4d 27 00 00       	call   3e9c <exit>
  }
  close(fd);
    174f:	83 ec 0c             	sub    $0xc,%esp
    1752:	ff 75 f4             	pushl  -0xc(%ebp)
    1755:	e8 6a 27 00 00       	call   3ec4 <close>
    175a:	83 c4 10             	add    $0x10,%esp

  if(link("lf1", "lf2") < 0){
    175d:	83 ec 08             	sub    $0x8,%esp
    1760:	68 67 4b 00 00       	push   $0x4b67
    1765:	68 63 4b 00 00       	push   $0x4b63
    176a:	e8 8d 27 00 00       	call   3efc <link>
    176f:	83 c4 10             	add    $0x10,%esp
    1772:	85 c0                	test   %eax,%eax
    1774:	79 17                	jns    178d <linktest+0xdc>
    printf(1, "link lf1 lf2 failed\n");
    1776:	83 ec 08             	sub    $0x8,%esp
    1779:	68 90 4b 00 00       	push   $0x4b90
    177e:	6a 01                	push   $0x1
    1780:	e8 86 28 00 00       	call   400b <printf>
    1785:	83 c4 10             	add    $0x10,%esp
    exit();
    1788:	e8 0f 27 00 00       	call   3e9c <exit>
  }
  unlink("lf1");
    178d:	83 ec 0c             	sub    $0xc,%esp
    1790:	68 63 4b 00 00       	push   $0x4b63
    1795:	e8 52 27 00 00       	call   3eec <unlink>
    179a:	83 c4 10             	add    $0x10,%esp

  if(open("lf1", 0) >= 0){
    179d:	83 ec 08             	sub    $0x8,%esp
    17a0:	6a 00                	push   $0x0
    17a2:	68 63 4b 00 00       	push   $0x4b63
    17a7:	e8 30 27 00 00       	call   3edc <open>
    17ac:	83 c4 10             	add    $0x10,%esp
    17af:	85 c0                	test   %eax,%eax
    17b1:	78 17                	js     17ca <linktest+0x119>
    printf(1, "unlinked lf1 but it is still there!\n");
    17b3:	83 ec 08             	sub    $0x8,%esp
    17b6:	68 a8 4b 00 00       	push   $0x4ba8
    17bb:	6a 01                	push   $0x1
    17bd:	e8 49 28 00 00       	call   400b <printf>
    17c2:	83 c4 10             	add    $0x10,%esp
    exit();
    17c5:	e8 d2 26 00 00       	call   3e9c <exit>
  }

  fd = open("lf2", 0);
    17ca:	83 ec 08             	sub    $0x8,%esp
    17cd:	6a 00                	push   $0x0
    17cf:	68 67 4b 00 00       	push   $0x4b67
    17d4:	e8 03 27 00 00       	call   3edc <open>
    17d9:	83 c4 10             	add    $0x10,%esp
    17dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    17df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17e3:	79 17                	jns    17fc <linktest+0x14b>
    printf(1, "open lf2 failed\n");
    17e5:	83 ec 08             	sub    $0x8,%esp
    17e8:	68 cd 4b 00 00       	push   $0x4bcd
    17ed:	6a 01                	push   $0x1
    17ef:	e8 17 28 00 00       	call   400b <printf>
    17f4:	83 c4 10             	add    $0x10,%esp
    exit();
    17f7:	e8 a0 26 00 00       	call   3e9c <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    17fc:	83 ec 04             	sub    $0x4,%esp
    17ff:	68 00 20 00 00       	push   $0x2000
    1804:	68 a0 83 00 00       	push   $0x83a0
    1809:	ff 75 f4             	pushl  -0xc(%ebp)
    180c:	e8 a3 26 00 00       	call   3eb4 <read>
    1811:	83 c4 10             	add    $0x10,%esp
    1814:	83 f8 05             	cmp    $0x5,%eax
    1817:	74 17                	je     1830 <linktest+0x17f>
    printf(1, "read lf2 failed\n");
    1819:	83 ec 08             	sub    $0x8,%esp
    181c:	68 de 4b 00 00       	push   $0x4bde
    1821:	6a 01                	push   $0x1
    1823:	e8 e3 27 00 00       	call   400b <printf>
    1828:	83 c4 10             	add    $0x10,%esp
    exit();
    182b:	e8 6c 26 00 00       	call   3e9c <exit>
  }
  close(fd);
    1830:	83 ec 0c             	sub    $0xc,%esp
    1833:	ff 75 f4             	pushl  -0xc(%ebp)
    1836:	e8 89 26 00 00       	call   3ec4 <close>
    183b:	83 c4 10             	add    $0x10,%esp

  if(link("lf2", "lf2") >= 0){
    183e:	83 ec 08             	sub    $0x8,%esp
    1841:	68 67 4b 00 00       	push   $0x4b67
    1846:	68 67 4b 00 00       	push   $0x4b67
    184b:	e8 ac 26 00 00       	call   3efc <link>
    1850:	83 c4 10             	add    $0x10,%esp
    1853:	85 c0                	test   %eax,%eax
    1855:	78 17                	js     186e <linktest+0x1bd>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1857:	83 ec 08             	sub    $0x8,%esp
    185a:	68 ef 4b 00 00       	push   $0x4bef
    185f:	6a 01                	push   $0x1
    1861:	e8 a5 27 00 00       	call   400b <printf>
    1866:	83 c4 10             	add    $0x10,%esp
    exit();
    1869:	e8 2e 26 00 00       	call   3e9c <exit>
  }

  unlink("lf2");
    186e:	83 ec 0c             	sub    $0xc,%esp
    1871:	68 67 4b 00 00       	push   $0x4b67
    1876:	e8 71 26 00 00       	call   3eec <unlink>
    187b:	83 c4 10             	add    $0x10,%esp
  if(link("lf2", "lf1") >= 0){
    187e:	83 ec 08             	sub    $0x8,%esp
    1881:	68 63 4b 00 00       	push   $0x4b63
    1886:	68 67 4b 00 00       	push   $0x4b67
    188b:	e8 6c 26 00 00       	call   3efc <link>
    1890:	83 c4 10             	add    $0x10,%esp
    1893:	85 c0                	test   %eax,%eax
    1895:	78 17                	js     18ae <linktest+0x1fd>
    printf(1, "link non-existant succeeded! oops\n");
    1897:	83 ec 08             	sub    $0x8,%esp
    189a:	68 10 4c 00 00       	push   $0x4c10
    189f:	6a 01                	push   $0x1
    18a1:	e8 65 27 00 00       	call   400b <printf>
    18a6:	83 c4 10             	add    $0x10,%esp
    exit();
    18a9:	e8 ee 25 00 00       	call   3e9c <exit>
  }

  if(link(".", "lf1") >= 0){
    18ae:	83 ec 08             	sub    $0x8,%esp
    18b1:	68 63 4b 00 00       	push   $0x4b63
    18b6:	68 33 4c 00 00       	push   $0x4c33
    18bb:	e8 3c 26 00 00       	call   3efc <link>
    18c0:	83 c4 10             	add    $0x10,%esp
    18c3:	85 c0                	test   %eax,%eax
    18c5:	78 17                	js     18de <linktest+0x22d>
    printf(1, "link . lf1 succeeded! oops\n");
    18c7:	83 ec 08             	sub    $0x8,%esp
    18ca:	68 35 4c 00 00       	push   $0x4c35
    18cf:	6a 01                	push   $0x1
    18d1:	e8 35 27 00 00       	call   400b <printf>
    18d6:	83 c4 10             	add    $0x10,%esp
    exit();
    18d9:	e8 be 25 00 00       	call   3e9c <exit>
  }

  printf(1, "linktest ok\n");
    18de:	83 ec 08             	sub    $0x8,%esp
    18e1:	68 51 4c 00 00       	push   $0x4c51
    18e6:	6a 01                	push   $0x1
    18e8:	e8 1e 27 00 00       	call   400b <printf>
    18ed:	83 c4 10             	add    $0x10,%esp
}
    18f0:	c9                   	leave  
    18f1:	c3                   	ret    

000018f2 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    18f2:	55                   	push   %ebp
    18f3:	89 e5                	mov    %esp,%ebp
    18f5:	83 ec 58             	sub    $0x58,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    18f8:	83 ec 08             	sub    $0x8,%esp
    18fb:	68 5e 4c 00 00       	push   $0x4c5e
    1900:	6a 01                	push   $0x1
    1902:	e8 04 27 00 00       	call   400b <printf>
    1907:	83 c4 10             	add    $0x10,%esp
  file[0] = 'C';
    190a:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    190e:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    1912:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1919:	e9 d5 00 00 00       	jmp    19f3 <concreate+0x101>
    file[1] = '0' + i;
    191e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1921:	83 c0 30             	add    $0x30,%eax
    1924:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    1927:	83 ec 0c             	sub    $0xc,%esp
    192a:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    192d:	50                   	push   %eax
    192e:	e8 b9 25 00 00       	call   3eec <unlink>
    1933:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    1936:	e8 59 25 00 00       	call   3e94 <fork>
    193b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid && (i % 3) == 1){
    193e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1942:	74 28                	je     196c <concreate+0x7a>
    1944:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1947:	b9 03 00 00 00       	mov    $0x3,%ecx
    194c:	99                   	cltd   
    194d:	f7 f9                	idiv   %ecx
    194f:	89 d0                	mov    %edx,%eax
    1951:	83 f8 01             	cmp    $0x1,%eax
    1954:	75 16                	jne    196c <concreate+0x7a>
      link("C0", file);
    1956:	83 ec 08             	sub    $0x8,%esp
    1959:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    195c:	50                   	push   %eax
    195d:	68 6e 4c 00 00       	push   $0x4c6e
    1962:	e8 95 25 00 00       	call   3efc <link>
    1967:	83 c4 10             	add    $0x10,%esp
    196a:	eb 74                	jmp    19e0 <concreate+0xee>
    } else if(pid == 0 && (i % 5) == 1){
    196c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1970:	75 28                	jne    199a <concreate+0xa8>
    1972:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1975:	b9 05 00 00 00       	mov    $0x5,%ecx
    197a:	99                   	cltd   
    197b:	f7 f9                	idiv   %ecx
    197d:	89 d0                	mov    %edx,%eax
    197f:	83 f8 01             	cmp    $0x1,%eax
    1982:	75 16                	jne    199a <concreate+0xa8>
      link("C0", file);
    1984:	83 ec 08             	sub    $0x8,%esp
    1987:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    198a:	50                   	push   %eax
    198b:	68 6e 4c 00 00       	push   $0x4c6e
    1990:	e8 67 25 00 00       	call   3efc <link>
    1995:	83 c4 10             	add    $0x10,%esp
    1998:	eb 46                	jmp    19e0 <concreate+0xee>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    199a:	83 ec 08             	sub    $0x8,%esp
    199d:	68 02 02 00 00       	push   $0x202
    19a2:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19a5:	50                   	push   %eax
    19a6:	e8 31 25 00 00       	call   3edc <open>
    19ab:	83 c4 10             	add    $0x10,%esp
    19ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(fd < 0){
    19b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    19b5:	79 1b                	jns    19d2 <concreate+0xe0>
        printf(1, "concreate create %s failed\n", file);
    19b7:	83 ec 04             	sub    $0x4,%esp
    19ba:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19bd:	50                   	push   %eax
    19be:	68 71 4c 00 00       	push   $0x4c71
    19c3:	6a 01                	push   $0x1
    19c5:	e8 41 26 00 00       	call   400b <printf>
    19ca:	83 c4 10             	add    $0x10,%esp
        exit();
    19cd:	e8 ca 24 00 00       	call   3e9c <exit>
      }
      close(fd);
    19d2:	83 ec 0c             	sub    $0xc,%esp
    19d5:	ff 75 e8             	pushl  -0x18(%ebp)
    19d8:	e8 e7 24 00 00       	call   3ec4 <close>
    19dd:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    19e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19e4:	75 05                	jne    19eb <concreate+0xf9>
      exit();
    19e6:	e8 b1 24 00 00       	call   3e9c <exit>
    else
      wait();
    19eb:	e8 b4 24 00 00       	call   3ea4 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    19f0:	ff 45 f4             	incl   -0xc(%ebp)
    19f3:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    19f7:	0f 8e 21 ff ff ff    	jle    191e <concreate+0x2c>
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    19fd:	83 ec 04             	sub    $0x4,%esp
    1a00:	6a 28                	push   $0x28
    1a02:	6a 00                	push   $0x0
    1a04:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1a07:	50                   	push   %eax
    1a08:	e8 0d 23 00 00       	call   3d1a <memset>
    1a0d:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    1a10:	83 ec 08             	sub    $0x8,%esp
    1a13:	6a 00                	push   $0x0
    1a15:	68 33 4c 00 00       	push   $0x4c33
    1a1a:	e8 bd 24 00 00       	call   3edc <open>
    1a1f:	83 c4 10             	add    $0x10,%esp
    1a22:	89 45 e8             	mov    %eax,-0x18(%ebp)
  n = 0;
    1a25:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1a2c:	e9 87 00 00 00       	jmp    1ab8 <concreate+0x1c6>
    if(de.inum == 0)
    1a31:	8b 45 ac             	mov    -0x54(%ebp),%eax
    1a34:	66 85 c0             	test   %ax,%ax
    1a37:	74 7e                	je     1ab7 <concreate+0x1c5>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1a39:	8a 45 ae             	mov    -0x52(%ebp),%al
    1a3c:	3c 43                	cmp    $0x43,%al
    1a3e:	75 78                	jne    1ab8 <concreate+0x1c6>
    1a40:	8a 45 b0             	mov    -0x50(%ebp),%al
    1a43:	84 c0                	test   %al,%al
    1a45:	75 71                	jne    1ab8 <concreate+0x1c6>
      i = de.name[1] - '0';
    1a47:	8a 45 af             	mov    -0x51(%ebp),%al
    1a4a:	0f be c0             	movsbl %al,%eax
    1a4d:	83 e8 30             	sub    $0x30,%eax
    1a50:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1a53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a57:	78 08                	js     1a61 <concreate+0x16f>
    1a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a5c:	83 f8 27             	cmp    $0x27,%eax
    1a5f:	76 1e                	jbe    1a7f <concreate+0x18d>
        printf(1, "concreate weird file %s\n", de.name);
    1a61:	83 ec 04             	sub    $0x4,%esp
    1a64:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1a67:	83 c0 02             	add    $0x2,%eax
    1a6a:	50                   	push   %eax
    1a6b:	68 8d 4c 00 00       	push   $0x4c8d
    1a70:	6a 01                	push   $0x1
    1a72:	e8 94 25 00 00       	call   400b <printf>
    1a77:	83 c4 10             	add    $0x10,%esp
        exit();
    1a7a:	e8 1d 24 00 00       	call   3e9c <exit>
      }
      if(fa[i]){
    1a7f:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1a82:	03 45 f4             	add    -0xc(%ebp),%eax
    1a85:	8a 00                	mov    (%eax),%al
    1a87:	84 c0                	test   %al,%al
    1a89:	74 1e                	je     1aa9 <concreate+0x1b7>
        printf(1, "concreate duplicate file %s\n", de.name);
    1a8b:	83 ec 04             	sub    $0x4,%esp
    1a8e:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1a91:	83 c0 02             	add    $0x2,%eax
    1a94:	50                   	push   %eax
    1a95:	68 a6 4c 00 00       	push   $0x4ca6
    1a9a:	6a 01                	push   $0x1
    1a9c:	e8 6a 25 00 00       	call   400b <printf>
    1aa1:	83 c4 10             	add    $0x10,%esp
        exit();
    1aa4:	e8 f3 23 00 00       	call   3e9c <exit>
      }
      fa[i] = 1;
    1aa9:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1aac:	03 45 f4             	add    -0xc(%ebp),%eax
    1aaf:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    1ab2:	ff 45 f0             	incl   -0x10(%ebp)
    1ab5:	eb 01                	jmp    1ab8 <concreate+0x1c6>
  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    if(de.inum == 0)
      continue;
    1ab7:	90                   	nop
  }

  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    1ab8:	83 ec 04             	sub    $0x4,%esp
    1abb:	6a 10                	push   $0x10
    1abd:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1ac0:	50                   	push   %eax
    1ac1:	ff 75 e8             	pushl  -0x18(%ebp)
    1ac4:	e8 eb 23 00 00       	call   3eb4 <read>
    1ac9:	83 c4 10             	add    $0x10,%esp
    1acc:	85 c0                	test   %eax,%eax
    1ace:	0f 8f 5d ff ff ff    	jg     1a31 <concreate+0x13f>
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    1ad4:	83 ec 0c             	sub    $0xc,%esp
    1ad7:	ff 75 e8             	pushl  -0x18(%ebp)
    1ada:	e8 e5 23 00 00       	call   3ec4 <close>
    1adf:	83 c4 10             	add    $0x10,%esp

  if(n != 40){
    1ae2:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    1ae6:	74 17                	je     1aff <concreate+0x20d>
    printf(1, "concreate not enough files in directory listing\n");
    1ae8:	83 ec 08             	sub    $0x8,%esp
    1aeb:	68 c4 4c 00 00       	push   $0x4cc4
    1af0:	6a 01                	push   $0x1
    1af2:	e8 14 25 00 00       	call   400b <printf>
    1af7:	83 c4 10             	add    $0x10,%esp
    exit();
    1afa:	e8 9d 23 00 00       	call   3e9c <exit>
  }

  for(i = 0; i < 40; i++){
    1aff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1b06:	e9 22 01 00 00       	jmp    1c2d <concreate+0x33b>
    file[1] = '0' + i;
    1b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b0e:	83 c0 30             	add    $0x30,%eax
    1b11:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1b14:	e8 7b 23 00 00       	call   3e94 <fork>
    1b19:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    1b1c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b20:	79 17                	jns    1b39 <concreate+0x247>
      printf(1, "fork failed\n");
    1b22:	83 ec 08             	sub    $0x8,%esp
    1b25:	68 55 44 00 00       	push   $0x4455
    1b2a:	6a 01                	push   $0x1
    1b2c:	e8 da 24 00 00       	call   400b <printf>
    1b31:	83 c4 10             	add    $0x10,%esp
      exit();
    1b34:	e8 63 23 00 00       	call   3e9c <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b3c:	b9 03 00 00 00       	mov    $0x3,%ecx
    1b41:	99                   	cltd   
    1b42:	f7 f9                	idiv   %ecx
    1b44:	89 d0                	mov    %edx,%eax
    1b46:	85 c0                	test   %eax,%eax
    1b48:	75 06                	jne    1b50 <concreate+0x25e>
    1b4a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b4e:	74 18                	je     1b68 <concreate+0x276>
       ((i % 3) == 1 && pid != 0)){
    1b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b53:	b9 03 00 00 00       	mov    $0x3,%ecx
    1b58:	99                   	cltd   
    1b59:	f7 f9                	idiv   %ecx
    1b5b:	89 d0                	mov    %edx,%eax
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1b5d:	83 f8 01             	cmp    $0x1,%eax
    1b60:	75 7c                	jne    1bde <concreate+0x2ec>
       ((i % 3) == 1 && pid != 0)){
    1b62:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b66:	74 76                	je     1bde <concreate+0x2ec>
      close(open(file, 0));
    1b68:	83 ec 08             	sub    $0x8,%esp
    1b6b:	6a 00                	push   $0x0
    1b6d:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1b70:	50                   	push   %eax
    1b71:	e8 66 23 00 00       	call   3edc <open>
    1b76:	83 c4 10             	add    $0x10,%esp
    1b79:	83 ec 0c             	sub    $0xc,%esp
    1b7c:	50                   	push   %eax
    1b7d:	e8 42 23 00 00       	call   3ec4 <close>
    1b82:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1b85:	83 ec 08             	sub    $0x8,%esp
    1b88:	6a 00                	push   $0x0
    1b8a:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1b8d:	50                   	push   %eax
    1b8e:	e8 49 23 00 00       	call   3edc <open>
    1b93:	83 c4 10             	add    $0x10,%esp
    1b96:	83 ec 0c             	sub    $0xc,%esp
    1b99:	50                   	push   %eax
    1b9a:	e8 25 23 00 00       	call   3ec4 <close>
    1b9f:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1ba2:	83 ec 08             	sub    $0x8,%esp
    1ba5:	6a 00                	push   $0x0
    1ba7:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1baa:	50                   	push   %eax
    1bab:	e8 2c 23 00 00       	call   3edc <open>
    1bb0:	83 c4 10             	add    $0x10,%esp
    1bb3:	83 ec 0c             	sub    $0xc,%esp
    1bb6:	50                   	push   %eax
    1bb7:	e8 08 23 00 00       	call   3ec4 <close>
    1bbc:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1bbf:	83 ec 08             	sub    $0x8,%esp
    1bc2:	6a 00                	push   $0x0
    1bc4:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1bc7:	50                   	push   %eax
    1bc8:	e8 0f 23 00 00       	call   3edc <open>
    1bcd:	83 c4 10             	add    $0x10,%esp
    1bd0:	83 ec 0c             	sub    $0xc,%esp
    1bd3:	50                   	push   %eax
    1bd4:	e8 eb 22 00 00       	call   3ec4 <close>
    1bd9:	83 c4 10             	add    $0x10,%esp
    1bdc:	eb 3c                	jmp    1c1a <concreate+0x328>
    } else {
      unlink(file);
    1bde:	83 ec 0c             	sub    $0xc,%esp
    1be1:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1be4:	50                   	push   %eax
    1be5:	e8 02 23 00 00       	call   3eec <unlink>
    1bea:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1bed:	83 ec 0c             	sub    $0xc,%esp
    1bf0:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1bf3:	50                   	push   %eax
    1bf4:	e8 f3 22 00 00       	call   3eec <unlink>
    1bf9:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1bfc:	83 ec 0c             	sub    $0xc,%esp
    1bff:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c02:	50                   	push   %eax
    1c03:	e8 e4 22 00 00       	call   3eec <unlink>
    1c08:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c0b:	83 ec 0c             	sub    $0xc,%esp
    1c0e:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c11:	50                   	push   %eax
    1c12:	e8 d5 22 00 00       	call   3eec <unlink>
    1c17:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1c1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c1e:	75 05                	jne    1c25 <concreate+0x333>
      exit();
    1c20:	e8 77 22 00 00       	call   3e9c <exit>
    else
      wait();
    1c25:	e8 7a 22 00 00       	call   3ea4 <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1c2a:	ff 45 f4             	incl   -0xc(%ebp)
    1c2d:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1c31:	0f 8e d4 fe ff ff    	jle    1b0b <concreate+0x219>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    1c37:	83 ec 08             	sub    $0x8,%esp
    1c3a:	68 f5 4c 00 00       	push   $0x4cf5
    1c3f:	6a 01                	push   $0x1
    1c41:	e8 c5 23 00 00       	call   400b <printf>
    1c46:	83 c4 10             	add    $0x10,%esp
}
    1c49:	c9                   	leave  
    1c4a:	c3                   	ret    

00001c4b <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1c4b:	55                   	push   %ebp
    1c4c:	89 e5                	mov    %esp,%ebp
    1c4e:	83 ec 18             	sub    $0x18,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1c51:	83 ec 08             	sub    $0x8,%esp
    1c54:	68 03 4d 00 00       	push   $0x4d03
    1c59:	6a 01                	push   $0x1
    1c5b:	e8 ab 23 00 00       	call   400b <printf>
    1c60:	83 c4 10             	add    $0x10,%esp

  unlink("x");
    1c63:	83 ec 0c             	sub    $0xc,%esp
    1c66:	68 8b 48 00 00       	push   $0x488b
    1c6b:	e8 7c 22 00 00       	call   3eec <unlink>
    1c70:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    1c73:	e8 1c 22 00 00       	call   3e94 <fork>
    1c78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1c7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c7f:	79 17                	jns    1c98 <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1c81:	83 ec 08             	sub    $0x8,%esp
    1c84:	68 55 44 00 00       	push   $0x4455
    1c89:	6a 01                	push   $0x1
    1c8b:	e8 7b 23 00 00       	call   400b <printf>
    1c90:	83 c4 10             	add    $0x10,%esp
    exit();
    1c93:	e8 04 22 00 00       	call   3e9c <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1c98:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c9c:	74 07                	je     1ca5 <linkunlink+0x5a>
    1c9e:	b8 01 00 00 00       	mov    $0x1,%eax
    1ca3:	eb 05                	jmp    1caa <linkunlink+0x5f>
    1ca5:	b8 61 00 00 00       	mov    $0x61,%eax
    1caa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1cad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1cb4:	e9 ad 00 00 00       	jmp    1d66 <linkunlink+0x11b>
    x = x * 1103515245 + 12345;
    1cb9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1cbc:	89 c8                	mov    %ecx,%eax
    1cbe:	89 c2                	mov    %eax,%edx
    1cc0:	c1 e2 09             	shl    $0x9,%edx
    1cc3:	29 ca                	sub    %ecx,%edx
    1cc5:	c1 e2 02             	shl    $0x2,%edx
    1cc8:	01 ca                	add    %ecx,%edx
    1cca:	89 d0                	mov    %edx,%eax
    1ccc:	c1 e0 09             	shl    $0x9,%eax
    1ccf:	29 d0                	sub    %edx,%eax
    1cd1:	d1 e0                	shl    %eax
    1cd3:	01 c8                	add    %ecx,%eax
    1cd5:	89 c2                	mov    %eax,%edx
    1cd7:	c1 e2 05             	shl    $0x5,%edx
    1cda:	01 d0                	add    %edx,%eax
    1cdc:	c1 e0 02             	shl    $0x2,%eax
    1cdf:	29 c8                	sub    %ecx,%eax
    1ce1:	c1 e0 02             	shl    $0x2,%eax
    1ce4:	01 c8                	add    %ecx,%eax
    1ce6:	05 39 30 00 00       	add    $0x3039,%eax
    1ceb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1cf1:	b9 03 00 00 00       	mov    $0x3,%ecx
    1cf6:	ba 00 00 00 00       	mov    $0x0,%edx
    1cfb:	f7 f1                	div    %ecx
    1cfd:	89 d0                	mov    %edx,%eax
    1cff:	85 c0                	test   %eax,%eax
    1d01:	75 23                	jne    1d26 <linkunlink+0xdb>
      close(open("x", O_RDWR | O_CREATE));
    1d03:	83 ec 08             	sub    $0x8,%esp
    1d06:	68 02 02 00 00       	push   $0x202
    1d0b:	68 8b 48 00 00       	push   $0x488b
    1d10:	e8 c7 21 00 00       	call   3edc <open>
    1d15:	83 c4 10             	add    $0x10,%esp
    1d18:	83 ec 0c             	sub    $0xc,%esp
    1d1b:	50                   	push   %eax
    1d1c:	e8 a3 21 00 00       	call   3ec4 <close>
    1d21:	83 c4 10             	add    $0x10,%esp
    1d24:	eb 3d                	jmp    1d63 <linkunlink+0x118>
    } else if((x % 3) == 1){
    1d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d29:	b9 03 00 00 00       	mov    $0x3,%ecx
    1d2e:	ba 00 00 00 00       	mov    $0x0,%edx
    1d33:	f7 f1                	div    %ecx
    1d35:	89 d0                	mov    %edx,%eax
    1d37:	83 f8 01             	cmp    $0x1,%eax
    1d3a:	75 17                	jne    1d53 <linkunlink+0x108>
      link("cat", "x");
    1d3c:	83 ec 08             	sub    $0x8,%esp
    1d3f:	68 8b 48 00 00       	push   $0x488b
    1d44:	68 14 4d 00 00       	push   $0x4d14
    1d49:	e8 ae 21 00 00       	call   3efc <link>
    1d4e:	83 c4 10             	add    $0x10,%esp
    1d51:	eb 10                	jmp    1d63 <linkunlink+0x118>
    } else {
      unlink("x");
    1d53:	83 ec 0c             	sub    $0xc,%esp
    1d56:	68 8b 48 00 00       	push   $0x488b
    1d5b:	e8 8c 21 00 00       	call   3eec <unlink>
    1d60:	83 c4 10             	add    $0x10,%esp
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    1d63:	ff 45 f4             	incl   -0xc(%ebp)
    1d66:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1d6a:	0f 8e 49 ff ff ff    	jle    1cb9 <linkunlink+0x6e>
    } else {
      unlink("x");
    }
  }

  if(pid)
    1d70:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d74:	74 19                	je     1d8f <linkunlink+0x144>
    wait();
    1d76:	e8 29 21 00 00       	call   3ea4 <wait>
  else 
    exit();

  printf(1, "linkunlink ok\n");
    1d7b:	83 ec 08             	sub    $0x8,%esp
    1d7e:	68 18 4d 00 00       	push   $0x4d18
    1d83:	6a 01                	push   $0x1
    1d85:	e8 81 22 00 00       	call   400b <printf>
    1d8a:	83 c4 10             	add    $0x10,%esp
}
    1d8d:	c9                   	leave  
    1d8e:	c3                   	ret    
  }

  if(pid)
    wait();
  else 
    exit();
    1d8f:	e8 08 21 00 00       	call   3e9c <exit>

00001d94 <bigdir>:
}

// directory that uses indirect blocks
void
bigdir(void)
{
    1d94:	55                   	push   %ebp
    1d95:	89 e5                	mov    %esp,%ebp
    1d97:	83 ec 28             	sub    $0x28,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1d9a:	83 ec 08             	sub    $0x8,%esp
    1d9d:	68 27 4d 00 00       	push   $0x4d27
    1da2:	6a 01                	push   $0x1
    1da4:	e8 62 22 00 00       	call   400b <printf>
    1da9:	83 c4 10             	add    $0x10,%esp
  unlink("bd");
    1dac:	83 ec 0c             	sub    $0xc,%esp
    1daf:	68 34 4d 00 00       	push   $0x4d34
    1db4:	e8 33 21 00 00       	call   3eec <unlink>
    1db9:	83 c4 10             	add    $0x10,%esp

  fd = open("bd", O_CREATE);
    1dbc:	83 ec 08             	sub    $0x8,%esp
    1dbf:	68 00 02 00 00       	push   $0x200
    1dc4:	68 34 4d 00 00       	push   $0x4d34
    1dc9:	e8 0e 21 00 00       	call   3edc <open>
    1dce:	83 c4 10             	add    $0x10,%esp
    1dd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1dd4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1dd8:	79 17                	jns    1df1 <bigdir+0x5d>
    printf(1, "bigdir create failed\n");
    1dda:	83 ec 08             	sub    $0x8,%esp
    1ddd:	68 37 4d 00 00       	push   $0x4d37
    1de2:	6a 01                	push   $0x1
    1de4:	e8 22 22 00 00       	call   400b <printf>
    1de9:	83 c4 10             	add    $0x10,%esp
    exit();
    1dec:	e8 ab 20 00 00       	call   3e9c <exit>
  }
  close(fd);
    1df1:	83 ec 0c             	sub    $0xc,%esp
    1df4:	ff 75 f0             	pushl  -0x10(%ebp)
    1df7:	e8 c8 20 00 00       	call   3ec4 <close>
    1dfc:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 500; i++){
    1dff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1e06:	eb 64                	jmp    1e6c <bigdir+0xd8>
    name[0] = 'x';
    1e08:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e0f:	85 c0                	test   %eax,%eax
    1e11:	79 03                	jns    1e16 <bigdir+0x82>
    1e13:	83 c0 3f             	add    $0x3f,%eax
    1e16:	c1 f8 06             	sar    $0x6,%eax
    1e19:	83 c0 30             	add    $0x30,%eax
    1e1c:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e22:	25 3f 00 00 80       	and    $0x8000003f,%eax
    1e27:	85 c0                	test   %eax,%eax
    1e29:	79 05                	jns    1e30 <bigdir+0x9c>
    1e2b:	48                   	dec    %eax
    1e2c:	83 c8 c0             	or     $0xffffffc0,%eax
    1e2f:	40                   	inc    %eax
    1e30:	83 c0 30             	add    $0x30,%eax
    1e33:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1e36:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1e3a:	83 ec 08             	sub    $0x8,%esp
    1e3d:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1e40:	50                   	push   %eax
    1e41:	68 34 4d 00 00       	push   $0x4d34
    1e46:	e8 b1 20 00 00       	call   3efc <link>
    1e4b:	83 c4 10             	add    $0x10,%esp
    1e4e:	85 c0                	test   %eax,%eax
    1e50:	74 17                	je     1e69 <bigdir+0xd5>
      printf(1, "bigdir link failed\n");
    1e52:	83 ec 08             	sub    $0x8,%esp
    1e55:	68 4d 4d 00 00       	push   $0x4d4d
    1e5a:	6a 01                	push   $0x1
    1e5c:	e8 aa 21 00 00       	call   400b <printf>
    1e61:	83 c4 10             	add    $0x10,%esp
      exit();
    1e64:	e8 33 20 00 00       	call   3e9c <exit>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    1e69:	ff 45 f4             	incl   -0xc(%ebp)
    1e6c:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1e73:	7e 93                	jle    1e08 <bigdir+0x74>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1e75:	83 ec 0c             	sub    $0xc,%esp
    1e78:	68 34 4d 00 00       	push   $0x4d34
    1e7d:	e8 6a 20 00 00       	call   3eec <unlink>
    1e82:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 500; i++){
    1e85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1e8c:	eb 5f                	jmp    1eed <bigdir+0x159>
    name[0] = 'x';
    1e8e:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e95:	85 c0                	test   %eax,%eax
    1e97:	79 03                	jns    1e9c <bigdir+0x108>
    1e99:	83 c0 3f             	add    $0x3f,%eax
    1e9c:	c1 f8 06             	sar    $0x6,%eax
    1e9f:	83 c0 30             	add    $0x30,%eax
    1ea2:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ea8:	25 3f 00 00 80       	and    $0x8000003f,%eax
    1ead:	85 c0                	test   %eax,%eax
    1eaf:	79 05                	jns    1eb6 <bigdir+0x122>
    1eb1:	48                   	dec    %eax
    1eb2:	83 c8 c0             	or     $0xffffffc0,%eax
    1eb5:	40                   	inc    %eax
    1eb6:	83 c0 30             	add    $0x30,%eax
    1eb9:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1ebc:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1ec0:	83 ec 0c             	sub    $0xc,%esp
    1ec3:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1ec6:	50                   	push   %eax
    1ec7:	e8 20 20 00 00       	call   3eec <unlink>
    1ecc:	83 c4 10             	add    $0x10,%esp
    1ecf:	85 c0                	test   %eax,%eax
    1ed1:	74 17                	je     1eea <bigdir+0x156>
      printf(1, "bigdir unlink failed");
    1ed3:	83 ec 08             	sub    $0x8,%esp
    1ed6:	68 61 4d 00 00       	push   $0x4d61
    1edb:	6a 01                	push   $0x1
    1edd:	e8 29 21 00 00       	call   400b <printf>
    1ee2:	83 c4 10             	add    $0x10,%esp
      exit();
    1ee5:	e8 b2 1f 00 00       	call   3e9c <exit>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    1eea:	ff 45 f4             	incl   -0xc(%ebp)
    1eed:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1ef4:	7e 98                	jle    1e8e <bigdir+0xfa>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1ef6:	83 ec 08             	sub    $0x8,%esp
    1ef9:	68 76 4d 00 00       	push   $0x4d76
    1efe:	6a 01                	push   $0x1
    1f00:	e8 06 21 00 00       	call   400b <printf>
    1f05:	83 c4 10             	add    $0x10,%esp
}
    1f08:	c9                   	leave  
    1f09:	c3                   	ret    

00001f0a <subdir>:

void
subdir(void)
{
    1f0a:	55                   	push   %ebp
    1f0b:	89 e5                	mov    %esp,%ebp
    1f0d:	83 ec 18             	sub    $0x18,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1f10:	83 ec 08             	sub    $0x8,%esp
    1f13:	68 81 4d 00 00       	push   $0x4d81
    1f18:	6a 01                	push   $0x1
    1f1a:	e8 ec 20 00 00       	call   400b <printf>
    1f1f:	83 c4 10             	add    $0x10,%esp

  unlink("ff");
    1f22:	83 ec 0c             	sub    $0xc,%esp
    1f25:	68 8e 4d 00 00       	push   $0x4d8e
    1f2a:	e8 bd 1f 00 00       	call   3eec <unlink>
    1f2f:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dd") != 0){
    1f32:	83 ec 0c             	sub    $0xc,%esp
    1f35:	68 91 4d 00 00       	push   $0x4d91
    1f3a:	e8 c5 1f 00 00       	call   3f04 <mkdir>
    1f3f:	83 c4 10             	add    $0x10,%esp
    1f42:	85 c0                	test   %eax,%eax
    1f44:	74 17                	je     1f5d <subdir+0x53>
    printf(1, "subdir mkdir dd failed\n");
    1f46:	83 ec 08             	sub    $0x8,%esp
    1f49:	68 94 4d 00 00       	push   $0x4d94
    1f4e:	6a 01                	push   $0x1
    1f50:	e8 b6 20 00 00       	call   400b <printf>
    1f55:	83 c4 10             	add    $0x10,%esp
    exit();
    1f58:	e8 3f 1f 00 00       	call   3e9c <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1f5d:	83 ec 08             	sub    $0x8,%esp
    1f60:	68 02 02 00 00       	push   $0x202
    1f65:	68 ac 4d 00 00       	push   $0x4dac
    1f6a:	e8 6d 1f 00 00       	call   3edc <open>
    1f6f:	83 c4 10             	add    $0x10,%esp
    1f72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1f75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1f79:	79 17                	jns    1f92 <subdir+0x88>
    printf(1, "create dd/ff failed\n");
    1f7b:	83 ec 08             	sub    $0x8,%esp
    1f7e:	68 b2 4d 00 00       	push   $0x4db2
    1f83:	6a 01                	push   $0x1
    1f85:	e8 81 20 00 00       	call   400b <printf>
    1f8a:	83 c4 10             	add    $0x10,%esp
    exit();
    1f8d:	e8 0a 1f 00 00       	call   3e9c <exit>
  }
  write(fd, "ff", 2);
    1f92:	83 ec 04             	sub    $0x4,%esp
    1f95:	6a 02                	push   $0x2
    1f97:	68 8e 4d 00 00       	push   $0x4d8e
    1f9c:	ff 75 f4             	pushl  -0xc(%ebp)
    1f9f:	e8 18 1f 00 00       	call   3ebc <write>
    1fa4:	83 c4 10             	add    $0x10,%esp
  close(fd);
    1fa7:	83 ec 0c             	sub    $0xc,%esp
    1faa:	ff 75 f4             	pushl  -0xc(%ebp)
    1fad:	e8 12 1f 00 00       	call   3ec4 <close>
    1fb2:	83 c4 10             	add    $0x10,%esp
  
  if(unlink("dd") >= 0){
    1fb5:	83 ec 0c             	sub    $0xc,%esp
    1fb8:	68 91 4d 00 00       	push   $0x4d91
    1fbd:	e8 2a 1f 00 00       	call   3eec <unlink>
    1fc2:	83 c4 10             	add    $0x10,%esp
    1fc5:	85 c0                	test   %eax,%eax
    1fc7:	78 17                	js     1fe0 <subdir+0xd6>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    1fc9:	83 ec 08             	sub    $0x8,%esp
    1fcc:	68 c8 4d 00 00       	push   $0x4dc8
    1fd1:	6a 01                	push   $0x1
    1fd3:	e8 33 20 00 00       	call   400b <printf>
    1fd8:	83 c4 10             	add    $0x10,%esp
    exit();
    1fdb:	e8 bc 1e 00 00       	call   3e9c <exit>
  }

  if(mkdir("/dd/dd") != 0){
    1fe0:	83 ec 0c             	sub    $0xc,%esp
    1fe3:	68 ee 4d 00 00       	push   $0x4dee
    1fe8:	e8 17 1f 00 00       	call   3f04 <mkdir>
    1fed:	83 c4 10             	add    $0x10,%esp
    1ff0:	85 c0                	test   %eax,%eax
    1ff2:	74 17                	je     200b <subdir+0x101>
    printf(1, "subdir mkdir dd/dd failed\n");
    1ff4:	83 ec 08             	sub    $0x8,%esp
    1ff7:	68 f5 4d 00 00       	push   $0x4df5
    1ffc:	6a 01                	push   $0x1
    1ffe:	e8 08 20 00 00       	call   400b <printf>
    2003:	83 c4 10             	add    $0x10,%esp
    exit();
    2006:	e8 91 1e 00 00       	call   3e9c <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    200b:	83 ec 08             	sub    $0x8,%esp
    200e:	68 02 02 00 00       	push   $0x202
    2013:	68 10 4e 00 00       	push   $0x4e10
    2018:	e8 bf 1e 00 00       	call   3edc <open>
    201d:	83 c4 10             	add    $0x10,%esp
    2020:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2023:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2027:	79 17                	jns    2040 <subdir+0x136>
    printf(1, "create dd/dd/ff failed\n");
    2029:	83 ec 08             	sub    $0x8,%esp
    202c:	68 19 4e 00 00       	push   $0x4e19
    2031:	6a 01                	push   $0x1
    2033:	e8 d3 1f 00 00       	call   400b <printf>
    2038:	83 c4 10             	add    $0x10,%esp
    exit();
    203b:	e8 5c 1e 00 00       	call   3e9c <exit>
  }
  write(fd, "FF", 2);
    2040:	83 ec 04             	sub    $0x4,%esp
    2043:	6a 02                	push   $0x2
    2045:	68 31 4e 00 00       	push   $0x4e31
    204a:	ff 75 f4             	pushl  -0xc(%ebp)
    204d:	e8 6a 1e 00 00       	call   3ebc <write>
    2052:	83 c4 10             	add    $0x10,%esp
  close(fd);
    2055:	83 ec 0c             	sub    $0xc,%esp
    2058:	ff 75 f4             	pushl  -0xc(%ebp)
    205b:	e8 64 1e 00 00       	call   3ec4 <close>
    2060:	83 c4 10             	add    $0x10,%esp

  fd = open("dd/dd/../ff", 0);
    2063:	83 ec 08             	sub    $0x8,%esp
    2066:	6a 00                	push   $0x0
    2068:	68 34 4e 00 00       	push   $0x4e34
    206d:	e8 6a 1e 00 00       	call   3edc <open>
    2072:	83 c4 10             	add    $0x10,%esp
    2075:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2078:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    207c:	79 17                	jns    2095 <subdir+0x18b>
    printf(1, "open dd/dd/../ff failed\n");
    207e:	83 ec 08             	sub    $0x8,%esp
    2081:	68 40 4e 00 00       	push   $0x4e40
    2086:	6a 01                	push   $0x1
    2088:	e8 7e 1f 00 00       	call   400b <printf>
    208d:	83 c4 10             	add    $0x10,%esp
    exit();
    2090:	e8 07 1e 00 00       	call   3e9c <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    2095:	83 ec 04             	sub    $0x4,%esp
    2098:	68 00 20 00 00       	push   $0x2000
    209d:	68 a0 83 00 00       	push   $0x83a0
    20a2:	ff 75 f4             	pushl  -0xc(%ebp)
    20a5:	e8 0a 1e 00 00       	call   3eb4 <read>
    20aa:	83 c4 10             	add    $0x10,%esp
    20ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    20b0:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    20b4:	75 09                	jne    20bf <subdir+0x1b5>
    20b6:	a0 a0 83 00 00       	mov    0x83a0,%al
    20bb:	3c 66                	cmp    $0x66,%al
    20bd:	74 17                	je     20d6 <subdir+0x1cc>
    printf(1, "dd/dd/../ff wrong content\n");
    20bf:	83 ec 08             	sub    $0x8,%esp
    20c2:	68 59 4e 00 00       	push   $0x4e59
    20c7:	6a 01                	push   $0x1
    20c9:	e8 3d 1f 00 00       	call   400b <printf>
    20ce:	83 c4 10             	add    $0x10,%esp
    exit();
    20d1:	e8 c6 1d 00 00       	call   3e9c <exit>
  }
  close(fd);
    20d6:	83 ec 0c             	sub    $0xc,%esp
    20d9:	ff 75 f4             	pushl  -0xc(%ebp)
    20dc:	e8 e3 1d 00 00       	call   3ec4 <close>
    20e1:	83 c4 10             	add    $0x10,%esp

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    20e4:	83 ec 08             	sub    $0x8,%esp
    20e7:	68 74 4e 00 00       	push   $0x4e74
    20ec:	68 10 4e 00 00       	push   $0x4e10
    20f1:	e8 06 1e 00 00       	call   3efc <link>
    20f6:	83 c4 10             	add    $0x10,%esp
    20f9:	85 c0                	test   %eax,%eax
    20fb:	74 17                	je     2114 <subdir+0x20a>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    20fd:	83 ec 08             	sub    $0x8,%esp
    2100:	68 80 4e 00 00       	push   $0x4e80
    2105:	6a 01                	push   $0x1
    2107:	e8 ff 1e 00 00       	call   400b <printf>
    210c:	83 c4 10             	add    $0x10,%esp
    exit();
    210f:	e8 88 1d 00 00       	call   3e9c <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    2114:	83 ec 0c             	sub    $0xc,%esp
    2117:	68 10 4e 00 00       	push   $0x4e10
    211c:	e8 cb 1d 00 00       	call   3eec <unlink>
    2121:	83 c4 10             	add    $0x10,%esp
    2124:	85 c0                	test   %eax,%eax
    2126:	74 17                	je     213f <subdir+0x235>
    printf(1, "unlink dd/dd/ff failed\n");
    2128:	83 ec 08             	sub    $0x8,%esp
    212b:	68 a1 4e 00 00       	push   $0x4ea1
    2130:	6a 01                	push   $0x1
    2132:	e8 d4 1e 00 00       	call   400b <printf>
    2137:	83 c4 10             	add    $0x10,%esp
    exit();
    213a:	e8 5d 1d 00 00       	call   3e9c <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    213f:	83 ec 08             	sub    $0x8,%esp
    2142:	6a 00                	push   $0x0
    2144:	68 10 4e 00 00       	push   $0x4e10
    2149:	e8 8e 1d 00 00       	call   3edc <open>
    214e:	83 c4 10             	add    $0x10,%esp
    2151:	85 c0                	test   %eax,%eax
    2153:	78 17                	js     216c <subdir+0x262>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    2155:	83 ec 08             	sub    $0x8,%esp
    2158:	68 bc 4e 00 00       	push   $0x4ebc
    215d:	6a 01                	push   $0x1
    215f:	e8 a7 1e 00 00       	call   400b <printf>
    2164:	83 c4 10             	add    $0x10,%esp
    exit();
    2167:	e8 30 1d 00 00       	call   3e9c <exit>
  }

  if(chdir("dd") != 0){
    216c:	83 ec 0c             	sub    $0xc,%esp
    216f:	68 91 4d 00 00       	push   $0x4d91
    2174:	e8 93 1d 00 00       	call   3f0c <chdir>
    2179:	83 c4 10             	add    $0x10,%esp
    217c:	85 c0                	test   %eax,%eax
    217e:	74 17                	je     2197 <subdir+0x28d>
    printf(1, "chdir dd failed\n");
    2180:	83 ec 08             	sub    $0x8,%esp
    2183:	68 e0 4e 00 00       	push   $0x4ee0
    2188:	6a 01                	push   $0x1
    218a:	e8 7c 1e 00 00       	call   400b <printf>
    218f:	83 c4 10             	add    $0x10,%esp
    exit();
    2192:	e8 05 1d 00 00       	call   3e9c <exit>
  }
  if(chdir("dd/../../dd") != 0){
    2197:	83 ec 0c             	sub    $0xc,%esp
    219a:	68 f1 4e 00 00       	push   $0x4ef1
    219f:	e8 68 1d 00 00       	call   3f0c <chdir>
    21a4:	83 c4 10             	add    $0x10,%esp
    21a7:	85 c0                	test   %eax,%eax
    21a9:	74 17                	je     21c2 <subdir+0x2b8>
    printf(1, "chdir dd/../../dd failed\n");
    21ab:	83 ec 08             	sub    $0x8,%esp
    21ae:	68 fd 4e 00 00       	push   $0x4efd
    21b3:	6a 01                	push   $0x1
    21b5:	e8 51 1e 00 00       	call   400b <printf>
    21ba:	83 c4 10             	add    $0x10,%esp
    exit();
    21bd:	e8 da 1c 00 00       	call   3e9c <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    21c2:	83 ec 0c             	sub    $0xc,%esp
    21c5:	68 17 4f 00 00       	push   $0x4f17
    21ca:	e8 3d 1d 00 00       	call   3f0c <chdir>
    21cf:	83 c4 10             	add    $0x10,%esp
    21d2:	85 c0                	test   %eax,%eax
    21d4:	74 17                	je     21ed <subdir+0x2e3>
    printf(1, "chdir dd/../../dd failed\n");
    21d6:	83 ec 08             	sub    $0x8,%esp
    21d9:	68 fd 4e 00 00       	push   $0x4efd
    21de:	6a 01                	push   $0x1
    21e0:	e8 26 1e 00 00       	call   400b <printf>
    21e5:	83 c4 10             	add    $0x10,%esp
    exit();
    21e8:	e8 af 1c 00 00       	call   3e9c <exit>
  }
  if(chdir("./..") != 0){
    21ed:	83 ec 0c             	sub    $0xc,%esp
    21f0:	68 26 4f 00 00       	push   $0x4f26
    21f5:	e8 12 1d 00 00       	call   3f0c <chdir>
    21fa:	83 c4 10             	add    $0x10,%esp
    21fd:	85 c0                	test   %eax,%eax
    21ff:	74 17                	je     2218 <subdir+0x30e>
    printf(1, "chdir ./.. failed\n");
    2201:	83 ec 08             	sub    $0x8,%esp
    2204:	68 2b 4f 00 00       	push   $0x4f2b
    2209:	6a 01                	push   $0x1
    220b:	e8 fb 1d 00 00       	call   400b <printf>
    2210:	83 c4 10             	add    $0x10,%esp
    exit();
    2213:	e8 84 1c 00 00       	call   3e9c <exit>
  }

  fd = open("dd/dd/ffff", 0);
    2218:	83 ec 08             	sub    $0x8,%esp
    221b:	6a 00                	push   $0x0
    221d:	68 74 4e 00 00       	push   $0x4e74
    2222:	e8 b5 1c 00 00       	call   3edc <open>
    2227:	83 c4 10             	add    $0x10,%esp
    222a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    222d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2231:	79 17                	jns    224a <subdir+0x340>
    printf(1, "open dd/dd/ffff failed\n");
    2233:	83 ec 08             	sub    $0x8,%esp
    2236:	68 3e 4f 00 00       	push   $0x4f3e
    223b:	6a 01                	push   $0x1
    223d:	e8 c9 1d 00 00       	call   400b <printf>
    2242:	83 c4 10             	add    $0x10,%esp
    exit();
    2245:	e8 52 1c 00 00       	call   3e9c <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    224a:	83 ec 04             	sub    $0x4,%esp
    224d:	68 00 20 00 00       	push   $0x2000
    2252:	68 a0 83 00 00       	push   $0x83a0
    2257:	ff 75 f4             	pushl  -0xc(%ebp)
    225a:	e8 55 1c 00 00       	call   3eb4 <read>
    225f:	83 c4 10             	add    $0x10,%esp
    2262:	83 f8 02             	cmp    $0x2,%eax
    2265:	74 17                	je     227e <subdir+0x374>
    printf(1, "read dd/dd/ffff wrong len\n");
    2267:	83 ec 08             	sub    $0x8,%esp
    226a:	68 56 4f 00 00       	push   $0x4f56
    226f:	6a 01                	push   $0x1
    2271:	e8 95 1d 00 00       	call   400b <printf>
    2276:	83 c4 10             	add    $0x10,%esp
    exit();
    2279:	e8 1e 1c 00 00       	call   3e9c <exit>
  }
  close(fd);
    227e:	83 ec 0c             	sub    $0xc,%esp
    2281:	ff 75 f4             	pushl  -0xc(%ebp)
    2284:	e8 3b 1c 00 00       	call   3ec4 <close>
    2289:	83 c4 10             	add    $0x10,%esp

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    228c:	83 ec 08             	sub    $0x8,%esp
    228f:	6a 00                	push   $0x0
    2291:	68 10 4e 00 00       	push   $0x4e10
    2296:	e8 41 1c 00 00       	call   3edc <open>
    229b:	83 c4 10             	add    $0x10,%esp
    229e:	85 c0                	test   %eax,%eax
    22a0:	78 17                	js     22b9 <subdir+0x3af>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    22a2:	83 ec 08             	sub    $0x8,%esp
    22a5:	68 74 4f 00 00       	push   $0x4f74
    22aa:	6a 01                	push   $0x1
    22ac:	e8 5a 1d 00 00       	call   400b <printf>
    22b1:	83 c4 10             	add    $0x10,%esp
    exit();
    22b4:	e8 e3 1b 00 00       	call   3e9c <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    22b9:	83 ec 08             	sub    $0x8,%esp
    22bc:	68 02 02 00 00       	push   $0x202
    22c1:	68 99 4f 00 00       	push   $0x4f99
    22c6:	e8 11 1c 00 00       	call   3edc <open>
    22cb:	83 c4 10             	add    $0x10,%esp
    22ce:	85 c0                	test   %eax,%eax
    22d0:	78 17                	js     22e9 <subdir+0x3df>
    printf(1, "create dd/ff/ff succeeded!\n");
    22d2:	83 ec 08             	sub    $0x8,%esp
    22d5:	68 a2 4f 00 00       	push   $0x4fa2
    22da:	6a 01                	push   $0x1
    22dc:	e8 2a 1d 00 00       	call   400b <printf>
    22e1:	83 c4 10             	add    $0x10,%esp
    exit();
    22e4:	e8 b3 1b 00 00       	call   3e9c <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    22e9:	83 ec 08             	sub    $0x8,%esp
    22ec:	68 02 02 00 00       	push   $0x202
    22f1:	68 be 4f 00 00       	push   $0x4fbe
    22f6:	e8 e1 1b 00 00       	call   3edc <open>
    22fb:	83 c4 10             	add    $0x10,%esp
    22fe:	85 c0                	test   %eax,%eax
    2300:	78 17                	js     2319 <subdir+0x40f>
    printf(1, "create dd/xx/ff succeeded!\n");
    2302:	83 ec 08             	sub    $0x8,%esp
    2305:	68 c7 4f 00 00       	push   $0x4fc7
    230a:	6a 01                	push   $0x1
    230c:	e8 fa 1c 00 00       	call   400b <printf>
    2311:	83 c4 10             	add    $0x10,%esp
    exit();
    2314:	e8 83 1b 00 00       	call   3e9c <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    2319:	83 ec 08             	sub    $0x8,%esp
    231c:	68 00 02 00 00       	push   $0x200
    2321:	68 91 4d 00 00       	push   $0x4d91
    2326:	e8 b1 1b 00 00       	call   3edc <open>
    232b:	83 c4 10             	add    $0x10,%esp
    232e:	85 c0                	test   %eax,%eax
    2330:	78 17                	js     2349 <subdir+0x43f>
    printf(1, "create dd succeeded!\n");
    2332:	83 ec 08             	sub    $0x8,%esp
    2335:	68 e3 4f 00 00       	push   $0x4fe3
    233a:	6a 01                	push   $0x1
    233c:	e8 ca 1c 00 00       	call   400b <printf>
    2341:	83 c4 10             	add    $0x10,%esp
    exit();
    2344:	e8 53 1b 00 00       	call   3e9c <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    2349:	83 ec 08             	sub    $0x8,%esp
    234c:	6a 02                	push   $0x2
    234e:	68 91 4d 00 00       	push   $0x4d91
    2353:	e8 84 1b 00 00       	call   3edc <open>
    2358:	83 c4 10             	add    $0x10,%esp
    235b:	85 c0                	test   %eax,%eax
    235d:	78 17                	js     2376 <subdir+0x46c>
    printf(1, "open dd rdwr succeeded!\n");
    235f:	83 ec 08             	sub    $0x8,%esp
    2362:	68 f9 4f 00 00       	push   $0x4ff9
    2367:	6a 01                	push   $0x1
    2369:	e8 9d 1c 00 00       	call   400b <printf>
    236e:	83 c4 10             	add    $0x10,%esp
    exit();
    2371:	e8 26 1b 00 00       	call   3e9c <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    2376:	83 ec 08             	sub    $0x8,%esp
    2379:	6a 01                	push   $0x1
    237b:	68 91 4d 00 00       	push   $0x4d91
    2380:	e8 57 1b 00 00       	call   3edc <open>
    2385:	83 c4 10             	add    $0x10,%esp
    2388:	85 c0                	test   %eax,%eax
    238a:	78 17                	js     23a3 <subdir+0x499>
    printf(1, "open dd wronly succeeded!\n");
    238c:	83 ec 08             	sub    $0x8,%esp
    238f:	68 12 50 00 00       	push   $0x5012
    2394:	6a 01                	push   $0x1
    2396:	e8 70 1c 00 00       	call   400b <printf>
    239b:	83 c4 10             	add    $0x10,%esp
    exit();
    239e:	e8 f9 1a 00 00       	call   3e9c <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    23a3:	83 ec 08             	sub    $0x8,%esp
    23a6:	68 2d 50 00 00       	push   $0x502d
    23ab:	68 99 4f 00 00       	push   $0x4f99
    23b0:	e8 47 1b 00 00       	call   3efc <link>
    23b5:	83 c4 10             	add    $0x10,%esp
    23b8:	85 c0                	test   %eax,%eax
    23ba:	75 17                	jne    23d3 <subdir+0x4c9>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    23bc:	83 ec 08             	sub    $0x8,%esp
    23bf:	68 38 50 00 00       	push   $0x5038
    23c4:	6a 01                	push   $0x1
    23c6:	e8 40 1c 00 00       	call   400b <printf>
    23cb:	83 c4 10             	add    $0x10,%esp
    exit();
    23ce:	e8 c9 1a 00 00       	call   3e9c <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    23d3:	83 ec 08             	sub    $0x8,%esp
    23d6:	68 2d 50 00 00       	push   $0x502d
    23db:	68 be 4f 00 00       	push   $0x4fbe
    23e0:	e8 17 1b 00 00       	call   3efc <link>
    23e5:	83 c4 10             	add    $0x10,%esp
    23e8:	85 c0                	test   %eax,%eax
    23ea:	75 17                	jne    2403 <subdir+0x4f9>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    23ec:	83 ec 08             	sub    $0x8,%esp
    23ef:	68 5c 50 00 00       	push   $0x505c
    23f4:	6a 01                	push   $0x1
    23f6:	e8 10 1c 00 00       	call   400b <printf>
    23fb:	83 c4 10             	add    $0x10,%esp
    exit();
    23fe:	e8 99 1a 00 00       	call   3e9c <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2403:	83 ec 08             	sub    $0x8,%esp
    2406:	68 74 4e 00 00       	push   $0x4e74
    240b:	68 ac 4d 00 00       	push   $0x4dac
    2410:	e8 e7 1a 00 00       	call   3efc <link>
    2415:	83 c4 10             	add    $0x10,%esp
    2418:	85 c0                	test   %eax,%eax
    241a:	75 17                	jne    2433 <subdir+0x529>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    241c:	83 ec 08             	sub    $0x8,%esp
    241f:	68 80 50 00 00       	push   $0x5080
    2424:	6a 01                	push   $0x1
    2426:	e8 e0 1b 00 00       	call   400b <printf>
    242b:	83 c4 10             	add    $0x10,%esp
    exit();
    242e:	e8 69 1a 00 00       	call   3e9c <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    2433:	83 ec 0c             	sub    $0xc,%esp
    2436:	68 99 4f 00 00       	push   $0x4f99
    243b:	e8 c4 1a 00 00       	call   3f04 <mkdir>
    2440:	83 c4 10             	add    $0x10,%esp
    2443:	85 c0                	test   %eax,%eax
    2445:	75 17                	jne    245e <subdir+0x554>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    2447:	83 ec 08             	sub    $0x8,%esp
    244a:	68 a2 50 00 00       	push   $0x50a2
    244f:	6a 01                	push   $0x1
    2451:	e8 b5 1b 00 00       	call   400b <printf>
    2456:	83 c4 10             	add    $0x10,%esp
    exit();
    2459:	e8 3e 1a 00 00       	call   3e9c <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    245e:	83 ec 0c             	sub    $0xc,%esp
    2461:	68 be 4f 00 00       	push   $0x4fbe
    2466:	e8 99 1a 00 00       	call   3f04 <mkdir>
    246b:	83 c4 10             	add    $0x10,%esp
    246e:	85 c0                	test   %eax,%eax
    2470:	75 17                	jne    2489 <subdir+0x57f>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    2472:	83 ec 08             	sub    $0x8,%esp
    2475:	68 bd 50 00 00       	push   $0x50bd
    247a:	6a 01                	push   $0x1
    247c:	e8 8a 1b 00 00       	call   400b <printf>
    2481:	83 c4 10             	add    $0x10,%esp
    exit();
    2484:	e8 13 1a 00 00       	call   3e9c <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    2489:	83 ec 0c             	sub    $0xc,%esp
    248c:	68 74 4e 00 00       	push   $0x4e74
    2491:	e8 6e 1a 00 00       	call   3f04 <mkdir>
    2496:	83 c4 10             	add    $0x10,%esp
    2499:	85 c0                	test   %eax,%eax
    249b:	75 17                	jne    24b4 <subdir+0x5aa>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    249d:	83 ec 08             	sub    $0x8,%esp
    24a0:	68 d8 50 00 00       	push   $0x50d8
    24a5:	6a 01                	push   $0x1
    24a7:	e8 5f 1b 00 00       	call   400b <printf>
    24ac:	83 c4 10             	add    $0x10,%esp
    exit();
    24af:	e8 e8 19 00 00       	call   3e9c <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    24b4:	83 ec 0c             	sub    $0xc,%esp
    24b7:	68 be 4f 00 00       	push   $0x4fbe
    24bc:	e8 2b 1a 00 00       	call   3eec <unlink>
    24c1:	83 c4 10             	add    $0x10,%esp
    24c4:	85 c0                	test   %eax,%eax
    24c6:	75 17                	jne    24df <subdir+0x5d5>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    24c8:	83 ec 08             	sub    $0x8,%esp
    24cb:	68 f5 50 00 00       	push   $0x50f5
    24d0:	6a 01                	push   $0x1
    24d2:	e8 34 1b 00 00       	call   400b <printf>
    24d7:	83 c4 10             	add    $0x10,%esp
    exit();
    24da:	e8 bd 19 00 00       	call   3e9c <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    24df:	83 ec 0c             	sub    $0xc,%esp
    24e2:	68 99 4f 00 00       	push   $0x4f99
    24e7:	e8 00 1a 00 00       	call   3eec <unlink>
    24ec:	83 c4 10             	add    $0x10,%esp
    24ef:	85 c0                	test   %eax,%eax
    24f1:	75 17                	jne    250a <subdir+0x600>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    24f3:	83 ec 08             	sub    $0x8,%esp
    24f6:	68 11 51 00 00       	push   $0x5111
    24fb:	6a 01                	push   $0x1
    24fd:	e8 09 1b 00 00       	call   400b <printf>
    2502:	83 c4 10             	add    $0x10,%esp
    exit();
    2505:	e8 92 19 00 00       	call   3e9c <exit>
  }
  if(chdir("dd/ff") == 0){
    250a:	83 ec 0c             	sub    $0xc,%esp
    250d:	68 ac 4d 00 00       	push   $0x4dac
    2512:	e8 f5 19 00 00       	call   3f0c <chdir>
    2517:	83 c4 10             	add    $0x10,%esp
    251a:	85 c0                	test   %eax,%eax
    251c:	75 17                	jne    2535 <subdir+0x62b>
    printf(1, "chdir dd/ff succeeded!\n");
    251e:	83 ec 08             	sub    $0x8,%esp
    2521:	68 2d 51 00 00       	push   $0x512d
    2526:	6a 01                	push   $0x1
    2528:	e8 de 1a 00 00       	call   400b <printf>
    252d:	83 c4 10             	add    $0x10,%esp
    exit();
    2530:	e8 67 19 00 00       	call   3e9c <exit>
  }
  if(chdir("dd/xx") == 0){
    2535:	83 ec 0c             	sub    $0xc,%esp
    2538:	68 45 51 00 00       	push   $0x5145
    253d:	e8 ca 19 00 00       	call   3f0c <chdir>
    2542:	83 c4 10             	add    $0x10,%esp
    2545:	85 c0                	test   %eax,%eax
    2547:	75 17                	jne    2560 <subdir+0x656>
    printf(1, "chdir dd/xx succeeded!\n");
    2549:	83 ec 08             	sub    $0x8,%esp
    254c:	68 4b 51 00 00       	push   $0x514b
    2551:	6a 01                	push   $0x1
    2553:	e8 b3 1a 00 00       	call   400b <printf>
    2558:	83 c4 10             	add    $0x10,%esp
    exit();
    255b:	e8 3c 19 00 00       	call   3e9c <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    2560:	83 ec 0c             	sub    $0xc,%esp
    2563:	68 74 4e 00 00       	push   $0x4e74
    2568:	e8 7f 19 00 00       	call   3eec <unlink>
    256d:	83 c4 10             	add    $0x10,%esp
    2570:	85 c0                	test   %eax,%eax
    2572:	74 17                	je     258b <subdir+0x681>
    printf(1, "unlink dd/dd/ff failed\n");
    2574:	83 ec 08             	sub    $0x8,%esp
    2577:	68 a1 4e 00 00       	push   $0x4ea1
    257c:	6a 01                	push   $0x1
    257e:	e8 88 1a 00 00       	call   400b <printf>
    2583:	83 c4 10             	add    $0x10,%esp
    exit();
    2586:	e8 11 19 00 00       	call   3e9c <exit>
  }
  if(unlink("dd/ff") != 0){
    258b:	83 ec 0c             	sub    $0xc,%esp
    258e:	68 ac 4d 00 00       	push   $0x4dac
    2593:	e8 54 19 00 00       	call   3eec <unlink>
    2598:	83 c4 10             	add    $0x10,%esp
    259b:	85 c0                	test   %eax,%eax
    259d:	74 17                	je     25b6 <subdir+0x6ac>
    printf(1, "unlink dd/ff failed\n");
    259f:	83 ec 08             	sub    $0x8,%esp
    25a2:	68 63 51 00 00       	push   $0x5163
    25a7:	6a 01                	push   $0x1
    25a9:	e8 5d 1a 00 00       	call   400b <printf>
    25ae:	83 c4 10             	add    $0x10,%esp
    exit();
    25b1:	e8 e6 18 00 00       	call   3e9c <exit>
  }
  if(unlink("dd") == 0){
    25b6:	83 ec 0c             	sub    $0xc,%esp
    25b9:	68 91 4d 00 00       	push   $0x4d91
    25be:	e8 29 19 00 00       	call   3eec <unlink>
    25c3:	83 c4 10             	add    $0x10,%esp
    25c6:	85 c0                	test   %eax,%eax
    25c8:	75 17                	jne    25e1 <subdir+0x6d7>
    printf(1, "unlink non-empty dd succeeded!\n");
    25ca:	83 ec 08             	sub    $0x8,%esp
    25cd:	68 78 51 00 00       	push   $0x5178
    25d2:	6a 01                	push   $0x1
    25d4:	e8 32 1a 00 00       	call   400b <printf>
    25d9:	83 c4 10             	add    $0x10,%esp
    exit();
    25dc:	e8 bb 18 00 00       	call   3e9c <exit>
  }
  if(unlink("dd/dd") < 0){
    25e1:	83 ec 0c             	sub    $0xc,%esp
    25e4:	68 98 51 00 00       	push   $0x5198
    25e9:	e8 fe 18 00 00       	call   3eec <unlink>
    25ee:	83 c4 10             	add    $0x10,%esp
    25f1:	85 c0                	test   %eax,%eax
    25f3:	79 17                	jns    260c <subdir+0x702>
    printf(1, "unlink dd/dd failed\n");
    25f5:	83 ec 08             	sub    $0x8,%esp
    25f8:	68 9e 51 00 00       	push   $0x519e
    25fd:	6a 01                	push   $0x1
    25ff:	e8 07 1a 00 00       	call   400b <printf>
    2604:	83 c4 10             	add    $0x10,%esp
    exit();
    2607:	e8 90 18 00 00       	call   3e9c <exit>
  }
  if(unlink("dd") < 0){
    260c:	83 ec 0c             	sub    $0xc,%esp
    260f:	68 91 4d 00 00       	push   $0x4d91
    2614:	e8 d3 18 00 00       	call   3eec <unlink>
    2619:	83 c4 10             	add    $0x10,%esp
    261c:	85 c0                	test   %eax,%eax
    261e:	79 17                	jns    2637 <subdir+0x72d>
    printf(1, "unlink dd failed\n");
    2620:	83 ec 08             	sub    $0x8,%esp
    2623:	68 b3 51 00 00       	push   $0x51b3
    2628:	6a 01                	push   $0x1
    262a:	e8 dc 19 00 00       	call   400b <printf>
    262f:	83 c4 10             	add    $0x10,%esp
    exit();
    2632:	e8 65 18 00 00       	call   3e9c <exit>
  }

  printf(1, "subdir ok\n");
    2637:	83 ec 08             	sub    $0x8,%esp
    263a:	68 c5 51 00 00       	push   $0x51c5
    263f:	6a 01                	push   $0x1
    2641:	e8 c5 19 00 00       	call   400b <printf>
    2646:	83 c4 10             	add    $0x10,%esp
}
    2649:	c9                   	leave  
    264a:	c3                   	ret    

0000264b <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    264b:	55                   	push   %ebp
    264c:	89 e5                	mov    %esp,%ebp
    264e:	83 ec 18             	sub    $0x18,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    2651:	83 ec 08             	sub    $0x8,%esp
    2654:	68 d0 51 00 00       	push   $0x51d0
    2659:	6a 01                	push   $0x1
    265b:	e8 ab 19 00 00       	call   400b <printf>
    2660:	83 c4 10             	add    $0x10,%esp

  unlink("bigwrite");
    2663:	83 ec 0c             	sub    $0xc,%esp
    2666:	68 df 51 00 00       	push   $0x51df
    266b:	e8 7c 18 00 00       	call   3eec <unlink>
    2670:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    2673:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    267a:	e9 a7 00 00 00       	jmp    2726 <bigwrite+0xdb>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    267f:	83 ec 08             	sub    $0x8,%esp
    2682:	68 02 02 00 00       	push   $0x202
    2687:	68 df 51 00 00       	push   $0x51df
    268c:	e8 4b 18 00 00       	call   3edc <open>
    2691:	83 c4 10             	add    $0x10,%esp
    2694:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    2697:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    269b:	79 17                	jns    26b4 <bigwrite+0x69>
      printf(1, "cannot create bigwrite\n");
    269d:	83 ec 08             	sub    $0x8,%esp
    26a0:	68 e8 51 00 00       	push   $0x51e8
    26a5:	6a 01                	push   $0x1
    26a7:	e8 5f 19 00 00       	call   400b <printf>
    26ac:	83 c4 10             	add    $0x10,%esp
      exit();
    26af:	e8 e8 17 00 00       	call   3e9c <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    26b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    26bb:	eb 3e                	jmp    26fb <bigwrite+0xb0>
      int cc = write(fd, buf, sz);
    26bd:	83 ec 04             	sub    $0x4,%esp
    26c0:	ff 75 f4             	pushl  -0xc(%ebp)
    26c3:	68 a0 83 00 00       	push   $0x83a0
    26c8:	ff 75 ec             	pushl  -0x14(%ebp)
    26cb:	e8 ec 17 00 00       	call   3ebc <write>
    26d0:	83 c4 10             	add    $0x10,%esp
    26d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    26d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    26d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    26dc:	74 1a                	je     26f8 <bigwrite+0xad>
        printf(1, "write(%d) ret %d\n", sz, cc);
    26de:	ff 75 e8             	pushl  -0x18(%ebp)
    26e1:	ff 75 f4             	pushl  -0xc(%ebp)
    26e4:	68 00 52 00 00       	push   $0x5200
    26e9:	6a 01                	push   $0x1
    26eb:	e8 1b 19 00 00       	call   400b <printf>
    26f0:	83 c4 10             	add    $0x10,%esp
        exit();
    26f3:	e8 a4 17 00 00       	call   3e9c <exit>
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
    26f8:	ff 45 f0             	incl   -0x10(%ebp)
    26fb:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    26ff:	7e bc                	jle    26bd <bigwrite+0x72>
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    2701:	83 ec 0c             	sub    $0xc,%esp
    2704:	ff 75 ec             	pushl  -0x14(%ebp)
    2707:	e8 b8 17 00 00       	call   3ec4 <close>
    270c:	83 c4 10             	add    $0x10,%esp
    unlink("bigwrite");
    270f:	83 ec 0c             	sub    $0xc,%esp
    2712:	68 df 51 00 00       	push   $0x51df
    2717:	e8 d0 17 00 00       	call   3eec <unlink>
    271c:	83 c4 10             	add    $0x10,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    271f:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    2726:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    272d:	0f 8e 4c ff ff ff    	jle    267f <bigwrite+0x34>
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
    2733:	83 ec 08             	sub    $0x8,%esp
    2736:	68 12 52 00 00       	push   $0x5212
    273b:	6a 01                	push   $0x1
    273d:	e8 c9 18 00 00       	call   400b <printf>
    2742:	83 c4 10             	add    $0x10,%esp
}
    2745:	c9                   	leave  
    2746:	c3                   	ret    

00002747 <bigfile>:

void
bigfile(void)
{
    2747:	55                   	push   %ebp
    2748:	89 e5                	mov    %esp,%ebp
    274a:	83 ec 18             	sub    $0x18,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    274d:	83 ec 08             	sub    $0x8,%esp
    2750:	68 1f 52 00 00       	push   $0x521f
    2755:	6a 01                	push   $0x1
    2757:	e8 af 18 00 00       	call   400b <printf>
    275c:	83 c4 10             	add    $0x10,%esp

  unlink("bigfile");
    275f:	83 ec 0c             	sub    $0xc,%esp
    2762:	68 2d 52 00 00       	push   $0x522d
    2767:	e8 80 17 00 00       	call   3eec <unlink>
    276c:	83 c4 10             	add    $0x10,%esp
  fd = open("bigfile", O_CREATE | O_RDWR);
    276f:	83 ec 08             	sub    $0x8,%esp
    2772:	68 02 02 00 00       	push   $0x202
    2777:	68 2d 52 00 00       	push   $0x522d
    277c:	e8 5b 17 00 00       	call   3edc <open>
    2781:	83 c4 10             	add    $0x10,%esp
    2784:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    2787:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    278b:	79 17                	jns    27a4 <bigfile+0x5d>
    printf(1, "cannot create bigfile");
    278d:	83 ec 08             	sub    $0x8,%esp
    2790:	68 35 52 00 00       	push   $0x5235
    2795:	6a 01                	push   $0x1
    2797:	e8 6f 18 00 00       	call   400b <printf>
    279c:	83 c4 10             	add    $0x10,%esp
    exit();
    279f:	e8 f8 16 00 00       	call   3e9c <exit>
  }
  for(i = 0; i < 20; i++){
    27a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    27ab:	eb 51                	jmp    27fe <bigfile+0xb7>
    memset(buf, i, 600);
    27ad:	83 ec 04             	sub    $0x4,%esp
    27b0:	68 58 02 00 00       	push   $0x258
    27b5:	ff 75 f4             	pushl  -0xc(%ebp)
    27b8:	68 a0 83 00 00       	push   $0x83a0
    27bd:	e8 58 15 00 00       	call   3d1a <memset>
    27c2:	83 c4 10             	add    $0x10,%esp
    if(write(fd, buf, 600) != 600){
    27c5:	83 ec 04             	sub    $0x4,%esp
    27c8:	68 58 02 00 00       	push   $0x258
    27cd:	68 a0 83 00 00       	push   $0x83a0
    27d2:	ff 75 ec             	pushl  -0x14(%ebp)
    27d5:	e8 e2 16 00 00       	call   3ebc <write>
    27da:	83 c4 10             	add    $0x10,%esp
    27dd:	3d 58 02 00 00       	cmp    $0x258,%eax
    27e2:	74 17                	je     27fb <bigfile+0xb4>
      printf(1, "write bigfile failed\n");
    27e4:	83 ec 08             	sub    $0x8,%esp
    27e7:	68 4b 52 00 00       	push   $0x524b
    27ec:	6a 01                	push   $0x1
    27ee:	e8 18 18 00 00       	call   400b <printf>
    27f3:	83 c4 10             	add    $0x10,%esp
      exit();
    27f6:	e8 a1 16 00 00       	call   3e9c <exit>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    27fb:	ff 45 f4             	incl   -0xc(%ebp)
    27fe:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    2802:	7e a9                	jle    27ad <bigfile+0x66>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    2804:	83 ec 0c             	sub    $0xc,%esp
    2807:	ff 75 ec             	pushl  -0x14(%ebp)
    280a:	e8 b5 16 00 00       	call   3ec4 <close>
    280f:	83 c4 10             	add    $0x10,%esp

  fd = open("bigfile", 0);
    2812:	83 ec 08             	sub    $0x8,%esp
    2815:	6a 00                	push   $0x0
    2817:	68 2d 52 00 00       	push   $0x522d
    281c:	e8 bb 16 00 00       	call   3edc <open>
    2821:	83 c4 10             	add    $0x10,%esp
    2824:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    2827:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    282b:	79 17                	jns    2844 <bigfile+0xfd>
    printf(1, "cannot open bigfile\n");
    282d:	83 ec 08             	sub    $0x8,%esp
    2830:	68 61 52 00 00       	push   $0x5261
    2835:	6a 01                	push   $0x1
    2837:	e8 cf 17 00 00       	call   400b <printf>
    283c:	83 c4 10             	add    $0x10,%esp
    exit();
    283f:	e8 58 16 00 00       	call   3e9c <exit>
  }
  total = 0;
    2844:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    284b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    2852:	83 ec 04             	sub    $0x4,%esp
    2855:	68 2c 01 00 00       	push   $0x12c
    285a:	68 a0 83 00 00       	push   $0x83a0
    285f:	ff 75 ec             	pushl  -0x14(%ebp)
    2862:	e8 4d 16 00 00       	call   3eb4 <read>
    2867:	83 c4 10             	add    $0x10,%esp
    286a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    286d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2871:	79 17                	jns    288a <bigfile+0x143>
      printf(1, "read bigfile failed\n");
    2873:	83 ec 08             	sub    $0x8,%esp
    2876:	68 76 52 00 00       	push   $0x5276
    287b:	6a 01                	push   $0x1
    287d:	e8 89 17 00 00       	call   400b <printf>
    2882:	83 c4 10             	add    $0x10,%esp
      exit();
    2885:	e8 12 16 00 00       	call   3e9c <exit>
    }
    if(cc == 0)
    288a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    288e:	75 1c                	jne    28ac <bigfile+0x165>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
    2890:	83 ec 0c             	sub    $0xc,%esp
    2893:	ff 75 ec             	pushl  -0x14(%ebp)
    2896:	e8 29 16 00 00       	call   3ec4 <close>
    289b:	83 c4 10             	add    $0x10,%esp
  if(total != 20*600){
    289e:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    28a5:	75 7c                	jne    2923 <bigfile+0x1dc>
    28a7:	e9 8e 00 00 00       	jmp    293a <bigfile+0x1f3>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    if(cc != 300){
    28ac:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    28b3:	74 17                	je     28cc <bigfile+0x185>
      printf(1, "short read bigfile\n");
    28b5:	83 ec 08             	sub    $0x8,%esp
    28b8:	68 8b 52 00 00       	push   $0x528b
    28bd:	6a 01                	push   $0x1
    28bf:	e8 47 17 00 00       	call   400b <printf>
    28c4:	83 c4 10             	add    $0x10,%esp
      exit();
    28c7:	e8 d0 15 00 00       	call   3e9c <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    28cc:	a0 a0 83 00 00       	mov    0x83a0,%al
    28d1:	0f be d0             	movsbl %al,%edx
    28d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    28d7:	89 c1                	mov    %eax,%ecx
    28d9:	c1 e9 1f             	shr    $0x1f,%ecx
    28dc:	8d 04 01             	lea    (%ecx,%eax,1),%eax
    28df:	d1 f8                	sar    %eax
    28e1:	39 c2                	cmp    %eax,%edx
    28e3:	75 19                	jne    28fe <bigfile+0x1b7>
    28e5:	a0 cb 84 00 00       	mov    0x84cb,%al
    28ea:	0f be d0             	movsbl %al,%edx
    28ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    28f0:	89 c1                	mov    %eax,%ecx
    28f2:	c1 e9 1f             	shr    $0x1f,%ecx
    28f5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
    28f8:	d1 f8                	sar    %eax
    28fa:	39 c2                	cmp    %eax,%edx
    28fc:	74 17                	je     2915 <bigfile+0x1ce>
      printf(1, "read bigfile wrong data\n");
    28fe:	83 ec 08             	sub    $0x8,%esp
    2901:	68 9f 52 00 00       	push   $0x529f
    2906:	6a 01                	push   $0x1
    2908:	e8 fe 16 00 00       	call   400b <printf>
    290d:	83 c4 10             	add    $0x10,%esp
      exit();
    2910:	e8 87 15 00 00       	call   3e9c <exit>
    }
    total += cc;
    2915:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2918:	01 45 f0             	add    %eax,-0x10(%ebp)
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    291b:	ff 45 f4             	incl   -0xc(%ebp)
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
    291e:	e9 2f ff ff ff       	jmp    2852 <bigfile+0x10b>
  close(fd);
  if(total != 20*600){
    printf(1, "read bigfile wrong total\n");
    2923:	83 ec 08             	sub    $0x8,%esp
    2926:	68 b8 52 00 00       	push   $0x52b8
    292b:	6a 01                	push   $0x1
    292d:	e8 d9 16 00 00       	call   400b <printf>
    2932:	83 c4 10             	add    $0x10,%esp
    exit();
    2935:	e8 62 15 00 00       	call   3e9c <exit>
  }
  unlink("bigfile");
    293a:	83 ec 0c             	sub    $0xc,%esp
    293d:	68 2d 52 00 00       	push   $0x522d
    2942:	e8 a5 15 00 00       	call   3eec <unlink>
    2947:	83 c4 10             	add    $0x10,%esp

  printf(1, "bigfile test ok\n");
    294a:	83 ec 08             	sub    $0x8,%esp
    294d:	68 d2 52 00 00       	push   $0x52d2
    2952:	6a 01                	push   $0x1
    2954:	e8 b2 16 00 00       	call   400b <printf>
    2959:	83 c4 10             	add    $0x10,%esp
}
    295c:	c9                   	leave  
    295d:	c3                   	ret    

0000295e <fourteen>:

void
fourteen(void)
{
    295e:	55                   	push   %ebp
    295f:	89 e5                	mov    %esp,%ebp
    2961:	83 ec 18             	sub    $0x18,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    2964:	83 ec 08             	sub    $0x8,%esp
    2967:	68 e3 52 00 00       	push   $0x52e3
    296c:	6a 01                	push   $0x1
    296e:	e8 98 16 00 00       	call   400b <printf>
    2973:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234") != 0){
    2976:	83 ec 0c             	sub    $0xc,%esp
    2979:	68 f2 52 00 00       	push   $0x52f2
    297e:	e8 81 15 00 00       	call   3f04 <mkdir>
    2983:	83 c4 10             	add    $0x10,%esp
    2986:	85 c0                	test   %eax,%eax
    2988:	74 17                	je     29a1 <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    298a:	83 ec 08             	sub    $0x8,%esp
    298d:	68 01 53 00 00       	push   $0x5301
    2992:	6a 01                	push   $0x1
    2994:	e8 72 16 00 00       	call   400b <printf>
    2999:	83 c4 10             	add    $0x10,%esp
    exit();
    299c:	e8 fb 14 00 00       	call   3e9c <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    29a1:	83 ec 0c             	sub    $0xc,%esp
    29a4:	68 20 53 00 00       	push   $0x5320
    29a9:	e8 56 15 00 00       	call   3f04 <mkdir>
    29ae:	83 c4 10             	add    $0x10,%esp
    29b1:	85 c0                	test   %eax,%eax
    29b3:	74 17                	je     29cc <fourteen+0x6e>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    29b5:	83 ec 08             	sub    $0x8,%esp
    29b8:	68 40 53 00 00       	push   $0x5340
    29bd:	6a 01                	push   $0x1
    29bf:	e8 47 16 00 00       	call   400b <printf>
    29c4:	83 c4 10             	add    $0x10,%esp
    exit();
    29c7:	e8 d0 14 00 00       	call   3e9c <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    29cc:	83 ec 08             	sub    $0x8,%esp
    29cf:	68 00 02 00 00       	push   $0x200
    29d4:	68 70 53 00 00       	push   $0x5370
    29d9:	e8 fe 14 00 00       	call   3edc <open>
    29de:	83 c4 10             	add    $0x10,%esp
    29e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    29e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    29e8:	79 17                	jns    2a01 <fourteen+0xa3>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    29ea:	83 ec 08             	sub    $0x8,%esp
    29ed:	68 a0 53 00 00       	push   $0x53a0
    29f2:	6a 01                	push   $0x1
    29f4:	e8 12 16 00 00       	call   400b <printf>
    29f9:	83 c4 10             	add    $0x10,%esp
    exit();
    29fc:	e8 9b 14 00 00       	call   3e9c <exit>
  }
  close(fd);
    2a01:	83 ec 0c             	sub    $0xc,%esp
    2a04:	ff 75 f4             	pushl  -0xc(%ebp)
    2a07:	e8 b8 14 00 00       	call   3ec4 <close>
    2a0c:	83 c4 10             	add    $0x10,%esp
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2a0f:	83 ec 08             	sub    $0x8,%esp
    2a12:	6a 00                	push   $0x0
    2a14:	68 e0 53 00 00       	push   $0x53e0
    2a19:	e8 be 14 00 00       	call   3edc <open>
    2a1e:	83 c4 10             	add    $0x10,%esp
    2a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a28:	79 17                	jns    2a41 <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2a2a:	83 ec 08             	sub    $0x8,%esp
    2a2d:	68 10 54 00 00       	push   $0x5410
    2a32:	6a 01                	push   $0x1
    2a34:	e8 d2 15 00 00       	call   400b <printf>
    2a39:	83 c4 10             	add    $0x10,%esp
    exit();
    2a3c:	e8 5b 14 00 00       	call   3e9c <exit>
  }
  close(fd);
    2a41:	83 ec 0c             	sub    $0xc,%esp
    2a44:	ff 75 f4             	pushl  -0xc(%ebp)
    2a47:	e8 78 14 00 00       	call   3ec4 <close>
    2a4c:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234/12345678901234") == 0){
    2a4f:	83 ec 0c             	sub    $0xc,%esp
    2a52:	68 4a 54 00 00       	push   $0x544a
    2a57:	e8 a8 14 00 00       	call   3f04 <mkdir>
    2a5c:	83 c4 10             	add    $0x10,%esp
    2a5f:	85 c0                	test   %eax,%eax
    2a61:	75 17                	jne    2a7a <fourteen+0x11c>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2a63:	83 ec 08             	sub    $0x8,%esp
    2a66:	68 68 54 00 00       	push   $0x5468
    2a6b:	6a 01                	push   $0x1
    2a6d:	e8 99 15 00 00       	call   400b <printf>
    2a72:	83 c4 10             	add    $0x10,%esp
    exit();
    2a75:	e8 22 14 00 00       	call   3e9c <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2a7a:	83 ec 0c             	sub    $0xc,%esp
    2a7d:	68 98 54 00 00       	push   $0x5498
    2a82:	e8 7d 14 00 00       	call   3f04 <mkdir>
    2a87:	83 c4 10             	add    $0x10,%esp
    2a8a:	85 c0                	test   %eax,%eax
    2a8c:	75 17                	jne    2aa5 <fourteen+0x147>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2a8e:	83 ec 08             	sub    $0x8,%esp
    2a91:	68 b8 54 00 00       	push   $0x54b8
    2a96:	6a 01                	push   $0x1
    2a98:	e8 6e 15 00 00       	call   400b <printf>
    2a9d:	83 c4 10             	add    $0x10,%esp
    exit();
    2aa0:	e8 f7 13 00 00       	call   3e9c <exit>
  }

  printf(1, "fourteen ok\n");
    2aa5:	83 ec 08             	sub    $0x8,%esp
    2aa8:	68 e9 54 00 00       	push   $0x54e9
    2aad:	6a 01                	push   $0x1
    2aaf:	e8 57 15 00 00       	call   400b <printf>
    2ab4:	83 c4 10             	add    $0x10,%esp
}
    2ab7:	c9                   	leave  
    2ab8:	c3                   	ret    

00002ab9 <rmdot>:

void
rmdot(void)
{
    2ab9:	55                   	push   %ebp
    2aba:	89 e5                	mov    %esp,%ebp
    2abc:	83 ec 08             	sub    $0x8,%esp
  printf(1, "rmdot test\n");
    2abf:	83 ec 08             	sub    $0x8,%esp
    2ac2:	68 f6 54 00 00       	push   $0x54f6
    2ac7:	6a 01                	push   $0x1
    2ac9:	e8 3d 15 00 00       	call   400b <printf>
    2ace:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dots") != 0){
    2ad1:	83 ec 0c             	sub    $0xc,%esp
    2ad4:	68 02 55 00 00       	push   $0x5502
    2ad9:	e8 26 14 00 00       	call   3f04 <mkdir>
    2ade:	83 c4 10             	add    $0x10,%esp
    2ae1:	85 c0                	test   %eax,%eax
    2ae3:	74 17                	je     2afc <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    2ae5:	83 ec 08             	sub    $0x8,%esp
    2ae8:	68 07 55 00 00       	push   $0x5507
    2aed:	6a 01                	push   $0x1
    2aef:	e8 17 15 00 00       	call   400b <printf>
    2af4:	83 c4 10             	add    $0x10,%esp
    exit();
    2af7:	e8 a0 13 00 00       	call   3e9c <exit>
  }
  if(chdir("dots") != 0){
    2afc:	83 ec 0c             	sub    $0xc,%esp
    2aff:	68 02 55 00 00       	push   $0x5502
    2b04:	e8 03 14 00 00       	call   3f0c <chdir>
    2b09:	83 c4 10             	add    $0x10,%esp
    2b0c:	85 c0                	test   %eax,%eax
    2b0e:	74 17                	je     2b27 <rmdot+0x6e>
    printf(1, "chdir dots failed\n");
    2b10:	83 ec 08             	sub    $0x8,%esp
    2b13:	68 1a 55 00 00       	push   $0x551a
    2b18:	6a 01                	push   $0x1
    2b1a:	e8 ec 14 00 00       	call   400b <printf>
    2b1f:	83 c4 10             	add    $0x10,%esp
    exit();
    2b22:	e8 75 13 00 00       	call   3e9c <exit>
  }
  if(unlink(".") == 0){
    2b27:	83 ec 0c             	sub    $0xc,%esp
    2b2a:	68 33 4c 00 00       	push   $0x4c33
    2b2f:	e8 b8 13 00 00       	call   3eec <unlink>
    2b34:	83 c4 10             	add    $0x10,%esp
    2b37:	85 c0                	test   %eax,%eax
    2b39:	75 17                	jne    2b52 <rmdot+0x99>
    printf(1, "rm . worked!\n");
    2b3b:	83 ec 08             	sub    $0x8,%esp
    2b3e:	68 2d 55 00 00       	push   $0x552d
    2b43:	6a 01                	push   $0x1
    2b45:	e8 c1 14 00 00       	call   400b <printf>
    2b4a:	83 c4 10             	add    $0x10,%esp
    exit();
    2b4d:	e8 4a 13 00 00       	call   3e9c <exit>
  }
  if(unlink("..") == 0){
    2b52:	83 ec 0c             	sub    $0xc,%esp
    2b55:	68 d2 47 00 00       	push   $0x47d2
    2b5a:	e8 8d 13 00 00       	call   3eec <unlink>
    2b5f:	83 c4 10             	add    $0x10,%esp
    2b62:	85 c0                	test   %eax,%eax
    2b64:	75 17                	jne    2b7d <rmdot+0xc4>
    printf(1, "rm .. worked!\n");
    2b66:	83 ec 08             	sub    $0x8,%esp
    2b69:	68 3b 55 00 00       	push   $0x553b
    2b6e:	6a 01                	push   $0x1
    2b70:	e8 96 14 00 00       	call   400b <printf>
    2b75:	83 c4 10             	add    $0x10,%esp
    exit();
    2b78:	e8 1f 13 00 00       	call   3e9c <exit>
  }
  if(chdir("/") != 0){
    2b7d:	83 ec 0c             	sub    $0xc,%esp
    2b80:	68 26 44 00 00       	push   $0x4426
    2b85:	e8 82 13 00 00       	call   3f0c <chdir>
    2b8a:	83 c4 10             	add    $0x10,%esp
    2b8d:	85 c0                	test   %eax,%eax
    2b8f:	74 17                	je     2ba8 <rmdot+0xef>
    printf(1, "chdir / failed\n");
    2b91:	83 ec 08             	sub    $0x8,%esp
    2b94:	68 28 44 00 00       	push   $0x4428
    2b99:	6a 01                	push   $0x1
    2b9b:	e8 6b 14 00 00       	call   400b <printf>
    2ba0:	83 c4 10             	add    $0x10,%esp
    exit();
    2ba3:	e8 f4 12 00 00       	call   3e9c <exit>
  }
  if(unlink("dots/.") == 0){
    2ba8:	83 ec 0c             	sub    $0xc,%esp
    2bab:	68 4a 55 00 00       	push   $0x554a
    2bb0:	e8 37 13 00 00       	call   3eec <unlink>
    2bb5:	83 c4 10             	add    $0x10,%esp
    2bb8:	85 c0                	test   %eax,%eax
    2bba:	75 17                	jne    2bd3 <rmdot+0x11a>
    printf(1, "unlink dots/. worked!\n");
    2bbc:	83 ec 08             	sub    $0x8,%esp
    2bbf:	68 51 55 00 00       	push   $0x5551
    2bc4:	6a 01                	push   $0x1
    2bc6:	e8 40 14 00 00       	call   400b <printf>
    2bcb:	83 c4 10             	add    $0x10,%esp
    exit();
    2bce:	e8 c9 12 00 00       	call   3e9c <exit>
  }
  if(unlink("dots/..") == 0){
    2bd3:	83 ec 0c             	sub    $0xc,%esp
    2bd6:	68 68 55 00 00       	push   $0x5568
    2bdb:	e8 0c 13 00 00       	call   3eec <unlink>
    2be0:	83 c4 10             	add    $0x10,%esp
    2be3:	85 c0                	test   %eax,%eax
    2be5:	75 17                	jne    2bfe <rmdot+0x145>
    printf(1, "unlink dots/.. worked!\n");
    2be7:	83 ec 08             	sub    $0x8,%esp
    2bea:	68 70 55 00 00       	push   $0x5570
    2bef:	6a 01                	push   $0x1
    2bf1:	e8 15 14 00 00       	call   400b <printf>
    2bf6:	83 c4 10             	add    $0x10,%esp
    exit();
    2bf9:	e8 9e 12 00 00       	call   3e9c <exit>
  }
  if(unlink("dots") != 0){
    2bfe:	83 ec 0c             	sub    $0xc,%esp
    2c01:	68 02 55 00 00       	push   $0x5502
    2c06:	e8 e1 12 00 00       	call   3eec <unlink>
    2c0b:	83 c4 10             	add    $0x10,%esp
    2c0e:	85 c0                	test   %eax,%eax
    2c10:	74 17                	je     2c29 <rmdot+0x170>
    printf(1, "unlink dots failed!\n");
    2c12:	83 ec 08             	sub    $0x8,%esp
    2c15:	68 88 55 00 00       	push   $0x5588
    2c1a:	6a 01                	push   $0x1
    2c1c:	e8 ea 13 00 00       	call   400b <printf>
    2c21:	83 c4 10             	add    $0x10,%esp
    exit();
    2c24:	e8 73 12 00 00       	call   3e9c <exit>
  }
  printf(1, "rmdot ok\n");
    2c29:	83 ec 08             	sub    $0x8,%esp
    2c2c:	68 9d 55 00 00       	push   $0x559d
    2c31:	6a 01                	push   $0x1
    2c33:	e8 d3 13 00 00       	call   400b <printf>
    2c38:	83 c4 10             	add    $0x10,%esp
}
    2c3b:	c9                   	leave  
    2c3c:	c3                   	ret    

00002c3d <dirfile>:

void
dirfile(void)
{
    2c3d:	55                   	push   %ebp
    2c3e:	89 e5                	mov    %esp,%ebp
    2c40:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "dir vs file\n");
    2c43:	83 ec 08             	sub    $0x8,%esp
    2c46:	68 a7 55 00 00       	push   $0x55a7
    2c4b:	6a 01                	push   $0x1
    2c4d:	e8 b9 13 00 00       	call   400b <printf>
    2c52:	83 c4 10             	add    $0x10,%esp

  fd = open("dirfile", O_CREATE);
    2c55:	83 ec 08             	sub    $0x8,%esp
    2c58:	68 00 02 00 00       	push   $0x200
    2c5d:	68 b4 55 00 00       	push   $0x55b4
    2c62:	e8 75 12 00 00       	call   3edc <open>
    2c67:	83 c4 10             	add    $0x10,%esp
    2c6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2c6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2c71:	79 17                	jns    2c8a <dirfile+0x4d>
    printf(1, "create dirfile failed\n");
    2c73:	83 ec 08             	sub    $0x8,%esp
    2c76:	68 bc 55 00 00       	push   $0x55bc
    2c7b:	6a 01                	push   $0x1
    2c7d:	e8 89 13 00 00       	call   400b <printf>
    2c82:	83 c4 10             	add    $0x10,%esp
    exit();
    2c85:	e8 12 12 00 00       	call   3e9c <exit>
  }
  close(fd);
    2c8a:	83 ec 0c             	sub    $0xc,%esp
    2c8d:	ff 75 f4             	pushl  -0xc(%ebp)
    2c90:	e8 2f 12 00 00       	call   3ec4 <close>
    2c95:	83 c4 10             	add    $0x10,%esp
  if(chdir("dirfile") == 0){
    2c98:	83 ec 0c             	sub    $0xc,%esp
    2c9b:	68 b4 55 00 00       	push   $0x55b4
    2ca0:	e8 67 12 00 00       	call   3f0c <chdir>
    2ca5:	83 c4 10             	add    $0x10,%esp
    2ca8:	85 c0                	test   %eax,%eax
    2caa:	75 17                	jne    2cc3 <dirfile+0x86>
    printf(1, "chdir dirfile succeeded!\n");
    2cac:	83 ec 08             	sub    $0x8,%esp
    2caf:	68 d3 55 00 00       	push   $0x55d3
    2cb4:	6a 01                	push   $0x1
    2cb6:	e8 50 13 00 00       	call   400b <printf>
    2cbb:	83 c4 10             	add    $0x10,%esp
    exit();
    2cbe:	e8 d9 11 00 00       	call   3e9c <exit>
  }
  fd = open("dirfile/xx", 0);
    2cc3:	83 ec 08             	sub    $0x8,%esp
    2cc6:	6a 00                	push   $0x0
    2cc8:	68 ed 55 00 00       	push   $0x55ed
    2ccd:	e8 0a 12 00 00       	call   3edc <open>
    2cd2:	83 c4 10             	add    $0x10,%esp
    2cd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2cd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2cdc:	78 17                	js     2cf5 <dirfile+0xb8>
    printf(1, "create dirfile/xx succeeded!\n");
    2cde:	83 ec 08             	sub    $0x8,%esp
    2ce1:	68 f8 55 00 00       	push   $0x55f8
    2ce6:	6a 01                	push   $0x1
    2ce8:	e8 1e 13 00 00       	call   400b <printf>
    2ced:	83 c4 10             	add    $0x10,%esp
    exit();
    2cf0:	e8 a7 11 00 00       	call   3e9c <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2cf5:	83 ec 08             	sub    $0x8,%esp
    2cf8:	68 00 02 00 00       	push   $0x200
    2cfd:	68 ed 55 00 00       	push   $0x55ed
    2d02:	e8 d5 11 00 00       	call   3edc <open>
    2d07:	83 c4 10             	add    $0x10,%esp
    2d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d11:	78 17                	js     2d2a <dirfile+0xed>
    printf(1, "create dirfile/xx succeeded!\n");
    2d13:	83 ec 08             	sub    $0x8,%esp
    2d16:	68 f8 55 00 00       	push   $0x55f8
    2d1b:	6a 01                	push   $0x1
    2d1d:	e8 e9 12 00 00       	call   400b <printf>
    2d22:	83 c4 10             	add    $0x10,%esp
    exit();
    2d25:	e8 72 11 00 00       	call   3e9c <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2d2a:	83 ec 0c             	sub    $0xc,%esp
    2d2d:	68 ed 55 00 00       	push   $0x55ed
    2d32:	e8 cd 11 00 00       	call   3f04 <mkdir>
    2d37:	83 c4 10             	add    $0x10,%esp
    2d3a:	85 c0                	test   %eax,%eax
    2d3c:	75 17                	jne    2d55 <dirfile+0x118>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2d3e:	83 ec 08             	sub    $0x8,%esp
    2d41:	68 16 56 00 00       	push   $0x5616
    2d46:	6a 01                	push   $0x1
    2d48:	e8 be 12 00 00       	call   400b <printf>
    2d4d:	83 c4 10             	add    $0x10,%esp
    exit();
    2d50:	e8 47 11 00 00       	call   3e9c <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2d55:	83 ec 0c             	sub    $0xc,%esp
    2d58:	68 ed 55 00 00       	push   $0x55ed
    2d5d:	e8 8a 11 00 00       	call   3eec <unlink>
    2d62:	83 c4 10             	add    $0x10,%esp
    2d65:	85 c0                	test   %eax,%eax
    2d67:	75 17                	jne    2d80 <dirfile+0x143>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2d69:	83 ec 08             	sub    $0x8,%esp
    2d6c:	68 33 56 00 00       	push   $0x5633
    2d71:	6a 01                	push   $0x1
    2d73:	e8 93 12 00 00       	call   400b <printf>
    2d78:	83 c4 10             	add    $0x10,%esp
    exit();
    2d7b:	e8 1c 11 00 00       	call   3e9c <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2d80:	83 ec 08             	sub    $0x8,%esp
    2d83:	68 ed 55 00 00       	push   $0x55ed
    2d88:	68 51 56 00 00       	push   $0x5651
    2d8d:	e8 6a 11 00 00       	call   3efc <link>
    2d92:	83 c4 10             	add    $0x10,%esp
    2d95:	85 c0                	test   %eax,%eax
    2d97:	75 17                	jne    2db0 <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2d99:	83 ec 08             	sub    $0x8,%esp
    2d9c:	68 58 56 00 00       	push   $0x5658
    2da1:	6a 01                	push   $0x1
    2da3:	e8 63 12 00 00       	call   400b <printf>
    2da8:	83 c4 10             	add    $0x10,%esp
    exit();
    2dab:	e8 ec 10 00 00       	call   3e9c <exit>
  }
  if(unlink("dirfile") != 0){
    2db0:	83 ec 0c             	sub    $0xc,%esp
    2db3:	68 b4 55 00 00       	push   $0x55b4
    2db8:	e8 2f 11 00 00       	call   3eec <unlink>
    2dbd:	83 c4 10             	add    $0x10,%esp
    2dc0:	85 c0                	test   %eax,%eax
    2dc2:	74 17                	je     2ddb <dirfile+0x19e>
    printf(1, "unlink dirfile failed!\n");
    2dc4:	83 ec 08             	sub    $0x8,%esp
    2dc7:	68 77 56 00 00       	push   $0x5677
    2dcc:	6a 01                	push   $0x1
    2dce:	e8 38 12 00 00       	call   400b <printf>
    2dd3:	83 c4 10             	add    $0x10,%esp
    exit();
    2dd6:	e8 c1 10 00 00       	call   3e9c <exit>
  }

  fd = open(".", O_RDWR);
    2ddb:	83 ec 08             	sub    $0x8,%esp
    2dde:	6a 02                	push   $0x2
    2de0:	68 33 4c 00 00       	push   $0x4c33
    2de5:	e8 f2 10 00 00       	call   3edc <open>
    2dea:	83 c4 10             	add    $0x10,%esp
    2ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2df0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2df4:	78 17                	js     2e0d <dirfile+0x1d0>
    printf(1, "open . for writing succeeded!\n");
    2df6:	83 ec 08             	sub    $0x8,%esp
    2df9:	68 90 56 00 00       	push   $0x5690
    2dfe:	6a 01                	push   $0x1
    2e00:	e8 06 12 00 00       	call   400b <printf>
    2e05:	83 c4 10             	add    $0x10,%esp
    exit();
    2e08:	e8 8f 10 00 00       	call   3e9c <exit>
  }
  fd = open(".", 0);
    2e0d:	83 ec 08             	sub    $0x8,%esp
    2e10:	6a 00                	push   $0x0
    2e12:	68 33 4c 00 00       	push   $0x4c33
    2e17:	e8 c0 10 00 00       	call   3edc <open>
    2e1c:	83 c4 10             	add    $0x10,%esp
    2e1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2e22:	83 ec 04             	sub    $0x4,%esp
    2e25:	6a 01                	push   $0x1
    2e27:	68 8b 48 00 00       	push   $0x488b
    2e2c:	ff 75 f4             	pushl  -0xc(%ebp)
    2e2f:	e8 88 10 00 00       	call   3ebc <write>
    2e34:	83 c4 10             	add    $0x10,%esp
    2e37:	85 c0                	test   %eax,%eax
    2e39:	7e 17                	jle    2e52 <dirfile+0x215>
    printf(1, "write . succeeded!\n");
    2e3b:	83 ec 08             	sub    $0x8,%esp
    2e3e:	68 af 56 00 00       	push   $0x56af
    2e43:	6a 01                	push   $0x1
    2e45:	e8 c1 11 00 00       	call   400b <printf>
    2e4a:	83 c4 10             	add    $0x10,%esp
    exit();
    2e4d:	e8 4a 10 00 00       	call   3e9c <exit>
  }
  close(fd);
    2e52:	83 ec 0c             	sub    $0xc,%esp
    2e55:	ff 75 f4             	pushl  -0xc(%ebp)
    2e58:	e8 67 10 00 00       	call   3ec4 <close>
    2e5d:	83 c4 10             	add    $0x10,%esp

  printf(1, "dir vs file OK\n");
    2e60:	83 ec 08             	sub    $0x8,%esp
    2e63:	68 c3 56 00 00       	push   $0x56c3
    2e68:	6a 01                	push   $0x1
    2e6a:	e8 9c 11 00 00       	call   400b <printf>
    2e6f:	83 c4 10             	add    $0x10,%esp
}
    2e72:	c9                   	leave  
    2e73:	c3                   	ret    

00002e74 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2e74:	55                   	push   %ebp
    2e75:	89 e5                	mov    %esp,%ebp
    2e77:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2e7a:	83 ec 08             	sub    $0x8,%esp
    2e7d:	68 d3 56 00 00       	push   $0x56d3
    2e82:	6a 01                	push   $0x1
    2e84:	e8 82 11 00 00       	call   400b <printf>
    2e89:	83 c4 10             	add    $0x10,%esp

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2e8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2e93:	e9 e6 00 00 00       	jmp    2f7e <iref+0x10a>
    if(mkdir("irefd") != 0){
    2e98:	83 ec 0c             	sub    $0xc,%esp
    2e9b:	68 e4 56 00 00       	push   $0x56e4
    2ea0:	e8 5f 10 00 00       	call   3f04 <mkdir>
    2ea5:	83 c4 10             	add    $0x10,%esp
    2ea8:	85 c0                	test   %eax,%eax
    2eaa:	74 17                	je     2ec3 <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2eac:	83 ec 08             	sub    $0x8,%esp
    2eaf:	68 ea 56 00 00       	push   $0x56ea
    2eb4:	6a 01                	push   $0x1
    2eb6:	e8 50 11 00 00       	call   400b <printf>
    2ebb:	83 c4 10             	add    $0x10,%esp
      exit();
    2ebe:	e8 d9 0f 00 00       	call   3e9c <exit>
    }
    if(chdir("irefd") != 0){
    2ec3:	83 ec 0c             	sub    $0xc,%esp
    2ec6:	68 e4 56 00 00       	push   $0x56e4
    2ecb:	e8 3c 10 00 00       	call   3f0c <chdir>
    2ed0:	83 c4 10             	add    $0x10,%esp
    2ed3:	85 c0                	test   %eax,%eax
    2ed5:	74 17                	je     2eee <iref+0x7a>
      printf(1, "chdir irefd failed\n");
    2ed7:	83 ec 08             	sub    $0x8,%esp
    2eda:	68 fe 56 00 00       	push   $0x56fe
    2edf:	6a 01                	push   $0x1
    2ee1:	e8 25 11 00 00       	call   400b <printf>
    2ee6:	83 c4 10             	add    $0x10,%esp
      exit();
    2ee9:	e8 ae 0f 00 00       	call   3e9c <exit>
    }

    mkdir("");
    2eee:	83 ec 0c             	sub    $0xc,%esp
    2ef1:	68 12 57 00 00       	push   $0x5712
    2ef6:	e8 09 10 00 00       	call   3f04 <mkdir>
    2efb:	83 c4 10             	add    $0x10,%esp
    link("README", "");
    2efe:	83 ec 08             	sub    $0x8,%esp
    2f01:	68 12 57 00 00       	push   $0x5712
    2f06:	68 51 56 00 00       	push   $0x5651
    2f0b:	e8 ec 0f 00 00       	call   3efc <link>
    2f10:	83 c4 10             	add    $0x10,%esp
    fd = open("", O_CREATE);
    2f13:	83 ec 08             	sub    $0x8,%esp
    2f16:	68 00 02 00 00       	push   $0x200
    2f1b:	68 12 57 00 00       	push   $0x5712
    2f20:	e8 b7 0f 00 00       	call   3edc <open>
    2f25:	83 c4 10             	add    $0x10,%esp
    2f28:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2f2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2f2f:	78 0e                	js     2f3f <iref+0xcb>
      close(fd);
    2f31:	83 ec 0c             	sub    $0xc,%esp
    2f34:	ff 75 f0             	pushl  -0x10(%ebp)
    2f37:	e8 88 0f 00 00       	call   3ec4 <close>
    2f3c:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    2f3f:	83 ec 08             	sub    $0x8,%esp
    2f42:	68 00 02 00 00       	push   $0x200
    2f47:	68 13 57 00 00       	push   $0x5713
    2f4c:	e8 8b 0f 00 00       	call   3edc <open>
    2f51:	83 c4 10             	add    $0x10,%esp
    2f54:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2f57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2f5b:	78 0e                	js     2f6b <iref+0xf7>
      close(fd);
    2f5d:	83 ec 0c             	sub    $0xc,%esp
    2f60:	ff 75 f0             	pushl  -0x10(%ebp)
    2f63:	e8 5c 0f 00 00       	call   3ec4 <close>
    2f68:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    2f6b:	83 ec 0c             	sub    $0xc,%esp
    2f6e:	68 13 57 00 00       	push   $0x5713
    2f73:	e8 74 0f 00 00       	call   3eec <unlink>
    2f78:	83 c4 10             	add    $0x10,%esp
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2f7b:	ff 45 f4             	incl   -0xc(%ebp)
    2f7e:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    2f82:	0f 8e 10 ff ff ff    	jle    2e98 <iref+0x24>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    2f88:	83 ec 0c             	sub    $0xc,%esp
    2f8b:	68 26 44 00 00       	push   $0x4426
    2f90:	e8 77 0f 00 00       	call   3f0c <chdir>
    2f95:	83 c4 10             	add    $0x10,%esp
  printf(1, "empty file name OK\n");
    2f98:	83 ec 08             	sub    $0x8,%esp
    2f9b:	68 16 57 00 00       	push   $0x5716
    2fa0:	6a 01                	push   $0x1
    2fa2:	e8 64 10 00 00       	call   400b <printf>
    2fa7:	83 c4 10             	add    $0x10,%esp
}
    2faa:	c9                   	leave  
    2fab:	c3                   	ret    

00002fac <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    2fac:	55                   	push   %ebp
    2fad:	89 e5                	mov    %esp,%ebp
    2faf:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
    2fb2:	83 ec 08             	sub    $0x8,%esp
    2fb5:	68 2a 57 00 00       	push   $0x572a
    2fba:	6a 01                	push   $0x1
    2fbc:	e8 4a 10 00 00       	call   400b <printf>
    2fc1:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<1000; n++){
    2fc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2fcb:	eb 1c                	jmp    2fe9 <forktest+0x3d>
    pid = fork();
    2fcd:	e8 c2 0e 00 00       	call   3e94 <fork>
    2fd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    2fd5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fd9:	78 19                	js     2ff4 <forktest+0x48>
      break;
    if(pid == 0)
    2fdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fdf:	75 05                	jne    2fe6 <forktest+0x3a>
      exit();
    2fe1:	e8 b6 0e 00 00       	call   3e9c <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
    2fe6:	ff 45 f4             	incl   -0xc(%ebp)
    2fe9:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    2ff0:	7e db                	jle    2fcd <forktest+0x21>
    2ff2:	eb 01                	jmp    2ff5 <forktest+0x49>
    pid = fork();
    if(pid < 0)
      break;
    2ff4:	90                   	nop
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    2ff5:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    2ffc:	75 3c                	jne    303a <forktest+0x8e>
    printf(1, "fork claimed to work 1000 times!\n");
    2ffe:	83 ec 08             	sub    $0x8,%esp
    3001:	68 38 57 00 00       	push   $0x5738
    3006:	6a 01                	push   $0x1
    3008:	e8 fe 0f 00 00       	call   400b <printf>
    300d:	83 c4 10             	add    $0x10,%esp
    exit();
    3010:	e8 87 0e 00 00       	call   3e9c <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
    3015:	e8 8a 0e 00 00       	call   3ea4 <wait>
    301a:	85 c0                	test   %eax,%eax
    301c:	79 17                	jns    3035 <forktest+0x89>
      printf(1, "wait stopped early\n");
    301e:	83 ec 08             	sub    $0x8,%esp
    3021:	68 5a 57 00 00       	push   $0x575a
    3026:	6a 01                	push   $0x1
    3028:	e8 de 0f 00 00       	call   400b <printf>
    302d:	83 c4 10             	add    $0x10,%esp
      exit();
    3030:	e8 67 0e 00 00       	call   3e9c <exit>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
    3035:	ff 4d f4             	decl   -0xc(%ebp)
    3038:	eb 01                	jmp    303b <forktest+0x8f>
    303a:	90                   	nop
    303b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    303f:	7f d4                	jg     3015 <forktest+0x69>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
    3041:	e8 5e 0e 00 00       	call   3ea4 <wait>
    3046:	83 f8 ff             	cmp    $0xffffffff,%eax
    3049:	74 17                	je     3062 <forktest+0xb6>
    printf(1, "wait got too many\n");
    304b:	83 ec 08             	sub    $0x8,%esp
    304e:	68 6e 57 00 00       	push   $0x576e
    3053:	6a 01                	push   $0x1
    3055:	e8 b1 0f 00 00       	call   400b <printf>
    305a:	83 c4 10             	add    $0x10,%esp
    exit();
    305d:	e8 3a 0e 00 00       	call   3e9c <exit>
  }
  
  printf(1, "fork test OK\n");
    3062:	83 ec 08             	sub    $0x8,%esp
    3065:	68 81 57 00 00       	push   $0x5781
    306a:	6a 01                	push   $0x1
    306c:	e8 9a 0f 00 00       	call   400b <printf>
    3071:	83 c4 10             	add    $0x10,%esp
}
    3074:	c9                   	leave  
    3075:	c3                   	ret    

00003076 <sbrktest>:

void
sbrktest(void)
{
    3076:	55                   	push   %ebp
    3077:	89 e5                	mov    %esp,%ebp
    3079:	53                   	push   %ebx
    307a:	83 ec 64             	sub    $0x64,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    307d:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    3082:	83 ec 08             	sub    $0x8,%esp
    3085:	68 8f 57 00 00       	push   $0x578f
    308a:	50                   	push   %eax
    308b:	e8 7b 0f 00 00       	call   400b <printf>
    3090:	83 c4 10             	add    $0x10,%esp
  oldbrk = sbrk(0);
    3093:	83 ec 0c             	sub    $0xc,%esp
    3096:	6a 00                	push   $0x0
    3098:	e8 87 0e 00 00       	call   3f24 <sbrk>
    309d:	83 c4 10             	add    $0x10,%esp
    30a0:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    30a3:	83 ec 0c             	sub    $0xc,%esp
    30a6:	6a 00                	push   $0x0
    30a8:	e8 77 0e 00 00       	call   3f24 <sbrk>
    30ad:	83 c4 10             	add    $0x10,%esp
    30b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){ 
    30b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    30ba:	eb 4c                	jmp    3108 <sbrktest+0x92>
    b = sbrk(1);
    30bc:	83 ec 0c             	sub    $0xc,%esp
    30bf:	6a 01                	push   $0x1
    30c1:	e8 5e 0e 00 00       	call   3f24 <sbrk>
    30c6:	83 c4 10             	add    $0x10,%esp
    30c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != a){
    30cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
    30cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    30d2:	74 24                	je     30f8 <sbrktest+0x82>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    30d4:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    30d9:	83 ec 0c             	sub    $0xc,%esp
    30dc:	ff 75 e8             	pushl  -0x18(%ebp)
    30df:	ff 75 f4             	pushl  -0xc(%ebp)
    30e2:	ff 75 f0             	pushl  -0x10(%ebp)
    30e5:	68 9a 57 00 00       	push   $0x579a
    30ea:	50                   	push   %eax
    30eb:	e8 1b 0f 00 00       	call   400b <printf>
    30f0:	83 c4 20             	add    $0x20,%esp
      exit();
    30f3:	e8 a4 0d 00 00       	call   3e9c <exit>
    }
    *b = 1;
    30f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    30fb:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    30fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3101:	40                   	inc    %eax
    3102:	89 45 f4             	mov    %eax,-0xc(%ebp)
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
    3105:	ff 45 f0             	incl   -0x10(%ebp)
    3108:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    310f:	7e ab                	jle    30bc <sbrktest+0x46>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    3111:	e8 7e 0d 00 00       	call   3e94 <fork>
    3116:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    3119:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    311d:	79 1b                	jns    313a <sbrktest+0xc4>
    printf(stdout, "sbrk test fork failed\n");
    311f:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    3124:	83 ec 08             	sub    $0x8,%esp
    3127:	68 b5 57 00 00       	push   $0x57b5
    312c:	50                   	push   %eax
    312d:	e8 d9 0e 00 00       	call   400b <printf>
    3132:	83 c4 10             	add    $0x10,%esp
    exit();
    3135:	e8 62 0d 00 00       	call   3e9c <exit>
  }
  c = sbrk(1);
    313a:	83 ec 0c             	sub    $0xc,%esp
    313d:	6a 01                	push   $0x1
    313f:	e8 e0 0d 00 00       	call   3f24 <sbrk>
    3144:	83 c4 10             	add    $0x10,%esp
    3147:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
    314a:	83 ec 0c             	sub    $0xc,%esp
    314d:	6a 01                	push   $0x1
    314f:	e8 d0 0d 00 00       	call   3f24 <sbrk>
    3154:	83 c4 10             	add    $0x10,%esp
    3157:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
    315a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    315d:	40                   	inc    %eax
    315e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    3161:	74 1b                	je     317e <sbrktest+0x108>
    printf(stdout, "sbrk test failed post-fork\n");
    3163:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    3168:	83 ec 08             	sub    $0x8,%esp
    316b:	68 cc 57 00 00       	push   $0x57cc
    3170:	50                   	push   %eax
    3171:	e8 95 0e 00 00       	call   400b <printf>
    3176:	83 c4 10             	add    $0x10,%esp
    exit();
    3179:	e8 1e 0d 00 00       	call   3e9c <exit>
  }
  if(pid == 0)
    317e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3182:	75 05                	jne    3189 <sbrktest+0x113>
    exit();
    3184:	e8 13 0d 00 00       	call   3e9c <exit>
  wait();
    3189:	e8 16 0d 00 00       	call   3ea4 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    318e:	83 ec 0c             	sub    $0xc,%esp
    3191:	6a 00                	push   $0x0
    3193:	e8 8c 0d 00 00       	call   3f24 <sbrk>
    3198:	83 c4 10             	add    $0x10,%esp
    319b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    319e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    31a1:	ba 00 00 40 06       	mov    $0x6400000,%edx
    31a6:	89 d1                	mov    %edx,%ecx
    31a8:	29 c1                	sub    %eax,%ecx
    31aa:	89 c8                	mov    %ecx,%eax
    31ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
  p = sbrk(amt);
    31af:	8b 45 dc             	mov    -0x24(%ebp),%eax
    31b2:	83 ec 0c             	sub    $0xc,%esp
    31b5:	50                   	push   %eax
    31b6:	e8 69 0d 00 00       	call   3f24 <sbrk>
    31bb:	83 c4 10             	add    $0x10,%esp
    31be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (p != a) { 
    31c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
    31c4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    31c7:	74 1b                	je     31e4 <sbrktest+0x16e>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    31c9:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    31ce:	83 ec 08             	sub    $0x8,%esp
    31d1:	68 e8 57 00 00       	push   $0x57e8
    31d6:	50                   	push   %eax
    31d7:	e8 2f 0e 00 00       	call   400b <printf>
    31dc:	83 c4 10             	add    $0x10,%esp
    exit();
    31df:	e8 b8 0c 00 00       	call   3e9c <exit>
  }
  lastaddr = (char*) (BIG-1);
    31e4:	c7 45 d4 ff ff 3f 06 	movl   $0x63fffff,-0x2c(%ebp)
  *lastaddr = 99;
    31eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    31ee:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    31f1:	83 ec 0c             	sub    $0xc,%esp
    31f4:	6a 00                	push   $0x0
    31f6:	e8 29 0d 00 00       	call   3f24 <sbrk>
    31fb:	83 c4 10             	add    $0x10,%esp
    31fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    3201:	83 ec 0c             	sub    $0xc,%esp
    3204:	68 00 f0 ff ff       	push   $0xfffff000
    3209:	e8 16 0d 00 00       	call   3f24 <sbrk>
    320e:	83 c4 10             	add    $0x10,%esp
    3211:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
    3214:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    3218:	75 1b                	jne    3235 <sbrktest+0x1bf>
    printf(stdout, "sbrk could not deallocate\n");
    321a:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    321f:	83 ec 08             	sub    $0x8,%esp
    3222:	68 26 58 00 00       	push   $0x5826
    3227:	50                   	push   %eax
    3228:	e8 de 0d 00 00       	call   400b <printf>
    322d:	83 c4 10             	add    $0x10,%esp
    exit();
    3230:	e8 67 0c 00 00       	call   3e9c <exit>
  }
  c = sbrk(0);
    3235:	83 ec 0c             	sub    $0xc,%esp
    3238:	6a 00                	push   $0x0
    323a:	e8 e5 0c 00 00       	call   3f24 <sbrk>
    323f:	83 c4 10             	add    $0x10,%esp
    3242:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
    3245:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3248:	2d 00 10 00 00       	sub    $0x1000,%eax
    324d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    3250:	74 1e                	je     3270 <sbrktest+0x1fa>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    3252:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    3257:	ff 75 e0             	pushl  -0x20(%ebp)
    325a:	ff 75 f4             	pushl  -0xc(%ebp)
    325d:	68 44 58 00 00       	push   $0x5844
    3262:	50                   	push   %eax
    3263:	e8 a3 0d 00 00       	call   400b <printf>
    3268:	83 c4 10             	add    $0x10,%esp
    exit();
    326b:	e8 2c 0c 00 00       	call   3e9c <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    3270:	83 ec 0c             	sub    $0xc,%esp
    3273:	6a 00                	push   $0x0
    3275:	e8 aa 0c 00 00       	call   3f24 <sbrk>
    327a:	83 c4 10             	add    $0x10,%esp
    327d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    3280:	83 ec 0c             	sub    $0xc,%esp
    3283:	68 00 10 00 00       	push   $0x1000
    3288:	e8 97 0c 00 00       	call   3f24 <sbrk>
    328d:	83 c4 10             	add    $0x10,%esp
    3290:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    3293:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3296:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3299:	75 1a                	jne    32b5 <sbrktest+0x23f>
    329b:	83 ec 0c             	sub    $0xc,%esp
    329e:	6a 00                	push   $0x0
    32a0:	e8 7f 0c 00 00       	call   3f24 <sbrk>
    32a5:	83 c4 10             	add    $0x10,%esp
    32a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
    32ab:	81 c2 00 10 00 00    	add    $0x1000,%edx
    32b1:	39 d0                	cmp    %edx,%eax
    32b3:	74 1e                	je     32d3 <sbrktest+0x25d>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    32b5:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    32ba:	ff 75 e0             	pushl  -0x20(%ebp)
    32bd:	ff 75 f4             	pushl  -0xc(%ebp)
    32c0:	68 7c 58 00 00       	push   $0x587c
    32c5:	50                   	push   %eax
    32c6:	e8 40 0d 00 00       	call   400b <printf>
    32cb:	83 c4 10             	add    $0x10,%esp
    exit();
    32ce:	e8 c9 0b 00 00       	call   3e9c <exit>
  }
  if(*lastaddr == 99){
    32d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    32d6:	8a 00                	mov    (%eax),%al
    32d8:	3c 63                	cmp    $0x63,%al
    32da:	75 1b                	jne    32f7 <sbrktest+0x281>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    32dc:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    32e1:	83 ec 08             	sub    $0x8,%esp
    32e4:	68 a4 58 00 00       	push   $0x58a4
    32e9:	50                   	push   %eax
    32ea:	e8 1c 0d 00 00       	call   400b <printf>
    32ef:	83 c4 10             	add    $0x10,%esp
    exit();
    32f2:	e8 a5 0b 00 00       	call   3e9c <exit>
  }

  a = sbrk(0);
    32f7:	83 ec 0c             	sub    $0xc,%esp
    32fa:	6a 00                	push   $0x0
    32fc:	e8 23 0c 00 00       	call   3f24 <sbrk>
    3301:	83 c4 10             	add    $0x10,%esp
    3304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    3307:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    330a:	83 ec 0c             	sub    $0xc,%esp
    330d:	6a 00                	push   $0x0
    330f:	e8 10 0c 00 00       	call   3f24 <sbrk>
    3314:	83 c4 10             	add    $0x10,%esp
    3317:	89 da                	mov    %ebx,%edx
    3319:	29 c2                	sub    %eax,%edx
    331b:	89 d0                	mov    %edx,%eax
    331d:	83 ec 0c             	sub    $0xc,%esp
    3320:	50                   	push   %eax
    3321:	e8 fe 0b 00 00       	call   3f24 <sbrk>
    3326:	83 c4 10             	add    $0x10,%esp
    3329:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
    332c:	8b 45 e0             	mov    -0x20(%ebp),%eax
    332f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3332:	74 1e                	je     3352 <sbrktest+0x2dc>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    3334:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    3339:	ff 75 e0             	pushl  -0x20(%ebp)
    333c:	ff 75 f4             	pushl  -0xc(%ebp)
    333f:	68 d4 58 00 00       	push   $0x58d4
    3344:	50                   	push   %eax
    3345:	e8 c1 0c 00 00       	call   400b <printf>
    334a:	83 c4 10             	add    $0x10,%esp
    exit();
    334d:	e8 4a 0b 00 00       	call   3e9c <exit>
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3352:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    3359:	eb 75                	jmp    33d0 <sbrktest+0x35a>
    ppid = getpid();
    335b:	e8 bc 0b 00 00       	call   3f1c <getpid>
    3360:	89 45 d0             	mov    %eax,-0x30(%ebp)
    pid = fork();
    3363:	e8 2c 0b 00 00       	call   3e94 <fork>
    3368:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
    336b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    336f:	79 1b                	jns    338c <sbrktest+0x316>
      printf(stdout, "fork failed\n");
    3371:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    3376:	83 ec 08             	sub    $0x8,%esp
    3379:	68 55 44 00 00       	push   $0x4455
    337e:	50                   	push   %eax
    337f:	e8 87 0c 00 00       	call   400b <printf>
    3384:	83 c4 10             	add    $0x10,%esp
      exit();
    3387:	e8 10 0b 00 00       	call   3e9c <exit>
    }
    if(pid == 0){
    338c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3390:	75 32                	jne    33c4 <sbrktest+0x34e>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    3392:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3395:	8a 00                	mov    (%eax),%al
    3397:	0f be d0             	movsbl %al,%edx
    339a:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    339f:	52                   	push   %edx
    33a0:	ff 75 f4             	pushl  -0xc(%ebp)
    33a3:	68 f5 58 00 00       	push   $0x58f5
    33a8:	50                   	push   %eax
    33a9:	e8 5d 0c 00 00       	call   400b <printf>
    33ae:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
    33b1:	83 ec 0c             	sub    $0xc,%esp
    33b4:	ff 75 d0             	pushl  -0x30(%ebp)
    33b7:	e8 10 0b 00 00       	call   3ecc <kill>
    33bc:	83 c4 10             	add    $0x10,%esp
      exit();
    33bf:	e8 d8 0a 00 00       	call   3e9c <exit>
    }
    wait();
    33c4:	e8 db 0a 00 00       	call   3ea4 <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    33c9:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    33d0:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    33d7:	76 82                	jbe    335b <sbrktest+0x2e5>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    33d9:	83 ec 0c             	sub    $0xc,%esp
    33dc:	8d 45 c8             	lea    -0x38(%ebp),%eax
    33df:	50                   	push   %eax
    33e0:	e8 c7 0a 00 00       	call   3eac <pipe>
    33e5:	83 c4 10             	add    $0x10,%esp
    33e8:	85 c0                	test   %eax,%eax
    33ea:	74 17                	je     3403 <sbrktest+0x38d>
    printf(1, "pipe() failed\n");
    33ec:	83 ec 08             	sub    $0x8,%esp
    33ef:	68 26 48 00 00       	push   $0x4826
    33f4:	6a 01                	push   $0x1
    33f6:	e8 10 0c 00 00       	call   400b <printf>
    33fb:	83 c4 10             	add    $0x10,%esp
    exit();
    33fe:	e8 99 0a 00 00       	call   3e9c <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3403:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    340a:	e9 87 00 00 00       	jmp    3496 <sbrktest+0x420>
    if((pids[i] = fork()) == 0){
    340f:	e8 80 0a 00 00       	call   3e94 <fork>
    3414:	8b 55 f0             	mov    -0x10(%ebp),%edx
    3417:	89 44 95 a0          	mov    %eax,-0x60(%ebp,%edx,4)
    341b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    341e:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3422:	85 c0                	test   %eax,%eax
    3424:	75 4c                	jne    3472 <sbrktest+0x3fc>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    3426:	83 ec 0c             	sub    $0xc,%esp
    3429:	6a 00                	push   $0x0
    342b:	e8 f4 0a 00 00       	call   3f24 <sbrk>
    3430:	83 c4 10             	add    $0x10,%esp
    3433:	ba 00 00 40 06       	mov    $0x6400000,%edx
    3438:	89 d1                	mov    %edx,%ecx
    343a:	29 c1                	sub    %eax,%ecx
    343c:	89 c8                	mov    %ecx,%eax
    343e:	83 ec 0c             	sub    $0xc,%esp
    3441:	50                   	push   %eax
    3442:	e8 dd 0a 00 00       	call   3f24 <sbrk>
    3447:	83 c4 10             	add    $0x10,%esp
      write(fds[1], "x", 1);
    344a:	8b 45 cc             	mov    -0x34(%ebp),%eax
    344d:	83 ec 04             	sub    $0x4,%esp
    3450:	6a 01                	push   $0x1
    3452:	68 8b 48 00 00       	push   $0x488b
    3457:	50                   	push   %eax
    3458:	e8 5f 0a 00 00       	call   3ebc <write>
    345d:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    3460:	83 ec 0c             	sub    $0xc,%esp
    3463:	68 e8 03 00 00       	push   $0x3e8
    3468:	e8 bf 0a 00 00       	call   3f2c <sleep>
    346d:	83 c4 10             	add    $0x10,%esp
    3470:	eb ee                	jmp    3460 <sbrktest+0x3ea>
    }
    if(pids[i] != -1)
    3472:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3475:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3479:	83 f8 ff             	cmp    $0xffffffff,%eax
    347c:	74 15                	je     3493 <sbrktest+0x41d>
      read(fds[0], &scratch, 1);
    347e:	8b 45 c8             	mov    -0x38(%ebp),%eax
    3481:	83 ec 04             	sub    $0x4,%esp
    3484:	6a 01                	push   $0x1
    3486:	8d 55 9f             	lea    -0x61(%ebp),%edx
    3489:	52                   	push   %edx
    348a:	50                   	push   %eax
    348b:	e8 24 0a 00 00       	call   3eb4 <read>
    3490:	83 c4 10             	add    $0x10,%esp
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3493:	ff 45 f0             	incl   -0x10(%ebp)
    3496:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3499:	83 f8 09             	cmp    $0x9,%eax
    349c:	0f 86 6d ff ff ff    	jbe    340f <sbrktest+0x399>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    34a2:	83 ec 0c             	sub    $0xc,%esp
    34a5:	68 00 10 00 00       	push   $0x1000
    34aa:	e8 75 0a 00 00       	call   3f24 <sbrk>
    34af:	83 c4 10             	add    $0x10,%esp
    34b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    34b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    34bc:	eb 2a                	jmp    34e8 <sbrktest+0x472>
    if(pids[i] == -1)
    34be:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34c1:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    34c5:	83 f8 ff             	cmp    $0xffffffff,%eax
    34c8:	74 1a                	je     34e4 <sbrktest+0x46e>
      continue;
    kill(pids[i]);
    34ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34cd:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    34d1:	83 ec 0c             	sub    $0xc,%esp
    34d4:	50                   	push   %eax
    34d5:	e8 f2 09 00 00       	call   3ecc <kill>
    34da:	83 c4 10             	add    $0x10,%esp
    wait();
    34dd:	e8 c2 09 00 00       	call   3ea4 <wait>
    34e2:	eb 01                	jmp    34e5 <sbrktest+0x46f>
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if(pids[i] == -1)
      continue;
    34e4:	90                   	nop
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    34e5:	ff 45 f0             	incl   -0x10(%ebp)
    34e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34eb:	83 f8 09             	cmp    $0x9,%eax
    34ee:	76 ce                	jbe    34be <sbrktest+0x448>
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    34f0:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    34f4:	75 1b                	jne    3511 <sbrktest+0x49b>
    printf(stdout, "failed sbrk leaked memory\n");
    34f6:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    34fb:	83 ec 08             	sub    $0x8,%esp
    34fe:	68 0e 59 00 00       	push   $0x590e
    3503:	50                   	push   %eax
    3504:	e8 02 0b 00 00       	call   400b <printf>
    3509:	83 c4 10             	add    $0x10,%esp
    exit();
    350c:	e8 8b 09 00 00       	call   3e9c <exit>
  }

  if(sbrk(0) > oldbrk)
    3511:	83 ec 0c             	sub    $0xc,%esp
    3514:	6a 00                	push   $0x0
    3516:	e8 09 0a 00 00       	call   3f24 <sbrk>
    351b:	83 c4 10             	add    $0x10,%esp
    351e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    3521:	76 22                	jbe    3545 <sbrktest+0x4cf>
    sbrk(-(sbrk(0) - oldbrk));
    3523:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    3526:	83 ec 0c             	sub    $0xc,%esp
    3529:	6a 00                	push   $0x0
    352b:	e8 f4 09 00 00       	call   3f24 <sbrk>
    3530:	83 c4 10             	add    $0x10,%esp
    3533:	89 da                	mov    %ebx,%edx
    3535:	29 c2                	sub    %eax,%edx
    3537:	89 d0                	mov    %edx,%eax
    3539:	83 ec 0c             	sub    $0xc,%esp
    353c:	50                   	push   %eax
    353d:	e8 e2 09 00 00       	call   3f24 <sbrk>
    3542:	83 c4 10             	add    $0x10,%esp

  printf(stdout, "sbrk test OK\n");
    3545:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    354a:	83 ec 08             	sub    $0x8,%esp
    354d:	68 29 59 00 00       	push   $0x5929
    3552:	50                   	push   %eax
    3553:	e8 b3 0a 00 00       	call   400b <printf>
    3558:	83 c4 10             	add    $0x10,%esp
}
    355b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    355e:	c9                   	leave  
    355f:	c3                   	ret    

00003560 <validateint>:

void
validateint(int *p)
{
    3560:	55                   	push   %ebp
    3561:	89 e5                	mov    %esp,%ebp
    3563:	56                   	push   %esi
    3564:	53                   	push   %ebx
    3565:	83 ec 14             	sub    $0x14,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    3568:	c7 45 e4 0d 00 00 00 	movl   $0xd,-0x1c(%ebp)
    356f:	8b 55 08             	mov    0x8(%ebp),%edx
    3572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3575:	89 d1                	mov    %edx,%ecx
    3577:	89 e3                	mov    %esp,%ebx
    3579:	89 cc                	mov    %ecx,%esp
    357b:	cd 40                	int    $0x40
    357d:	89 dc                	mov    %ebx,%esp
    357f:	89 c6                	mov    %eax,%esi
    3581:	89 75 f4             	mov    %esi,-0xc(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    3584:	83 c4 14             	add    $0x14,%esp
    3587:	5b                   	pop    %ebx
    3588:	5e                   	pop    %esi
    3589:	c9                   	leave  
    358a:	c3                   	ret    

0000358b <validatetest>:

void
validatetest(void)
{
    358b:	55                   	push   %ebp
    358c:	89 e5                	mov    %esp,%ebp
    358e:	83 ec 18             	sub    $0x18,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    3591:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    3596:	83 ec 08             	sub    $0x8,%esp
    3599:	68 37 59 00 00       	push   $0x5937
    359e:	50                   	push   %eax
    359f:	e8 67 0a 00 00       	call   400b <printf>
    35a4:	83 c4 10             	add    $0x10,%esp
  hi = 1100*1024;
    35a7:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    35ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    35b5:	e9 8a 00 00 00       	jmp    3644 <validatetest+0xb9>
    if((pid = fork()) == 0){
    35ba:	e8 d5 08 00 00       	call   3e94 <fork>
    35bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    35c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    35c6:	75 14                	jne    35dc <validatetest+0x51>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    35c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    35cb:	83 ec 0c             	sub    $0xc,%esp
    35ce:	50                   	push   %eax
    35cf:	e8 8c ff ff ff       	call   3560 <validateint>
    35d4:	83 c4 10             	add    $0x10,%esp
      exit();
    35d7:	e8 c0 08 00 00       	call   3e9c <exit>
    }
    sleep(0);
    35dc:	83 ec 0c             	sub    $0xc,%esp
    35df:	6a 00                	push   $0x0
    35e1:	e8 46 09 00 00       	call   3f2c <sleep>
    35e6:	83 c4 10             	add    $0x10,%esp
    sleep(0);
    35e9:	83 ec 0c             	sub    $0xc,%esp
    35ec:	6a 00                	push   $0x0
    35ee:	e8 39 09 00 00       	call   3f2c <sleep>
    35f3:	83 c4 10             	add    $0x10,%esp
    kill(pid);
    35f6:	83 ec 0c             	sub    $0xc,%esp
    35f9:	ff 75 ec             	pushl  -0x14(%ebp)
    35fc:	e8 cb 08 00 00       	call   3ecc <kill>
    3601:	83 c4 10             	add    $0x10,%esp
    wait();
    3604:	e8 9b 08 00 00       	call   3ea4 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    3609:	8b 45 f4             	mov    -0xc(%ebp),%eax
    360c:	83 ec 08             	sub    $0x8,%esp
    360f:	50                   	push   %eax
    3610:	68 46 59 00 00       	push   $0x5946
    3615:	e8 e2 08 00 00       	call   3efc <link>
    361a:	83 c4 10             	add    $0x10,%esp
    361d:	83 f8 ff             	cmp    $0xffffffff,%eax
    3620:	74 1b                	je     363d <validatetest+0xb2>
      printf(stdout, "link should not succeed\n");
    3622:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    3627:	83 ec 08             	sub    $0x8,%esp
    362a:	68 51 59 00 00       	push   $0x5951
    362f:	50                   	push   %eax
    3630:	e8 d6 09 00 00       	call   400b <printf>
    3635:	83 c4 10             	add    $0x10,%esp
      exit();
    3638:	e8 5f 08 00 00       	call   3e9c <exit>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    363d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    3644:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3647:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    364a:	0f 83 6a ff ff ff    	jae    35ba <validatetest+0x2f>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    3650:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    3655:	83 ec 08             	sub    $0x8,%esp
    3658:	68 6a 59 00 00       	push   $0x596a
    365d:	50                   	push   %eax
    365e:	e8 a8 09 00 00       	call   400b <printf>
    3663:	83 c4 10             	add    $0x10,%esp
}
    3666:	c9                   	leave  
    3667:	c3                   	ret    

00003668 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    3668:	55                   	push   %ebp
    3669:	89 e5                	mov    %esp,%ebp
    366b:	83 ec 18             	sub    $0x18,%esp
  int i;

  printf(stdout, "bss test\n");
    366e:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    3673:	83 ec 08             	sub    $0x8,%esp
    3676:	68 77 59 00 00       	push   $0x5977
    367b:	50                   	push   %eax
    367c:	e8 8a 09 00 00       	call   400b <printf>
    3681:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    3684:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    368b:	eb 2c                	jmp    36b9 <bsstest+0x51>
    if(uninit[i] != '\0'){
    368d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3690:	05 80 5c 00 00       	add    $0x5c80,%eax
    3695:	8a 00                	mov    (%eax),%al
    3697:	84 c0                	test   %al,%al
    3699:	74 1b                	je     36b6 <bsstest+0x4e>
      printf(stdout, "bss test failed\n");
    369b:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    36a0:	83 ec 08             	sub    $0x8,%esp
    36a3:	68 81 59 00 00       	push   $0x5981
    36a8:	50                   	push   %eax
    36a9:	e8 5d 09 00 00       	call   400b <printf>
    36ae:	83 c4 10             	add    $0x10,%esp
      exit();
    36b1:	e8 e6 07 00 00       	call   3e9c <exit>
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    36b6:	ff 45 f4             	incl   -0xc(%ebp)
    36b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    36bc:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    36c1:	76 ca                	jbe    368d <bsstest+0x25>
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    36c3:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    36c8:	83 ec 08             	sub    $0x8,%esp
    36cb:	68 92 59 00 00       	push   $0x5992
    36d0:	50                   	push   %eax
    36d1:	e8 35 09 00 00       	call   400b <printf>
    36d6:	83 c4 10             	add    $0x10,%esp
}
    36d9:	c9                   	leave  
    36da:	c3                   	ret    

000036db <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    36db:	55                   	push   %ebp
    36dc:	89 e5                	mov    %esp,%ebp
    36de:	83 ec 18             	sub    $0x18,%esp
  int pid, fd;

  unlink("bigarg-ok");
    36e1:	83 ec 0c             	sub    $0xc,%esp
    36e4:	68 9f 59 00 00       	push   $0x599f
    36e9:	e8 fe 07 00 00       	call   3eec <unlink>
    36ee:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    36f1:	e8 9e 07 00 00       	call   3e94 <fork>
    36f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    36f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    36fd:	0f 85 96 00 00 00    	jne    3799 <bigargtest+0xbe>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    3703:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    370a:	eb 11                	jmp    371d <bigargtest+0x42>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    370c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    370f:	c7 04 85 e0 5b 00 00 	movl   $0x59ac,0x5be0(,%eax,4)
    3716:	ac 59 00 00 
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    371a:	ff 45 f4             	incl   -0xc(%ebp)
    371d:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    3721:	7e e9                	jle    370c <bigargtest+0x31>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    3723:	c7 05 5c 5c 00 00 00 	movl   $0x0,0x5c5c
    372a:	00 00 00 
    printf(stdout, "bigarg test\n");
    372d:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    3732:	83 ec 08             	sub    $0x8,%esp
    3735:	68 89 5a 00 00       	push   $0x5a89
    373a:	50                   	push   %eax
    373b:	e8 cb 08 00 00       	call   400b <printf>
    3740:	83 c4 10             	add    $0x10,%esp
    exec("echo", args);
    3743:	83 ec 08             	sub    $0x8,%esp
    3746:	68 e0 5b 00 00       	push   $0x5be0
    374b:	68 b4 43 00 00       	push   $0x43b4
    3750:	e8 7f 07 00 00       	call   3ed4 <exec>
    3755:	83 c4 10             	add    $0x10,%esp
    printf(stdout, "bigarg test ok\n");
    3758:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    375d:	83 ec 08             	sub    $0x8,%esp
    3760:	68 96 5a 00 00       	push   $0x5a96
    3765:	50                   	push   %eax
    3766:	e8 a0 08 00 00       	call   400b <printf>
    376b:	83 c4 10             	add    $0x10,%esp
    fd = open("bigarg-ok", O_CREATE);
    376e:	83 ec 08             	sub    $0x8,%esp
    3771:	68 00 02 00 00       	push   $0x200
    3776:	68 9f 59 00 00       	push   $0x599f
    377b:	e8 5c 07 00 00       	call   3edc <open>
    3780:	83 c4 10             	add    $0x10,%esp
    3783:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    3786:	83 ec 0c             	sub    $0xc,%esp
    3789:	ff 75 ec             	pushl  -0x14(%ebp)
    378c:	e8 33 07 00 00       	call   3ec4 <close>
    3791:	83 c4 10             	add    $0x10,%esp
    exit();
    3794:	e8 03 07 00 00       	call   3e9c <exit>
  } else if(pid < 0){
    3799:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    379d:	79 1b                	jns    37ba <bigargtest+0xdf>
    printf(stdout, "bigargtest: fork failed\n");
    379f:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    37a4:	83 ec 08             	sub    $0x8,%esp
    37a7:	68 a6 5a 00 00       	push   $0x5aa6
    37ac:	50                   	push   %eax
    37ad:	e8 59 08 00 00       	call   400b <printf>
    37b2:	83 c4 10             	add    $0x10,%esp
    exit();
    37b5:	e8 e2 06 00 00       	call   3e9c <exit>
  }
  wait();
    37ba:	e8 e5 06 00 00       	call   3ea4 <wait>
  fd = open("bigarg-ok", 0);
    37bf:	83 ec 08             	sub    $0x8,%esp
    37c2:	6a 00                	push   $0x0
    37c4:	68 9f 59 00 00       	push   $0x599f
    37c9:	e8 0e 07 00 00       	call   3edc <open>
    37ce:	83 c4 10             	add    $0x10,%esp
    37d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    37d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    37d8:	79 1b                	jns    37f5 <bigargtest+0x11a>
    printf(stdout, "bigarg test failed!\n");
    37da:	a1 ac 5b 00 00       	mov    0x5bac,%eax
    37df:	83 ec 08             	sub    $0x8,%esp
    37e2:	68 bf 5a 00 00       	push   $0x5abf
    37e7:	50                   	push   %eax
    37e8:	e8 1e 08 00 00       	call   400b <printf>
    37ed:	83 c4 10             	add    $0x10,%esp
    exit();
    37f0:	e8 a7 06 00 00       	call   3e9c <exit>
  }
  close(fd);
    37f5:	83 ec 0c             	sub    $0xc,%esp
    37f8:	ff 75 ec             	pushl  -0x14(%ebp)
    37fb:	e8 c4 06 00 00       	call   3ec4 <close>
    3800:	83 c4 10             	add    $0x10,%esp
  unlink("bigarg-ok");
    3803:	83 ec 0c             	sub    $0xc,%esp
    3806:	68 9f 59 00 00       	push   $0x599f
    380b:	e8 dc 06 00 00       	call   3eec <unlink>
    3810:	83 c4 10             	add    $0x10,%esp
}
    3813:	c9                   	leave  
    3814:	c3                   	ret    

00003815 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    3815:	55                   	push   %ebp
    3816:	89 e5                	mov    %esp,%ebp
    3818:	53                   	push   %ebx
    3819:	83 ec 64             	sub    $0x64,%esp
  int nfiles;
  int fsblocks = 0;
    381c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    3823:	83 ec 08             	sub    $0x8,%esp
    3826:	68 d4 5a 00 00       	push   $0x5ad4
    382b:	6a 01                	push   $0x1
    382d:	e8 d9 07 00 00       	call   400b <printf>
    3832:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    3835:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    383c:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3840:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3843:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    3848:	f7 e9                	imul   %ecx
    384a:	c1 fa 06             	sar    $0x6,%edx
    384d:	89 c8                	mov    %ecx,%eax
    384f:	c1 f8 1f             	sar    $0x1f,%eax
    3852:	89 d1                	mov    %edx,%ecx
    3854:	29 c1                	sub    %eax,%ecx
    3856:	89 c8                	mov    %ecx,%eax
    3858:	83 c0 30             	add    $0x30,%eax
    385b:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    385e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3861:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    3866:	f7 eb                	imul   %ebx
    3868:	c1 fa 06             	sar    $0x6,%edx
    386b:	89 d8                	mov    %ebx,%eax
    386d:	c1 f8 1f             	sar    $0x1f,%eax
    3870:	89 d1                	mov    %edx,%ecx
    3872:	29 c1                	sub    %eax,%ecx
    3874:	89 c8                	mov    %ecx,%eax
    3876:	c1 e0 02             	shl    $0x2,%eax
    3879:	01 c8                	add    %ecx,%eax
    387b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3882:	01 d0                	add    %edx,%eax
    3884:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    388b:	01 d0                	add    %edx,%eax
    388d:	c1 e0 03             	shl    $0x3,%eax
    3890:	89 d9                	mov    %ebx,%ecx
    3892:	29 c1                	sub    %eax,%ecx
    3894:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3899:	f7 e9                	imul   %ecx
    389b:	c1 fa 05             	sar    $0x5,%edx
    389e:	89 c8                	mov    %ecx,%eax
    38a0:	c1 f8 1f             	sar    $0x1f,%eax
    38a3:	89 d1                	mov    %edx,%ecx
    38a5:	29 c1                	sub    %eax,%ecx
    38a7:	89 c8                	mov    %ecx,%eax
    38a9:	83 c0 30             	add    $0x30,%eax
    38ac:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    38af:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    38b2:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    38b7:	f7 eb                	imul   %ebx
    38b9:	c1 fa 05             	sar    $0x5,%edx
    38bc:	89 d8                	mov    %ebx,%eax
    38be:	c1 f8 1f             	sar    $0x1f,%eax
    38c1:	89 d1                	mov    %edx,%ecx
    38c3:	29 c1                	sub    %eax,%ecx
    38c5:	89 c8                	mov    %ecx,%eax
    38c7:	c1 e0 02             	shl    $0x2,%eax
    38ca:	01 c8                	add    %ecx,%eax
    38cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    38d3:	01 d0                	add    %edx,%eax
    38d5:	c1 e0 02             	shl    $0x2,%eax
    38d8:	89 d9                	mov    %ebx,%ecx
    38da:	29 c1                	sub    %eax,%ecx
    38dc:	ba 67 66 66 66       	mov    $0x66666667,%edx
    38e1:	89 c8                	mov    %ecx,%eax
    38e3:	f7 ea                	imul   %edx
    38e5:	c1 fa 02             	sar    $0x2,%edx
    38e8:	89 c8                	mov    %ecx,%eax
    38ea:	c1 f8 1f             	sar    $0x1f,%eax
    38ed:	89 d1                	mov    %edx,%ecx
    38ef:	29 c1                	sub    %eax,%ecx
    38f1:	89 c8                	mov    %ecx,%eax
    38f3:	83 c0 30             	add    $0x30,%eax
    38f6:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    38f9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    38fc:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3901:	89 c8                	mov    %ecx,%eax
    3903:	f7 ea                	imul   %edx
    3905:	c1 fa 02             	sar    $0x2,%edx
    3908:	89 c8                	mov    %ecx,%eax
    390a:	c1 f8 1f             	sar    $0x1f,%eax
    390d:	29 c2                	sub    %eax,%edx
    390f:	89 d0                	mov    %edx,%eax
    3911:	c1 e0 02             	shl    $0x2,%eax
    3914:	01 d0                	add    %edx,%eax
    3916:	d1 e0                	shl    %eax
    3918:	89 ca                	mov    %ecx,%edx
    391a:	29 c2                	sub    %eax,%edx
    391c:	88 d0                	mov    %dl,%al
    391e:	83 c0 30             	add    $0x30,%eax
    3921:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3924:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    3928:	83 ec 04             	sub    $0x4,%esp
    392b:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    392e:	50                   	push   %eax
    392f:	68 e1 5a 00 00       	push   $0x5ae1
    3934:	6a 01                	push   $0x1
    3936:	e8 d0 06 00 00       	call   400b <printf>
    393b:	83 c4 10             	add    $0x10,%esp
    int fd = open(name, O_CREATE|O_RDWR);
    393e:	83 ec 08             	sub    $0x8,%esp
    3941:	68 02 02 00 00       	push   $0x202
    3946:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3949:	50                   	push   %eax
    394a:	e8 8d 05 00 00       	call   3edc <open>
    394f:	83 c4 10             	add    $0x10,%esp
    3952:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    3955:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3959:	79 18                	jns    3973 <fsfull+0x15e>
      printf(1, "open %s failed\n", name);
    395b:	83 ec 04             	sub    $0x4,%esp
    395e:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3961:	50                   	push   %eax
    3962:	68 ed 5a 00 00       	push   $0x5aed
    3967:	6a 01                	push   $0x1
    3969:	e8 9d 06 00 00       	call   400b <printf>
    396e:	83 c4 10             	add    $0x10,%esp
      break;
    3971:	eb 6b                	jmp    39de <fsfull+0x1c9>
    }
    int total = 0;
    3973:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    397a:	83 ec 04             	sub    $0x4,%esp
    397d:	68 00 02 00 00       	push   $0x200
    3982:	68 a0 83 00 00       	push   $0x83a0
    3987:	ff 75 e8             	pushl  -0x18(%ebp)
    398a:	e8 2d 05 00 00       	call   3ebc <write>
    398f:	83 c4 10             	add    $0x10,%esp
    3992:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    3995:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    399c:	7f 2b                	jg     39c9 <fsfull+0x1b4>
        break;
      total += cc;
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    399e:	83 ec 04             	sub    $0x4,%esp
    39a1:	ff 75 ec             	pushl  -0x14(%ebp)
    39a4:	68 fd 5a 00 00       	push   $0x5afd
    39a9:	6a 01                	push   $0x1
    39ab:	e8 5b 06 00 00       	call   400b <printf>
    39b0:	83 c4 10             	add    $0x10,%esp
    close(fd);
    39b3:	83 ec 0c             	sub    $0xc,%esp
    39b6:	ff 75 e8             	pushl  -0x18(%ebp)
    39b9:	e8 06 05 00 00       	call   3ec4 <close>
    39be:	83 c4 10             	add    $0x10,%esp
    if(total == 0)
    39c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    39c5:	74 0d                	je     39d4 <fsfull+0x1bf>
    39c7:	eb 0d                	jmp    39d6 <fsfull+0x1c1>
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
      if(cc < 512)
        break;
      total += cc;
    39c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    39cc:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    39cf:	ff 45 f0             	incl   -0x10(%ebp)
    }
    39d2:	eb a6                	jmp    397a <fsfull+0x165>
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
    39d4:	eb 08                	jmp    39de <fsfull+0x1c9>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    39d6:	ff 45 f4             	incl   -0xc(%ebp)
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
    39d9:	e9 5e fe ff ff       	jmp    383c <fsfull+0x27>

  while(nfiles >= 0){
    39de:	e9 fe 00 00 00       	jmp    3ae1 <fsfull+0x2cc>
    char name[64];
    name[0] = 'f';
    39e3:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    39e7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    39ea:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    39ef:	f7 e9                	imul   %ecx
    39f1:	c1 fa 06             	sar    $0x6,%edx
    39f4:	89 c8                	mov    %ecx,%eax
    39f6:	c1 f8 1f             	sar    $0x1f,%eax
    39f9:	89 d1                	mov    %edx,%ecx
    39fb:	29 c1                	sub    %eax,%ecx
    39fd:	89 c8                	mov    %ecx,%eax
    39ff:	83 c0 30             	add    $0x30,%eax
    3a02:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3a05:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a08:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    3a0d:	f7 eb                	imul   %ebx
    3a0f:	c1 fa 06             	sar    $0x6,%edx
    3a12:	89 d8                	mov    %ebx,%eax
    3a14:	c1 f8 1f             	sar    $0x1f,%eax
    3a17:	89 d1                	mov    %edx,%ecx
    3a19:	29 c1                	sub    %eax,%ecx
    3a1b:	89 c8                	mov    %ecx,%eax
    3a1d:	c1 e0 02             	shl    $0x2,%eax
    3a20:	01 c8                	add    %ecx,%eax
    3a22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3a29:	01 d0                	add    %edx,%eax
    3a2b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3a32:	01 d0                	add    %edx,%eax
    3a34:	c1 e0 03             	shl    $0x3,%eax
    3a37:	89 d9                	mov    %ebx,%ecx
    3a39:	29 c1                	sub    %eax,%ecx
    3a3b:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3a40:	f7 e9                	imul   %ecx
    3a42:	c1 fa 05             	sar    $0x5,%edx
    3a45:	89 c8                	mov    %ecx,%eax
    3a47:	c1 f8 1f             	sar    $0x1f,%eax
    3a4a:	89 d1                	mov    %edx,%ecx
    3a4c:	29 c1                	sub    %eax,%ecx
    3a4e:	89 c8                	mov    %ecx,%eax
    3a50:	83 c0 30             	add    $0x30,%eax
    3a53:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3a56:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a59:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3a5e:	f7 eb                	imul   %ebx
    3a60:	c1 fa 05             	sar    $0x5,%edx
    3a63:	89 d8                	mov    %ebx,%eax
    3a65:	c1 f8 1f             	sar    $0x1f,%eax
    3a68:	89 d1                	mov    %edx,%ecx
    3a6a:	29 c1                	sub    %eax,%ecx
    3a6c:	89 c8                	mov    %ecx,%eax
    3a6e:	c1 e0 02             	shl    $0x2,%eax
    3a71:	01 c8                	add    %ecx,%eax
    3a73:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3a7a:	01 d0                	add    %edx,%eax
    3a7c:	c1 e0 02             	shl    $0x2,%eax
    3a7f:	89 d9                	mov    %ebx,%ecx
    3a81:	29 c1                	sub    %eax,%ecx
    3a83:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3a88:	89 c8                	mov    %ecx,%eax
    3a8a:	f7 ea                	imul   %edx
    3a8c:	c1 fa 02             	sar    $0x2,%edx
    3a8f:	89 c8                	mov    %ecx,%eax
    3a91:	c1 f8 1f             	sar    $0x1f,%eax
    3a94:	89 d1                	mov    %edx,%ecx
    3a96:	29 c1                	sub    %eax,%ecx
    3a98:	89 c8                	mov    %ecx,%eax
    3a9a:	83 c0 30             	add    $0x30,%eax
    3a9d:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3aa0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3aa3:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3aa8:	89 c8                	mov    %ecx,%eax
    3aaa:	f7 ea                	imul   %edx
    3aac:	c1 fa 02             	sar    $0x2,%edx
    3aaf:	89 c8                	mov    %ecx,%eax
    3ab1:	c1 f8 1f             	sar    $0x1f,%eax
    3ab4:	29 c2                	sub    %eax,%edx
    3ab6:	89 d0                	mov    %edx,%eax
    3ab8:	c1 e0 02             	shl    $0x2,%eax
    3abb:	01 d0                	add    %edx,%eax
    3abd:	d1 e0                	shl    %eax
    3abf:	89 ca                	mov    %ecx,%edx
    3ac1:	29 c2                	sub    %eax,%edx
    3ac3:	88 d0                	mov    %dl,%al
    3ac5:	83 c0 30             	add    $0x30,%eax
    3ac8:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3acb:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    3acf:	83 ec 0c             	sub    $0xc,%esp
    3ad2:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3ad5:	50                   	push   %eax
    3ad6:	e8 11 04 00 00       	call   3eec <unlink>
    3adb:	83 c4 10             	add    $0x10,%esp
    nfiles--;
    3ade:	ff 4d f4             	decl   -0xc(%ebp)
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3ae1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3ae5:	0f 89 f8 fe ff ff    	jns    39e3 <fsfull+0x1ce>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
    3aeb:	83 ec 08             	sub    $0x8,%esp
    3aee:	68 0d 5b 00 00       	push   $0x5b0d
    3af3:	6a 01                	push   $0x1
    3af5:	e8 11 05 00 00       	call   400b <printf>
    3afa:	83 c4 10             	add    $0x10,%esp
}
    3afd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3b00:	c9                   	leave  
    3b01:	c3                   	ret    

00003b02 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3b02:	55                   	push   %ebp
    3b03:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3b05:	8b 15 b0 5b 00 00    	mov    0x5bb0,%edx
    3b0b:	89 d0                	mov    %edx,%eax
    3b0d:	d1 e0                	shl    %eax
    3b0f:	01 d0                	add    %edx,%eax
    3b11:	c1 e0 02             	shl    $0x2,%eax
    3b14:	01 d0                	add    %edx,%eax
    3b16:	c1 e0 08             	shl    $0x8,%eax
    3b19:	01 d0                	add    %edx,%eax
    3b1b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    3b22:	01 c8                	add    %ecx,%eax
    3b24:	c1 e0 02             	shl    $0x2,%eax
    3b27:	01 d0                	add    %edx,%eax
    3b29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3b30:	01 d0                	add    %edx,%eax
    3b32:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3b39:	01 d0                	add    %edx,%eax
    3b3b:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3b40:	a3 b0 5b 00 00       	mov    %eax,0x5bb0
  return randstate;
    3b45:	a1 b0 5b 00 00       	mov    0x5bb0,%eax
}
    3b4a:	c9                   	leave  
    3b4b:	c3                   	ret    

00003b4c <main>:

int
main(int argc, char *argv[])
{
    3b4c:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    3b50:	83 e4 f0             	and    $0xfffffff0,%esp
    3b53:	ff 71 fc             	pushl  -0x4(%ecx)
    3b56:	55                   	push   %ebp
    3b57:	89 e5                	mov    %esp,%ebp
    3b59:	51                   	push   %ecx
    3b5a:	83 ec 04             	sub    $0x4,%esp
  printf(1, "usertests starting\n");
    3b5d:	83 ec 08             	sub    $0x8,%esp
    3b60:	68 23 5b 00 00       	push   $0x5b23
    3b65:	6a 01                	push   $0x1
    3b67:	e8 9f 04 00 00       	call   400b <printf>
    3b6c:	83 c4 10             	add    $0x10,%esp

  if(open("usertests.ran", 0) >= 0){
    3b6f:	83 ec 08             	sub    $0x8,%esp
    3b72:	6a 00                	push   $0x0
    3b74:	68 37 5b 00 00       	push   $0x5b37
    3b79:	e8 5e 03 00 00       	call   3edc <open>
    3b7e:	83 c4 10             	add    $0x10,%esp
    3b81:	85 c0                	test   %eax,%eax
    3b83:	78 17                	js     3b9c <main+0x50>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3b85:	83 ec 08             	sub    $0x8,%esp
    3b88:	68 48 5b 00 00       	push   $0x5b48
    3b8d:	6a 01                	push   $0x1
    3b8f:	e8 77 04 00 00       	call   400b <printf>
    3b94:	83 c4 10             	add    $0x10,%esp
    exit();
    3b97:	e8 00 03 00 00       	call   3e9c <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3b9c:	83 ec 08             	sub    $0x8,%esp
    3b9f:	68 00 02 00 00       	push   $0x200
    3ba4:	68 37 5b 00 00       	push   $0x5b37
    3ba9:	e8 2e 03 00 00       	call   3edc <open>
    3bae:	83 c4 10             	add    $0x10,%esp
    3bb1:	83 ec 0c             	sub    $0xc,%esp
    3bb4:	50                   	push   %eax
    3bb5:	e8 0a 03 00 00       	call   3ec4 <close>
    3bba:	83 c4 10             	add    $0x10,%esp

  createdelete();
    3bbd:	e8 c7 d6 ff ff       	call   1289 <createdelete>
  linkunlink();
    3bc2:	e8 84 e0 ff ff       	call   1c4b <linkunlink>
  concreate();
    3bc7:	e8 26 dd ff ff       	call   18f2 <concreate>
  fourfiles();
    3bcc:	e8 69 d4 ff ff       	call   103a <fourfiles>
  sharedfd();
    3bd1:	e8 8b d2 ff ff       	call   e61 <sharedfd>

  bigargtest();
    3bd6:	e8 00 fb ff ff       	call   36db <bigargtest>
  bigwrite();
    3bdb:	e8 6b ea ff ff       	call   264b <bigwrite>
  bigargtest();
    3be0:	e8 f6 fa ff ff       	call   36db <bigargtest>
  bsstest();
    3be5:	e8 7e fa ff ff       	call   3668 <bsstest>
  sbrktest();
    3bea:	e8 87 f4 ff ff       	call   3076 <sbrktest>
  validatetest();
    3bef:	e8 97 f9 ff ff       	call   358b <validatetest>

  opentest();
    3bf4:	e8 03 c7 ff ff       	call   2fc <opentest>
  writetest();
    3bf9:	e8 ac c7 ff ff       	call   3aa <writetest>
  writetest1();
    3bfe:	e8 b5 c9 ff ff       	call   5b8 <writetest1>
  createtest();
    3c03:	e8 aa cb ff ff       	call   7b2 <createtest>

  openiputtest();
    3c08:	e8 e1 c5 ff ff       	call   1ee <openiputtest>
  exitiputtest();
    3c0d:	e8 de c4 ff ff       	call   f0 <exitiputtest>
  iputtest();
    3c12:	e8 e9 c3 ff ff       	call   0 <iputtest>

  mem();
    3c17:	e8 55 d1 ff ff       	call   d71 <mem>
  pipe1();
    3c1c:	e8 93 cd ff ff       	call   9b4 <pipe1>
  preempt();
    3c21:	e8 71 cf ff ff       	call   b97 <preempt>
  exitwait();
    3c26:	e8 cf d0 ff ff       	call   cfa <exitwait>

  rmdot();
    3c2b:	e8 89 ee ff ff       	call   2ab9 <rmdot>
  fourteen();
    3c30:	e8 29 ed ff ff       	call   295e <fourteen>
  bigfile();
    3c35:	e8 0d eb ff ff       	call   2747 <bigfile>
  subdir();
    3c3a:	e8 cb e2 ff ff       	call   1f0a <subdir>
  linktest();
    3c3f:	e8 6d da ff ff       	call   16b1 <linktest>
  unlinkread();
    3c44:	e8 a9 d8 ff ff       	call   14f2 <unlinkread>
  dirfile();
    3c49:	e8 ef ef ff ff       	call   2c3d <dirfile>
  iref();
    3c4e:	e8 21 f2 ff ff       	call   2e74 <iref>
  forktest();
    3c53:	e8 54 f3 ff ff       	call   2fac <forktest>
  bigdir(); // slow
    3c58:	e8 37 e1 ff ff       	call   1d94 <bigdir>
  exectest();
    3c5d:	e8 00 cd ff ff       	call   962 <exectest>

  exit();
    3c62:	e8 35 02 00 00       	call   3e9c <exit>
    3c67:	90                   	nop

00003c68 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    3c68:	55                   	push   %ebp
    3c69:	89 e5                	mov    %esp,%ebp
    3c6b:	57                   	push   %edi
    3c6c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    3c6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3c70:	8b 55 10             	mov    0x10(%ebp),%edx
    3c73:	8b 45 0c             	mov    0xc(%ebp),%eax
    3c76:	89 cb                	mov    %ecx,%ebx
    3c78:	89 df                	mov    %ebx,%edi
    3c7a:	89 d1                	mov    %edx,%ecx
    3c7c:	fc                   	cld    
    3c7d:	f3 aa                	rep stos %al,%es:(%edi)
    3c7f:	89 ca                	mov    %ecx,%edx
    3c81:	89 fb                	mov    %edi,%ebx
    3c83:	89 5d 08             	mov    %ebx,0x8(%ebp)
    3c86:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    3c89:	5b                   	pop    %ebx
    3c8a:	5f                   	pop    %edi
    3c8b:	c9                   	leave  
    3c8c:	c3                   	ret    

00003c8d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    3c8d:	55                   	push   %ebp
    3c8e:	89 e5                	mov    %esp,%ebp
    3c90:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    3c93:	8b 45 08             	mov    0x8(%ebp),%eax
    3c96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3c99:	90                   	nop
    3c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3c9d:	8a 10                	mov    (%eax),%dl
    3c9f:	8b 45 08             	mov    0x8(%ebp),%eax
    3ca2:	88 10                	mov    %dl,(%eax)
    3ca4:	8b 45 08             	mov    0x8(%ebp),%eax
    3ca7:	8a 00                	mov    (%eax),%al
    3ca9:	84 c0                	test   %al,%al
    3cab:	0f 95 c0             	setne  %al
    3cae:	ff 45 08             	incl   0x8(%ebp)
    3cb1:	ff 45 0c             	incl   0xc(%ebp)
    3cb4:	84 c0                	test   %al,%al
    3cb6:	75 e2                	jne    3c9a <strcpy+0xd>
    ;
  return os;
    3cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3cbb:	c9                   	leave  
    3cbc:	c3                   	ret    

00003cbd <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3cbd:	55                   	push   %ebp
    3cbe:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3cc0:	eb 06                	jmp    3cc8 <strcmp+0xb>
    p++, q++;
    3cc2:	ff 45 08             	incl   0x8(%ebp)
    3cc5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    3cc8:	8b 45 08             	mov    0x8(%ebp),%eax
    3ccb:	8a 00                	mov    (%eax),%al
    3ccd:	84 c0                	test   %al,%al
    3ccf:	74 0e                	je     3cdf <strcmp+0x22>
    3cd1:	8b 45 08             	mov    0x8(%ebp),%eax
    3cd4:	8a 10                	mov    (%eax),%dl
    3cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cd9:	8a 00                	mov    (%eax),%al
    3cdb:	38 c2                	cmp    %al,%dl
    3cdd:	74 e3                	je     3cc2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    3cdf:	8b 45 08             	mov    0x8(%ebp),%eax
    3ce2:	8a 00                	mov    (%eax),%al
    3ce4:	0f b6 d0             	movzbl %al,%edx
    3ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cea:	8a 00                	mov    (%eax),%al
    3cec:	0f b6 c0             	movzbl %al,%eax
    3cef:	89 d1                	mov    %edx,%ecx
    3cf1:	29 c1                	sub    %eax,%ecx
    3cf3:	89 c8                	mov    %ecx,%eax
}
    3cf5:	c9                   	leave  
    3cf6:	c3                   	ret    

00003cf7 <strlen>:

uint
strlen(char *s)
{
    3cf7:	55                   	push   %ebp
    3cf8:	89 e5                	mov    %esp,%ebp
    3cfa:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3cfd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3d04:	eb 03                	jmp    3d09 <strlen+0x12>
    3d06:	ff 45 fc             	incl   -0x4(%ebp)
    3d09:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3d0c:	03 45 08             	add    0x8(%ebp),%eax
    3d0f:	8a 00                	mov    (%eax),%al
    3d11:	84 c0                	test   %al,%al
    3d13:	75 f1                	jne    3d06 <strlen+0xf>
    ;
  return n;
    3d15:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3d18:	c9                   	leave  
    3d19:	c3                   	ret    

00003d1a <memset>:

void*
memset(void *dst, int c, uint n)
{
    3d1a:	55                   	push   %ebp
    3d1b:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    3d1d:	8b 45 10             	mov    0x10(%ebp),%eax
    3d20:	50                   	push   %eax
    3d21:	ff 75 0c             	pushl  0xc(%ebp)
    3d24:	ff 75 08             	pushl  0x8(%ebp)
    3d27:	e8 3c ff ff ff       	call   3c68 <stosb>
    3d2c:	83 c4 0c             	add    $0xc,%esp
  return dst;
    3d2f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3d32:	c9                   	leave  
    3d33:	c3                   	ret    

00003d34 <strchr>:

char*
strchr(const char *s, char c)
{
    3d34:	55                   	push   %ebp
    3d35:	89 e5                	mov    %esp,%ebp
    3d37:	83 ec 04             	sub    $0x4,%esp
    3d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d3d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3d40:	eb 12                	jmp    3d54 <strchr+0x20>
    if(*s == c)
    3d42:	8b 45 08             	mov    0x8(%ebp),%eax
    3d45:	8a 00                	mov    (%eax),%al
    3d47:	3a 45 fc             	cmp    -0x4(%ebp),%al
    3d4a:	75 05                	jne    3d51 <strchr+0x1d>
      return (char*)s;
    3d4c:	8b 45 08             	mov    0x8(%ebp),%eax
    3d4f:	eb 11                	jmp    3d62 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    3d51:	ff 45 08             	incl   0x8(%ebp)
    3d54:	8b 45 08             	mov    0x8(%ebp),%eax
    3d57:	8a 00                	mov    (%eax),%al
    3d59:	84 c0                	test   %al,%al
    3d5b:	75 e5                	jne    3d42 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    3d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3d62:	c9                   	leave  
    3d63:	c3                   	ret    

00003d64 <gets>:

char*
gets(char *buf, int max)
{
    3d64:	55                   	push   %ebp
    3d65:	89 e5                	mov    %esp,%ebp
    3d67:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3d6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3d71:	eb 38                	jmp    3dab <gets+0x47>
    cc = read(0, &c, 1);
    3d73:	83 ec 04             	sub    $0x4,%esp
    3d76:	6a 01                	push   $0x1
    3d78:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3d7b:	50                   	push   %eax
    3d7c:	6a 00                	push   $0x0
    3d7e:	e8 31 01 00 00       	call   3eb4 <read>
    3d83:	83 c4 10             	add    $0x10,%esp
    3d86:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3d89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3d8d:	7e 27                	jle    3db6 <gets+0x52>
      break;
    buf[i++] = c;
    3d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d92:	03 45 08             	add    0x8(%ebp),%eax
    3d95:	8a 55 ef             	mov    -0x11(%ebp),%dl
    3d98:	88 10                	mov    %dl,(%eax)
    3d9a:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
    3d9d:	8a 45 ef             	mov    -0x11(%ebp),%al
    3da0:	3c 0a                	cmp    $0xa,%al
    3da2:	74 13                	je     3db7 <gets+0x53>
    3da4:	8a 45 ef             	mov    -0x11(%ebp),%al
    3da7:	3c 0d                	cmp    $0xd,%al
    3da9:	74 0c                	je     3db7 <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3dae:	40                   	inc    %eax
    3daf:	3b 45 0c             	cmp    0xc(%ebp),%eax
    3db2:	7c bf                	jl     3d73 <gets+0xf>
    3db4:	eb 01                	jmp    3db7 <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    3db6:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    3db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3dba:	03 45 08             	add    0x8(%ebp),%eax
    3dbd:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3dc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3dc3:	c9                   	leave  
    3dc4:	c3                   	ret    

00003dc5 <stat>:

int
stat(char *n, struct stat *st)
{
    3dc5:	55                   	push   %ebp
    3dc6:	89 e5                	mov    %esp,%ebp
    3dc8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3dcb:	83 ec 08             	sub    $0x8,%esp
    3dce:	6a 00                	push   $0x0
    3dd0:	ff 75 08             	pushl  0x8(%ebp)
    3dd3:	e8 04 01 00 00       	call   3edc <open>
    3dd8:	83 c4 10             	add    $0x10,%esp
    3ddb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3dde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3de2:	79 07                	jns    3deb <stat+0x26>
    return -1;
    3de4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3de9:	eb 25                	jmp    3e10 <stat+0x4b>
  r = fstat(fd, st);
    3deb:	83 ec 08             	sub    $0x8,%esp
    3dee:	ff 75 0c             	pushl  0xc(%ebp)
    3df1:	ff 75 f4             	pushl  -0xc(%ebp)
    3df4:	e8 fb 00 00 00       	call   3ef4 <fstat>
    3df9:	83 c4 10             	add    $0x10,%esp
    3dfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3dff:	83 ec 0c             	sub    $0xc,%esp
    3e02:	ff 75 f4             	pushl  -0xc(%ebp)
    3e05:	e8 ba 00 00 00       	call   3ec4 <close>
    3e0a:	83 c4 10             	add    $0x10,%esp
  return r;
    3e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    3e10:	c9                   	leave  
    3e11:	c3                   	ret    

00003e12 <atoi>:

int
atoi(const char *s)
{
    3e12:	55                   	push   %ebp
    3e13:	89 e5                	mov    %esp,%ebp
    3e15:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3e18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3e1f:	eb 22                	jmp    3e43 <atoi+0x31>
    n = n*10 + *s++ - '0';
    3e21:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3e24:	89 d0                	mov    %edx,%eax
    3e26:	c1 e0 02             	shl    $0x2,%eax
    3e29:	01 d0                	add    %edx,%eax
    3e2b:	d1 e0                	shl    %eax
    3e2d:	89 c2                	mov    %eax,%edx
    3e2f:	8b 45 08             	mov    0x8(%ebp),%eax
    3e32:	8a 00                	mov    (%eax),%al
    3e34:	0f be c0             	movsbl %al,%eax
    3e37:	8d 04 02             	lea    (%edx,%eax,1),%eax
    3e3a:	83 e8 30             	sub    $0x30,%eax
    3e3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3e40:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3e43:	8b 45 08             	mov    0x8(%ebp),%eax
    3e46:	8a 00                	mov    (%eax),%al
    3e48:	3c 2f                	cmp    $0x2f,%al
    3e4a:	7e 09                	jle    3e55 <atoi+0x43>
    3e4c:	8b 45 08             	mov    0x8(%ebp),%eax
    3e4f:	8a 00                	mov    (%eax),%al
    3e51:	3c 39                	cmp    $0x39,%al
    3e53:	7e cc                	jle    3e21 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    3e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3e58:	c9                   	leave  
    3e59:	c3                   	ret    

00003e5a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3e5a:	55                   	push   %ebp
    3e5b:	89 e5                	mov    %esp,%ebp
    3e5d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    3e60:	8b 45 08             	mov    0x8(%ebp),%eax
    3e63:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    3e66:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e69:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    3e6c:	eb 10                	jmp    3e7e <memmove+0x24>
    *dst++ = *src++;
    3e6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3e71:	8a 10                	mov    (%eax),%dl
    3e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3e76:	88 10                	mov    %dl,(%eax)
    3e78:	ff 45 fc             	incl   -0x4(%ebp)
    3e7b:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3e7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    3e82:	0f 9f c0             	setg   %al
    3e85:	ff 4d 10             	decl   0x10(%ebp)
    3e88:	84 c0                	test   %al,%al
    3e8a:	75 e2                	jne    3e6e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    3e8c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3e8f:	c9                   	leave  
    3e90:	c3                   	ret    
    3e91:	90                   	nop
    3e92:	90                   	nop
    3e93:	90                   	nop

00003e94 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3e94:	b8 01 00 00 00       	mov    $0x1,%eax
    3e99:	cd 40                	int    $0x40
    3e9b:	c3                   	ret    

00003e9c <exit>:
SYSCALL(exit)
    3e9c:	b8 02 00 00 00       	mov    $0x2,%eax
    3ea1:	cd 40                	int    $0x40
    3ea3:	c3                   	ret    

00003ea4 <wait>:
SYSCALL(wait)
    3ea4:	b8 03 00 00 00       	mov    $0x3,%eax
    3ea9:	cd 40                	int    $0x40
    3eab:	c3                   	ret    

00003eac <pipe>:
SYSCALL(pipe)
    3eac:	b8 04 00 00 00       	mov    $0x4,%eax
    3eb1:	cd 40                	int    $0x40
    3eb3:	c3                   	ret    

00003eb4 <read>:
SYSCALL(read)
    3eb4:	b8 05 00 00 00       	mov    $0x5,%eax
    3eb9:	cd 40                	int    $0x40
    3ebb:	c3                   	ret    

00003ebc <write>:
SYSCALL(write)
    3ebc:	b8 10 00 00 00       	mov    $0x10,%eax
    3ec1:	cd 40                	int    $0x40
    3ec3:	c3                   	ret    

00003ec4 <close>:
SYSCALL(close)
    3ec4:	b8 15 00 00 00       	mov    $0x15,%eax
    3ec9:	cd 40                	int    $0x40
    3ecb:	c3                   	ret    

00003ecc <kill>:
SYSCALL(kill)
    3ecc:	b8 06 00 00 00       	mov    $0x6,%eax
    3ed1:	cd 40                	int    $0x40
    3ed3:	c3                   	ret    

00003ed4 <exec>:
SYSCALL(exec)
    3ed4:	b8 07 00 00 00       	mov    $0x7,%eax
    3ed9:	cd 40                	int    $0x40
    3edb:	c3                   	ret    

00003edc <open>:
SYSCALL(open)
    3edc:	b8 0f 00 00 00       	mov    $0xf,%eax
    3ee1:	cd 40                	int    $0x40
    3ee3:	c3                   	ret    

00003ee4 <mknod>:
SYSCALL(mknod)
    3ee4:	b8 11 00 00 00       	mov    $0x11,%eax
    3ee9:	cd 40                	int    $0x40
    3eeb:	c3                   	ret    

00003eec <unlink>:
SYSCALL(unlink)
    3eec:	b8 12 00 00 00       	mov    $0x12,%eax
    3ef1:	cd 40                	int    $0x40
    3ef3:	c3                   	ret    

00003ef4 <fstat>:
SYSCALL(fstat)
    3ef4:	b8 08 00 00 00       	mov    $0x8,%eax
    3ef9:	cd 40                	int    $0x40
    3efb:	c3                   	ret    

00003efc <link>:
SYSCALL(link)
    3efc:	b8 13 00 00 00       	mov    $0x13,%eax
    3f01:	cd 40                	int    $0x40
    3f03:	c3                   	ret    

00003f04 <mkdir>:
SYSCALL(mkdir)
    3f04:	b8 14 00 00 00       	mov    $0x14,%eax
    3f09:	cd 40                	int    $0x40
    3f0b:	c3                   	ret    

00003f0c <chdir>:
SYSCALL(chdir)
    3f0c:	b8 09 00 00 00       	mov    $0x9,%eax
    3f11:	cd 40                	int    $0x40
    3f13:	c3                   	ret    

00003f14 <dup>:
SYSCALL(dup)
    3f14:	b8 0a 00 00 00       	mov    $0xa,%eax
    3f19:	cd 40                	int    $0x40
    3f1b:	c3                   	ret    

00003f1c <getpid>:
SYSCALL(getpid)
    3f1c:	b8 0b 00 00 00       	mov    $0xb,%eax
    3f21:	cd 40                	int    $0x40
    3f23:	c3                   	ret    

00003f24 <sbrk>:
SYSCALL(sbrk)
    3f24:	b8 0c 00 00 00       	mov    $0xc,%eax
    3f29:	cd 40                	int    $0x40
    3f2b:	c3                   	ret    

00003f2c <sleep>:
SYSCALL(sleep)
    3f2c:	b8 0d 00 00 00       	mov    $0xd,%eax
    3f31:	cd 40                	int    $0x40
    3f33:	c3                   	ret    

00003f34 <uptime>:
SYSCALL(uptime)
    3f34:	b8 0e 00 00 00       	mov    $0xe,%eax
    3f39:	cd 40                	int    $0x40
    3f3b:	c3                   	ret    

00003f3c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    3f3c:	55                   	push   %ebp
    3f3d:	89 e5                	mov    %esp,%ebp
    3f3f:	83 ec 18             	sub    $0x18,%esp
    3f42:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f45:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    3f48:	83 ec 04             	sub    $0x4,%esp
    3f4b:	6a 01                	push   $0x1
    3f4d:	8d 45 f4             	lea    -0xc(%ebp),%eax
    3f50:	50                   	push   %eax
    3f51:	ff 75 08             	pushl  0x8(%ebp)
    3f54:	e8 63 ff ff ff       	call   3ebc <write>
    3f59:	83 c4 10             	add    $0x10,%esp
}
    3f5c:	c9                   	leave  
    3f5d:	c3                   	ret    

00003f5e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3f5e:	55                   	push   %ebp
    3f5f:	89 e5                	mov    %esp,%ebp
    3f61:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    3f64:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    3f6b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    3f6f:	74 17                	je     3f88 <printint+0x2a>
    3f71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    3f75:	79 11                	jns    3f88 <printint+0x2a>
    neg = 1;
    3f77:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    3f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f81:	f7 d8                	neg    %eax
    3f83:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3f86:	eb 06                	jmp    3f8e <printint+0x30>
  } else {
    x = xx;
    3f88:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    3f8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    3f95:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3f98:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3f9b:	ba 00 00 00 00       	mov    $0x0,%edx
    3fa0:	f7 f1                	div    %ecx
    3fa2:	89 d0                	mov    %edx,%eax
    3fa4:	8a 90 b4 5b 00 00    	mov    0x5bb4(%eax),%dl
    3faa:	8d 45 dc             	lea    -0x24(%ebp),%eax
    3fad:	03 45 f4             	add    -0xc(%ebp),%eax
    3fb0:	88 10                	mov    %dl,(%eax)
    3fb2:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
    3fb5:	8b 45 10             	mov    0x10(%ebp),%eax
    3fb8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3fbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3fbe:	ba 00 00 00 00       	mov    $0x0,%edx
    3fc3:	f7 75 d4             	divl   -0x2c(%ebp)
    3fc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3fc9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3fcd:	75 c6                	jne    3f95 <printint+0x37>
  if(neg)
    3fcf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3fd3:	74 2a                	je     3fff <printint+0xa1>
    buf[i++] = '-';
    3fd5:	8d 45 dc             	lea    -0x24(%ebp),%eax
    3fd8:	03 45 f4             	add    -0xc(%ebp),%eax
    3fdb:	c6 00 2d             	movb   $0x2d,(%eax)
    3fde:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
    3fe1:	eb 1d                	jmp    4000 <printint+0xa2>
    putc(fd, buf[i]);
    3fe3:	8d 45 dc             	lea    -0x24(%ebp),%eax
    3fe6:	03 45 f4             	add    -0xc(%ebp),%eax
    3fe9:	8a 00                	mov    (%eax),%al
    3feb:	0f be c0             	movsbl %al,%eax
    3fee:	83 ec 08             	sub    $0x8,%esp
    3ff1:	50                   	push   %eax
    3ff2:	ff 75 08             	pushl  0x8(%ebp)
    3ff5:	e8 42 ff ff ff       	call   3f3c <putc>
    3ffa:	83 c4 10             	add    $0x10,%esp
    3ffd:	eb 01                	jmp    4000 <printint+0xa2>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    3fff:	90                   	nop
    4000:	ff 4d f4             	decl   -0xc(%ebp)
    4003:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4007:	79 da                	jns    3fe3 <printint+0x85>
    putc(fd, buf[i]);
}
    4009:	c9                   	leave  
    400a:	c3                   	ret    

0000400b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    400b:	55                   	push   %ebp
    400c:	89 e5                	mov    %esp,%ebp
    400e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    4011:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    4018:	8d 45 0c             	lea    0xc(%ebp),%eax
    401b:	83 c0 04             	add    $0x4,%eax
    401e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    4021:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    4028:	e9 58 01 00 00       	jmp    4185 <printf+0x17a>
    c = fmt[i] & 0xff;
    402d:	8b 55 0c             	mov    0xc(%ebp),%edx
    4030:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4033:	8d 04 02             	lea    (%edx,%eax,1),%eax
    4036:	8a 00                	mov    (%eax),%al
    4038:	0f be c0             	movsbl %al,%eax
    403b:	25 ff 00 00 00       	and    $0xff,%eax
    4040:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    4043:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4047:	75 2c                	jne    4075 <printf+0x6a>
      if(c == '%'){
    4049:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    404d:	75 0c                	jne    405b <printf+0x50>
        state = '%';
    404f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    4056:	e9 27 01 00 00       	jmp    4182 <printf+0x177>
      } else {
        putc(fd, c);
    405b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    405e:	0f be c0             	movsbl %al,%eax
    4061:	83 ec 08             	sub    $0x8,%esp
    4064:	50                   	push   %eax
    4065:	ff 75 08             	pushl  0x8(%ebp)
    4068:	e8 cf fe ff ff       	call   3f3c <putc>
    406d:	83 c4 10             	add    $0x10,%esp
    4070:	e9 0d 01 00 00       	jmp    4182 <printf+0x177>
      }
    } else if(state == '%'){
    4075:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    4079:	0f 85 03 01 00 00    	jne    4182 <printf+0x177>
      if(c == 'd'){
    407f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    4083:	75 1e                	jne    40a3 <printf+0x98>
        printint(fd, *ap, 10, 1);
    4085:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4088:	8b 00                	mov    (%eax),%eax
    408a:	6a 01                	push   $0x1
    408c:	6a 0a                	push   $0xa
    408e:	50                   	push   %eax
    408f:	ff 75 08             	pushl  0x8(%ebp)
    4092:	e8 c7 fe ff ff       	call   3f5e <printint>
    4097:	83 c4 10             	add    $0x10,%esp
        ap++;
    409a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    409e:	e9 d8 00 00 00       	jmp    417b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    40a3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    40a7:	74 06                	je     40af <printf+0xa4>
    40a9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    40ad:	75 1e                	jne    40cd <printf+0xc2>
        printint(fd, *ap, 16, 0);
    40af:	8b 45 e8             	mov    -0x18(%ebp),%eax
    40b2:	8b 00                	mov    (%eax),%eax
    40b4:	6a 00                	push   $0x0
    40b6:	6a 10                	push   $0x10
    40b8:	50                   	push   %eax
    40b9:	ff 75 08             	pushl  0x8(%ebp)
    40bc:	e8 9d fe ff ff       	call   3f5e <printint>
    40c1:	83 c4 10             	add    $0x10,%esp
        ap++;
    40c4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    40c8:	e9 ae 00 00 00       	jmp    417b <printf+0x170>
      } else if(c == 's'){
    40cd:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    40d1:	75 43                	jne    4116 <printf+0x10b>
        s = (char*)*ap;
    40d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    40d6:	8b 00                	mov    (%eax),%eax
    40d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    40db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    40df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    40e3:	75 25                	jne    410a <printf+0xff>
          s = "(null)";
    40e5:	c7 45 f4 90 5b 00 00 	movl   $0x5b90,-0xc(%ebp)
        while(*s != 0){
    40ec:	eb 1d                	jmp    410b <printf+0x100>
          putc(fd, *s);
    40ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40f1:	8a 00                	mov    (%eax),%al
    40f3:	0f be c0             	movsbl %al,%eax
    40f6:	83 ec 08             	sub    $0x8,%esp
    40f9:	50                   	push   %eax
    40fa:	ff 75 08             	pushl  0x8(%ebp)
    40fd:	e8 3a fe ff ff       	call   3f3c <putc>
    4102:	83 c4 10             	add    $0x10,%esp
          s++;
    4105:	ff 45 f4             	incl   -0xc(%ebp)
    4108:	eb 01                	jmp    410b <printf+0x100>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    410a:	90                   	nop
    410b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    410e:	8a 00                	mov    (%eax),%al
    4110:	84 c0                	test   %al,%al
    4112:	75 da                	jne    40ee <printf+0xe3>
    4114:	eb 65                	jmp    417b <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    4116:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    411a:	75 1d                	jne    4139 <printf+0x12e>
        putc(fd, *ap);
    411c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    411f:	8b 00                	mov    (%eax),%eax
    4121:	0f be c0             	movsbl %al,%eax
    4124:	83 ec 08             	sub    $0x8,%esp
    4127:	50                   	push   %eax
    4128:	ff 75 08             	pushl  0x8(%ebp)
    412b:	e8 0c fe ff ff       	call   3f3c <putc>
    4130:	83 c4 10             	add    $0x10,%esp
        ap++;
    4133:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4137:	eb 42                	jmp    417b <printf+0x170>
      } else if(c == '%'){
    4139:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    413d:	75 17                	jne    4156 <printf+0x14b>
        putc(fd, c);
    413f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4142:	0f be c0             	movsbl %al,%eax
    4145:	83 ec 08             	sub    $0x8,%esp
    4148:	50                   	push   %eax
    4149:	ff 75 08             	pushl  0x8(%ebp)
    414c:	e8 eb fd ff ff       	call   3f3c <putc>
    4151:	83 c4 10             	add    $0x10,%esp
    4154:	eb 25                	jmp    417b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    4156:	83 ec 08             	sub    $0x8,%esp
    4159:	6a 25                	push   $0x25
    415b:	ff 75 08             	pushl  0x8(%ebp)
    415e:	e8 d9 fd ff ff       	call   3f3c <putc>
    4163:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    4166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4169:	0f be c0             	movsbl %al,%eax
    416c:	83 ec 08             	sub    $0x8,%esp
    416f:	50                   	push   %eax
    4170:	ff 75 08             	pushl  0x8(%ebp)
    4173:	e8 c4 fd ff ff       	call   3f3c <putc>
    4178:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    417b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    4182:	ff 45 f0             	incl   -0x10(%ebp)
    4185:	8b 55 0c             	mov    0xc(%ebp),%edx
    4188:	8b 45 f0             	mov    -0x10(%ebp),%eax
    418b:	8d 04 02             	lea    (%edx,%eax,1),%eax
    418e:	8a 00                	mov    (%eax),%al
    4190:	84 c0                	test   %al,%al
    4192:	0f 85 95 fe ff ff    	jne    402d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    4198:	c9                   	leave  
    4199:	c3                   	ret    
    419a:	90                   	nop
    419b:	90                   	nop

0000419c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    419c:	55                   	push   %ebp
    419d:	89 e5                	mov    %esp,%ebp
    419f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    41a2:	8b 45 08             	mov    0x8(%ebp),%eax
    41a5:	83 e8 08             	sub    $0x8,%eax
    41a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    41ab:	a1 68 5c 00 00       	mov    0x5c68,%eax
    41b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    41b3:	eb 24                	jmp    41d9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    41b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    41b8:	8b 00                	mov    (%eax),%eax
    41ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    41bd:	77 12                	ja     41d1 <free+0x35>
    41bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    41c2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    41c5:	77 24                	ja     41eb <free+0x4f>
    41c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    41ca:	8b 00                	mov    (%eax),%eax
    41cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    41cf:	77 1a                	ja     41eb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    41d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    41d4:	8b 00                	mov    (%eax),%eax
    41d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    41d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    41dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    41df:	76 d4                	jbe    41b5 <free+0x19>
    41e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    41e4:	8b 00                	mov    (%eax),%eax
    41e6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    41e9:	76 ca                	jbe    41b5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    41eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    41ee:	8b 40 04             	mov    0x4(%eax),%eax
    41f1:	c1 e0 03             	shl    $0x3,%eax
    41f4:	89 c2                	mov    %eax,%edx
    41f6:	03 55 f8             	add    -0x8(%ebp),%edx
    41f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    41fc:	8b 00                	mov    (%eax),%eax
    41fe:	39 c2                	cmp    %eax,%edx
    4200:	75 24                	jne    4226 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    4202:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4205:	8b 50 04             	mov    0x4(%eax),%edx
    4208:	8b 45 fc             	mov    -0x4(%ebp),%eax
    420b:	8b 00                	mov    (%eax),%eax
    420d:	8b 40 04             	mov    0x4(%eax),%eax
    4210:	01 c2                	add    %eax,%edx
    4212:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4215:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    4218:	8b 45 fc             	mov    -0x4(%ebp),%eax
    421b:	8b 00                	mov    (%eax),%eax
    421d:	8b 10                	mov    (%eax),%edx
    421f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4222:	89 10                	mov    %edx,(%eax)
    4224:	eb 0a                	jmp    4230 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    4226:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4229:	8b 10                	mov    (%eax),%edx
    422b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    422e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    4230:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4233:	8b 40 04             	mov    0x4(%eax),%eax
    4236:	c1 e0 03             	shl    $0x3,%eax
    4239:	03 45 fc             	add    -0x4(%ebp),%eax
    423c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    423f:	75 20                	jne    4261 <free+0xc5>
    p->s.size += bp->s.size;
    4241:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4244:	8b 50 04             	mov    0x4(%eax),%edx
    4247:	8b 45 f8             	mov    -0x8(%ebp),%eax
    424a:	8b 40 04             	mov    0x4(%eax),%eax
    424d:	01 c2                	add    %eax,%edx
    424f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4252:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    4255:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4258:	8b 10                	mov    (%eax),%edx
    425a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    425d:	89 10                	mov    %edx,(%eax)
    425f:	eb 08                	jmp    4269 <free+0xcd>
  } else
    p->s.ptr = bp;
    4261:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4264:	8b 55 f8             	mov    -0x8(%ebp),%edx
    4267:	89 10                	mov    %edx,(%eax)
  freep = p;
    4269:	8b 45 fc             	mov    -0x4(%ebp),%eax
    426c:	a3 68 5c 00 00       	mov    %eax,0x5c68
}
    4271:	c9                   	leave  
    4272:	c3                   	ret    

00004273 <morecore>:

static Header*
morecore(uint nu)
{
    4273:	55                   	push   %ebp
    4274:	89 e5                	mov    %esp,%ebp
    4276:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    4279:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    4280:	77 07                	ja     4289 <morecore+0x16>
    nu = 4096;
    4282:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    4289:	8b 45 08             	mov    0x8(%ebp),%eax
    428c:	c1 e0 03             	shl    $0x3,%eax
    428f:	83 ec 0c             	sub    $0xc,%esp
    4292:	50                   	push   %eax
    4293:	e8 8c fc ff ff       	call   3f24 <sbrk>
    4298:	83 c4 10             	add    $0x10,%esp
    429b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    429e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    42a2:	75 07                	jne    42ab <morecore+0x38>
    return 0;
    42a4:	b8 00 00 00 00       	mov    $0x0,%eax
    42a9:	eb 26                	jmp    42d1 <morecore+0x5e>
  hp = (Header*)p;
    42ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    42ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    42b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    42b4:	8b 55 08             	mov    0x8(%ebp),%edx
    42b7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    42ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
    42bd:	83 c0 08             	add    $0x8,%eax
    42c0:	83 ec 0c             	sub    $0xc,%esp
    42c3:	50                   	push   %eax
    42c4:	e8 d3 fe ff ff       	call   419c <free>
    42c9:	83 c4 10             	add    $0x10,%esp
  return freep;
    42cc:	a1 68 5c 00 00       	mov    0x5c68,%eax
}
    42d1:	c9                   	leave  
    42d2:	c3                   	ret    

000042d3 <malloc>:

void*
malloc(uint nbytes)
{
    42d3:	55                   	push   %ebp
    42d4:	89 e5                	mov    %esp,%ebp
    42d6:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    42d9:	8b 45 08             	mov    0x8(%ebp),%eax
    42dc:	83 c0 07             	add    $0x7,%eax
    42df:	c1 e8 03             	shr    $0x3,%eax
    42e2:	40                   	inc    %eax
    42e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    42e6:	a1 68 5c 00 00       	mov    0x5c68,%eax
    42eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    42ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    42f2:	75 23                	jne    4317 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    42f4:	c7 45 f0 60 5c 00 00 	movl   $0x5c60,-0x10(%ebp)
    42fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    42fe:	a3 68 5c 00 00       	mov    %eax,0x5c68
    4303:	a1 68 5c 00 00       	mov    0x5c68,%eax
    4308:	a3 60 5c 00 00       	mov    %eax,0x5c60
    base.s.size = 0;
    430d:	c7 05 64 5c 00 00 00 	movl   $0x0,0x5c64
    4314:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4317:	8b 45 f0             	mov    -0x10(%ebp),%eax
    431a:	8b 00                	mov    (%eax),%eax
    431c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    431f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4322:	8b 40 04             	mov    0x4(%eax),%eax
    4325:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    4328:	72 4d                	jb     4377 <malloc+0xa4>
      if(p->s.size == nunits)
    432a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    432d:	8b 40 04             	mov    0x4(%eax),%eax
    4330:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    4333:	75 0c                	jne    4341 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    4335:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4338:	8b 10                	mov    (%eax),%edx
    433a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    433d:	89 10                	mov    %edx,(%eax)
    433f:	eb 26                	jmp    4367 <malloc+0x94>
      else {
        p->s.size -= nunits;
    4341:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4344:	8b 40 04             	mov    0x4(%eax),%eax
    4347:	89 c2                	mov    %eax,%edx
    4349:	2b 55 ec             	sub    -0x14(%ebp),%edx
    434c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    434f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    4352:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4355:	8b 40 04             	mov    0x4(%eax),%eax
    4358:	c1 e0 03             	shl    $0x3,%eax
    435b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    435e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4361:	8b 55 ec             	mov    -0x14(%ebp),%edx
    4364:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    4367:	8b 45 f0             	mov    -0x10(%ebp),%eax
    436a:	a3 68 5c 00 00       	mov    %eax,0x5c68
      return (void*)(p + 1);
    436f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4372:	83 c0 08             	add    $0x8,%eax
    4375:	eb 3b                	jmp    43b2 <malloc+0xdf>
    }
    if(p == freep)
    4377:	a1 68 5c 00 00       	mov    0x5c68,%eax
    437c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    437f:	75 1e                	jne    439f <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
    4381:	83 ec 0c             	sub    $0xc,%esp
    4384:	ff 75 ec             	pushl  -0x14(%ebp)
    4387:	e8 e7 fe ff ff       	call   4273 <morecore>
    438c:	83 c4 10             	add    $0x10,%esp
    438f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    4392:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4396:	75 07                	jne    439f <malloc+0xcc>
        return 0;
    4398:	b8 00 00 00 00       	mov    $0x0,%eax
    439d:	eb 13                	jmp    43b2 <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    439f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    43a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43a8:	8b 00                	mov    (%eax),%eax
    43aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    43ad:	e9 6d ff ff ff       	jmp    431f <malloc+0x4c>
}
    43b2:	c9                   	leave  
    43b3:	c3                   	ret    
