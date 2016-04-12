
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 0b 38 10 80       	mov    $0x8010380b,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 64 84 10 80       	push   $0x80108464
80100042:	68 60 c6 10 80       	push   $0x8010c660
80100047:	e8 56 4f 00 00       	call   80104fa2 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 70 05 11 80 64 	movl   $0x80110564,0x80110570
80100056:	05 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 74 05 11 80 64 	movl   $0x80110564,0x80110574
80100060:	05 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 74 05 11 80    	mov    0x80110574,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 64 05 11 80 	movl   $0x80110564,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 74 05 11 80       	mov    0x80110574,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 74 05 11 80       	mov    %eax,0x80110574

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 64 05 11 80       	mov    $0x80110564,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b0:	c9                   	leave  
801000b1:	c3                   	ret    

801000b2 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b2:	55                   	push   %ebp
801000b3:	89 e5                	mov    %esp,%ebp
801000b5:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b8:	83 ec 0c             	sub    $0xc,%esp
801000bb:	68 60 c6 10 80       	push   $0x8010c660
801000c0:	e8 fe 4e 00 00       	call   80104fc3 <acquire>
801000c5:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c8:	a1 74 05 11 80       	mov    0x80110574,%eax
801000cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d0:	eb 67                	jmp    80100139 <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d5:	8b 40 04             	mov    0x4(%eax),%eax
801000d8:	3b 45 08             	cmp    0x8(%ebp),%eax
801000db:	75 53                	jne    80100130 <bget+0x7e>
801000dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e0:	8b 40 08             	mov    0x8(%eax),%eax
801000e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e6:	75 48                	jne    80100130 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000eb:	8b 00                	mov    (%eax),%eax
801000ed:	83 e0 01             	and    $0x1,%eax
801000f0:	85 c0                	test   %eax,%eax
801000f2:	75 27                	jne    8010011b <bget+0x69>
        b->flags |= B_BUSY;
801000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f7:	8b 00                	mov    (%eax),%eax
801000f9:	89 c2                	mov    %eax,%edx
801000fb:	83 ca 01             	or     $0x1,%edx
801000fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100101:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100103:	83 ec 0c             	sub    $0xc,%esp
80100106:	68 60 c6 10 80       	push   $0x8010c660
8010010b:	e8 19 4f 00 00       	call   80105029 <release>
80100110:	83 c4 10             	add    $0x10,%esp
        return b;
80100113:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100116:	e9 98 00 00 00       	jmp    801001b3 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011b:	83 ec 08             	sub    $0x8,%esp
8010011e:	68 60 c6 10 80       	push   $0x8010c660
80100123:	ff 75 f4             	pushl  -0xc(%ebp)
80100126:	e8 94 4b 00 00       	call   80104cbf <sleep>
8010012b:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012e:	eb 98                	jmp    801000c8 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100130:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100133:	8b 40 10             	mov    0x10(%eax),%eax
80100136:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100139:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
80100140:	75 90                	jne    801000d2 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100142:	a1 70 05 11 80       	mov    0x80110570,%eax
80100147:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014a:	eb 51                	jmp    8010019d <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014f:	8b 00                	mov    (%eax),%eax
80100151:	83 e0 01             	and    $0x1,%eax
80100154:	85 c0                	test   %eax,%eax
80100156:	75 3c                	jne    80100194 <bget+0xe2>
80100158:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015b:	8b 00                	mov    (%eax),%eax
8010015d:	83 e0 04             	and    $0x4,%eax
80100160:	85 c0                	test   %eax,%eax
80100162:	75 30                	jne    80100194 <bget+0xe2>
      b->dev = dev;
80100164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100167:	8b 55 08             	mov    0x8(%ebp),%edx
8010016a:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100170:	8b 55 0c             	mov    0xc(%ebp),%edx
80100173:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100176:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100179:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
8010017f:	83 ec 0c             	sub    $0xc,%esp
80100182:	68 60 c6 10 80       	push   $0x8010c660
80100187:	e8 9d 4e 00 00       	call   80105029 <release>
8010018c:	83 c4 10             	add    $0x10,%esp
      return b;
8010018f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100192:	eb 1f                	jmp    801001b3 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100194:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100197:	8b 40 0c             	mov    0xc(%eax),%eax
8010019a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019d:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
801001a4:	75 a6                	jne    8010014c <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a6:	83 ec 0c             	sub    $0xc,%esp
801001a9:	68 6b 84 10 80       	push   $0x8010846b
801001ae:	e8 af 03 00 00       	call   80100562 <panic>
}
801001b3:	c9                   	leave  
801001b4:	c3                   	ret    

801001b5 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b5:	55                   	push   %ebp
801001b6:	89 e5                	mov    %esp,%ebp
801001b8:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bb:	83 ec 08             	sub    $0x8,%esp
801001be:	ff 75 0c             	pushl  0xc(%ebp)
801001c1:	ff 75 08             	pushl  0x8(%ebp)
801001c4:	e8 e9 fe ff ff       	call   801000b2 <bget>
801001c9:	83 c4 10             	add    $0x10,%esp
801001cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d2:	8b 00                	mov    (%eax),%eax
801001d4:	83 e0 02             	and    $0x2,%eax
801001d7:	85 c0                	test   %eax,%eax
801001d9:	75 0e                	jne    801001e9 <bread+0x34>
    iderw(b);
801001db:	83 ec 0c             	sub    $0xc,%esp
801001de:	ff 75 f4             	pushl  -0xc(%ebp)
801001e1:	e8 c9 26 00 00       	call   801028af <iderw>
801001e6:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ec:	c9                   	leave  
801001ed:	c3                   	ret    

801001ee <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ee:	55                   	push   %ebp
801001ef:	89 e5                	mov    %esp,%ebp
801001f1:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f4:	8b 45 08             	mov    0x8(%ebp),%eax
801001f7:	8b 00                	mov    (%eax),%eax
801001f9:	83 e0 01             	and    $0x1,%eax
801001fc:	85 c0                	test   %eax,%eax
801001fe:	75 0d                	jne    8010020d <bwrite+0x1f>
    panic("bwrite");
80100200:	83 ec 0c             	sub    $0xc,%esp
80100203:	68 7c 84 10 80       	push   $0x8010847c
80100208:	e8 55 03 00 00       	call   80100562 <panic>
  b->flags |= B_DIRTY;
8010020d:	8b 45 08             	mov    0x8(%ebp),%eax
80100210:	8b 00                	mov    (%eax),%eax
80100212:	89 c2                	mov    %eax,%edx
80100214:	83 ca 04             	or     $0x4,%edx
80100217:	8b 45 08             	mov    0x8(%ebp),%eax
8010021a:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021c:	83 ec 0c             	sub    $0xc,%esp
8010021f:	ff 75 08             	pushl  0x8(%ebp)
80100222:	e8 88 26 00 00       	call   801028af <iderw>
80100227:	83 c4 10             	add    $0x10,%esp
}
8010022a:	c9                   	leave  
8010022b:	c3                   	ret    

8010022c <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022c:	55                   	push   %ebp
8010022d:	89 e5                	mov    %esp,%ebp
8010022f:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100232:	8b 45 08             	mov    0x8(%ebp),%eax
80100235:	8b 00                	mov    (%eax),%eax
80100237:	83 e0 01             	and    $0x1,%eax
8010023a:	85 c0                	test   %eax,%eax
8010023c:	75 0d                	jne    8010024b <brelse+0x1f>
    panic("brelse");
8010023e:	83 ec 0c             	sub    $0xc,%esp
80100241:	68 83 84 10 80       	push   $0x80108483
80100246:	e8 17 03 00 00       	call   80100562 <panic>

  acquire(&bcache.lock);
8010024b:	83 ec 0c             	sub    $0xc,%esp
8010024e:	68 60 c6 10 80       	push   $0x8010c660
80100253:	e8 6b 4d 00 00       	call   80104fc3 <acquire>
80100258:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025b:	8b 45 08             	mov    0x8(%ebp),%eax
8010025e:	8b 40 10             	mov    0x10(%eax),%eax
80100261:	8b 55 08             	mov    0x8(%ebp),%edx
80100264:	8b 52 0c             	mov    0xc(%edx),%edx
80100267:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026a:	8b 45 08             	mov    0x8(%ebp),%eax
8010026d:	8b 40 0c             	mov    0xc(%eax),%eax
80100270:	8b 55 08             	mov    0x8(%ebp),%edx
80100273:	8b 52 10             	mov    0x10(%edx),%edx
80100276:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
80100279:	8b 15 74 05 11 80    	mov    0x80110574,%edx
8010027f:	8b 45 08             	mov    0x8(%ebp),%eax
80100282:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100285:	8b 45 08             	mov    0x8(%ebp),%eax
80100288:	c7 40 0c 64 05 11 80 	movl   $0x80110564,0xc(%eax)
  bcache.head.next->prev = b;
8010028f:	a1 74 05 11 80       	mov    0x80110574,%eax
80100294:	8b 55 08             	mov    0x8(%ebp),%edx
80100297:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029a:	8b 45 08             	mov    0x8(%ebp),%eax
8010029d:	a3 74 05 11 80       	mov    %eax,0x80110574

  b->flags &= ~B_BUSY;
801002a2:	8b 45 08             	mov    0x8(%ebp),%eax
801002a5:	8b 00                	mov    (%eax),%eax
801002a7:	89 c2                	mov    %eax,%edx
801002a9:	83 e2 fe             	and    $0xfffffffe,%edx
801002ac:	8b 45 08             	mov    0x8(%ebp),%eax
801002af:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b1:	83 ec 0c             	sub    $0xc,%esp
801002b4:	ff 75 08             	pushl  0x8(%ebp)
801002b7:	e8 ed 4a 00 00       	call   80104da9 <wakeup>
801002bc:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002bf:	83 ec 0c             	sub    $0xc,%esp
801002c2:	68 60 c6 10 80       	push   $0x8010c660
801002c7:	e8 5d 4d 00 00       	call   80105029 <release>
801002cc:	83 c4 10             	add    $0x10,%esp
}
801002cf:	c9                   	leave  
801002d0:	c3                   	ret    
801002d1:	00 00                	add    %al,(%eax)
	...

801002d4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	53                   	push   %ebx
801002d8:	83 ec 18             	sub    $0x18,%esp
801002db:	8b 45 08             	mov    0x8(%ebp),%eax
801002de:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801002e5:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
801002e9:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
801002ed:	ec                   	in     (%dx),%al
801002ee:	88 c3                	mov    %al,%bl
801002f0:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801002f3:	8a 45 fb             	mov    -0x5(%ebp),%al
}
801002f6:	83 c4 18             	add    $0x18,%esp
801002f9:	5b                   	pop    %ebx
801002fa:	c9                   	leave  
801002fb:	c3                   	ret    

801002fc <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002fc:	55                   	push   %ebp
801002fd:	89 e5                	mov    %esp,%ebp
801002ff:	83 ec 08             	sub    $0x8,%esp
80100302:	8b 45 08             	mov    0x8(%ebp),%eax
80100305:	8b 55 0c             	mov    0xc(%ebp),%edx
80100308:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010030c:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010030f:	8a 45 f8             	mov    -0x8(%ebp),%al
80100312:	8b 55 fc             	mov    -0x4(%ebp),%edx
80100315:	ee                   	out    %al,(%dx)
}
80100316:	c9                   	leave  
80100317:	c3                   	ret    

80100318 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100318:	55                   	push   %ebp
80100319:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010031b:	fa                   	cli    
}
8010031c:	c9                   	leave  
8010031d:	c3                   	ret    

8010031e <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010031e:	55                   	push   %ebp
8010031f:	89 e5                	mov    %esp,%ebp
80100321:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100324:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100328:	74 19                	je     80100343 <printint+0x25>
8010032a:	8b 45 08             	mov    0x8(%ebp),%eax
8010032d:	c1 e8 1f             	shr    $0x1f,%eax
80100330:	89 45 10             	mov    %eax,0x10(%ebp)
80100333:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100337:	74 0a                	je     80100343 <printint+0x25>
    x = -xx;
80100339:	8b 45 08             	mov    0x8(%ebp),%eax
8010033c:	f7 d8                	neg    %eax
8010033e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100341:	eb 06                	jmp    80100349 <printint+0x2b>
  else
    x = xx;
80100343:	8b 45 08             	mov    0x8(%ebp),%eax
80100346:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100349:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100350:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100353:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100356:	ba 00 00 00 00       	mov    $0x0,%edx
8010035b:	f7 f1                	div    %ecx
8010035d:	89 d0                	mov    %edx,%eax
8010035f:	8a 90 04 90 10 80    	mov    -0x7fef6ffc(%eax),%dl
80100365:	8d 45 e0             	lea    -0x20(%ebp),%eax
80100368:	03 45 f4             	add    -0xc(%ebp),%eax
8010036b:	88 10                	mov    %dl,(%eax)
8010036d:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
80100370:	8b 45 0c             	mov    0xc(%ebp),%eax
80100373:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100376:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100379:	ba 00 00 00 00       	mov    $0x0,%edx
8010037e:	f7 75 d4             	divl   -0x2c(%ebp)
80100381:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100384:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100388:	75 c6                	jne    80100350 <printint+0x32>

  if(sign)
8010038a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038e:	74 27                	je     801003b7 <printint+0x99>
    buf[i++] = '-';
80100390:	8d 45 e0             	lea    -0x20(%ebp),%eax
80100393:	03 45 f4             	add    -0xc(%ebp),%eax
80100396:	c6 00 2d             	movb   $0x2d,(%eax)
80100399:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
8010039c:	eb 1a                	jmp    801003b8 <printint+0x9a>
    consputc(buf[i]);
8010039e:	8d 45 e0             	lea    -0x20(%ebp),%eax
801003a1:	03 45 f4             	add    -0xc(%ebp),%eax
801003a4:	8a 00                	mov    (%eax),%al
801003a6:	0f be c0             	movsbl %al,%eax
801003a9:	83 ec 0c             	sub    $0xc,%esp
801003ac:	50                   	push   %eax
801003ad:	e8 c4 03 00 00       	call   80100776 <consputc>
801003b2:	83 c4 10             	add    $0x10,%esp
801003b5:	eb 01                	jmp    801003b8 <printint+0x9a>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b7:	90                   	nop
801003b8:	ff 4d f4             	decl   -0xc(%ebp)
801003bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003bf:	79 dd                	jns    8010039e <printint+0x80>
    consputc(buf[i]);
}
801003c1:	c9                   	leave  
801003c2:	c3                   	ret    

801003c3 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c3:	55                   	push   %ebp
801003c4:	89 e5                	mov    %esp,%ebp
801003c6:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003c9:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d5:	74 10                	je     801003e7 <cprintf+0x24>
    acquire(&cons.lock);
801003d7:	83 ec 0c             	sub    $0xc,%esp
801003da:	68 c0 b5 10 80       	push   $0x8010b5c0
801003df:	e8 df 4b 00 00       	call   80104fc3 <acquire>
801003e4:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003e7:	8b 45 08             	mov    0x8(%ebp),%eax
801003ea:	85 c0                	test   %eax,%eax
801003ec:	75 0d                	jne    801003fb <cprintf+0x38>
    panic("null fmt");
801003ee:	83 ec 0c             	sub    $0xc,%esp
801003f1:	68 8a 84 10 80       	push   $0x8010848a
801003f6:	e8 67 01 00 00       	call   80100562 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fb:	8d 45 08             	lea    0x8(%ebp),%eax
801003fe:	83 c0 04             	add    $0x4,%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 17 01 00 00       	jmp    80100527 <cprintf+0x164>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x66>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 55 03 00 00       	call   80100776 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 fb 00 00 00       	jmp    80100524 <cprintf+0x161>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	ff 45 f4             	incl   -0xc(%ebp)
8010042f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100432:	8d 04 02             	lea    (%edx,%eax,1),%eax
80100435:	8a 00                	mov    (%eax),%al
80100437:	0f be c0             	movsbl %al,%eax
8010043a:	25 ff 00 00 00       	and    $0xff,%eax
8010043f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100442:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100446:	0f 84 fd 00 00 00    	je     80100549 <cprintf+0x186>
      break;
    switch(c){
8010044c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010044f:	83 f8 70             	cmp    $0x70,%eax
80100452:	74 45                	je     80100499 <cprintf+0xd6>
80100454:	83 f8 70             	cmp    $0x70,%eax
80100457:	7f 13                	jg     8010046c <cprintf+0xa9>
80100459:	83 f8 25             	cmp    $0x25,%eax
8010045c:	0f 84 97 00 00 00    	je     801004f9 <cprintf+0x136>
80100462:	83 f8 64             	cmp    $0x64,%eax
80100465:	74 14                	je     8010047b <cprintf+0xb8>
80100467:	e9 9c 00 00 00       	jmp    80100508 <cprintf+0x145>
8010046c:	83 f8 73             	cmp    $0x73,%eax
8010046f:	74 43                	je     801004b4 <cprintf+0xf1>
80100471:	83 f8 78             	cmp    $0x78,%eax
80100474:	74 23                	je     80100499 <cprintf+0xd6>
80100476:	e9 8d 00 00 00       	jmp    80100508 <cprintf+0x145>
    case 'd':
      printint(*argp++, 10, 1);
8010047b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047e:	8b 00                	mov    (%eax),%eax
80100480:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100484:	83 ec 04             	sub    $0x4,%esp
80100487:	6a 01                	push   $0x1
80100489:	6a 0a                	push   $0xa
8010048b:	50                   	push   %eax
8010048c:	e8 8d fe ff ff       	call   8010031e <printint>
80100491:	83 c4 10             	add    $0x10,%esp
      break;
80100494:	e9 8b 00 00 00       	jmp    80100524 <cprintf+0x161>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100499:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049c:	8b 00                	mov    (%eax),%eax
8010049e:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004a2:	83 ec 04             	sub    $0x4,%esp
801004a5:	6a 00                	push   $0x0
801004a7:	6a 10                	push   $0x10
801004a9:	50                   	push   %eax
801004aa:	e8 6f fe ff ff       	call   8010031e <printint>
801004af:	83 c4 10             	add    $0x10,%esp
      break;
801004b2:	eb 70                	jmp    80100524 <cprintf+0x161>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004b7:	8b 00                	mov    (%eax),%eax
801004b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004c0:	0f 94 c0             	sete   %al
801004c3:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004c7:	84 c0                	test   %al,%al
801004c9:	74 22                	je     801004ed <cprintf+0x12a>
        s = "(null)";
801004cb:	c7 45 ec 93 84 10 80 	movl   $0x80108493,-0x14(%ebp)
      for(; *s; s++)
801004d2:	eb 1a                	jmp    801004ee <cprintf+0x12b>
        consputc(*s);
801004d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d7:	8a 00                	mov    (%eax),%al
801004d9:	0f be c0             	movsbl %al,%eax
801004dc:	83 ec 0c             	sub    $0xc,%esp
801004df:	50                   	push   %eax
801004e0:	e8 91 02 00 00       	call   80100776 <consputc>
801004e5:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004e8:	ff 45 ec             	incl   -0x14(%ebp)
801004eb:	eb 01                	jmp    801004ee <cprintf+0x12b>
801004ed:	90                   	nop
801004ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f1:	8a 00                	mov    (%eax),%al
801004f3:	84 c0                	test   %al,%al
801004f5:	75 dd                	jne    801004d4 <cprintf+0x111>
        consputc(*s);
      break;
801004f7:	eb 2b                	jmp    80100524 <cprintf+0x161>
    case '%':
      consputc('%');
801004f9:	83 ec 0c             	sub    $0xc,%esp
801004fc:	6a 25                	push   $0x25
801004fe:	e8 73 02 00 00       	call   80100776 <consputc>
80100503:	83 c4 10             	add    $0x10,%esp
      break;
80100506:	eb 1c                	jmp    80100524 <cprintf+0x161>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100508:	83 ec 0c             	sub    $0xc,%esp
8010050b:	6a 25                	push   $0x25
8010050d:	e8 64 02 00 00       	call   80100776 <consputc>
80100512:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100515:	83 ec 0c             	sub    $0xc,%esp
80100518:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051b:	e8 56 02 00 00       	call   80100776 <consputc>
80100520:	83 c4 10             	add    $0x10,%esp
      break;
80100523:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100524:	ff 45 f4             	incl   -0xc(%ebp)
80100527:	8b 55 08             	mov    0x8(%ebp),%edx
8010052a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010052d:	8d 04 02             	lea    (%edx,%eax,1),%eax
80100530:	8a 00                	mov    (%eax),%al
80100532:	0f be c0             	movsbl %al,%eax
80100535:	25 ff 00 00 00       	and    $0xff,%eax
8010053a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010053d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100541:	0f 85 c9 fe ff ff    	jne    80100410 <cprintf+0x4d>
80100547:	eb 01                	jmp    8010054a <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100549:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
8010054a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010054e:	74 10                	je     80100560 <cprintf+0x19d>
    release(&cons.lock);
80100550:	83 ec 0c             	sub    $0xc,%esp
80100553:	68 c0 b5 10 80       	push   $0x8010b5c0
80100558:	e8 cc 4a 00 00       	call   80105029 <release>
8010055d:	83 c4 10             	add    $0x10,%esp
}
80100560:	c9                   	leave  
80100561:	c3                   	ret    

80100562 <panic>:

void
panic(char *s)
{
80100562:	55                   	push   %ebp
80100563:	89 e5                	mov    %esp,%ebp
80100565:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
80100568:	e8 ab fd ff ff       	call   80100318 <cli>
  cons.locking = 0;
8010056d:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
80100574:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
80100577:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010057d:	8a 00                	mov    (%eax),%al
8010057f:	0f b6 c0             	movzbl %al,%eax
80100582:	83 ec 08             	sub    $0x8,%esp
80100585:	50                   	push   %eax
80100586:	68 9a 84 10 80       	push   $0x8010849a
8010058b:	e8 33 fe ff ff       	call   801003c3 <cprintf>
80100590:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100593:	8b 45 08             	mov    0x8(%ebp),%eax
80100596:	83 ec 0c             	sub    $0xc,%esp
80100599:	50                   	push   %eax
8010059a:	e8 24 fe ff ff       	call   801003c3 <cprintf>
8010059f:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a2:	83 ec 0c             	sub    $0xc,%esp
801005a5:	68 a9 84 10 80       	push   $0x801084a9
801005aa:	e8 14 fe ff ff       	call   801003c3 <cprintf>
801005af:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b2:	83 ec 08             	sub    $0x8,%esp
801005b5:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005b8:	50                   	push   %eax
801005b9:	8d 45 08             	lea    0x8(%ebp),%eax
801005bc:	50                   	push   %eax
801005bd:	e8 b8 4a 00 00       	call   8010507a <getcallerpcs>
801005c2:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005cc:	eb 1b                	jmp    801005e9 <panic+0x87>
    cprintf(" %p", pcs[i]);
801005ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d1:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005d5:	83 ec 08             	sub    $0x8,%esp
801005d8:	50                   	push   %eax
801005d9:	68 ab 84 10 80       	push   $0x801084ab
801005de:	e8 e0 fd ff ff       	call   801003c3 <cprintf>
801005e3:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005e6:	ff 45 f4             	incl   -0xc(%ebp)
801005e9:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005ed:	7e df                	jle    801005ce <panic+0x6c>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005ef:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005f6:	00 00 00 
  for(;;)
    ;
801005f9:	eb fe                	jmp    801005f9 <panic+0x97>

801005fb <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005fb:	55                   	push   %ebp
801005fc:	89 e5                	mov    %esp,%ebp
801005fe:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100601:	6a 0e                	push   $0xe
80100603:	68 d4 03 00 00       	push   $0x3d4
80100608:	e8 ef fc ff ff       	call   801002fc <outb>
8010060d:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100610:	68 d5 03 00 00       	push   $0x3d5
80100615:	e8 ba fc ff ff       	call   801002d4 <inb>
8010061a:	83 c4 04             	add    $0x4,%esp
8010061d:	0f b6 c0             	movzbl %al,%eax
80100620:	c1 e0 08             	shl    $0x8,%eax
80100623:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100626:	6a 0f                	push   $0xf
80100628:	68 d4 03 00 00       	push   $0x3d4
8010062d:	e8 ca fc ff ff       	call   801002fc <outb>
80100632:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
80100635:	68 d5 03 00 00       	push   $0x3d5
8010063a:	e8 95 fc ff ff       	call   801002d4 <inb>
8010063f:	83 c4 04             	add    $0x4,%esp
80100642:	0f b6 c0             	movzbl %al,%eax
80100645:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100648:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010064c:	75 1d                	jne    8010066b <cgaputc+0x70>
    pos += 80 - pos%80;
8010064e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100651:	b9 50 00 00 00       	mov    $0x50,%ecx
80100656:	99                   	cltd   
80100657:	f7 f9                	idiv   %ecx
80100659:	89 d0                	mov    %edx,%eax
8010065b:	ba 50 00 00 00       	mov    $0x50,%edx
80100660:	89 d1                	mov    %edx,%ecx
80100662:	29 c1                	sub    %eax,%ecx
80100664:	89 c8                	mov    %ecx,%eax
80100666:	01 45 f4             	add    %eax,-0xc(%ebp)
80100669:	eb 32                	jmp    8010069d <cgaputc+0xa2>
  else if(c == BACKSPACE){
8010066b:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100672:	75 0b                	jne    8010067f <cgaputc+0x84>
    if(pos > 0) --pos;
80100674:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100678:	7e 23                	jle    8010069d <cgaputc+0xa2>
8010067a:	ff 4d f4             	decl   -0xc(%ebp)
8010067d:	eb 1e                	jmp    8010069d <cgaputc+0xa2>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010067f:	a1 00 90 10 80       	mov    0x80109000,%eax
80100684:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100687:	d1 e2                	shl    %edx
80100689:	8d 14 10             	lea    (%eax,%edx,1),%edx
8010068c:	8b 45 08             	mov    0x8(%ebp),%eax
8010068f:	25 ff 00 00 00       	and    $0xff,%eax
80100694:	80 cc 07             	or     $0x7,%ah
80100697:	66 89 02             	mov    %ax,(%edx)
8010069a:	ff 45 f4             	incl   -0xc(%ebp)

  if(pos < 0 || pos > 25*80)
8010069d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006a1:	78 09                	js     801006ac <cgaputc+0xb1>
801006a3:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006aa:	7e 0d                	jle    801006b9 <cgaputc+0xbe>
    panic("pos under/overflow");
801006ac:	83 ec 0c             	sub    $0xc,%esp
801006af:	68 af 84 10 80       	push   $0x801084af
801006b4:	e8 a9 fe ff ff       	call   80100562 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006b9:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006c0:	7e 4c                	jle    8010070e <cgaputc+0x113>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006c2:	a1 00 90 10 80       	mov    0x80109000,%eax
801006c7:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006cd:	a1 00 90 10 80       	mov    0x80109000,%eax
801006d2:	83 ec 04             	sub    $0x4,%esp
801006d5:	68 60 0e 00 00       	push   $0xe60
801006da:	52                   	push   %edx
801006db:	50                   	push   %eax
801006dc:	e8 f9 4b 00 00       	call   801052da <memmove>
801006e1:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006e4:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006e8:	b8 80 07 00 00       	mov    $0x780,%eax
801006ed:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006f0:	d1 e0                	shl    %eax
801006f2:	8b 15 00 90 10 80    	mov    0x80109000,%edx
801006f8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006fb:	d1 e1                	shl    %ecx
801006fd:	01 ca                	add    %ecx,%edx
801006ff:	83 ec 04             	sub    $0x4,%esp
80100702:	50                   	push   %eax
80100703:	6a 00                	push   $0x0
80100705:	52                   	push   %edx
80100706:	e8 13 4b 00 00       	call   8010521e <memset>
8010070b:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
8010070e:	83 ec 08             	sub    $0x8,%esp
80100711:	6a 0e                	push   $0xe
80100713:	68 d4 03 00 00       	push   $0x3d4
80100718:	e8 df fb ff ff       	call   801002fc <outb>
8010071d:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
80100720:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100723:	c1 f8 08             	sar    $0x8,%eax
80100726:	0f b6 c0             	movzbl %al,%eax
80100729:	83 ec 08             	sub    $0x8,%esp
8010072c:	50                   	push   %eax
8010072d:	68 d5 03 00 00       	push   $0x3d5
80100732:	e8 c5 fb ff ff       	call   801002fc <outb>
80100737:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
8010073a:	83 ec 08             	sub    $0x8,%esp
8010073d:	6a 0f                	push   $0xf
8010073f:	68 d4 03 00 00       	push   $0x3d4
80100744:	e8 b3 fb ff ff       	call   801002fc <outb>
80100749:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
8010074c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010074f:	0f b6 c0             	movzbl %al,%eax
80100752:	83 ec 08             	sub    $0x8,%esp
80100755:	50                   	push   %eax
80100756:	68 d5 03 00 00       	push   $0x3d5
8010075b:	e8 9c fb ff ff       	call   801002fc <outb>
80100760:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
80100763:	a1 00 90 10 80       	mov    0x80109000,%eax
80100768:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010076b:	d1 e2                	shl    %edx
8010076d:	01 d0                	add    %edx,%eax
8010076f:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100774:	c9                   	leave  
80100775:	c3                   	ret    

80100776 <consputc>:

void
consputc(int c)
{
80100776:	55                   	push   %ebp
80100777:	89 e5                	mov    %esp,%ebp
80100779:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
8010077c:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
80100781:	85 c0                	test   %eax,%eax
80100783:	74 07                	je     8010078c <consputc+0x16>
    cli();
80100785:	e8 8e fb ff ff       	call   80100318 <cli>
    for(;;)
      ;
8010078a:	eb fe                	jmp    8010078a <consputc+0x14>
  }

  if(c == BACKSPACE){
8010078c:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100793:	75 29                	jne    801007be <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100795:	83 ec 0c             	sub    $0xc,%esp
80100798:	6a 08                	push   $0x8
8010079a:	e8 96 63 00 00       	call   80106b35 <uartputc>
8010079f:	83 c4 10             	add    $0x10,%esp
801007a2:	83 ec 0c             	sub    $0xc,%esp
801007a5:	6a 20                	push   $0x20
801007a7:	e8 89 63 00 00       	call   80106b35 <uartputc>
801007ac:	83 c4 10             	add    $0x10,%esp
801007af:	83 ec 0c             	sub    $0xc,%esp
801007b2:	6a 08                	push   $0x8
801007b4:	e8 7c 63 00 00       	call   80106b35 <uartputc>
801007b9:	83 c4 10             	add    $0x10,%esp
801007bc:	eb 0e                	jmp    801007cc <consputc+0x56>
  } else
    uartputc(c);
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	ff 75 08             	pushl  0x8(%ebp)
801007c4:	e8 6c 63 00 00       	call   80106b35 <uartputc>
801007c9:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007cc:	83 ec 0c             	sub    $0xc,%esp
801007cf:	ff 75 08             	pushl  0x8(%ebp)
801007d2:	e8 24 fe ff ff       	call   801005fb <cgaputc>
801007d7:	83 c4 10             	add    $0x10,%esp
}
801007da:	c9                   	leave  
801007db:	c3                   	ret    

801007dc <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007dc:	55                   	push   %ebp
801007dd:	89 e5                	mov    %esp,%ebp
801007df:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
801007e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
801007e9:	83 ec 0c             	sub    $0xc,%esp
801007ec:	68 c0 b5 10 80       	push   $0x8010b5c0
801007f1:	e8 cd 47 00 00       	call   80104fc3 <acquire>
801007f6:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801007f9:	e9 4f 01 00 00       	jmp    8010094d <consoleintr+0x171>
    switch(c){
801007fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100801:	83 f8 10             	cmp    $0x10,%eax
80100804:	74 1e                	je     80100824 <consoleintr+0x48>
80100806:	83 f8 10             	cmp    $0x10,%eax
80100809:	7f 0a                	jg     80100815 <consoleintr+0x39>
8010080b:	83 f8 08             	cmp    $0x8,%eax
8010080e:	74 69                	je     80100879 <consoleintr+0x9d>
80100810:	e9 97 00 00 00       	jmp    801008ac <consoleintr+0xd0>
80100815:	83 f8 15             	cmp    $0x15,%eax
80100818:	74 33                	je     8010084d <consoleintr+0x71>
8010081a:	83 f8 7f             	cmp    $0x7f,%eax
8010081d:	74 5a                	je     80100879 <consoleintr+0x9d>
8010081f:	e9 88 00 00 00       	jmp    801008ac <consoleintr+0xd0>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
80100824:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
8010082b:	e9 1d 01 00 00       	jmp    8010094d <consoleintr+0x171>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100830:	a1 08 08 11 80       	mov    0x80110808,%eax
80100835:	48                   	dec    %eax
80100836:	a3 08 08 11 80       	mov    %eax,0x80110808
        consputc(BACKSPACE);
8010083b:	83 ec 0c             	sub    $0xc,%esp
8010083e:	68 00 01 00 00       	push   $0x100
80100843:	e8 2e ff ff ff       	call   80100776 <consputc>
80100848:	83 c4 10             	add    $0x10,%esp
8010084b:	eb 01                	jmp    8010084e <consoleintr+0x72>
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010084d:	90                   	nop
8010084e:	8b 15 08 08 11 80    	mov    0x80110808,%edx
80100854:	a1 04 08 11 80       	mov    0x80110804,%eax
80100859:	39 c2                	cmp    %eax,%edx
8010085b:	0f 84 df 00 00 00    	je     80100940 <consoleintr+0x164>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100861:	a1 08 08 11 80       	mov    0x80110808,%eax
80100866:	48                   	dec    %eax
80100867:	83 e0 7f             	and    $0x7f,%eax
8010086a:	8a 80 80 07 11 80    	mov    -0x7feef880(%eax),%al
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100870:	3c 0a                	cmp    $0xa,%al
80100872:	75 bc                	jne    80100830 <consoleintr+0x54>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100874:	e9 d4 00 00 00       	jmp    8010094d <consoleintr+0x171>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100879:	8b 15 08 08 11 80    	mov    0x80110808,%edx
8010087f:	a1 04 08 11 80       	mov    0x80110804,%eax
80100884:	39 c2                	cmp    %eax,%edx
80100886:	0f 84 b7 00 00 00    	je     80100943 <consoleintr+0x167>
        input.e--;
8010088c:	a1 08 08 11 80       	mov    0x80110808,%eax
80100891:	48                   	dec    %eax
80100892:	a3 08 08 11 80       	mov    %eax,0x80110808
        consputc(BACKSPACE);
80100897:	83 ec 0c             	sub    $0xc,%esp
8010089a:	68 00 01 00 00       	push   $0x100
8010089f:	e8 d2 fe ff ff       	call   80100776 <consputc>
801008a4:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008a7:	e9 a1 00 00 00       	jmp    8010094d <consoleintr+0x171>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008b0:	0f 84 90 00 00 00    	je     80100946 <consoleintr+0x16a>
801008b6:	8b 15 08 08 11 80    	mov    0x80110808,%edx
801008bc:	a1 00 08 11 80       	mov    0x80110800,%eax
801008c1:	89 d1                	mov    %edx,%ecx
801008c3:	29 c1                	sub    %eax,%ecx
801008c5:	89 c8                	mov    %ecx,%eax
801008c7:	83 f8 7f             	cmp    $0x7f,%eax
801008ca:	77 7d                	ja     80100949 <consoleintr+0x16d>
        c = (c == '\r') ? '\n' : c;
801008cc:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008d0:	74 05                	je     801008d7 <consoleintr+0xfb>
801008d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008d5:	eb 05                	jmp    801008dc <consoleintr+0x100>
801008d7:	b8 0a 00 00 00       	mov    $0xa,%eax
801008dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008df:	a1 08 08 11 80       	mov    0x80110808,%eax
801008e4:	89 c1                	mov    %eax,%ecx
801008e6:	83 e1 7f             	and    $0x7f,%ecx
801008e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801008ec:	88 91 80 07 11 80    	mov    %dl,-0x7feef880(%ecx)
801008f2:	40                   	inc    %eax
801008f3:	a3 08 08 11 80       	mov    %eax,0x80110808
        consputc(c);
801008f8:	83 ec 0c             	sub    $0xc,%esp
801008fb:	ff 75 f0             	pushl  -0x10(%ebp)
801008fe:	e8 73 fe ff ff       	call   80100776 <consputc>
80100903:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100906:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
8010090a:	74 18                	je     80100924 <consoleintr+0x148>
8010090c:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100910:	74 12                	je     80100924 <consoleintr+0x148>
80100912:	a1 08 08 11 80       	mov    0x80110808,%eax
80100917:	8b 15 00 08 11 80    	mov    0x80110800,%edx
8010091d:	83 ea 80             	sub    $0xffffff80,%edx
80100920:	39 d0                	cmp    %edx,%eax
80100922:	75 28                	jne    8010094c <consoleintr+0x170>
          input.w = input.e;
80100924:	a1 08 08 11 80       	mov    0x80110808,%eax
80100929:	a3 04 08 11 80       	mov    %eax,0x80110804
          wakeup(&input.r);
8010092e:	83 ec 0c             	sub    $0xc,%esp
80100931:	68 00 08 11 80       	push   $0x80110800
80100936:	e8 6e 44 00 00       	call   80104da9 <wakeup>
8010093b:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
8010093e:	eb 0d                	jmp    8010094d <consoleintr+0x171>
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100940:	90                   	nop
80100941:	eb 0a                	jmp    8010094d <consoleintr+0x171>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100943:	90                   	nop
80100944:	eb 07                	jmp    8010094d <consoleintr+0x171>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
          wakeup(&input.r);
        }
      }
      break;
80100946:	90                   	nop
80100947:	eb 04                	jmp    8010094d <consoleintr+0x171>
80100949:	90                   	nop
8010094a:	eb 01                	jmp    8010094d <consoleintr+0x171>
8010094c:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
8010094d:	8b 45 08             	mov    0x8(%ebp),%eax
80100950:	ff d0                	call   *%eax
80100952:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100955:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100959:	0f 89 9f fe ff ff    	jns    801007fe <consoleintr+0x22>
        }
      }
      break;
    }
  }
  release(&cons.lock);
8010095f:	83 ec 0c             	sub    $0xc,%esp
80100962:	68 c0 b5 10 80       	push   $0x8010b5c0
80100967:	e8 bd 46 00 00       	call   80105029 <release>
8010096c:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
8010096f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100973:	74 05                	je     8010097a <consoleintr+0x19e>
    procdump();  // now call procdump() wo. cons.lock held
80100975:	e8 ea 44 00 00       	call   80104e64 <procdump>
  }
}
8010097a:	c9                   	leave  
8010097b:	c3                   	ret    

8010097c <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010097c:	55                   	push   %ebp
8010097d:	89 e5                	mov    %esp,%ebp
8010097f:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100982:	83 ec 0c             	sub    $0xc,%esp
80100985:	ff 75 08             	pushl  0x8(%ebp)
80100988:	e8 f6 10 00 00       	call   80101a83 <iunlock>
8010098d:	83 c4 10             	add    $0x10,%esp
  target = n;
80100990:	8b 45 10             	mov    0x10(%ebp),%eax
80100993:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100996:	83 ec 0c             	sub    $0xc,%esp
80100999:	68 c0 b5 10 80       	push   $0x8010b5c0
8010099e:	e8 20 46 00 00       	call   80104fc3 <acquire>
801009a3:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009a6:	e9 a9 00 00 00       	jmp    80100a54 <consoleread+0xd8>
    while(input.r == input.w){
      if(proc->killed){
801009ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801009b1:	8b 40 24             	mov    0x24(%eax),%eax
801009b4:	85 c0                	test   %eax,%eax
801009b6:	74 28                	je     801009e0 <consoleread+0x64>
        release(&cons.lock);
801009b8:	83 ec 0c             	sub    $0xc,%esp
801009bb:	68 c0 b5 10 80       	push   $0x8010b5c0
801009c0:	e8 64 46 00 00       	call   80105029 <release>
801009c5:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	ff 75 08             	pushl  0x8(%ebp)
801009ce:	e8 53 0f 00 00       	call   80101926 <ilock>
801009d3:	83 c4 10             	add    $0x10,%esp
        return -1;
801009d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009db:	e9 aa 00 00 00       	jmp    80100a8a <consoleread+0x10e>
      }
      sleep(&input.r, &cons.lock);
801009e0:	83 ec 08             	sub    $0x8,%esp
801009e3:	68 c0 b5 10 80       	push   $0x8010b5c0
801009e8:	68 00 08 11 80       	push   $0x80110800
801009ed:	e8 cd 42 00 00       	call   80104cbf <sleep>
801009f2:	83 c4 10             	add    $0x10,%esp
801009f5:	eb 01                	jmp    801009f8 <consoleread+0x7c>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801009f7:	90                   	nop
801009f8:	8b 15 00 08 11 80    	mov    0x80110800,%edx
801009fe:	a1 04 08 11 80       	mov    0x80110804,%eax
80100a03:	39 c2                	cmp    %eax,%edx
80100a05:	74 a4                	je     801009ab <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a07:	a1 00 08 11 80       	mov    0x80110800,%eax
80100a0c:	89 c2                	mov    %eax,%edx
80100a0e:	83 e2 7f             	and    $0x7f,%edx
80100a11:	8a 92 80 07 11 80    	mov    -0x7feef880(%edx),%dl
80100a17:	0f be d2             	movsbl %dl,%edx
80100a1a:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100a1d:	40                   	inc    %eax
80100a1e:	a3 00 08 11 80       	mov    %eax,0x80110800
    if(c == C('D')){  // EOF
80100a23:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a27:	75 15                	jne    80100a3e <consoleread+0xc2>
      if(n < target){
80100a29:	8b 45 10             	mov    0x10(%ebp),%eax
80100a2c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a2f:	73 2b                	jae    80100a5c <consoleread+0xe0>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a31:	a1 00 08 11 80       	mov    0x80110800,%eax
80100a36:	48                   	dec    %eax
80100a37:	a3 00 08 11 80       	mov    %eax,0x80110800
      }
      break;
80100a3c:	eb 22                	jmp    80100a60 <consoleread+0xe4>
    }
    *dst++ = c;
80100a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100a41:	88 c2                	mov    %al,%dl
80100a43:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a46:	88 10                	mov    %dl,(%eax)
80100a48:	ff 45 0c             	incl   0xc(%ebp)
    --n;
80100a4b:	ff 4d 10             	decl   0x10(%ebp)
    if(c == '\n')
80100a4e:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a52:	74 0b                	je     80100a5f <consoleread+0xe3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100a54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a58:	7f 9d                	jg     801009f7 <consoleread+0x7b>
80100a5a:	eb 04                	jmp    80100a60 <consoleread+0xe4>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100a5c:	90                   	nop
80100a5d:	eb 01                	jmp    80100a60 <consoleread+0xe4>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a5f:	90                   	nop
  }
  release(&cons.lock);
80100a60:	83 ec 0c             	sub    $0xc,%esp
80100a63:	68 c0 b5 10 80       	push   $0x8010b5c0
80100a68:	e8 bc 45 00 00       	call   80105029 <release>
80100a6d:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a70:	83 ec 0c             	sub    $0xc,%esp
80100a73:	ff 75 08             	pushl  0x8(%ebp)
80100a76:	e8 ab 0e 00 00       	call   80101926 <ilock>
80100a7b:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a7e:	8b 45 10             	mov    0x10(%ebp),%eax
80100a81:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a84:	89 d1                	mov    %edx,%ecx
80100a86:	29 c1                	sub    %eax,%ecx
80100a88:	89 c8                	mov    %ecx,%eax
}
80100a8a:	c9                   	leave  
80100a8b:	c3                   	ret    

80100a8c <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a8c:	55                   	push   %ebp
80100a8d:	89 e5                	mov    %esp,%ebp
80100a8f:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100a92:	83 ec 0c             	sub    $0xc,%esp
80100a95:	ff 75 08             	pushl  0x8(%ebp)
80100a98:	e8 e6 0f 00 00       	call   80101a83 <iunlock>
80100a9d:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	68 c0 b5 10 80       	push   $0x8010b5c0
80100aa8:	e8 16 45 00 00       	call   80104fc3 <acquire>
80100aad:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100ab0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100ab7:	eb 1f                	jmp    80100ad8 <consolewrite+0x4c>
    consputc(buf[i] & 0xff);
80100ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100abc:	03 45 0c             	add    0xc(%ebp),%eax
80100abf:	8a 00                	mov    (%eax),%al
80100ac1:	0f be c0             	movsbl %al,%eax
80100ac4:	25 ff 00 00 00       	and    $0xff,%eax
80100ac9:	83 ec 0c             	sub    $0xc,%esp
80100acc:	50                   	push   %eax
80100acd:	e8 a4 fc ff ff       	call   80100776 <consputc>
80100ad2:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100ad5:	ff 45 f4             	incl   -0xc(%ebp)
80100ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100adb:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ade:	7c d9                	jl     80100ab9 <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100ae0:	83 ec 0c             	sub    $0xc,%esp
80100ae3:	68 c0 b5 10 80       	push   $0x8010b5c0
80100ae8:	e8 3c 45 00 00       	call   80105029 <release>
80100aed:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100af0:	83 ec 0c             	sub    $0xc,%esp
80100af3:	ff 75 08             	pushl  0x8(%ebp)
80100af6:	e8 2b 0e 00 00       	call   80101926 <ilock>
80100afb:	83 c4 10             	add    $0x10,%esp

  return n;
80100afe:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b01:	c9                   	leave  
80100b02:	c3                   	ret    

80100b03 <consoleinit>:

void
consoleinit(void)
{
80100b03:	55                   	push   %ebp
80100b04:	89 e5                	mov    %esp,%ebp
80100b06:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b09:	83 ec 08             	sub    $0x8,%esp
80100b0c:	68 c2 84 10 80       	push   $0x801084c2
80100b11:	68 c0 b5 10 80       	push   $0x8010b5c0
80100b16:	e8 87 44 00 00       	call   80104fa2 <initlock>
80100b1b:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b1e:	c7 05 cc 11 11 80 8c 	movl   $0x80100a8c,0x801111cc
80100b25:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b28:	c7 05 c8 11 11 80 7c 	movl   $0x8010097c,0x801111c8
80100b2f:	09 10 80 
  cons.locking = 1;
80100b32:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100b39:	00 00 00 

  picenable(IRQ_KBD);
80100b3c:	83 ec 0c             	sub    $0xc,%esp
80100b3f:	6a 01                	push   $0x1
80100b41:	e8 ab 33 00 00       	call   80103ef1 <picenable>
80100b46:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b49:	83 ec 08             	sub    $0x8,%esp
80100b4c:	6a 00                	push   $0x0
80100b4e:	6a 01                	push   $0x1
80100b50:	e8 23 1f 00 00       	call   80102a78 <ioapicenable>
80100b55:	83 c4 10             	add    $0x10,%esp
}
80100b58:	c9                   	leave  
80100b59:	c3                   	ret    
	...

80100b5c <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b5c:	55                   	push   %ebp
80100b5d:	89 e5                	mov    %esp,%ebp
80100b5f:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b65:	e8 67 29 00 00       	call   801034d1 <begin_op>
  if((ip = namei(path)) == 0){
80100b6a:	83 ec 0c             	sub    $0xc,%esp
80100b6d:	ff 75 08             	pushl  0x8(%ebp)
80100b70:	e8 53 19 00 00       	call   801024c8 <namei>
80100b75:	83 c4 10             	add    $0x10,%esp
80100b78:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b7b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b7f:	75 0f                	jne    80100b90 <exec+0x34>
    end_op();
80100b81:	e8 d4 29 00 00       	call   8010355a <end_op>
    return -1;
80100b86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8b:	e9 a3 03 00 00       	jmp    80100f33 <exec+0x3d7>
  }
  ilock(ip);
80100b90:	83 ec 0c             	sub    $0xc,%esp
80100b93:	ff 75 d8             	pushl  -0x28(%ebp)
80100b96:	e8 8b 0d 00 00       	call   80101926 <ilock>
80100b9b:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100b9e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100ba5:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100bab:	6a 34                	push   $0x34
80100bad:	6a 00                	push   $0x0
80100baf:	50                   	push   %eax
80100bb0:	ff 75 d8             	pushl  -0x28(%ebp)
80100bb3:	e8 bc 12 00 00       	call   80101e74 <readi>
80100bb8:	83 c4 10             	add    $0x10,%esp
80100bbb:	83 f8 33             	cmp    $0x33,%eax
80100bbe:	0f 86 1e 03 00 00    	jbe    80100ee2 <exec+0x386>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100bc4:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bca:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100bcf:	0f 85 10 03 00 00    	jne    80100ee5 <exec+0x389>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100bd5:	e8 73 70 00 00       	call   80107c4d <setupkvm>
80100bda:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bdd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100be1:	0f 84 01 03 00 00    	je     80100ee8 <exec+0x38c>
    goto bad;

  // Load program into memory.
  sz = 0;
80100be7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100bf5:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bfb:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100bfe:	e9 ab 00 00 00       	jmp    80100cae <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c03:	8b 55 e8             	mov    -0x18(%ebp),%edx
80100c06:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c0c:	6a 20                	push   $0x20
80100c0e:	52                   	push   %edx
80100c0f:	50                   	push   %eax
80100c10:	ff 75 d8             	pushl  -0x28(%ebp)
80100c13:	e8 5c 12 00 00       	call   80101e74 <readi>
80100c18:	83 c4 10             	add    $0x10,%esp
80100c1b:	83 f8 20             	cmp    $0x20,%eax
80100c1e:	0f 85 c7 02 00 00    	jne    80100eeb <exec+0x38f>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c24:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c2a:	83 f8 01             	cmp    $0x1,%eax
80100c2d:	75 72                	jne    80100ca1 <exec+0x145>
      continue;
    if(ph.memsz < ph.filesz)
80100c2f:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c35:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c3b:	39 c2                	cmp    %eax,%edx
80100c3d:	0f 82 ab 02 00 00    	jb     80100eee <exec+0x392>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c43:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c49:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c4f:	8d 04 02             	lea    (%edx,%eax,1),%eax
80100c52:	83 ec 04             	sub    $0x4,%esp
80100c55:	50                   	push   %eax
80100c56:	ff 75 e0             	pushl  -0x20(%ebp)
80100c59:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c5c:	e8 8f 73 00 00       	call   80107ff0 <allocuvm>
80100c61:	83 c4 10             	add    $0x10,%esp
80100c64:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c67:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c6b:	0f 84 80 02 00 00    	je     80100ef1 <exec+0x395>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c71:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c77:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c7d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c83:	83 ec 0c             	sub    $0xc,%esp
80100c86:	51                   	push   %ecx
80100c87:	52                   	push   %edx
80100c88:	ff 75 d8             	pushl  -0x28(%ebp)
80100c8b:	50                   	push   %eax
80100c8c:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c8f:	e8 78 72 00 00       	call   80107f0c <loaduvm>
80100c94:	83 c4 20             	add    $0x20,%esp
80100c97:	85 c0                	test   %eax,%eax
80100c99:	0f 88 55 02 00 00    	js     80100ef4 <exec+0x398>
80100c9f:	eb 01                	jmp    80100ca2 <exec+0x146>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100ca1:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ca2:	ff 45 ec             	incl   -0x14(%ebp)
80100ca5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ca8:	83 c0 20             	add    $0x20,%eax
80100cab:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cae:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
80100cb4:	0f b7 c0             	movzwl %ax,%eax
80100cb7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cba:	0f 8f 43 ff ff ff    	jg     80100c03 <exec+0xa7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100cc0:	83 ec 0c             	sub    $0xc,%esp
80100cc3:	ff 75 d8             	pushl  -0x28(%ebp)
80100cc6:	e8 18 0f 00 00       	call   80101be3 <iunlockput>
80100ccb:	83 c4 10             	add    $0x10,%esp
  end_op();
80100cce:	e8 87 28 00 00       	call   8010355a <end_op>
  ip = 0;
80100cd3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cda:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cdd:	05 ff 0f 00 00       	add    $0xfff,%eax
80100ce2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ce7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cea:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ced:	05 00 20 00 00       	add    $0x2000,%eax
80100cf2:	83 ec 04             	sub    $0x4,%esp
80100cf5:	50                   	push   %eax
80100cf6:	ff 75 e0             	pushl  -0x20(%ebp)
80100cf9:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cfc:	e8 ef 72 00 00       	call   80107ff0 <allocuvm>
80100d01:	83 c4 10             	add    $0x10,%esp
80100d04:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d07:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d0b:	0f 84 e6 01 00 00    	je     80100ef7 <exec+0x39b>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d11:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d14:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d19:	83 ec 08             	sub    $0x8,%esp
80100d1c:	50                   	push   %eax
80100d1d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d20:	e8 e2 74 00 00       	call   80108207 <clearpteu>
80100d25:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d28:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d2b:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d2e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d35:	eb 7c                	jmp    80100db3 <exec+0x257>
    if(argc >= MAXARG)
80100d37:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d3b:	0f 87 b9 01 00 00    	ja     80100efa <exec+0x39e>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d44:	c1 e0 02             	shl    $0x2,%eax
80100d47:	03 45 0c             	add    0xc(%ebp),%eax
80100d4a:	8b 00                	mov    (%eax),%eax
80100d4c:	83 ec 0c             	sub    $0xc,%esp
80100d4f:	50                   	push   %eax
80100d50:	e8 0e 47 00 00       	call   80105463 <strlen>
80100d55:	83 c4 10             	add    $0x10,%esp
80100d58:	f7 d0                	not    %eax
80100d5a:	03 45 dc             	add    -0x24(%ebp),%eax
80100d5d:	83 e0 fc             	and    $0xfffffffc,%eax
80100d60:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d66:	c1 e0 02             	shl    $0x2,%eax
80100d69:	03 45 0c             	add    0xc(%ebp),%eax
80100d6c:	8b 00                	mov    (%eax),%eax
80100d6e:	83 ec 0c             	sub    $0xc,%esp
80100d71:	50                   	push   %eax
80100d72:	e8 ec 46 00 00       	call   80105463 <strlen>
80100d77:	83 c4 10             	add    $0x10,%esp
80100d7a:	40                   	inc    %eax
80100d7b:	89 c2                	mov    %eax,%edx
80100d7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d80:	c1 e0 02             	shl    $0x2,%eax
80100d83:	03 45 0c             	add    0xc(%ebp),%eax
80100d86:	8b 00                	mov    (%eax),%eax
80100d88:	52                   	push   %edx
80100d89:	50                   	push   %eax
80100d8a:	ff 75 dc             	pushl  -0x24(%ebp)
80100d8d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d90:	e8 26 76 00 00       	call   801083bb <copyout>
80100d95:	83 c4 10             	add    $0x10,%esp
80100d98:	85 c0                	test   %eax,%eax
80100d9a:	0f 88 5d 01 00 00    	js     80100efd <exec+0x3a1>
      goto bad;
    ustack[3+argc] = sp;
80100da0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100da3:	8d 50 03             	lea    0x3(%eax),%edx
80100da6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100da9:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100db0:	ff 45 e4             	incl   -0x1c(%ebp)
80100db3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db6:	c1 e0 02             	shl    $0x2,%eax
80100db9:	03 45 0c             	add    0xc(%ebp),%eax
80100dbc:	8b 00                	mov    (%eax),%eax
80100dbe:	85 c0                	test   %eax,%eax
80100dc0:	0f 85 71 ff ff ff    	jne    80100d37 <exec+0x1db>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100dc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc9:	83 c0 03             	add    $0x3,%eax
80100dcc:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100dd3:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dd7:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dde:	ff ff ff 
  ustack[1] = argc;
80100de1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de4:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ded:	40                   	inc    %eax
80100dee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100df5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100df8:	29 d0                	sub    %edx,%eax
80100dfa:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e03:	83 c0 04             	add    $0x4,%eax
80100e06:	c1 e0 02             	shl    $0x2,%eax
80100e09:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0f:	83 c0 04             	add    $0x4,%eax
80100e12:	c1 e0 02             	shl    $0x2,%eax
80100e15:	50                   	push   %eax
80100e16:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e1c:	50                   	push   %eax
80100e1d:	ff 75 dc             	pushl  -0x24(%ebp)
80100e20:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e23:	e8 93 75 00 00       	call   801083bb <copyout>
80100e28:	83 c4 10             	add    $0x10,%esp
80100e2b:	85 c0                	test   %eax,%eax
80100e2d:	0f 88 cd 00 00 00    	js     80100f00 <exec+0x3a4>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e33:	8b 45 08             	mov    0x8(%ebp),%eax
80100e36:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e3f:	eb 13                	jmp    80100e54 <exec+0x2f8>
    if(*s == '/')
80100e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e44:	8a 00                	mov    (%eax),%al
80100e46:	3c 2f                	cmp    $0x2f,%al
80100e48:	75 07                	jne    80100e51 <exec+0x2f5>
      last = s+1;
80100e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e4d:	40                   	inc    %eax
80100e4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e51:	ff 45 f4             	incl   -0xc(%ebp)
80100e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e57:	8a 00                	mov    (%eax),%al
80100e59:	84 c0                	test   %al,%al
80100e5b:	75 e4                	jne    80100e41 <exec+0x2e5>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e5d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e63:	83 c0 6c             	add    $0x6c,%eax
80100e66:	83 ec 04             	sub    $0x4,%esp
80100e69:	6a 10                	push   $0x10
80100e6b:	ff 75 f0             	pushl  -0x10(%ebp)
80100e6e:	50                   	push   %eax
80100e6f:	e8 a5 45 00 00       	call   80105419 <safestrcpy>
80100e74:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e7d:	8b 40 04             	mov    0x4(%eax),%eax
80100e80:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e83:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e89:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e8c:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e8f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e95:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100e98:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea0:	8b 40 18             	mov    0x18(%eax),%eax
80100ea3:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ea9:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100eac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb2:	8b 40 18             	mov    0x18(%eax),%eax
80100eb5:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100eb8:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ebb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec1:	83 ec 0c             	sub    $0xc,%esp
80100ec4:	50                   	push   %eax
80100ec5:	e8 69 6e 00 00       	call   80107d33 <switchuvm>
80100eca:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100ecd:	83 ec 0c             	sub    $0xc,%esp
80100ed0:	ff 75 d0             	pushl  -0x30(%ebp)
80100ed3:	e8 9c 72 00 00       	call   80108174 <freevm>
80100ed8:	83 c4 10             	add    $0x10,%esp
  return 0;
80100edb:	b8 00 00 00 00       	mov    $0x0,%eax
80100ee0:	eb 51                	jmp    80100f33 <exec+0x3d7>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100ee2:	90                   	nop
80100ee3:	eb 1c                	jmp    80100f01 <exec+0x3a5>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100ee5:	90                   	nop
80100ee6:	eb 19                	jmp    80100f01 <exec+0x3a5>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100ee8:	90                   	nop
80100ee9:	eb 16                	jmp    80100f01 <exec+0x3a5>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100eeb:	90                   	nop
80100eec:	eb 13                	jmp    80100f01 <exec+0x3a5>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100eee:	90                   	nop
80100eef:	eb 10                	jmp    80100f01 <exec+0x3a5>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100ef1:	90                   	nop
80100ef2:	eb 0d                	jmp    80100f01 <exec+0x3a5>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100ef4:	90                   	nop
80100ef5:	eb 0a                	jmp    80100f01 <exec+0x3a5>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100ef7:	90                   	nop
80100ef8:	eb 07                	jmp    80100f01 <exec+0x3a5>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100efa:	90                   	nop
80100efb:	eb 04                	jmp    80100f01 <exec+0x3a5>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100efd:	90                   	nop
80100efe:	eb 01                	jmp    80100f01 <exec+0x3a5>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100f00:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100f01:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f05:	74 0e                	je     80100f15 <exec+0x3b9>
    freevm(pgdir);
80100f07:	83 ec 0c             	sub    $0xc,%esp
80100f0a:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f0d:	e8 62 72 00 00       	call   80108174 <freevm>
80100f12:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f15:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f19:	74 13                	je     80100f2e <exec+0x3d2>
    iunlockput(ip);
80100f1b:	83 ec 0c             	sub    $0xc,%esp
80100f1e:	ff 75 d8             	pushl  -0x28(%ebp)
80100f21:	e8 bd 0c 00 00       	call   80101be3 <iunlockput>
80100f26:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f29:	e8 2c 26 00 00       	call   8010355a <end_op>
  }
  return -1;
80100f2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f33:	c9                   	leave  
80100f34:	c3                   	ret    
80100f35:	00 00                	add    %al,(%eax)
	...

80100f38 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f38:	55                   	push   %ebp
80100f39:	89 e5                	mov    %esp,%ebp
80100f3b:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f3e:	83 ec 08             	sub    $0x8,%esp
80100f41:	68 ca 84 10 80       	push   $0x801084ca
80100f46:	68 20 08 11 80       	push   $0x80110820
80100f4b:	e8 52 40 00 00       	call   80104fa2 <initlock>
80100f50:	83 c4 10             	add    $0x10,%esp
}
80100f53:	c9                   	leave  
80100f54:	c3                   	ret    

80100f55 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f55:	55                   	push   %ebp
80100f56:	89 e5                	mov    %esp,%ebp
80100f58:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f5b:	83 ec 0c             	sub    $0xc,%esp
80100f5e:	68 20 08 11 80       	push   $0x80110820
80100f63:	e8 5b 40 00 00       	call   80104fc3 <acquire>
80100f68:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f6b:	c7 45 f4 54 08 11 80 	movl   $0x80110854,-0xc(%ebp)
80100f72:	eb 2d                	jmp    80100fa1 <filealloc+0x4c>
    if(f->ref == 0){
80100f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f77:	8b 40 04             	mov    0x4(%eax),%eax
80100f7a:	85 c0                	test   %eax,%eax
80100f7c:	75 1f                	jne    80100f9d <filealloc+0x48>
      f->ref = 1;
80100f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f81:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f88:	83 ec 0c             	sub    $0xc,%esp
80100f8b:	68 20 08 11 80       	push   $0x80110820
80100f90:	e8 94 40 00 00       	call   80105029 <release>
80100f95:	83 c4 10             	add    $0x10,%esp
      return f;
80100f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f9b:	eb 23                	jmp    80100fc0 <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f9d:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fa1:	b8 b4 11 11 80       	mov    $0x801111b4,%eax
80100fa6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100fa9:	72 c9                	jb     80100f74 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fab:	83 ec 0c             	sub    $0xc,%esp
80100fae:	68 20 08 11 80       	push   $0x80110820
80100fb3:	e8 71 40 00 00       	call   80105029 <release>
80100fb8:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fc0:	c9                   	leave  
80100fc1:	c3                   	ret    

80100fc2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fc2:	55                   	push   %ebp
80100fc3:	89 e5                	mov    %esp,%ebp
80100fc5:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80100fc8:	83 ec 0c             	sub    $0xc,%esp
80100fcb:	68 20 08 11 80       	push   $0x80110820
80100fd0:	e8 ee 3f 00 00       	call   80104fc3 <acquire>
80100fd5:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80100fd8:	8b 45 08             	mov    0x8(%ebp),%eax
80100fdb:	8b 40 04             	mov    0x4(%eax),%eax
80100fde:	85 c0                	test   %eax,%eax
80100fe0:	7f 0d                	jg     80100fef <filedup+0x2d>
    panic("filedup");
80100fe2:	83 ec 0c             	sub    $0xc,%esp
80100fe5:	68 d1 84 10 80       	push   $0x801084d1
80100fea:	e8 73 f5 ff ff       	call   80100562 <panic>
  f->ref++;
80100fef:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff2:	8b 40 04             	mov    0x4(%eax),%eax
80100ff5:	8d 50 01             	lea    0x1(%eax),%edx
80100ff8:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffb:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100ffe:	83 ec 0c             	sub    $0xc,%esp
80101001:	68 20 08 11 80       	push   $0x80110820
80101006:	e8 1e 40 00 00       	call   80105029 <release>
8010100b:	83 c4 10             	add    $0x10,%esp
  return f;
8010100e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101011:	c9                   	leave  
80101012:	c3                   	ret    

80101013 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101013:	55                   	push   %ebp
80101014:	89 e5                	mov    %esp,%ebp
80101016:	57                   	push   %edi
80101017:	56                   	push   %esi
80101018:	53                   	push   %ebx
80101019:	83 ec 2c             	sub    $0x2c,%esp
  struct file ff;

  acquire(&ftable.lock);
8010101c:	83 ec 0c             	sub    $0xc,%esp
8010101f:	68 20 08 11 80       	push   $0x80110820
80101024:	e8 9a 3f 00 00       	call   80104fc3 <acquire>
80101029:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010102c:	8b 45 08             	mov    0x8(%ebp),%eax
8010102f:	8b 40 04             	mov    0x4(%eax),%eax
80101032:	85 c0                	test   %eax,%eax
80101034:	7f 0d                	jg     80101043 <fileclose+0x30>
    panic("fileclose");
80101036:	83 ec 0c             	sub    $0xc,%esp
80101039:	68 d9 84 10 80       	push   $0x801084d9
8010103e:	e8 1f f5 ff ff       	call   80100562 <panic>
  if(--f->ref > 0){
80101043:	8b 45 08             	mov    0x8(%ebp),%eax
80101046:	8b 40 04             	mov    0x4(%eax),%eax
80101049:	8d 50 ff             	lea    -0x1(%eax),%edx
8010104c:	8b 45 08             	mov    0x8(%ebp),%eax
8010104f:	89 50 04             	mov    %edx,0x4(%eax)
80101052:	8b 45 08             	mov    0x8(%ebp),%eax
80101055:	8b 40 04             	mov    0x4(%eax),%eax
80101058:	85 c0                	test   %eax,%eax
8010105a:	7e 12                	jle    8010106e <fileclose+0x5b>
    release(&ftable.lock);
8010105c:	83 ec 0c             	sub    $0xc,%esp
8010105f:	68 20 08 11 80       	push   $0x80110820
80101064:	e8 c0 3f 00 00       	call   80105029 <release>
80101069:	83 c4 10             	add    $0x10,%esp
    return;
8010106c:	eb 79                	jmp    801010e7 <fileclose+0xd4>
  }
  ff = *f;
8010106e:	8b 45 08             	mov    0x8(%ebp),%eax
80101071:	8d 55 d0             	lea    -0x30(%ebp),%edx
80101074:	89 c3                	mov    %eax,%ebx
80101076:	b8 06 00 00 00       	mov    $0x6,%eax
8010107b:	89 d7                	mov    %edx,%edi
8010107d:	89 de                	mov    %ebx,%esi
8010107f:	89 c1                	mov    %eax,%ecx
80101081:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
80101083:	8b 45 08             	mov    0x8(%ebp),%eax
80101086:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010108d:	8b 45 08             	mov    0x8(%ebp),%eax
80101090:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101096:	83 ec 0c             	sub    $0xc,%esp
80101099:	68 20 08 11 80       	push   $0x80110820
8010109e:	e8 86 3f 00 00       	call   80105029 <release>
801010a3:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
801010a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
801010a9:	83 f8 01             	cmp    $0x1,%eax
801010ac:	75 18                	jne    801010c6 <fileclose+0xb3>
    pipeclose(ff.pipe, ff.writable);
801010ae:	8a 45 d9             	mov    -0x27(%ebp),%al
801010b1:	0f be d0             	movsbl %al,%edx
801010b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010b7:	83 ec 08             	sub    $0x8,%esp
801010ba:	52                   	push   %edx
801010bb:	50                   	push   %eax
801010bc:	e8 97 30 00 00       	call   80104158 <pipeclose>
801010c1:	83 c4 10             	add    $0x10,%esp
801010c4:	eb 21                	jmp    801010e7 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801010c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
801010c9:	83 f8 02             	cmp    $0x2,%eax
801010cc:	75 19                	jne    801010e7 <fileclose+0xd4>
    begin_op();
801010ce:	e8 fe 23 00 00       	call   801034d1 <begin_op>
    iput(ff.ip);
801010d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010d6:	83 ec 0c             	sub    $0xc,%esp
801010d9:	50                   	push   %eax
801010da:	e8 15 0a 00 00       	call   80101af4 <iput>
801010df:	83 c4 10             	add    $0x10,%esp
    end_op();
801010e2:	e8 73 24 00 00       	call   8010355a <end_op>
  }
}
801010e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010ea:	83 c4 00             	add    $0x0,%esp
801010ed:	5b                   	pop    %ebx
801010ee:	5e                   	pop    %esi
801010ef:	5f                   	pop    %edi
801010f0:	c9                   	leave  
801010f1:	c3                   	ret    

801010f2 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010f2:	55                   	push   %ebp
801010f3:	89 e5                	mov    %esp,%ebp
801010f5:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801010f8:	8b 45 08             	mov    0x8(%ebp),%eax
801010fb:	8b 00                	mov    (%eax),%eax
801010fd:	83 f8 02             	cmp    $0x2,%eax
80101100:	75 40                	jne    80101142 <filestat+0x50>
    ilock(f->ip);
80101102:	8b 45 08             	mov    0x8(%ebp),%eax
80101105:	8b 40 10             	mov    0x10(%eax),%eax
80101108:	83 ec 0c             	sub    $0xc,%esp
8010110b:	50                   	push   %eax
8010110c:	e8 15 08 00 00       	call   80101926 <ilock>
80101111:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101114:	8b 45 08             	mov    0x8(%ebp),%eax
80101117:	8b 40 10             	mov    0x10(%eax),%eax
8010111a:	83 ec 08             	sub    $0x8,%esp
8010111d:	ff 75 0c             	pushl  0xc(%ebp)
80101120:	50                   	push   %eax
80101121:	e8 0a 0d 00 00       	call   80101e30 <stati>
80101126:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101129:	8b 45 08             	mov    0x8(%ebp),%eax
8010112c:	8b 40 10             	mov    0x10(%eax),%eax
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	50                   	push   %eax
80101133:	e8 4b 09 00 00       	call   80101a83 <iunlock>
80101138:	83 c4 10             	add    $0x10,%esp
    return 0;
8010113b:	b8 00 00 00 00       	mov    $0x0,%eax
80101140:	eb 05                	jmp    80101147 <filestat+0x55>
  }
  return -1;
80101142:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101147:	c9                   	leave  
80101148:	c3                   	ret    

80101149 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101149:	55                   	push   %ebp
8010114a:	89 e5                	mov    %esp,%ebp
8010114c:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
8010114f:	8b 45 08             	mov    0x8(%ebp),%eax
80101152:	8a 40 08             	mov    0x8(%eax),%al
80101155:	84 c0                	test   %al,%al
80101157:	75 0a                	jne    80101163 <fileread+0x1a>
    return -1;
80101159:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010115e:	e9 9b 00 00 00       	jmp    801011fe <fileread+0xb5>
  if(f->type == FD_PIPE)
80101163:	8b 45 08             	mov    0x8(%ebp),%eax
80101166:	8b 00                	mov    (%eax),%eax
80101168:	83 f8 01             	cmp    $0x1,%eax
8010116b:	75 1a                	jne    80101187 <fileread+0x3e>
    return piperead(f->pipe, addr, n);
8010116d:	8b 45 08             	mov    0x8(%ebp),%eax
80101170:	8b 40 0c             	mov    0xc(%eax),%eax
80101173:	83 ec 04             	sub    $0x4,%esp
80101176:	ff 75 10             	pushl  0x10(%ebp)
80101179:	ff 75 0c             	pushl  0xc(%ebp)
8010117c:	50                   	push   %eax
8010117d:	e8 82 31 00 00       	call   80104304 <piperead>
80101182:	83 c4 10             	add    $0x10,%esp
80101185:	eb 77                	jmp    801011fe <fileread+0xb5>
  if(f->type == FD_INODE){
80101187:	8b 45 08             	mov    0x8(%ebp),%eax
8010118a:	8b 00                	mov    (%eax),%eax
8010118c:	83 f8 02             	cmp    $0x2,%eax
8010118f:	75 60                	jne    801011f1 <fileread+0xa8>
    ilock(f->ip);
80101191:	8b 45 08             	mov    0x8(%ebp),%eax
80101194:	8b 40 10             	mov    0x10(%eax),%eax
80101197:	83 ec 0c             	sub    $0xc,%esp
8010119a:	50                   	push   %eax
8010119b:	e8 86 07 00 00       	call   80101926 <ilock>
801011a0:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011a6:	8b 45 08             	mov    0x8(%ebp),%eax
801011a9:	8b 50 14             	mov    0x14(%eax),%edx
801011ac:	8b 45 08             	mov    0x8(%ebp),%eax
801011af:	8b 40 10             	mov    0x10(%eax),%eax
801011b2:	51                   	push   %ecx
801011b3:	52                   	push   %edx
801011b4:	ff 75 0c             	pushl  0xc(%ebp)
801011b7:	50                   	push   %eax
801011b8:	e8 b7 0c 00 00       	call   80101e74 <readi>
801011bd:	83 c4 10             	add    $0x10,%esp
801011c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011c7:	7e 11                	jle    801011da <fileread+0x91>
      f->off += r;
801011c9:	8b 45 08             	mov    0x8(%ebp),%eax
801011cc:	8b 50 14             	mov    0x14(%eax),%edx
801011cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011d2:	01 c2                	add    %eax,%edx
801011d4:	8b 45 08             	mov    0x8(%ebp),%eax
801011d7:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011da:	8b 45 08             	mov    0x8(%ebp),%eax
801011dd:	8b 40 10             	mov    0x10(%eax),%eax
801011e0:	83 ec 0c             	sub    $0xc,%esp
801011e3:	50                   	push   %eax
801011e4:	e8 9a 08 00 00       	call   80101a83 <iunlock>
801011e9:	83 c4 10             	add    $0x10,%esp
    return r;
801011ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011ef:	eb 0d                	jmp    801011fe <fileread+0xb5>
  }
  panic("fileread");
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	68 e3 84 10 80       	push   $0x801084e3
801011f9:	e8 64 f3 ff ff       	call   80100562 <panic>
}
801011fe:	c9                   	leave  
801011ff:	c3                   	ret    

80101200 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101200:	55                   	push   %ebp
80101201:	89 e5                	mov    %esp,%ebp
80101203:	53                   	push   %ebx
80101204:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
80101207:	8b 45 08             	mov    0x8(%ebp),%eax
8010120a:	8a 40 09             	mov    0x9(%eax),%al
8010120d:	84 c0                	test   %al,%al
8010120f:	75 0a                	jne    8010121b <filewrite+0x1b>
    return -1;
80101211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101216:	e9 21 01 00 00       	jmp    8010133c <filewrite+0x13c>
  if(f->type == FD_PIPE)
8010121b:	8b 45 08             	mov    0x8(%ebp),%eax
8010121e:	8b 00                	mov    (%eax),%eax
80101220:	83 f8 01             	cmp    $0x1,%eax
80101223:	75 1d                	jne    80101242 <filewrite+0x42>
    return pipewrite(f->pipe, addr, n);
80101225:	8b 45 08             	mov    0x8(%ebp),%eax
80101228:	8b 40 0c             	mov    0xc(%eax),%eax
8010122b:	83 ec 04             	sub    $0x4,%esp
8010122e:	ff 75 10             	pushl  0x10(%ebp)
80101231:	ff 75 0c             	pushl  0xc(%ebp)
80101234:	50                   	push   %eax
80101235:	e8 c8 2f 00 00       	call   80104202 <pipewrite>
8010123a:	83 c4 10             	add    $0x10,%esp
8010123d:	e9 fa 00 00 00       	jmp    8010133c <filewrite+0x13c>
  if(f->type == FD_INODE){
80101242:	8b 45 08             	mov    0x8(%ebp),%eax
80101245:	8b 00                	mov    (%eax),%eax
80101247:	83 f8 02             	cmp    $0x2,%eax
8010124a:	0f 85 df 00 00 00    	jne    8010132f <filewrite+0x12f>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101250:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101257:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010125e:	e9 a9 00 00 00       	jmp    8010130c <filewrite+0x10c>
      int n1 = n - i;
80101263:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101266:	8b 55 10             	mov    0x10(%ebp),%edx
80101269:	89 d1                	mov    %edx,%ecx
8010126b:	29 c1                	sub    %eax,%ecx
8010126d:	89 c8                	mov    %ecx,%eax
8010126f:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101272:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101275:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101278:	7e 06                	jle    80101280 <filewrite+0x80>
        n1 = max;
8010127a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010127d:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101280:	e8 4c 22 00 00       	call   801034d1 <begin_op>
      ilock(f->ip);
80101285:	8b 45 08             	mov    0x8(%ebp),%eax
80101288:	8b 40 10             	mov    0x10(%eax),%eax
8010128b:	83 ec 0c             	sub    $0xc,%esp
8010128e:	50                   	push   %eax
8010128f:	e8 92 06 00 00       	call   80101926 <ilock>
80101294:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101297:	8b 5d f0             	mov    -0x10(%ebp),%ebx
8010129a:	8b 45 08             	mov    0x8(%ebp),%eax
8010129d:	8b 48 14             	mov    0x14(%eax),%ecx
801012a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012a3:	89 c2                	mov    %eax,%edx
801012a5:	03 55 0c             	add    0xc(%ebp),%edx
801012a8:	8b 45 08             	mov    0x8(%ebp),%eax
801012ab:	8b 40 10             	mov    0x10(%eax),%eax
801012ae:	53                   	push   %ebx
801012af:	51                   	push   %ecx
801012b0:	52                   	push   %edx
801012b1:	50                   	push   %eax
801012b2:	e8 1d 0d 00 00       	call   80101fd4 <writei>
801012b7:	83 c4 10             	add    $0x10,%esp
801012ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012c1:	7e 11                	jle    801012d4 <filewrite+0xd4>
        f->off += r;
801012c3:	8b 45 08             	mov    0x8(%ebp),%eax
801012c6:	8b 50 14             	mov    0x14(%eax),%edx
801012c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012cc:	01 c2                	add    %eax,%edx
801012ce:	8b 45 08             	mov    0x8(%ebp),%eax
801012d1:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012d4:	8b 45 08             	mov    0x8(%ebp),%eax
801012d7:	8b 40 10             	mov    0x10(%eax),%eax
801012da:	83 ec 0c             	sub    $0xc,%esp
801012dd:	50                   	push   %eax
801012de:	e8 a0 07 00 00       	call   80101a83 <iunlock>
801012e3:	83 c4 10             	add    $0x10,%esp
      end_op();
801012e6:	e8 6f 22 00 00       	call   8010355a <end_op>

      if(r < 0)
801012eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012ef:	78 29                	js     8010131a <filewrite+0x11a>
        break;
      if(r != n1)
801012f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012f7:	74 0d                	je     80101306 <filewrite+0x106>
        panic("short filewrite");
801012f9:	83 ec 0c             	sub    $0xc,%esp
801012fc:	68 ec 84 10 80       	push   $0x801084ec
80101301:	e8 5c f2 ff ff       	call   80100562 <panic>
      i += r;
80101306:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101309:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010130c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010130f:	3b 45 10             	cmp    0x10(%ebp),%eax
80101312:	0f 8c 4b ff ff ff    	jl     80101263 <filewrite+0x63>
80101318:	eb 01                	jmp    8010131b <filewrite+0x11b>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
8010131a:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010131b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010131e:	3b 45 10             	cmp    0x10(%ebp),%eax
80101321:	75 05                	jne    80101328 <filewrite+0x128>
80101323:	8b 45 10             	mov    0x10(%ebp),%eax
80101326:	eb 05                	jmp    8010132d <filewrite+0x12d>
80101328:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010132d:	eb 0d                	jmp    8010133c <filewrite+0x13c>
  }
  panic("filewrite");
8010132f:	83 ec 0c             	sub    $0xc,%esp
80101332:	68 fc 84 10 80       	push   $0x801084fc
80101337:	e8 26 f2 ff ff       	call   80100562 <panic>
}
8010133c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010133f:	c9                   	leave  
80101340:	c3                   	ret    
80101341:	00 00                	add    %al,(%eax)
	...

80101344 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101344:	55                   	push   %ebp
80101345:	89 e5                	mov    %esp,%ebp
80101347:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010134a:	8b 45 08             	mov    0x8(%ebp),%eax
8010134d:	83 ec 08             	sub    $0x8,%esp
80101350:	6a 01                	push   $0x1
80101352:	50                   	push   %eax
80101353:	e8 5d ee ff ff       	call   801001b5 <bread>
80101358:	83 c4 10             	add    $0x10,%esp
8010135b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010135e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101361:	83 c0 18             	add    $0x18,%eax
80101364:	83 ec 04             	sub    $0x4,%esp
80101367:	6a 1c                	push   $0x1c
80101369:	50                   	push   %eax
8010136a:	ff 75 0c             	pushl  0xc(%ebp)
8010136d:	e8 68 3f 00 00       	call   801052da <memmove>
80101372:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101375:	83 ec 0c             	sub    $0xc,%esp
80101378:	ff 75 f4             	pushl  -0xc(%ebp)
8010137b:	e8 ac ee ff ff       	call   8010022c <brelse>
80101380:	83 c4 10             	add    $0x10,%esp
}
80101383:	c9                   	leave  
80101384:	c3                   	ret    

80101385 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101385:	55                   	push   %ebp
80101386:	89 e5                	mov    %esp,%ebp
80101388:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010138b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010138e:	8b 45 08             	mov    0x8(%ebp),%eax
80101391:	83 ec 08             	sub    $0x8,%esp
80101394:	52                   	push   %edx
80101395:	50                   	push   %eax
80101396:	e8 1a ee ff ff       	call   801001b5 <bread>
8010139b:	83 c4 10             	add    $0x10,%esp
8010139e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a4:	83 c0 18             	add    $0x18,%eax
801013a7:	83 ec 04             	sub    $0x4,%esp
801013aa:	68 00 02 00 00       	push   $0x200
801013af:	6a 00                	push   $0x0
801013b1:	50                   	push   %eax
801013b2:	e8 67 3e 00 00       	call   8010521e <memset>
801013b7:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801013ba:	83 ec 0c             	sub    $0xc,%esp
801013bd:	ff 75 f4             	pushl  -0xc(%ebp)
801013c0:	e8 36 23 00 00       	call   801036fb <log_write>
801013c5:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013c8:	83 ec 0c             	sub    $0xc,%esp
801013cb:	ff 75 f4             	pushl  -0xc(%ebp)
801013ce:	e8 59 ee ff ff       	call   8010022c <brelse>
801013d3:	83 c4 10             	add    $0x10,%esp
}
801013d6:	c9                   	leave  
801013d7:	c3                   	ret    

801013d8 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013d8:	55                   	push   %ebp
801013d9:	89 e5                	mov    %esp,%ebp
801013db:	53                   	push   %ebx
801013dc:	83 ec 14             	sub    $0x14,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801013df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801013e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013ed:	e9 15 01 00 00       	jmp    80101507 <balloc+0x12f>
    bp = bread(dev, BBLOCK(b, sb));
801013f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f5:	85 c0                	test   %eax,%eax
801013f7:	79 05                	jns    801013fe <balloc+0x26>
801013f9:	05 ff 0f 00 00       	add    $0xfff,%eax
801013fe:	c1 f8 0c             	sar    $0xc,%eax
80101401:	89 c2                	mov    %eax,%edx
80101403:	a1 38 12 11 80       	mov    0x80111238,%eax
80101408:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010140b:	83 ec 08             	sub    $0x8,%esp
8010140e:	50                   	push   %eax
8010140f:	ff 75 08             	pushl  0x8(%ebp)
80101412:	e8 9e ed ff ff       	call   801001b5 <bread>
80101417:	83 c4 10             	add    $0x10,%esp
8010141a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010141d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101424:	e9 a8 00 00 00       	jmp    801014d1 <balloc+0xf9>
      m = 1 << (bi % 8);
80101429:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010142c:	25 07 00 00 80       	and    $0x80000007,%eax
80101431:	85 c0                	test   %eax,%eax
80101433:	79 05                	jns    8010143a <balloc+0x62>
80101435:	48                   	dec    %eax
80101436:	83 c8 f8             	or     $0xfffffff8,%eax
80101439:	40                   	inc    %eax
8010143a:	ba 01 00 00 00       	mov    $0x1,%edx
8010143f:	89 d3                	mov    %edx,%ebx
80101441:	88 c1                	mov    %al,%cl
80101443:	d3 e3                	shl    %cl,%ebx
80101445:	89 d8                	mov    %ebx,%eax
80101447:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010144a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010144d:	85 c0                	test   %eax,%eax
8010144f:	79 03                	jns    80101454 <balloc+0x7c>
80101451:	83 c0 07             	add    $0x7,%eax
80101454:	c1 f8 03             	sar    $0x3,%eax
80101457:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010145a:	8a 44 02 18          	mov    0x18(%edx,%eax,1),%al
8010145e:	0f b6 c0             	movzbl %al,%eax
80101461:	23 45 e8             	and    -0x18(%ebp),%eax
80101464:	85 c0                	test   %eax,%eax
80101466:	75 66                	jne    801014ce <balloc+0xf6>
        bp->data[bi/8] |= m;  // Mark block in use.
80101468:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010146b:	85 c0                	test   %eax,%eax
8010146d:	79 03                	jns    80101472 <balloc+0x9a>
8010146f:	83 c0 07             	add    $0x7,%eax
80101472:	c1 f8 03             	sar    $0x3,%eax
80101475:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101478:	8a 54 02 18          	mov    0x18(%edx,%eax,1),%dl
8010147c:	88 d1                	mov    %dl,%cl
8010147e:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101481:	09 ca                	or     %ecx,%edx
80101483:	88 d1                	mov    %dl,%cl
80101485:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101488:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010148c:	83 ec 0c             	sub    $0xc,%esp
8010148f:	ff 75 ec             	pushl  -0x14(%ebp)
80101492:	e8 64 22 00 00       	call   801036fb <log_write>
80101497:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
8010149a:	83 ec 0c             	sub    $0xc,%esp
8010149d:	ff 75 ec             	pushl  -0x14(%ebp)
801014a0:	e8 87 ed ff ff       	call   8010022c <brelse>
801014a5:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801014a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014ae:	01 c2                	add    %eax,%edx
801014b0:	8b 45 08             	mov    0x8(%ebp),%eax
801014b3:	83 ec 08             	sub    $0x8,%esp
801014b6:	52                   	push   %edx
801014b7:	50                   	push   %eax
801014b8:	e8 c8 fe ff ff       	call   80101385 <bzero>
801014bd:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801014c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014c6:	8d 04 02             	lea    (%edx,%eax,1),%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801014c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014cc:	c9                   	leave  
801014cd:	c3                   	ret    
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014ce:	ff 45 f0             	incl   -0x10(%ebp)
801014d1:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014d8:	7f 18                	jg     801014f2 <balloc+0x11a>
801014da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014e0:	8d 04 02             	lea    (%edx,%eax,1),%eax
801014e3:	89 c2                	mov    %eax,%edx
801014e5:	a1 20 12 11 80       	mov    0x80111220,%eax
801014ea:	39 c2                	cmp    %eax,%edx
801014ec:	0f 82 37 ff ff ff    	jb     80101429 <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014f2:	83 ec 0c             	sub    $0xc,%esp
801014f5:	ff 75 ec             	pushl  -0x14(%ebp)
801014f8:	e8 2f ed ff ff       	call   8010022c <brelse>
801014fd:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101500:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101507:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010150a:	a1 20 12 11 80       	mov    0x80111220,%eax
8010150f:	39 c2                	cmp    %eax,%edx
80101511:	0f 82 db fe ff ff    	jb     801013f2 <balloc+0x1a>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101517:	83 ec 0c             	sub    $0xc,%esp
8010151a:	68 08 85 10 80       	push   $0x80108508
8010151f:	e8 3e f0 ff ff       	call   80100562 <panic>

80101524 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101524:	55                   	push   %ebp
80101525:	89 e5                	mov    %esp,%ebp
80101527:	53                   	push   %ebx
80101528:	83 ec 14             	sub    $0x14,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010152b:	83 ec 08             	sub    $0x8,%esp
8010152e:	68 20 12 11 80       	push   $0x80111220
80101533:	ff 75 08             	pushl  0x8(%ebp)
80101536:	e8 09 fe ff ff       	call   80101344 <readsb>
8010153b:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
8010153e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101541:	89 c2                	mov    %eax,%edx
80101543:	c1 ea 0c             	shr    $0xc,%edx
80101546:	a1 38 12 11 80       	mov    0x80111238,%eax
8010154b:	01 c2                	add    %eax,%edx
8010154d:	8b 45 08             	mov    0x8(%ebp),%eax
80101550:	83 ec 08             	sub    $0x8,%esp
80101553:	52                   	push   %edx
80101554:	50                   	push   %eax
80101555:	e8 5b ec ff ff       	call   801001b5 <bread>
8010155a:	83 c4 10             	add    $0x10,%esp
8010155d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101560:	8b 45 0c             	mov    0xc(%ebp),%eax
80101563:	25 ff 0f 00 00       	and    $0xfff,%eax
80101568:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010156b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010156e:	25 07 00 00 80       	and    $0x80000007,%eax
80101573:	85 c0                	test   %eax,%eax
80101575:	79 05                	jns    8010157c <bfree+0x58>
80101577:	48                   	dec    %eax
80101578:	83 c8 f8             	or     $0xfffffff8,%eax
8010157b:	40                   	inc    %eax
8010157c:	ba 01 00 00 00       	mov    $0x1,%edx
80101581:	89 d3                	mov    %edx,%ebx
80101583:	88 c1                	mov    %al,%cl
80101585:	d3 e3                	shl    %cl,%ebx
80101587:	89 d8                	mov    %ebx,%eax
80101589:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010158c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010158f:	85 c0                	test   %eax,%eax
80101591:	79 03                	jns    80101596 <bfree+0x72>
80101593:	83 c0 07             	add    $0x7,%eax
80101596:	c1 f8 03             	sar    $0x3,%eax
80101599:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010159c:	8a 44 02 18          	mov    0x18(%edx,%eax,1),%al
801015a0:	0f b6 c0             	movzbl %al,%eax
801015a3:	23 45 ec             	and    -0x14(%ebp),%eax
801015a6:	85 c0                	test   %eax,%eax
801015a8:	75 0d                	jne    801015b7 <bfree+0x93>
    panic("freeing free block");
801015aa:	83 ec 0c             	sub    $0xc,%esp
801015ad:	68 1e 85 10 80       	push   $0x8010851e
801015b2:	e8 ab ef ff ff       	call   80100562 <panic>
  bp->data[bi/8] &= ~m;
801015b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015ba:	85 c0                	test   %eax,%eax
801015bc:	79 03                	jns    801015c1 <bfree+0x9d>
801015be:	83 c0 07             	add    $0x7,%eax
801015c1:	c1 f8 03             	sar    $0x3,%eax
801015c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015c7:	8a 54 02 18          	mov    0x18(%edx,%eax,1),%dl
801015cb:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015ce:	f7 d1                	not    %ecx
801015d0:	21 ca                	and    %ecx,%edx
801015d2:	88 d1                	mov    %dl,%cl
801015d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015d7:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801015db:	83 ec 0c             	sub    $0xc,%esp
801015de:	ff 75 f4             	pushl  -0xc(%ebp)
801015e1:	e8 15 21 00 00       	call   801036fb <log_write>
801015e6:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801015e9:	83 ec 0c             	sub    $0xc,%esp
801015ec:	ff 75 f4             	pushl  -0xc(%ebp)
801015ef:	e8 38 ec ff ff       	call   8010022c <brelse>
801015f4:	83 c4 10             	add    $0x10,%esp
}
801015f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015fa:	c9                   	leave  
801015fb:	c3                   	ret    

801015fc <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801015fc:	55                   	push   %ebp
801015fd:	89 e5                	mov    %esp,%ebp
801015ff:	57                   	push   %edi
80101600:	56                   	push   %esi
80101601:	53                   	push   %ebx
80101602:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
80101605:	83 ec 08             	sub    $0x8,%esp
80101608:	68 31 85 10 80       	push   $0x80108531
8010160d:	68 40 12 11 80       	push   $0x80111240
80101612:	e8 8b 39 00 00       	call   80104fa2 <initlock>
80101617:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
8010161a:	83 ec 08             	sub    $0x8,%esp
8010161d:	68 20 12 11 80       	push   $0x80111220
80101622:	ff 75 08             	pushl  0x8(%ebp)
80101625:	e8 1a fd ff ff       	call   80101344 <readsb>
8010162a:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
8010162d:	a1 38 12 11 80       	mov    0x80111238,%eax
80101632:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101635:	8b 3d 34 12 11 80    	mov    0x80111234,%edi
8010163b:	8b 35 30 12 11 80    	mov    0x80111230,%esi
80101641:	8b 1d 2c 12 11 80    	mov    0x8011122c,%ebx
80101647:	8b 0d 28 12 11 80    	mov    0x80111228,%ecx
8010164d:	8b 15 24 12 11 80    	mov    0x80111224,%edx
80101653:	a1 20 12 11 80       	mov    0x80111220,%eax
80101658:	ff 75 e4             	pushl  -0x1c(%ebp)
8010165b:	57                   	push   %edi
8010165c:	56                   	push   %esi
8010165d:	53                   	push   %ebx
8010165e:	51                   	push   %ecx
8010165f:	52                   	push   %edx
80101660:	50                   	push   %eax
80101661:	68 38 85 10 80       	push   $0x80108538
80101666:	e8 58 ed ff ff       	call   801003c3 <cprintf>
8010166b:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
8010166e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101671:	83 c4 00             	add    $0x0,%esp
80101674:	5b                   	pop    %ebx
80101675:	5e                   	pop    %esi
80101676:	5f                   	pop    %edi
80101677:	c9                   	leave  
80101678:	c3                   	ret    

80101679 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101679:	55                   	push   %ebp
8010167a:	89 e5                	mov    %esp,%ebp
8010167c:	83 ec 28             	sub    $0x28,%esp
8010167f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101682:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101686:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010168d:	e9 9c 00 00 00       	jmp    8010172e <ialloc+0xb5>
    bp = bread(dev, IBLOCK(inum, sb));
80101692:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101695:	89 c2                	mov    %eax,%edx
80101697:	c1 ea 03             	shr    $0x3,%edx
8010169a:	a1 34 12 11 80       	mov    0x80111234,%eax
8010169f:	8d 04 02             	lea    (%edx,%eax,1),%eax
801016a2:	83 ec 08             	sub    $0x8,%esp
801016a5:	50                   	push   %eax
801016a6:	ff 75 08             	pushl  0x8(%ebp)
801016a9:	e8 07 eb ff ff       	call   801001b5 <bread>
801016ae:	83 c4 10             	add    $0x10,%esp
801016b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801016b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016b7:	83 c0 18             	add    $0x18,%eax
801016ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016bd:	83 e2 07             	and    $0x7,%edx
801016c0:	c1 e2 06             	shl    $0x6,%edx
801016c3:	01 d0                	add    %edx,%eax
801016c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801016c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016cb:	8b 00                	mov    (%eax),%eax
801016cd:	66 85 c0             	test   %ax,%ax
801016d0:	75 4b                	jne    8010171d <ialloc+0xa4>
      memset(dip, 0, sizeof(*dip));
801016d2:	83 ec 04             	sub    $0x4,%esp
801016d5:	6a 40                	push   $0x40
801016d7:	6a 00                	push   $0x0
801016d9:	ff 75 ec             	pushl  -0x14(%ebp)
801016dc:	e8 3d 3b 00 00       	call   8010521e <memset>
801016e1:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801016e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016ea:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
801016ed:	83 ec 0c             	sub    $0xc,%esp
801016f0:	ff 75 f0             	pushl  -0x10(%ebp)
801016f3:	e8 03 20 00 00       	call   801036fb <log_write>
801016f8:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801016fb:	83 ec 0c             	sub    $0xc,%esp
801016fe:	ff 75 f0             	pushl  -0x10(%ebp)
80101701:	e8 26 eb ff ff       	call   8010022c <brelse>
80101706:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
80101709:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010170c:	83 ec 08             	sub    $0x8,%esp
8010170f:	50                   	push   %eax
80101710:	ff 75 08             	pushl  0x8(%ebp)
80101713:	e8 f4 00 00 00       	call   8010180c <iget>
80101718:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
8010171b:	c9                   	leave  
8010171c:	c3                   	ret    
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
8010171d:	83 ec 0c             	sub    $0xc,%esp
80101720:	ff 75 f0             	pushl  -0x10(%ebp)
80101723:	e8 04 eb ff ff       	call   8010022c <brelse>
80101728:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010172b:	ff 45 f4             	incl   -0xc(%ebp)
8010172e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101731:	a1 28 12 11 80       	mov    0x80111228,%eax
80101736:	39 c2                	cmp    %eax,%edx
80101738:	0f 82 54 ff ff ff    	jb     80101692 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
8010173e:	83 ec 0c             	sub    $0xc,%esp
80101741:	68 8b 85 10 80       	push   $0x8010858b
80101746:	e8 17 ee ff ff       	call   80100562 <panic>

8010174b <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
8010174b:	55                   	push   %ebp
8010174c:	89 e5                	mov    %esp,%ebp
8010174e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101751:	8b 45 08             	mov    0x8(%ebp),%eax
80101754:	8b 40 04             	mov    0x4(%eax),%eax
80101757:	89 c2                	mov    %eax,%edx
80101759:	c1 ea 03             	shr    $0x3,%edx
8010175c:	a1 34 12 11 80       	mov    0x80111234,%eax
80101761:	01 c2                	add    %eax,%edx
80101763:	8b 45 08             	mov    0x8(%ebp),%eax
80101766:	8b 00                	mov    (%eax),%eax
80101768:	83 ec 08             	sub    $0x8,%esp
8010176b:	52                   	push   %edx
8010176c:	50                   	push   %eax
8010176d:	e8 43 ea ff ff       	call   801001b5 <bread>
80101772:	83 c4 10             	add    $0x10,%esp
80101775:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101778:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010177b:	83 c0 18             	add    $0x18,%eax
8010177e:	89 c2                	mov    %eax,%edx
80101780:	8b 45 08             	mov    0x8(%ebp),%eax
80101783:	8b 40 04             	mov    0x4(%eax),%eax
80101786:	83 e0 07             	and    $0x7,%eax
80101789:	c1 e0 06             	shl    $0x6,%eax
8010178c:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010178f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101792:	8b 45 08             	mov    0x8(%ebp),%eax
80101795:	8b 40 10             	mov    0x10(%eax),%eax
80101798:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010179b:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
8010179e:	8b 45 08             	mov    0x8(%ebp),%eax
801017a1:	66 8b 40 12          	mov    0x12(%eax),%ax
801017a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801017a8:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
801017ac:	8b 45 08             	mov    0x8(%ebp),%eax
801017af:	8b 40 14             	mov    0x14(%eax),%eax
801017b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801017b5:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
801017b9:	8b 45 08             	mov    0x8(%ebp),%eax
801017bc:	66 8b 40 16          	mov    0x16(%eax),%ax
801017c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801017c3:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
801017c7:	8b 45 08             	mov    0x8(%ebp),%eax
801017ca:	8b 50 18             	mov    0x18(%eax),%edx
801017cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017d0:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017d3:	8b 45 08             	mov    0x8(%ebp),%eax
801017d6:	8d 50 1c             	lea    0x1c(%eax),%edx
801017d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017dc:	83 c0 0c             	add    $0xc,%eax
801017df:	83 ec 04             	sub    $0x4,%esp
801017e2:	6a 34                	push   $0x34
801017e4:	52                   	push   %edx
801017e5:	50                   	push   %eax
801017e6:	e8 ef 3a 00 00       	call   801052da <memmove>
801017eb:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801017ee:	83 ec 0c             	sub    $0xc,%esp
801017f1:	ff 75 f4             	pushl  -0xc(%ebp)
801017f4:	e8 02 1f 00 00       	call   801036fb <log_write>
801017f9:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801017fc:	83 ec 0c             	sub    $0xc,%esp
801017ff:	ff 75 f4             	pushl  -0xc(%ebp)
80101802:	e8 25 ea ff ff       	call   8010022c <brelse>
80101807:	83 c4 10             	add    $0x10,%esp
}
8010180a:	c9                   	leave  
8010180b:	c3                   	ret    

8010180c <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010180c:	55                   	push   %ebp
8010180d:	89 e5                	mov    %esp,%ebp
8010180f:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101812:	83 ec 0c             	sub    $0xc,%esp
80101815:	68 40 12 11 80       	push   $0x80111240
8010181a:	e8 a4 37 00 00       	call   80104fc3 <acquire>
8010181f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101822:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101829:	c7 45 f4 74 12 11 80 	movl   $0x80111274,-0xc(%ebp)
80101830:	eb 5d                	jmp    8010188f <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101832:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101835:	8b 40 08             	mov    0x8(%eax),%eax
80101838:	85 c0                	test   %eax,%eax
8010183a:	7e 39                	jle    80101875 <iget+0x69>
8010183c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183f:	8b 00                	mov    (%eax),%eax
80101841:	3b 45 08             	cmp    0x8(%ebp),%eax
80101844:	75 2f                	jne    80101875 <iget+0x69>
80101846:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101849:	8b 40 04             	mov    0x4(%eax),%eax
8010184c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010184f:	75 24                	jne    80101875 <iget+0x69>
      ip->ref++;
80101851:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101854:	8b 40 08             	mov    0x8(%eax),%eax
80101857:	8d 50 01             	lea    0x1(%eax),%edx
8010185a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010185d:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101860:	83 ec 0c             	sub    $0xc,%esp
80101863:	68 40 12 11 80       	push   $0x80111240
80101868:	e8 bc 37 00 00       	call   80105029 <release>
8010186d:	83 c4 10             	add    $0x10,%esp
      return ip;
80101870:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101873:	eb 75                	jmp    801018ea <iget+0xde>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101875:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101879:	75 10                	jne    8010188b <iget+0x7f>
8010187b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010187e:	8b 40 08             	mov    0x8(%eax),%eax
80101881:	85 c0                	test   %eax,%eax
80101883:	75 06                	jne    8010188b <iget+0x7f>
      empty = ip;
80101885:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101888:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010188b:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
8010188f:	b8 14 22 11 80       	mov    $0x80112214,%eax
80101894:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101897:	72 99                	jb     80101832 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101899:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010189d:	75 0d                	jne    801018ac <iget+0xa0>
    panic("iget: no inodes");
8010189f:	83 ec 0c             	sub    $0xc,%esp
801018a2:	68 9d 85 10 80       	push   $0x8010859d
801018a7:	e8 b6 ec ff ff       	call   80100562 <panic>

  ip = empty;
801018ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801018b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b5:	8b 55 08             	mov    0x8(%ebp),%edx
801018b8:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801018ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018bd:	8b 55 0c             	mov    0xc(%ebp),%edx
801018c0:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801018c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801018cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018d0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801018d7:	83 ec 0c             	sub    $0xc,%esp
801018da:	68 40 12 11 80       	push   $0x80111240
801018df:	e8 45 37 00 00       	call   80105029 <release>
801018e4:	83 c4 10             	add    $0x10,%esp

  return ip;
801018e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801018ea:	c9                   	leave  
801018eb:	c3                   	ret    

801018ec <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801018ec:	55                   	push   %ebp
801018ed:	89 e5                	mov    %esp,%ebp
801018ef:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801018f2:	83 ec 0c             	sub    $0xc,%esp
801018f5:	68 40 12 11 80       	push   $0x80111240
801018fa:	e8 c4 36 00 00       	call   80104fc3 <acquire>
801018ff:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101902:	8b 45 08             	mov    0x8(%ebp),%eax
80101905:	8b 40 08             	mov    0x8(%eax),%eax
80101908:	8d 50 01             	lea    0x1(%eax),%edx
8010190b:	8b 45 08             	mov    0x8(%ebp),%eax
8010190e:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101911:	83 ec 0c             	sub    $0xc,%esp
80101914:	68 40 12 11 80       	push   $0x80111240
80101919:	e8 0b 37 00 00       	call   80105029 <release>
8010191e:	83 c4 10             	add    $0x10,%esp
  return ip;
80101921:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101924:	c9                   	leave  
80101925:	c3                   	ret    

80101926 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101926:	55                   	push   %ebp
80101927:	89 e5                	mov    %esp,%ebp
80101929:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010192c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101930:	74 0a                	je     8010193c <ilock+0x16>
80101932:	8b 45 08             	mov    0x8(%ebp),%eax
80101935:	8b 40 08             	mov    0x8(%eax),%eax
80101938:	85 c0                	test   %eax,%eax
8010193a:	7f 0d                	jg     80101949 <ilock+0x23>
    panic("ilock");
8010193c:	83 ec 0c             	sub    $0xc,%esp
8010193f:	68 ad 85 10 80       	push   $0x801085ad
80101944:	e8 19 ec ff ff       	call   80100562 <panic>

  acquire(&icache.lock);
80101949:	83 ec 0c             	sub    $0xc,%esp
8010194c:	68 40 12 11 80       	push   $0x80111240
80101951:	e8 6d 36 00 00       	call   80104fc3 <acquire>
80101956:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101959:	eb 13                	jmp    8010196e <ilock+0x48>
    sleep(ip, &icache.lock);
8010195b:	83 ec 08             	sub    $0x8,%esp
8010195e:	68 40 12 11 80       	push   $0x80111240
80101963:	ff 75 08             	pushl  0x8(%ebp)
80101966:	e8 54 33 00 00       	call   80104cbf <sleep>
8010196b:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
8010196e:	8b 45 08             	mov    0x8(%ebp),%eax
80101971:	8b 40 0c             	mov    0xc(%eax),%eax
80101974:	83 e0 01             	and    $0x1,%eax
80101977:	84 c0                	test   %al,%al
80101979:	75 e0                	jne    8010195b <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
8010197b:	8b 45 08             	mov    0x8(%ebp),%eax
8010197e:	8b 40 0c             	mov    0xc(%eax),%eax
80101981:	89 c2                	mov    %eax,%edx
80101983:	83 ca 01             	or     $0x1,%edx
80101986:	8b 45 08             	mov    0x8(%ebp),%eax
80101989:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
8010198c:	83 ec 0c             	sub    $0xc,%esp
8010198f:	68 40 12 11 80       	push   $0x80111240
80101994:	e8 90 36 00 00       	call   80105029 <release>
80101999:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
8010199c:	8b 45 08             	mov    0x8(%ebp),%eax
8010199f:	8b 40 0c             	mov    0xc(%eax),%eax
801019a2:	83 e0 02             	and    $0x2,%eax
801019a5:	85 c0                	test   %eax,%eax
801019a7:	0f 85 d4 00 00 00    	jne    80101a81 <ilock+0x15b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019ad:	8b 45 08             	mov    0x8(%ebp),%eax
801019b0:	8b 40 04             	mov    0x4(%eax),%eax
801019b3:	89 c2                	mov    %eax,%edx
801019b5:	c1 ea 03             	shr    $0x3,%edx
801019b8:	a1 34 12 11 80       	mov    0x80111234,%eax
801019bd:	01 c2                	add    %eax,%edx
801019bf:	8b 45 08             	mov    0x8(%ebp),%eax
801019c2:	8b 00                	mov    (%eax),%eax
801019c4:	83 ec 08             	sub    $0x8,%esp
801019c7:	52                   	push   %edx
801019c8:	50                   	push   %eax
801019c9:	e8 e7 e7 ff ff       	call   801001b5 <bread>
801019ce:	83 c4 10             	add    $0x10,%esp
801019d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019d7:	83 c0 18             	add    $0x18,%eax
801019da:	89 c2                	mov    %eax,%edx
801019dc:	8b 45 08             	mov    0x8(%ebp),%eax
801019df:	8b 40 04             	mov    0x4(%eax),%eax
801019e2:	83 e0 07             	and    $0x7,%eax
801019e5:	c1 e0 06             	shl    $0x6,%eax
801019e8:	8d 04 02             	lea    (%edx,%eax,1),%eax
801019eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801019ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019f1:	8b 00                	mov    (%eax),%eax
801019f3:	8b 55 08             	mov    0x8(%ebp),%edx
801019f6:	66 89 42 10          	mov    %ax,0x10(%edx)
    ip->major = dip->major;
801019fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019fd:	66 8b 40 02          	mov    0x2(%eax),%ax
80101a01:	8b 55 08             	mov    0x8(%ebp),%edx
80101a04:	66 89 42 12          	mov    %ax,0x12(%edx)
    ip->minor = dip->minor;
80101a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a0b:	8b 40 04             	mov    0x4(%eax),%eax
80101a0e:	8b 55 08             	mov    0x8(%ebp),%edx
80101a11:	66 89 42 14          	mov    %ax,0x14(%edx)
    ip->nlink = dip->nlink;
80101a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a18:	66 8b 40 06          	mov    0x6(%eax),%ax
80101a1c:	8b 55 08             	mov    0x8(%ebp),%edx
80101a1f:	66 89 42 16          	mov    %ax,0x16(%edx)
    ip->size = dip->size;
80101a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a26:	8b 50 08             	mov    0x8(%eax),%edx
80101a29:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2c:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a32:	8d 50 0c             	lea    0xc(%eax),%edx
80101a35:	8b 45 08             	mov    0x8(%ebp),%eax
80101a38:	83 c0 1c             	add    $0x1c,%eax
80101a3b:	83 ec 04             	sub    $0x4,%esp
80101a3e:	6a 34                	push   $0x34
80101a40:	52                   	push   %edx
80101a41:	50                   	push   %eax
80101a42:	e8 93 38 00 00       	call   801052da <memmove>
80101a47:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101a4a:	83 ec 0c             	sub    $0xc,%esp
80101a4d:	ff 75 f4             	pushl  -0xc(%ebp)
80101a50:	e8 d7 e7 ff ff       	call   8010022c <brelse>
80101a55:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101a58:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5b:	8b 40 0c             	mov    0xc(%eax),%eax
80101a5e:	89 c2                	mov    %eax,%edx
80101a60:	83 ca 02             	or     $0x2,%edx
80101a63:	8b 45 08             	mov    0x8(%ebp),%eax
80101a66:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 40 10             	mov    0x10(%eax),%eax
80101a6f:	66 85 c0             	test   %ax,%ax
80101a72:	75 0d                	jne    80101a81 <ilock+0x15b>
      panic("ilock: no type");
80101a74:	83 ec 0c             	sub    $0xc,%esp
80101a77:	68 b3 85 10 80       	push   $0x801085b3
80101a7c:	e8 e1 ea ff ff       	call   80100562 <panic>
  }
}
80101a81:	c9                   	leave  
80101a82:	c3                   	ret    

80101a83 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a83:	55                   	push   %ebp
80101a84:	89 e5                	mov    %esp,%ebp
80101a86:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a8d:	74 17                	je     80101aa6 <iunlock+0x23>
80101a8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a92:	8b 40 0c             	mov    0xc(%eax),%eax
80101a95:	83 e0 01             	and    $0x1,%eax
80101a98:	85 c0                	test   %eax,%eax
80101a9a:	74 0a                	je     80101aa6 <iunlock+0x23>
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 40 08             	mov    0x8(%eax),%eax
80101aa2:	85 c0                	test   %eax,%eax
80101aa4:	7f 0d                	jg     80101ab3 <iunlock+0x30>
    panic("iunlock");
80101aa6:	83 ec 0c             	sub    $0xc,%esp
80101aa9:	68 c2 85 10 80       	push   $0x801085c2
80101aae:	e8 af ea ff ff       	call   80100562 <panic>

  acquire(&icache.lock);
80101ab3:	83 ec 0c             	sub    $0xc,%esp
80101ab6:	68 40 12 11 80       	push   $0x80111240
80101abb:	e8 03 35 00 00       	call   80104fc3 <acquire>
80101ac0:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac6:	8b 40 0c             	mov    0xc(%eax),%eax
80101ac9:	89 c2                	mov    %eax,%edx
80101acb:	83 e2 fe             	and    $0xfffffffe,%edx
80101ace:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad1:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101ad4:	83 ec 0c             	sub    $0xc,%esp
80101ad7:	ff 75 08             	pushl  0x8(%ebp)
80101ada:	e8 ca 32 00 00       	call   80104da9 <wakeup>
80101adf:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101ae2:	83 ec 0c             	sub    $0xc,%esp
80101ae5:	68 40 12 11 80       	push   $0x80111240
80101aea:	e8 3a 35 00 00       	call   80105029 <release>
80101aef:	83 c4 10             	add    $0x10,%esp
}
80101af2:	c9                   	leave  
80101af3:	c3                   	ret    

80101af4 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101af4:	55                   	push   %ebp
80101af5:	89 e5                	mov    %esp,%ebp
80101af7:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101afa:	83 ec 0c             	sub    $0xc,%esp
80101afd:	68 40 12 11 80       	push   $0x80111240
80101b02:	e8 bc 34 00 00       	call   80104fc3 <acquire>
80101b07:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101b0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0d:	8b 40 08             	mov    0x8(%eax),%eax
80101b10:	83 f8 01             	cmp    $0x1,%eax
80101b13:	0f 85 a9 00 00 00    	jne    80101bc2 <iput+0xce>
80101b19:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1c:	8b 40 0c             	mov    0xc(%eax),%eax
80101b1f:	83 e0 02             	and    $0x2,%eax
80101b22:	85 c0                	test   %eax,%eax
80101b24:	0f 84 98 00 00 00    	je     80101bc2 <iput+0xce>
80101b2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2d:	66 8b 40 16          	mov    0x16(%eax),%ax
80101b31:	66 85 c0             	test   %ax,%ax
80101b34:	0f 85 88 00 00 00    	jne    80101bc2 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101b3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3d:	8b 40 0c             	mov    0xc(%eax),%eax
80101b40:	83 e0 01             	and    $0x1,%eax
80101b43:	84 c0                	test   %al,%al
80101b45:	74 0d                	je     80101b54 <iput+0x60>
      panic("iput busy");
80101b47:	83 ec 0c             	sub    $0xc,%esp
80101b4a:	68 ca 85 10 80       	push   $0x801085ca
80101b4f:	e8 0e ea ff ff       	call   80100562 <panic>
    ip->flags |= I_BUSY;
80101b54:	8b 45 08             	mov    0x8(%ebp),%eax
80101b57:	8b 40 0c             	mov    0xc(%eax),%eax
80101b5a:	89 c2                	mov    %eax,%edx
80101b5c:	83 ca 01             	or     $0x1,%edx
80101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b62:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101b65:	83 ec 0c             	sub    $0xc,%esp
80101b68:	68 40 12 11 80       	push   $0x80111240
80101b6d:	e8 b7 34 00 00       	call   80105029 <release>
80101b72:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101b75:	83 ec 0c             	sub    $0xc,%esp
80101b78:	ff 75 08             	pushl  0x8(%ebp)
80101b7b:	e8 9b 01 00 00       	call   80101d1b <itrunc>
80101b80:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101b83:	8b 45 08             	mov    0x8(%ebp),%eax
80101b86:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b8c:	83 ec 0c             	sub    $0xc,%esp
80101b8f:	ff 75 08             	pushl  0x8(%ebp)
80101b92:	e8 b4 fb ff ff       	call   8010174b <iupdate>
80101b97:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101b9a:	83 ec 0c             	sub    $0xc,%esp
80101b9d:	68 40 12 11 80       	push   $0x80111240
80101ba2:	e8 1c 34 00 00       	call   80104fc3 <acquire>
80101ba7:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101baa:	8b 45 08             	mov    0x8(%ebp),%eax
80101bad:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101bb4:	83 ec 0c             	sub    $0xc,%esp
80101bb7:	ff 75 08             	pushl  0x8(%ebp)
80101bba:	e8 ea 31 00 00       	call   80104da9 <wakeup>
80101bbf:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101bc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc5:	8b 40 08             	mov    0x8(%eax),%eax
80101bc8:	8d 50 ff             	lea    -0x1(%eax),%edx
80101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
80101bce:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101bd1:	83 ec 0c             	sub    $0xc,%esp
80101bd4:	68 40 12 11 80       	push   $0x80111240
80101bd9:	e8 4b 34 00 00       	call   80105029 <release>
80101bde:	83 c4 10             	add    $0x10,%esp
}
80101be1:	c9                   	leave  
80101be2:	c3                   	ret    

80101be3 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101be3:	55                   	push   %ebp
80101be4:	89 e5                	mov    %esp,%ebp
80101be6:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101be9:	83 ec 0c             	sub    $0xc,%esp
80101bec:	ff 75 08             	pushl  0x8(%ebp)
80101bef:	e8 8f fe ff ff       	call   80101a83 <iunlock>
80101bf4:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101bf7:	83 ec 0c             	sub    $0xc,%esp
80101bfa:	ff 75 08             	pushl  0x8(%ebp)
80101bfd:	e8 f2 fe ff ff       	call   80101af4 <iput>
80101c02:	83 c4 10             	add    $0x10,%esp
}
80101c05:	c9                   	leave  
80101c06:	c3                   	ret    

80101c07 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c07:	55                   	push   %ebp
80101c08:	89 e5                	mov    %esp,%ebp
80101c0a:	53                   	push   %ebx
80101c0b:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c0e:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c12:	77 42                	ja     80101c56 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101c14:	8b 45 08             	mov    0x8(%ebp),%eax
80101c17:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c1a:	83 c2 04             	add    $0x4,%edx
80101c1d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c21:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c28:	75 24                	jne    80101c4e <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2d:	8b 00                	mov    (%eax),%eax
80101c2f:	83 ec 0c             	sub    $0xc,%esp
80101c32:	50                   	push   %eax
80101c33:	e8 a0 f7 ff ff       	call   801013d8 <balloc>
80101c38:	83 c4 10             	add    $0x10,%esp
80101c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c41:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c44:	8d 4a 04             	lea    0x4(%edx),%ecx
80101c47:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c4a:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c51:	e9 c0 00 00 00       	jmp    80101d16 <bmap+0x10f>
  }
  bn -= NDIRECT;
80101c56:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c5a:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c5e:	0f 87 a5 00 00 00    	ja     80101d09 <bmap+0x102>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c64:	8b 45 08             	mov    0x8(%ebp),%eax
80101c67:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c71:	75 1d                	jne    80101c90 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c73:	8b 45 08             	mov    0x8(%ebp),%eax
80101c76:	8b 00                	mov    (%eax),%eax
80101c78:	83 ec 0c             	sub    $0xc,%esp
80101c7b:	50                   	push   %eax
80101c7c:	e8 57 f7 ff ff       	call   801013d8 <balloc>
80101c81:	83 c4 10             	add    $0x10,%esp
80101c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c87:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c8d:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c90:	8b 45 08             	mov    0x8(%ebp),%eax
80101c93:	8b 00                	mov    (%eax),%eax
80101c95:	83 ec 08             	sub    $0x8,%esp
80101c98:	ff 75 f4             	pushl  -0xc(%ebp)
80101c9b:	50                   	push   %eax
80101c9c:	e8 14 e5 ff ff       	call   801001b5 <bread>
80101ca1:	83 c4 10             	add    $0x10,%esp
80101ca4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101caa:	83 c0 18             	add    $0x18,%eax
80101cad:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cb3:	c1 e0 02             	shl    $0x2,%eax
80101cb6:	03 45 ec             	add    -0x14(%ebp),%eax
80101cb9:	8b 00                	mov    (%eax),%eax
80101cbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cc2:	75 32                	jne    80101cf6 <bmap+0xef>
      a[bn] = addr = balloc(ip->dev);
80101cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cc7:	c1 e0 02             	shl    $0x2,%eax
80101cca:	89 c3                	mov    %eax,%ebx
80101ccc:	03 5d ec             	add    -0x14(%ebp),%ebx
80101ccf:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd2:	8b 00                	mov    (%eax),%eax
80101cd4:	83 ec 0c             	sub    $0xc,%esp
80101cd7:	50                   	push   %eax
80101cd8:	e8 fb f6 ff ff       	call   801013d8 <balloc>
80101cdd:	83 c4 10             	add    $0x10,%esp
80101ce0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ce6:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101ce8:	83 ec 0c             	sub    $0xc,%esp
80101ceb:	ff 75 f0             	pushl  -0x10(%ebp)
80101cee:	e8 08 1a 00 00       	call   801036fb <log_write>
80101cf3:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101cf6:	83 ec 0c             	sub    $0xc,%esp
80101cf9:	ff 75 f0             	pushl  -0x10(%ebp)
80101cfc:	e8 2b e5 ff ff       	call   8010022c <brelse>
80101d01:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d07:	eb 0d                	jmp    80101d16 <bmap+0x10f>
  }

  panic("bmap: out of range");
80101d09:	83 ec 0c             	sub    $0xc,%esp
80101d0c:	68 d4 85 10 80       	push   $0x801085d4
80101d11:	e8 4c e8 ff ff       	call   80100562 <panic>
}
80101d16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d19:	c9                   	leave  
80101d1a:	c3                   	ret    

80101d1b <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d1b:	55                   	push   %ebp
80101d1c:	89 e5                	mov    %esp,%ebp
80101d1e:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d28:	eb 44                	jmp    80101d6e <itrunc+0x53>
    if(ip->addrs[i]){
80101d2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d30:	83 c2 04             	add    $0x4,%edx
80101d33:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d37:	85 c0                	test   %eax,%eax
80101d39:	74 30                	je     80101d6b <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101d3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d41:	83 c2 04             	add    $0x4,%edx
80101d44:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101d48:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4b:	8b 00                	mov    (%eax),%eax
80101d4d:	83 ec 08             	sub    $0x8,%esp
80101d50:	52                   	push   %edx
80101d51:	50                   	push   %eax
80101d52:	e8 cd f7 ff ff       	call   80101524 <bfree>
80101d57:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101d5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d60:	83 c2 04             	add    $0x4,%edx
80101d63:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d6a:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d6b:	ff 45 f4             	incl   -0xc(%ebp)
80101d6e:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d72:	7e b6                	jle    80101d2a <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101d74:	8b 45 08             	mov    0x8(%ebp),%eax
80101d77:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d7a:	85 c0                	test   %eax,%eax
80101d7c:	0f 84 94 00 00 00    	je     80101e16 <itrunc+0xfb>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d82:	8b 45 08             	mov    0x8(%ebp),%eax
80101d85:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d88:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8b:	8b 00                	mov    (%eax),%eax
80101d8d:	83 ec 08             	sub    $0x8,%esp
80101d90:	52                   	push   %edx
80101d91:	50                   	push   %eax
80101d92:	e8 1e e4 ff ff       	call   801001b5 <bread>
80101d97:	83 c4 10             	add    $0x10,%esp
80101d9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101d9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101da0:	83 c0 18             	add    $0x18,%eax
80101da3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101da6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101dad:	eb 2f                	jmp    80101dde <itrunc+0xc3>
      if(a[j])
80101daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101db2:	c1 e0 02             	shl    $0x2,%eax
80101db5:	03 45 e8             	add    -0x18(%ebp),%eax
80101db8:	8b 00                	mov    (%eax),%eax
80101dba:	85 c0                	test   %eax,%eax
80101dbc:	74 1d                	je     80101ddb <itrunc+0xc0>
        bfree(ip->dev, a[j]);
80101dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dc1:	c1 e0 02             	shl    $0x2,%eax
80101dc4:	03 45 e8             	add    -0x18(%ebp),%eax
80101dc7:	8b 10                	mov    (%eax),%edx
80101dc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dcc:	8b 00                	mov    (%eax),%eax
80101dce:	83 ec 08             	sub    $0x8,%esp
80101dd1:	52                   	push   %edx
80101dd2:	50                   	push   %eax
80101dd3:	e8 4c f7 ff ff       	call   80101524 <bfree>
80101dd8:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101ddb:	ff 45 f0             	incl   -0x10(%ebp)
80101dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101de1:	83 f8 7f             	cmp    $0x7f,%eax
80101de4:	76 c9                	jbe    80101daf <itrunc+0x94>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101de6:	83 ec 0c             	sub    $0xc,%esp
80101de9:	ff 75 ec             	pushl  -0x14(%ebp)
80101dec:	e8 3b e4 ff ff       	call   8010022c <brelse>
80101df1:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101df4:	8b 45 08             	mov    0x8(%ebp),%eax
80101df7:	8b 50 4c             	mov    0x4c(%eax),%edx
80101dfa:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfd:	8b 00                	mov    (%eax),%eax
80101dff:	83 ec 08             	sub    $0x8,%esp
80101e02:	52                   	push   %edx
80101e03:	50                   	push   %eax
80101e04:	e8 1b f7 ff ff       	call   80101524 <bfree>
80101e09:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0f:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101e16:	8b 45 08             	mov    0x8(%ebp),%eax
80101e19:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101e20:	83 ec 0c             	sub    $0xc,%esp
80101e23:	ff 75 08             	pushl  0x8(%ebp)
80101e26:	e8 20 f9 ff ff       	call   8010174b <iupdate>
80101e2b:	83 c4 10             	add    $0x10,%esp
}
80101e2e:	c9                   	leave  
80101e2f:	c3                   	ret    

80101e30 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e33:	8b 45 08             	mov    0x8(%ebp),%eax
80101e36:	8b 00                	mov    (%eax),%eax
80101e38:	89 c2                	mov    %eax,%edx
80101e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e3d:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101e40:	8b 45 08             	mov    0x8(%ebp),%eax
80101e43:	8b 50 04             	mov    0x4(%eax),%edx
80101e46:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e49:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4f:	8b 40 10             	mov    0x10(%eax),%eax
80101e52:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e55:	66 89 02             	mov    %ax,(%edx)
  st->nlink = ip->nlink;
80101e58:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5b:	66 8b 40 16          	mov    0x16(%eax),%ax
80101e5f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e62:	66 89 42 0c          	mov    %ax,0xc(%edx)
  st->size = ip->size;
80101e66:	8b 45 08             	mov    0x8(%ebp),%eax
80101e69:	8b 50 18             	mov    0x18(%eax),%edx
80101e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e6f:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e72:	c9                   	leave  
80101e73:	c3                   	ret    

80101e74 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e74:	55                   	push   %ebp
80101e75:	89 e5                	mov    %esp,%ebp
80101e77:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7d:	8b 40 10             	mov    0x10(%eax),%eax
80101e80:	66 83 f8 03          	cmp    $0x3,%ax
80101e84:	75 5c                	jne    80101ee2 <readi+0x6e>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e86:	8b 45 08             	mov    0x8(%ebp),%eax
80101e89:	66 8b 40 12          	mov    0x12(%eax),%ax
80101e8d:	66 85 c0             	test   %ax,%ax
80101e90:	78 20                	js     80101eb2 <readi+0x3e>
80101e92:	8b 45 08             	mov    0x8(%ebp),%eax
80101e95:	66 8b 40 12          	mov    0x12(%eax),%ax
80101e99:	66 83 f8 09          	cmp    $0x9,%ax
80101e9d:	7f 13                	jg     80101eb2 <readi+0x3e>
80101e9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea2:	66 8b 40 12          	mov    0x12(%eax),%ax
80101ea6:	98                   	cwtl   
80101ea7:	8b 04 c5 c0 11 11 80 	mov    -0x7feeee40(,%eax,8),%eax
80101eae:	85 c0                	test   %eax,%eax
80101eb0:	75 0a                	jne    80101ebc <readi+0x48>
      return -1;
80101eb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb7:	e9 16 01 00 00       	jmp    80101fd2 <readi+0x15e>
    return devsw[ip->major].read(ip, dst, n);
80101ebc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebf:	66 8b 40 12          	mov    0x12(%eax),%ax
80101ec3:	98                   	cwtl   
80101ec4:	8b 14 c5 c0 11 11 80 	mov    -0x7feeee40(,%eax,8),%edx
80101ecb:	8b 45 14             	mov    0x14(%ebp),%eax
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	50                   	push   %eax
80101ed2:	ff 75 0c             	pushl  0xc(%ebp)
80101ed5:	ff 75 08             	pushl  0x8(%ebp)
80101ed8:	ff d2                	call   *%edx
80101eda:	83 c4 10             	add    $0x10,%esp
80101edd:	e9 f0 00 00 00       	jmp    80101fd2 <readi+0x15e>
  }

  if(off > ip->size || off + n < off)
80101ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee5:	8b 40 18             	mov    0x18(%eax),%eax
80101ee8:	3b 45 10             	cmp    0x10(%ebp),%eax
80101eeb:	72 0e                	jb     80101efb <readi+0x87>
80101eed:	8b 45 14             	mov    0x14(%ebp),%eax
80101ef0:	8b 55 10             	mov    0x10(%ebp),%edx
80101ef3:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101ef6:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ef9:	73 0a                	jae    80101f05 <readi+0x91>
    return -1;
80101efb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f00:	e9 cd 00 00 00       	jmp    80101fd2 <readi+0x15e>
  if(off + n > ip->size)
80101f05:	8b 45 14             	mov    0x14(%ebp),%eax
80101f08:	8b 55 10             	mov    0x10(%ebp),%edx
80101f0b:	01 c2                	add    %eax,%edx
80101f0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f10:	8b 40 18             	mov    0x18(%eax),%eax
80101f13:	39 c2                	cmp    %eax,%edx
80101f15:	76 0c                	jbe    80101f23 <readi+0xaf>
    n = ip->size - off;
80101f17:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1a:	8b 40 18             	mov    0x18(%eax),%eax
80101f1d:	2b 45 10             	sub    0x10(%ebp),%eax
80101f20:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f2a:	e9 94 00 00 00       	jmp    80101fc3 <readi+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f2f:	8b 45 10             	mov    0x10(%ebp),%eax
80101f32:	c1 e8 09             	shr    $0x9,%eax
80101f35:	83 ec 08             	sub    $0x8,%esp
80101f38:	50                   	push   %eax
80101f39:	ff 75 08             	pushl  0x8(%ebp)
80101f3c:	e8 c6 fc ff ff       	call   80101c07 <bmap>
80101f41:	83 c4 10             	add    $0x10,%esp
80101f44:	8b 55 08             	mov    0x8(%ebp),%edx
80101f47:	8b 12                	mov    (%edx),%edx
80101f49:	83 ec 08             	sub    $0x8,%esp
80101f4c:	50                   	push   %eax
80101f4d:	52                   	push   %edx
80101f4e:	e8 62 e2 ff ff       	call   801001b5 <bread>
80101f53:	83 c4 10             	add    $0x10,%esp
80101f56:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f59:	8b 45 10             	mov    0x10(%ebp),%eax
80101f5c:	89 c2                	mov    %eax,%edx
80101f5e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101f64:	b8 00 02 00 00       	mov    $0x200,%eax
80101f69:	89 c1                	mov    %eax,%ecx
80101f6b:	29 d1                	sub    %edx,%ecx
80101f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f70:	8b 55 14             	mov    0x14(%ebp),%edx
80101f73:	29 c2                	sub    %eax,%edx
80101f75:	89 c8                	mov    %ecx,%eax
80101f77:	39 d0                	cmp    %edx,%eax
80101f79:	76 02                	jbe    80101f7d <readi+0x109>
80101f7b:	89 d0                	mov    %edx,%eax
80101f7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f83:	8d 50 18             	lea    0x18(%eax),%edx
80101f86:	8b 45 10             	mov    0x10(%ebp),%eax
80101f89:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f8e:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101f91:	83 ec 04             	sub    $0x4,%esp
80101f94:	ff 75 ec             	pushl  -0x14(%ebp)
80101f97:	50                   	push   %eax
80101f98:	ff 75 0c             	pushl  0xc(%ebp)
80101f9b:	e8 3a 33 00 00       	call   801052da <memmove>
80101fa0:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	ff 75 f0             	pushl  -0x10(%ebp)
80101fa9:	e8 7e e2 ff ff       	call   8010022c <brelse>
80101fae:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fb4:	01 45 f4             	add    %eax,-0xc(%ebp)
80101fb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fba:	01 45 10             	add    %eax,0x10(%ebp)
80101fbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fc0:	01 45 0c             	add    %eax,0xc(%ebp)
80101fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fc6:	3b 45 14             	cmp    0x14(%ebp),%eax
80101fc9:	0f 82 60 ff ff ff    	jb     80101f2f <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101fcf:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101fd2:	c9                   	leave  
80101fd3:	c3                   	ret    

80101fd4 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101fd4:	55                   	push   %ebp
80101fd5:	89 e5                	mov    %esp,%ebp
80101fd7:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fda:	8b 45 08             	mov    0x8(%ebp),%eax
80101fdd:	8b 40 10             	mov    0x10(%eax),%eax
80101fe0:	66 83 f8 03          	cmp    $0x3,%ax
80101fe4:	75 5c                	jne    80102042 <writei+0x6e>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101fe6:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe9:	66 8b 40 12          	mov    0x12(%eax),%ax
80101fed:	66 85 c0             	test   %ax,%ax
80101ff0:	78 20                	js     80102012 <writei+0x3e>
80101ff2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff5:	66 8b 40 12          	mov    0x12(%eax),%ax
80101ff9:	66 83 f8 09          	cmp    $0x9,%ax
80101ffd:	7f 13                	jg     80102012 <writei+0x3e>
80101fff:	8b 45 08             	mov    0x8(%ebp),%eax
80102002:	66 8b 40 12          	mov    0x12(%eax),%ax
80102006:	98                   	cwtl   
80102007:	8b 04 c5 c4 11 11 80 	mov    -0x7feeee3c(,%eax,8),%eax
8010200e:	85 c0                	test   %eax,%eax
80102010:	75 0a                	jne    8010201c <writei+0x48>
      return -1;
80102012:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102017:	e9 48 01 00 00       	jmp    80102164 <writei+0x190>
    return devsw[ip->major].write(ip, src, n);
8010201c:	8b 45 08             	mov    0x8(%ebp),%eax
8010201f:	66 8b 40 12          	mov    0x12(%eax),%ax
80102023:	98                   	cwtl   
80102024:	8b 14 c5 c4 11 11 80 	mov    -0x7feeee3c(,%eax,8),%edx
8010202b:	8b 45 14             	mov    0x14(%ebp),%eax
8010202e:	83 ec 04             	sub    $0x4,%esp
80102031:	50                   	push   %eax
80102032:	ff 75 0c             	pushl  0xc(%ebp)
80102035:	ff 75 08             	pushl  0x8(%ebp)
80102038:	ff d2                	call   *%edx
8010203a:	83 c4 10             	add    $0x10,%esp
8010203d:	e9 22 01 00 00       	jmp    80102164 <writei+0x190>
  }

  if(off > ip->size || off + n < off)
80102042:	8b 45 08             	mov    0x8(%ebp),%eax
80102045:	8b 40 18             	mov    0x18(%eax),%eax
80102048:	3b 45 10             	cmp    0x10(%ebp),%eax
8010204b:	72 0e                	jb     8010205b <writei+0x87>
8010204d:	8b 45 14             	mov    0x14(%ebp),%eax
80102050:	8b 55 10             	mov    0x10(%ebp),%edx
80102053:	8d 04 02             	lea    (%edx,%eax,1),%eax
80102056:	3b 45 10             	cmp    0x10(%ebp),%eax
80102059:	73 0a                	jae    80102065 <writei+0x91>
    return -1;
8010205b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102060:	e9 ff 00 00 00       	jmp    80102164 <writei+0x190>
  if(off + n > MAXFILE*BSIZE)
80102065:	8b 45 14             	mov    0x14(%ebp),%eax
80102068:	8b 55 10             	mov    0x10(%ebp),%edx
8010206b:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010206e:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102073:	76 0a                	jbe    8010207f <writei+0xab>
    return -1;
80102075:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010207a:	e9 e5 00 00 00       	jmp    80102164 <writei+0x190>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010207f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102086:	e9 a2 00 00 00       	jmp    8010212d <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010208b:	8b 45 10             	mov    0x10(%ebp),%eax
8010208e:	c1 e8 09             	shr    $0x9,%eax
80102091:	83 ec 08             	sub    $0x8,%esp
80102094:	50                   	push   %eax
80102095:	ff 75 08             	pushl  0x8(%ebp)
80102098:	e8 6a fb ff ff       	call   80101c07 <bmap>
8010209d:	83 c4 10             	add    $0x10,%esp
801020a0:	8b 55 08             	mov    0x8(%ebp),%edx
801020a3:	8b 12                	mov    (%edx),%edx
801020a5:	83 ec 08             	sub    $0x8,%esp
801020a8:	50                   	push   %eax
801020a9:	52                   	push   %edx
801020aa:	e8 06 e1 ff ff       	call   801001b5 <bread>
801020af:	83 c4 10             	add    $0x10,%esp
801020b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020b5:	8b 45 10             	mov    0x10(%ebp),%eax
801020b8:	89 c2                	mov    %eax,%edx
801020ba:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801020c0:	b8 00 02 00 00       	mov    $0x200,%eax
801020c5:	89 c1                	mov    %eax,%ecx
801020c7:	29 d1                	sub    %edx,%ecx
801020c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020cc:	8b 55 14             	mov    0x14(%ebp),%edx
801020cf:	29 c2                	sub    %eax,%edx
801020d1:	89 c8                	mov    %ecx,%eax
801020d3:	39 d0                	cmp    %edx,%eax
801020d5:	76 02                	jbe    801020d9 <writei+0x105>
801020d7:	89 d0                	mov    %edx,%eax
801020d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801020dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020df:	8d 50 18             	lea    0x18(%eax),%edx
801020e2:	8b 45 10             	mov    0x10(%ebp),%eax
801020e5:	25 ff 01 00 00       	and    $0x1ff,%eax
801020ea:	8d 04 02             	lea    (%edx,%eax,1),%eax
801020ed:	83 ec 04             	sub    $0x4,%esp
801020f0:	ff 75 ec             	pushl  -0x14(%ebp)
801020f3:	ff 75 0c             	pushl  0xc(%ebp)
801020f6:	50                   	push   %eax
801020f7:	e8 de 31 00 00       	call   801052da <memmove>
801020fc:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801020ff:	83 ec 0c             	sub    $0xc,%esp
80102102:	ff 75 f0             	pushl  -0x10(%ebp)
80102105:	e8 f1 15 00 00       	call   801036fb <log_write>
8010210a:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010210d:	83 ec 0c             	sub    $0xc,%esp
80102110:	ff 75 f0             	pushl  -0x10(%ebp)
80102113:	e8 14 e1 ff ff       	call   8010022c <brelse>
80102118:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010211b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010211e:	01 45 f4             	add    %eax,-0xc(%ebp)
80102121:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102124:	01 45 10             	add    %eax,0x10(%ebp)
80102127:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010212a:	01 45 0c             	add    %eax,0xc(%ebp)
8010212d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102130:	3b 45 14             	cmp    0x14(%ebp),%eax
80102133:	0f 82 52 ff ff ff    	jb     8010208b <writei+0xb7>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102139:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010213d:	74 22                	je     80102161 <writei+0x18d>
8010213f:	8b 45 08             	mov    0x8(%ebp),%eax
80102142:	8b 40 18             	mov    0x18(%eax),%eax
80102145:	3b 45 10             	cmp    0x10(%ebp),%eax
80102148:	73 17                	jae    80102161 <writei+0x18d>
    ip->size = off;
8010214a:	8b 45 08             	mov    0x8(%ebp),%eax
8010214d:	8b 55 10             	mov    0x10(%ebp),%edx
80102150:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102153:	83 ec 0c             	sub    $0xc,%esp
80102156:	ff 75 08             	pushl  0x8(%ebp)
80102159:	e8 ed f5 ff ff       	call   8010174b <iupdate>
8010215e:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102161:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102164:	c9                   	leave  
80102165:	c3                   	ret    

80102166 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102166:	55                   	push   %ebp
80102167:	89 e5                	mov    %esp,%ebp
80102169:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
8010216c:	83 ec 04             	sub    $0x4,%esp
8010216f:	6a 0e                	push   $0xe
80102171:	ff 75 0c             	pushl  0xc(%ebp)
80102174:	ff 75 08             	pushl  0x8(%ebp)
80102177:	e8 f3 31 00 00       	call   8010536f <strncmp>
8010217c:	83 c4 10             	add    $0x10,%esp
}
8010217f:	c9                   	leave  
80102180:	c3                   	ret    

80102181 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102181:	55                   	push   %ebp
80102182:	89 e5                	mov    %esp,%ebp
80102184:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102187:	8b 45 08             	mov    0x8(%ebp),%eax
8010218a:	8b 40 10             	mov    0x10(%eax),%eax
8010218d:	66 83 f8 01          	cmp    $0x1,%ax
80102191:	74 0d                	je     801021a0 <dirlookup+0x1f>
    panic("dirlookup not DIR");
80102193:	83 ec 0c             	sub    $0xc,%esp
80102196:	68 e7 85 10 80       	push   $0x801085e7
8010219b:	e8 c2 e3 ff ff       	call   80100562 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801021a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021a7:	eb 79                	jmp    80102222 <dirlookup+0xa1>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021a9:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021ac:	6a 10                	push   $0x10
801021ae:	ff 75 f4             	pushl  -0xc(%ebp)
801021b1:	50                   	push   %eax
801021b2:	ff 75 08             	pushl  0x8(%ebp)
801021b5:	e8 ba fc ff ff       	call   80101e74 <readi>
801021ba:	83 c4 10             	add    $0x10,%esp
801021bd:	83 f8 10             	cmp    $0x10,%eax
801021c0:	74 0d                	je     801021cf <dirlookup+0x4e>
      panic("dirlink read");
801021c2:	83 ec 0c             	sub    $0xc,%esp
801021c5:	68 f9 85 10 80       	push   $0x801085f9
801021ca:	e8 93 e3 ff ff       	call   80100562 <panic>
    if(de.inum == 0)
801021cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801021d2:	66 85 c0             	test   %ax,%ax
801021d5:	74 46                	je     8010221d <dirlookup+0x9c>
      continue;
    if(namecmp(name, de.name) == 0){
801021d7:	83 ec 08             	sub    $0x8,%esp
801021da:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021dd:	83 c0 02             	add    $0x2,%eax
801021e0:	50                   	push   %eax
801021e1:	ff 75 0c             	pushl  0xc(%ebp)
801021e4:	e8 7d ff ff ff       	call   80102166 <namecmp>
801021e9:	83 c4 10             	add    $0x10,%esp
801021ec:	85 c0                	test   %eax,%eax
801021ee:	75 2e                	jne    8010221e <dirlookup+0x9d>
      // entry matches path element
      if(poff)
801021f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801021f4:	74 08                	je     801021fe <dirlookup+0x7d>
        *poff = off;
801021f6:	8b 45 10             	mov    0x10(%ebp),%eax
801021f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021fc:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801021fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102201:	0f b7 c0             	movzwl %ax,%eax
80102204:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102207:	8b 45 08             	mov    0x8(%ebp),%eax
8010220a:	8b 00                	mov    (%eax),%eax
8010220c:	83 ec 08             	sub    $0x8,%esp
8010220f:	ff 75 f0             	pushl  -0x10(%ebp)
80102212:	50                   	push   %eax
80102213:	e8 f4 f5 ff ff       	call   8010180c <iget>
80102218:	83 c4 10             	add    $0x10,%esp
8010221b:	eb 19                	jmp    80102236 <dirlookup+0xb5>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
8010221d:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010221e:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102222:	8b 45 08             	mov    0x8(%ebp),%eax
80102225:	8b 40 18             	mov    0x18(%eax),%eax
80102228:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010222b:	0f 87 78 ff ff ff    	ja     801021a9 <dirlookup+0x28>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102231:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102236:	c9                   	leave  
80102237:	c3                   	ret    

80102238 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102238:	55                   	push   %ebp
80102239:	89 e5                	mov    %esp,%ebp
8010223b:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010223e:	83 ec 04             	sub    $0x4,%esp
80102241:	6a 00                	push   $0x0
80102243:	ff 75 0c             	pushl  0xc(%ebp)
80102246:	ff 75 08             	pushl  0x8(%ebp)
80102249:	e8 33 ff ff ff       	call   80102181 <dirlookup>
8010224e:	83 c4 10             	add    $0x10,%esp
80102251:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102254:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102258:	74 18                	je     80102272 <dirlink+0x3a>
    iput(ip);
8010225a:	83 ec 0c             	sub    $0xc,%esp
8010225d:	ff 75 f0             	pushl  -0x10(%ebp)
80102260:	e8 8f f8 ff ff       	call   80101af4 <iput>
80102265:	83 c4 10             	add    $0x10,%esp
    return -1;
80102268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010226d:	e9 9b 00 00 00       	jmp    8010230d <dirlink+0xd5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102272:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102279:	eb 38                	jmp    801022b3 <dirlink+0x7b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010227b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010227e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102281:	6a 10                	push   $0x10
80102283:	52                   	push   %edx
80102284:	50                   	push   %eax
80102285:	ff 75 08             	pushl  0x8(%ebp)
80102288:	e8 e7 fb ff ff       	call   80101e74 <readi>
8010228d:	83 c4 10             	add    $0x10,%esp
80102290:	83 f8 10             	cmp    $0x10,%eax
80102293:	74 0d                	je     801022a2 <dirlink+0x6a>
      panic("dirlink read");
80102295:	83 ec 0c             	sub    $0xc,%esp
80102298:	68 f9 85 10 80       	push   $0x801085f9
8010229d:	e8 c0 e2 ff ff       	call   80100562 <panic>
    if(de.inum == 0)
801022a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801022a5:	66 85 c0             	test   %ax,%ax
801022a8:	74 18                	je     801022c2 <dirlink+0x8a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022ad:	83 c0 10             	add    $0x10,%eax
801022b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801022b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801022b6:	8b 45 08             	mov    0x8(%ebp),%eax
801022b9:	8b 40 18             	mov    0x18(%eax),%eax
801022bc:	39 c2                	cmp    %eax,%edx
801022be:	72 bb                	jb     8010227b <dirlink+0x43>
801022c0:	eb 01                	jmp    801022c3 <dirlink+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801022c2:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801022c3:	83 ec 04             	sub    $0x4,%esp
801022c6:	6a 0e                	push   $0xe
801022c8:	ff 75 0c             	pushl  0xc(%ebp)
801022cb:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022ce:	83 c0 02             	add    $0x2,%eax
801022d1:	50                   	push   %eax
801022d2:	e8 e8 30 00 00       	call   801053bf <strncpy>
801022d7:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801022da:	8b 45 10             	mov    0x10(%ebp),%eax
801022dd:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801022e4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022e7:	6a 10                	push   $0x10
801022e9:	52                   	push   %edx
801022ea:	50                   	push   %eax
801022eb:	ff 75 08             	pushl  0x8(%ebp)
801022ee:	e8 e1 fc ff ff       	call   80101fd4 <writei>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	83 f8 10             	cmp    $0x10,%eax
801022f9:	74 0d                	je     80102308 <dirlink+0xd0>
    panic("dirlink");
801022fb:	83 ec 0c             	sub    $0xc,%esp
801022fe:	68 06 86 10 80       	push   $0x80108606
80102303:	e8 5a e2 ff ff       	call   80100562 <panic>
  
  return 0;
80102308:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010230d:	c9                   	leave  
8010230e:	c3                   	ret    

8010230f <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010230f:	55                   	push   %ebp
80102310:	89 e5                	mov    %esp,%ebp
80102312:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102315:	eb 03                	jmp    8010231a <skipelem+0xb>
    path++;
80102317:	ff 45 08             	incl   0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010231a:	8b 45 08             	mov    0x8(%ebp),%eax
8010231d:	8a 00                	mov    (%eax),%al
8010231f:	3c 2f                	cmp    $0x2f,%al
80102321:	74 f4                	je     80102317 <skipelem+0x8>
    path++;
  if(*path == 0)
80102323:	8b 45 08             	mov    0x8(%ebp),%eax
80102326:	8a 00                	mov    (%eax),%al
80102328:	84 c0                	test   %al,%al
8010232a:	75 07                	jne    80102333 <skipelem+0x24>
    return 0;
8010232c:	b8 00 00 00 00       	mov    $0x0,%eax
80102331:	eb 76                	jmp    801023a9 <skipelem+0x9a>
  s = path;
80102333:	8b 45 08             	mov    0x8(%ebp),%eax
80102336:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102339:	eb 03                	jmp    8010233e <skipelem+0x2f>
    path++;
8010233b:	ff 45 08             	incl   0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010233e:	8b 45 08             	mov    0x8(%ebp),%eax
80102341:	8a 00                	mov    (%eax),%al
80102343:	3c 2f                	cmp    $0x2f,%al
80102345:	74 09                	je     80102350 <skipelem+0x41>
80102347:	8b 45 08             	mov    0x8(%ebp),%eax
8010234a:	8a 00                	mov    (%eax),%al
8010234c:	84 c0                	test   %al,%al
8010234e:	75 eb                	jne    8010233b <skipelem+0x2c>
    path++;
  len = path - s;
80102350:	8b 55 08             	mov    0x8(%ebp),%edx
80102353:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102356:	89 d1                	mov    %edx,%ecx
80102358:	29 c1                	sub    %eax,%ecx
8010235a:	89 c8                	mov    %ecx,%eax
8010235c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010235f:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102363:	7e 15                	jle    8010237a <skipelem+0x6b>
    memmove(name, s, DIRSIZ);
80102365:	83 ec 04             	sub    $0x4,%esp
80102368:	6a 0e                	push   $0xe
8010236a:	ff 75 f4             	pushl  -0xc(%ebp)
8010236d:	ff 75 0c             	pushl  0xc(%ebp)
80102370:	e8 65 2f 00 00       	call   801052da <memmove>
80102375:	83 c4 10             	add    $0x10,%esp
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102378:	eb 23                	jmp    8010239d <skipelem+0x8e>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
8010237a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010237d:	83 ec 04             	sub    $0x4,%esp
80102380:	50                   	push   %eax
80102381:	ff 75 f4             	pushl  -0xc(%ebp)
80102384:	ff 75 0c             	pushl  0xc(%ebp)
80102387:	e8 4e 2f 00 00       	call   801052da <memmove>
8010238c:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
8010238f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102392:	03 45 0c             	add    0xc(%ebp),%eax
80102395:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102398:	eb 03                	jmp    8010239d <skipelem+0x8e>
    path++;
8010239a:	ff 45 08             	incl   0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010239d:	8b 45 08             	mov    0x8(%ebp),%eax
801023a0:	8a 00                	mov    (%eax),%al
801023a2:	3c 2f                	cmp    $0x2f,%al
801023a4:	74 f4                	je     8010239a <skipelem+0x8b>
    path++;
  return path;
801023a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
801023a9:	c9                   	leave  
801023aa:	c3                   	ret    

801023ab <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801023ab:	55                   	push   %ebp
801023ac:	89 e5                	mov    %esp,%ebp
801023ae:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801023b1:	8b 45 08             	mov    0x8(%ebp),%eax
801023b4:	8a 00                	mov    (%eax),%al
801023b6:	3c 2f                	cmp    $0x2f,%al
801023b8:	75 17                	jne    801023d1 <namex+0x26>
    ip = iget(ROOTDEV, ROOTINO);
801023ba:	83 ec 08             	sub    $0x8,%esp
801023bd:	6a 01                	push   $0x1
801023bf:	6a 01                	push   $0x1
801023c1:	e8 46 f4 ff ff       	call   8010180c <iget>
801023c6:	83 c4 10             	add    $0x10,%esp
801023c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023cc:	e9 b9 00 00 00       	jmp    8010248a <namex+0xdf>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
801023d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801023d7:	8b 40 68             	mov    0x68(%eax),%eax
801023da:	83 ec 0c             	sub    $0xc,%esp
801023dd:	50                   	push   %eax
801023de:	e8 09 f5 ff ff       	call   801018ec <idup>
801023e3:	83 c4 10             	add    $0x10,%esp
801023e6:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801023e9:	e9 9c 00 00 00       	jmp    8010248a <namex+0xdf>
    ilock(ip);
801023ee:	83 ec 0c             	sub    $0xc,%esp
801023f1:	ff 75 f4             	pushl  -0xc(%ebp)
801023f4:	e8 2d f5 ff ff       	call   80101926 <ilock>
801023f9:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ff:	8b 40 10             	mov    0x10(%eax),%eax
80102402:	66 83 f8 01          	cmp    $0x1,%ax
80102406:	74 18                	je     80102420 <namex+0x75>
      iunlockput(ip);
80102408:	83 ec 0c             	sub    $0xc,%esp
8010240b:	ff 75 f4             	pushl  -0xc(%ebp)
8010240e:	e8 d0 f7 ff ff       	call   80101be3 <iunlockput>
80102413:	83 c4 10             	add    $0x10,%esp
      return 0;
80102416:	b8 00 00 00 00       	mov    $0x0,%eax
8010241b:	e9 a6 00 00 00       	jmp    801024c6 <namex+0x11b>
    }
    if(nameiparent && *path == '\0'){
80102420:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102424:	74 1f                	je     80102445 <namex+0x9a>
80102426:	8b 45 08             	mov    0x8(%ebp),%eax
80102429:	8a 00                	mov    (%eax),%al
8010242b:	84 c0                	test   %al,%al
8010242d:	75 16                	jne    80102445 <namex+0x9a>
      // Stop one level early.
      iunlock(ip);
8010242f:	83 ec 0c             	sub    $0xc,%esp
80102432:	ff 75 f4             	pushl  -0xc(%ebp)
80102435:	e8 49 f6 ff ff       	call   80101a83 <iunlock>
8010243a:	83 c4 10             	add    $0x10,%esp
      return ip;
8010243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102440:	e9 81 00 00 00       	jmp    801024c6 <namex+0x11b>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102445:	83 ec 04             	sub    $0x4,%esp
80102448:	6a 00                	push   $0x0
8010244a:	ff 75 10             	pushl  0x10(%ebp)
8010244d:	ff 75 f4             	pushl  -0xc(%ebp)
80102450:	e8 2c fd ff ff       	call   80102181 <dirlookup>
80102455:	83 c4 10             	add    $0x10,%esp
80102458:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010245b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010245f:	75 15                	jne    80102476 <namex+0xcb>
      iunlockput(ip);
80102461:	83 ec 0c             	sub    $0xc,%esp
80102464:	ff 75 f4             	pushl  -0xc(%ebp)
80102467:	e8 77 f7 ff ff       	call   80101be3 <iunlockput>
8010246c:	83 c4 10             	add    $0x10,%esp
      return 0;
8010246f:	b8 00 00 00 00       	mov    $0x0,%eax
80102474:	eb 50                	jmp    801024c6 <namex+0x11b>
    }
    iunlockput(ip);
80102476:	83 ec 0c             	sub    $0xc,%esp
80102479:	ff 75 f4             	pushl  -0xc(%ebp)
8010247c:	e8 62 f7 ff ff       	call   80101be3 <iunlockput>
80102481:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102484:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102487:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010248a:	83 ec 08             	sub    $0x8,%esp
8010248d:	ff 75 10             	pushl  0x10(%ebp)
80102490:	ff 75 08             	pushl  0x8(%ebp)
80102493:	e8 77 fe ff ff       	call   8010230f <skipelem>
80102498:	83 c4 10             	add    $0x10,%esp
8010249b:	89 45 08             	mov    %eax,0x8(%ebp)
8010249e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024a2:	0f 85 46 ff ff ff    	jne    801023ee <namex+0x43>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801024a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024ac:	74 15                	je     801024c3 <namex+0x118>
    iput(ip);
801024ae:	83 ec 0c             	sub    $0xc,%esp
801024b1:	ff 75 f4             	pushl  -0xc(%ebp)
801024b4:	e8 3b f6 ff ff       	call   80101af4 <iput>
801024b9:	83 c4 10             	add    $0x10,%esp
    return 0;
801024bc:	b8 00 00 00 00       	mov    $0x0,%eax
801024c1:	eb 03                	jmp    801024c6 <namex+0x11b>
  }
  return ip;
801024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801024c6:	c9                   	leave  
801024c7:	c3                   	ret    

801024c8 <namei>:

struct inode*
namei(char *path)
{
801024c8:	55                   	push   %ebp
801024c9:	89 e5                	mov    %esp,%ebp
801024cb:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801024ce:	83 ec 04             	sub    $0x4,%esp
801024d1:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024d4:	50                   	push   %eax
801024d5:	6a 00                	push   $0x0
801024d7:	ff 75 08             	pushl  0x8(%ebp)
801024da:	e8 cc fe ff ff       	call   801023ab <namex>
801024df:	83 c4 10             	add    $0x10,%esp
}
801024e2:	c9                   	leave  
801024e3:	c3                   	ret    

801024e4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024e4:	55                   	push   %ebp
801024e5:	89 e5                	mov    %esp,%ebp
801024e7:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801024ea:	83 ec 04             	sub    $0x4,%esp
801024ed:	ff 75 0c             	pushl  0xc(%ebp)
801024f0:	6a 01                	push   $0x1
801024f2:	ff 75 08             	pushl  0x8(%ebp)
801024f5:	e8 b1 fe ff ff       	call   801023ab <namex>
801024fa:	83 c4 10             	add    $0x10,%esp
}
801024fd:	c9                   	leave  
801024fe:	c3                   	ret    
	...

80102500 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
80102503:	53                   	push   %ebx
80102504:	83 ec 18             	sub    $0x18,%esp
80102507:	8b 45 08             	mov    0x8(%ebp),%eax
8010250a:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010250e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102511:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
80102515:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
80102519:	ec                   	in     (%dx),%al
8010251a:	88 c3                	mov    %al,%bl
8010251c:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
8010251f:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80102522:	83 c4 18             	add    $0x18,%esp
80102525:	5b                   	pop    %ebx
80102526:	c9                   	leave  
80102527:	c3                   	ret    

80102528 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102528:	55                   	push   %ebp
80102529:	89 e5                	mov    %esp,%ebp
8010252b:	57                   	push   %edi
8010252c:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010252d:	8b 55 08             	mov    0x8(%ebp),%edx
80102530:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102533:	8b 45 10             	mov    0x10(%ebp),%eax
80102536:	89 cb                	mov    %ecx,%ebx
80102538:	89 df                	mov    %ebx,%edi
8010253a:	89 c1                	mov    %eax,%ecx
8010253c:	fc                   	cld    
8010253d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010253f:	89 c8                	mov    %ecx,%eax
80102541:	89 fb                	mov    %edi,%ebx
80102543:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102546:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102549:	5b                   	pop    %ebx
8010254a:	5f                   	pop    %edi
8010254b:	c9                   	leave  
8010254c:	c3                   	ret    

8010254d <outb>:

static inline void
outb(ushort port, uchar data)
{
8010254d:	55                   	push   %ebp
8010254e:	89 e5                	mov    %esp,%ebp
80102550:	83 ec 08             	sub    $0x8,%esp
80102553:	8b 45 08             	mov    0x8(%ebp),%eax
80102556:	8b 55 0c             	mov    0xc(%ebp),%edx
80102559:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010255d:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102560:	8a 45 f8             	mov    -0x8(%ebp),%al
80102563:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102566:	ee                   	out    %al,(%dx)
}
80102567:	c9                   	leave  
80102568:	c3                   	ret    

80102569 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102569:	55                   	push   %ebp
8010256a:	89 e5                	mov    %esp,%ebp
8010256c:	56                   	push   %esi
8010256d:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
8010256e:	8b 55 08             	mov    0x8(%ebp),%edx
80102571:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102574:	8b 45 10             	mov    0x10(%ebp),%eax
80102577:	89 cb                	mov    %ecx,%ebx
80102579:	89 de                	mov    %ebx,%esi
8010257b:	89 c1                	mov    %eax,%ecx
8010257d:	fc                   	cld    
8010257e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102580:	89 c8                	mov    %ecx,%eax
80102582:	89 f3                	mov    %esi,%ebx
80102584:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102587:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010258a:	5b                   	pop    %ebx
8010258b:	5e                   	pop    %esi
8010258c:	c9                   	leave  
8010258d:	c3                   	ret    

8010258e <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010258e:	55                   	push   %ebp
8010258f:	89 e5                	mov    %esp,%ebp
80102591:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102594:	90                   	nop
80102595:	68 f7 01 00 00       	push   $0x1f7
8010259a:	e8 61 ff ff ff       	call   80102500 <inb>
8010259f:	83 c4 04             	add    $0x4,%esp
801025a2:	0f b6 c0             	movzbl %al,%eax
801025a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
801025a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025ab:	25 c0 00 00 00       	and    $0xc0,%eax
801025b0:	83 f8 40             	cmp    $0x40,%eax
801025b3:	75 e0                	jne    80102595 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801025b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025b9:	74 11                	je     801025cc <idewait+0x3e>
801025bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025be:	83 e0 21             	and    $0x21,%eax
801025c1:	85 c0                	test   %eax,%eax
801025c3:	74 07                	je     801025cc <idewait+0x3e>
    return -1;
801025c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025ca:	eb 05                	jmp    801025d1 <idewait+0x43>
  return 0;
801025cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801025d1:	c9                   	leave  
801025d2:	c3                   	ret    

801025d3 <ideinit>:

void
ideinit(void)
{
801025d3:	55                   	push   %ebp
801025d4:	89 e5                	mov    %esp,%ebp
801025d6:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
801025d9:	83 ec 08             	sub    $0x8,%esp
801025dc:	68 0e 86 10 80       	push   $0x8010860e
801025e1:	68 00 b6 10 80       	push   $0x8010b600
801025e6:	e8 b7 29 00 00       	call   80104fa2 <initlock>
801025eb:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801025ee:	83 ec 0c             	sub    $0xc,%esp
801025f1:	6a 0e                	push   $0xe
801025f3:	e8 f9 18 00 00       	call   80103ef1 <picenable>
801025f8:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801025fb:	a1 40 29 11 80       	mov    0x80112940,%eax
80102600:	48                   	dec    %eax
80102601:	83 ec 08             	sub    $0x8,%esp
80102604:	50                   	push   %eax
80102605:	6a 0e                	push   $0xe
80102607:	e8 6c 04 00 00       	call   80102a78 <ioapicenable>
8010260c:	83 c4 10             	add    $0x10,%esp
  idewait(0);
8010260f:	83 ec 0c             	sub    $0xc,%esp
80102612:	6a 00                	push   $0x0
80102614:	e8 75 ff ff ff       	call   8010258e <idewait>
80102619:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010261c:	83 ec 08             	sub    $0x8,%esp
8010261f:	68 f0 00 00 00       	push   $0xf0
80102624:	68 f6 01 00 00       	push   $0x1f6
80102629:	e8 1f ff ff ff       	call   8010254d <outb>
8010262e:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102631:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102638:	eb 23                	jmp    8010265d <ideinit+0x8a>
    if(inb(0x1f7) != 0){
8010263a:	83 ec 0c             	sub    $0xc,%esp
8010263d:	68 f7 01 00 00       	push   $0x1f7
80102642:	e8 b9 fe ff ff       	call   80102500 <inb>
80102647:	83 c4 10             	add    $0x10,%esp
8010264a:	84 c0                	test   %al,%al
8010264c:	74 0c                	je     8010265a <ideinit+0x87>
      havedisk1 = 1;
8010264e:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
80102655:	00 00 00 
      break;
80102658:	eb 0c                	jmp    80102666 <ideinit+0x93>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010265a:	ff 45 f4             	incl   -0xc(%ebp)
8010265d:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102664:	7e d4                	jle    8010263a <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102666:	83 ec 08             	sub    $0x8,%esp
80102669:	68 e0 00 00 00       	push   $0xe0
8010266e:	68 f6 01 00 00       	push   $0x1f6
80102673:	e8 d5 fe ff ff       	call   8010254d <outb>
80102678:	83 c4 10             	add    $0x10,%esp
}
8010267b:	c9                   	leave  
8010267c:	c3                   	ret    

8010267d <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010267d:	55                   	push   %ebp
8010267e:	89 e5                	mov    %esp,%ebp
80102680:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102683:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102687:	75 0d                	jne    80102696 <idestart+0x19>
    panic("idestart");
80102689:	83 ec 0c             	sub    $0xc,%esp
8010268c:	68 12 86 10 80       	push   $0x80108612
80102691:	e8 cc de ff ff       	call   80100562 <panic>
  if(b->blockno >= FSSIZE)
80102696:	8b 45 08             	mov    0x8(%ebp),%eax
80102699:	8b 40 08             	mov    0x8(%eax),%eax
8010269c:	3d e7 03 00 00       	cmp    $0x3e7,%eax
801026a1:	76 0d                	jbe    801026b0 <idestart+0x33>
    panic("incorrect blockno");
801026a3:	83 ec 0c             	sub    $0xc,%esp
801026a6:	68 1b 86 10 80       	push   $0x8010861b
801026ab:	e8 b2 de ff ff       	call   80100562 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801026b0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801026b7:	8b 45 08             	mov    0x8(%ebp),%eax
801026ba:	8b 50 08             	mov    0x8(%eax),%edx
801026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026c0:	0f af c2             	imul   %edx,%eax
801026c3:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
801026c6:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801026ca:	7e 0d                	jle    801026d9 <idestart+0x5c>
801026cc:	83 ec 0c             	sub    $0xc,%esp
801026cf:	68 12 86 10 80       	push   $0x80108612
801026d4:	e8 89 de ff ff       	call   80100562 <panic>
  
  idewait(0);
801026d9:	83 ec 0c             	sub    $0xc,%esp
801026dc:	6a 00                	push   $0x0
801026de:	e8 ab fe ff ff       	call   8010258e <idewait>
801026e3:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801026e6:	83 ec 08             	sub    $0x8,%esp
801026e9:	6a 00                	push   $0x0
801026eb:	68 f6 03 00 00       	push   $0x3f6
801026f0:	e8 58 fe ff ff       	call   8010254d <outb>
801026f5:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
801026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026fb:	0f b6 c0             	movzbl %al,%eax
801026fe:	83 ec 08             	sub    $0x8,%esp
80102701:	50                   	push   %eax
80102702:	68 f2 01 00 00       	push   $0x1f2
80102707:	e8 41 fe ff ff       	call   8010254d <outb>
8010270c:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
8010270f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102712:	0f b6 c0             	movzbl %al,%eax
80102715:	83 ec 08             	sub    $0x8,%esp
80102718:	50                   	push   %eax
80102719:	68 f3 01 00 00       	push   $0x1f3
8010271e:	e8 2a fe ff ff       	call   8010254d <outb>
80102723:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102726:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102729:	c1 f8 08             	sar    $0x8,%eax
8010272c:	0f b6 c0             	movzbl %al,%eax
8010272f:	83 ec 08             	sub    $0x8,%esp
80102732:	50                   	push   %eax
80102733:	68 f4 01 00 00       	push   $0x1f4
80102738:	e8 10 fe ff ff       	call   8010254d <outb>
8010273d:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102740:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102743:	c1 f8 10             	sar    $0x10,%eax
80102746:	0f b6 c0             	movzbl %al,%eax
80102749:	83 ec 08             	sub    $0x8,%esp
8010274c:	50                   	push   %eax
8010274d:	68 f5 01 00 00       	push   $0x1f5
80102752:	e8 f6 fd ff ff       	call   8010254d <outb>
80102757:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010275a:	8b 45 08             	mov    0x8(%ebp),%eax
8010275d:	8b 40 04             	mov    0x4(%eax),%eax
80102760:	83 e0 01             	and    $0x1,%eax
80102763:	88 c2                	mov    %al,%dl
80102765:	c1 e2 04             	shl    $0x4,%edx
80102768:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010276b:	c1 f8 18             	sar    $0x18,%eax
8010276e:	83 e0 0f             	and    $0xf,%eax
80102771:	09 d0                	or     %edx,%eax
80102773:	83 c8 e0             	or     $0xffffffe0,%eax
80102776:	0f b6 c0             	movzbl %al,%eax
80102779:	83 ec 08             	sub    $0x8,%esp
8010277c:	50                   	push   %eax
8010277d:	68 f6 01 00 00       	push   $0x1f6
80102782:	e8 c6 fd ff ff       	call   8010254d <outb>
80102787:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
8010278a:	8b 45 08             	mov    0x8(%ebp),%eax
8010278d:	8b 00                	mov    (%eax),%eax
8010278f:	83 e0 04             	and    $0x4,%eax
80102792:	85 c0                	test   %eax,%eax
80102794:	74 30                	je     801027c6 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
80102796:	83 ec 08             	sub    $0x8,%esp
80102799:	6a 30                	push   $0x30
8010279b:	68 f7 01 00 00       	push   $0x1f7
801027a0:	e8 a8 fd ff ff       	call   8010254d <outb>
801027a5:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
801027a8:	8b 45 08             	mov    0x8(%ebp),%eax
801027ab:	83 c0 18             	add    $0x18,%eax
801027ae:	83 ec 04             	sub    $0x4,%esp
801027b1:	68 80 00 00 00       	push   $0x80
801027b6:	50                   	push   %eax
801027b7:	68 f0 01 00 00       	push   $0x1f0
801027bc:	e8 a8 fd ff ff       	call   80102569 <outsl>
801027c1:	83 c4 10             	add    $0x10,%esp
801027c4:	eb 12                	jmp    801027d8 <idestart+0x15b>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801027c6:	83 ec 08             	sub    $0x8,%esp
801027c9:	6a 20                	push   $0x20
801027cb:	68 f7 01 00 00       	push   $0x1f7
801027d0:	e8 78 fd ff ff       	call   8010254d <outb>
801027d5:	83 c4 10             	add    $0x10,%esp
  }
}
801027d8:	c9                   	leave  
801027d9:	c3                   	ret    

801027da <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027da:	55                   	push   %ebp
801027db:	89 e5                	mov    %esp,%ebp
801027dd:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027e0:	83 ec 0c             	sub    $0xc,%esp
801027e3:	68 00 b6 10 80       	push   $0x8010b600
801027e8:	e8 d6 27 00 00       	call   80104fc3 <acquire>
801027ed:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801027f0:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801027f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027fc:	75 15                	jne    80102813 <ideintr+0x39>
    release(&idelock);
801027fe:	83 ec 0c             	sub    $0xc,%esp
80102801:	68 00 b6 10 80       	push   $0x8010b600
80102806:	e8 1e 28 00 00       	call   80105029 <release>
8010280b:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
8010280e:	e9 9a 00 00 00       	jmp    801028ad <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102816:	8b 40 14             	mov    0x14(%eax),%eax
80102819:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102821:	8b 00                	mov    (%eax),%eax
80102823:	83 e0 04             	and    $0x4,%eax
80102826:	85 c0                	test   %eax,%eax
80102828:	75 2d                	jne    80102857 <ideintr+0x7d>
8010282a:	83 ec 0c             	sub    $0xc,%esp
8010282d:	6a 01                	push   $0x1
8010282f:	e8 5a fd ff ff       	call   8010258e <idewait>
80102834:	83 c4 10             	add    $0x10,%esp
80102837:	85 c0                	test   %eax,%eax
80102839:	78 1c                	js     80102857 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
8010283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010283e:	83 c0 18             	add    $0x18,%eax
80102841:	83 ec 04             	sub    $0x4,%esp
80102844:	68 80 00 00 00       	push   $0x80
80102849:	50                   	push   %eax
8010284a:	68 f0 01 00 00       	push   $0x1f0
8010284f:	e8 d4 fc ff ff       	call   80102528 <insl>
80102854:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102857:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010285a:	8b 00                	mov    (%eax),%eax
8010285c:	89 c2                	mov    %eax,%edx
8010285e:	83 ca 02             	or     $0x2,%edx
80102861:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102864:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102866:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102869:	8b 00                	mov    (%eax),%eax
8010286b:	89 c2                	mov    %eax,%edx
8010286d:	83 e2 fb             	and    $0xfffffffb,%edx
80102870:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102873:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102875:	83 ec 0c             	sub    $0xc,%esp
80102878:	ff 75 f4             	pushl  -0xc(%ebp)
8010287b:	e8 29 25 00 00       	call   80104da9 <wakeup>
80102880:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102883:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102888:	85 c0                	test   %eax,%eax
8010288a:	74 11                	je     8010289d <ideintr+0xc3>
    idestart(idequeue);
8010288c:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102891:	83 ec 0c             	sub    $0xc,%esp
80102894:	50                   	push   %eax
80102895:	e8 e3 fd ff ff       	call   8010267d <idestart>
8010289a:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
8010289d:	83 ec 0c             	sub    $0xc,%esp
801028a0:	68 00 b6 10 80       	push   $0x8010b600
801028a5:	e8 7f 27 00 00       	call   80105029 <release>
801028aa:	83 c4 10             	add    $0x10,%esp
}
801028ad:	c9                   	leave  
801028ae:	c3                   	ret    

801028af <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801028af:	55                   	push   %ebp
801028b0:	89 e5                	mov    %esp,%ebp
801028b2:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801028b5:	8b 45 08             	mov    0x8(%ebp),%eax
801028b8:	8b 00                	mov    (%eax),%eax
801028ba:	83 e0 01             	and    $0x1,%eax
801028bd:	85 c0                	test   %eax,%eax
801028bf:	75 0d                	jne    801028ce <iderw+0x1f>
    panic("iderw: buf not busy");
801028c1:	83 ec 0c             	sub    $0xc,%esp
801028c4:	68 2d 86 10 80       	push   $0x8010862d
801028c9:	e8 94 dc ff ff       	call   80100562 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801028ce:	8b 45 08             	mov    0x8(%ebp),%eax
801028d1:	8b 00                	mov    (%eax),%eax
801028d3:	83 e0 06             	and    $0x6,%eax
801028d6:	83 f8 02             	cmp    $0x2,%eax
801028d9:	75 0d                	jne    801028e8 <iderw+0x39>
    panic("iderw: nothing to do");
801028db:	83 ec 0c             	sub    $0xc,%esp
801028de:	68 41 86 10 80       	push   $0x80108641
801028e3:	e8 7a dc ff ff       	call   80100562 <panic>
  if(b->dev != 0 && !havedisk1)
801028e8:	8b 45 08             	mov    0x8(%ebp),%eax
801028eb:	8b 40 04             	mov    0x4(%eax),%eax
801028ee:	85 c0                	test   %eax,%eax
801028f0:	74 16                	je     80102908 <iderw+0x59>
801028f2:	a1 38 b6 10 80       	mov    0x8010b638,%eax
801028f7:	85 c0                	test   %eax,%eax
801028f9:	75 0d                	jne    80102908 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
801028fb:	83 ec 0c             	sub    $0xc,%esp
801028fe:	68 56 86 10 80       	push   $0x80108656
80102903:	e8 5a dc ff ff       	call   80100562 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102908:	83 ec 0c             	sub    $0xc,%esp
8010290b:	68 00 b6 10 80       	push   $0x8010b600
80102910:	e8 ae 26 00 00       	call   80104fc3 <acquire>
80102915:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102918:	8b 45 08             	mov    0x8(%ebp),%eax
8010291b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102922:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
80102929:	eb 0b                	jmp    80102936 <iderw+0x87>
8010292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010292e:	8b 00                	mov    (%eax),%eax
80102930:	83 c0 14             	add    $0x14,%eax
80102933:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102936:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102939:	8b 00                	mov    (%eax),%eax
8010293b:	85 c0                	test   %eax,%eax
8010293d:	75 ec                	jne    8010292b <iderw+0x7c>
    ;
  *pp = b;
8010293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102942:	8b 55 08             	mov    0x8(%ebp),%edx
80102945:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102947:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010294c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010294f:	75 25                	jne    80102976 <iderw+0xc7>
    idestart(b);
80102951:	83 ec 0c             	sub    $0xc,%esp
80102954:	ff 75 08             	pushl  0x8(%ebp)
80102957:	e8 21 fd ff ff       	call   8010267d <idestart>
8010295c:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010295f:	eb 16                	jmp    80102977 <iderw+0xc8>
    sleep(b, &idelock);
80102961:	83 ec 08             	sub    $0x8,%esp
80102964:	68 00 b6 10 80       	push   $0x8010b600
80102969:	ff 75 08             	pushl  0x8(%ebp)
8010296c:	e8 4e 23 00 00       	call   80104cbf <sleep>
80102971:	83 c4 10             	add    $0x10,%esp
80102974:	eb 01                	jmp    80102977 <iderw+0xc8>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102976:	90                   	nop
80102977:	8b 45 08             	mov    0x8(%ebp),%eax
8010297a:	8b 00                	mov    (%eax),%eax
8010297c:	83 e0 06             	and    $0x6,%eax
8010297f:	83 f8 02             	cmp    $0x2,%eax
80102982:	75 dd                	jne    80102961 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102984:	83 ec 0c             	sub    $0xc,%esp
80102987:	68 00 b6 10 80       	push   $0x8010b600
8010298c:	e8 98 26 00 00       	call   80105029 <release>
80102991:	83 c4 10             	add    $0x10,%esp
}
80102994:	c9                   	leave  
80102995:	c3                   	ret    
	...

80102998 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102998:	55                   	push   %ebp
80102999:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010299b:	a1 14 22 11 80       	mov    0x80112214,%eax
801029a0:	8b 55 08             	mov    0x8(%ebp),%edx
801029a3:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801029a5:	a1 14 22 11 80       	mov    0x80112214,%eax
801029aa:	8b 40 10             	mov    0x10(%eax),%eax
}
801029ad:	c9                   	leave  
801029ae:	c3                   	ret    

801029af <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801029af:	55                   	push   %ebp
801029b0:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801029b2:	a1 14 22 11 80       	mov    0x80112214,%eax
801029b7:	8b 55 08             	mov    0x8(%ebp),%edx
801029ba:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801029bc:	a1 14 22 11 80       	mov    0x80112214,%eax
801029c1:	8b 55 0c             	mov    0xc(%ebp),%edx
801029c4:	89 50 10             	mov    %edx,0x10(%eax)
}
801029c7:	c9                   	leave  
801029c8:	c3                   	ret    

801029c9 <ioapicinit>:

void
ioapicinit(void)
{
801029c9:	55                   	push   %ebp
801029ca:	89 e5                	mov    %esp,%ebp
801029cc:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
801029cf:	a1 44 23 11 80       	mov    0x80112344,%eax
801029d4:	85 c0                	test   %eax,%eax
801029d6:	0f 84 99 00 00 00    	je     80102a75 <ioapicinit+0xac>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801029dc:	c7 05 14 22 11 80 00 	movl   $0xfec00000,0x80112214
801029e3:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029e6:	6a 01                	push   $0x1
801029e8:	e8 ab ff ff ff       	call   80102998 <ioapicread>
801029ed:	83 c4 04             	add    $0x4,%esp
801029f0:	c1 e8 10             	shr    $0x10,%eax
801029f3:	25 ff 00 00 00       	and    $0xff,%eax
801029f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801029fb:	6a 00                	push   $0x0
801029fd:	e8 96 ff ff ff       	call   80102998 <ioapicread>
80102a02:	83 c4 04             	add    $0x4,%esp
80102a05:	c1 e8 18             	shr    $0x18,%eax
80102a08:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102a0b:	a0 40 23 11 80       	mov    0x80112340,%al
80102a10:	0f b6 c0             	movzbl %al,%eax
80102a13:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102a16:	74 10                	je     80102a28 <ioapicinit+0x5f>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a18:	83 ec 0c             	sub    $0xc,%esp
80102a1b:	68 74 86 10 80       	push   $0x80108674
80102a20:	e8 9e d9 ff ff       	call   801003c3 <cprintf>
80102a25:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102a2f:	eb 3a                	jmp    80102a6b <ioapicinit+0xa2>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a34:	83 c0 20             	add    $0x20,%eax
80102a37:	0d 00 00 01 00       	or     $0x10000,%eax
80102a3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102a3f:	83 c2 08             	add    $0x8,%edx
80102a42:	d1 e2                	shl    %edx
80102a44:	83 ec 08             	sub    $0x8,%esp
80102a47:	50                   	push   %eax
80102a48:	52                   	push   %edx
80102a49:	e8 61 ff ff ff       	call   801029af <ioapicwrite>
80102a4e:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a54:	83 c0 08             	add    $0x8,%eax
80102a57:	d1 e0                	shl    %eax
80102a59:	40                   	inc    %eax
80102a5a:	83 ec 08             	sub    $0x8,%esp
80102a5d:	6a 00                	push   $0x0
80102a5f:	50                   	push   %eax
80102a60:	e8 4a ff ff ff       	call   801029af <ioapicwrite>
80102a65:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a68:	ff 45 f4             	incl   -0xc(%ebp)
80102a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a6e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a71:	7e be                	jle    80102a31 <ioapicinit+0x68>
80102a73:	eb 01                	jmp    80102a76 <ioapicinit+0xad>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102a75:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a76:	c9                   	leave  
80102a77:	c3                   	ret    

80102a78 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a78:	55                   	push   %ebp
80102a79:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102a7b:	a1 44 23 11 80       	mov    0x80112344,%eax
80102a80:	85 c0                	test   %eax,%eax
80102a82:	74 33                	je     80102ab7 <ioapicenable+0x3f>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a84:	8b 45 08             	mov    0x8(%ebp),%eax
80102a87:	83 c0 20             	add    $0x20,%eax
80102a8a:	8b 55 08             	mov    0x8(%ebp),%edx
80102a8d:	83 c2 08             	add    $0x8,%edx
80102a90:	d1 e2                	shl    %edx
80102a92:	50                   	push   %eax
80102a93:	52                   	push   %edx
80102a94:	e8 16 ff ff ff       	call   801029af <ioapicwrite>
80102a99:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a9f:	c1 e0 18             	shl    $0x18,%eax
80102aa2:	8b 55 08             	mov    0x8(%ebp),%edx
80102aa5:	83 c2 08             	add    $0x8,%edx
80102aa8:	d1 e2                	shl    %edx
80102aaa:	42                   	inc    %edx
80102aab:	50                   	push   %eax
80102aac:	52                   	push   %edx
80102aad:	e8 fd fe ff ff       	call   801029af <ioapicwrite>
80102ab2:	83 c4 08             	add    $0x8,%esp
80102ab5:	eb 01                	jmp    80102ab8 <ioapicenable+0x40>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102ab7:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102ab8:	c9                   	leave  
80102ab9:	c3                   	ret    
	...

80102abc <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102abc:	55                   	push   %ebp
80102abd:	89 e5                	mov    %esp,%ebp
80102abf:	8b 45 08             	mov    0x8(%ebp),%eax
80102ac2:	2d 00 00 00 80       	sub    $0x80000000,%eax
80102ac7:	c9                   	leave  
80102ac8:	c3                   	ret    

80102ac9 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102ac9:	55                   	push   %ebp
80102aca:	89 e5                	mov    %esp,%ebp
80102acc:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102acf:	83 ec 08             	sub    $0x8,%esp
80102ad2:	68 a6 86 10 80       	push   $0x801086a6
80102ad7:	68 20 22 11 80       	push   $0x80112220
80102adc:	e8 c1 24 00 00       	call   80104fa2 <initlock>
80102ae1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102ae4:	c7 05 54 22 11 80 00 	movl   $0x0,0x80112254
80102aeb:	00 00 00 
  freerange(vstart, vend);
80102aee:	83 ec 08             	sub    $0x8,%esp
80102af1:	ff 75 0c             	pushl  0xc(%ebp)
80102af4:	ff 75 08             	pushl  0x8(%ebp)
80102af7:	e8 28 00 00 00       	call   80102b24 <freerange>
80102afc:	83 c4 10             	add    $0x10,%esp
}
80102aff:	c9                   	leave  
80102b00:	c3                   	ret    

80102b01 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b01:	55                   	push   %ebp
80102b02:	89 e5                	mov    %esp,%ebp
80102b04:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102b07:	83 ec 08             	sub    $0x8,%esp
80102b0a:	ff 75 0c             	pushl  0xc(%ebp)
80102b0d:	ff 75 08             	pushl  0x8(%ebp)
80102b10:	e8 0f 00 00 00       	call   80102b24 <freerange>
80102b15:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102b18:	c7 05 54 22 11 80 01 	movl   $0x1,0x80112254
80102b1f:	00 00 00 
}
80102b22:	c9                   	leave  
80102b23:	c3                   	ret    

80102b24 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102b24:	55                   	push   %ebp
80102b25:	89 e5                	mov    %esp,%ebp
80102b27:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102b2a:	8b 45 08             	mov    0x8(%ebp),%eax
80102b2d:	05 ff 0f 00 00       	add    $0xfff,%eax
80102b32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102b37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b3a:	eb 15                	jmp    80102b51 <freerange+0x2d>
    kfree(p);
80102b3c:	83 ec 0c             	sub    $0xc,%esp
80102b3f:	ff 75 f4             	pushl  -0xc(%ebp)
80102b42:	e8 1c 00 00 00       	call   80102b63 <kfree>
80102b47:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b4a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b54:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
80102b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b5d:	39 c2                	cmp    %eax,%edx
80102b5f:	76 db                	jbe    80102b3c <freerange+0x18>
    kfree(p);
}
80102b61:	c9                   	leave  
80102b62:	c3                   	ret    

80102b63 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b63:	55                   	push   %ebp
80102b64:	89 e5                	mov    %esp,%ebp
80102b66:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102b69:	8b 45 08             	mov    0x8(%ebp),%eax
80102b6c:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b71:	85 c0                	test   %eax,%eax
80102b73:	75 1b                	jne    80102b90 <kfree+0x2d>
80102b75:	81 7d 08 3c 51 11 80 	cmpl   $0x8011513c,0x8(%ebp)
80102b7c:	72 12                	jb     80102b90 <kfree+0x2d>
80102b7e:	ff 75 08             	pushl  0x8(%ebp)
80102b81:	e8 36 ff ff ff       	call   80102abc <v2p>
80102b86:	83 c4 04             	add    $0x4,%esp
80102b89:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b8e:	76 0d                	jbe    80102b9d <kfree+0x3a>
    panic("kfree");
80102b90:	83 ec 0c             	sub    $0xc,%esp
80102b93:	68 ab 86 10 80       	push   $0x801086ab
80102b98:	e8 c5 d9 ff ff       	call   80100562 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b9d:	83 ec 04             	sub    $0x4,%esp
80102ba0:	68 00 10 00 00       	push   $0x1000
80102ba5:	6a 01                	push   $0x1
80102ba7:	ff 75 08             	pushl  0x8(%ebp)
80102baa:	e8 6f 26 00 00       	call   8010521e <memset>
80102baf:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102bb2:	a1 54 22 11 80       	mov    0x80112254,%eax
80102bb7:	85 c0                	test   %eax,%eax
80102bb9:	74 10                	je     80102bcb <kfree+0x68>
    acquire(&kmem.lock);
80102bbb:	83 ec 0c             	sub    $0xc,%esp
80102bbe:	68 20 22 11 80       	push   $0x80112220
80102bc3:	e8 fb 23 00 00       	call   80104fc3 <acquire>
80102bc8:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102bcb:	8b 45 08             	mov    0x8(%ebp),%eax
80102bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102bd1:	8b 15 58 22 11 80    	mov    0x80112258,%edx
80102bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bda:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bdf:	a3 58 22 11 80       	mov    %eax,0x80112258
  if(kmem.use_lock)
80102be4:	a1 54 22 11 80       	mov    0x80112254,%eax
80102be9:	85 c0                	test   %eax,%eax
80102beb:	74 10                	je     80102bfd <kfree+0x9a>
    release(&kmem.lock);
80102bed:	83 ec 0c             	sub    $0xc,%esp
80102bf0:	68 20 22 11 80       	push   $0x80112220
80102bf5:	e8 2f 24 00 00       	call   80105029 <release>
80102bfa:	83 c4 10             	add    $0x10,%esp
}
80102bfd:	c9                   	leave  
80102bfe:	c3                   	ret    

80102bff <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102bff:	55                   	push   %ebp
80102c00:	89 e5                	mov    %esp,%ebp
80102c02:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102c05:	a1 54 22 11 80       	mov    0x80112254,%eax
80102c0a:	85 c0                	test   %eax,%eax
80102c0c:	74 10                	je     80102c1e <kalloc+0x1f>
    acquire(&kmem.lock);
80102c0e:	83 ec 0c             	sub    $0xc,%esp
80102c11:	68 20 22 11 80       	push   $0x80112220
80102c16:	e8 a8 23 00 00       	call   80104fc3 <acquire>
80102c1b:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102c1e:	a1 58 22 11 80       	mov    0x80112258,%eax
80102c23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102c26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102c2a:	74 0a                	je     80102c36 <kalloc+0x37>
    kmem.freelist = r->next;
80102c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c2f:	8b 00                	mov    (%eax),%eax
80102c31:	a3 58 22 11 80       	mov    %eax,0x80112258
  if(kmem.use_lock)
80102c36:	a1 54 22 11 80       	mov    0x80112254,%eax
80102c3b:	85 c0                	test   %eax,%eax
80102c3d:	74 10                	je     80102c4f <kalloc+0x50>
    release(&kmem.lock);
80102c3f:	83 ec 0c             	sub    $0xc,%esp
80102c42:	68 20 22 11 80       	push   $0x80112220
80102c47:	e8 dd 23 00 00       	call   80105029 <release>
80102c4c:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102c52:	c9                   	leave  
80102c53:	c3                   	ret    

80102c54 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c54:	55                   	push   %ebp
80102c55:	89 e5                	mov    %esp,%ebp
80102c57:	53                   	push   %ebx
80102c58:	83 ec 18             	sub    $0x18,%esp
80102c5b:	8b 45 08             	mov    0x8(%ebp),%eax
80102c5e:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c62:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102c65:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
80102c69:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
80102c6d:	ec                   	in     (%dx),%al
80102c6e:	88 c3                	mov    %al,%bl
80102c70:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102c73:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80102c76:	83 c4 18             	add    $0x18,%esp
80102c79:	5b                   	pop    %ebx
80102c7a:	c9                   	leave  
80102c7b:	c3                   	ret    

80102c7c <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c7c:	55                   	push   %ebp
80102c7d:	89 e5                	mov    %esp,%ebp
80102c7f:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c82:	6a 64                	push   $0x64
80102c84:	e8 cb ff ff ff       	call   80102c54 <inb>
80102c89:	83 c4 04             	add    $0x4,%esp
80102c8c:	0f b6 c0             	movzbl %al,%eax
80102c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c95:	83 e0 01             	and    $0x1,%eax
80102c98:	85 c0                	test   %eax,%eax
80102c9a:	75 0a                	jne    80102ca6 <kbdgetc+0x2a>
    return -1;
80102c9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102ca1:	e9 1d 01 00 00       	jmp    80102dc3 <kbdgetc+0x147>
  data = inb(KBDATAP);
80102ca6:	6a 60                	push   $0x60
80102ca8:	e8 a7 ff ff ff       	call   80102c54 <inb>
80102cad:	83 c4 04             	add    $0x4,%esp
80102cb0:	0f b6 c0             	movzbl %al,%eax
80102cb3:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102cb6:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102cbd:	75 17                	jne    80102cd6 <kbdgetc+0x5a>
    shift |= E0ESC;
80102cbf:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cc4:	83 c8 40             	or     $0x40,%eax
80102cc7:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102ccc:	b8 00 00 00 00       	mov    $0x0,%eax
80102cd1:	e9 ed 00 00 00       	jmp    80102dc3 <kbdgetc+0x147>
  } else if(data & 0x80){
80102cd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cd9:	25 80 00 00 00       	and    $0x80,%eax
80102cde:	85 c0                	test   %eax,%eax
80102ce0:	74 44                	je     80102d26 <kbdgetc+0xaa>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ce2:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102ce7:	83 e0 40             	and    $0x40,%eax
80102cea:	85 c0                	test   %eax,%eax
80102cec:	75 08                	jne    80102cf6 <kbdgetc+0x7a>
80102cee:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cf1:	83 e0 7f             	and    $0x7f,%eax
80102cf4:	eb 03                	jmp    80102cf9 <kbdgetc+0x7d>
80102cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cf9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102cfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cff:	05 20 90 10 80       	add    $0x80109020,%eax
80102d04:	8a 00                	mov    (%eax),%al
80102d06:	83 c8 40             	or     $0x40,%eax
80102d09:	0f b6 c0             	movzbl %al,%eax
80102d0c:	f7 d0                	not    %eax
80102d0e:	89 c2                	mov    %eax,%edx
80102d10:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d15:	21 d0                	and    %edx,%eax
80102d17:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102d1c:	b8 00 00 00 00       	mov    $0x0,%eax
80102d21:	e9 9d 00 00 00       	jmp    80102dc3 <kbdgetc+0x147>
  } else if(shift & E0ESC){
80102d26:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d2b:	83 e0 40             	and    $0x40,%eax
80102d2e:	85 c0                	test   %eax,%eax
80102d30:	74 14                	je     80102d46 <kbdgetc+0xca>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d32:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102d39:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d3e:	83 e0 bf             	and    $0xffffffbf,%eax
80102d41:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102d46:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d49:	05 20 90 10 80       	add    $0x80109020,%eax
80102d4e:	8a 00                	mov    (%eax),%al
80102d50:	0f b6 d0             	movzbl %al,%edx
80102d53:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d58:	09 d0                	or     %edx,%eax
80102d5a:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102d5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d62:	05 20 91 10 80       	add    $0x80109120,%eax
80102d67:	8a 00                	mov    (%eax),%al
80102d69:	0f b6 d0             	movzbl %al,%edx
80102d6c:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d71:	31 d0                	xor    %edx,%eax
80102d73:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d78:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d7d:	83 e0 03             	and    $0x3,%eax
80102d80:	8b 04 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%eax
80102d87:	03 45 fc             	add    -0x4(%ebp),%eax
80102d8a:	8a 00                	mov    (%eax),%al
80102d8c:	0f b6 c0             	movzbl %al,%eax
80102d8f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d92:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d97:	83 e0 08             	and    $0x8,%eax
80102d9a:	85 c0                	test   %eax,%eax
80102d9c:	74 22                	je     80102dc0 <kbdgetc+0x144>
    if('a' <= c && c <= 'z')
80102d9e:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102da2:	76 0c                	jbe    80102db0 <kbdgetc+0x134>
80102da4:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102da8:	77 06                	ja     80102db0 <kbdgetc+0x134>
      c += 'A' - 'a';
80102daa:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102dae:	eb 10                	jmp    80102dc0 <kbdgetc+0x144>
    else if('A' <= c && c <= 'Z')
80102db0:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102db4:	76 0a                	jbe    80102dc0 <kbdgetc+0x144>
80102db6:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102dba:	77 04                	ja     80102dc0 <kbdgetc+0x144>
      c += 'a' - 'A';
80102dbc:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102dc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102dc3:	c9                   	leave  
80102dc4:	c3                   	ret    

80102dc5 <kbdintr>:

void
kbdintr(void)
{
80102dc5:	55                   	push   %ebp
80102dc6:	89 e5                	mov    %esp,%ebp
80102dc8:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102dcb:	83 ec 0c             	sub    $0xc,%esp
80102dce:	68 7c 2c 10 80       	push   $0x80102c7c
80102dd3:	e8 04 da ff ff       	call   801007dc <consoleintr>
80102dd8:	83 c4 10             	add    $0x10,%esp
}
80102ddb:	c9                   	leave  
80102ddc:	c3                   	ret    
80102ddd:	00 00                	add    %al,(%eax)
	...

80102de0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	53                   	push   %ebx
80102de4:	83 ec 18             	sub    $0x18,%esp
80102de7:	8b 45 08             	mov    0x8(%ebp),%eax
80102dea:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dee:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102df1:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
80102df5:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
80102df9:	ec                   	in     (%dx),%al
80102dfa:	88 c3                	mov    %al,%bl
80102dfc:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102dff:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80102e02:	83 c4 18             	add    $0x18,%esp
80102e05:	5b                   	pop    %ebx
80102e06:	c9                   	leave  
80102e07:	c3                   	ret    

80102e08 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102e08:	55                   	push   %ebp
80102e09:	89 e5                	mov    %esp,%ebp
80102e0b:	83 ec 08             	sub    $0x8,%esp
80102e0e:	8b 45 08             	mov    0x8(%ebp),%eax
80102e11:	8b 55 0c             	mov    0xc(%ebp),%edx
80102e14:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102e18:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e1b:	8a 45 f8             	mov    -0x8(%ebp),%al
80102e1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102e21:	ee                   	out    %al,(%dx)
}
80102e22:	c9                   	leave  
80102e23:	c3                   	ret    

80102e24 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102e24:	55                   	push   %ebp
80102e25:	89 e5                	mov    %esp,%ebp
80102e27:	53                   	push   %ebx
80102e28:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102e2b:	9c                   	pushf  
80102e2c:	5b                   	pop    %ebx
80102e2d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80102e30:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102e33:	83 c4 10             	add    $0x10,%esp
80102e36:	5b                   	pop    %ebx
80102e37:	c9                   	leave  
80102e38:	c3                   	ret    

80102e39 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102e39:	55                   	push   %ebp
80102e3a:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102e3c:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102e41:	8b 55 08             	mov    0x8(%ebp),%edx
80102e44:	c1 e2 02             	shl    $0x2,%edx
80102e47:	8d 14 10             	lea    (%eax,%edx,1),%edx
80102e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e4d:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102e4f:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102e54:	83 c0 20             	add    $0x20,%eax
80102e57:	8b 00                	mov    (%eax),%eax
}
80102e59:	c9                   	leave  
80102e5a:	c3                   	ret    

80102e5b <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102e5b:	55                   	push   %ebp
80102e5c:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102e5e:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102e63:	85 c0                	test   %eax,%eax
80102e65:	0f 84 0d 01 00 00    	je     80102f78 <lapicinit+0x11d>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e6b:	68 3f 01 00 00       	push   $0x13f
80102e70:	6a 3c                	push   $0x3c
80102e72:	e8 c2 ff ff ff       	call   80102e39 <lapicw>
80102e77:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102e7a:	6a 0b                	push   $0xb
80102e7c:	68 f8 00 00 00       	push   $0xf8
80102e81:	e8 b3 ff ff ff       	call   80102e39 <lapicw>
80102e86:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e89:	68 20 00 02 00       	push   $0x20020
80102e8e:	68 c8 00 00 00       	push   $0xc8
80102e93:	e8 a1 ff ff ff       	call   80102e39 <lapicw>
80102e98:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102e9b:	68 80 96 98 00       	push   $0x989680
80102ea0:	68 e0 00 00 00       	push   $0xe0
80102ea5:	e8 8f ff ff ff       	call   80102e39 <lapicw>
80102eaa:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102ead:	68 00 00 01 00       	push   $0x10000
80102eb2:	68 d4 00 00 00       	push   $0xd4
80102eb7:	e8 7d ff ff ff       	call   80102e39 <lapicw>
80102ebc:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102ebf:	68 00 00 01 00       	push   $0x10000
80102ec4:	68 d8 00 00 00       	push   $0xd8
80102ec9:	e8 6b ff ff ff       	call   80102e39 <lapicw>
80102ece:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102ed1:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102ed6:	83 c0 30             	add    $0x30,%eax
80102ed9:	8b 00                	mov    (%eax),%eax
80102edb:	c1 e8 10             	shr    $0x10,%eax
80102ede:	25 ff 00 00 00       	and    $0xff,%eax
80102ee3:	83 f8 03             	cmp    $0x3,%eax
80102ee6:	76 12                	jbe    80102efa <lapicinit+0x9f>
    lapicw(PCINT, MASKED);
80102ee8:	68 00 00 01 00       	push   $0x10000
80102eed:	68 d0 00 00 00       	push   $0xd0
80102ef2:	e8 42 ff ff ff       	call   80102e39 <lapicw>
80102ef7:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102efa:	6a 33                	push   $0x33
80102efc:	68 dc 00 00 00       	push   $0xdc
80102f01:	e8 33 ff ff ff       	call   80102e39 <lapicw>
80102f06:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f09:	6a 00                	push   $0x0
80102f0b:	68 a0 00 00 00       	push   $0xa0
80102f10:	e8 24 ff ff ff       	call   80102e39 <lapicw>
80102f15:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102f18:	6a 00                	push   $0x0
80102f1a:	68 a0 00 00 00       	push   $0xa0
80102f1f:	e8 15 ff ff ff       	call   80102e39 <lapicw>
80102f24:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f27:	6a 00                	push   $0x0
80102f29:	6a 2c                	push   $0x2c
80102f2b:	e8 09 ff ff ff       	call   80102e39 <lapicw>
80102f30:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f33:	6a 00                	push   $0x0
80102f35:	68 c4 00 00 00       	push   $0xc4
80102f3a:	e8 fa fe ff ff       	call   80102e39 <lapicw>
80102f3f:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102f42:	68 00 85 08 00       	push   $0x88500
80102f47:	68 c0 00 00 00       	push   $0xc0
80102f4c:	e8 e8 fe ff ff       	call   80102e39 <lapicw>
80102f51:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102f54:	90                   	nop
80102f55:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102f5a:	05 00 03 00 00       	add    $0x300,%eax
80102f5f:	8b 00                	mov    (%eax),%eax
80102f61:	25 00 10 00 00       	and    $0x1000,%eax
80102f66:	85 c0                	test   %eax,%eax
80102f68:	75 eb                	jne    80102f55 <lapicinit+0xfa>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f6a:	6a 00                	push   $0x0
80102f6c:	6a 20                	push   $0x20
80102f6e:	e8 c6 fe ff ff       	call   80102e39 <lapicw>
80102f73:	83 c4 08             	add    $0x8,%esp
80102f76:	eb 01                	jmp    80102f79 <lapicinit+0x11e>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80102f78:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f79:	c9                   	leave  
80102f7a:	c3                   	ret    

80102f7b <cpunum>:

int
cpunum(void)
{
80102f7b:	55                   	push   %ebp
80102f7c:	89 e5                	mov    %esp,%ebp
80102f7e:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f81:	e8 9e fe ff ff       	call   80102e24 <readeflags>
80102f86:	25 00 02 00 00       	and    $0x200,%eax
80102f8b:	85 c0                	test   %eax,%eax
80102f8d:	74 28                	je     80102fb7 <cpunum+0x3c>
    static int n;
    if(n++ == 0)
80102f8f:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102f94:	85 c0                	test   %eax,%eax
80102f96:	0f 94 c2             	sete   %dl
80102f99:	40                   	inc    %eax
80102f9a:	a3 40 b6 10 80       	mov    %eax,0x8010b640
80102f9f:	84 d2                	test   %dl,%dl
80102fa1:	74 14                	je     80102fb7 <cpunum+0x3c>
      cprintf("cpu called from %x with interrupts enabled\n",
80102fa3:	8b 45 04             	mov    0x4(%ebp),%eax
80102fa6:	83 ec 08             	sub    $0x8,%esp
80102fa9:	50                   	push   %eax
80102faa:	68 b4 86 10 80       	push   $0x801086b4
80102faf:	e8 0f d4 ff ff       	call   801003c3 <cprintf>
80102fb4:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80102fb7:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102fbc:	85 c0                	test   %eax,%eax
80102fbe:	74 0f                	je     80102fcf <cpunum+0x54>
    return lapic[ID]>>24;
80102fc0:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102fc5:	83 c0 20             	add    $0x20,%eax
80102fc8:	8b 00                	mov    (%eax),%eax
80102fca:	c1 e8 18             	shr    $0x18,%eax
80102fcd:	eb 05                	jmp    80102fd4 <cpunum+0x59>
  return 0;
80102fcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102fd4:	c9                   	leave  
80102fd5:	c3                   	ret    

80102fd6 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102fd6:	55                   	push   %ebp
80102fd7:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102fd9:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102fde:	85 c0                	test   %eax,%eax
80102fe0:	74 0c                	je     80102fee <lapiceoi+0x18>
    lapicw(EOI, 0);
80102fe2:	6a 00                	push   $0x0
80102fe4:	6a 2c                	push   $0x2c
80102fe6:	e8 4e fe ff ff       	call   80102e39 <lapicw>
80102feb:	83 c4 08             	add    $0x8,%esp
}
80102fee:	c9                   	leave  
80102fef:	c3                   	ret    

80102ff0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
}
80102ff3:	c9                   	leave  
80102ff4:	c3                   	ret    

80102ff5 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ff5:	55                   	push   %ebp
80102ff6:	89 e5                	mov    %esp,%ebp
80102ff8:	83 ec 14             	sub    $0x14,%esp
80102ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80102ffe:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103001:	6a 0f                	push   $0xf
80103003:	6a 70                	push   $0x70
80103005:	e8 fe fd ff ff       	call   80102e08 <outb>
8010300a:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
8010300d:	6a 0a                	push   $0xa
8010300f:	6a 71                	push   $0x71
80103011:	e8 f2 fd ff ff       	call   80102e08 <outb>
80103016:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103019:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103020:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103023:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103028:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010302b:	8d 50 02             	lea    0x2(%eax),%edx
8010302e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103031:	c1 e8 04             	shr    $0x4,%eax
80103034:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103037:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010303b:	c1 e0 18             	shl    $0x18,%eax
8010303e:	50                   	push   %eax
8010303f:	68 c4 00 00 00       	push   $0xc4
80103044:	e8 f0 fd ff ff       	call   80102e39 <lapicw>
80103049:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010304c:	68 00 c5 00 00       	push   $0xc500
80103051:	68 c0 00 00 00       	push   $0xc0
80103056:	e8 de fd ff ff       	call   80102e39 <lapicw>
8010305b:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010305e:	68 c8 00 00 00       	push   $0xc8
80103063:	e8 88 ff ff ff       	call   80102ff0 <microdelay>
80103068:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
8010306b:	68 00 85 00 00       	push   $0x8500
80103070:	68 c0 00 00 00       	push   $0xc0
80103075:	e8 bf fd ff ff       	call   80102e39 <lapicw>
8010307a:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010307d:	6a 64                	push   $0x64
8010307f:	e8 6c ff ff ff       	call   80102ff0 <microdelay>
80103084:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103087:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010308e:	eb 3c                	jmp    801030cc <lapicstartap+0xd7>
    lapicw(ICRHI, apicid<<24);
80103090:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103094:	c1 e0 18             	shl    $0x18,%eax
80103097:	50                   	push   %eax
80103098:	68 c4 00 00 00       	push   $0xc4
8010309d:	e8 97 fd ff ff       	call   80102e39 <lapicw>
801030a2:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
801030a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801030a8:	c1 e8 0c             	shr    $0xc,%eax
801030ab:	80 cc 06             	or     $0x6,%ah
801030ae:	50                   	push   %eax
801030af:	68 c0 00 00 00       	push   $0xc0
801030b4:	e8 80 fd ff ff       	call   80102e39 <lapicw>
801030b9:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801030bc:	68 c8 00 00 00       	push   $0xc8
801030c1:	e8 2a ff ff ff       	call   80102ff0 <microdelay>
801030c6:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030c9:	ff 45 fc             	incl   -0x4(%ebp)
801030cc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801030d0:	7e be                	jle    80103090 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801030d2:	c9                   	leave  
801030d3:	c3                   	ret    

801030d4 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801030d4:	55                   	push   %ebp
801030d5:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801030d7:	8b 45 08             	mov    0x8(%ebp),%eax
801030da:	0f b6 c0             	movzbl %al,%eax
801030dd:	50                   	push   %eax
801030de:	6a 70                	push   $0x70
801030e0:	e8 23 fd ff ff       	call   80102e08 <outb>
801030e5:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801030e8:	68 c8 00 00 00       	push   $0xc8
801030ed:	e8 fe fe ff ff       	call   80102ff0 <microdelay>
801030f2:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801030f5:	6a 71                	push   $0x71
801030f7:	e8 e4 fc ff ff       	call   80102de0 <inb>
801030fc:	83 c4 04             	add    $0x4,%esp
801030ff:	0f b6 c0             	movzbl %al,%eax
}
80103102:	c9                   	leave  
80103103:	c3                   	ret    

80103104 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103104:	55                   	push   %ebp
80103105:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103107:	6a 00                	push   $0x0
80103109:	e8 c6 ff ff ff       	call   801030d4 <cmos_read>
8010310e:	83 c4 04             	add    $0x4,%esp
80103111:	8b 55 08             	mov    0x8(%ebp),%edx
80103114:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103116:	6a 02                	push   $0x2
80103118:	e8 b7 ff ff ff       	call   801030d4 <cmos_read>
8010311d:	83 c4 04             	add    $0x4,%esp
80103120:	8b 55 08             	mov    0x8(%ebp),%edx
80103123:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103126:	6a 04                	push   $0x4
80103128:	e8 a7 ff ff ff       	call   801030d4 <cmos_read>
8010312d:	83 c4 04             	add    $0x4,%esp
80103130:	8b 55 08             	mov    0x8(%ebp),%edx
80103133:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80103136:	6a 07                	push   $0x7
80103138:	e8 97 ff ff ff       	call   801030d4 <cmos_read>
8010313d:	83 c4 04             	add    $0x4,%esp
80103140:	8b 55 08             	mov    0x8(%ebp),%edx
80103143:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80103146:	6a 08                	push   $0x8
80103148:	e8 87 ff ff ff       	call   801030d4 <cmos_read>
8010314d:	83 c4 04             	add    $0x4,%esp
80103150:	8b 55 08             	mov    0x8(%ebp),%edx
80103153:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
80103156:	6a 09                	push   $0x9
80103158:	e8 77 ff ff ff       	call   801030d4 <cmos_read>
8010315d:	83 c4 04             	add    $0x4,%esp
80103160:	8b 55 08             	mov    0x8(%ebp),%edx
80103163:	89 42 14             	mov    %eax,0x14(%edx)
}
80103166:	c9                   	leave  
80103167:	c3                   	ret    

80103168 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103168:	55                   	push   %ebp
80103169:	89 e5                	mov    %esp,%ebp
8010316b:	57                   	push   %edi
8010316c:	56                   	push   %esi
8010316d:	53                   	push   %ebx
8010316e:	83 ec 4c             	sub    $0x4c,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103171:	6a 0b                	push   $0xb
80103173:	e8 5c ff ff ff       	call   801030d4 <cmos_read>
80103178:	83 c4 04             	add    $0x4,%esp
8010317b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  bcd = (sb & (1 << 2)) == 0;
8010317e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103181:	83 e0 04             	and    $0x4,%eax
80103184:	85 c0                	test   %eax,%eax
80103186:	0f 94 c0             	sete   %al
80103189:	0f b6 c0             	movzbl %al,%eax
8010318c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010318f:	eb 01                	jmp    80103192 <cmostime+0x2a>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103191:	90                   	nop

  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103192:	8d 45 c8             	lea    -0x38(%ebp),%eax
80103195:	50                   	push   %eax
80103196:	e8 69 ff ff ff       	call   80103104 <fill_rtcdate>
8010319b:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
8010319e:	6a 0a                	push   $0xa
801031a0:	e8 2f ff ff ff       	call   801030d4 <cmos_read>
801031a5:	83 c4 04             	add    $0x4,%esp
801031a8:	25 80 00 00 00       	and    $0x80,%eax
801031ad:	85 c0                	test   %eax,%eax
801031af:	74 03                	je     801031b4 <cmostime+0x4c>
        continue;
801031b1:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801031b2:	eb de                	jmp    80103192 <cmostime+0x2a>
  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
801031b4:	8d 45 b0             	lea    -0x50(%ebp),%eax
801031b7:	50                   	push   %eax
801031b8:	e8 47 ff ff ff       	call   80103104 <fill_rtcdate>
801031bd:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801031c0:	83 ec 04             	sub    $0x4,%esp
801031c3:	6a 18                	push   $0x18
801031c5:	8d 45 b0             	lea    -0x50(%ebp),%eax
801031c8:	50                   	push   %eax
801031c9:	8d 45 c8             	lea    -0x38(%ebp),%eax
801031cc:	50                   	push   %eax
801031cd:	e8 b3 20 00 00       	call   80105285 <memcmp>
801031d2:	83 c4 10             	add    $0x10,%esp
801031d5:	85 c0                	test   %eax,%eax
801031d7:	75 b8                	jne    80103191 <cmostime+0x29>
      break;
  }

  // convert
  if (bcd) {
801031d9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801031dd:	0f 84 a8 00 00 00    	je     8010328b <cmostime+0x123>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801031e3:	8b 45 c8             	mov    -0x38(%ebp),%eax
801031e6:	89 c2                	mov    %eax,%edx
801031e8:	c1 ea 04             	shr    $0x4,%edx
801031eb:	89 d0                	mov    %edx,%eax
801031ed:	c1 e0 02             	shl    $0x2,%eax
801031f0:	01 d0                	add    %edx,%eax
801031f2:	d1 e0                	shl    %eax
801031f4:	8b 55 c8             	mov    -0x38(%ebp),%edx
801031f7:	83 e2 0f             	and    $0xf,%edx
801031fa:	01 d0                	add    %edx,%eax
801031fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(minute);
801031ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103202:	89 c2                	mov    %eax,%edx
80103204:	c1 ea 04             	shr    $0x4,%edx
80103207:	89 d0                	mov    %edx,%eax
80103209:	c1 e0 02             	shl    $0x2,%eax
8010320c:	01 d0                	add    %edx,%eax
8010320e:	d1 e0                	shl    %eax
80103210:	8b 55 cc             	mov    -0x34(%ebp),%edx
80103213:	83 e2 0f             	and    $0xf,%edx
80103216:	01 d0                	add    %edx,%eax
80103218:	89 45 cc             	mov    %eax,-0x34(%ebp)
    CONV(hour  );
8010321b:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010321e:	89 c2                	mov    %eax,%edx
80103220:	c1 ea 04             	shr    $0x4,%edx
80103223:	89 d0                	mov    %edx,%eax
80103225:	c1 e0 02             	shl    $0x2,%eax
80103228:	01 d0                	add    %edx,%eax
8010322a:	d1 e0                	shl    %eax
8010322c:	8b 55 d0             	mov    -0x30(%ebp),%edx
8010322f:	83 e2 0f             	and    $0xf,%edx
80103232:	01 d0                	add    %edx,%eax
80103234:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(day   );
80103237:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010323a:	89 c2                	mov    %eax,%edx
8010323c:	c1 ea 04             	shr    $0x4,%edx
8010323f:	89 d0                	mov    %edx,%eax
80103241:	c1 e0 02             	shl    $0x2,%eax
80103244:	01 d0                	add    %edx,%eax
80103246:	d1 e0                	shl    %eax
80103248:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010324b:	83 e2 0f             	and    $0xf,%edx
8010324e:	01 d0                	add    %edx,%eax
80103250:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(month );
80103253:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103256:	89 c2                	mov    %eax,%edx
80103258:	c1 ea 04             	shr    $0x4,%edx
8010325b:	89 d0                	mov    %edx,%eax
8010325d:	c1 e0 02             	shl    $0x2,%eax
80103260:	01 d0                	add    %edx,%eax
80103262:	d1 e0                	shl    %eax
80103264:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103267:	83 e2 0f             	and    $0xf,%edx
8010326a:	01 d0                	add    %edx,%eax
8010326c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(year  );
8010326f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103272:	89 c2                	mov    %eax,%edx
80103274:	c1 ea 04             	shr    $0x4,%edx
80103277:	89 d0                	mov    %edx,%eax
80103279:	c1 e0 02             	shl    $0x2,%eax
8010327c:	01 d0                	add    %edx,%eax
8010327e:	d1 e0                	shl    %eax
80103280:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103283:	83 e2 0f             	and    $0xf,%edx
80103286:	01 d0                	add    %edx,%eax
80103288:	89 45 dc             	mov    %eax,-0x24(%ebp)
#undef     CONV
  }

  *r = t1;
8010328b:	8b 45 08             	mov    0x8(%ebp),%eax
8010328e:	89 c2                	mov    %eax,%edx
80103290:	8d 5d c8             	lea    -0x38(%ebp),%ebx
80103293:	b8 06 00 00 00       	mov    $0x6,%eax
80103298:	89 d7                	mov    %edx,%edi
8010329a:	89 de                	mov    %ebx,%esi
8010329c:	89 c1                	mov    %eax,%ecx
8010329e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
801032a0:	8b 45 08             	mov    0x8(%ebp),%eax
801032a3:	8b 40 14             	mov    0x14(%eax),%eax
801032a6:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801032ac:	8b 45 08             	mov    0x8(%ebp),%eax
801032af:	89 50 14             	mov    %edx,0x14(%eax)
}
801032b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032b5:	83 c4 00             	add    $0x0,%esp
801032b8:	5b                   	pop    %ebx
801032b9:	5e                   	pop    %esi
801032ba:	5f                   	pop    %edi
801032bb:	c9                   	leave  
801032bc:	c3                   	ret    
801032bd:	00 00                	add    %al,(%eax)
	...

801032c0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801032c6:	83 ec 08             	sub    $0x8,%esp
801032c9:	68 e0 86 10 80       	push   $0x801086e0
801032ce:	68 60 22 11 80       	push   $0x80112260
801032d3:	e8 ca 1c 00 00       	call   80104fa2 <initlock>
801032d8:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801032db:	83 ec 08             	sub    $0x8,%esp
801032de:	8d 45 dc             	lea    -0x24(%ebp),%eax
801032e1:	50                   	push   %eax
801032e2:	ff 75 08             	pushl  0x8(%ebp)
801032e5:	e8 5a e0 ff ff       	call   80101344 <readsb>
801032ea:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
801032ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032f0:	a3 94 22 11 80       	mov    %eax,0x80112294
  log.size = sb.nlog;
801032f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032f8:	a3 98 22 11 80       	mov    %eax,0x80112298
  log.dev = dev;
801032fd:	8b 45 08             	mov    0x8(%ebp),%eax
80103300:	a3 a4 22 11 80       	mov    %eax,0x801122a4
  recover_from_log();
80103305:	e8 a6 01 00 00       	call   801034b0 <recover_from_log>
}
8010330a:	c9                   	leave  
8010330b:	c3                   	ret    

8010330c <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
8010330c:	55                   	push   %ebp
8010330d:	89 e5                	mov    %esp,%ebp
8010330f:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103312:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103319:	e9 8f 00 00 00       	jmp    801033ad <install_trans+0xa1>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010331e:	a1 94 22 11 80       	mov    0x80112294,%eax
80103323:	03 45 f4             	add    -0xc(%ebp),%eax
80103326:	40                   	inc    %eax
80103327:	89 c2                	mov    %eax,%edx
80103329:	a1 a4 22 11 80       	mov    0x801122a4,%eax
8010332e:	83 ec 08             	sub    $0x8,%esp
80103331:	52                   	push   %edx
80103332:	50                   	push   %eax
80103333:	e8 7d ce ff ff       	call   801001b5 <bread>
80103338:	83 c4 10             	add    $0x10,%esp
8010333b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010333e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103341:	83 c0 10             	add    $0x10,%eax
80103344:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
8010334b:	89 c2                	mov    %eax,%edx
8010334d:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103352:	83 ec 08             	sub    $0x8,%esp
80103355:	52                   	push   %edx
80103356:	50                   	push   %eax
80103357:	e8 59 ce ff ff       	call   801001b5 <bread>
8010335c:	83 c4 10             	add    $0x10,%esp
8010335f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103362:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103365:	8d 50 18             	lea    0x18(%eax),%edx
80103368:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010336b:	83 c0 18             	add    $0x18,%eax
8010336e:	83 ec 04             	sub    $0x4,%esp
80103371:	68 00 02 00 00       	push   $0x200
80103376:	52                   	push   %edx
80103377:	50                   	push   %eax
80103378:	e8 5d 1f 00 00       	call   801052da <memmove>
8010337d:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80103380:	83 ec 0c             	sub    $0xc,%esp
80103383:	ff 75 ec             	pushl  -0x14(%ebp)
80103386:	e8 63 ce ff ff       	call   801001ee <bwrite>
8010338b:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
8010338e:	83 ec 0c             	sub    $0xc,%esp
80103391:	ff 75 f0             	pushl  -0x10(%ebp)
80103394:	e8 93 ce ff ff       	call   8010022c <brelse>
80103399:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
8010339c:	83 ec 0c             	sub    $0xc,%esp
8010339f:	ff 75 ec             	pushl  -0x14(%ebp)
801033a2:	e8 85 ce ff ff       	call   8010022c <brelse>
801033a7:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033aa:	ff 45 f4             	incl   -0xc(%ebp)
801033ad:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801033b2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033b5:	0f 8f 63 ff ff ff    	jg     8010331e <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801033bb:	c9                   	leave  
801033bc:	c3                   	ret    

801033bd <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801033bd:	55                   	push   %ebp
801033be:	89 e5                	mov    %esp,%ebp
801033c0:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801033c3:	a1 94 22 11 80       	mov    0x80112294,%eax
801033c8:	89 c2                	mov    %eax,%edx
801033ca:	a1 a4 22 11 80       	mov    0x801122a4,%eax
801033cf:	83 ec 08             	sub    $0x8,%esp
801033d2:	52                   	push   %edx
801033d3:	50                   	push   %eax
801033d4:	e8 dc cd ff ff       	call   801001b5 <bread>
801033d9:	83 c4 10             	add    $0x10,%esp
801033dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801033df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033e2:	83 c0 18             	add    $0x18,%eax
801033e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801033e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033eb:	8b 00                	mov    (%eax),%eax
801033ed:	a3 a8 22 11 80       	mov    %eax,0x801122a8
  for (i = 0; i < log.lh.n; i++) {
801033f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033f9:	eb 1a                	jmp    80103415 <read_head+0x58>
    log.lh.block[i] = lh->block[i];
801033fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103401:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103405:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103408:	83 c2 10             	add    $0x10,%edx
8010340b:	89 04 95 6c 22 11 80 	mov    %eax,-0x7feedd94(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103412:	ff 45 f4             	incl   -0xc(%ebp)
80103415:	a1 a8 22 11 80       	mov    0x801122a8,%eax
8010341a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010341d:	7f dc                	jg     801033fb <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
8010341f:	83 ec 0c             	sub    $0xc,%esp
80103422:	ff 75 f0             	pushl  -0x10(%ebp)
80103425:	e8 02 ce ff ff       	call   8010022c <brelse>
8010342a:	83 c4 10             	add    $0x10,%esp
}
8010342d:	c9                   	leave  
8010342e:	c3                   	ret    

8010342f <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010342f:	55                   	push   %ebp
80103430:	89 e5                	mov    %esp,%ebp
80103432:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103435:	a1 94 22 11 80       	mov    0x80112294,%eax
8010343a:	89 c2                	mov    %eax,%edx
8010343c:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103441:	83 ec 08             	sub    $0x8,%esp
80103444:	52                   	push   %edx
80103445:	50                   	push   %eax
80103446:	e8 6a cd ff ff       	call   801001b5 <bread>
8010344b:	83 c4 10             	add    $0x10,%esp
8010344e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103451:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103454:	83 c0 18             	add    $0x18,%eax
80103457:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010345a:	8b 15 a8 22 11 80    	mov    0x801122a8,%edx
80103460:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103463:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103465:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010346c:	eb 1a                	jmp    80103488 <write_head+0x59>
    hb->block[i] = log.lh.block[i];
8010346e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103471:	83 c0 10             	add    $0x10,%eax
80103474:	8b 0c 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%ecx
8010347b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010347e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103481:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103485:	ff 45 f4             	incl   -0xc(%ebp)
80103488:	a1 a8 22 11 80       	mov    0x801122a8,%eax
8010348d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103490:	7f dc                	jg     8010346e <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80103492:	83 ec 0c             	sub    $0xc,%esp
80103495:	ff 75 f0             	pushl  -0x10(%ebp)
80103498:	e8 51 cd ff ff       	call   801001ee <bwrite>
8010349d:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	ff 75 f0             	pushl  -0x10(%ebp)
801034a6:	e8 81 cd ff ff       	call   8010022c <brelse>
801034ab:	83 c4 10             	add    $0x10,%esp
}
801034ae:	c9                   	leave  
801034af:	c3                   	ret    

801034b0 <recover_from_log>:

static void
recover_from_log(void)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801034b6:	e8 02 ff ff ff       	call   801033bd <read_head>
  install_trans(); // if committed, copy from log to disk
801034bb:	e8 4c fe ff ff       	call   8010330c <install_trans>
  log.lh.n = 0;
801034c0:	c7 05 a8 22 11 80 00 	movl   $0x0,0x801122a8
801034c7:	00 00 00 
  write_head(); // clear the log
801034ca:	e8 60 ff ff ff       	call   8010342f <write_head>
}
801034cf:	c9                   	leave  
801034d0:	c3                   	ret    

801034d1 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801034d1:	55                   	push   %ebp
801034d2:	89 e5                	mov    %esp,%ebp
801034d4:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801034d7:	83 ec 0c             	sub    $0xc,%esp
801034da:	68 60 22 11 80       	push   $0x80112260
801034df:	e8 df 1a 00 00       	call   80104fc3 <acquire>
801034e4:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801034e7:	a1 a0 22 11 80       	mov    0x801122a0,%eax
801034ec:	85 c0                	test   %eax,%eax
801034ee:	74 17                	je     80103507 <begin_op+0x36>
      sleep(&log, &log.lock);
801034f0:	83 ec 08             	sub    $0x8,%esp
801034f3:	68 60 22 11 80       	push   $0x80112260
801034f8:	68 60 22 11 80       	push   $0x80112260
801034fd:	e8 bd 17 00 00       	call   80104cbf <sleep>
80103502:	83 c4 10             	add    $0x10,%esp
    } else {
      log.outstanding += 1;
      release(&log.lock);
      break;
    }
  }
80103505:	eb e0                	jmp    801034e7 <begin_op+0x16>
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103507:	8b 15 a8 22 11 80    	mov    0x801122a8,%edx
8010350d:	a1 9c 22 11 80       	mov    0x8011229c,%eax
80103512:	8d 48 01             	lea    0x1(%eax),%ecx
80103515:	89 c8                	mov    %ecx,%eax
80103517:	c1 e0 02             	shl    $0x2,%eax
8010351a:	01 c8                	add    %ecx,%eax
8010351c:	d1 e0                	shl    %eax
8010351e:	8d 04 02             	lea    (%edx,%eax,1),%eax
80103521:	83 f8 1e             	cmp    $0x1e,%eax
80103524:	7e 17                	jle    8010353d <begin_op+0x6c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103526:	83 ec 08             	sub    $0x8,%esp
80103529:	68 60 22 11 80       	push   $0x80112260
8010352e:	68 60 22 11 80       	push   $0x80112260
80103533:	e8 87 17 00 00       	call   80104cbf <sleep>
80103538:	83 c4 10             	add    $0x10,%esp
    } else {
      log.outstanding += 1;
      release(&log.lock);
      break;
    }
  }
8010353b:	eb aa                	jmp    801034e7 <begin_op+0x16>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
8010353d:	a1 9c 22 11 80       	mov    0x8011229c,%eax
80103542:	40                   	inc    %eax
80103543:	a3 9c 22 11 80       	mov    %eax,0x8011229c
      release(&log.lock);
80103548:	83 ec 0c             	sub    $0xc,%esp
8010354b:	68 60 22 11 80       	push   $0x80112260
80103550:	e8 d4 1a 00 00       	call   80105029 <release>
80103555:	83 c4 10             	add    $0x10,%esp
      break;
    }
  }
}
80103558:	c9                   	leave  
80103559:	c3                   	ret    

8010355a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010355a:	55                   	push   %ebp
8010355b:	89 e5                	mov    %esp,%ebp
8010355d:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103560:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103567:	83 ec 0c             	sub    $0xc,%esp
8010356a:	68 60 22 11 80       	push   $0x80112260
8010356f:	e8 4f 1a 00 00       	call   80104fc3 <acquire>
80103574:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103577:	a1 9c 22 11 80       	mov    0x8011229c,%eax
8010357c:	48                   	dec    %eax
8010357d:	a3 9c 22 11 80       	mov    %eax,0x8011229c
  if(log.committing)
80103582:	a1 a0 22 11 80       	mov    0x801122a0,%eax
80103587:	85 c0                	test   %eax,%eax
80103589:	74 0d                	je     80103598 <end_op+0x3e>
    panic("log.committing");
8010358b:	83 ec 0c             	sub    $0xc,%esp
8010358e:	68 e4 86 10 80       	push   $0x801086e4
80103593:	e8 ca cf ff ff       	call   80100562 <panic>
  if(log.outstanding == 0){
80103598:	a1 9c 22 11 80       	mov    0x8011229c,%eax
8010359d:	85 c0                	test   %eax,%eax
8010359f:	75 13                	jne    801035b4 <end_op+0x5a>
    do_commit = 1;
801035a1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801035a8:	c7 05 a0 22 11 80 01 	movl   $0x1,0x801122a0
801035af:	00 00 00 
801035b2:	eb 10                	jmp    801035c4 <end_op+0x6a>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801035b4:	83 ec 0c             	sub    $0xc,%esp
801035b7:	68 60 22 11 80       	push   $0x80112260
801035bc:	e8 e8 17 00 00       	call   80104da9 <wakeup>
801035c1:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801035c4:	83 ec 0c             	sub    $0xc,%esp
801035c7:	68 60 22 11 80       	push   $0x80112260
801035cc:	e8 58 1a 00 00       	call   80105029 <release>
801035d1:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801035d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801035d8:	74 3f                	je     80103619 <end_op+0xbf>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801035da:	e8 ed 00 00 00       	call   801036cc <commit>
    acquire(&log.lock);
801035df:	83 ec 0c             	sub    $0xc,%esp
801035e2:	68 60 22 11 80       	push   $0x80112260
801035e7:	e8 d7 19 00 00       	call   80104fc3 <acquire>
801035ec:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801035ef:	c7 05 a0 22 11 80 00 	movl   $0x0,0x801122a0
801035f6:	00 00 00 
    wakeup(&log);
801035f9:	83 ec 0c             	sub    $0xc,%esp
801035fc:	68 60 22 11 80       	push   $0x80112260
80103601:	e8 a3 17 00 00       	call   80104da9 <wakeup>
80103606:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103609:	83 ec 0c             	sub    $0xc,%esp
8010360c:	68 60 22 11 80       	push   $0x80112260
80103611:	e8 13 1a 00 00       	call   80105029 <release>
80103616:	83 c4 10             	add    $0x10,%esp
  }
}
80103619:	c9                   	leave  
8010361a:	c3                   	ret    

8010361b <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
8010361b:	55                   	push   %ebp
8010361c:	89 e5                	mov    %esp,%ebp
8010361e:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103621:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103628:	e9 8f 00 00 00       	jmp    801036bc <write_log+0xa1>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010362d:	a1 94 22 11 80       	mov    0x80112294,%eax
80103632:	03 45 f4             	add    -0xc(%ebp),%eax
80103635:	40                   	inc    %eax
80103636:	89 c2                	mov    %eax,%edx
80103638:	a1 a4 22 11 80       	mov    0x801122a4,%eax
8010363d:	83 ec 08             	sub    $0x8,%esp
80103640:	52                   	push   %edx
80103641:	50                   	push   %eax
80103642:	e8 6e cb ff ff       	call   801001b5 <bread>
80103647:	83 c4 10             	add    $0x10,%esp
8010364a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010364d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103650:	83 c0 10             	add    $0x10,%eax
80103653:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
8010365a:	89 c2                	mov    %eax,%edx
8010365c:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103661:	83 ec 08             	sub    $0x8,%esp
80103664:	52                   	push   %edx
80103665:	50                   	push   %eax
80103666:	e8 4a cb ff ff       	call   801001b5 <bread>
8010366b:	83 c4 10             	add    $0x10,%esp
8010366e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103671:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103674:	8d 50 18             	lea    0x18(%eax),%edx
80103677:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010367a:	83 c0 18             	add    $0x18,%eax
8010367d:	83 ec 04             	sub    $0x4,%esp
80103680:	68 00 02 00 00       	push   $0x200
80103685:	52                   	push   %edx
80103686:	50                   	push   %eax
80103687:	e8 4e 1c 00 00       	call   801052da <memmove>
8010368c:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
8010368f:	83 ec 0c             	sub    $0xc,%esp
80103692:	ff 75 f0             	pushl  -0x10(%ebp)
80103695:	e8 54 cb ff ff       	call   801001ee <bwrite>
8010369a:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
8010369d:	83 ec 0c             	sub    $0xc,%esp
801036a0:	ff 75 ec             	pushl  -0x14(%ebp)
801036a3:	e8 84 cb ff ff       	call   8010022c <brelse>
801036a8:	83 c4 10             	add    $0x10,%esp
    brelse(to);
801036ab:	83 ec 0c             	sub    $0xc,%esp
801036ae:	ff 75 f0             	pushl  -0x10(%ebp)
801036b1:	e8 76 cb ff ff       	call   8010022c <brelse>
801036b6:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036b9:	ff 45 f4             	incl   -0xc(%ebp)
801036bc:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801036c1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036c4:	0f 8f 63 ff ff ff    	jg     8010362d <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801036ca:	c9                   	leave  
801036cb:	c3                   	ret    

801036cc <commit>:

static void
commit()
{
801036cc:	55                   	push   %ebp
801036cd:	89 e5                	mov    %esp,%ebp
801036cf:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801036d2:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801036d7:	85 c0                	test   %eax,%eax
801036d9:	7e 1e                	jle    801036f9 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
801036db:	e8 3b ff ff ff       	call   8010361b <write_log>
    write_head();    // Write header to disk -- the real commit
801036e0:	e8 4a fd ff ff       	call   8010342f <write_head>
    install_trans(); // Now install writes to home locations
801036e5:	e8 22 fc ff ff       	call   8010330c <install_trans>
    log.lh.n = 0; 
801036ea:	c7 05 a8 22 11 80 00 	movl   $0x0,0x801122a8
801036f1:	00 00 00 
    write_head();    // Erase the transaction from the log
801036f4:	e8 36 fd ff ff       	call   8010342f <write_head>
  }
}
801036f9:	c9                   	leave  
801036fa:	c3                   	ret    

801036fb <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801036fb:	55                   	push   %ebp
801036fc:	89 e5                	mov    %esp,%ebp
801036fe:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103701:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103706:	83 f8 1d             	cmp    $0x1d,%eax
80103709:	7f 10                	jg     8010371b <log_write+0x20>
8010370b:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103710:	8b 15 98 22 11 80    	mov    0x80112298,%edx
80103716:	4a                   	dec    %edx
80103717:	39 d0                	cmp    %edx,%eax
80103719:	7c 0d                	jl     80103728 <log_write+0x2d>
    panic("too big a transaction");
8010371b:	83 ec 0c             	sub    $0xc,%esp
8010371e:	68 f3 86 10 80       	push   $0x801086f3
80103723:	e8 3a ce ff ff       	call   80100562 <panic>
  if (log.outstanding < 1)
80103728:	a1 9c 22 11 80       	mov    0x8011229c,%eax
8010372d:	85 c0                	test   %eax,%eax
8010372f:	7f 0d                	jg     8010373e <log_write+0x43>
    panic("log_write outside of trans");
80103731:	83 ec 0c             	sub    $0xc,%esp
80103734:	68 09 87 10 80       	push   $0x80108709
80103739:	e8 24 ce ff ff       	call   80100562 <panic>

  acquire(&log.lock);
8010373e:	83 ec 0c             	sub    $0xc,%esp
80103741:	68 60 22 11 80       	push   $0x80112260
80103746:	e8 78 18 00 00       	call   80104fc3 <acquire>
8010374b:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
8010374e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103755:	eb 1c                	jmp    80103773 <log_write+0x78>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103757:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010375a:	83 c0 10             	add    $0x10,%eax
8010375d:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
80103764:	89 c2                	mov    %eax,%edx
80103766:	8b 45 08             	mov    0x8(%ebp),%eax
80103769:	8b 40 08             	mov    0x8(%eax),%eax
8010376c:	39 c2                	cmp    %eax,%edx
8010376e:	74 0f                	je     8010377f <log_write+0x84>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103770:	ff 45 f4             	incl   -0xc(%ebp)
80103773:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103778:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010377b:	7f da                	jg     80103757 <log_write+0x5c>
8010377d:	eb 01                	jmp    80103780 <log_write+0x85>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
8010377f:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103780:	8b 45 08             	mov    0x8(%ebp),%eax
80103783:	8b 40 08             	mov    0x8(%eax),%eax
80103786:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103789:	83 c2 10             	add    $0x10,%edx
8010378c:	89 04 95 6c 22 11 80 	mov    %eax,-0x7feedd94(,%edx,4)
  if (i == log.lh.n)
80103793:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103798:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010379b:	75 0b                	jne    801037a8 <log_write+0xad>
    log.lh.n++;
8010379d:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801037a2:	40                   	inc    %eax
801037a3:	a3 a8 22 11 80       	mov    %eax,0x801122a8
  b->flags |= B_DIRTY; // prevent eviction
801037a8:	8b 45 08             	mov    0x8(%ebp),%eax
801037ab:	8b 00                	mov    (%eax),%eax
801037ad:	89 c2                	mov    %eax,%edx
801037af:	83 ca 04             	or     $0x4,%edx
801037b2:	8b 45 08             	mov    0x8(%ebp),%eax
801037b5:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801037b7:	83 ec 0c             	sub    $0xc,%esp
801037ba:	68 60 22 11 80       	push   $0x80112260
801037bf:	e8 65 18 00 00       	call   80105029 <release>
801037c4:	83 c4 10             	add    $0x10,%esp
}
801037c7:	c9                   	leave  
801037c8:	c3                   	ret    
801037c9:	00 00                	add    %al,(%eax)
	...

801037cc <v2p>:
801037cc:	55                   	push   %ebp
801037cd:	89 e5                	mov    %esp,%ebp
801037cf:	8b 45 08             	mov    0x8(%ebp),%eax
801037d2:	2d 00 00 00 80       	sub    $0x80000000,%eax
801037d7:	c9                   	leave  
801037d8:	c3                   	ret    

801037d9 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801037d9:	55                   	push   %ebp
801037da:	89 e5                	mov    %esp,%ebp
801037dc:	8b 45 08             	mov    0x8(%ebp),%eax
801037df:	2d 00 00 00 80       	sub    $0x80000000,%eax
801037e4:	c9                   	leave  
801037e5:	c3                   	ret    

801037e6 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801037e6:	55                   	push   %ebp
801037e7:	89 e5                	mov    %esp,%ebp
801037e9:	53                   	push   %ebx
801037ea:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
801037ed:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801037f0:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
801037f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801037f6:	89 c3                	mov    %eax,%ebx
801037f8:	89 d8                	mov    %ebx,%eax
801037fa:	f0 87 02             	lock xchg %eax,(%edx)
801037fd:	89 c3                	mov    %eax,%ebx
801037ff:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103802:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103805:	83 c4 10             	add    $0x10,%esp
80103808:	5b                   	pop    %ebx
80103809:	c9                   	leave  
8010380a:	c3                   	ret    

8010380b <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010380b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
8010380f:	83 e4 f0             	and    $0xfffffff0,%esp
80103812:	ff 71 fc             	pushl  -0x4(%ecx)
80103815:	55                   	push   %ebp
80103816:	89 e5                	mov    %esp,%ebp
80103818:	51                   	push   %ecx
80103819:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010381c:	83 ec 08             	sub    $0x8,%esp
8010381f:	68 00 00 40 80       	push   $0x80400000
80103824:	68 3c 51 11 80       	push   $0x8011513c
80103829:	e8 9b f2 ff ff       	call   80102ac9 <kinit1>
8010382e:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103831:	e8 ca 44 00 00       	call   80107d00 <kvmalloc>
  mpinit();        // collect info about this machine
80103836:	e8 87 04 00 00       	call   80103cc2 <mpinit>
  lapicinit();
8010383b:	e8 1b f6 ff ff       	call   80102e5b <lapicinit>
  seginit();       // set up segments
80103840:	e8 98 3e 00 00       	call   801076dd <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103845:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010384b:	8a 00                	mov    (%eax),%al
8010384d:	0f b6 c0             	movzbl %al,%eax
80103850:	83 ec 08             	sub    $0x8,%esp
80103853:	50                   	push   %eax
80103854:	68 24 87 10 80       	push   $0x80108724
80103859:	e8 65 cb ff ff       	call   801003c3 <cprintf>
8010385e:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103861:	e8 bc 06 00 00       	call   80103f22 <picinit>
  ioapicinit();    // another interrupt controller
80103866:	e8 5e f1 ff ff       	call   801029c9 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010386b:	e8 93 d2 ff ff       	call   80100b03 <consoleinit>
  uartinit();      // serial port
80103870:	e8 cf 31 00 00       	call   80106a44 <uartinit>
  pinit();         // process table
80103875:	e8 a5 0b 00 00       	call   8010441f <pinit>
  tvinit();        // trap vectors
8010387a:	e8 a6 2d 00 00       	call   80106625 <tvinit>
  binit();         // buffer cache
8010387f:	e8 b0 c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103884:	e8 af d6 ff ff       	call   80100f38 <fileinit>
  ideinit();       // disk
80103889:	e8 45 ed ff ff       	call   801025d3 <ideinit>
  if(!ismp)
8010388e:	a1 44 23 11 80       	mov    0x80112344,%eax
80103893:	85 c0                	test   %eax,%eax
80103895:	75 05                	jne    8010389c <main+0x91>
    timerinit();   // uniprocessor timer
80103897:	e8 e4 2c 00 00       	call   80106580 <timerinit>
  startothers();   // start other processors
8010389c:	e8 7e 00 00 00       	call   8010391f <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801038a1:	83 ec 08             	sub    $0x8,%esp
801038a4:	68 00 00 00 8e       	push   $0x8e000000
801038a9:	68 00 00 40 80       	push   $0x80400000
801038ae:	e8 4e f2 ff ff       	call   80102b01 <kinit2>
801038b3:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801038b6:	e8 83 0c 00 00       	call   8010453e <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801038bb:	e8 1a 00 00 00       	call   801038da <mpmain>

801038c0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801038c6:	e8 4c 44 00 00       	call   80107d17 <switchkvm>
  seginit();
801038cb:	e8 0d 3e 00 00       	call   801076dd <seginit>
  lapicinit();
801038d0:	e8 86 f5 ff ff       	call   80102e5b <lapicinit>
  mpmain();
801038d5:	e8 00 00 00 00       	call   801038da <mpmain>

801038da <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801038da:	55                   	push   %ebp
801038db:	89 e5                	mov    %esp,%ebp
801038dd:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801038e0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038e6:	8a 00                	mov    (%eax),%al
801038e8:	0f b6 c0             	movzbl %al,%eax
801038eb:	83 ec 08             	sub    $0x8,%esp
801038ee:	50                   	push   %eax
801038ef:	68 3b 87 10 80       	push   $0x8010873b
801038f4:	e8 ca ca ff ff       	call   801003c3 <cprintf>
801038f9:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
801038fc:	e8 82 2e 00 00       	call   80106783 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103901:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103907:	05 a8 00 00 00       	add    $0xa8,%eax
8010390c:	83 ec 08             	sub    $0x8,%esp
8010390f:	6a 01                	push   $0x1
80103911:	50                   	push   %eax
80103912:	e8 cf fe ff ff       	call   801037e6 <xchg>
80103917:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
8010391a:	e8 c0 11 00 00       	call   80104adf <scheduler>

8010391f <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
8010391f:	55                   	push   %ebp
80103920:	89 e5                	mov    %esp,%ebp
80103922:	53                   	push   %ebx
80103923:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103926:	68 00 70 00 00       	push   $0x7000
8010392b:	e8 a9 fe ff ff       	call   801037d9 <p2v>
80103930:	83 c4 04             	add    $0x4,%esp
80103933:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103936:	b8 8a 00 00 00       	mov    $0x8a,%eax
8010393b:	83 ec 04             	sub    $0x4,%esp
8010393e:	50                   	push   %eax
8010393f:	68 0c b5 10 80       	push   $0x8010b50c
80103944:	ff 75 f0             	pushl  -0x10(%ebp)
80103947:	e8 8e 19 00 00       	call   801052da <memmove>
8010394c:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
8010394f:	c7 45 f4 60 23 11 80 	movl   $0x80112360,-0xc(%ebp)
80103956:	e9 98 00 00 00       	jmp    801039f3 <startothers+0xd4>
    if(c == cpus+cpunum())  // We've started already.
8010395b:	e8 1b f6 ff ff       	call   80102f7b <cpunum>
80103960:	89 c2                	mov    %eax,%edx
80103962:	89 d0                	mov    %edx,%eax
80103964:	d1 e0                	shl    %eax
80103966:	01 d0                	add    %edx,%eax
80103968:	c1 e0 04             	shl    $0x4,%eax
8010396b:	29 d0                	sub    %edx,%eax
8010396d:	c1 e0 02             	shl    $0x2,%eax
80103970:	05 60 23 11 80       	add    $0x80112360,%eax
80103975:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103978:	74 71                	je     801039eb <startothers+0xcc>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010397a:	e8 80 f2 ff ff       	call   80102bff <kalloc>
8010397f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103982:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103985:	83 e8 04             	sub    $0x4,%eax
80103988:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010398b:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103991:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103993:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103996:	83 e8 08             	sub    $0x8,%eax
80103999:	c7 00 c0 38 10 80    	movl   $0x801038c0,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
8010399f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039a2:	8d 58 f4             	lea    -0xc(%eax),%ebx
801039a5:	b8 00 a0 10 80       	mov    $0x8010a000,%eax
801039aa:	83 ec 0c             	sub    $0xc,%esp
801039ad:	50                   	push   %eax
801039ae:	e8 19 fe ff ff       	call   801037cc <v2p>
801039b3:	83 c4 10             	add    $0x10,%esp
801039b6:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801039b8:	83 ec 0c             	sub    $0xc,%esp
801039bb:	ff 75 f0             	pushl  -0x10(%ebp)
801039be:	e8 09 fe ff ff       	call   801037cc <v2p>
801039c3:	83 c4 10             	add    $0x10,%esp
801039c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801039c9:	8a 12                	mov    (%edx),%dl
801039cb:	0f b6 d2             	movzbl %dl,%edx
801039ce:	83 ec 08             	sub    $0x8,%esp
801039d1:	50                   	push   %eax
801039d2:	52                   	push   %edx
801039d3:	e8 1d f6 ff ff       	call   80102ff5 <lapicstartap>
801039d8:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039db:	90                   	nop
801039dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039df:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801039e5:	85 c0                	test   %eax,%eax
801039e7:	74 f3                	je     801039dc <startothers+0xbd>
801039e9:	eb 01                	jmp    801039ec <startothers+0xcd>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
801039eb:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801039ec:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801039f3:	a1 40 29 11 80       	mov    0x80112940,%eax
801039f8:	89 c2                	mov    %eax,%edx
801039fa:	89 d0                	mov    %edx,%eax
801039fc:	d1 e0                	shl    %eax
801039fe:	01 d0                	add    %edx,%eax
80103a00:	c1 e0 04             	shl    $0x4,%eax
80103a03:	29 d0                	sub    %edx,%eax
80103a05:	c1 e0 02             	shl    $0x2,%eax
80103a08:	05 60 23 11 80       	add    $0x80112360,%eax
80103a0d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a10:	0f 87 45 ff ff ff    	ja     8010395b <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103a16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a19:	c9                   	leave  
80103a1a:	c3                   	ret    
	...

80103a1c <p2v>:
80103a1c:	55                   	push   %ebp
80103a1d:	89 e5                	mov    %esp,%ebp
80103a1f:	8b 45 08             	mov    0x8(%ebp),%eax
80103a22:	2d 00 00 00 80       	sub    $0x80000000,%eax
80103a27:	c9                   	leave  
80103a28:	c3                   	ret    

80103a29 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103a29:	55                   	push   %ebp
80103a2a:	89 e5                	mov    %esp,%ebp
80103a2c:	53                   	push   %ebx
80103a2d:	83 ec 18             	sub    $0x18,%esp
80103a30:	8b 45 08             	mov    0x8(%ebp),%eax
80103a33:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103a3a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
80103a3e:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
80103a42:	ec                   	in     (%dx),%al
80103a43:	88 c3                	mov    %al,%bl
80103a45:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80103a48:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80103a4b:	83 c4 18             	add    $0x18,%esp
80103a4e:	5b                   	pop    %ebx
80103a4f:	c9                   	leave  
80103a50:	c3                   	ret    

80103a51 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a51:	55                   	push   %ebp
80103a52:	89 e5                	mov    %esp,%ebp
80103a54:	83 ec 08             	sub    $0x8,%esp
80103a57:	8b 45 08             	mov    0x8(%ebp),%eax
80103a5a:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a5d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103a61:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a64:	8a 45 f8             	mov    -0x8(%ebp),%al
80103a67:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a6a:	ee                   	out    %al,(%dx)
}
80103a6b:	c9                   	leave  
80103a6c:	c3                   	ret    

80103a6d <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103a6d:	55                   	push   %ebp
80103a6e:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103a70:	a1 44 b6 10 80       	mov    0x8010b644,%eax
80103a75:	89 c2                	mov    %eax,%edx
80103a77:	b8 60 23 11 80       	mov    $0x80112360,%eax
80103a7c:	89 d1                	mov    %edx,%ecx
80103a7e:	29 c1                	sub    %eax,%ecx
80103a80:	89 c8                	mov    %ecx,%eax
80103a82:	89 c2                	mov    %eax,%edx
80103a84:	c1 fa 02             	sar    $0x2,%edx
80103a87:	89 d0                	mov    %edx,%eax
80103a89:	c1 e0 03             	shl    $0x3,%eax
80103a8c:	01 d0                	add    %edx,%eax
80103a8e:	c1 e0 03             	shl    $0x3,%eax
80103a91:	01 d0                	add    %edx,%eax
80103a93:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80103a9a:	01 c8                	add    %ecx,%eax
80103a9c:	c1 e0 03             	shl    $0x3,%eax
80103a9f:	01 d0                	add    %edx,%eax
80103aa1:	c1 e0 03             	shl    $0x3,%eax
80103aa4:	29 d0                	sub    %edx,%eax
80103aa6:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80103aad:	01 c8                	add    %ecx,%eax
80103aaf:	c1 e0 02             	shl    $0x2,%eax
80103ab2:	01 d0                	add    %edx,%eax
80103ab4:	c1 e0 03             	shl    $0x3,%eax
80103ab7:	29 d0                	sub    %edx,%eax
80103ab9:	89 c1                	mov    %eax,%ecx
80103abb:	c1 e1 07             	shl    $0x7,%ecx
80103abe:	01 c8                	add    %ecx,%eax
80103ac0:	d1 e0                	shl    %eax
80103ac2:	01 d0                	add    %edx,%eax
}
80103ac4:	c9                   	leave  
80103ac5:	c3                   	ret    

80103ac6 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103ac6:	55                   	push   %ebp
80103ac7:	89 e5                	mov    %esp,%ebp
80103ac9:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103acc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103ad3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103ada:	eb 11                	jmp    80103aed <sum+0x27>
    sum += addr[i];
80103adc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103adf:	03 45 08             	add    0x8(%ebp),%eax
80103ae2:	8a 00                	mov    (%eax),%al
80103ae4:	0f b6 c0             	movzbl %al,%eax
80103ae7:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103aea:	ff 45 fc             	incl   -0x4(%ebp)
80103aed:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103af0:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103af3:	7c e7                	jl     80103adc <sum+0x16>
    sum += addr[i];
  return sum;
80103af5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103af8:	c9                   	leave  
80103af9:	c3                   	ret    

80103afa <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103afa:	55                   	push   %ebp
80103afb:	89 e5                	mov    %esp,%ebp
80103afd:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103b00:	ff 75 08             	pushl  0x8(%ebp)
80103b03:	e8 14 ff ff ff       	call   80103a1c <p2v>
80103b08:	83 c4 04             	add    $0x4,%esp
80103b0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b11:	03 45 f0             	add    -0x10(%ebp),%eax
80103b14:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b1d:	eb 36                	jmp    80103b55 <mpsearch1+0x5b>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103b1f:	83 ec 04             	sub    $0x4,%esp
80103b22:	6a 04                	push   $0x4
80103b24:	68 4c 87 10 80       	push   $0x8010874c
80103b29:	ff 75 f4             	pushl  -0xc(%ebp)
80103b2c:	e8 54 17 00 00       	call   80105285 <memcmp>
80103b31:	83 c4 10             	add    $0x10,%esp
80103b34:	85 c0                	test   %eax,%eax
80103b36:	75 19                	jne    80103b51 <mpsearch1+0x57>
80103b38:	83 ec 08             	sub    $0x8,%esp
80103b3b:	6a 10                	push   $0x10
80103b3d:	ff 75 f4             	pushl  -0xc(%ebp)
80103b40:	e8 81 ff ff ff       	call   80103ac6 <sum>
80103b45:	83 c4 10             	add    $0x10,%esp
80103b48:	84 c0                	test   %al,%al
80103b4a:	75 05                	jne    80103b51 <mpsearch1+0x57>
      return (struct mp*)p;
80103b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b4f:	eb 11                	jmp    80103b62 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103b51:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b58:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103b5b:	72 c2                	jb     80103b1f <mpsearch1+0x25>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103b5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103b62:	c9                   	leave  
80103b63:	c3                   	ret    

80103b64 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103b64:	55                   	push   %ebp
80103b65:	89 e5                	mov    %esp,%ebp
80103b67:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103b6a:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b74:	83 c0 0f             	add    $0xf,%eax
80103b77:	8a 00                	mov    (%eax),%al
80103b79:	0f b6 c0             	movzbl %al,%eax
80103b7c:	89 c2                	mov    %eax,%edx
80103b7e:	c1 e2 08             	shl    $0x8,%edx
80103b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b84:	83 c0 0e             	add    $0xe,%eax
80103b87:	8a 00                	mov    (%eax),%al
80103b89:	0f b6 c0             	movzbl %al,%eax
80103b8c:	09 d0                	or     %edx,%eax
80103b8e:	c1 e0 04             	shl    $0x4,%eax
80103b91:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b98:	74 21                	je     80103bbb <mpsearch+0x57>
    if((mp = mpsearch1(p, 1024)))
80103b9a:	83 ec 08             	sub    $0x8,%esp
80103b9d:	68 00 04 00 00       	push   $0x400
80103ba2:	ff 75 f0             	pushl  -0x10(%ebp)
80103ba5:	e8 50 ff ff ff       	call   80103afa <mpsearch1>
80103baa:	83 c4 10             	add    $0x10,%esp
80103bad:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103bb0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103bb4:	74 4f                	je     80103c05 <mpsearch+0xa1>
      return mp;
80103bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103bb9:	eb 5f                	jmp    80103c1a <mpsearch+0xb6>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bbe:	83 c0 14             	add    $0x14,%eax
80103bc1:	8a 00                	mov    (%eax),%al
80103bc3:	0f b6 c0             	movzbl %al,%eax
80103bc6:	89 c2                	mov    %eax,%edx
80103bc8:	c1 e2 08             	shl    $0x8,%edx
80103bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bce:	83 c0 13             	add    $0x13,%eax
80103bd1:	8a 00                	mov    (%eax),%al
80103bd3:	0f b6 c0             	movzbl %al,%eax
80103bd6:	09 d0                	or     %edx,%eax
80103bd8:	c1 e0 0a             	shl    $0xa,%eax
80103bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103be1:	2d 00 04 00 00       	sub    $0x400,%eax
80103be6:	83 ec 08             	sub    $0x8,%esp
80103be9:	68 00 04 00 00       	push   $0x400
80103bee:	50                   	push   %eax
80103bef:	e8 06 ff ff ff       	call   80103afa <mpsearch1>
80103bf4:	83 c4 10             	add    $0x10,%esp
80103bf7:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103bfa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103bfe:	74 05                	je     80103c05 <mpsearch+0xa1>
      return mp;
80103c00:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c03:	eb 15                	jmp    80103c1a <mpsearch+0xb6>
  }
  return mpsearch1(0xF0000, 0x10000);
80103c05:	83 ec 08             	sub    $0x8,%esp
80103c08:	68 00 00 01 00       	push   $0x10000
80103c0d:	68 00 00 0f 00       	push   $0xf0000
80103c12:	e8 e3 fe ff ff       	call   80103afa <mpsearch1>
80103c17:	83 c4 10             	add    $0x10,%esp
}
80103c1a:	c9                   	leave  
80103c1b:	c3                   	ret    

80103c1c <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103c1c:	55                   	push   %ebp
80103c1d:	89 e5                	mov    %esp,%ebp
80103c1f:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c22:	e8 3d ff ff ff       	call   80103b64 <mpsearch>
80103c27:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c2e:	74 0a                	je     80103c3a <mpconfig+0x1e>
80103c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c33:	8b 40 04             	mov    0x4(%eax),%eax
80103c36:	85 c0                	test   %eax,%eax
80103c38:	75 07                	jne    80103c41 <mpconfig+0x25>
    return 0;
80103c3a:	b8 00 00 00 00       	mov    $0x0,%eax
80103c3f:	eb 7f                	jmp    80103cc0 <mpconfig+0xa4>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c44:	8b 40 04             	mov    0x4(%eax),%eax
80103c47:	83 ec 0c             	sub    $0xc,%esp
80103c4a:	50                   	push   %eax
80103c4b:	e8 cc fd ff ff       	call   80103a1c <p2v>
80103c50:	83 c4 10             	add    $0x10,%esp
80103c53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103c56:	83 ec 04             	sub    $0x4,%esp
80103c59:	6a 04                	push   $0x4
80103c5b:	68 51 87 10 80       	push   $0x80108751
80103c60:	ff 75 f0             	pushl  -0x10(%ebp)
80103c63:	e8 1d 16 00 00       	call   80105285 <memcmp>
80103c68:	83 c4 10             	add    $0x10,%esp
80103c6b:	85 c0                	test   %eax,%eax
80103c6d:	74 07                	je     80103c76 <mpconfig+0x5a>
    return 0;
80103c6f:	b8 00 00 00 00       	mov    $0x0,%eax
80103c74:	eb 4a                	jmp    80103cc0 <mpconfig+0xa4>
  if(conf->version != 1 && conf->version != 4)
80103c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c79:	8a 40 06             	mov    0x6(%eax),%al
80103c7c:	3c 01                	cmp    $0x1,%al
80103c7e:	74 11                	je     80103c91 <mpconfig+0x75>
80103c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c83:	8a 40 06             	mov    0x6(%eax),%al
80103c86:	3c 04                	cmp    $0x4,%al
80103c88:	74 07                	je     80103c91 <mpconfig+0x75>
    return 0;
80103c8a:	b8 00 00 00 00       	mov    $0x0,%eax
80103c8f:	eb 2f                	jmp    80103cc0 <mpconfig+0xa4>
  if(sum((uchar*)conf, conf->length) != 0)
80103c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c94:	8b 40 04             	mov    0x4(%eax),%eax
80103c97:	0f b7 d0             	movzwl %ax,%edx
80103c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c9d:	83 ec 08             	sub    $0x8,%esp
80103ca0:	52                   	push   %edx
80103ca1:	50                   	push   %eax
80103ca2:	e8 1f fe ff ff       	call   80103ac6 <sum>
80103ca7:	83 c4 10             	add    $0x10,%esp
80103caa:	84 c0                	test   %al,%al
80103cac:	74 07                	je     80103cb5 <mpconfig+0x99>
    return 0;
80103cae:	b8 00 00 00 00       	mov    $0x0,%eax
80103cb3:	eb 0b                	jmp    80103cc0 <mpconfig+0xa4>
  *pmp = mp;
80103cb5:	8b 45 08             	mov    0x8(%ebp),%eax
80103cb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cbb:	89 10                	mov    %edx,(%eax)
  return conf;
80103cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103cc0:	c9                   	leave  
80103cc1:	c3                   	ret    

80103cc2 <mpinit>:

void
mpinit(void)
{
80103cc2:	55                   	push   %ebp
80103cc3:	89 e5                	mov    %esp,%ebp
80103cc5:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103cc8:	c7 05 44 b6 10 80 60 	movl   $0x80112360,0x8010b644
80103ccf:	23 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103cd2:	83 ec 0c             	sub    $0xc,%esp
80103cd5:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103cd8:	50                   	push   %eax
80103cd9:	e8 3e ff ff ff       	call   80103c1c <mpconfig>
80103cde:	83 c4 10             	add    $0x10,%esp
80103ce1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103ce4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103ce8:	0f 84 a1 01 00 00    	je     80103e8f <mpinit+0x1cd>
    return;
  ismp = 1;
80103cee:	c7 05 44 23 11 80 01 	movl   $0x1,0x80112344
80103cf5:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cfb:	8b 40 24             	mov    0x24(%eax),%eax
80103cfe:	a3 5c 22 11 80       	mov    %eax,0x8011225c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d06:	83 c0 2c             	add    $0x2c,%eax
80103d09:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d12:	8b 40 04             	mov    0x4(%eax),%eax
80103d15:	0f b7 c0             	movzwl %ax,%eax
80103d18:	8d 04 02             	lea    (%edx,%eax,1),%eax
80103d1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d1e:	e9 fe 00 00 00       	jmp    80103e21 <mpinit+0x15f>
    switch(*p){
80103d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d26:	8a 00                	mov    (%eax),%al
80103d28:	0f b6 c0             	movzbl %al,%eax
80103d2b:	83 f8 04             	cmp    $0x4,%eax
80103d2e:	0f 87 ca 00 00 00    	ja     80103dfe <mpinit+0x13c>
80103d34:	8b 04 85 94 87 10 80 	mov    -0x7fef786c(,%eax,4),%eax
80103d3b:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d40:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103d43:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d46:	8a 40 01             	mov    0x1(%eax),%al
80103d49:	0f b6 d0             	movzbl %al,%edx
80103d4c:	a1 40 29 11 80       	mov    0x80112940,%eax
80103d51:	39 c2                	cmp    %eax,%edx
80103d53:	74 2a                	je     80103d7f <mpinit+0xbd>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103d55:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d58:	8a 40 01             	mov    0x1(%eax),%al
80103d5b:	0f b6 d0             	movzbl %al,%edx
80103d5e:	a1 40 29 11 80       	mov    0x80112940,%eax
80103d63:	83 ec 04             	sub    $0x4,%esp
80103d66:	52                   	push   %edx
80103d67:	50                   	push   %eax
80103d68:	68 56 87 10 80       	push   $0x80108756
80103d6d:	e8 51 c6 ff ff       	call   801003c3 <cprintf>
80103d72:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103d75:	c7 05 44 23 11 80 00 	movl   $0x0,0x80112344
80103d7c:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103d7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d82:	8a 40 03             	mov    0x3(%eax),%al
80103d85:	0f b6 c0             	movzbl %al,%eax
80103d88:	83 e0 02             	and    $0x2,%eax
80103d8b:	85 c0                	test   %eax,%eax
80103d8d:	74 1f                	je     80103dae <mpinit+0xec>
        bcpu = &cpus[ncpu];
80103d8f:	a1 40 29 11 80       	mov    0x80112940,%eax
80103d94:	89 c2                	mov    %eax,%edx
80103d96:	89 d0                	mov    %edx,%eax
80103d98:	d1 e0                	shl    %eax
80103d9a:	01 d0                	add    %edx,%eax
80103d9c:	c1 e0 04             	shl    $0x4,%eax
80103d9f:	29 d0                	sub    %edx,%eax
80103da1:	c1 e0 02             	shl    $0x2,%eax
80103da4:	05 60 23 11 80       	add    $0x80112360,%eax
80103da9:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
80103dae:	8b 15 40 29 11 80    	mov    0x80112940,%edx
80103db4:	a1 40 29 11 80       	mov    0x80112940,%eax
80103db9:	88 c1                	mov    %al,%cl
80103dbb:	89 d0                	mov    %edx,%eax
80103dbd:	d1 e0                	shl    %eax
80103dbf:	01 d0                	add    %edx,%eax
80103dc1:	c1 e0 04             	shl    $0x4,%eax
80103dc4:	29 d0                	sub    %edx,%eax
80103dc6:	c1 e0 02             	shl    $0x2,%eax
80103dc9:	05 60 23 11 80       	add    $0x80112360,%eax
80103dce:	88 08                	mov    %cl,(%eax)
      ncpu++;
80103dd0:	a1 40 29 11 80       	mov    0x80112940,%eax
80103dd5:	40                   	inc    %eax
80103dd6:	a3 40 29 11 80       	mov    %eax,0x80112940
      p += sizeof(struct mpproc);
80103ddb:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103ddf:	eb 40                	jmp    80103e21 <mpinit+0x15f>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103de4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103de7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103dea:	8a 40 01             	mov    0x1(%eax),%al
80103ded:	a2 40 23 11 80       	mov    %al,0x80112340
      p += sizeof(struct mpioapic);
80103df2:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103df6:	eb 29                	jmp    80103e21 <mpinit+0x15f>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103df8:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103dfc:	eb 23                	jmp    80103e21 <mpinit+0x15f>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e01:	8a 00                	mov    (%eax),%al
80103e03:	0f b6 c0             	movzbl %al,%eax
80103e06:	83 ec 08             	sub    $0x8,%esp
80103e09:	50                   	push   %eax
80103e0a:	68 74 87 10 80       	push   $0x80108774
80103e0f:	e8 af c5 ff ff       	call   801003c3 <cprintf>
80103e14:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103e17:	c7 05 44 23 11 80 00 	movl   $0x0,0x80112344
80103e1e:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e24:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103e27:	0f 82 f6 fe ff ff    	jb     80103d23 <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103e2d:	a1 44 23 11 80       	mov    0x80112344,%eax
80103e32:	85 c0                	test   %eax,%eax
80103e34:	75 1d                	jne    80103e53 <mpinit+0x191>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103e36:	c7 05 40 29 11 80 01 	movl   $0x1,0x80112940
80103e3d:	00 00 00 
    lapic = 0;
80103e40:	c7 05 5c 22 11 80 00 	movl   $0x0,0x8011225c
80103e47:	00 00 00 
    ioapicid = 0;
80103e4a:	c6 05 40 23 11 80 00 	movb   $0x0,0x80112340
    return;
80103e51:	eb 3d                	jmp    80103e90 <mpinit+0x1ce>
  }

  if(mp->imcrp){
80103e53:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e56:	8a 40 0c             	mov    0xc(%eax),%al
80103e59:	84 c0                	test   %al,%al
80103e5b:	74 33                	je     80103e90 <mpinit+0x1ce>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103e5d:	83 ec 08             	sub    $0x8,%esp
80103e60:	6a 70                	push   $0x70
80103e62:	6a 22                	push   $0x22
80103e64:	e8 e8 fb ff ff       	call   80103a51 <outb>
80103e69:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103e6c:	83 ec 0c             	sub    $0xc,%esp
80103e6f:	6a 23                	push   $0x23
80103e71:	e8 b3 fb ff ff       	call   80103a29 <inb>
80103e76:	83 c4 10             	add    $0x10,%esp
80103e79:	83 c8 01             	or     $0x1,%eax
80103e7c:	0f b6 c0             	movzbl %al,%eax
80103e7f:	83 ec 08             	sub    $0x8,%esp
80103e82:	50                   	push   %eax
80103e83:	6a 23                	push   $0x23
80103e85:	e8 c7 fb ff ff       	call   80103a51 <outb>
80103e8a:	83 c4 10             	add    $0x10,%esp
80103e8d:	eb 01                	jmp    80103e90 <mpinit+0x1ce>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103e8f:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103e90:	c9                   	leave  
80103e91:	c3                   	ret    
	...

80103e94 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103e94:	55                   	push   %ebp
80103e95:	89 e5                	mov    %esp,%ebp
80103e97:	83 ec 08             	sub    $0x8,%esp
80103e9a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e9d:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ea0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103ea4:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ea7:	8a 45 f8             	mov    -0x8(%ebp),%al
80103eaa:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103ead:	ee                   	out    %al,(%dx)
}
80103eae:	c9                   	leave  
80103eaf:	c3                   	ret    

80103eb0 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	83 ec 04             	sub    $0x4,%esp
80103eb6:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103ec0:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103ec6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103ec9:	0f b6 c0             	movzbl %al,%eax
80103ecc:	50                   	push   %eax
80103ecd:	6a 21                	push   $0x21
80103ecf:	e8 c0 ff ff ff       	call   80103e94 <outb>
80103ed4:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103eda:	66 c1 e8 08          	shr    $0x8,%ax
80103ede:	0f b6 c0             	movzbl %al,%eax
80103ee1:	50                   	push   %eax
80103ee2:	68 a1 00 00 00       	push   $0xa1
80103ee7:	e8 a8 ff ff ff       	call   80103e94 <outb>
80103eec:	83 c4 08             	add    $0x8,%esp
}
80103eef:	c9                   	leave  
80103ef0:	c3                   	ret    

80103ef1 <picenable>:

void
picenable(int irq)
{
80103ef1:	55                   	push   %ebp
80103ef2:	89 e5                	mov    %esp,%ebp
80103ef4:	53                   	push   %ebx
  picsetmask(irqmask & ~(1<<irq));
80103ef5:	8b 45 08             	mov    0x8(%ebp),%eax
80103ef8:	ba 01 00 00 00       	mov    $0x1,%edx
80103efd:	89 d3                	mov    %edx,%ebx
80103eff:	88 c1                	mov    %al,%cl
80103f01:	d3 e3                	shl    %cl,%ebx
80103f03:	89 d8                	mov    %ebx,%eax
80103f05:	89 c2                	mov    %eax,%edx
80103f07:	f7 d2                	not    %edx
80103f09:	66 a1 00 b0 10 80    	mov    0x8010b000,%ax
80103f0f:	21 d0                	and    %edx,%eax
80103f11:	0f b7 c0             	movzwl %ax,%eax
80103f14:	50                   	push   %eax
80103f15:	e8 96 ff ff ff       	call   80103eb0 <picsetmask>
80103f1a:	83 c4 04             	add    $0x4,%esp
}
80103f1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f20:	c9                   	leave  
80103f21:	c3                   	ret    

80103f22 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103f22:	55                   	push   %ebp
80103f23:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103f25:	68 ff 00 00 00       	push   $0xff
80103f2a:	6a 21                	push   $0x21
80103f2c:	e8 63 ff ff ff       	call   80103e94 <outb>
80103f31:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103f34:	68 ff 00 00 00       	push   $0xff
80103f39:	68 a1 00 00 00       	push   $0xa1
80103f3e:	e8 51 ff ff ff       	call   80103e94 <outb>
80103f43:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103f46:	6a 11                	push   $0x11
80103f48:	6a 20                	push   $0x20
80103f4a:	e8 45 ff ff ff       	call   80103e94 <outb>
80103f4f:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103f52:	6a 20                	push   $0x20
80103f54:	6a 21                	push   $0x21
80103f56:	e8 39 ff ff ff       	call   80103e94 <outb>
80103f5b:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103f5e:	6a 04                	push   $0x4
80103f60:	6a 21                	push   $0x21
80103f62:	e8 2d ff ff ff       	call   80103e94 <outb>
80103f67:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103f6a:	6a 03                	push   $0x3
80103f6c:	6a 21                	push   $0x21
80103f6e:	e8 21 ff ff ff       	call   80103e94 <outb>
80103f73:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103f76:	6a 11                	push   $0x11
80103f78:	68 a0 00 00 00       	push   $0xa0
80103f7d:	e8 12 ff ff ff       	call   80103e94 <outb>
80103f82:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103f85:	6a 28                	push   $0x28
80103f87:	68 a1 00 00 00       	push   $0xa1
80103f8c:	e8 03 ff ff ff       	call   80103e94 <outb>
80103f91:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103f94:	6a 02                	push   $0x2
80103f96:	68 a1 00 00 00       	push   $0xa1
80103f9b:	e8 f4 fe ff ff       	call   80103e94 <outb>
80103fa0:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103fa3:	6a 03                	push   $0x3
80103fa5:	68 a1 00 00 00       	push   $0xa1
80103faa:	e8 e5 fe ff ff       	call   80103e94 <outb>
80103faf:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103fb2:	6a 68                	push   $0x68
80103fb4:	6a 20                	push   $0x20
80103fb6:	e8 d9 fe ff ff       	call   80103e94 <outb>
80103fbb:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103fbe:	6a 0a                	push   $0xa
80103fc0:	6a 20                	push   $0x20
80103fc2:	e8 cd fe ff ff       	call   80103e94 <outb>
80103fc7:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80103fca:	6a 68                	push   $0x68
80103fcc:	68 a0 00 00 00       	push   $0xa0
80103fd1:	e8 be fe ff ff       	call   80103e94 <outb>
80103fd6:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80103fd9:	6a 0a                	push   $0xa
80103fdb:	68 a0 00 00 00       	push   $0xa0
80103fe0:	e8 af fe ff ff       	call   80103e94 <outb>
80103fe5:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80103fe8:	66 a1 00 b0 10 80    	mov    0x8010b000,%ax
80103fee:	66 83 f8 ff          	cmp    $0xffff,%ax
80103ff2:	74 12                	je     80104006 <picinit+0xe4>
    picsetmask(irqmask);
80103ff4:	66 a1 00 b0 10 80    	mov    0x8010b000,%ax
80103ffa:	0f b7 c0             	movzwl %ax,%eax
80103ffd:	50                   	push   %eax
80103ffe:	e8 ad fe ff ff       	call   80103eb0 <picsetmask>
80104003:	83 c4 04             	add    $0x4,%esp
}
80104006:	c9                   	leave  
80104007:	c3                   	ret    

80104008 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104008:	55                   	push   %ebp
80104009:	89 e5                	mov    %esp,%ebp
8010400b:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
8010400e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104015:	8b 45 0c             	mov    0xc(%ebp),%eax
80104018:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010401e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104021:	8b 10                	mov    (%eax),%edx
80104023:	8b 45 08             	mov    0x8(%ebp),%eax
80104026:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104028:	e8 28 cf ff ff       	call   80100f55 <filealloc>
8010402d:	8b 55 08             	mov    0x8(%ebp),%edx
80104030:	89 02                	mov    %eax,(%edx)
80104032:	8b 45 08             	mov    0x8(%ebp),%eax
80104035:	8b 00                	mov    (%eax),%eax
80104037:	85 c0                	test   %eax,%eax
80104039:	0f 84 c9 00 00 00    	je     80104108 <pipealloc+0x100>
8010403f:	e8 11 cf ff ff       	call   80100f55 <filealloc>
80104044:	8b 55 0c             	mov    0xc(%ebp),%edx
80104047:	89 02                	mov    %eax,(%edx)
80104049:	8b 45 0c             	mov    0xc(%ebp),%eax
8010404c:	8b 00                	mov    (%eax),%eax
8010404e:	85 c0                	test   %eax,%eax
80104050:	0f 84 b2 00 00 00    	je     80104108 <pipealloc+0x100>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104056:	e8 a4 eb ff ff       	call   80102bff <kalloc>
8010405b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010405e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104062:	0f 84 9f 00 00 00    	je     80104107 <pipealloc+0xff>
    goto bad;
  p->readopen = 1;
80104068:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010406b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104072:	00 00 00 
  p->writeopen = 1;
80104075:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104078:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010407f:	00 00 00 
  p->nwrite = 0;
80104082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104085:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010408c:	00 00 00 
  p->nread = 0;
8010408f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104092:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104099:	00 00 00 
  initlock(&p->lock, "pipe");
8010409c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010409f:	83 ec 08             	sub    $0x8,%esp
801040a2:	68 a8 87 10 80       	push   $0x801087a8
801040a7:	50                   	push   %eax
801040a8:	e8 f5 0e 00 00       	call   80104fa2 <initlock>
801040ad:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801040b0:	8b 45 08             	mov    0x8(%ebp),%eax
801040b3:	8b 00                	mov    (%eax),%eax
801040b5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801040bb:	8b 45 08             	mov    0x8(%ebp),%eax
801040be:	8b 00                	mov    (%eax),%eax
801040c0:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801040c4:	8b 45 08             	mov    0x8(%ebp),%eax
801040c7:	8b 00                	mov    (%eax),%eax
801040c9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801040cd:	8b 45 08             	mov    0x8(%ebp),%eax
801040d0:	8b 00                	mov    (%eax),%eax
801040d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040d5:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801040d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801040db:	8b 00                	mov    (%eax),%eax
801040dd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801040e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801040e6:	8b 00                	mov    (%eax),%eax
801040e8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801040ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801040ef:	8b 00                	mov    (%eax),%eax
801040f1:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801040f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801040f8:	8b 00                	mov    (%eax),%eax
801040fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040fd:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104100:	b8 00 00 00 00       	mov    $0x0,%eax
80104105:	eb 4f                	jmp    80104156 <pipealloc+0x14e>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80104107:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80104108:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010410c:	74 0f                	je     8010411d <pipealloc+0x115>
    kfree((char*)p);
8010410e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104111:	83 ec 0c             	sub    $0xc,%esp
80104114:	50                   	push   %eax
80104115:	e8 49 ea ff ff       	call   80102b63 <kfree>
8010411a:	83 c4 10             	add    $0x10,%esp
  if(*f0)
8010411d:	8b 45 08             	mov    0x8(%ebp),%eax
80104120:	8b 00                	mov    (%eax),%eax
80104122:	85 c0                	test   %eax,%eax
80104124:	74 11                	je     80104137 <pipealloc+0x12f>
    fileclose(*f0);
80104126:	8b 45 08             	mov    0x8(%ebp),%eax
80104129:	8b 00                	mov    (%eax),%eax
8010412b:	83 ec 0c             	sub    $0xc,%esp
8010412e:	50                   	push   %eax
8010412f:	e8 df ce ff ff       	call   80101013 <fileclose>
80104134:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104137:	8b 45 0c             	mov    0xc(%ebp),%eax
8010413a:	8b 00                	mov    (%eax),%eax
8010413c:	85 c0                	test   %eax,%eax
8010413e:	74 11                	je     80104151 <pipealloc+0x149>
    fileclose(*f1);
80104140:	8b 45 0c             	mov    0xc(%ebp),%eax
80104143:	8b 00                	mov    (%eax),%eax
80104145:	83 ec 0c             	sub    $0xc,%esp
80104148:	50                   	push   %eax
80104149:	e8 c5 ce ff ff       	call   80101013 <fileclose>
8010414e:	83 c4 10             	add    $0x10,%esp
  return -1;
80104151:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104156:	c9                   	leave  
80104157:	c3                   	ret    

80104158 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104158:	55                   	push   %ebp
80104159:	89 e5                	mov    %esp,%ebp
8010415b:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
8010415e:	8b 45 08             	mov    0x8(%ebp),%eax
80104161:	83 ec 0c             	sub    $0xc,%esp
80104164:	50                   	push   %eax
80104165:	e8 59 0e 00 00       	call   80104fc3 <acquire>
8010416a:	83 c4 10             	add    $0x10,%esp
  if(writable){
8010416d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104171:	74 23                	je     80104196 <pipeclose+0x3e>
    p->writeopen = 0;
80104173:	8b 45 08             	mov    0x8(%ebp),%eax
80104176:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
8010417d:	00 00 00 
    wakeup(&p->nread);
80104180:	8b 45 08             	mov    0x8(%ebp),%eax
80104183:	05 34 02 00 00       	add    $0x234,%eax
80104188:	83 ec 0c             	sub    $0xc,%esp
8010418b:	50                   	push   %eax
8010418c:	e8 18 0c 00 00       	call   80104da9 <wakeup>
80104191:	83 c4 10             	add    $0x10,%esp
80104194:	eb 21                	jmp    801041b7 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80104196:	8b 45 08             	mov    0x8(%ebp),%eax
80104199:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801041a0:	00 00 00 
    wakeup(&p->nwrite);
801041a3:	8b 45 08             	mov    0x8(%ebp),%eax
801041a6:	05 38 02 00 00       	add    $0x238,%eax
801041ab:	83 ec 0c             	sub    $0xc,%esp
801041ae:	50                   	push   %eax
801041af:	e8 f5 0b 00 00       	call   80104da9 <wakeup>
801041b4:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
801041b7:	8b 45 08             	mov    0x8(%ebp),%eax
801041ba:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041c0:	85 c0                	test   %eax,%eax
801041c2:	75 2d                	jne    801041f1 <pipeclose+0x99>
801041c4:	8b 45 08             	mov    0x8(%ebp),%eax
801041c7:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801041cd:	85 c0                	test   %eax,%eax
801041cf:	75 20                	jne    801041f1 <pipeclose+0x99>
    release(&p->lock);
801041d1:	8b 45 08             	mov    0x8(%ebp),%eax
801041d4:	83 ec 0c             	sub    $0xc,%esp
801041d7:	50                   	push   %eax
801041d8:	e8 4c 0e 00 00       	call   80105029 <release>
801041dd:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801041e0:	8b 45 08             	mov    0x8(%ebp),%eax
801041e3:	83 ec 0c             	sub    $0xc,%esp
801041e6:	50                   	push   %eax
801041e7:	e8 77 e9 ff ff       	call   80102b63 <kfree>
801041ec:	83 c4 10             	add    $0x10,%esp
801041ef:	eb 0f                	jmp    80104200 <pipeclose+0xa8>
  } else
    release(&p->lock);
801041f1:	8b 45 08             	mov    0x8(%ebp),%eax
801041f4:	83 ec 0c             	sub    $0xc,%esp
801041f7:	50                   	push   %eax
801041f8:	e8 2c 0e 00 00       	call   80105029 <release>
801041fd:	83 c4 10             	add    $0x10,%esp
}
80104200:	c9                   	leave  
80104201:	c3                   	ret    

80104202 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104202:	55                   	push   %ebp
80104203:	89 e5                	mov    %esp,%ebp
80104205:	53                   	push   %ebx
80104206:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80104209:	8b 45 08             	mov    0x8(%ebp),%eax
8010420c:	83 ec 0c             	sub    $0xc,%esp
8010420f:	50                   	push   %eax
80104210:	e8 ae 0d 00 00       	call   80104fc3 <acquire>
80104215:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80104218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010421f:	e9 ad 00 00 00       	jmp    801042d1 <pipewrite+0xcf>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80104224:	8b 45 08             	mov    0x8(%ebp),%eax
80104227:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010422d:	85 c0                	test   %eax,%eax
8010422f:	74 0d                	je     8010423e <pipewrite+0x3c>
80104231:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104237:	8b 40 24             	mov    0x24(%eax),%eax
8010423a:	85 c0                	test   %eax,%eax
8010423c:	74 19                	je     80104257 <pipewrite+0x55>
        release(&p->lock);
8010423e:	8b 45 08             	mov    0x8(%ebp),%eax
80104241:	83 ec 0c             	sub    $0xc,%esp
80104244:	50                   	push   %eax
80104245:	e8 df 0d 00 00       	call   80105029 <release>
8010424a:	83 c4 10             	add    $0x10,%esp
        return -1;
8010424d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104252:	e9 a8 00 00 00       	jmp    801042ff <pipewrite+0xfd>
      }
      wakeup(&p->nread);
80104257:	8b 45 08             	mov    0x8(%ebp),%eax
8010425a:	05 34 02 00 00       	add    $0x234,%eax
8010425f:	83 ec 0c             	sub    $0xc,%esp
80104262:	50                   	push   %eax
80104263:	e8 41 0b 00 00       	call   80104da9 <wakeup>
80104268:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010426b:	8b 45 08             	mov    0x8(%ebp),%eax
8010426e:	8b 55 08             	mov    0x8(%ebp),%edx
80104271:	81 c2 38 02 00 00    	add    $0x238,%edx
80104277:	83 ec 08             	sub    $0x8,%esp
8010427a:	50                   	push   %eax
8010427b:	52                   	push   %edx
8010427c:	e8 3e 0a 00 00       	call   80104cbf <sleep>
80104281:	83 c4 10             	add    $0x10,%esp
80104284:	eb 01                	jmp    80104287 <pipewrite+0x85>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104286:	90                   	nop
80104287:	8b 45 08             	mov    0x8(%ebp),%eax
8010428a:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104290:	8b 45 08             	mov    0x8(%ebp),%eax
80104293:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104299:	05 00 02 00 00       	add    $0x200,%eax
8010429e:	39 c2                	cmp    %eax,%edx
801042a0:	74 82                	je     80104224 <pipewrite+0x22>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801042a2:	8b 45 08             	mov    0x8(%ebp),%eax
801042a5:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801042ab:	89 c3                	mov    %eax,%ebx
801042ad:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801042b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042b6:	03 55 0c             	add    0xc(%ebp),%edx
801042b9:	8a 0a                	mov    (%edx),%cl
801042bb:	8b 55 08             	mov    0x8(%ebp),%edx
801042be:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
801042c2:	8d 50 01             	lea    0x1(%eax),%edx
801042c5:	8b 45 08             	mov    0x8(%ebp),%eax
801042c8:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801042ce:	ff 45 f4             	incl   -0xc(%ebp)
801042d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042d4:	3b 45 10             	cmp    0x10(%ebp),%eax
801042d7:	7c ad                	jl     80104286 <pipewrite+0x84>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801042d9:	8b 45 08             	mov    0x8(%ebp),%eax
801042dc:	05 34 02 00 00       	add    $0x234,%eax
801042e1:	83 ec 0c             	sub    $0xc,%esp
801042e4:	50                   	push   %eax
801042e5:	e8 bf 0a 00 00       	call   80104da9 <wakeup>
801042ea:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801042ed:	8b 45 08             	mov    0x8(%ebp),%eax
801042f0:	83 ec 0c             	sub    $0xc,%esp
801042f3:	50                   	push   %eax
801042f4:	e8 30 0d 00 00       	call   80105029 <release>
801042f9:	83 c4 10             	add    $0x10,%esp
  return n;
801042fc:	8b 45 10             	mov    0x10(%ebp),%eax
}
801042ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104302:	c9                   	leave  
80104303:	c3                   	ret    

80104304 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104304:	55                   	push   %ebp
80104305:	89 e5                	mov    %esp,%ebp
80104307:	53                   	push   %ebx
80104308:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
8010430b:	8b 45 08             	mov    0x8(%ebp),%eax
8010430e:	83 ec 0c             	sub    $0xc,%esp
80104311:	50                   	push   %eax
80104312:	e8 ac 0c 00 00       	call   80104fc3 <acquire>
80104317:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010431a:	eb 3f                	jmp    8010435b <piperead+0x57>
    if(proc->killed){
8010431c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104322:	8b 40 24             	mov    0x24(%eax),%eax
80104325:	85 c0                	test   %eax,%eax
80104327:	74 19                	je     80104342 <piperead+0x3e>
      release(&p->lock);
80104329:	8b 45 08             	mov    0x8(%ebp),%eax
8010432c:	83 ec 0c             	sub    $0xc,%esp
8010432f:	50                   	push   %eax
80104330:	e8 f4 0c 00 00       	call   80105029 <release>
80104335:	83 c4 10             	add    $0x10,%esp
      return -1;
80104338:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010433d:	e9 bd 00 00 00       	jmp    801043ff <piperead+0xfb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104342:	8b 45 08             	mov    0x8(%ebp),%eax
80104345:	8b 55 08             	mov    0x8(%ebp),%edx
80104348:	81 c2 34 02 00 00    	add    $0x234,%edx
8010434e:	83 ec 08             	sub    $0x8,%esp
80104351:	50                   	push   %eax
80104352:	52                   	push   %edx
80104353:	e8 67 09 00 00       	call   80104cbf <sleep>
80104358:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010435b:	8b 45 08             	mov    0x8(%ebp),%eax
8010435e:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104364:	8b 45 08             	mov    0x8(%ebp),%eax
80104367:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010436d:	39 c2                	cmp    %eax,%edx
8010436f:	75 0d                	jne    8010437e <piperead+0x7a>
80104371:	8b 45 08             	mov    0x8(%ebp),%eax
80104374:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010437a:	85 c0                	test   %eax,%eax
8010437c:	75 9e                	jne    8010431c <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010437e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104385:	eb 47                	jmp    801043ce <piperead+0xca>
    if(p->nread == p->nwrite)
80104387:	8b 45 08             	mov    0x8(%ebp),%eax
8010438a:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104390:	8b 45 08             	mov    0x8(%ebp),%eax
80104393:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104399:	39 c2                	cmp    %eax,%edx
8010439b:	74 3b                	je     801043d8 <piperead+0xd4>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010439d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043a0:	89 c2                	mov    %eax,%edx
801043a2:	03 55 0c             	add    0xc(%ebp),%edx
801043a5:	8b 45 08             	mov    0x8(%ebp),%eax
801043a8:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801043ae:	89 c3                	mov    %eax,%ebx
801043b0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801043b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801043b9:	8a 4c 19 34          	mov    0x34(%ecx,%ebx,1),%cl
801043bd:	88 0a                	mov    %cl,(%edx)
801043bf:	8d 50 01             	lea    0x1(%eax),%edx
801043c2:	8b 45 08             	mov    0x8(%ebp),%eax
801043c5:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801043cb:	ff 45 f4             	incl   -0xc(%ebp)
801043ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043d1:	3b 45 10             	cmp    0x10(%ebp),%eax
801043d4:	7c b1                	jl     80104387 <piperead+0x83>
801043d6:	eb 01                	jmp    801043d9 <piperead+0xd5>
    if(p->nread == p->nwrite)
      break;
801043d8:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801043d9:	8b 45 08             	mov    0x8(%ebp),%eax
801043dc:	05 38 02 00 00       	add    $0x238,%eax
801043e1:	83 ec 0c             	sub    $0xc,%esp
801043e4:	50                   	push   %eax
801043e5:	e8 bf 09 00 00       	call   80104da9 <wakeup>
801043ea:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043ed:	8b 45 08             	mov    0x8(%ebp),%eax
801043f0:	83 ec 0c             	sub    $0xc,%esp
801043f3:	50                   	push   %eax
801043f4:	e8 30 0c 00 00       	call   80105029 <release>
801043f9:	83 c4 10             	add    $0x10,%esp
  return i;
801043fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801043ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104402:	c9                   	leave  
80104403:	c3                   	ret    

80104404 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104404:	55                   	push   %ebp
80104405:	89 e5                	mov    %esp,%ebp
80104407:	53                   	push   %ebx
80104408:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010440b:	9c                   	pushf  
8010440c:	5b                   	pop    %ebx
8010440d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80104410:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104413:	83 c4 10             	add    $0x10,%esp
80104416:	5b                   	pop    %ebx
80104417:	c9                   	leave  
80104418:	c3                   	ret    

80104419 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104419:	55                   	push   %ebp
8010441a:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010441c:	fb                   	sti    
}
8010441d:	c9                   	leave  
8010441e:	c3                   	ret    

8010441f <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
8010441f:	55                   	push   %ebp
80104420:	89 e5                	mov    %esp,%ebp
80104422:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80104425:	83 ec 08             	sub    $0x8,%esp
80104428:	68 ad 87 10 80       	push   $0x801087ad
8010442d:	68 60 29 11 80       	push   $0x80112960
80104432:	e8 6b 0b 00 00       	call   80104fa2 <initlock>
80104437:	83 c4 10             	add    $0x10,%esp
}
8010443a:	c9                   	leave  
8010443b:	c3                   	ret    

8010443c <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
8010443c:	55                   	push   %ebp
8010443d:	89 e5                	mov    %esp,%ebp
8010443f:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104442:	83 ec 0c             	sub    $0xc,%esp
80104445:	68 60 29 11 80       	push   $0x80112960
8010444a:	e8 74 0b 00 00       	call   80104fc3 <acquire>
8010444f:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104452:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104459:	eb 0e                	jmp    80104469 <allocproc+0x2d>
    if(p->state == UNUSED)
8010445b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010445e:	8b 40 0c             	mov    0xc(%eax),%eax
80104461:	85 c0                	test   %eax,%eax
80104463:	74 28                	je     8010448d <allocproc+0x51>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104465:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104469:	b8 94 48 11 80       	mov    $0x80114894,%eax
8010446e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104471:	72 e8                	jb     8010445b <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104473:	83 ec 0c             	sub    $0xc,%esp
80104476:	68 60 29 11 80       	push   $0x80112960
8010447b:	e8 a9 0b 00 00       	call   80105029 <release>
80104480:	83 c4 10             	add    $0x10,%esp
  return 0;
80104483:	b8 00 00 00 00       	mov    $0x0,%eax
80104488:	e9 af 00 00 00       	jmp    8010453c <allocproc+0x100>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
8010448d:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010448e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104491:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104498:	a1 04 b0 10 80       	mov    0x8010b004,%eax
8010449d:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044a0:	89 42 10             	mov    %eax,0x10(%edx)
801044a3:	40                   	inc    %eax
801044a4:	a3 04 b0 10 80       	mov    %eax,0x8010b004
  release(&ptable.lock);
801044a9:	83 ec 0c             	sub    $0xc,%esp
801044ac:	68 60 29 11 80       	push   $0x80112960
801044b1:	e8 73 0b 00 00       	call   80105029 <release>
801044b6:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801044b9:	e8 41 e7 ff ff       	call   80102bff <kalloc>
801044be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044c1:	89 42 08             	mov    %eax,0x8(%edx)
801044c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c7:	8b 40 08             	mov    0x8(%eax),%eax
801044ca:	85 c0                	test   %eax,%eax
801044cc:	75 11                	jne    801044df <allocproc+0xa3>
    p->state = UNUSED;
801044ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801044d8:	b8 00 00 00 00       	mov    $0x0,%eax
801044dd:	eb 5d                	jmp    8010453c <allocproc+0x100>
  }
  sp = p->kstack + KSTACKSIZE;
801044df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e2:	8b 40 08             	mov    0x8(%eax),%eax
801044e5:	05 00 10 00 00       	add    $0x1000,%eax
801044ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801044ed:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801044f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f7:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801044fa:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801044fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104501:	ba dc 65 10 80       	mov    $0x801065dc,%edx
80104506:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104508:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
8010450c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010450f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104512:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104515:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104518:	8b 40 1c             	mov    0x1c(%eax),%eax
8010451b:	83 ec 04             	sub    $0x4,%esp
8010451e:	6a 14                	push   $0x14
80104520:	6a 00                	push   $0x0
80104522:	50                   	push   %eax
80104523:	e8 f6 0c 00 00       	call   8010521e <memset>
80104528:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010452b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010452e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104531:	ba 7a 4c 10 80       	mov    $0x80104c7a,%edx
80104536:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104539:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010453c:	c9                   	leave  
8010453d:	c3                   	ret    

8010453e <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010453e:	55                   	push   %ebp
8010453f:	89 e5                	mov    %esp,%ebp
80104541:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104544:	e8 f3 fe ff ff       	call   8010443c <allocproc>
80104549:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
8010454c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010454f:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm()) == 0)
80104554:	e8 f4 36 00 00       	call   80107c4d <setupkvm>
80104559:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010455c:	89 42 04             	mov    %eax,0x4(%edx)
8010455f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104562:	8b 40 04             	mov    0x4(%eax),%eax
80104565:	85 c0                	test   %eax,%eax
80104567:	75 0d                	jne    80104576 <userinit+0x38>
    panic("userinit: out of memory?");
80104569:	83 ec 0c             	sub    $0xc,%esp
8010456c:	68 b4 87 10 80       	push   $0x801087b4
80104571:	e8 ec bf ff ff       	call   80100562 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104576:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010457b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010457e:	8b 40 04             	mov    0x4(%eax),%eax
80104581:	83 ec 04             	sub    $0x4,%esp
80104584:	52                   	push   %edx
80104585:	68 e0 b4 10 80       	push   $0x8010b4e0
8010458a:	50                   	push   %eax
8010458b:	e8 07 39 00 00       	call   80107e97 <inituvm>
80104590:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104593:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104596:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010459c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010459f:	8b 40 18             	mov    0x18(%eax),%eax
801045a2:	83 ec 04             	sub    $0x4,%esp
801045a5:	6a 4c                	push   $0x4c
801045a7:	6a 00                	push   $0x0
801045a9:	50                   	push   %eax
801045aa:	e8 6f 0c 00 00       	call   8010521e <memset>
801045af:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801045b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b5:	8b 40 18             	mov    0x18(%eax),%eax
801045b8:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801045be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c1:	8b 40 18             	mov    0x18(%eax),%eax
801045c4:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801045ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045cd:	8b 50 18             	mov    0x18(%eax),%edx
801045d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d3:	8b 40 18             	mov    0x18(%eax),%eax
801045d6:	8b 40 2c             	mov    0x2c(%eax),%eax
801045d9:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
801045dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e0:	8b 50 18             	mov    0x18(%eax),%edx
801045e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e6:	8b 40 18             	mov    0x18(%eax),%eax
801045e9:	8b 40 2c             	mov    0x2c(%eax),%eax
801045ec:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
801045f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f3:	8b 40 18             	mov    0x18(%eax),%eax
801045f6:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801045fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104600:	8b 40 18             	mov    0x18(%eax),%eax
80104603:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010460a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460d:	8b 40 18             	mov    0x18(%eax),%eax
80104610:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104617:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010461a:	83 c0 6c             	add    $0x6c,%eax
8010461d:	83 ec 04             	sub    $0x4,%esp
80104620:	6a 10                	push   $0x10
80104622:	68 cd 87 10 80       	push   $0x801087cd
80104627:	50                   	push   %eax
80104628:	e8 ec 0d 00 00       	call   80105419 <safestrcpy>
8010462d:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104630:	83 ec 0c             	sub    $0xc,%esp
80104633:	68 d6 87 10 80       	push   $0x801087d6
80104638:	e8 8b de ff ff       	call   801024c8 <namei>
8010463d:	83 c4 10             	add    $0x10,%esp
80104640:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104643:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
80104646:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104649:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104650:	c9                   	leave  
80104651:	c3                   	ret    

80104652 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104652:	55                   	push   %ebp
80104653:	89 e5                	mov    %esp,%ebp
80104655:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
80104658:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010465e:	8b 00                	mov    (%eax),%eax
80104660:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104663:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104667:	7e 31                	jle    8010469a <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104669:	8b 45 08             	mov    0x8(%ebp),%eax
8010466c:	89 c2                	mov    %eax,%edx
8010466e:	03 55 f4             	add    -0xc(%ebp),%edx
80104671:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104677:	8b 40 04             	mov    0x4(%eax),%eax
8010467a:	83 ec 04             	sub    $0x4,%esp
8010467d:	52                   	push   %edx
8010467e:	ff 75 f4             	pushl  -0xc(%ebp)
80104681:	50                   	push   %eax
80104682:	e8 69 39 00 00       	call   80107ff0 <allocuvm>
80104687:	83 c4 10             	add    $0x10,%esp
8010468a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010468d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104691:	75 3e                	jne    801046d1 <growproc+0x7f>
      return -1;
80104693:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104698:	eb 59                	jmp    801046f3 <growproc+0xa1>
  } else if(n < 0){
8010469a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010469e:	79 31                	jns    801046d1 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801046a0:	8b 45 08             	mov    0x8(%ebp),%eax
801046a3:	89 c2                	mov    %eax,%edx
801046a5:	03 55 f4             	add    -0xc(%ebp),%edx
801046a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ae:	8b 40 04             	mov    0x4(%eax),%eax
801046b1:	83 ec 04             	sub    $0x4,%esp
801046b4:	52                   	push   %edx
801046b5:	ff 75 f4             	pushl  -0xc(%ebp)
801046b8:	50                   	push   %eax
801046b9:	e8 f9 39 00 00       	call   801080b7 <deallocuvm>
801046be:	83 c4 10             	add    $0x10,%esp
801046c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801046c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801046c8:	75 07                	jne    801046d1 <growproc+0x7f>
      return -1;
801046ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046cf:	eb 22                	jmp    801046f3 <growproc+0xa1>
  }
  proc->sz = sz;
801046d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046da:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801046dc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046e2:	83 ec 0c             	sub    $0xc,%esp
801046e5:	50                   	push   %eax
801046e6:	e8 48 36 00 00       	call   80107d33 <switchuvm>
801046eb:	83 c4 10             	add    $0x10,%esp
  return 0;
801046ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046f3:	c9                   	leave  
801046f4:	c3                   	ret    

801046f5 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801046f5:	55                   	push   %ebp
801046f6:	89 e5                	mov    %esp,%ebp
801046f8:	57                   	push   %edi
801046f9:	56                   	push   %esi
801046fa:	53                   	push   %ebx
801046fb:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801046fe:	e8 39 fd ff ff       	call   8010443c <allocproc>
80104703:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104706:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010470a:	75 0a                	jne    80104716 <fork+0x21>
    return -1;
8010470c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104711:	e9 61 01 00 00       	jmp    80104877 <fork+0x182>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104716:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010471c:	8b 10                	mov    (%eax),%edx
8010471e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104724:	8b 40 04             	mov    0x4(%eax),%eax
80104727:	83 ec 08             	sub    $0x8,%esp
8010472a:	52                   	push   %edx
8010472b:	50                   	push   %eax
8010472c:	e8 16 3b 00 00       	call   80108247 <copyuvm>
80104731:	83 c4 10             	add    $0x10,%esp
80104734:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104737:	89 42 04             	mov    %eax,0x4(%edx)
8010473a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010473d:	8b 40 04             	mov    0x4(%eax),%eax
80104740:	85 c0                	test   %eax,%eax
80104742:	75 30                	jne    80104774 <fork+0x7f>
    kfree(np->kstack);
80104744:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104747:	8b 40 08             	mov    0x8(%eax),%eax
8010474a:	83 ec 0c             	sub    $0xc,%esp
8010474d:	50                   	push   %eax
8010474e:	e8 10 e4 ff ff       	call   80102b63 <kfree>
80104753:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104756:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104759:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104760:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104763:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010476a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010476f:	e9 03 01 00 00       	jmp    80104877 <fork+0x182>
  }
  np->sz = proc->sz;
80104774:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010477a:	8b 10                	mov    (%eax),%edx
8010477c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010477f:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104781:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104788:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010478b:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
8010478e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104791:	8b 50 18             	mov    0x18(%eax),%edx
80104794:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010479a:	8b 40 18             	mov    0x18(%eax),%eax
8010479d:	89 c3                	mov    %eax,%ebx
8010479f:	b8 13 00 00 00       	mov    $0x13,%eax
801047a4:	89 d7                	mov    %edx,%edi
801047a6:	89 de                	mov    %ebx,%esi
801047a8:	89 c1                	mov    %eax,%ecx
801047aa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801047ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047af:	8b 40 18             	mov    0x18(%eax),%eax
801047b2:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801047b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801047c0:	eb 40                	jmp    80104802 <fork+0x10d>
    if(proc->ofile[i])
801047c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047cb:	83 c2 08             	add    $0x8,%edx
801047ce:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047d2:	85 c0                	test   %eax,%eax
801047d4:	74 29                	je     801047ff <fork+0x10a>
      np->ofile[i] = filedup(proc->ofile[i]);
801047d6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047df:	83 c2 08             	add    $0x8,%edx
801047e2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047e6:	83 ec 0c             	sub    $0xc,%esp
801047e9:	50                   	push   %eax
801047ea:	e8 d3 c7 ff ff       	call   80100fc2 <filedup>
801047ef:	83 c4 10             	add    $0x10,%esp
801047f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
801047f5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801047f8:	83 c1 08             	add    $0x8,%ecx
801047fb:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801047ff:	ff 45 e4             	incl   -0x1c(%ebp)
80104802:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104806:	7e ba                	jle    801047c2 <fork+0xcd>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104808:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010480e:	8b 40 68             	mov    0x68(%eax),%eax
80104811:	83 ec 0c             	sub    $0xc,%esp
80104814:	50                   	push   %eax
80104815:	e8 d2 d0 ff ff       	call   801018ec <idup>
8010481a:	83 c4 10             	add    $0x10,%esp
8010481d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104820:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104823:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104829:	8d 50 6c             	lea    0x6c(%eax),%edx
8010482c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010482f:	83 c0 6c             	add    $0x6c,%eax
80104832:	83 ec 04             	sub    $0x4,%esp
80104835:	6a 10                	push   $0x10
80104837:	52                   	push   %edx
80104838:	50                   	push   %eax
80104839:	e8 db 0b 00 00       	call   80105419 <safestrcpy>
8010483e:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104841:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104844:	8b 40 10             	mov    0x10(%eax),%eax
80104847:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
8010484a:	83 ec 0c             	sub    $0xc,%esp
8010484d:	68 60 29 11 80       	push   $0x80112960
80104852:	e8 6c 07 00 00       	call   80104fc3 <acquire>
80104857:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
8010485a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010485d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104864:	83 ec 0c             	sub    $0xc,%esp
80104867:	68 60 29 11 80       	push   $0x80112960
8010486c:	e8 b8 07 00 00       	call   80105029 <release>
80104871:	83 c4 10             	add    $0x10,%esp
  
  return pid;
80104874:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104877:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010487a:	83 c4 00             	add    $0x0,%esp
8010487d:	5b                   	pop    %ebx
8010487e:	5e                   	pop    %esi
8010487f:	5f                   	pop    %edi
80104880:	c9                   	leave  
80104881:	c3                   	ret    

80104882 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104882:	55                   	push   %ebp
80104883:	89 e5                	mov    %esp,%ebp
80104885:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104888:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010488f:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104894:	39 c2                	cmp    %eax,%edx
80104896:	75 0d                	jne    801048a5 <exit+0x23>
    panic("init exiting");
80104898:	83 ec 0c             	sub    $0xc,%esp
8010489b:	68 d8 87 10 80       	push   $0x801087d8
801048a0:	e8 bd bc ff ff       	call   80100562 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801048a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801048ac:	eb 47                	jmp    801048f5 <exit+0x73>
    if(proc->ofile[fd]){
801048ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048b7:	83 c2 08             	add    $0x8,%edx
801048ba:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048be:	85 c0                	test   %eax,%eax
801048c0:	74 30                	je     801048f2 <exit+0x70>
      fileclose(proc->ofile[fd]);
801048c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048cb:	83 c2 08             	add    $0x8,%edx
801048ce:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048d2:	83 ec 0c             	sub    $0xc,%esp
801048d5:	50                   	push   %eax
801048d6:	e8 38 c7 ff ff       	call   80101013 <fileclose>
801048db:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
801048de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048e7:	83 c2 08             	add    $0x8,%edx
801048ea:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801048f1:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801048f2:	ff 45 f0             	incl   -0x10(%ebp)
801048f5:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801048f9:	7e b3                	jle    801048ae <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
801048fb:	e8 d1 eb ff ff       	call   801034d1 <begin_op>
  iput(proc->cwd);
80104900:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104906:	8b 40 68             	mov    0x68(%eax),%eax
80104909:	83 ec 0c             	sub    $0xc,%esp
8010490c:	50                   	push   %eax
8010490d:	e8 e2 d1 ff ff       	call   80101af4 <iput>
80104912:	83 c4 10             	add    $0x10,%esp
  end_op();
80104915:	e8 40 ec ff ff       	call   8010355a <end_op>
  proc->cwd = 0;
8010491a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104920:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104927:	83 ec 0c             	sub    $0xc,%esp
8010492a:	68 60 29 11 80       	push   $0x80112960
8010492f:	e8 8f 06 00 00       	call   80104fc3 <acquire>
80104934:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104937:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010493d:	8b 40 14             	mov    0x14(%eax),%eax
80104940:	83 ec 0c             	sub    $0xc,%esp
80104943:	50                   	push   %eax
80104944:	e8 21 04 00 00       	call   80104d6a <wakeup1>
80104949:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010494c:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104953:	eb 3c                	jmp    80104991 <exit+0x10f>
    if(p->parent == proc){
80104955:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104958:	8b 50 14             	mov    0x14(%eax),%edx
8010495b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104961:	39 c2                	cmp    %eax,%edx
80104963:	75 28                	jne    8010498d <exit+0x10b>
      p->parent = initproc;
80104965:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
8010496b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010496e:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104971:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104974:	8b 40 0c             	mov    0xc(%eax),%eax
80104977:	83 f8 05             	cmp    $0x5,%eax
8010497a:	75 11                	jne    8010498d <exit+0x10b>
        wakeup1(initproc);
8010497c:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104981:	83 ec 0c             	sub    $0xc,%esp
80104984:	50                   	push   %eax
80104985:	e8 e0 03 00 00       	call   80104d6a <wakeup1>
8010498a:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010498d:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104991:	b8 94 48 11 80       	mov    $0x80114894,%eax
80104996:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104999:	72 ba                	jb     80104955 <exit+0xd3>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
8010499b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049a1:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801049a8:	e8 d8 01 00 00       	call   80104b85 <sched>
  panic("zombie exit");
801049ad:	83 ec 0c             	sub    $0xc,%esp
801049b0:	68 e5 87 10 80       	push   $0x801087e5
801049b5:	e8 a8 bb ff ff       	call   80100562 <panic>

801049ba <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801049ba:	55                   	push   %ebp
801049bb:	89 e5                	mov    %esp,%ebp
801049bd:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801049c0:	83 ec 0c             	sub    $0xc,%esp
801049c3:	68 60 29 11 80       	push   $0x80112960
801049c8:	e8 f6 05 00 00       	call   80104fc3 <acquire>
801049cd:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801049d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049d7:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
801049de:	e9 a6 00 00 00       	jmp    80104a89 <wait+0xcf>
      if(p->parent != proc)
801049e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e6:	8b 50 14             	mov    0x14(%eax),%edx
801049e9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049ef:	39 c2                	cmp    %eax,%edx
801049f1:	0f 85 8d 00 00 00    	jne    80104a84 <wait+0xca>
        continue;
      havekids = 1;
801049f7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801049fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a01:	8b 40 0c             	mov    0xc(%eax),%eax
80104a04:	83 f8 05             	cmp    $0x5,%eax
80104a07:	75 7c                	jne    80104a85 <wait+0xcb>
        // Found one.
        pid = p->pid;
80104a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a0c:	8b 40 10             	mov    0x10(%eax),%eax
80104a0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a15:	8b 40 08             	mov    0x8(%eax),%eax
80104a18:	83 ec 0c             	sub    $0xc,%esp
80104a1b:	50                   	push   %eax
80104a1c:	e8 42 e1 ff ff       	call   80102b63 <kfree>
80104a21:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a27:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a31:	8b 40 04             	mov    0x4(%eax),%eax
80104a34:	83 ec 0c             	sub    $0xc,%esp
80104a37:	50                   	push   %eax
80104a38:	e8 37 37 00 00       	call   80108174 <freevm>
80104a3d:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a43:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a4d:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a57:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a61:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a68:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104a6f:	83 ec 0c             	sub    $0xc,%esp
80104a72:	68 60 29 11 80       	push   $0x80112960
80104a77:	e8 ad 05 00 00       	call   80105029 <release>
80104a7c:	83 c4 10             	add    $0x10,%esp
        return pid;
80104a7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a82:	eb 59                	jmp    80104add <wait+0x123>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104a84:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a85:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104a89:	b8 94 48 11 80       	mov    $0x80114894,%eax
80104a8e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104a91:	0f 82 4c ff ff ff    	jb     801049e3 <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104a97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a9b:	74 0d                	je     80104aaa <wait+0xf0>
80104a9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aa3:	8b 40 24             	mov    0x24(%eax),%eax
80104aa6:	85 c0                	test   %eax,%eax
80104aa8:	74 17                	je     80104ac1 <wait+0x107>
      release(&ptable.lock);
80104aaa:	83 ec 0c             	sub    $0xc,%esp
80104aad:	68 60 29 11 80       	push   $0x80112960
80104ab2:	e8 72 05 00 00       	call   80105029 <release>
80104ab7:	83 c4 10             	add    $0x10,%esp
      return -1;
80104aba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104abf:	eb 1c                	jmp    80104add <wait+0x123>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104ac1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ac7:	83 ec 08             	sub    $0x8,%esp
80104aca:	68 60 29 11 80       	push   $0x80112960
80104acf:	50                   	push   %eax
80104ad0:	e8 ea 01 00 00       	call   80104cbf <sleep>
80104ad5:	83 c4 10             	add    $0x10,%esp
  }
80104ad8:	e9 f3 fe ff ff       	jmp    801049d0 <wait+0x16>
}
80104add:	c9                   	leave  
80104ade:	c3                   	ret    

80104adf <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104adf:	55                   	push   %ebp
80104ae0:	89 e5                	mov    %esp,%ebp
80104ae2:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104ae5:	e8 2f f9 ff ff       	call   80104419 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104aea:	83 ec 0c             	sub    $0xc,%esp
80104aed:	68 60 29 11 80       	push   $0x80112960
80104af2:	e8 cc 04 00 00       	call   80104fc3 <acquire>
80104af7:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104afa:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104b01:	eb 63                	jmp    80104b66 <scheduler+0x87>
      if(p->state != RUNNABLE)
80104b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b06:	8b 40 0c             	mov    0xc(%eax),%eax
80104b09:	83 f8 03             	cmp    $0x3,%eax
80104b0c:	75 53                	jne    80104b61 <scheduler+0x82>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b11:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104b17:	83 ec 0c             	sub    $0xc,%esp
80104b1a:	ff 75 f4             	pushl  -0xc(%ebp)
80104b1d:	e8 11 32 00 00       	call   80107d33 <switchuvm>
80104b22:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b28:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104b2f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b35:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b38:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104b3f:	83 c2 04             	add    $0x4,%edx
80104b42:	83 ec 08             	sub    $0x8,%esp
80104b45:	50                   	push   %eax
80104b46:	52                   	push   %edx
80104b47:	e8 3c 09 00 00       	call   80105488 <swtch>
80104b4c:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104b4f:	e8 c3 31 00 00       	call   80107d17 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104b54:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104b5b:	00 00 00 00 
80104b5f:	eb 01                	jmp    80104b62 <scheduler+0x83>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104b61:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b62:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104b66:	b8 94 48 11 80       	mov    $0x80114894,%eax
80104b6b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104b6e:	72 93                	jb     80104b03 <scheduler+0x24>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104b70:	83 ec 0c             	sub    $0xc,%esp
80104b73:	68 60 29 11 80       	push   $0x80112960
80104b78:	e8 ac 04 00 00       	call   80105029 <release>
80104b7d:	83 c4 10             	add    $0x10,%esp

  }
80104b80:	e9 60 ff ff ff       	jmp    80104ae5 <scheduler+0x6>

80104b85 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104b85:	55                   	push   %ebp
80104b86:	89 e5                	mov    %esp,%ebp
80104b88:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104b8b:	83 ec 0c             	sub    $0xc,%esp
80104b8e:	68 60 29 11 80       	push   $0x80112960
80104b93:	e8 58 05 00 00       	call   801050f0 <holding>
80104b98:	83 c4 10             	add    $0x10,%esp
80104b9b:	85 c0                	test   %eax,%eax
80104b9d:	75 0d                	jne    80104bac <sched+0x27>
    panic("sched ptable.lock");
80104b9f:	83 ec 0c             	sub    $0xc,%esp
80104ba2:	68 f1 87 10 80       	push   $0x801087f1
80104ba7:	e8 b6 b9 ff ff       	call   80100562 <panic>
  if(cpu->ncli != 1)
80104bac:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bb2:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104bb8:	83 f8 01             	cmp    $0x1,%eax
80104bbb:	74 0d                	je     80104bca <sched+0x45>
    panic("sched locks");
80104bbd:	83 ec 0c             	sub    $0xc,%esp
80104bc0:	68 03 88 10 80       	push   $0x80108803
80104bc5:	e8 98 b9 ff ff       	call   80100562 <panic>
  if(proc->state == RUNNING)
80104bca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bd0:	8b 40 0c             	mov    0xc(%eax),%eax
80104bd3:	83 f8 04             	cmp    $0x4,%eax
80104bd6:	75 0d                	jne    80104be5 <sched+0x60>
    panic("sched running");
80104bd8:	83 ec 0c             	sub    $0xc,%esp
80104bdb:	68 0f 88 10 80       	push   $0x8010880f
80104be0:	e8 7d b9 ff ff       	call   80100562 <panic>
  if(readeflags()&FL_IF)
80104be5:	e8 1a f8 ff ff       	call   80104404 <readeflags>
80104bea:	25 00 02 00 00       	and    $0x200,%eax
80104bef:	85 c0                	test   %eax,%eax
80104bf1:	74 0d                	je     80104c00 <sched+0x7b>
    panic("sched interruptible");
80104bf3:	83 ec 0c             	sub    $0xc,%esp
80104bf6:	68 1d 88 10 80       	push   $0x8010881d
80104bfb:	e8 62 b9 ff ff       	call   80100562 <panic>
  intena = cpu->intena;
80104c00:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c06:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104c0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104c0f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c15:	8b 40 04             	mov    0x4(%eax),%eax
80104c18:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c1f:	83 c2 1c             	add    $0x1c,%edx
80104c22:	83 ec 08             	sub    $0x8,%esp
80104c25:	50                   	push   %eax
80104c26:	52                   	push   %edx
80104c27:	e8 5c 08 00 00       	call   80105488 <swtch>
80104c2c:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104c2f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c35:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c38:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104c3e:	c9                   	leave  
80104c3f:	c3                   	ret    

80104c40 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104c46:	83 ec 0c             	sub    $0xc,%esp
80104c49:	68 60 29 11 80       	push   $0x80112960
80104c4e:	e8 70 03 00 00       	call   80104fc3 <acquire>
80104c53:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104c56:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c5c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104c63:	e8 1d ff ff ff       	call   80104b85 <sched>
  release(&ptable.lock);
80104c68:	83 ec 0c             	sub    $0xc,%esp
80104c6b:	68 60 29 11 80       	push   $0x80112960
80104c70:	e8 b4 03 00 00       	call   80105029 <release>
80104c75:	83 c4 10             	add    $0x10,%esp
}
80104c78:	c9                   	leave  
80104c79:	c3                   	ret    

80104c7a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104c7a:	55                   	push   %ebp
80104c7b:	89 e5                	mov    %esp,%ebp
80104c7d:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104c80:	83 ec 0c             	sub    $0xc,%esp
80104c83:	68 60 29 11 80       	push   $0x80112960
80104c88:	e8 9c 03 00 00       	call   80105029 <release>
80104c8d:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104c90:	a1 20 b0 10 80       	mov    0x8010b020,%eax
80104c95:	85 c0                	test   %eax,%eax
80104c97:	74 24                	je     80104cbd <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104c99:	c7 05 20 b0 10 80 00 	movl   $0x0,0x8010b020
80104ca0:	00 00 00 
    iinit(ROOTDEV);
80104ca3:	83 ec 0c             	sub    $0xc,%esp
80104ca6:	6a 01                	push   $0x1
80104ca8:	e8 4f c9 ff ff       	call   801015fc <iinit>
80104cad:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104cb0:	83 ec 0c             	sub    $0xc,%esp
80104cb3:	6a 01                	push   $0x1
80104cb5:	e8 06 e6 ff ff       	call   801032c0 <initlog>
80104cba:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104cbd:	c9                   	leave  
80104cbe:	c3                   	ret    

80104cbf <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104cbf:	55                   	push   %ebp
80104cc0:	89 e5                	mov    %esp,%ebp
80104cc2:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104cc5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ccb:	85 c0                	test   %eax,%eax
80104ccd:	75 0d                	jne    80104cdc <sleep+0x1d>
    panic("sleep");
80104ccf:	83 ec 0c             	sub    $0xc,%esp
80104cd2:	68 31 88 10 80       	push   $0x80108831
80104cd7:	e8 86 b8 ff ff       	call   80100562 <panic>

  if(lk == 0)
80104cdc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104ce0:	75 0d                	jne    80104cef <sleep+0x30>
    panic("sleep without lk");
80104ce2:	83 ec 0c             	sub    $0xc,%esp
80104ce5:	68 37 88 10 80       	push   $0x80108837
80104cea:	e8 73 b8 ff ff       	call   80100562 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104cef:	81 7d 0c 60 29 11 80 	cmpl   $0x80112960,0xc(%ebp)
80104cf6:	74 1e                	je     80104d16 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104cf8:	83 ec 0c             	sub    $0xc,%esp
80104cfb:	68 60 29 11 80       	push   $0x80112960
80104d00:	e8 be 02 00 00       	call   80104fc3 <acquire>
80104d05:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104d08:	83 ec 0c             	sub    $0xc,%esp
80104d0b:	ff 75 0c             	pushl  0xc(%ebp)
80104d0e:	e8 16 03 00 00       	call   80105029 <release>
80104d13:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104d16:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d1c:	8b 55 08             	mov    0x8(%ebp),%edx
80104d1f:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104d22:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d28:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104d2f:	e8 51 fe ff ff       	call   80104b85 <sched>

  // Tidy up.
  proc->chan = 0;
80104d34:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d3a:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104d41:	81 7d 0c 60 29 11 80 	cmpl   $0x80112960,0xc(%ebp)
80104d48:	74 1e                	je     80104d68 <sleep+0xa9>
    release(&ptable.lock);
80104d4a:	83 ec 0c             	sub    $0xc,%esp
80104d4d:	68 60 29 11 80       	push   $0x80112960
80104d52:	e8 d2 02 00 00       	call   80105029 <release>
80104d57:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104d5a:	83 ec 0c             	sub    $0xc,%esp
80104d5d:	ff 75 0c             	pushl  0xc(%ebp)
80104d60:	e8 5e 02 00 00       	call   80104fc3 <acquire>
80104d65:	83 c4 10             	add    $0x10,%esp
  }
}
80104d68:	c9                   	leave  
80104d69:	c3                   	ret    

80104d6a <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104d6a:	55                   	push   %ebp
80104d6b:	89 e5                	mov    %esp,%ebp
80104d6d:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d70:	c7 45 fc 94 29 11 80 	movl   $0x80112994,-0x4(%ebp)
80104d77:	eb 24                	jmp    80104d9d <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104d79:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d7c:	8b 40 0c             	mov    0xc(%eax),%eax
80104d7f:	83 f8 02             	cmp    $0x2,%eax
80104d82:	75 15                	jne    80104d99 <wakeup1+0x2f>
80104d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d87:	8b 40 20             	mov    0x20(%eax),%eax
80104d8a:	3b 45 08             	cmp    0x8(%ebp),%eax
80104d8d:	75 0a                	jne    80104d99 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104d8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d92:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d99:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104d9d:	b8 94 48 11 80       	mov    $0x80114894,%eax
80104da2:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80104da5:	72 d2                	jb     80104d79 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104da7:	c9                   	leave  
80104da8:	c3                   	ret    

80104da9 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104da9:	55                   	push   %ebp
80104daa:	89 e5                	mov    %esp,%ebp
80104dac:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104daf:	83 ec 0c             	sub    $0xc,%esp
80104db2:	68 60 29 11 80       	push   $0x80112960
80104db7:	e8 07 02 00 00       	call   80104fc3 <acquire>
80104dbc:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104dbf:	83 ec 0c             	sub    $0xc,%esp
80104dc2:	ff 75 08             	pushl  0x8(%ebp)
80104dc5:	e8 a0 ff ff ff       	call   80104d6a <wakeup1>
80104dca:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104dcd:	83 ec 0c             	sub    $0xc,%esp
80104dd0:	68 60 29 11 80       	push   $0x80112960
80104dd5:	e8 4f 02 00 00       	call   80105029 <release>
80104dda:	83 c4 10             	add    $0x10,%esp
}
80104ddd:	c9                   	leave  
80104dde:	c3                   	ret    

80104ddf <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104ddf:	55                   	push   %ebp
80104de0:	89 e5                	mov    %esp,%ebp
80104de2:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104de5:	83 ec 0c             	sub    $0xc,%esp
80104de8:	68 60 29 11 80       	push   $0x80112960
80104ded:	e8 d1 01 00 00       	call   80104fc3 <acquire>
80104df2:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104df5:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104dfc:	eb 45                	jmp    80104e43 <kill+0x64>
    if(p->pid == pid){
80104dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e01:	8b 40 10             	mov    0x10(%eax),%eax
80104e04:	3b 45 08             	cmp    0x8(%ebp),%eax
80104e07:	75 36                	jne    80104e3f <kill+0x60>
      p->killed = 1;
80104e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e0c:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e16:	8b 40 0c             	mov    0xc(%eax),%eax
80104e19:	83 f8 02             	cmp    $0x2,%eax
80104e1c:	75 0a                	jne    80104e28 <kill+0x49>
        p->state = RUNNABLE;
80104e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e21:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104e28:	83 ec 0c             	sub    $0xc,%esp
80104e2b:	68 60 29 11 80       	push   $0x80112960
80104e30:	e8 f4 01 00 00       	call   80105029 <release>
80104e35:	83 c4 10             	add    $0x10,%esp
      return 0;
80104e38:	b8 00 00 00 00       	mov    $0x0,%eax
80104e3d:	eb 23                	jmp    80104e62 <kill+0x83>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e3f:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104e43:	b8 94 48 11 80       	mov    $0x80114894,%eax
80104e48:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104e4b:	72 b1                	jb     80104dfe <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104e4d:	83 ec 0c             	sub    $0xc,%esp
80104e50:	68 60 29 11 80       	push   $0x80112960
80104e55:	e8 cf 01 00 00       	call   80105029 <release>
80104e5a:	83 c4 10             	add    $0x10,%esp
  return -1;
80104e5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e62:	c9                   	leave  
80104e63:	c3                   	ret    

80104e64 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104e64:	55                   	push   %ebp
80104e65:	89 e5                	mov    %esp,%ebp
80104e67:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e6a:	c7 45 f0 94 29 11 80 	movl   $0x80112994,-0x10(%ebp)
80104e71:	e9 d4 00 00 00       	jmp    80104f4a <procdump+0xe6>
    if(p->state == UNUSED)
80104e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e79:	8b 40 0c             	mov    0xc(%eax),%eax
80104e7c:	85 c0                	test   %eax,%eax
80104e7e:	0f 84 c1 00 00 00    	je     80104f45 <procdump+0xe1>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e87:	8b 40 0c             	mov    0xc(%eax),%eax
80104e8a:	83 f8 05             	cmp    $0x5,%eax
80104e8d:	77 23                	ja     80104eb2 <procdump+0x4e>
80104e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e92:	8b 40 0c             	mov    0xc(%eax),%eax
80104e95:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104e9c:	85 c0                	test   %eax,%eax
80104e9e:	74 12                	je     80104eb2 <procdump+0x4e>
      state = states[p->state];
80104ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ea3:	8b 40 0c             	mov    0xc(%eax),%eax
80104ea6:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104ead:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104eb0:	eb 07                	jmp    80104eb9 <procdump+0x55>
    else
      state = "???";
80104eb2:	c7 45 ec 48 88 10 80 	movl   $0x80108848,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ebc:	8d 50 6c             	lea    0x6c(%eax),%edx
80104ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ec2:	8b 40 10             	mov    0x10(%eax),%eax
80104ec5:	52                   	push   %edx
80104ec6:	ff 75 ec             	pushl  -0x14(%ebp)
80104ec9:	50                   	push   %eax
80104eca:	68 4c 88 10 80       	push   $0x8010884c
80104ecf:	e8 ef b4 ff ff       	call   801003c3 <cprintf>
80104ed4:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104eda:	8b 40 0c             	mov    0xc(%eax),%eax
80104edd:	83 f8 02             	cmp    $0x2,%eax
80104ee0:	75 51                	jne    80104f33 <procdump+0xcf>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ee5:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ee8:	8b 40 0c             	mov    0xc(%eax),%eax
80104eeb:	83 c0 08             	add    $0x8,%eax
80104eee:	83 ec 08             	sub    $0x8,%esp
80104ef1:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104ef4:	52                   	push   %edx
80104ef5:	50                   	push   %eax
80104ef6:	e8 7f 01 00 00       	call   8010507a <getcallerpcs>
80104efb:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104efe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104f05:	eb 1b                	jmp    80104f22 <procdump+0xbe>
        cprintf(" %p", pc[i]);
80104f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f0a:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104f0e:	83 ec 08             	sub    $0x8,%esp
80104f11:	50                   	push   %eax
80104f12:	68 55 88 10 80       	push   $0x80108855
80104f17:	e8 a7 b4 ff ff       	call   801003c3 <cprintf>
80104f1c:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104f1f:	ff 45 f4             	incl   -0xc(%ebp)
80104f22:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104f26:	7f 0b                	jg     80104f33 <procdump+0xcf>
80104f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f2b:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104f2f:	85 c0                	test   %eax,%eax
80104f31:	75 d4                	jne    80104f07 <procdump+0xa3>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104f33:	83 ec 0c             	sub    $0xc,%esp
80104f36:	68 59 88 10 80       	push   $0x80108859
80104f3b:	e8 83 b4 ff ff       	call   801003c3 <cprintf>
80104f40:	83 c4 10             	add    $0x10,%esp
80104f43:	eb 01                	jmp    80104f46 <procdump+0xe2>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80104f45:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f46:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104f4a:	b8 94 48 11 80       	mov    $0x80114894,%eax
80104f4f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104f52:	0f 82 1e ff ff ff    	jb     80104e76 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104f58:	c9                   	leave  
80104f59:	c3                   	ret    
	...

80104f5c <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104f5c:	55                   	push   %ebp
80104f5d:	89 e5                	mov    %esp,%ebp
80104f5f:	53                   	push   %ebx
80104f60:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f63:	9c                   	pushf  
80104f64:	5b                   	pop    %ebx
80104f65:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80104f68:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104f6b:	83 c4 10             	add    $0x10,%esp
80104f6e:	5b                   	pop    %ebx
80104f6f:	c9                   	leave  
80104f70:	c3                   	ret    

80104f71 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104f71:	55                   	push   %ebp
80104f72:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104f74:	fa                   	cli    
}
80104f75:	c9                   	leave  
80104f76:	c3                   	ret    

80104f77 <sti>:

static inline void
sti(void)
{
80104f77:	55                   	push   %ebp
80104f78:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104f7a:	fb                   	sti    
}
80104f7b:	c9                   	leave  
80104f7c:	c3                   	ret    

80104f7d <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104f7d:	55                   	push   %ebp
80104f7e:	89 e5                	mov    %esp,%ebp
80104f80:	53                   	push   %ebx
80104f81:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
80104f84:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104f87:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
80104f8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104f8d:	89 c3                	mov    %eax,%ebx
80104f8f:	89 d8                	mov    %ebx,%eax
80104f91:	f0 87 02             	lock xchg %eax,(%edx)
80104f94:	89 c3                	mov    %eax,%ebx
80104f96:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104f99:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104f9c:	83 c4 10             	add    $0x10,%esp
80104f9f:	5b                   	pop    %ebx
80104fa0:	c9                   	leave  
80104fa1:	c3                   	ret    

80104fa2 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104fa2:	55                   	push   %ebp
80104fa3:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104fa5:	8b 45 08             	mov    0x8(%ebp),%eax
80104fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
80104fab:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104fae:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104fb7:	8b 45 08             	mov    0x8(%ebp),%eax
80104fba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104fc1:	c9                   	leave  
80104fc2:	c3                   	ret    

80104fc3 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104fc3:	55                   	push   %ebp
80104fc4:	89 e5                	mov    %esp,%ebp
80104fc6:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104fc9:	e8 4c 01 00 00       	call   8010511a <pushcli>
  if(holding(lk))
80104fce:	8b 45 08             	mov    0x8(%ebp),%eax
80104fd1:	83 ec 0c             	sub    $0xc,%esp
80104fd4:	50                   	push   %eax
80104fd5:	e8 16 01 00 00       	call   801050f0 <holding>
80104fda:	83 c4 10             	add    $0x10,%esp
80104fdd:	85 c0                	test   %eax,%eax
80104fdf:	74 0d                	je     80104fee <acquire+0x2b>
    panic("acquire");
80104fe1:	83 ec 0c             	sub    $0xc,%esp
80104fe4:	68 85 88 10 80       	push   $0x80108885
80104fe9:	e8 74 b5 ff ff       	call   80100562 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104fee:	90                   	nop
80104fef:	8b 45 08             	mov    0x8(%ebp),%eax
80104ff2:	83 ec 08             	sub    $0x8,%esp
80104ff5:	6a 01                	push   $0x1
80104ff7:	50                   	push   %eax
80104ff8:	e8 80 ff ff ff       	call   80104f7d <xchg>
80104ffd:	83 c4 10             	add    $0x10,%esp
80105000:	85 c0                	test   %eax,%eax
80105002:	75 eb                	jne    80104fef <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105004:	8b 45 08             	mov    0x8(%ebp),%eax
80105007:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010500e:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105011:	8b 45 08             	mov    0x8(%ebp),%eax
80105014:	83 c0 0c             	add    $0xc,%eax
80105017:	83 ec 08             	sub    $0x8,%esp
8010501a:	50                   	push   %eax
8010501b:	8d 45 08             	lea    0x8(%ebp),%eax
8010501e:	50                   	push   %eax
8010501f:	e8 56 00 00 00       	call   8010507a <getcallerpcs>
80105024:	83 c4 10             	add    $0x10,%esp
}
80105027:	c9                   	leave  
80105028:	c3                   	ret    

80105029 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105029:	55                   	push   %ebp
8010502a:	89 e5                	mov    %esp,%ebp
8010502c:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
8010502f:	83 ec 0c             	sub    $0xc,%esp
80105032:	ff 75 08             	pushl  0x8(%ebp)
80105035:	e8 b6 00 00 00       	call   801050f0 <holding>
8010503a:	83 c4 10             	add    $0x10,%esp
8010503d:	85 c0                	test   %eax,%eax
8010503f:	75 0d                	jne    8010504e <release+0x25>
    panic("release");
80105041:	83 ec 0c             	sub    $0xc,%esp
80105044:	68 8d 88 10 80       	push   $0x8010888d
80105049:	e8 14 b5 ff ff       	call   80100562 <panic>

  lk->pcs[0] = 0;
8010504e:	8b 45 08             	mov    0x8(%ebp),%eax
80105051:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105058:	8b 45 08             	mov    0x8(%ebp),%eax
8010505b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105062:	8b 45 08             	mov    0x8(%ebp),%eax
80105065:	83 ec 08             	sub    $0x8,%esp
80105068:	6a 00                	push   $0x0
8010506a:	50                   	push   %eax
8010506b:	e8 0d ff ff ff       	call   80104f7d <xchg>
80105070:	83 c4 10             	add    $0x10,%esp

  popcli();
80105073:	e8 e8 00 00 00       	call   80105160 <popcli>
}
80105078:	c9                   	leave  
80105079:	c3                   	ret    

8010507a <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010507a:	55                   	push   %ebp
8010507b:	89 e5                	mov    %esp,%ebp
8010507d:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105080:	8b 45 08             	mov    0x8(%ebp),%eax
80105083:	83 e8 08             	sub    $0x8,%eax
80105086:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105089:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105090:	eb 33                	jmp    801050c5 <getcallerpcs+0x4b>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105092:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105096:	74 49                	je     801050e1 <getcallerpcs+0x67>
80105098:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010509f:	76 43                	jbe    801050e4 <getcallerpcs+0x6a>
801050a1:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801050a5:	74 40                	je     801050e7 <getcallerpcs+0x6d>
      break;
    pcs[i] = ebp[1];     // saved %eip
801050a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050aa:	c1 e0 02             	shl    $0x2,%eax
801050ad:	03 45 0c             	add    0xc(%ebp),%eax
801050b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
801050b3:	83 c2 04             	add    $0x4,%edx
801050b6:	8b 12                	mov    (%edx),%edx
801050b8:	89 10                	mov    %edx,(%eax)
    ebp = (uint*)ebp[0]; // saved %ebp
801050ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050bd:	8b 00                	mov    (%eax),%eax
801050bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801050c2:	ff 45 f8             	incl   -0x8(%ebp)
801050c5:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801050c9:	7e c7                	jle    80105092 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801050cb:	eb 1b                	jmp    801050e8 <getcallerpcs+0x6e>
    pcs[i] = 0;
801050cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050d0:	c1 e0 02             	shl    $0x2,%eax
801050d3:	03 45 0c             	add    0xc(%ebp),%eax
801050d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801050dc:	ff 45 f8             	incl   -0x8(%ebp)
801050df:	eb 07                	jmp    801050e8 <getcallerpcs+0x6e>
801050e1:	90                   	nop
801050e2:	eb 04                	jmp    801050e8 <getcallerpcs+0x6e>
801050e4:	90                   	nop
801050e5:	eb 01                	jmp    801050e8 <getcallerpcs+0x6e>
801050e7:	90                   	nop
801050e8:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801050ec:	7e df                	jle    801050cd <getcallerpcs+0x53>
    pcs[i] = 0;
}
801050ee:	c9                   	leave  
801050ef:	c3                   	ret    

801050f0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801050f3:	8b 45 08             	mov    0x8(%ebp),%eax
801050f6:	8b 00                	mov    (%eax),%eax
801050f8:	85 c0                	test   %eax,%eax
801050fa:	74 17                	je     80105113 <holding+0x23>
801050fc:	8b 45 08             	mov    0x8(%ebp),%eax
801050ff:	8b 50 08             	mov    0x8(%eax),%edx
80105102:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105108:	39 c2                	cmp    %eax,%edx
8010510a:	75 07                	jne    80105113 <holding+0x23>
8010510c:	b8 01 00 00 00       	mov    $0x1,%eax
80105111:	eb 05                	jmp    80105118 <holding+0x28>
80105113:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105118:	c9                   	leave  
80105119:	c3                   	ret    

8010511a <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010511a:	55                   	push   %ebp
8010511b:	89 e5                	mov    %esp,%ebp
8010511d:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105120:	e8 37 fe ff ff       	call   80104f5c <readeflags>
80105125:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105128:	e8 44 fe ff ff       	call   80104f71 <cli>
  if(cpu->ncli++ == 0)
8010512d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105133:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105139:	85 d2                	test   %edx,%edx
8010513b:	0f 94 c1             	sete   %cl
8010513e:	42                   	inc    %edx
8010513f:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105145:	84 c9                	test   %cl,%cl
80105147:	74 15                	je     8010515e <pushcli+0x44>
    cpu->intena = eflags & FL_IF;
80105149:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010514f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105152:	81 e2 00 02 00 00    	and    $0x200,%edx
80105158:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010515e:	c9                   	leave  
8010515f:	c3                   	ret    

80105160 <popcli>:

void
popcli(void)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105166:	e8 f1 fd ff ff       	call   80104f5c <readeflags>
8010516b:	25 00 02 00 00       	and    $0x200,%eax
80105170:	85 c0                	test   %eax,%eax
80105172:	74 0d                	je     80105181 <popcli+0x21>
    panic("popcli - interruptible");
80105174:	83 ec 0c             	sub    $0xc,%esp
80105177:	68 95 88 10 80       	push   $0x80108895
8010517c:	e8 e1 b3 ff ff       	call   80100562 <panic>
  if(--cpu->ncli < 0)
80105181:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105187:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010518d:	4a                   	dec    %edx
8010518e:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105194:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010519a:	85 c0                	test   %eax,%eax
8010519c:	79 0d                	jns    801051ab <popcli+0x4b>
    panic("popcli");
8010519e:	83 ec 0c             	sub    $0xc,%esp
801051a1:	68 ac 88 10 80       	push   $0x801088ac
801051a6:	e8 b7 b3 ff ff       	call   80100562 <panic>
  if(cpu->ncli == 0 && cpu->intena)
801051ab:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051b1:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801051b7:	85 c0                	test   %eax,%eax
801051b9:	75 15                	jne    801051d0 <popcli+0x70>
801051bb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051c1:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801051c7:	85 c0                	test   %eax,%eax
801051c9:	74 05                	je     801051d0 <popcli+0x70>
    sti();
801051cb:	e8 a7 fd ff ff       	call   80104f77 <sti>
}
801051d0:	c9                   	leave  
801051d1:	c3                   	ret    
	...

801051d4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801051d4:	55                   	push   %ebp
801051d5:	89 e5                	mov    %esp,%ebp
801051d7:	57                   	push   %edi
801051d8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801051d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051dc:	8b 55 10             	mov    0x10(%ebp),%edx
801051df:	8b 45 0c             	mov    0xc(%ebp),%eax
801051e2:	89 cb                	mov    %ecx,%ebx
801051e4:	89 df                	mov    %ebx,%edi
801051e6:	89 d1                	mov    %edx,%ecx
801051e8:	fc                   	cld    
801051e9:	f3 aa                	rep stos %al,%es:(%edi)
801051eb:	89 ca                	mov    %ecx,%edx
801051ed:	89 fb                	mov    %edi,%ebx
801051ef:	89 5d 08             	mov    %ebx,0x8(%ebp)
801051f2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801051f5:	5b                   	pop    %ebx
801051f6:	5f                   	pop    %edi
801051f7:	c9                   	leave  
801051f8:	c3                   	ret    

801051f9 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801051f9:	55                   	push   %ebp
801051fa:	89 e5                	mov    %esp,%ebp
801051fc:	57                   	push   %edi
801051fd:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801051fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105201:	8b 55 10             	mov    0x10(%ebp),%edx
80105204:	8b 45 0c             	mov    0xc(%ebp),%eax
80105207:	89 cb                	mov    %ecx,%ebx
80105209:	89 df                	mov    %ebx,%edi
8010520b:	89 d1                	mov    %edx,%ecx
8010520d:	fc                   	cld    
8010520e:	f3 ab                	rep stos %eax,%es:(%edi)
80105210:	89 ca                	mov    %ecx,%edx
80105212:	89 fb                	mov    %edi,%ebx
80105214:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105217:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010521a:	5b                   	pop    %ebx
8010521b:	5f                   	pop    %edi
8010521c:	c9                   	leave  
8010521d:	c3                   	ret    

8010521e <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010521e:	55                   	push   %ebp
8010521f:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105221:	8b 45 08             	mov    0x8(%ebp),%eax
80105224:	83 e0 03             	and    $0x3,%eax
80105227:	85 c0                	test   %eax,%eax
80105229:	75 43                	jne    8010526e <memset+0x50>
8010522b:	8b 45 10             	mov    0x10(%ebp),%eax
8010522e:	83 e0 03             	and    $0x3,%eax
80105231:	85 c0                	test   %eax,%eax
80105233:	75 39                	jne    8010526e <memset+0x50>
    c &= 0xFF;
80105235:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010523c:	8b 45 10             	mov    0x10(%ebp),%eax
8010523f:	c1 e8 02             	shr    $0x2,%eax
80105242:	89 c2                	mov    %eax,%edx
80105244:	8b 45 0c             	mov    0xc(%ebp),%eax
80105247:	89 c1                	mov    %eax,%ecx
80105249:	c1 e1 18             	shl    $0x18,%ecx
8010524c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010524f:	c1 e0 10             	shl    $0x10,%eax
80105252:	09 c1                	or     %eax,%ecx
80105254:	8b 45 0c             	mov    0xc(%ebp),%eax
80105257:	c1 e0 08             	shl    $0x8,%eax
8010525a:	09 c8                	or     %ecx,%eax
8010525c:	0b 45 0c             	or     0xc(%ebp),%eax
8010525f:	52                   	push   %edx
80105260:	50                   	push   %eax
80105261:	ff 75 08             	pushl  0x8(%ebp)
80105264:	e8 90 ff ff ff       	call   801051f9 <stosl>
80105269:	83 c4 0c             	add    $0xc,%esp
8010526c:	eb 12                	jmp    80105280 <memset+0x62>
  } else
    stosb(dst, c, n);
8010526e:	8b 45 10             	mov    0x10(%ebp),%eax
80105271:	50                   	push   %eax
80105272:	ff 75 0c             	pushl  0xc(%ebp)
80105275:	ff 75 08             	pushl  0x8(%ebp)
80105278:	e8 57 ff ff ff       	call   801051d4 <stosb>
8010527d:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105280:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105283:	c9                   	leave  
80105284:	c3                   	ret    

80105285 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105285:	55                   	push   %ebp
80105286:	89 e5                	mov    %esp,%ebp
80105288:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010528b:	8b 45 08             	mov    0x8(%ebp),%eax
8010528e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105291:	8b 45 0c             	mov    0xc(%ebp),%eax
80105294:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105297:	eb 2c                	jmp    801052c5 <memcmp+0x40>
    if(*s1 != *s2)
80105299:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010529c:	8a 10                	mov    (%eax),%dl
8010529e:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052a1:	8a 00                	mov    (%eax),%al
801052a3:	38 c2                	cmp    %al,%dl
801052a5:	74 18                	je     801052bf <memcmp+0x3a>
      return *s1 - *s2;
801052a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052aa:	8a 00                	mov    (%eax),%al
801052ac:	0f b6 d0             	movzbl %al,%edx
801052af:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052b2:	8a 00                	mov    (%eax),%al
801052b4:	0f b6 c0             	movzbl %al,%eax
801052b7:	89 d1                	mov    %edx,%ecx
801052b9:	29 c1                	sub    %eax,%ecx
801052bb:	89 c8                	mov    %ecx,%eax
801052bd:	eb 19                	jmp    801052d8 <memcmp+0x53>
    s1++, s2++;
801052bf:	ff 45 fc             	incl   -0x4(%ebp)
801052c2:	ff 45 f8             	incl   -0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801052c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052c9:	0f 95 c0             	setne  %al
801052cc:	ff 4d 10             	decl   0x10(%ebp)
801052cf:	84 c0                	test   %al,%al
801052d1:	75 c6                	jne    80105299 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801052d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052d8:	c9                   	leave  
801052d9:	c3                   	ret    

801052da <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801052da:	55                   	push   %ebp
801052db:	89 e5                	mov    %esp,%ebp
801052dd:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801052e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801052e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801052e6:	8b 45 08             	mov    0x8(%ebp),%eax
801052e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801052ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801052f2:	73 4e                	jae    80105342 <memmove+0x68>
801052f4:	8b 45 10             	mov    0x10(%ebp),%eax
801052f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052fa:	8d 04 02             	lea    (%edx,%eax,1),%eax
801052fd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105300:	76 43                	jbe    80105345 <memmove+0x6b>
    s += n;
80105302:	8b 45 10             	mov    0x10(%ebp),%eax
80105305:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105308:	8b 45 10             	mov    0x10(%ebp),%eax
8010530b:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010530e:	eb 10                	jmp    80105320 <memmove+0x46>
      *--d = *--s;
80105310:	ff 4d f8             	decl   -0x8(%ebp)
80105313:	ff 4d fc             	decl   -0x4(%ebp)
80105316:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105319:	8a 10                	mov    (%eax),%dl
8010531b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010531e:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105320:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105324:	0f 95 c0             	setne  %al
80105327:	ff 4d 10             	decl   0x10(%ebp)
8010532a:	84 c0                	test   %al,%al
8010532c:	75 e2                	jne    80105310 <memmove+0x36>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010532e:	eb 24                	jmp    80105354 <memmove+0x7a>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80105330:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105333:	8a 10                	mov    (%eax),%dl
80105335:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105338:	88 10                	mov    %dl,(%eax)
8010533a:	ff 45 f8             	incl   -0x8(%ebp)
8010533d:	ff 45 fc             	incl   -0x4(%ebp)
80105340:	eb 04                	jmp    80105346 <memmove+0x6c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105342:	90                   	nop
80105343:	eb 01                	jmp    80105346 <memmove+0x6c>
80105345:	90                   	nop
80105346:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010534a:	0f 95 c0             	setne  %al
8010534d:	ff 4d 10             	decl   0x10(%ebp)
80105350:	84 c0                	test   %al,%al
80105352:	75 dc                	jne    80105330 <memmove+0x56>
      *d++ = *s++;

  return dst;
80105354:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105357:	c9                   	leave  
80105358:	c3                   	ret    

80105359 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105359:	55                   	push   %ebp
8010535a:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
8010535c:	ff 75 10             	pushl  0x10(%ebp)
8010535f:	ff 75 0c             	pushl  0xc(%ebp)
80105362:	ff 75 08             	pushl  0x8(%ebp)
80105365:	e8 70 ff ff ff       	call   801052da <memmove>
8010536a:	83 c4 0c             	add    $0xc,%esp
}
8010536d:	c9                   	leave  
8010536e:	c3                   	ret    

8010536f <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010536f:	55                   	push   %ebp
80105370:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105372:	eb 09                	jmp    8010537d <strncmp+0xe>
    n--, p++, q++;
80105374:	ff 4d 10             	decl   0x10(%ebp)
80105377:	ff 45 08             	incl   0x8(%ebp)
8010537a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010537d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105381:	74 17                	je     8010539a <strncmp+0x2b>
80105383:	8b 45 08             	mov    0x8(%ebp),%eax
80105386:	8a 00                	mov    (%eax),%al
80105388:	84 c0                	test   %al,%al
8010538a:	74 0e                	je     8010539a <strncmp+0x2b>
8010538c:	8b 45 08             	mov    0x8(%ebp),%eax
8010538f:	8a 10                	mov    (%eax),%dl
80105391:	8b 45 0c             	mov    0xc(%ebp),%eax
80105394:	8a 00                	mov    (%eax),%al
80105396:	38 c2                	cmp    %al,%dl
80105398:	74 da                	je     80105374 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010539a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010539e:	75 07                	jne    801053a7 <strncmp+0x38>
    return 0;
801053a0:	b8 00 00 00 00       	mov    $0x0,%eax
801053a5:	eb 16                	jmp    801053bd <strncmp+0x4e>
  return (uchar)*p - (uchar)*q;
801053a7:	8b 45 08             	mov    0x8(%ebp),%eax
801053aa:	8a 00                	mov    (%eax),%al
801053ac:	0f b6 d0             	movzbl %al,%edx
801053af:	8b 45 0c             	mov    0xc(%ebp),%eax
801053b2:	8a 00                	mov    (%eax),%al
801053b4:	0f b6 c0             	movzbl %al,%eax
801053b7:	89 d1                	mov    %edx,%ecx
801053b9:	29 c1                	sub    %eax,%ecx
801053bb:	89 c8                	mov    %ecx,%eax
}
801053bd:	c9                   	leave  
801053be:	c3                   	ret    

801053bf <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801053bf:	55                   	push   %ebp
801053c0:	89 e5                	mov    %esp,%ebp
801053c2:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801053c5:	8b 45 08             	mov    0x8(%ebp),%eax
801053c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801053cb:	90                   	nop
801053cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053d0:	0f 9f c0             	setg   %al
801053d3:	ff 4d 10             	decl   0x10(%ebp)
801053d6:	84 c0                	test   %al,%al
801053d8:	74 2b                	je     80105405 <strncpy+0x46>
801053da:	8b 45 0c             	mov    0xc(%ebp),%eax
801053dd:	8a 10                	mov    (%eax),%dl
801053df:	8b 45 08             	mov    0x8(%ebp),%eax
801053e2:	88 10                	mov    %dl,(%eax)
801053e4:	8b 45 08             	mov    0x8(%ebp),%eax
801053e7:	8a 00                	mov    (%eax),%al
801053e9:	84 c0                	test   %al,%al
801053eb:	0f 95 c0             	setne  %al
801053ee:	ff 45 08             	incl   0x8(%ebp)
801053f1:	ff 45 0c             	incl   0xc(%ebp)
801053f4:	84 c0                	test   %al,%al
801053f6:	75 d4                	jne    801053cc <strncpy+0xd>
    ;
  while(n-- > 0)
801053f8:	eb 0c                	jmp    80105406 <strncpy+0x47>
    *s++ = 0;
801053fa:	8b 45 08             	mov    0x8(%ebp),%eax
801053fd:	c6 00 00             	movb   $0x0,(%eax)
80105400:	ff 45 08             	incl   0x8(%ebp)
80105403:	eb 01                	jmp    80105406 <strncpy+0x47>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105405:	90                   	nop
80105406:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010540a:	0f 9f c0             	setg   %al
8010540d:	ff 4d 10             	decl   0x10(%ebp)
80105410:	84 c0                	test   %al,%al
80105412:	75 e6                	jne    801053fa <strncpy+0x3b>
    *s++ = 0;
  return os;
80105414:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105417:	c9                   	leave  
80105418:	c3                   	ret    

80105419 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105419:	55                   	push   %ebp
8010541a:	89 e5                	mov    %esp,%ebp
8010541c:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010541f:	8b 45 08             	mov    0x8(%ebp),%eax
80105422:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105425:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105429:	7f 05                	jg     80105430 <safestrcpy+0x17>
    return os;
8010542b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010542e:	eb 31                	jmp    80105461 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105430:	90                   	nop
80105431:	ff 4d 10             	decl   0x10(%ebp)
80105434:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105438:	7e 1e                	jle    80105458 <safestrcpy+0x3f>
8010543a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010543d:	8a 10                	mov    (%eax),%dl
8010543f:	8b 45 08             	mov    0x8(%ebp),%eax
80105442:	88 10                	mov    %dl,(%eax)
80105444:	8b 45 08             	mov    0x8(%ebp),%eax
80105447:	8a 00                	mov    (%eax),%al
80105449:	84 c0                	test   %al,%al
8010544b:	0f 95 c0             	setne  %al
8010544e:	ff 45 08             	incl   0x8(%ebp)
80105451:	ff 45 0c             	incl   0xc(%ebp)
80105454:	84 c0                	test   %al,%al
80105456:	75 d9                	jne    80105431 <safestrcpy+0x18>
    ;
  *s = 0;
80105458:	8b 45 08             	mov    0x8(%ebp),%eax
8010545b:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010545e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105461:	c9                   	leave  
80105462:	c3                   	ret    

80105463 <strlen>:

int
strlen(const char *s)
{
80105463:	55                   	push   %ebp
80105464:	89 e5                	mov    %esp,%ebp
80105466:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105469:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105470:	eb 03                	jmp    80105475 <strlen+0x12>
80105472:	ff 45 fc             	incl   -0x4(%ebp)
80105475:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105478:	03 45 08             	add    0x8(%ebp),%eax
8010547b:	8a 00                	mov    (%eax),%al
8010547d:	84 c0                	test   %al,%al
8010547f:	75 f1                	jne    80105472 <strlen+0xf>
    ;
  return n;
80105481:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105484:	c9                   	leave  
80105485:	c3                   	ret    
	...

80105488 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105488:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010548c:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105490:	55                   	push   %ebp
  pushl %ebx
80105491:	53                   	push   %ebx
  pushl %esi
80105492:	56                   	push   %esi
  pushl %edi
80105493:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105494:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105496:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105498:	5f                   	pop    %edi
  popl %esi
80105499:	5e                   	pop    %esi
  popl %ebx
8010549a:	5b                   	pop    %ebx
  popl %ebp
8010549b:	5d                   	pop    %ebp
  ret
8010549c:	c3                   	ret    
8010549d:	00 00                	add    %al,(%eax)
	...

801054a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801054a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054a9:	8b 00                	mov    (%eax),%eax
801054ab:	3b 45 08             	cmp    0x8(%ebp),%eax
801054ae:	76 12                	jbe    801054c2 <fetchint+0x22>
801054b0:	8b 45 08             	mov    0x8(%ebp),%eax
801054b3:	8d 50 04             	lea    0x4(%eax),%edx
801054b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054bc:	8b 00                	mov    (%eax),%eax
801054be:	39 c2                	cmp    %eax,%edx
801054c0:	76 07                	jbe    801054c9 <fetchint+0x29>
    return -1;
801054c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054c7:	eb 0f                	jmp    801054d8 <fetchint+0x38>
  *ip = *(int*)(addr);
801054c9:	8b 45 08             	mov    0x8(%ebp),%eax
801054cc:	8b 10                	mov    (%eax),%edx
801054ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801054d1:	89 10                	mov    %edx,(%eax)
  return 0;
801054d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054d8:	c9                   	leave  
801054d9:	c3                   	ret    

801054da <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801054da:	55                   	push   %ebp
801054db:	89 e5                	mov    %esp,%ebp
801054dd:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
801054e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054e6:	8b 00                	mov    (%eax),%eax
801054e8:	3b 45 08             	cmp    0x8(%ebp),%eax
801054eb:	77 07                	ja     801054f4 <fetchstr+0x1a>
    return -1;
801054ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054f2:	eb 46                	jmp    8010553a <fetchstr+0x60>
  *pp = (char*)addr;
801054f4:	8b 55 08             	mov    0x8(%ebp),%edx
801054f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801054fa:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801054fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105502:	8b 00                	mov    (%eax),%eax
80105504:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105507:	8b 45 0c             	mov    0xc(%ebp),%eax
8010550a:	8b 00                	mov    (%eax),%eax
8010550c:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010550f:	eb 1c                	jmp    8010552d <fetchstr+0x53>
    if(*s == 0)
80105511:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105514:	8a 00                	mov    (%eax),%al
80105516:	84 c0                	test   %al,%al
80105518:	75 10                	jne    8010552a <fetchstr+0x50>
      return s - *pp;
8010551a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010551d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105520:	8b 00                	mov    (%eax),%eax
80105522:	89 d1                	mov    %edx,%ecx
80105524:	29 c1                	sub    %eax,%ecx
80105526:	89 c8                	mov    %ecx,%eax
80105528:	eb 10                	jmp    8010553a <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
8010552a:	ff 45 fc             	incl   -0x4(%ebp)
8010552d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105530:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105533:	72 dc                	jb     80105511 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105535:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010553a:	c9                   	leave  
8010553b:	c3                   	ret    

8010553c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010553c:	55                   	push   %ebp
8010553d:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010553f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105545:	8b 40 18             	mov    0x18(%eax),%eax
80105548:	8b 50 44             	mov    0x44(%eax),%edx
8010554b:	8b 45 08             	mov    0x8(%ebp),%eax
8010554e:	c1 e0 02             	shl    $0x2,%eax
80105551:	8d 04 02             	lea    (%edx,%eax,1),%eax
80105554:	83 c0 04             	add    $0x4,%eax
80105557:	ff 75 0c             	pushl  0xc(%ebp)
8010555a:	50                   	push   %eax
8010555b:	e8 40 ff ff ff       	call   801054a0 <fetchint>
80105560:	83 c4 08             	add    $0x8,%esp
}
80105563:	c9                   	leave  
80105564:	c3                   	ret    

80105565 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105565:	55                   	push   %ebp
80105566:	89 e5                	mov    %esp,%ebp
80105568:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
8010556b:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010556e:	50                   	push   %eax
8010556f:	ff 75 08             	pushl  0x8(%ebp)
80105572:	e8 c5 ff ff ff       	call   8010553c <argint>
80105577:	83 c4 08             	add    $0x8,%esp
8010557a:	85 c0                	test   %eax,%eax
8010557c:	79 07                	jns    80105585 <argptr+0x20>
    return -1;
8010557e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105583:	eb 3d                	jmp    801055c2 <argptr+0x5d>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105585:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105588:	89 c2                	mov    %eax,%edx
8010558a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105590:	8b 00                	mov    (%eax),%eax
80105592:	39 c2                	cmp    %eax,%edx
80105594:	73 16                	jae    801055ac <argptr+0x47>
80105596:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105599:	89 c2                	mov    %eax,%edx
8010559b:	8b 45 10             	mov    0x10(%ebp),%eax
8010559e:	01 c2                	add    %eax,%edx
801055a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055a6:	8b 00                	mov    (%eax),%eax
801055a8:	39 c2                	cmp    %eax,%edx
801055aa:	76 07                	jbe    801055b3 <argptr+0x4e>
    return -1;
801055ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055b1:	eb 0f                	jmp    801055c2 <argptr+0x5d>
  *pp = (char*)i;
801055b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055b6:	89 c2                	mov    %eax,%edx
801055b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801055bb:	89 10                	mov    %edx,(%eax)
  return 0;
801055bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055c2:	c9                   	leave  
801055c3:	c3                   	ret    

801055c4 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801055c4:	55                   	push   %ebp
801055c5:	89 e5                	mov    %esp,%ebp
801055c7:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
801055ca:	8d 45 fc             	lea    -0x4(%ebp),%eax
801055cd:	50                   	push   %eax
801055ce:	ff 75 08             	pushl  0x8(%ebp)
801055d1:	e8 66 ff ff ff       	call   8010553c <argint>
801055d6:	83 c4 08             	add    $0x8,%esp
801055d9:	85 c0                	test   %eax,%eax
801055db:	79 07                	jns    801055e4 <argstr+0x20>
    return -1;
801055dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055e2:	eb 0f                	jmp    801055f3 <argstr+0x2f>
  return fetchstr(addr, pp);
801055e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055e7:	ff 75 0c             	pushl  0xc(%ebp)
801055ea:	50                   	push   %eax
801055eb:	e8 ea fe ff ff       	call   801054da <fetchstr>
801055f0:	83 c4 08             	add    $0x8,%esp
}
801055f3:	c9                   	leave  
801055f4:	c3                   	ret    

801055f5 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801055f5:	55                   	push   %ebp
801055f6:	89 e5                	mov    %esp,%ebp
801055f8:	53                   	push   %ebx
801055f9:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
801055fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105602:	8b 40 18             	mov    0x18(%eax),%eax
80105605:	8b 40 1c             	mov    0x1c(%eax),%eax
80105608:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010560b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010560f:	7e 30                	jle    80105641 <syscall+0x4c>
80105611:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105614:	83 f8 15             	cmp    $0x15,%eax
80105617:	77 28                	ja     80105641 <syscall+0x4c>
80105619:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010561c:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105623:	85 c0                	test   %eax,%eax
80105625:	74 1a                	je     80105641 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105627:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010562d:	8b 58 18             	mov    0x18(%eax),%ebx
80105630:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105633:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010563a:	ff d0                	call   *%eax
8010563c:	89 43 1c             	mov    %eax,0x1c(%ebx)
8010563f:	eb 34                	jmp    80105675 <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105641:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105647:	8d 50 6c             	lea    0x6c(%eax),%edx
            proc->pid, proc->name, num);
8010564a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105650:	8b 40 10             	mov    0x10(%eax),%eax
80105653:	ff 75 f4             	pushl  -0xc(%ebp)
80105656:	52                   	push   %edx
80105657:	50                   	push   %eax
80105658:	68 b3 88 10 80       	push   $0x801088b3
8010565d:	e8 61 ad ff ff       	call   801003c3 <cprintf>
80105662:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105665:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010566b:	8b 40 18             	mov    0x18(%eax),%eax
8010566e:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105675:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105678:	c9                   	leave  
80105679:	c3                   	ret    
	...

8010567c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010567c:	55                   	push   %ebp
8010567d:	89 e5                	mov    %esp,%ebp
8010567f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105682:	83 ec 08             	sub    $0x8,%esp
80105685:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105688:	50                   	push   %eax
80105689:	ff 75 08             	pushl  0x8(%ebp)
8010568c:	e8 ab fe ff ff       	call   8010553c <argint>
80105691:	83 c4 10             	add    $0x10,%esp
80105694:	85 c0                	test   %eax,%eax
80105696:	79 07                	jns    8010569f <argfd+0x23>
    return -1;
80105698:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010569d:	eb 50                	jmp    801056ef <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
8010569f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056a2:	85 c0                	test   %eax,%eax
801056a4:	78 21                	js     801056c7 <argfd+0x4b>
801056a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056a9:	83 f8 0f             	cmp    $0xf,%eax
801056ac:	7f 19                	jg     801056c7 <argfd+0x4b>
801056ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801056b7:	83 c2 08             	add    $0x8,%edx
801056ba:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801056be:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801056c5:	75 07                	jne    801056ce <argfd+0x52>
    return -1;
801056c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056cc:	eb 21                	jmp    801056ef <argfd+0x73>
  if(pfd)
801056ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801056d2:	74 08                	je     801056dc <argfd+0x60>
    *pfd = fd;
801056d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801056d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801056da:	89 10                	mov    %edx,(%eax)
  if(pf)
801056dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056e0:	74 08                	je     801056ea <argfd+0x6e>
    *pf = f;
801056e2:	8b 45 10             	mov    0x10(%ebp),%eax
801056e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056e8:	89 10                	mov    %edx,(%eax)
  return 0;
801056ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056ef:	c9                   	leave  
801056f0:	c3                   	ret    

801056f1 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801056f1:	55                   	push   %ebp
801056f2:	89 e5                	mov    %esp,%ebp
801056f4:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801056f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801056fe:	eb 2f                	jmp    8010572f <fdalloc+0x3e>
    if(proc->ofile[fd] == 0){
80105700:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105706:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105709:	83 c2 08             	add    $0x8,%edx
8010570c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105710:	85 c0                	test   %eax,%eax
80105712:	75 18                	jne    8010572c <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105714:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010571a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010571d:	8d 4a 08             	lea    0x8(%edx),%ecx
80105720:	8b 55 08             	mov    0x8(%ebp),%edx
80105723:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105727:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010572a:	eb 0e                	jmp    8010573a <fdalloc+0x49>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010572c:	ff 45 fc             	incl   -0x4(%ebp)
8010572f:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105733:	7e cb                	jle    80105700 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105735:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010573a:	c9                   	leave  
8010573b:	c3                   	ret    

8010573c <sys_dup>:

int
sys_dup(void)
{
8010573c:	55                   	push   %ebp
8010573d:	89 e5                	mov    %esp,%ebp
8010573f:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105742:	83 ec 04             	sub    $0x4,%esp
80105745:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105748:	50                   	push   %eax
80105749:	6a 00                	push   $0x0
8010574b:	6a 00                	push   $0x0
8010574d:	e8 2a ff ff ff       	call   8010567c <argfd>
80105752:	83 c4 10             	add    $0x10,%esp
80105755:	85 c0                	test   %eax,%eax
80105757:	79 07                	jns    80105760 <sys_dup+0x24>
    return -1;
80105759:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010575e:	eb 31                	jmp    80105791 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105760:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105763:	83 ec 0c             	sub    $0xc,%esp
80105766:	50                   	push   %eax
80105767:	e8 85 ff ff ff       	call   801056f1 <fdalloc>
8010576c:	83 c4 10             	add    $0x10,%esp
8010576f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105772:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105776:	79 07                	jns    8010577f <sys_dup+0x43>
    return -1;
80105778:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577d:	eb 12                	jmp    80105791 <sys_dup+0x55>
  filedup(f);
8010577f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105782:	83 ec 0c             	sub    $0xc,%esp
80105785:	50                   	push   %eax
80105786:	e8 37 b8 ff ff       	call   80100fc2 <filedup>
8010578b:	83 c4 10             	add    $0x10,%esp
  return fd;
8010578e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105791:	c9                   	leave  
80105792:	c3                   	ret    

80105793 <sys_read>:

int
sys_read(void)
{
80105793:	55                   	push   %ebp
80105794:	89 e5                	mov    %esp,%ebp
80105796:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105799:	83 ec 04             	sub    $0x4,%esp
8010579c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010579f:	50                   	push   %eax
801057a0:	6a 00                	push   $0x0
801057a2:	6a 00                	push   $0x0
801057a4:	e8 d3 fe ff ff       	call   8010567c <argfd>
801057a9:	83 c4 10             	add    $0x10,%esp
801057ac:	85 c0                	test   %eax,%eax
801057ae:	78 2e                	js     801057de <sys_read+0x4b>
801057b0:	83 ec 08             	sub    $0x8,%esp
801057b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057b6:	50                   	push   %eax
801057b7:	6a 02                	push   $0x2
801057b9:	e8 7e fd ff ff       	call   8010553c <argint>
801057be:	83 c4 10             	add    $0x10,%esp
801057c1:	85 c0                	test   %eax,%eax
801057c3:	78 19                	js     801057de <sys_read+0x4b>
801057c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057c8:	83 ec 04             	sub    $0x4,%esp
801057cb:	50                   	push   %eax
801057cc:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057cf:	50                   	push   %eax
801057d0:	6a 01                	push   $0x1
801057d2:	e8 8e fd ff ff       	call   80105565 <argptr>
801057d7:	83 c4 10             	add    $0x10,%esp
801057da:	85 c0                	test   %eax,%eax
801057dc:	79 07                	jns    801057e5 <sys_read+0x52>
    return -1;
801057de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e3:	eb 17                	jmp    801057fc <sys_read+0x69>
  return fileread(f, p, n);
801057e5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801057e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
801057eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ee:	83 ec 04             	sub    $0x4,%esp
801057f1:	51                   	push   %ecx
801057f2:	52                   	push   %edx
801057f3:	50                   	push   %eax
801057f4:	e8 50 b9 ff ff       	call   80101149 <fileread>
801057f9:	83 c4 10             	add    $0x10,%esp
}
801057fc:	c9                   	leave  
801057fd:	c3                   	ret    

801057fe <sys_write>:

int
sys_write(void)
{
801057fe:	55                   	push   %ebp
801057ff:	89 e5                	mov    %esp,%ebp
80105801:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105804:	83 ec 04             	sub    $0x4,%esp
80105807:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010580a:	50                   	push   %eax
8010580b:	6a 00                	push   $0x0
8010580d:	6a 00                	push   $0x0
8010580f:	e8 68 fe ff ff       	call   8010567c <argfd>
80105814:	83 c4 10             	add    $0x10,%esp
80105817:	85 c0                	test   %eax,%eax
80105819:	78 2e                	js     80105849 <sys_write+0x4b>
8010581b:	83 ec 08             	sub    $0x8,%esp
8010581e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105821:	50                   	push   %eax
80105822:	6a 02                	push   $0x2
80105824:	e8 13 fd ff ff       	call   8010553c <argint>
80105829:	83 c4 10             	add    $0x10,%esp
8010582c:	85 c0                	test   %eax,%eax
8010582e:	78 19                	js     80105849 <sys_write+0x4b>
80105830:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105833:	83 ec 04             	sub    $0x4,%esp
80105836:	50                   	push   %eax
80105837:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010583a:	50                   	push   %eax
8010583b:	6a 01                	push   $0x1
8010583d:	e8 23 fd ff ff       	call   80105565 <argptr>
80105842:	83 c4 10             	add    $0x10,%esp
80105845:	85 c0                	test   %eax,%eax
80105847:	79 07                	jns    80105850 <sys_write+0x52>
    return -1;
80105849:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584e:	eb 17                	jmp    80105867 <sys_write+0x69>
  return filewrite(f, p, n);
80105850:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105853:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105859:	83 ec 04             	sub    $0x4,%esp
8010585c:	51                   	push   %ecx
8010585d:	52                   	push   %edx
8010585e:	50                   	push   %eax
8010585f:	e8 9c b9 ff ff       	call   80101200 <filewrite>
80105864:	83 c4 10             	add    $0x10,%esp
}
80105867:	c9                   	leave  
80105868:	c3                   	ret    

80105869 <sys_close>:

int
sys_close(void)
{
80105869:	55                   	push   %ebp
8010586a:	89 e5                	mov    %esp,%ebp
8010586c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
8010586f:	83 ec 04             	sub    $0x4,%esp
80105872:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105875:	50                   	push   %eax
80105876:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105879:	50                   	push   %eax
8010587a:	6a 00                	push   $0x0
8010587c:	e8 fb fd ff ff       	call   8010567c <argfd>
80105881:	83 c4 10             	add    $0x10,%esp
80105884:	85 c0                	test   %eax,%eax
80105886:	79 07                	jns    8010588f <sys_close+0x26>
    return -1;
80105888:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010588d:	eb 28                	jmp    801058b7 <sys_close+0x4e>
  proc->ofile[fd] = 0;
8010588f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105895:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105898:	83 c2 08             	add    $0x8,%edx
8010589b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801058a2:	00 
  fileclose(f);
801058a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058a6:	83 ec 0c             	sub    $0xc,%esp
801058a9:	50                   	push   %eax
801058aa:	e8 64 b7 ff ff       	call   80101013 <fileclose>
801058af:	83 c4 10             	add    $0x10,%esp
  return 0;
801058b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058b7:	c9                   	leave  
801058b8:	c3                   	ret    

801058b9 <sys_fstat>:

int
sys_fstat(void)
{
801058b9:	55                   	push   %ebp
801058ba:	89 e5                	mov    %esp,%ebp
801058bc:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801058bf:	83 ec 04             	sub    $0x4,%esp
801058c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058c5:	50                   	push   %eax
801058c6:	6a 00                	push   $0x0
801058c8:	6a 00                	push   $0x0
801058ca:	e8 ad fd ff ff       	call   8010567c <argfd>
801058cf:	83 c4 10             	add    $0x10,%esp
801058d2:	85 c0                	test   %eax,%eax
801058d4:	78 17                	js     801058ed <sys_fstat+0x34>
801058d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058d9:	83 ec 04             	sub    $0x4,%esp
801058dc:	6a 14                	push   $0x14
801058de:	50                   	push   %eax
801058df:	6a 01                	push   $0x1
801058e1:	e8 7f fc ff ff       	call   80105565 <argptr>
801058e6:	83 c4 10             	add    $0x10,%esp
801058e9:	85 c0                	test   %eax,%eax
801058eb:	79 07                	jns    801058f4 <sys_fstat+0x3b>
    return -1;
801058ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058f2:	eb 13                	jmp    80105907 <sys_fstat+0x4e>
  return filestat(f, st);
801058f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801058f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058fa:	83 ec 08             	sub    $0x8,%esp
801058fd:	52                   	push   %edx
801058fe:	50                   	push   %eax
801058ff:	e8 ee b7 ff ff       	call   801010f2 <filestat>
80105904:	83 c4 10             	add    $0x10,%esp
}
80105907:	c9                   	leave  
80105908:	c3                   	ret    

80105909 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105909:	55                   	push   %ebp
8010590a:	89 e5                	mov    %esp,%ebp
8010590c:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010590f:	83 ec 08             	sub    $0x8,%esp
80105912:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105915:	50                   	push   %eax
80105916:	6a 00                	push   $0x0
80105918:	e8 a7 fc ff ff       	call   801055c4 <argstr>
8010591d:	83 c4 10             	add    $0x10,%esp
80105920:	85 c0                	test   %eax,%eax
80105922:	78 15                	js     80105939 <sys_link+0x30>
80105924:	83 ec 08             	sub    $0x8,%esp
80105927:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010592a:	50                   	push   %eax
8010592b:	6a 01                	push   $0x1
8010592d:	e8 92 fc ff ff       	call   801055c4 <argstr>
80105932:	83 c4 10             	add    $0x10,%esp
80105935:	85 c0                	test   %eax,%eax
80105937:	79 0a                	jns    80105943 <sys_link+0x3a>
    return -1;
80105939:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010593e:	e9 5f 01 00 00       	jmp    80105aa2 <sys_link+0x199>

  begin_op();
80105943:	e8 89 db ff ff       	call   801034d1 <begin_op>
  if((ip = namei(old)) == 0){
80105948:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010594b:	83 ec 0c             	sub    $0xc,%esp
8010594e:	50                   	push   %eax
8010594f:	e8 74 cb ff ff       	call   801024c8 <namei>
80105954:	83 c4 10             	add    $0x10,%esp
80105957:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010595a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010595e:	75 0f                	jne    8010596f <sys_link+0x66>
    end_op();
80105960:	e8 f5 db ff ff       	call   8010355a <end_op>
    return -1;
80105965:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010596a:	e9 33 01 00 00       	jmp    80105aa2 <sys_link+0x199>
  }

  ilock(ip);
8010596f:	83 ec 0c             	sub    $0xc,%esp
80105972:	ff 75 f4             	pushl  -0xc(%ebp)
80105975:	e8 ac bf ff ff       	call   80101926 <ilock>
8010597a:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
8010597d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105980:	8b 40 10             	mov    0x10(%eax),%eax
80105983:	66 83 f8 01          	cmp    $0x1,%ax
80105987:	75 1d                	jne    801059a6 <sys_link+0x9d>
    iunlockput(ip);
80105989:	83 ec 0c             	sub    $0xc,%esp
8010598c:	ff 75 f4             	pushl  -0xc(%ebp)
8010598f:	e8 4f c2 ff ff       	call   80101be3 <iunlockput>
80105994:	83 c4 10             	add    $0x10,%esp
    end_op();
80105997:	e8 be db ff ff       	call   8010355a <end_op>
    return -1;
8010599c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059a1:	e9 fc 00 00 00       	jmp    80105aa2 <sys_link+0x199>
  }

  ip->nlink++;
801059a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059a9:	66 8b 40 16          	mov    0x16(%eax),%ax
801059ad:	40                   	inc    %eax
801059ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059b1:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
801059b5:	83 ec 0c             	sub    $0xc,%esp
801059b8:	ff 75 f4             	pushl  -0xc(%ebp)
801059bb:	e8 8b bd ff ff       	call   8010174b <iupdate>
801059c0:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
801059c3:	83 ec 0c             	sub    $0xc,%esp
801059c6:	ff 75 f4             	pushl  -0xc(%ebp)
801059c9:	e8 b5 c0 ff ff       	call   80101a83 <iunlock>
801059ce:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
801059d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059d4:	83 ec 08             	sub    $0x8,%esp
801059d7:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801059da:	52                   	push   %edx
801059db:	50                   	push   %eax
801059dc:	e8 03 cb ff ff       	call   801024e4 <nameiparent>
801059e1:	83 c4 10             	add    $0x10,%esp
801059e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801059e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059eb:	74 71                	je     80105a5e <sys_link+0x155>
    goto bad;
  ilock(dp);
801059ed:	83 ec 0c             	sub    $0xc,%esp
801059f0:	ff 75 f0             	pushl  -0x10(%ebp)
801059f3:	e8 2e bf ff ff       	call   80101926 <ilock>
801059f8:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801059fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059fe:	8b 10                	mov    (%eax),%edx
80105a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a03:	8b 00                	mov    (%eax),%eax
80105a05:	39 c2                	cmp    %eax,%edx
80105a07:	75 1d                	jne    80105a26 <sys_link+0x11d>
80105a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a0c:	8b 40 04             	mov    0x4(%eax),%eax
80105a0f:	83 ec 04             	sub    $0x4,%esp
80105a12:	50                   	push   %eax
80105a13:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105a16:	50                   	push   %eax
80105a17:	ff 75 f0             	pushl  -0x10(%ebp)
80105a1a:	e8 19 c8 ff ff       	call   80102238 <dirlink>
80105a1f:	83 c4 10             	add    $0x10,%esp
80105a22:	85 c0                	test   %eax,%eax
80105a24:	79 10                	jns    80105a36 <sys_link+0x12d>
    iunlockput(dp);
80105a26:	83 ec 0c             	sub    $0xc,%esp
80105a29:	ff 75 f0             	pushl  -0x10(%ebp)
80105a2c:	e8 b2 c1 ff ff       	call   80101be3 <iunlockput>
80105a31:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105a34:	eb 29                	jmp    80105a5f <sys_link+0x156>
  }
  iunlockput(dp);
80105a36:	83 ec 0c             	sub    $0xc,%esp
80105a39:	ff 75 f0             	pushl  -0x10(%ebp)
80105a3c:	e8 a2 c1 ff ff       	call   80101be3 <iunlockput>
80105a41:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105a44:	83 ec 0c             	sub    $0xc,%esp
80105a47:	ff 75 f4             	pushl  -0xc(%ebp)
80105a4a:	e8 a5 c0 ff ff       	call   80101af4 <iput>
80105a4f:	83 c4 10             	add    $0x10,%esp

  end_op();
80105a52:	e8 03 db ff ff       	call   8010355a <end_op>

  return 0;
80105a57:	b8 00 00 00 00       	mov    $0x0,%eax
80105a5c:	eb 44                	jmp    80105aa2 <sys_link+0x199>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105a5e:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105a5f:	83 ec 0c             	sub    $0xc,%esp
80105a62:	ff 75 f4             	pushl  -0xc(%ebp)
80105a65:	e8 bc be ff ff       	call   80101926 <ilock>
80105a6a:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a70:	66 8b 40 16          	mov    0x16(%eax),%ax
80105a74:	48                   	dec    %eax
80105a75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a78:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80105a7c:	83 ec 0c             	sub    $0xc,%esp
80105a7f:	ff 75 f4             	pushl  -0xc(%ebp)
80105a82:	e8 c4 bc ff ff       	call   8010174b <iupdate>
80105a87:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105a8a:	83 ec 0c             	sub    $0xc,%esp
80105a8d:	ff 75 f4             	pushl  -0xc(%ebp)
80105a90:	e8 4e c1 ff ff       	call   80101be3 <iunlockput>
80105a95:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a98:	e8 bd da ff ff       	call   8010355a <end_op>
  return -1;
80105a9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aa2:	c9                   	leave  
80105aa3:	c3                   	ret    

80105aa4 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105aa4:	55                   	push   %ebp
80105aa5:	89 e5                	mov    %esp,%ebp
80105aa7:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105aaa:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105ab1:	eb 3f                	jmp    80105af2 <isdirempty+0x4e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ab3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ab6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ab9:	6a 10                	push   $0x10
80105abb:	52                   	push   %edx
80105abc:	50                   	push   %eax
80105abd:	ff 75 08             	pushl  0x8(%ebp)
80105ac0:	e8 af c3 ff ff       	call   80101e74 <readi>
80105ac5:	83 c4 10             	add    $0x10,%esp
80105ac8:	83 f8 10             	cmp    $0x10,%eax
80105acb:	74 0d                	je     80105ada <isdirempty+0x36>
      panic("isdirempty: readi");
80105acd:	83 ec 0c             	sub    $0xc,%esp
80105ad0:	68 cf 88 10 80       	push   $0x801088cf
80105ad5:	e8 88 aa ff ff       	call   80100562 <panic>
    if(de.inum != 0)
80105ada:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105add:	66 85 c0             	test   %ax,%ax
80105ae0:	74 07                	je     80105ae9 <isdirempty+0x45>
      return 0;
80105ae2:	b8 00 00 00 00       	mov    $0x0,%eax
80105ae7:	eb 1b                	jmp    80105b04 <isdirempty+0x60>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aec:	83 c0 10             	add    $0x10,%eax
80105aef:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105af2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105af5:	8b 45 08             	mov    0x8(%ebp),%eax
80105af8:	8b 40 18             	mov    0x18(%eax),%eax
80105afb:	39 c2                	cmp    %eax,%edx
80105afd:	72 b4                	jb     80105ab3 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105aff:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b04:	c9                   	leave  
80105b05:	c3                   	ret    

80105b06 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105b06:	55                   	push   %ebp
80105b07:	89 e5                	mov    %esp,%ebp
80105b09:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105b0c:	83 ec 08             	sub    $0x8,%esp
80105b0f:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105b12:	50                   	push   %eax
80105b13:	6a 00                	push   $0x0
80105b15:	e8 aa fa ff ff       	call   801055c4 <argstr>
80105b1a:	83 c4 10             	add    $0x10,%esp
80105b1d:	85 c0                	test   %eax,%eax
80105b1f:	79 0a                	jns    80105b2b <sys_unlink+0x25>
    return -1;
80105b21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b26:	e9 b2 01 00 00       	jmp    80105cdd <sys_unlink+0x1d7>

  begin_op();
80105b2b:	e8 a1 d9 ff ff       	call   801034d1 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105b30:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105b33:	83 ec 08             	sub    $0x8,%esp
80105b36:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105b39:	52                   	push   %edx
80105b3a:	50                   	push   %eax
80105b3b:	e8 a4 c9 ff ff       	call   801024e4 <nameiparent>
80105b40:	83 c4 10             	add    $0x10,%esp
80105b43:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b4a:	75 0f                	jne    80105b5b <sys_unlink+0x55>
    end_op();
80105b4c:	e8 09 da ff ff       	call   8010355a <end_op>
    return -1;
80105b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b56:	e9 82 01 00 00       	jmp    80105cdd <sys_unlink+0x1d7>
  }

  ilock(dp);
80105b5b:	83 ec 0c             	sub    $0xc,%esp
80105b5e:	ff 75 f4             	pushl  -0xc(%ebp)
80105b61:	e8 c0 bd ff ff       	call   80101926 <ilock>
80105b66:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105b69:	83 ec 08             	sub    $0x8,%esp
80105b6c:	68 e1 88 10 80       	push   $0x801088e1
80105b71:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b74:	50                   	push   %eax
80105b75:	e8 ec c5 ff ff       	call   80102166 <namecmp>
80105b7a:	83 c4 10             	add    $0x10,%esp
80105b7d:	85 c0                	test   %eax,%eax
80105b7f:	0f 84 40 01 00 00    	je     80105cc5 <sys_unlink+0x1bf>
80105b85:	83 ec 08             	sub    $0x8,%esp
80105b88:	68 e3 88 10 80       	push   $0x801088e3
80105b8d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b90:	50                   	push   %eax
80105b91:	e8 d0 c5 ff ff       	call   80102166 <namecmp>
80105b96:	83 c4 10             	add    $0x10,%esp
80105b99:	85 c0                	test   %eax,%eax
80105b9b:	0f 84 24 01 00 00    	je     80105cc5 <sys_unlink+0x1bf>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105ba1:	83 ec 04             	sub    $0x4,%esp
80105ba4:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105ba7:	50                   	push   %eax
80105ba8:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105bab:	50                   	push   %eax
80105bac:	ff 75 f4             	pushl  -0xc(%ebp)
80105baf:	e8 cd c5 ff ff       	call   80102181 <dirlookup>
80105bb4:	83 c4 10             	add    $0x10,%esp
80105bb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105bba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105bbe:	0f 84 00 01 00 00    	je     80105cc4 <sys_unlink+0x1be>
    goto bad;
  ilock(ip);
80105bc4:	83 ec 0c             	sub    $0xc,%esp
80105bc7:	ff 75 f0             	pushl  -0x10(%ebp)
80105bca:	e8 57 bd ff ff       	call   80101926 <ilock>
80105bcf:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bd5:	66 8b 40 16          	mov    0x16(%eax),%ax
80105bd9:	66 85 c0             	test   %ax,%ax
80105bdc:	7f 0d                	jg     80105beb <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105bde:	83 ec 0c             	sub    $0xc,%esp
80105be1:	68 e6 88 10 80       	push   $0x801088e6
80105be6:	e8 77 a9 ff ff       	call   80100562 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bee:	8b 40 10             	mov    0x10(%eax),%eax
80105bf1:	66 83 f8 01          	cmp    $0x1,%ax
80105bf5:	75 25                	jne    80105c1c <sys_unlink+0x116>
80105bf7:	83 ec 0c             	sub    $0xc,%esp
80105bfa:	ff 75 f0             	pushl  -0x10(%ebp)
80105bfd:	e8 a2 fe ff ff       	call   80105aa4 <isdirempty>
80105c02:	83 c4 10             	add    $0x10,%esp
80105c05:	85 c0                	test   %eax,%eax
80105c07:	75 13                	jne    80105c1c <sys_unlink+0x116>
    iunlockput(ip);
80105c09:	83 ec 0c             	sub    $0xc,%esp
80105c0c:	ff 75 f0             	pushl  -0x10(%ebp)
80105c0f:	e8 cf bf ff ff       	call   80101be3 <iunlockput>
80105c14:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105c17:	e9 a9 00 00 00       	jmp    80105cc5 <sys_unlink+0x1bf>
  }

  memset(&de, 0, sizeof(de));
80105c1c:	83 ec 04             	sub    $0x4,%esp
80105c1f:	6a 10                	push   $0x10
80105c21:	6a 00                	push   $0x0
80105c23:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c26:	50                   	push   %eax
80105c27:	e8 f2 f5 ff ff       	call   8010521e <memset>
80105c2c:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c2f:	8b 55 c8             	mov    -0x38(%ebp),%edx
80105c32:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c35:	6a 10                	push   $0x10
80105c37:	52                   	push   %edx
80105c38:	50                   	push   %eax
80105c39:	ff 75 f4             	pushl  -0xc(%ebp)
80105c3c:	e8 93 c3 ff ff       	call   80101fd4 <writei>
80105c41:	83 c4 10             	add    $0x10,%esp
80105c44:	83 f8 10             	cmp    $0x10,%eax
80105c47:	74 0d                	je     80105c56 <sys_unlink+0x150>
    panic("unlink: writei");
80105c49:	83 ec 0c             	sub    $0xc,%esp
80105c4c:	68 f8 88 10 80       	push   $0x801088f8
80105c51:	e8 0c a9 ff ff       	call   80100562 <panic>
  if(ip->type == T_DIR){
80105c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c59:	8b 40 10             	mov    0x10(%eax),%eax
80105c5c:	66 83 f8 01          	cmp    $0x1,%ax
80105c60:	75 1d                	jne    80105c7f <sys_unlink+0x179>
    dp->nlink--;
80105c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c65:	66 8b 40 16          	mov    0x16(%eax),%ax
80105c69:	48                   	dec    %eax
80105c6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c6d:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80105c71:	83 ec 0c             	sub    $0xc,%esp
80105c74:	ff 75 f4             	pushl  -0xc(%ebp)
80105c77:	e8 cf ba ff ff       	call   8010174b <iupdate>
80105c7c:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105c7f:	83 ec 0c             	sub    $0xc,%esp
80105c82:	ff 75 f4             	pushl  -0xc(%ebp)
80105c85:	e8 59 bf ff ff       	call   80101be3 <iunlockput>
80105c8a:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c90:	66 8b 40 16          	mov    0x16(%eax),%ax
80105c94:	48                   	dec    %eax
80105c95:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c98:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80105c9c:	83 ec 0c             	sub    $0xc,%esp
80105c9f:	ff 75 f0             	pushl  -0x10(%ebp)
80105ca2:	e8 a4 ba ff ff       	call   8010174b <iupdate>
80105ca7:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105caa:	83 ec 0c             	sub    $0xc,%esp
80105cad:	ff 75 f0             	pushl  -0x10(%ebp)
80105cb0:	e8 2e bf ff ff       	call   80101be3 <iunlockput>
80105cb5:	83 c4 10             	add    $0x10,%esp

  end_op();
80105cb8:	e8 9d d8 ff ff       	call   8010355a <end_op>

  return 0;
80105cbd:	b8 00 00 00 00       	mov    $0x0,%eax
80105cc2:	eb 19                	jmp    80105cdd <sys_unlink+0x1d7>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105cc4:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105cc5:	83 ec 0c             	sub    $0xc,%esp
80105cc8:	ff 75 f4             	pushl  -0xc(%ebp)
80105ccb:	e8 13 bf ff ff       	call   80101be3 <iunlockput>
80105cd0:	83 c4 10             	add    $0x10,%esp
  end_op();
80105cd3:	e8 82 d8 ff ff       	call   8010355a <end_op>
  return -1;
80105cd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cdd:	c9                   	leave  
80105cde:	c3                   	ret    

80105cdf <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105cdf:	55                   	push   %ebp
80105ce0:	89 e5                	mov    %esp,%ebp
80105ce2:	83 ec 38             	sub    $0x38,%esp
80105ce5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105ce8:	8b 55 10             	mov    0x10(%ebp),%edx
80105ceb:	8b 45 14             	mov    0x14(%ebp),%eax
80105cee:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105cf2:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105cf6:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105cfa:	83 ec 08             	sub    $0x8,%esp
80105cfd:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d00:	50                   	push   %eax
80105d01:	ff 75 08             	pushl  0x8(%ebp)
80105d04:	e8 db c7 ff ff       	call   801024e4 <nameiparent>
80105d09:	83 c4 10             	add    $0x10,%esp
80105d0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d13:	75 0a                	jne    80105d1f <create+0x40>
    return 0;
80105d15:	b8 00 00 00 00       	mov    $0x0,%eax
80105d1a:	e9 89 01 00 00       	jmp    80105ea8 <create+0x1c9>
  ilock(dp);
80105d1f:	83 ec 0c             	sub    $0xc,%esp
80105d22:	ff 75 f4             	pushl  -0xc(%ebp)
80105d25:	e8 fc bb ff ff       	call   80101926 <ilock>
80105d2a:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105d2d:	83 ec 04             	sub    $0x4,%esp
80105d30:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d33:	50                   	push   %eax
80105d34:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d37:	50                   	push   %eax
80105d38:	ff 75 f4             	pushl  -0xc(%ebp)
80105d3b:	e8 41 c4 ff ff       	call   80102181 <dirlookup>
80105d40:	83 c4 10             	add    $0x10,%esp
80105d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d4a:	74 4f                	je     80105d9b <create+0xbc>
    iunlockput(dp);
80105d4c:	83 ec 0c             	sub    $0xc,%esp
80105d4f:	ff 75 f4             	pushl  -0xc(%ebp)
80105d52:	e8 8c be ff ff       	call   80101be3 <iunlockput>
80105d57:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105d5a:	83 ec 0c             	sub    $0xc,%esp
80105d5d:	ff 75 f0             	pushl  -0x10(%ebp)
80105d60:	e8 c1 bb ff ff       	call   80101926 <ilock>
80105d65:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105d68:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105d6d:	75 14                	jne    80105d83 <create+0xa4>
80105d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d72:	8b 40 10             	mov    0x10(%eax),%eax
80105d75:	66 83 f8 02          	cmp    $0x2,%ax
80105d79:	75 08                	jne    80105d83 <create+0xa4>
      return ip;
80105d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d7e:	e9 25 01 00 00       	jmp    80105ea8 <create+0x1c9>
    iunlockput(ip);
80105d83:	83 ec 0c             	sub    $0xc,%esp
80105d86:	ff 75 f0             	pushl  -0x10(%ebp)
80105d89:	e8 55 be ff ff       	call   80101be3 <iunlockput>
80105d8e:	83 c4 10             	add    $0x10,%esp
    return 0;
80105d91:	b8 00 00 00 00       	mov    $0x0,%eax
80105d96:	e9 0d 01 00 00       	jmp    80105ea8 <create+0x1c9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105d9b:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da2:	8b 00                	mov    (%eax),%eax
80105da4:	83 ec 08             	sub    $0x8,%esp
80105da7:	52                   	push   %edx
80105da8:	50                   	push   %eax
80105da9:	e8 cb b8 ff ff       	call   80101679 <ialloc>
80105dae:	83 c4 10             	add    $0x10,%esp
80105db1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105db4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105db8:	75 0d                	jne    80105dc7 <create+0xe8>
    panic("create: ialloc");
80105dba:	83 ec 0c             	sub    $0xc,%esp
80105dbd:	68 07 89 10 80       	push   $0x80108907
80105dc2:	e8 9b a7 ff ff       	call   80100562 <panic>

  ilock(ip);
80105dc7:	83 ec 0c             	sub    $0xc,%esp
80105dca:	ff 75 f0             	pushl  -0x10(%ebp)
80105dcd:	e8 54 bb ff ff       	call   80101926 <ilock>
80105dd2:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105dd5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105dd8:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105ddb:	66 89 42 12          	mov    %ax,0x12(%edx)
  ip->minor = minor;
80105ddf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105de2:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105de5:	66 89 42 14          	mov    %ax,0x14(%edx)
  ip->nlink = 1;
80105de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dec:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105df2:	83 ec 0c             	sub    $0xc,%esp
80105df5:	ff 75 f0             	pushl  -0x10(%ebp)
80105df8:	e8 4e b9 ff ff       	call   8010174b <iupdate>
80105dfd:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105e00:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105e05:	75 66                	jne    80105e6d <create+0x18e>
    dp->nlink++;  // for ".."
80105e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e0a:	66 8b 40 16          	mov    0x16(%eax),%ax
80105e0e:	40                   	inc    %eax
80105e0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e12:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80105e16:	83 ec 0c             	sub    $0xc,%esp
80105e19:	ff 75 f4             	pushl  -0xc(%ebp)
80105e1c:	e8 2a b9 ff ff       	call   8010174b <iupdate>
80105e21:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e27:	8b 40 04             	mov    0x4(%eax),%eax
80105e2a:	83 ec 04             	sub    $0x4,%esp
80105e2d:	50                   	push   %eax
80105e2e:	68 e1 88 10 80       	push   $0x801088e1
80105e33:	ff 75 f0             	pushl  -0x10(%ebp)
80105e36:	e8 fd c3 ff ff       	call   80102238 <dirlink>
80105e3b:	83 c4 10             	add    $0x10,%esp
80105e3e:	85 c0                	test   %eax,%eax
80105e40:	78 1e                	js     80105e60 <create+0x181>
80105e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e45:	8b 40 04             	mov    0x4(%eax),%eax
80105e48:	83 ec 04             	sub    $0x4,%esp
80105e4b:	50                   	push   %eax
80105e4c:	68 e3 88 10 80       	push   $0x801088e3
80105e51:	ff 75 f0             	pushl  -0x10(%ebp)
80105e54:	e8 df c3 ff ff       	call   80102238 <dirlink>
80105e59:	83 c4 10             	add    $0x10,%esp
80105e5c:	85 c0                	test   %eax,%eax
80105e5e:	79 0d                	jns    80105e6d <create+0x18e>
      panic("create dots");
80105e60:	83 ec 0c             	sub    $0xc,%esp
80105e63:	68 16 89 10 80       	push   $0x80108916
80105e68:	e8 f5 a6 ff ff       	call   80100562 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e70:	8b 40 04             	mov    0x4(%eax),%eax
80105e73:	83 ec 04             	sub    $0x4,%esp
80105e76:	50                   	push   %eax
80105e77:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e7a:	50                   	push   %eax
80105e7b:	ff 75 f4             	pushl  -0xc(%ebp)
80105e7e:	e8 b5 c3 ff ff       	call   80102238 <dirlink>
80105e83:	83 c4 10             	add    $0x10,%esp
80105e86:	85 c0                	test   %eax,%eax
80105e88:	79 0d                	jns    80105e97 <create+0x1b8>
    panic("create: dirlink");
80105e8a:	83 ec 0c             	sub    $0xc,%esp
80105e8d:	68 22 89 10 80       	push   $0x80108922
80105e92:	e8 cb a6 ff ff       	call   80100562 <panic>

  iunlockput(dp);
80105e97:	83 ec 0c             	sub    $0xc,%esp
80105e9a:	ff 75 f4             	pushl  -0xc(%ebp)
80105e9d:	e8 41 bd ff ff       	call   80101be3 <iunlockput>
80105ea2:	83 c4 10             	add    $0x10,%esp

  return ip;
80105ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105ea8:	c9                   	leave  
80105ea9:	c3                   	ret    

80105eaa <sys_open>:

int
sys_open(void)
{
80105eaa:	55                   	push   %ebp
80105eab:	89 e5                	mov    %esp,%ebp
80105ead:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105eb0:	83 ec 08             	sub    $0x8,%esp
80105eb3:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105eb6:	50                   	push   %eax
80105eb7:	6a 00                	push   $0x0
80105eb9:	e8 06 f7 ff ff       	call   801055c4 <argstr>
80105ebe:	83 c4 10             	add    $0x10,%esp
80105ec1:	85 c0                	test   %eax,%eax
80105ec3:	78 15                	js     80105eda <sys_open+0x30>
80105ec5:	83 ec 08             	sub    $0x8,%esp
80105ec8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ecb:	50                   	push   %eax
80105ecc:	6a 01                	push   $0x1
80105ece:	e8 69 f6 ff ff       	call   8010553c <argint>
80105ed3:	83 c4 10             	add    $0x10,%esp
80105ed6:	85 c0                	test   %eax,%eax
80105ed8:	79 0a                	jns    80105ee4 <sys_open+0x3a>
    return -1;
80105eda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105edf:	e9 5e 01 00 00       	jmp    80106042 <sys_open+0x198>

  begin_op();
80105ee4:	e8 e8 d5 ff ff       	call   801034d1 <begin_op>

  if(omode & O_CREATE){
80105ee9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105eec:	25 00 02 00 00       	and    $0x200,%eax
80105ef1:	85 c0                	test   %eax,%eax
80105ef3:	74 2a                	je     80105f1f <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80105ef5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ef8:	6a 00                	push   $0x0
80105efa:	6a 00                	push   $0x0
80105efc:	6a 02                	push   $0x2
80105efe:	50                   	push   %eax
80105eff:	e8 db fd ff ff       	call   80105cdf <create>
80105f04:	83 c4 10             	add    $0x10,%esp
80105f07:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105f0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f0e:	75 74                	jne    80105f84 <sys_open+0xda>
      end_op();
80105f10:	e8 45 d6 ff ff       	call   8010355a <end_op>
      return -1;
80105f15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f1a:	e9 23 01 00 00       	jmp    80106042 <sys_open+0x198>
    }
  } else {
    if((ip = namei(path)) == 0){
80105f1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f22:	83 ec 0c             	sub    $0xc,%esp
80105f25:	50                   	push   %eax
80105f26:	e8 9d c5 ff ff       	call   801024c8 <namei>
80105f2b:	83 c4 10             	add    $0x10,%esp
80105f2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f35:	75 0f                	jne    80105f46 <sys_open+0x9c>
      end_op();
80105f37:	e8 1e d6 ff ff       	call   8010355a <end_op>
      return -1;
80105f3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f41:	e9 fc 00 00 00       	jmp    80106042 <sys_open+0x198>
    }
    ilock(ip);
80105f46:	83 ec 0c             	sub    $0xc,%esp
80105f49:	ff 75 f4             	pushl  -0xc(%ebp)
80105f4c:	e8 d5 b9 ff ff       	call   80101926 <ilock>
80105f51:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f57:	8b 40 10             	mov    0x10(%eax),%eax
80105f5a:	66 83 f8 01          	cmp    $0x1,%ax
80105f5e:	75 24                	jne    80105f84 <sys_open+0xda>
80105f60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f63:	85 c0                	test   %eax,%eax
80105f65:	74 1d                	je     80105f84 <sys_open+0xda>
      iunlockput(ip);
80105f67:	83 ec 0c             	sub    $0xc,%esp
80105f6a:	ff 75 f4             	pushl  -0xc(%ebp)
80105f6d:	e8 71 bc ff ff       	call   80101be3 <iunlockput>
80105f72:	83 c4 10             	add    $0x10,%esp
      end_op();
80105f75:	e8 e0 d5 ff ff       	call   8010355a <end_op>
      return -1;
80105f7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f7f:	e9 be 00 00 00       	jmp    80106042 <sys_open+0x198>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105f84:	e8 cc af ff ff       	call   80100f55 <filealloc>
80105f89:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f90:	74 17                	je     80105fa9 <sys_open+0xff>
80105f92:	83 ec 0c             	sub    $0xc,%esp
80105f95:	ff 75 f0             	pushl  -0x10(%ebp)
80105f98:	e8 54 f7 ff ff       	call   801056f1 <fdalloc>
80105f9d:	83 c4 10             	add    $0x10,%esp
80105fa0:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105fa3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105fa7:	79 2e                	jns    80105fd7 <sys_open+0x12d>
    if(f)
80105fa9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fad:	74 0e                	je     80105fbd <sys_open+0x113>
      fileclose(f);
80105faf:	83 ec 0c             	sub    $0xc,%esp
80105fb2:	ff 75 f0             	pushl  -0x10(%ebp)
80105fb5:	e8 59 b0 ff ff       	call   80101013 <fileclose>
80105fba:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105fbd:	83 ec 0c             	sub    $0xc,%esp
80105fc0:	ff 75 f4             	pushl  -0xc(%ebp)
80105fc3:	e8 1b bc ff ff       	call   80101be3 <iunlockput>
80105fc8:	83 c4 10             	add    $0x10,%esp
    end_op();
80105fcb:	e8 8a d5 ff ff       	call   8010355a <end_op>
    return -1;
80105fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fd5:	eb 6b                	jmp    80106042 <sys_open+0x198>
  }
  iunlock(ip);
80105fd7:	83 ec 0c             	sub    $0xc,%esp
80105fda:	ff 75 f4             	pushl  -0xc(%ebp)
80105fdd:	e8 a1 ba ff ff       	call   80101a83 <iunlock>
80105fe2:	83 c4 10             	add    $0x10,%esp
  end_op();
80105fe5:	e8 70 d5 ff ff       	call   8010355a <end_op>

  f->type = FD_INODE;
80105fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fed:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ff6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ff9:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fff:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106009:	83 e0 01             	and    $0x1,%eax
8010600c:	85 c0                	test   %eax,%eax
8010600e:	0f 94 c2             	sete   %dl
80106011:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106014:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106017:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010601a:	83 e0 01             	and    $0x1,%eax
8010601d:	84 c0                	test   %al,%al
8010601f:	75 0a                	jne    8010602b <sys_open+0x181>
80106021:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106024:	83 e0 02             	and    $0x2,%eax
80106027:	85 c0                	test   %eax,%eax
80106029:	74 07                	je     80106032 <sys_open+0x188>
8010602b:	b8 01 00 00 00       	mov    $0x1,%eax
80106030:	eb 05                	jmp    80106037 <sys_open+0x18d>
80106032:	b8 00 00 00 00       	mov    $0x0,%eax
80106037:	88 c2                	mov    %al,%dl
80106039:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010603c:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010603f:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106042:	c9                   	leave  
80106043:	c3                   	ret    

80106044 <sys_mkdir>:

int
sys_mkdir(void)
{
80106044:	55                   	push   %ebp
80106045:	89 e5                	mov    %esp,%ebp
80106047:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010604a:	e8 82 d4 ff ff       	call   801034d1 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010604f:	83 ec 08             	sub    $0x8,%esp
80106052:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106055:	50                   	push   %eax
80106056:	6a 00                	push   $0x0
80106058:	e8 67 f5 ff ff       	call   801055c4 <argstr>
8010605d:	83 c4 10             	add    $0x10,%esp
80106060:	85 c0                	test   %eax,%eax
80106062:	78 1b                	js     8010607f <sys_mkdir+0x3b>
80106064:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106067:	6a 00                	push   $0x0
80106069:	6a 00                	push   $0x0
8010606b:	6a 01                	push   $0x1
8010606d:	50                   	push   %eax
8010606e:	e8 6c fc ff ff       	call   80105cdf <create>
80106073:	83 c4 10             	add    $0x10,%esp
80106076:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106079:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010607d:	75 0c                	jne    8010608b <sys_mkdir+0x47>
    end_op();
8010607f:	e8 d6 d4 ff ff       	call   8010355a <end_op>
    return -1;
80106084:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106089:	eb 18                	jmp    801060a3 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
8010608b:	83 ec 0c             	sub    $0xc,%esp
8010608e:	ff 75 f4             	pushl  -0xc(%ebp)
80106091:	e8 4d bb ff ff       	call   80101be3 <iunlockput>
80106096:	83 c4 10             	add    $0x10,%esp
  end_op();
80106099:	e8 bc d4 ff ff       	call   8010355a <end_op>
  return 0;
8010609e:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060a3:	c9                   	leave  
801060a4:	c3                   	ret    

801060a5 <sys_mknod>:

int
sys_mknod(void)
{
801060a5:	55                   	push   %ebp
801060a6:	89 e5                	mov    %esp,%ebp
801060a8:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
801060ab:	e8 21 d4 ff ff       	call   801034d1 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
801060b0:	83 ec 08             	sub    $0x8,%esp
801060b3:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060b6:	50                   	push   %eax
801060b7:	6a 00                	push   $0x0
801060b9:	e8 06 f5 ff ff       	call   801055c4 <argstr>
801060be:	83 c4 10             	add    $0x10,%esp
801060c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060c8:	78 4f                	js     80106119 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801060ca:	83 ec 08             	sub    $0x8,%esp
801060cd:	8d 45 e8             	lea    -0x18(%ebp),%eax
801060d0:	50                   	push   %eax
801060d1:	6a 01                	push   $0x1
801060d3:	e8 64 f4 ff ff       	call   8010553c <argint>
801060d8:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801060db:	85 c0                	test   %eax,%eax
801060dd:	78 3a                	js     80106119 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801060df:	83 ec 08             	sub    $0x8,%esp
801060e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060e5:	50                   	push   %eax
801060e6:	6a 02                	push   $0x2
801060e8:	e8 4f f4 ff ff       	call   8010553c <argint>
801060ed:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801060f0:	85 c0                	test   %eax,%eax
801060f2:	78 25                	js     80106119 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801060f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060f7:	0f bf c8             	movswl %ax,%ecx
801060fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060fd:	0f bf d0             	movswl %ax,%edx
80106100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106103:	51                   	push   %ecx
80106104:	52                   	push   %edx
80106105:	6a 03                	push   $0x3
80106107:	50                   	push   %eax
80106108:	e8 d2 fb ff ff       	call   80105cdf <create>
8010610d:	83 c4 10             	add    $0x10,%esp
80106110:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106113:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106117:	75 0c                	jne    80106125 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106119:	e8 3c d4 ff ff       	call   8010355a <end_op>
    return -1;
8010611e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106123:	eb 18                	jmp    8010613d <sys_mknod+0x98>
  }
  iunlockput(ip);
80106125:	83 ec 0c             	sub    $0xc,%esp
80106128:	ff 75 f0             	pushl  -0x10(%ebp)
8010612b:	e8 b3 ba ff ff       	call   80101be3 <iunlockput>
80106130:	83 c4 10             	add    $0x10,%esp
  end_op();
80106133:	e8 22 d4 ff ff       	call   8010355a <end_op>
  return 0;
80106138:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010613d:	c9                   	leave  
8010613e:	c3                   	ret    

8010613f <sys_chdir>:

int
sys_chdir(void)
{
8010613f:	55                   	push   %ebp
80106140:	89 e5                	mov    %esp,%ebp
80106142:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106145:	e8 87 d3 ff ff       	call   801034d1 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010614a:	83 ec 08             	sub    $0x8,%esp
8010614d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106150:	50                   	push   %eax
80106151:	6a 00                	push   $0x0
80106153:	e8 6c f4 ff ff       	call   801055c4 <argstr>
80106158:	83 c4 10             	add    $0x10,%esp
8010615b:	85 c0                	test   %eax,%eax
8010615d:	78 18                	js     80106177 <sys_chdir+0x38>
8010615f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106162:	83 ec 0c             	sub    $0xc,%esp
80106165:	50                   	push   %eax
80106166:	e8 5d c3 ff ff       	call   801024c8 <namei>
8010616b:	83 c4 10             	add    $0x10,%esp
8010616e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106171:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106175:	75 0c                	jne    80106183 <sys_chdir+0x44>
    end_op();
80106177:	e8 de d3 ff ff       	call   8010355a <end_op>
    return -1;
8010617c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106181:	eb 6d                	jmp    801061f0 <sys_chdir+0xb1>
  }
  ilock(ip);
80106183:	83 ec 0c             	sub    $0xc,%esp
80106186:	ff 75 f4             	pushl  -0xc(%ebp)
80106189:	e8 98 b7 ff ff       	call   80101926 <ilock>
8010618e:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80106191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106194:	8b 40 10             	mov    0x10(%eax),%eax
80106197:	66 83 f8 01          	cmp    $0x1,%ax
8010619b:	74 1a                	je     801061b7 <sys_chdir+0x78>
    iunlockput(ip);
8010619d:	83 ec 0c             	sub    $0xc,%esp
801061a0:	ff 75 f4             	pushl  -0xc(%ebp)
801061a3:	e8 3b ba ff ff       	call   80101be3 <iunlockput>
801061a8:	83 c4 10             	add    $0x10,%esp
    end_op();
801061ab:	e8 aa d3 ff ff       	call   8010355a <end_op>
    return -1;
801061b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061b5:	eb 39                	jmp    801061f0 <sys_chdir+0xb1>
  }
  iunlock(ip);
801061b7:	83 ec 0c             	sub    $0xc,%esp
801061ba:	ff 75 f4             	pushl  -0xc(%ebp)
801061bd:	e8 c1 b8 ff ff       	call   80101a83 <iunlock>
801061c2:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
801061c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061cb:	8b 40 68             	mov    0x68(%eax),%eax
801061ce:	83 ec 0c             	sub    $0xc,%esp
801061d1:	50                   	push   %eax
801061d2:	e8 1d b9 ff ff       	call   80101af4 <iput>
801061d7:	83 c4 10             	add    $0x10,%esp
  end_op();
801061da:	e8 7b d3 ff ff       	call   8010355a <end_op>
  proc->cwd = ip;
801061df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061e8:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801061eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061f0:	c9                   	leave  
801061f1:	c3                   	ret    

801061f2 <sys_exec>:

int
sys_exec(void)
{
801061f2:	55                   	push   %ebp
801061f3:	89 e5                	mov    %esp,%ebp
801061f5:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801061fb:	83 ec 08             	sub    $0x8,%esp
801061fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106201:	50                   	push   %eax
80106202:	6a 00                	push   $0x0
80106204:	e8 bb f3 ff ff       	call   801055c4 <argstr>
80106209:	83 c4 10             	add    $0x10,%esp
8010620c:	85 c0                	test   %eax,%eax
8010620e:	78 18                	js     80106228 <sys_exec+0x36>
80106210:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106216:	83 ec 08             	sub    $0x8,%esp
80106219:	50                   	push   %eax
8010621a:	6a 01                	push   $0x1
8010621c:	e8 1b f3 ff ff       	call   8010553c <argint>
80106221:	83 c4 10             	add    $0x10,%esp
80106224:	85 c0                	test   %eax,%eax
80106226:	79 0a                	jns    80106232 <sys_exec+0x40>
    return -1;
80106228:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010622d:	e9 ca 00 00 00       	jmp    801062fc <sys_exec+0x10a>
  }
  memset(argv, 0, sizeof(argv));
80106232:	83 ec 04             	sub    $0x4,%esp
80106235:	68 80 00 00 00       	push   $0x80
8010623a:	6a 00                	push   $0x0
8010623c:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106242:	50                   	push   %eax
80106243:	e8 d6 ef ff ff       	call   8010521e <memset>
80106248:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
8010624b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106252:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106255:	83 f8 1f             	cmp    $0x1f,%eax
80106258:	76 0a                	jbe    80106264 <sys_exec+0x72>
      return -1;
8010625a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010625f:	e9 98 00 00 00       	jmp    801062fc <sys_exec+0x10a>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106264:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010626a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010626d:	c1 e2 02             	shl    $0x2,%edx
80106270:	89 d1                	mov    %edx,%ecx
80106272:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
80106278:	8d 14 11             	lea    (%ecx,%edx,1),%edx
8010627b:	83 ec 08             	sub    $0x8,%esp
8010627e:	50                   	push   %eax
8010627f:	52                   	push   %edx
80106280:	e8 1b f2 ff ff       	call   801054a0 <fetchint>
80106285:	83 c4 10             	add    $0x10,%esp
80106288:	85 c0                	test   %eax,%eax
8010628a:	79 07                	jns    80106293 <sys_exec+0xa1>
      return -1;
8010628c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106291:	eb 69                	jmp    801062fc <sys_exec+0x10a>
    if(uarg == 0){
80106293:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106299:	85 c0                	test   %eax,%eax
8010629b:	75 26                	jne    801062c3 <sys_exec+0xd1>
      argv[i] = 0;
8010629d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062a0:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801062a7:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801062ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062ae:	83 ec 08             	sub    $0x8,%esp
801062b1:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801062b7:	52                   	push   %edx
801062b8:	50                   	push   %eax
801062b9:	e8 9e a8 ff ff       	call   80100b5c <exec>
801062be:	83 c4 10             	add    $0x10,%esp
801062c1:	eb 39                	jmp    801062fc <sys_exec+0x10a>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801062c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801062cd:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801062d3:	8d 14 10             	lea    (%eax,%edx,1),%edx
801062d6:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801062dc:	83 ec 08             	sub    $0x8,%esp
801062df:	52                   	push   %edx
801062e0:	50                   	push   %eax
801062e1:	e8 f4 f1 ff ff       	call   801054da <fetchstr>
801062e6:	83 c4 10             	add    $0x10,%esp
801062e9:	85 c0                	test   %eax,%eax
801062eb:	79 07                	jns    801062f4 <sys_exec+0x102>
      return -1;
801062ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062f2:	eb 08                	jmp    801062fc <sys_exec+0x10a>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801062f4:	ff 45 f4             	incl   -0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801062f7:	e9 56 ff ff ff       	jmp    80106252 <sys_exec+0x60>
  return exec(path, argv);
}
801062fc:	c9                   	leave  
801062fd:	c3                   	ret    

801062fe <sys_pipe>:

int
sys_pipe(void)
{
801062fe:	55                   	push   %ebp
801062ff:	89 e5                	mov    %esp,%ebp
80106301:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106304:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106307:	83 ec 04             	sub    $0x4,%esp
8010630a:	6a 08                	push   $0x8
8010630c:	50                   	push   %eax
8010630d:	6a 00                	push   $0x0
8010630f:	e8 51 f2 ff ff       	call   80105565 <argptr>
80106314:	83 c4 10             	add    $0x10,%esp
80106317:	85 c0                	test   %eax,%eax
80106319:	79 0a                	jns    80106325 <sys_pipe+0x27>
    return -1;
8010631b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106320:	e9 af 00 00 00       	jmp    801063d4 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80106325:	83 ec 08             	sub    $0x8,%esp
80106328:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010632b:	50                   	push   %eax
8010632c:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010632f:	50                   	push   %eax
80106330:	e8 d3 dc ff ff       	call   80104008 <pipealloc>
80106335:	83 c4 10             	add    $0x10,%esp
80106338:	85 c0                	test   %eax,%eax
8010633a:	79 0a                	jns    80106346 <sys_pipe+0x48>
    return -1;
8010633c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106341:	e9 8e 00 00 00       	jmp    801063d4 <sys_pipe+0xd6>
  fd0 = -1;
80106346:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010634d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106350:	83 ec 0c             	sub    $0xc,%esp
80106353:	50                   	push   %eax
80106354:	e8 98 f3 ff ff       	call   801056f1 <fdalloc>
80106359:	83 c4 10             	add    $0x10,%esp
8010635c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010635f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106363:	78 18                	js     8010637d <sys_pipe+0x7f>
80106365:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106368:	83 ec 0c             	sub    $0xc,%esp
8010636b:	50                   	push   %eax
8010636c:	e8 80 f3 ff ff       	call   801056f1 <fdalloc>
80106371:	83 c4 10             	add    $0x10,%esp
80106374:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106377:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010637b:	79 3f                	jns    801063bc <sys_pipe+0xbe>
    if(fd0 >= 0)
8010637d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106381:	78 14                	js     80106397 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80106383:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106389:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010638c:	83 c2 08             	add    $0x8,%edx
8010638f:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106396:	00 
    fileclose(rf);
80106397:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010639a:	83 ec 0c             	sub    $0xc,%esp
8010639d:	50                   	push   %eax
8010639e:	e8 70 ac ff ff       	call   80101013 <fileclose>
801063a3:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
801063a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063a9:	83 ec 0c             	sub    $0xc,%esp
801063ac:	50                   	push   %eax
801063ad:	e8 61 ac ff ff       	call   80101013 <fileclose>
801063b2:	83 c4 10             	add    $0x10,%esp
    return -1;
801063b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063ba:	eb 18                	jmp    801063d4 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
801063bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801063bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063c2:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801063c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801063c7:	8d 50 04             	lea    0x4(%eax),%edx
801063ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063cd:	89 02                	mov    %eax,(%edx)
  return 0;
801063cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063d4:	c9                   	leave  
801063d5:	c3                   	ret    
	...

801063d8 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801063d8:	55                   	push   %ebp
801063d9:	89 e5                	mov    %esp,%ebp
801063db:	83 ec 08             	sub    $0x8,%esp
  return fork();
801063de:	e8 12 e3 ff ff       	call   801046f5 <fork>
}
801063e3:	c9                   	leave  
801063e4:	c3                   	ret    

801063e5 <sys_exit>:

int
sys_exit(void)
{
801063e5:	55                   	push   %ebp
801063e6:	89 e5                	mov    %esp,%ebp
801063e8:	83 ec 08             	sub    $0x8,%esp
  exit();
801063eb:	e8 92 e4 ff ff       	call   80104882 <exit>
  return 0;  // not reached
801063f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063f5:	c9                   	leave  
801063f6:	c3                   	ret    

801063f7 <sys_wait>:

int
sys_wait(void)
{
801063f7:	55                   	push   %ebp
801063f8:	89 e5                	mov    %esp,%ebp
801063fa:	83 ec 08             	sub    $0x8,%esp
  return wait();
801063fd:	e8 b8 e5 ff ff       	call   801049ba <wait>
}
80106402:	c9                   	leave  
80106403:	c3                   	ret    

80106404 <sys_kill>:

int
sys_kill(void)
{
80106404:	55                   	push   %ebp
80106405:	89 e5                	mov    %esp,%ebp
80106407:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010640a:	83 ec 08             	sub    $0x8,%esp
8010640d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106410:	50                   	push   %eax
80106411:	6a 00                	push   $0x0
80106413:	e8 24 f1 ff ff       	call   8010553c <argint>
80106418:	83 c4 10             	add    $0x10,%esp
8010641b:	85 c0                	test   %eax,%eax
8010641d:	79 07                	jns    80106426 <sys_kill+0x22>
    return -1;
8010641f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106424:	eb 0f                	jmp    80106435 <sys_kill+0x31>
  return kill(pid);
80106426:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106429:	83 ec 0c             	sub    $0xc,%esp
8010642c:	50                   	push   %eax
8010642d:	e8 ad e9 ff ff       	call   80104ddf <kill>
80106432:	83 c4 10             	add    $0x10,%esp
}
80106435:	c9                   	leave  
80106436:	c3                   	ret    

80106437 <sys_getpid>:

int
sys_getpid(void)
{
80106437:	55                   	push   %ebp
80106438:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010643a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106440:	8b 40 10             	mov    0x10(%eax),%eax
}
80106443:	c9                   	leave  
80106444:	c3                   	ret    

80106445 <sys_sbrk>:

int
sys_sbrk(void)
{
80106445:	55                   	push   %ebp
80106446:	89 e5                	mov    %esp,%ebp
80106448:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010644b:	83 ec 08             	sub    $0x8,%esp
8010644e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106451:	50                   	push   %eax
80106452:	6a 00                	push   $0x0
80106454:	e8 e3 f0 ff ff       	call   8010553c <argint>
80106459:	83 c4 10             	add    $0x10,%esp
8010645c:	85 c0                	test   %eax,%eax
8010645e:	79 07                	jns    80106467 <sys_sbrk+0x22>
    return -1;
80106460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106465:	eb 28                	jmp    8010648f <sys_sbrk+0x4a>
  addr = proc->sz;
80106467:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010646d:	8b 00                	mov    (%eax),%eax
8010646f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106472:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106475:	83 ec 0c             	sub    $0xc,%esp
80106478:	50                   	push   %eax
80106479:	e8 d4 e1 ff ff       	call   80104652 <growproc>
8010647e:	83 c4 10             	add    $0x10,%esp
80106481:	85 c0                	test   %eax,%eax
80106483:	79 07                	jns    8010648c <sys_sbrk+0x47>
    return -1;
80106485:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010648a:	eb 03                	jmp    8010648f <sys_sbrk+0x4a>
  return addr;
8010648c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010648f:	c9                   	leave  
80106490:	c3                   	ret    

80106491 <sys_sleep>:

int
sys_sleep(void)
{
80106491:	55                   	push   %ebp
80106492:	89 e5                	mov    %esp,%ebp
80106494:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106497:	83 ec 08             	sub    $0x8,%esp
8010649a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010649d:	50                   	push   %eax
8010649e:	6a 00                	push   $0x0
801064a0:	e8 97 f0 ff ff       	call   8010553c <argint>
801064a5:	83 c4 10             	add    $0x10,%esp
801064a8:	85 c0                	test   %eax,%eax
801064aa:	79 07                	jns    801064b3 <sys_sleep+0x22>
    return -1;
801064ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064b1:	eb 79                	jmp    8010652c <sys_sleep+0x9b>
  acquire(&tickslock);
801064b3:	83 ec 0c             	sub    $0xc,%esp
801064b6:	68 a0 48 11 80       	push   $0x801148a0
801064bb:	e8 03 eb ff ff       	call   80104fc3 <acquire>
801064c0:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801064c3:	a1 e0 50 11 80       	mov    0x801150e0,%eax
801064c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801064cb:	eb 39                	jmp    80106506 <sys_sleep+0x75>
    if(proc->killed){
801064cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064d3:	8b 40 24             	mov    0x24(%eax),%eax
801064d6:	85 c0                	test   %eax,%eax
801064d8:	74 17                	je     801064f1 <sys_sleep+0x60>
      release(&tickslock);
801064da:	83 ec 0c             	sub    $0xc,%esp
801064dd:	68 a0 48 11 80       	push   $0x801148a0
801064e2:	e8 42 eb ff ff       	call   80105029 <release>
801064e7:	83 c4 10             	add    $0x10,%esp
      return -1;
801064ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064ef:	eb 3b                	jmp    8010652c <sys_sleep+0x9b>
    }
    sleep(&ticks, &tickslock);
801064f1:	83 ec 08             	sub    $0x8,%esp
801064f4:	68 a0 48 11 80       	push   $0x801148a0
801064f9:	68 e0 50 11 80       	push   $0x801150e0
801064fe:	e8 bc e7 ff ff       	call   80104cbf <sleep>
80106503:	83 c4 10             	add    $0x10,%esp
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106506:	a1 e0 50 11 80       	mov    0x801150e0,%eax
8010650b:	89 c2                	mov    %eax,%edx
8010650d:	2b 55 f4             	sub    -0xc(%ebp),%edx
80106510:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106513:	39 c2                	cmp    %eax,%edx
80106515:	72 b6                	jb     801064cd <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106517:	83 ec 0c             	sub    $0xc,%esp
8010651a:	68 a0 48 11 80       	push   $0x801148a0
8010651f:	e8 05 eb ff ff       	call   80105029 <release>
80106524:	83 c4 10             	add    $0x10,%esp
  return 0;
80106527:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010652c:	c9                   	leave  
8010652d:	c3                   	ret    

8010652e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010652e:	55                   	push   %ebp
8010652f:	89 e5                	mov    %esp,%ebp
80106531:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
80106534:	83 ec 0c             	sub    $0xc,%esp
80106537:	68 a0 48 11 80       	push   $0x801148a0
8010653c:	e8 82 ea ff ff       	call   80104fc3 <acquire>
80106541:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106544:	a1 e0 50 11 80       	mov    0x801150e0,%eax
80106549:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010654c:	83 ec 0c             	sub    $0xc,%esp
8010654f:	68 a0 48 11 80       	push   $0x801148a0
80106554:	e8 d0 ea ff ff       	call   80105029 <release>
80106559:	83 c4 10             	add    $0x10,%esp
  return xticks;
8010655c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010655f:	c9                   	leave  
80106560:	c3                   	ret    
80106561:	00 00                	add    %al,(%eax)
	...

80106564 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106564:	55                   	push   %ebp
80106565:	89 e5                	mov    %esp,%ebp
80106567:	83 ec 08             	sub    $0x8,%esp
8010656a:	8b 45 08             	mov    0x8(%ebp),%eax
8010656d:	8b 55 0c             	mov    0xc(%ebp),%edx
80106570:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106574:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106577:	8a 45 f8             	mov    -0x8(%ebp),%al
8010657a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010657d:	ee                   	out    %al,(%dx)
}
8010657e:	c9                   	leave  
8010657f:	c3                   	ret    

80106580 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106580:	55                   	push   %ebp
80106581:	89 e5                	mov    %esp,%ebp
80106583:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106586:	6a 34                	push   $0x34
80106588:	6a 43                	push   $0x43
8010658a:	e8 d5 ff ff ff       	call   80106564 <outb>
8010658f:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106592:	68 9c 00 00 00       	push   $0x9c
80106597:	6a 40                	push   $0x40
80106599:	e8 c6 ff ff ff       	call   80106564 <outb>
8010659e:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801065a1:	6a 2e                	push   $0x2e
801065a3:	6a 40                	push   $0x40
801065a5:	e8 ba ff ff ff       	call   80106564 <outb>
801065aa:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
801065ad:	83 ec 0c             	sub    $0xc,%esp
801065b0:	6a 00                	push   $0x0
801065b2:	e8 3a d9 ff ff       	call   80103ef1 <picenable>
801065b7:	83 c4 10             	add    $0x10,%esp
}
801065ba:	c9                   	leave  
801065bb:	c3                   	ret    

801065bc <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801065bc:	1e                   	push   %ds
  pushl %es
801065bd:	06                   	push   %es
  pushl %fs
801065be:	0f a0                	push   %fs
  pushl %gs
801065c0:	0f a8                	push   %gs
  pushal
801065c2:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801065c3:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801065c7:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801065c9:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801065cb:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801065cf:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801065d1:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801065d3:	54                   	push   %esp
  call trap
801065d4:	e8 c1 01 00 00       	call   8010679a <trap>
  addl $4, %esp
801065d9:	83 c4 04             	add    $0x4,%esp

801065dc <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801065dc:	61                   	popa   
  popl %gs
801065dd:	0f a9                	pop    %gs
  popl %fs
801065df:	0f a1                	pop    %fs
  popl %es
801065e1:	07                   	pop    %es
  popl %ds
801065e2:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801065e3:	83 c4 08             	add    $0x8,%esp
  iret
801065e6:	cf                   	iret   
	...

801065e8 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801065e8:	55                   	push   %ebp
801065e9:	89 e5                	mov    %esp,%ebp
801065eb:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801065ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801065f1:	48                   	dec    %eax
801065f2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801065f6:	8b 45 08             	mov    0x8(%ebp),%eax
801065f9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801065fd:	8b 45 08             	mov    0x8(%ebp),%eax
80106600:	c1 e8 10             	shr    $0x10,%eax
80106603:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106607:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010660a:	0f 01 18             	lidtl  (%eax)
}
8010660d:	c9                   	leave  
8010660e:	c3                   	ret    

8010660f <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
8010660f:	55                   	push   %ebp
80106610:	89 e5                	mov    %esp,%ebp
80106612:	53                   	push   %ebx
80106613:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106616:	0f 20 d3             	mov    %cr2,%ebx
80106619:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
8010661c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010661f:	83 c4 10             	add    $0x10,%esp
80106622:	5b                   	pop    %ebx
80106623:	c9                   	leave  
80106624:	c3                   	ret    

80106625 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106625:	55                   	push   %ebp
80106626:	89 e5                	mov    %esp,%ebp
80106628:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
8010662b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106632:	e9 b8 00 00 00       	jmp    801066ef <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106637:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010663a:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
80106641:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106644:	66 89 04 d5 e0 48 11 	mov    %ax,-0x7feeb720(,%edx,8)
8010664b:	80 
8010664c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010664f:	66 c7 04 c5 e2 48 11 	movw   $0x8,-0x7feeb71e(,%eax,8)
80106656:	80 08 00 
80106659:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010665c:	8a 14 c5 e4 48 11 80 	mov    -0x7feeb71c(,%eax,8),%dl
80106663:	83 e2 e0             	and    $0xffffffe0,%edx
80106666:	88 14 c5 e4 48 11 80 	mov    %dl,-0x7feeb71c(,%eax,8)
8010666d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106670:	8a 14 c5 e4 48 11 80 	mov    -0x7feeb71c(,%eax,8),%dl
80106677:	83 e2 1f             	and    $0x1f,%edx
8010667a:	88 14 c5 e4 48 11 80 	mov    %dl,-0x7feeb71c(,%eax,8)
80106681:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106684:	8a 14 c5 e5 48 11 80 	mov    -0x7feeb71b(,%eax,8),%dl
8010668b:	83 e2 f0             	and    $0xfffffff0,%edx
8010668e:	83 ca 0e             	or     $0xe,%edx
80106691:	88 14 c5 e5 48 11 80 	mov    %dl,-0x7feeb71b(,%eax,8)
80106698:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010669b:	8a 14 c5 e5 48 11 80 	mov    -0x7feeb71b(,%eax,8),%dl
801066a2:	83 e2 ef             	and    $0xffffffef,%edx
801066a5:	88 14 c5 e5 48 11 80 	mov    %dl,-0x7feeb71b(,%eax,8)
801066ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066af:	8a 14 c5 e5 48 11 80 	mov    -0x7feeb71b(,%eax,8),%dl
801066b6:	83 e2 9f             	and    $0xffffff9f,%edx
801066b9:	88 14 c5 e5 48 11 80 	mov    %dl,-0x7feeb71b(,%eax,8)
801066c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066c3:	8a 14 c5 e5 48 11 80 	mov    -0x7feeb71b(,%eax,8),%dl
801066ca:	83 ca 80             	or     $0xffffff80,%edx
801066cd:	88 14 c5 e5 48 11 80 	mov    %dl,-0x7feeb71b(,%eax,8)
801066d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066d7:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
801066de:	c1 e8 10             	shr    $0x10,%eax
801066e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066e4:	66 89 04 d5 e6 48 11 	mov    %ax,-0x7feeb71a(,%edx,8)
801066eb:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801066ec:	ff 45 f4             	incl   -0xc(%ebp)
801066ef:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801066f6:	0f 8e 3b ff ff ff    	jle    80106637 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801066fc:	a1 98 b1 10 80       	mov    0x8010b198,%eax
80106701:	66 a3 e0 4a 11 80    	mov    %ax,0x80114ae0
80106707:	66 c7 05 e2 4a 11 80 	movw   $0x8,0x80114ae2
8010670e:	08 00 
80106710:	a0 e4 4a 11 80       	mov    0x80114ae4,%al
80106715:	83 e0 e0             	and    $0xffffffe0,%eax
80106718:	a2 e4 4a 11 80       	mov    %al,0x80114ae4
8010671d:	a0 e4 4a 11 80       	mov    0x80114ae4,%al
80106722:	83 e0 1f             	and    $0x1f,%eax
80106725:	a2 e4 4a 11 80       	mov    %al,0x80114ae4
8010672a:	a0 e5 4a 11 80       	mov    0x80114ae5,%al
8010672f:	83 c8 0f             	or     $0xf,%eax
80106732:	a2 e5 4a 11 80       	mov    %al,0x80114ae5
80106737:	a0 e5 4a 11 80       	mov    0x80114ae5,%al
8010673c:	83 e0 ef             	and    $0xffffffef,%eax
8010673f:	a2 e5 4a 11 80       	mov    %al,0x80114ae5
80106744:	a0 e5 4a 11 80       	mov    0x80114ae5,%al
80106749:	83 c8 60             	or     $0x60,%eax
8010674c:	a2 e5 4a 11 80       	mov    %al,0x80114ae5
80106751:	a0 e5 4a 11 80       	mov    0x80114ae5,%al
80106756:	83 c8 80             	or     $0xffffff80,%eax
80106759:	a2 e5 4a 11 80       	mov    %al,0x80114ae5
8010675e:	a1 98 b1 10 80       	mov    0x8010b198,%eax
80106763:	c1 e8 10             	shr    $0x10,%eax
80106766:	66 a3 e6 4a 11 80    	mov    %ax,0x80114ae6
  
  initlock(&tickslock, "time");
8010676c:	83 ec 08             	sub    $0x8,%esp
8010676f:	68 34 89 10 80       	push   $0x80108934
80106774:	68 a0 48 11 80       	push   $0x801148a0
80106779:	e8 24 e8 ff ff       	call   80104fa2 <initlock>
8010677e:	83 c4 10             	add    $0x10,%esp
}
80106781:	c9                   	leave  
80106782:	c3                   	ret    

80106783 <idtinit>:

void
idtinit(void)
{
80106783:	55                   	push   %ebp
80106784:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106786:	68 00 08 00 00       	push   $0x800
8010678b:	68 e0 48 11 80       	push   $0x801148e0
80106790:	e8 53 fe ff ff       	call   801065e8 <lidt>
80106795:	83 c4 08             	add    $0x8,%esp
}
80106798:	c9                   	leave  
80106799:	c3                   	ret    

8010679a <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010679a:	55                   	push   %ebp
8010679b:	89 e5                	mov    %esp,%ebp
8010679d:	57                   	push   %edi
8010679e:	56                   	push   %esi
8010679f:	53                   	push   %ebx
801067a0:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
801067a3:	8b 45 08             	mov    0x8(%ebp),%eax
801067a6:	8b 40 30             	mov    0x30(%eax),%eax
801067a9:	83 f8 40             	cmp    $0x40,%eax
801067ac:	75 3e                	jne    801067ec <trap+0x52>
    if(proc->killed)
801067ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067b4:	8b 40 24             	mov    0x24(%eax),%eax
801067b7:	85 c0                	test   %eax,%eax
801067b9:	74 05                	je     801067c0 <trap+0x26>
      exit();
801067bb:	e8 c2 e0 ff ff       	call   80104882 <exit>
    proc->tf = tf;
801067c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067c6:	8b 55 08             	mov    0x8(%ebp),%edx
801067c9:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801067cc:	e8 24 ee ff ff       	call   801055f5 <syscall>
    if(proc->killed)
801067d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067d7:	8b 40 24             	mov    0x24(%eax),%eax
801067da:	85 c0                	test   %eax,%eax
801067dc:	0f 84 12 02 00 00    	je     801069f4 <trap+0x25a>
      exit();
801067e2:	e8 9b e0 ff ff       	call   80104882 <exit>
    return;
801067e7:	e9 09 02 00 00       	jmp    801069f5 <trap+0x25b>
  }

  switch(tf->trapno){
801067ec:	8b 45 08             	mov    0x8(%ebp),%eax
801067ef:	8b 40 30             	mov    0x30(%eax),%eax
801067f2:	83 e8 20             	sub    $0x20,%eax
801067f5:	83 f8 1f             	cmp    $0x1f,%eax
801067f8:	0f 87 bb 00 00 00    	ja     801068b9 <trap+0x11f>
801067fe:	8b 04 85 dc 89 10 80 	mov    -0x7fef7624(,%eax,4),%eax
80106805:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106807:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010680d:	8a 00                	mov    (%eax),%al
8010680f:	84 c0                	test   %al,%al
80106811:	75 3b                	jne    8010684e <trap+0xb4>
      acquire(&tickslock);
80106813:	83 ec 0c             	sub    $0xc,%esp
80106816:	68 a0 48 11 80       	push   $0x801148a0
8010681b:	e8 a3 e7 ff ff       	call   80104fc3 <acquire>
80106820:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106823:	a1 e0 50 11 80       	mov    0x801150e0,%eax
80106828:	40                   	inc    %eax
80106829:	a3 e0 50 11 80       	mov    %eax,0x801150e0
      wakeup(&ticks);
8010682e:	83 ec 0c             	sub    $0xc,%esp
80106831:	68 e0 50 11 80       	push   $0x801150e0
80106836:	e8 6e e5 ff ff       	call   80104da9 <wakeup>
8010683b:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
8010683e:	83 ec 0c             	sub    $0xc,%esp
80106841:	68 a0 48 11 80       	push   $0x801148a0
80106846:	e8 de e7 ff ff       	call   80105029 <release>
8010684b:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
8010684e:	e8 83 c7 ff ff       	call   80102fd6 <lapiceoi>
    break;
80106853:	e9 18 01 00 00       	jmp    80106970 <trap+0x1d6>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106858:	e8 7d bf ff ff       	call   801027da <ideintr>
    lapiceoi();
8010685d:	e8 74 c7 ff ff       	call   80102fd6 <lapiceoi>
    break;
80106862:	e9 09 01 00 00       	jmp    80106970 <trap+0x1d6>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106867:	e8 59 c5 ff ff       	call   80102dc5 <kbdintr>
    lapiceoi();
8010686c:	e8 65 c7 ff ff       	call   80102fd6 <lapiceoi>
    break;
80106871:	e9 fa 00 00 00       	jmp    80106970 <trap+0x1d6>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106876:	e8 61 03 00 00       	call   80106bdc <uartintr>
    lapiceoi();
8010687b:	e8 56 c7 ff ff       	call   80102fd6 <lapiceoi>
    break;
80106880:	e9 eb 00 00 00       	jmp    80106970 <trap+0x1d6>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
80106885:	8b 45 08             	mov    0x8(%ebp),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106888:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
8010688b:	8b 45 08             	mov    0x8(%ebp),%eax
8010688e:	8b 40 3c             	mov    0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106891:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106894:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010689a:	8a 00                	mov    (%eax),%al
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010689c:	0f b6 c0             	movzbl %al,%eax
8010689f:	51                   	push   %ecx
801068a0:	52                   	push   %edx
801068a1:	50                   	push   %eax
801068a2:	68 3c 89 10 80       	push   $0x8010893c
801068a7:	e8 17 9b ff ff       	call   801003c3 <cprintf>
801068ac:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
801068af:	e8 22 c7 ff ff       	call   80102fd6 <lapiceoi>
    break;
801068b4:	e9 b7 00 00 00       	jmp    80106970 <trap+0x1d6>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801068b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068bf:	85 c0                	test   %eax,%eax
801068c1:	74 10                	je     801068d3 <trap+0x139>
801068c3:	8b 45 08             	mov    0x8(%ebp),%eax
801068c6:	8b 40 3c             	mov    0x3c(%eax),%eax
801068c9:	0f b7 c0             	movzwl %ax,%eax
801068cc:	83 e0 03             	and    $0x3,%eax
801068cf:	85 c0                	test   %eax,%eax
801068d1:	75 3e                	jne    80106911 <trap+0x177>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801068d3:	e8 37 fd ff ff       	call   8010660f <rcr2>
              tf->trapno, cpu->id, tf->eip, rcr2());
801068d8:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801068db:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
801068de:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801068e5:	8a 12                	mov    (%edx),%dl
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801068e7:	0f b6 ca             	movzbl %dl,%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
801068ea:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801068ed:	8b 52 30             	mov    0x30(%edx),%edx
801068f0:	83 ec 0c             	sub    $0xc,%esp
801068f3:	50                   	push   %eax
801068f4:	53                   	push   %ebx
801068f5:	51                   	push   %ecx
801068f6:	52                   	push   %edx
801068f7:	68 60 89 10 80       	push   $0x80108960
801068fc:	e8 c2 9a ff ff       	call   801003c3 <cprintf>
80106901:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106904:	83 ec 0c             	sub    $0xc,%esp
80106907:	68 92 89 10 80       	push   $0x80108992
8010690c:	e8 51 9c ff ff       	call   80100562 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106911:	e8 f9 fc ff ff       	call   8010660f <rcr2>
80106916:	89 c2                	mov    %eax,%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106918:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010691b:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010691e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106924:	8a 00                	mov    (%eax),%al
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106926:	0f b6 f0             	movzbl %al,%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106929:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010692c:	8b 58 34             	mov    0x34(%eax),%ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010692f:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106932:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106935:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010693b:	83 c0 6c             	add    $0x6c,%eax
8010693e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106941:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106947:	8b 40 10             	mov    0x10(%eax),%eax
8010694a:	52                   	push   %edx
8010694b:	57                   	push   %edi
8010694c:	56                   	push   %esi
8010694d:	53                   	push   %ebx
8010694e:	51                   	push   %ecx
8010694f:	ff 75 e4             	pushl  -0x1c(%ebp)
80106952:	50                   	push   %eax
80106953:	68 98 89 10 80       	push   $0x80108998
80106958:	e8 66 9a ff ff       	call   801003c3 <cprintf>
8010695d:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106960:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106966:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010696d:	eb 01                	jmp    80106970 <trap+0x1d6>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
8010696f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106970:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106976:	85 c0                	test   %eax,%eax
80106978:	74 23                	je     8010699d <trap+0x203>
8010697a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106980:	8b 40 24             	mov    0x24(%eax),%eax
80106983:	85 c0                	test   %eax,%eax
80106985:	74 16                	je     8010699d <trap+0x203>
80106987:	8b 45 08             	mov    0x8(%ebp),%eax
8010698a:	8b 40 3c             	mov    0x3c(%eax),%eax
8010698d:	0f b7 c0             	movzwl %ax,%eax
80106990:	83 e0 03             	and    $0x3,%eax
80106993:	83 f8 03             	cmp    $0x3,%eax
80106996:	75 05                	jne    8010699d <trap+0x203>
    exit();
80106998:	e8 e5 de ff ff       	call   80104882 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
8010699d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069a3:	85 c0                	test   %eax,%eax
801069a5:	74 1e                	je     801069c5 <trap+0x22b>
801069a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069ad:	8b 40 0c             	mov    0xc(%eax),%eax
801069b0:	83 f8 04             	cmp    $0x4,%eax
801069b3:	75 10                	jne    801069c5 <trap+0x22b>
801069b5:	8b 45 08             	mov    0x8(%ebp),%eax
801069b8:	8b 40 30             	mov    0x30(%eax),%eax
801069bb:	83 f8 20             	cmp    $0x20,%eax
801069be:	75 05                	jne    801069c5 <trap+0x22b>
    yield();
801069c0:	e8 7b e2 ff ff       	call   80104c40 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801069c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069cb:	85 c0                	test   %eax,%eax
801069cd:	74 26                	je     801069f5 <trap+0x25b>
801069cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069d5:	8b 40 24             	mov    0x24(%eax),%eax
801069d8:	85 c0                	test   %eax,%eax
801069da:	74 19                	je     801069f5 <trap+0x25b>
801069dc:	8b 45 08             	mov    0x8(%ebp),%eax
801069df:	8b 40 3c             	mov    0x3c(%eax),%eax
801069e2:	0f b7 c0             	movzwl %ax,%eax
801069e5:	83 e0 03             	and    $0x3,%eax
801069e8:	83 f8 03             	cmp    $0x3,%eax
801069eb:	75 08                	jne    801069f5 <trap+0x25b>
    exit();
801069ed:	e8 90 de ff ff       	call   80104882 <exit>
801069f2:	eb 01                	jmp    801069f5 <trap+0x25b>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801069f4:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801069f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069f8:	83 c4 00             	add    $0x0,%esp
801069fb:	5b                   	pop    %ebx
801069fc:	5e                   	pop    %esi
801069fd:	5f                   	pop    %edi
801069fe:	c9                   	leave  
801069ff:	c3                   	ret    

80106a00 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
80106a03:	53                   	push   %ebx
80106a04:	83 ec 18             	sub    $0x18,%esp
80106a07:	8b 45 08             	mov    0x8(%ebp),%eax
80106a0a:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106a0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106a11:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
80106a15:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
80106a19:	ec                   	in     (%dx),%al
80106a1a:	88 c3                	mov    %al,%bl
80106a1c:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80106a1f:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80106a22:	83 c4 18             	add    $0x18,%esp
80106a25:	5b                   	pop    %ebx
80106a26:	c9                   	leave  
80106a27:	c3                   	ret    

80106a28 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106a28:	55                   	push   %ebp
80106a29:	89 e5                	mov    %esp,%ebp
80106a2b:	83 ec 08             	sub    $0x8,%esp
80106a2e:	8b 45 08             	mov    0x8(%ebp),%eax
80106a31:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a34:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106a38:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106a3b:	8a 45 f8             	mov    -0x8(%ebp),%al
80106a3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106a41:	ee                   	out    %al,(%dx)
}
80106a42:	c9                   	leave  
80106a43:	c3                   	ret    

80106a44 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106a44:	55                   	push   %ebp
80106a45:	89 e5                	mov    %esp,%ebp
80106a47:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106a4a:	6a 00                	push   $0x0
80106a4c:	68 fa 03 00 00       	push   $0x3fa
80106a51:	e8 d2 ff ff ff       	call   80106a28 <outb>
80106a56:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106a59:	68 80 00 00 00       	push   $0x80
80106a5e:	68 fb 03 00 00       	push   $0x3fb
80106a63:	e8 c0 ff ff ff       	call   80106a28 <outb>
80106a68:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106a6b:	6a 0c                	push   $0xc
80106a6d:	68 f8 03 00 00       	push   $0x3f8
80106a72:	e8 b1 ff ff ff       	call   80106a28 <outb>
80106a77:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106a7a:	6a 00                	push   $0x0
80106a7c:	68 f9 03 00 00       	push   $0x3f9
80106a81:	e8 a2 ff ff ff       	call   80106a28 <outb>
80106a86:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106a89:	6a 03                	push   $0x3
80106a8b:	68 fb 03 00 00       	push   $0x3fb
80106a90:	e8 93 ff ff ff       	call   80106a28 <outb>
80106a95:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106a98:	6a 00                	push   $0x0
80106a9a:	68 fc 03 00 00       	push   $0x3fc
80106a9f:	e8 84 ff ff ff       	call   80106a28 <outb>
80106aa4:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106aa7:	6a 01                	push   $0x1
80106aa9:	68 f9 03 00 00       	push   $0x3f9
80106aae:	e8 75 ff ff ff       	call   80106a28 <outb>
80106ab3:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106ab6:	68 fd 03 00 00       	push   $0x3fd
80106abb:	e8 40 ff ff ff       	call   80106a00 <inb>
80106ac0:	83 c4 04             	add    $0x4,%esp
80106ac3:	3c ff                	cmp    $0xff,%al
80106ac5:	74 6b                	je     80106b32 <uartinit+0xee>
    return;
  uart = 1;
80106ac7:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
80106ace:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106ad1:	68 fa 03 00 00       	push   $0x3fa
80106ad6:	e8 25 ff ff ff       	call   80106a00 <inb>
80106adb:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106ade:	68 f8 03 00 00       	push   $0x3f8
80106ae3:	e8 18 ff ff ff       	call   80106a00 <inb>
80106ae8:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80106aeb:	83 ec 0c             	sub    $0xc,%esp
80106aee:	6a 04                	push   $0x4
80106af0:	e8 fc d3 ff ff       	call   80103ef1 <picenable>
80106af5:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80106af8:	83 ec 08             	sub    $0x8,%esp
80106afb:	6a 00                	push   $0x0
80106afd:	6a 04                	push   $0x4
80106aff:	e8 74 bf ff ff       	call   80102a78 <ioapicenable>
80106b04:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106b07:	c7 45 f4 5c 8a 10 80 	movl   $0x80108a5c,-0xc(%ebp)
80106b0e:	eb 17                	jmp    80106b27 <uartinit+0xe3>
    uartputc(*p);
80106b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b13:	8a 00                	mov    (%eax),%al
80106b15:	0f be c0             	movsbl %al,%eax
80106b18:	83 ec 0c             	sub    $0xc,%esp
80106b1b:	50                   	push   %eax
80106b1c:	e8 14 00 00 00       	call   80106b35 <uartputc>
80106b21:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106b24:	ff 45 f4             	incl   -0xc(%ebp)
80106b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b2a:	8a 00                	mov    (%eax),%al
80106b2c:	84 c0                	test   %al,%al
80106b2e:	75 e0                	jne    80106b10 <uartinit+0xcc>
80106b30:	eb 01                	jmp    80106b33 <uartinit+0xef>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80106b32:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80106b33:	c9                   	leave  
80106b34:	c3                   	ret    

80106b35 <uartputc>:

void
uartputc(int c)
{
80106b35:	55                   	push   %ebp
80106b36:	89 e5                	mov    %esp,%ebp
80106b38:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106b3b:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106b40:	85 c0                	test   %eax,%eax
80106b42:	74 52                	je     80106b96 <uartputc+0x61>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106b4b:	eb 10                	jmp    80106b5d <uartputc+0x28>
    microdelay(10);
80106b4d:	83 ec 0c             	sub    $0xc,%esp
80106b50:	6a 0a                	push   $0xa
80106b52:	e8 99 c4 ff ff       	call   80102ff0 <microdelay>
80106b57:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b5a:	ff 45 f4             	incl   -0xc(%ebp)
80106b5d:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106b61:	7f 1a                	jg     80106b7d <uartputc+0x48>
80106b63:	83 ec 0c             	sub    $0xc,%esp
80106b66:	68 fd 03 00 00       	push   $0x3fd
80106b6b:	e8 90 fe ff ff       	call   80106a00 <inb>
80106b70:	83 c4 10             	add    $0x10,%esp
80106b73:	0f b6 c0             	movzbl %al,%eax
80106b76:	83 e0 20             	and    $0x20,%eax
80106b79:	85 c0                	test   %eax,%eax
80106b7b:	74 d0                	je     80106b4d <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106b7d:	8b 45 08             	mov    0x8(%ebp),%eax
80106b80:	0f b6 c0             	movzbl %al,%eax
80106b83:	83 ec 08             	sub    $0x8,%esp
80106b86:	50                   	push   %eax
80106b87:	68 f8 03 00 00       	push   $0x3f8
80106b8c:	e8 97 fe ff ff       	call   80106a28 <outb>
80106b91:	83 c4 10             	add    $0x10,%esp
80106b94:	eb 01                	jmp    80106b97 <uartputc+0x62>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80106b96:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106b97:	c9                   	leave  
80106b98:	c3                   	ret    

80106b99 <uartgetc>:

static int
uartgetc(void)
{
80106b99:	55                   	push   %ebp
80106b9a:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106b9c:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106ba1:	85 c0                	test   %eax,%eax
80106ba3:	75 07                	jne    80106bac <uartgetc+0x13>
    return -1;
80106ba5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106baa:	eb 2e                	jmp    80106bda <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106bac:	68 fd 03 00 00       	push   $0x3fd
80106bb1:	e8 4a fe ff ff       	call   80106a00 <inb>
80106bb6:	83 c4 04             	add    $0x4,%esp
80106bb9:	0f b6 c0             	movzbl %al,%eax
80106bbc:	83 e0 01             	and    $0x1,%eax
80106bbf:	85 c0                	test   %eax,%eax
80106bc1:	75 07                	jne    80106bca <uartgetc+0x31>
    return -1;
80106bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bc8:	eb 10                	jmp    80106bda <uartgetc+0x41>
  return inb(COM1+0);
80106bca:	68 f8 03 00 00       	push   $0x3f8
80106bcf:	e8 2c fe ff ff       	call   80106a00 <inb>
80106bd4:	83 c4 04             	add    $0x4,%esp
80106bd7:	0f b6 c0             	movzbl %al,%eax
}
80106bda:	c9                   	leave  
80106bdb:	c3                   	ret    

80106bdc <uartintr>:

void
uartintr(void)
{
80106bdc:	55                   	push   %ebp
80106bdd:	89 e5                	mov    %esp,%ebp
80106bdf:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106be2:	83 ec 0c             	sub    $0xc,%esp
80106be5:	68 99 6b 10 80       	push   $0x80106b99
80106bea:	e8 ed 9b ff ff       	call   801007dc <consoleintr>
80106bef:	83 c4 10             	add    $0x10,%esp
}
80106bf2:	c9                   	leave  
80106bf3:	c3                   	ret    

80106bf4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106bf4:	6a 00                	push   $0x0
  pushl $0
80106bf6:	6a 00                	push   $0x0
  jmp alltraps
80106bf8:	e9 bf f9 ff ff       	jmp    801065bc <alltraps>

80106bfd <vector1>:
.globl vector1
vector1:
  pushl $0
80106bfd:	6a 00                	push   $0x0
  pushl $1
80106bff:	6a 01                	push   $0x1
  jmp alltraps
80106c01:	e9 b6 f9 ff ff       	jmp    801065bc <alltraps>

80106c06 <vector2>:
.globl vector2
vector2:
  pushl $0
80106c06:	6a 00                	push   $0x0
  pushl $2
80106c08:	6a 02                	push   $0x2
  jmp alltraps
80106c0a:	e9 ad f9 ff ff       	jmp    801065bc <alltraps>

80106c0f <vector3>:
.globl vector3
vector3:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $3
80106c11:	6a 03                	push   $0x3
  jmp alltraps
80106c13:	e9 a4 f9 ff ff       	jmp    801065bc <alltraps>

80106c18 <vector4>:
.globl vector4
vector4:
  pushl $0
80106c18:	6a 00                	push   $0x0
  pushl $4
80106c1a:	6a 04                	push   $0x4
  jmp alltraps
80106c1c:	e9 9b f9 ff ff       	jmp    801065bc <alltraps>

80106c21 <vector5>:
.globl vector5
vector5:
  pushl $0
80106c21:	6a 00                	push   $0x0
  pushl $5
80106c23:	6a 05                	push   $0x5
  jmp alltraps
80106c25:	e9 92 f9 ff ff       	jmp    801065bc <alltraps>

80106c2a <vector6>:
.globl vector6
vector6:
  pushl $0
80106c2a:	6a 00                	push   $0x0
  pushl $6
80106c2c:	6a 06                	push   $0x6
  jmp alltraps
80106c2e:	e9 89 f9 ff ff       	jmp    801065bc <alltraps>

80106c33 <vector7>:
.globl vector7
vector7:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $7
80106c35:	6a 07                	push   $0x7
  jmp alltraps
80106c37:	e9 80 f9 ff ff       	jmp    801065bc <alltraps>

80106c3c <vector8>:
.globl vector8
vector8:
  pushl $8
80106c3c:	6a 08                	push   $0x8
  jmp alltraps
80106c3e:	e9 79 f9 ff ff       	jmp    801065bc <alltraps>

80106c43 <vector9>:
.globl vector9
vector9:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $9
80106c45:	6a 09                	push   $0x9
  jmp alltraps
80106c47:	e9 70 f9 ff ff       	jmp    801065bc <alltraps>

80106c4c <vector10>:
.globl vector10
vector10:
  pushl $10
80106c4c:	6a 0a                	push   $0xa
  jmp alltraps
80106c4e:	e9 69 f9 ff ff       	jmp    801065bc <alltraps>

80106c53 <vector11>:
.globl vector11
vector11:
  pushl $11
80106c53:	6a 0b                	push   $0xb
  jmp alltraps
80106c55:	e9 62 f9 ff ff       	jmp    801065bc <alltraps>

80106c5a <vector12>:
.globl vector12
vector12:
  pushl $12
80106c5a:	6a 0c                	push   $0xc
  jmp alltraps
80106c5c:	e9 5b f9 ff ff       	jmp    801065bc <alltraps>

80106c61 <vector13>:
.globl vector13
vector13:
  pushl $13
80106c61:	6a 0d                	push   $0xd
  jmp alltraps
80106c63:	e9 54 f9 ff ff       	jmp    801065bc <alltraps>

80106c68 <vector14>:
.globl vector14
vector14:
  pushl $14
80106c68:	6a 0e                	push   $0xe
  jmp alltraps
80106c6a:	e9 4d f9 ff ff       	jmp    801065bc <alltraps>

80106c6f <vector15>:
.globl vector15
vector15:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $15
80106c71:	6a 0f                	push   $0xf
  jmp alltraps
80106c73:	e9 44 f9 ff ff       	jmp    801065bc <alltraps>

80106c78 <vector16>:
.globl vector16
vector16:
  pushl $0
80106c78:	6a 00                	push   $0x0
  pushl $16
80106c7a:	6a 10                	push   $0x10
  jmp alltraps
80106c7c:	e9 3b f9 ff ff       	jmp    801065bc <alltraps>

80106c81 <vector17>:
.globl vector17
vector17:
  pushl $17
80106c81:	6a 11                	push   $0x11
  jmp alltraps
80106c83:	e9 34 f9 ff ff       	jmp    801065bc <alltraps>

80106c88 <vector18>:
.globl vector18
vector18:
  pushl $0
80106c88:	6a 00                	push   $0x0
  pushl $18
80106c8a:	6a 12                	push   $0x12
  jmp alltraps
80106c8c:	e9 2b f9 ff ff       	jmp    801065bc <alltraps>

80106c91 <vector19>:
.globl vector19
vector19:
  pushl $0
80106c91:	6a 00                	push   $0x0
  pushl $19
80106c93:	6a 13                	push   $0x13
  jmp alltraps
80106c95:	e9 22 f9 ff ff       	jmp    801065bc <alltraps>

80106c9a <vector20>:
.globl vector20
vector20:
  pushl $0
80106c9a:	6a 00                	push   $0x0
  pushl $20
80106c9c:	6a 14                	push   $0x14
  jmp alltraps
80106c9e:	e9 19 f9 ff ff       	jmp    801065bc <alltraps>

80106ca3 <vector21>:
.globl vector21
vector21:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $21
80106ca5:	6a 15                	push   $0x15
  jmp alltraps
80106ca7:	e9 10 f9 ff ff       	jmp    801065bc <alltraps>

80106cac <vector22>:
.globl vector22
vector22:
  pushl $0
80106cac:	6a 00                	push   $0x0
  pushl $22
80106cae:	6a 16                	push   $0x16
  jmp alltraps
80106cb0:	e9 07 f9 ff ff       	jmp    801065bc <alltraps>

80106cb5 <vector23>:
.globl vector23
vector23:
  pushl $0
80106cb5:	6a 00                	push   $0x0
  pushl $23
80106cb7:	6a 17                	push   $0x17
  jmp alltraps
80106cb9:	e9 fe f8 ff ff       	jmp    801065bc <alltraps>

80106cbe <vector24>:
.globl vector24
vector24:
  pushl $0
80106cbe:	6a 00                	push   $0x0
  pushl $24
80106cc0:	6a 18                	push   $0x18
  jmp alltraps
80106cc2:	e9 f5 f8 ff ff       	jmp    801065bc <alltraps>

80106cc7 <vector25>:
.globl vector25
vector25:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $25
80106cc9:	6a 19                	push   $0x19
  jmp alltraps
80106ccb:	e9 ec f8 ff ff       	jmp    801065bc <alltraps>

80106cd0 <vector26>:
.globl vector26
vector26:
  pushl $0
80106cd0:	6a 00                	push   $0x0
  pushl $26
80106cd2:	6a 1a                	push   $0x1a
  jmp alltraps
80106cd4:	e9 e3 f8 ff ff       	jmp    801065bc <alltraps>

80106cd9 <vector27>:
.globl vector27
vector27:
  pushl $0
80106cd9:	6a 00                	push   $0x0
  pushl $27
80106cdb:	6a 1b                	push   $0x1b
  jmp alltraps
80106cdd:	e9 da f8 ff ff       	jmp    801065bc <alltraps>

80106ce2 <vector28>:
.globl vector28
vector28:
  pushl $0
80106ce2:	6a 00                	push   $0x0
  pushl $28
80106ce4:	6a 1c                	push   $0x1c
  jmp alltraps
80106ce6:	e9 d1 f8 ff ff       	jmp    801065bc <alltraps>

80106ceb <vector29>:
.globl vector29
vector29:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $29
80106ced:	6a 1d                	push   $0x1d
  jmp alltraps
80106cef:	e9 c8 f8 ff ff       	jmp    801065bc <alltraps>

80106cf4 <vector30>:
.globl vector30
vector30:
  pushl $0
80106cf4:	6a 00                	push   $0x0
  pushl $30
80106cf6:	6a 1e                	push   $0x1e
  jmp alltraps
80106cf8:	e9 bf f8 ff ff       	jmp    801065bc <alltraps>

80106cfd <vector31>:
.globl vector31
vector31:
  pushl $0
80106cfd:	6a 00                	push   $0x0
  pushl $31
80106cff:	6a 1f                	push   $0x1f
  jmp alltraps
80106d01:	e9 b6 f8 ff ff       	jmp    801065bc <alltraps>

80106d06 <vector32>:
.globl vector32
vector32:
  pushl $0
80106d06:	6a 00                	push   $0x0
  pushl $32
80106d08:	6a 20                	push   $0x20
  jmp alltraps
80106d0a:	e9 ad f8 ff ff       	jmp    801065bc <alltraps>

80106d0f <vector33>:
.globl vector33
vector33:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $33
80106d11:	6a 21                	push   $0x21
  jmp alltraps
80106d13:	e9 a4 f8 ff ff       	jmp    801065bc <alltraps>

80106d18 <vector34>:
.globl vector34
vector34:
  pushl $0
80106d18:	6a 00                	push   $0x0
  pushl $34
80106d1a:	6a 22                	push   $0x22
  jmp alltraps
80106d1c:	e9 9b f8 ff ff       	jmp    801065bc <alltraps>

80106d21 <vector35>:
.globl vector35
vector35:
  pushl $0
80106d21:	6a 00                	push   $0x0
  pushl $35
80106d23:	6a 23                	push   $0x23
  jmp alltraps
80106d25:	e9 92 f8 ff ff       	jmp    801065bc <alltraps>

80106d2a <vector36>:
.globl vector36
vector36:
  pushl $0
80106d2a:	6a 00                	push   $0x0
  pushl $36
80106d2c:	6a 24                	push   $0x24
  jmp alltraps
80106d2e:	e9 89 f8 ff ff       	jmp    801065bc <alltraps>

80106d33 <vector37>:
.globl vector37
vector37:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $37
80106d35:	6a 25                	push   $0x25
  jmp alltraps
80106d37:	e9 80 f8 ff ff       	jmp    801065bc <alltraps>

80106d3c <vector38>:
.globl vector38
vector38:
  pushl $0
80106d3c:	6a 00                	push   $0x0
  pushl $38
80106d3e:	6a 26                	push   $0x26
  jmp alltraps
80106d40:	e9 77 f8 ff ff       	jmp    801065bc <alltraps>

80106d45 <vector39>:
.globl vector39
vector39:
  pushl $0
80106d45:	6a 00                	push   $0x0
  pushl $39
80106d47:	6a 27                	push   $0x27
  jmp alltraps
80106d49:	e9 6e f8 ff ff       	jmp    801065bc <alltraps>

80106d4e <vector40>:
.globl vector40
vector40:
  pushl $0
80106d4e:	6a 00                	push   $0x0
  pushl $40
80106d50:	6a 28                	push   $0x28
  jmp alltraps
80106d52:	e9 65 f8 ff ff       	jmp    801065bc <alltraps>

80106d57 <vector41>:
.globl vector41
vector41:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $41
80106d59:	6a 29                	push   $0x29
  jmp alltraps
80106d5b:	e9 5c f8 ff ff       	jmp    801065bc <alltraps>

80106d60 <vector42>:
.globl vector42
vector42:
  pushl $0
80106d60:	6a 00                	push   $0x0
  pushl $42
80106d62:	6a 2a                	push   $0x2a
  jmp alltraps
80106d64:	e9 53 f8 ff ff       	jmp    801065bc <alltraps>

80106d69 <vector43>:
.globl vector43
vector43:
  pushl $0
80106d69:	6a 00                	push   $0x0
  pushl $43
80106d6b:	6a 2b                	push   $0x2b
  jmp alltraps
80106d6d:	e9 4a f8 ff ff       	jmp    801065bc <alltraps>

80106d72 <vector44>:
.globl vector44
vector44:
  pushl $0
80106d72:	6a 00                	push   $0x0
  pushl $44
80106d74:	6a 2c                	push   $0x2c
  jmp alltraps
80106d76:	e9 41 f8 ff ff       	jmp    801065bc <alltraps>

80106d7b <vector45>:
.globl vector45
vector45:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $45
80106d7d:	6a 2d                	push   $0x2d
  jmp alltraps
80106d7f:	e9 38 f8 ff ff       	jmp    801065bc <alltraps>

80106d84 <vector46>:
.globl vector46
vector46:
  pushl $0
80106d84:	6a 00                	push   $0x0
  pushl $46
80106d86:	6a 2e                	push   $0x2e
  jmp alltraps
80106d88:	e9 2f f8 ff ff       	jmp    801065bc <alltraps>

80106d8d <vector47>:
.globl vector47
vector47:
  pushl $0
80106d8d:	6a 00                	push   $0x0
  pushl $47
80106d8f:	6a 2f                	push   $0x2f
  jmp alltraps
80106d91:	e9 26 f8 ff ff       	jmp    801065bc <alltraps>

80106d96 <vector48>:
.globl vector48
vector48:
  pushl $0
80106d96:	6a 00                	push   $0x0
  pushl $48
80106d98:	6a 30                	push   $0x30
  jmp alltraps
80106d9a:	e9 1d f8 ff ff       	jmp    801065bc <alltraps>

80106d9f <vector49>:
.globl vector49
vector49:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $49
80106da1:	6a 31                	push   $0x31
  jmp alltraps
80106da3:	e9 14 f8 ff ff       	jmp    801065bc <alltraps>

80106da8 <vector50>:
.globl vector50
vector50:
  pushl $0
80106da8:	6a 00                	push   $0x0
  pushl $50
80106daa:	6a 32                	push   $0x32
  jmp alltraps
80106dac:	e9 0b f8 ff ff       	jmp    801065bc <alltraps>

80106db1 <vector51>:
.globl vector51
vector51:
  pushl $0
80106db1:	6a 00                	push   $0x0
  pushl $51
80106db3:	6a 33                	push   $0x33
  jmp alltraps
80106db5:	e9 02 f8 ff ff       	jmp    801065bc <alltraps>

80106dba <vector52>:
.globl vector52
vector52:
  pushl $0
80106dba:	6a 00                	push   $0x0
  pushl $52
80106dbc:	6a 34                	push   $0x34
  jmp alltraps
80106dbe:	e9 f9 f7 ff ff       	jmp    801065bc <alltraps>

80106dc3 <vector53>:
.globl vector53
vector53:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $53
80106dc5:	6a 35                	push   $0x35
  jmp alltraps
80106dc7:	e9 f0 f7 ff ff       	jmp    801065bc <alltraps>

80106dcc <vector54>:
.globl vector54
vector54:
  pushl $0
80106dcc:	6a 00                	push   $0x0
  pushl $54
80106dce:	6a 36                	push   $0x36
  jmp alltraps
80106dd0:	e9 e7 f7 ff ff       	jmp    801065bc <alltraps>

80106dd5 <vector55>:
.globl vector55
vector55:
  pushl $0
80106dd5:	6a 00                	push   $0x0
  pushl $55
80106dd7:	6a 37                	push   $0x37
  jmp alltraps
80106dd9:	e9 de f7 ff ff       	jmp    801065bc <alltraps>

80106dde <vector56>:
.globl vector56
vector56:
  pushl $0
80106dde:	6a 00                	push   $0x0
  pushl $56
80106de0:	6a 38                	push   $0x38
  jmp alltraps
80106de2:	e9 d5 f7 ff ff       	jmp    801065bc <alltraps>

80106de7 <vector57>:
.globl vector57
vector57:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $57
80106de9:	6a 39                	push   $0x39
  jmp alltraps
80106deb:	e9 cc f7 ff ff       	jmp    801065bc <alltraps>

80106df0 <vector58>:
.globl vector58
vector58:
  pushl $0
80106df0:	6a 00                	push   $0x0
  pushl $58
80106df2:	6a 3a                	push   $0x3a
  jmp alltraps
80106df4:	e9 c3 f7 ff ff       	jmp    801065bc <alltraps>

80106df9 <vector59>:
.globl vector59
vector59:
  pushl $0
80106df9:	6a 00                	push   $0x0
  pushl $59
80106dfb:	6a 3b                	push   $0x3b
  jmp alltraps
80106dfd:	e9 ba f7 ff ff       	jmp    801065bc <alltraps>

80106e02 <vector60>:
.globl vector60
vector60:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $60
80106e04:	6a 3c                	push   $0x3c
  jmp alltraps
80106e06:	e9 b1 f7 ff ff       	jmp    801065bc <alltraps>

80106e0b <vector61>:
.globl vector61
vector61:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $61
80106e0d:	6a 3d                	push   $0x3d
  jmp alltraps
80106e0f:	e9 a8 f7 ff ff       	jmp    801065bc <alltraps>

80106e14 <vector62>:
.globl vector62
vector62:
  pushl $0
80106e14:	6a 00                	push   $0x0
  pushl $62
80106e16:	6a 3e                	push   $0x3e
  jmp alltraps
80106e18:	e9 9f f7 ff ff       	jmp    801065bc <alltraps>

80106e1d <vector63>:
.globl vector63
vector63:
  pushl $0
80106e1d:	6a 00                	push   $0x0
  pushl $63
80106e1f:	6a 3f                	push   $0x3f
  jmp alltraps
80106e21:	e9 96 f7 ff ff       	jmp    801065bc <alltraps>

80106e26 <vector64>:
.globl vector64
vector64:
  pushl $0
80106e26:	6a 00                	push   $0x0
  pushl $64
80106e28:	6a 40                	push   $0x40
  jmp alltraps
80106e2a:	e9 8d f7 ff ff       	jmp    801065bc <alltraps>

80106e2f <vector65>:
.globl vector65
vector65:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $65
80106e31:	6a 41                	push   $0x41
  jmp alltraps
80106e33:	e9 84 f7 ff ff       	jmp    801065bc <alltraps>

80106e38 <vector66>:
.globl vector66
vector66:
  pushl $0
80106e38:	6a 00                	push   $0x0
  pushl $66
80106e3a:	6a 42                	push   $0x42
  jmp alltraps
80106e3c:	e9 7b f7 ff ff       	jmp    801065bc <alltraps>

80106e41 <vector67>:
.globl vector67
vector67:
  pushl $0
80106e41:	6a 00                	push   $0x0
  pushl $67
80106e43:	6a 43                	push   $0x43
  jmp alltraps
80106e45:	e9 72 f7 ff ff       	jmp    801065bc <alltraps>

80106e4a <vector68>:
.globl vector68
vector68:
  pushl $0
80106e4a:	6a 00                	push   $0x0
  pushl $68
80106e4c:	6a 44                	push   $0x44
  jmp alltraps
80106e4e:	e9 69 f7 ff ff       	jmp    801065bc <alltraps>

80106e53 <vector69>:
.globl vector69
vector69:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $69
80106e55:	6a 45                	push   $0x45
  jmp alltraps
80106e57:	e9 60 f7 ff ff       	jmp    801065bc <alltraps>

80106e5c <vector70>:
.globl vector70
vector70:
  pushl $0
80106e5c:	6a 00                	push   $0x0
  pushl $70
80106e5e:	6a 46                	push   $0x46
  jmp alltraps
80106e60:	e9 57 f7 ff ff       	jmp    801065bc <alltraps>

80106e65 <vector71>:
.globl vector71
vector71:
  pushl $0
80106e65:	6a 00                	push   $0x0
  pushl $71
80106e67:	6a 47                	push   $0x47
  jmp alltraps
80106e69:	e9 4e f7 ff ff       	jmp    801065bc <alltraps>

80106e6e <vector72>:
.globl vector72
vector72:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $72
80106e70:	6a 48                	push   $0x48
  jmp alltraps
80106e72:	e9 45 f7 ff ff       	jmp    801065bc <alltraps>

80106e77 <vector73>:
.globl vector73
vector73:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $73
80106e79:	6a 49                	push   $0x49
  jmp alltraps
80106e7b:	e9 3c f7 ff ff       	jmp    801065bc <alltraps>

80106e80 <vector74>:
.globl vector74
vector74:
  pushl $0
80106e80:	6a 00                	push   $0x0
  pushl $74
80106e82:	6a 4a                	push   $0x4a
  jmp alltraps
80106e84:	e9 33 f7 ff ff       	jmp    801065bc <alltraps>

80106e89 <vector75>:
.globl vector75
vector75:
  pushl $0
80106e89:	6a 00                	push   $0x0
  pushl $75
80106e8b:	6a 4b                	push   $0x4b
  jmp alltraps
80106e8d:	e9 2a f7 ff ff       	jmp    801065bc <alltraps>

80106e92 <vector76>:
.globl vector76
vector76:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $76
80106e94:	6a 4c                	push   $0x4c
  jmp alltraps
80106e96:	e9 21 f7 ff ff       	jmp    801065bc <alltraps>

80106e9b <vector77>:
.globl vector77
vector77:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $77
80106e9d:	6a 4d                	push   $0x4d
  jmp alltraps
80106e9f:	e9 18 f7 ff ff       	jmp    801065bc <alltraps>

80106ea4 <vector78>:
.globl vector78
vector78:
  pushl $0
80106ea4:	6a 00                	push   $0x0
  pushl $78
80106ea6:	6a 4e                	push   $0x4e
  jmp alltraps
80106ea8:	e9 0f f7 ff ff       	jmp    801065bc <alltraps>

80106ead <vector79>:
.globl vector79
vector79:
  pushl $0
80106ead:	6a 00                	push   $0x0
  pushl $79
80106eaf:	6a 4f                	push   $0x4f
  jmp alltraps
80106eb1:	e9 06 f7 ff ff       	jmp    801065bc <alltraps>

80106eb6 <vector80>:
.globl vector80
vector80:
  pushl $0
80106eb6:	6a 00                	push   $0x0
  pushl $80
80106eb8:	6a 50                	push   $0x50
  jmp alltraps
80106eba:	e9 fd f6 ff ff       	jmp    801065bc <alltraps>

80106ebf <vector81>:
.globl vector81
vector81:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $81
80106ec1:	6a 51                	push   $0x51
  jmp alltraps
80106ec3:	e9 f4 f6 ff ff       	jmp    801065bc <alltraps>

80106ec8 <vector82>:
.globl vector82
vector82:
  pushl $0
80106ec8:	6a 00                	push   $0x0
  pushl $82
80106eca:	6a 52                	push   $0x52
  jmp alltraps
80106ecc:	e9 eb f6 ff ff       	jmp    801065bc <alltraps>

80106ed1 <vector83>:
.globl vector83
vector83:
  pushl $0
80106ed1:	6a 00                	push   $0x0
  pushl $83
80106ed3:	6a 53                	push   $0x53
  jmp alltraps
80106ed5:	e9 e2 f6 ff ff       	jmp    801065bc <alltraps>

80106eda <vector84>:
.globl vector84
vector84:
  pushl $0
80106eda:	6a 00                	push   $0x0
  pushl $84
80106edc:	6a 54                	push   $0x54
  jmp alltraps
80106ede:	e9 d9 f6 ff ff       	jmp    801065bc <alltraps>

80106ee3 <vector85>:
.globl vector85
vector85:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $85
80106ee5:	6a 55                	push   $0x55
  jmp alltraps
80106ee7:	e9 d0 f6 ff ff       	jmp    801065bc <alltraps>

80106eec <vector86>:
.globl vector86
vector86:
  pushl $0
80106eec:	6a 00                	push   $0x0
  pushl $86
80106eee:	6a 56                	push   $0x56
  jmp alltraps
80106ef0:	e9 c7 f6 ff ff       	jmp    801065bc <alltraps>

80106ef5 <vector87>:
.globl vector87
vector87:
  pushl $0
80106ef5:	6a 00                	push   $0x0
  pushl $87
80106ef7:	6a 57                	push   $0x57
  jmp alltraps
80106ef9:	e9 be f6 ff ff       	jmp    801065bc <alltraps>

80106efe <vector88>:
.globl vector88
vector88:
  pushl $0
80106efe:	6a 00                	push   $0x0
  pushl $88
80106f00:	6a 58                	push   $0x58
  jmp alltraps
80106f02:	e9 b5 f6 ff ff       	jmp    801065bc <alltraps>

80106f07 <vector89>:
.globl vector89
vector89:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $89
80106f09:	6a 59                	push   $0x59
  jmp alltraps
80106f0b:	e9 ac f6 ff ff       	jmp    801065bc <alltraps>

80106f10 <vector90>:
.globl vector90
vector90:
  pushl $0
80106f10:	6a 00                	push   $0x0
  pushl $90
80106f12:	6a 5a                	push   $0x5a
  jmp alltraps
80106f14:	e9 a3 f6 ff ff       	jmp    801065bc <alltraps>

80106f19 <vector91>:
.globl vector91
vector91:
  pushl $0
80106f19:	6a 00                	push   $0x0
  pushl $91
80106f1b:	6a 5b                	push   $0x5b
  jmp alltraps
80106f1d:	e9 9a f6 ff ff       	jmp    801065bc <alltraps>

80106f22 <vector92>:
.globl vector92
vector92:
  pushl $0
80106f22:	6a 00                	push   $0x0
  pushl $92
80106f24:	6a 5c                	push   $0x5c
  jmp alltraps
80106f26:	e9 91 f6 ff ff       	jmp    801065bc <alltraps>

80106f2b <vector93>:
.globl vector93
vector93:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $93
80106f2d:	6a 5d                	push   $0x5d
  jmp alltraps
80106f2f:	e9 88 f6 ff ff       	jmp    801065bc <alltraps>

80106f34 <vector94>:
.globl vector94
vector94:
  pushl $0
80106f34:	6a 00                	push   $0x0
  pushl $94
80106f36:	6a 5e                	push   $0x5e
  jmp alltraps
80106f38:	e9 7f f6 ff ff       	jmp    801065bc <alltraps>

80106f3d <vector95>:
.globl vector95
vector95:
  pushl $0
80106f3d:	6a 00                	push   $0x0
  pushl $95
80106f3f:	6a 5f                	push   $0x5f
  jmp alltraps
80106f41:	e9 76 f6 ff ff       	jmp    801065bc <alltraps>

80106f46 <vector96>:
.globl vector96
vector96:
  pushl $0
80106f46:	6a 00                	push   $0x0
  pushl $96
80106f48:	6a 60                	push   $0x60
  jmp alltraps
80106f4a:	e9 6d f6 ff ff       	jmp    801065bc <alltraps>

80106f4f <vector97>:
.globl vector97
vector97:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $97
80106f51:	6a 61                	push   $0x61
  jmp alltraps
80106f53:	e9 64 f6 ff ff       	jmp    801065bc <alltraps>

80106f58 <vector98>:
.globl vector98
vector98:
  pushl $0
80106f58:	6a 00                	push   $0x0
  pushl $98
80106f5a:	6a 62                	push   $0x62
  jmp alltraps
80106f5c:	e9 5b f6 ff ff       	jmp    801065bc <alltraps>

80106f61 <vector99>:
.globl vector99
vector99:
  pushl $0
80106f61:	6a 00                	push   $0x0
  pushl $99
80106f63:	6a 63                	push   $0x63
  jmp alltraps
80106f65:	e9 52 f6 ff ff       	jmp    801065bc <alltraps>

80106f6a <vector100>:
.globl vector100
vector100:
  pushl $0
80106f6a:	6a 00                	push   $0x0
  pushl $100
80106f6c:	6a 64                	push   $0x64
  jmp alltraps
80106f6e:	e9 49 f6 ff ff       	jmp    801065bc <alltraps>

80106f73 <vector101>:
.globl vector101
vector101:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $101
80106f75:	6a 65                	push   $0x65
  jmp alltraps
80106f77:	e9 40 f6 ff ff       	jmp    801065bc <alltraps>

80106f7c <vector102>:
.globl vector102
vector102:
  pushl $0
80106f7c:	6a 00                	push   $0x0
  pushl $102
80106f7e:	6a 66                	push   $0x66
  jmp alltraps
80106f80:	e9 37 f6 ff ff       	jmp    801065bc <alltraps>

80106f85 <vector103>:
.globl vector103
vector103:
  pushl $0
80106f85:	6a 00                	push   $0x0
  pushl $103
80106f87:	6a 67                	push   $0x67
  jmp alltraps
80106f89:	e9 2e f6 ff ff       	jmp    801065bc <alltraps>

80106f8e <vector104>:
.globl vector104
vector104:
  pushl $0
80106f8e:	6a 00                	push   $0x0
  pushl $104
80106f90:	6a 68                	push   $0x68
  jmp alltraps
80106f92:	e9 25 f6 ff ff       	jmp    801065bc <alltraps>

80106f97 <vector105>:
.globl vector105
vector105:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $105
80106f99:	6a 69                	push   $0x69
  jmp alltraps
80106f9b:	e9 1c f6 ff ff       	jmp    801065bc <alltraps>

80106fa0 <vector106>:
.globl vector106
vector106:
  pushl $0
80106fa0:	6a 00                	push   $0x0
  pushl $106
80106fa2:	6a 6a                	push   $0x6a
  jmp alltraps
80106fa4:	e9 13 f6 ff ff       	jmp    801065bc <alltraps>

80106fa9 <vector107>:
.globl vector107
vector107:
  pushl $0
80106fa9:	6a 00                	push   $0x0
  pushl $107
80106fab:	6a 6b                	push   $0x6b
  jmp alltraps
80106fad:	e9 0a f6 ff ff       	jmp    801065bc <alltraps>

80106fb2 <vector108>:
.globl vector108
vector108:
  pushl $0
80106fb2:	6a 00                	push   $0x0
  pushl $108
80106fb4:	6a 6c                	push   $0x6c
  jmp alltraps
80106fb6:	e9 01 f6 ff ff       	jmp    801065bc <alltraps>

80106fbb <vector109>:
.globl vector109
vector109:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $109
80106fbd:	6a 6d                	push   $0x6d
  jmp alltraps
80106fbf:	e9 f8 f5 ff ff       	jmp    801065bc <alltraps>

80106fc4 <vector110>:
.globl vector110
vector110:
  pushl $0
80106fc4:	6a 00                	push   $0x0
  pushl $110
80106fc6:	6a 6e                	push   $0x6e
  jmp alltraps
80106fc8:	e9 ef f5 ff ff       	jmp    801065bc <alltraps>

80106fcd <vector111>:
.globl vector111
vector111:
  pushl $0
80106fcd:	6a 00                	push   $0x0
  pushl $111
80106fcf:	6a 6f                	push   $0x6f
  jmp alltraps
80106fd1:	e9 e6 f5 ff ff       	jmp    801065bc <alltraps>

80106fd6 <vector112>:
.globl vector112
vector112:
  pushl $0
80106fd6:	6a 00                	push   $0x0
  pushl $112
80106fd8:	6a 70                	push   $0x70
  jmp alltraps
80106fda:	e9 dd f5 ff ff       	jmp    801065bc <alltraps>

80106fdf <vector113>:
.globl vector113
vector113:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $113
80106fe1:	6a 71                	push   $0x71
  jmp alltraps
80106fe3:	e9 d4 f5 ff ff       	jmp    801065bc <alltraps>

80106fe8 <vector114>:
.globl vector114
vector114:
  pushl $0
80106fe8:	6a 00                	push   $0x0
  pushl $114
80106fea:	6a 72                	push   $0x72
  jmp alltraps
80106fec:	e9 cb f5 ff ff       	jmp    801065bc <alltraps>

80106ff1 <vector115>:
.globl vector115
vector115:
  pushl $0
80106ff1:	6a 00                	push   $0x0
  pushl $115
80106ff3:	6a 73                	push   $0x73
  jmp alltraps
80106ff5:	e9 c2 f5 ff ff       	jmp    801065bc <alltraps>

80106ffa <vector116>:
.globl vector116
vector116:
  pushl $0
80106ffa:	6a 00                	push   $0x0
  pushl $116
80106ffc:	6a 74                	push   $0x74
  jmp alltraps
80106ffe:	e9 b9 f5 ff ff       	jmp    801065bc <alltraps>

80107003 <vector117>:
.globl vector117
vector117:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $117
80107005:	6a 75                	push   $0x75
  jmp alltraps
80107007:	e9 b0 f5 ff ff       	jmp    801065bc <alltraps>

8010700c <vector118>:
.globl vector118
vector118:
  pushl $0
8010700c:	6a 00                	push   $0x0
  pushl $118
8010700e:	6a 76                	push   $0x76
  jmp alltraps
80107010:	e9 a7 f5 ff ff       	jmp    801065bc <alltraps>

80107015 <vector119>:
.globl vector119
vector119:
  pushl $0
80107015:	6a 00                	push   $0x0
  pushl $119
80107017:	6a 77                	push   $0x77
  jmp alltraps
80107019:	e9 9e f5 ff ff       	jmp    801065bc <alltraps>

8010701e <vector120>:
.globl vector120
vector120:
  pushl $0
8010701e:	6a 00                	push   $0x0
  pushl $120
80107020:	6a 78                	push   $0x78
  jmp alltraps
80107022:	e9 95 f5 ff ff       	jmp    801065bc <alltraps>

80107027 <vector121>:
.globl vector121
vector121:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $121
80107029:	6a 79                	push   $0x79
  jmp alltraps
8010702b:	e9 8c f5 ff ff       	jmp    801065bc <alltraps>

80107030 <vector122>:
.globl vector122
vector122:
  pushl $0
80107030:	6a 00                	push   $0x0
  pushl $122
80107032:	6a 7a                	push   $0x7a
  jmp alltraps
80107034:	e9 83 f5 ff ff       	jmp    801065bc <alltraps>

80107039 <vector123>:
.globl vector123
vector123:
  pushl $0
80107039:	6a 00                	push   $0x0
  pushl $123
8010703b:	6a 7b                	push   $0x7b
  jmp alltraps
8010703d:	e9 7a f5 ff ff       	jmp    801065bc <alltraps>

80107042 <vector124>:
.globl vector124
vector124:
  pushl $0
80107042:	6a 00                	push   $0x0
  pushl $124
80107044:	6a 7c                	push   $0x7c
  jmp alltraps
80107046:	e9 71 f5 ff ff       	jmp    801065bc <alltraps>

8010704b <vector125>:
.globl vector125
vector125:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $125
8010704d:	6a 7d                	push   $0x7d
  jmp alltraps
8010704f:	e9 68 f5 ff ff       	jmp    801065bc <alltraps>

80107054 <vector126>:
.globl vector126
vector126:
  pushl $0
80107054:	6a 00                	push   $0x0
  pushl $126
80107056:	6a 7e                	push   $0x7e
  jmp alltraps
80107058:	e9 5f f5 ff ff       	jmp    801065bc <alltraps>

8010705d <vector127>:
.globl vector127
vector127:
  pushl $0
8010705d:	6a 00                	push   $0x0
  pushl $127
8010705f:	6a 7f                	push   $0x7f
  jmp alltraps
80107061:	e9 56 f5 ff ff       	jmp    801065bc <alltraps>

80107066 <vector128>:
.globl vector128
vector128:
  pushl $0
80107066:	6a 00                	push   $0x0
  pushl $128
80107068:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010706d:	e9 4a f5 ff ff       	jmp    801065bc <alltraps>

80107072 <vector129>:
.globl vector129
vector129:
  pushl $0
80107072:	6a 00                	push   $0x0
  pushl $129
80107074:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107079:	e9 3e f5 ff ff       	jmp    801065bc <alltraps>

8010707e <vector130>:
.globl vector130
vector130:
  pushl $0
8010707e:	6a 00                	push   $0x0
  pushl $130
80107080:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107085:	e9 32 f5 ff ff       	jmp    801065bc <alltraps>

8010708a <vector131>:
.globl vector131
vector131:
  pushl $0
8010708a:	6a 00                	push   $0x0
  pushl $131
8010708c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107091:	e9 26 f5 ff ff       	jmp    801065bc <alltraps>

80107096 <vector132>:
.globl vector132
vector132:
  pushl $0
80107096:	6a 00                	push   $0x0
  pushl $132
80107098:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010709d:	e9 1a f5 ff ff       	jmp    801065bc <alltraps>

801070a2 <vector133>:
.globl vector133
vector133:
  pushl $0
801070a2:	6a 00                	push   $0x0
  pushl $133
801070a4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801070a9:	e9 0e f5 ff ff       	jmp    801065bc <alltraps>

801070ae <vector134>:
.globl vector134
vector134:
  pushl $0
801070ae:	6a 00                	push   $0x0
  pushl $134
801070b0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801070b5:	e9 02 f5 ff ff       	jmp    801065bc <alltraps>

801070ba <vector135>:
.globl vector135
vector135:
  pushl $0
801070ba:	6a 00                	push   $0x0
  pushl $135
801070bc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801070c1:	e9 f6 f4 ff ff       	jmp    801065bc <alltraps>

801070c6 <vector136>:
.globl vector136
vector136:
  pushl $0
801070c6:	6a 00                	push   $0x0
  pushl $136
801070c8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801070cd:	e9 ea f4 ff ff       	jmp    801065bc <alltraps>

801070d2 <vector137>:
.globl vector137
vector137:
  pushl $0
801070d2:	6a 00                	push   $0x0
  pushl $137
801070d4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801070d9:	e9 de f4 ff ff       	jmp    801065bc <alltraps>

801070de <vector138>:
.globl vector138
vector138:
  pushl $0
801070de:	6a 00                	push   $0x0
  pushl $138
801070e0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801070e5:	e9 d2 f4 ff ff       	jmp    801065bc <alltraps>

801070ea <vector139>:
.globl vector139
vector139:
  pushl $0
801070ea:	6a 00                	push   $0x0
  pushl $139
801070ec:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801070f1:	e9 c6 f4 ff ff       	jmp    801065bc <alltraps>

801070f6 <vector140>:
.globl vector140
vector140:
  pushl $0
801070f6:	6a 00                	push   $0x0
  pushl $140
801070f8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801070fd:	e9 ba f4 ff ff       	jmp    801065bc <alltraps>

80107102 <vector141>:
.globl vector141
vector141:
  pushl $0
80107102:	6a 00                	push   $0x0
  pushl $141
80107104:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107109:	e9 ae f4 ff ff       	jmp    801065bc <alltraps>

8010710e <vector142>:
.globl vector142
vector142:
  pushl $0
8010710e:	6a 00                	push   $0x0
  pushl $142
80107110:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107115:	e9 a2 f4 ff ff       	jmp    801065bc <alltraps>

8010711a <vector143>:
.globl vector143
vector143:
  pushl $0
8010711a:	6a 00                	push   $0x0
  pushl $143
8010711c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107121:	e9 96 f4 ff ff       	jmp    801065bc <alltraps>

80107126 <vector144>:
.globl vector144
vector144:
  pushl $0
80107126:	6a 00                	push   $0x0
  pushl $144
80107128:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010712d:	e9 8a f4 ff ff       	jmp    801065bc <alltraps>

80107132 <vector145>:
.globl vector145
vector145:
  pushl $0
80107132:	6a 00                	push   $0x0
  pushl $145
80107134:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107139:	e9 7e f4 ff ff       	jmp    801065bc <alltraps>

8010713e <vector146>:
.globl vector146
vector146:
  pushl $0
8010713e:	6a 00                	push   $0x0
  pushl $146
80107140:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107145:	e9 72 f4 ff ff       	jmp    801065bc <alltraps>

8010714a <vector147>:
.globl vector147
vector147:
  pushl $0
8010714a:	6a 00                	push   $0x0
  pushl $147
8010714c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107151:	e9 66 f4 ff ff       	jmp    801065bc <alltraps>

80107156 <vector148>:
.globl vector148
vector148:
  pushl $0
80107156:	6a 00                	push   $0x0
  pushl $148
80107158:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010715d:	e9 5a f4 ff ff       	jmp    801065bc <alltraps>

80107162 <vector149>:
.globl vector149
vector149:
  pushl $0
80107162:	6a 00                	push   $0x0
  pushl $149
80107164:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107169:	e9 4e f4 ff ff       	jmp    801065bc <alltraps>

8010716e <vector150>:
.globl vector150
vector150:
  pushl $0
8010716e:	6a 00                	push   $0x0
  pushl $150
80107170:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107175:	e9 42 f4 ff ff       	jmp    801065bc <alltraps>

8010717a <vector151>:
.globl vector151
vector151:
  pushl $0
8010717a:	6a 00                	push   $0x0
  pushl $151
8010717c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107181:	e9 36 f4 ff ff       	jmp    801065bc <alltraps>

80107186 <vector152>:
.globl vector152
vector152:
  pushl $0
80107186:	6a 00                	push   $0x0
  pushl $152
80107188:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010718d:	e9 2a f4 ff ff       	jmp    801065bc <alltraps>

80107192 <vector153>:
.globl vector153
vector153:
  pushl $0
80107192:	6a 00                	push   $0x0
  pushl $153
80107194:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107199:	e9 1e f4 ff ff       	jmp    801065bc <alltraps>

8010719e <vector154>:
.globl vector154
vector154:
  pushl $0
8010719e:	6a 00                	push   $0x0
  pushl $154
801071a0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801071a5:	e9 12 f4 ff ff       	jmp    801065bc <alltraps>

801071aa <vector155>:
.globl vector155
vector155:
  pushl $0
801071aa:	6a 00                	push   $0x0
  pushl $155
801071ac:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801071b1:	e9 06 f4 ff ff       	jmp    801065bc <alltraps>

801071b6 <vector156>:
.globl vector156
vector156:
  pushl $0
801071b6:	6a 00                	push   $0x0
  pushl $156
801071b8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801071bd:	e9 fa f3 ff ff       	jmp    801065bc <alltraps>

801071c2 <vector157>:
.globl vector157
vector157:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $157
801071c4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801071c9:	e9 ee f3 ff ff       	jmp    801065bc <alltraps>

801071ce <vector158>:
.globl vector158
vector158:
  pushl $0
801071ce:	6a 00                	push   $0x0
  pushl $158
801071d0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801071d5:	e9 e2 f3 ff ff       	jmp    801065bc <alltraps>

801071da <vector159>:
.globl vector159
vector159:
  pushl $0
801071da:	6a 00                	push   $0x0
  pushl $159
801071dc:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801071e1:	e9 d6 f3 ff ff       	jmp    801065bc <alltraps>

801071e6 <vector160>:
.globl vector160
vector160:
  pushl $0
801071e6:	6a 00                	push   $0x0
  pushl $160
801071e8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801071ed:	e9 ca f3 ff ff       	jmp    801065bc <alltraps>

801071f2 <vector161>:
.globl vector161
vector161:
  pushl $0
801071f2:	6a 00                	push   $0x0
  pushl $161
801071f4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801071f9:	e9 be f3 ff ff       	jmp    801065bc <alltraps>

801071fe <vector162>:
.globl vector162
vector162:
  pushl $0
801071fe:	6a 00                	push   $0x0
  pushl $162
80107200:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107205:	e9 b2 f3 ff ff       	jmp    801065bc <alltraps>

8010720a <vector163>:
.globl vector163
vector163:
  pushl $0
8010720a:	6a 00                	push   $0x0
  pushl $163
8010720c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107211:	e9 a6 f3 ff ff       	jmp    801065bc <alltraps>

80107216 <vector164>:
.globl vector164
vector164:
  pushl $0
80107216:	6a 00                	push   $0x0
  pushl $164
80107218:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010721d:	e9 9a f3 ff ff       	jmp    801065bc <alltraps>

80107222 <vector165>:
.globl vector165
vector165:
  pushl $0
80107222:	6a 00                	push   $0x0
  pushl $165
80107224:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107229:	e9 8e f3 ff ff       	jmp    801065bc <alltraps>

8010722e <vector166>:
.globl vector166
vector166:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $166
80107230:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107235:	e9 82 f3 ff ff       	jmp    801065bc <alltraps>

8010723a <vector167>:
.globl vector167
vector167:
  pushl $0
8010723a:	6a 00                	push   $0x0
  pushl $167
8010723c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107241:	e9 76 f3 ff ff       	jmp    801065bc <alltraps>

80107246 <vector168>:
.globl vector168
vector168:
  pushl $0
80107246:	6a 00                	push   $0x0
  pushl $168
80107248:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010724d:	e9 6a f3 ff ff       	jmp    801065bc <alltraps>

80107252 <vector169>:
.globl vector169
vector169:
  pushl $0
80107252:	6a 00                	push   $0x0
  pushl $169
80107254:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107259:	e9 5e f3 ff ff       	jmp    801065bc <alltraps>

8010725e <vector170>:
.globl vector170
vector170:
  pushl $0
8010725e:	6a 00                	push   $0x0
  pushl $170
80107260:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107265:	e9 52 f3 ff ff       	jmp    801065bc <alltraps>

8010726a <vector171>:
.globl vector171
vector171:
  pushl $0
8010726a:	6a 00                	push   $0x0
  pushl $171
8010726c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107271:	e9 46 f3 ff ff       	jmp    801065bc <alltraps>

80107276 <vector172>:
.globl vector172
vector172:
  pushl $0
80107276:	6a 00                	push   $0x0
  pushl $172
80107278:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010727d:	e9 3a f3 ff ff       	jmp    801065bc <alltraps>

80107282 <vector173>:
.globl vector173
vector173:
  pushl $0
80107282:	6a 00                	push   $0x0
  pushl $173
80107284:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107289:	e9 2e f3 ff ff       	jmp    801065bc <alltraps>

8010728e <vector174>:
.globl vector174
vector174:
  pushl $0
8010728e:	6a 00                	push   $0x0
  pushl $174
80107290:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107295:	e9 22 f3 ff ff       	jmp    801065bc <alltraps>

8010729a <vector175>:
.globl vector175
vector175:
  pushl $0
8010729a:	6a 00                	push   $0x0
  pushl $175
8010729c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801072a1:	e9 16 f3 ff ff       	jmp    801065bc <alltraps>

801072a6 <vector176>:
.globl vector176
vector176:
  pushl $0
801072a6:	6a 00                	push   $0x0
  pushl $176
801072a8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801072ad:	e9 0a f3 ff ff       	jmp    801065bc <alltraps>

801072b2 <vector177>:
.globl vector177
vector177:
  pushl $0
801072b2:	6a 00                	push   $0x0
  pushl $177
801072b4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801072b9:	e9 fe f2 ff ff       	jmp    801065bc <alltraps>

801072be <vector178>:
.globl vector178
vector178:
  pushl $0
801072be:	6a 00                	push   $0x0
  pushl $178
801072c0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801072c5:	e9 f2 f2 ff ff       	jmp    801065bc <alltraps>

801072ca <vector179>:
.globl vector179
vector179:
  pushl $0
801072ca:	6a 00                	push   $0x0
  pushl $179
801072cc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801072d1:	e9 e6 f2 ff ff       	jmp    801065bc <alltraps>

801072d6 <vector180>:
.globl vector180
vector180:
  pushl $0
801072d6:	6a 00                	push   $0x0
  pushl $180
801072d8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801072dd:	e9 da f2 ff ff       	jmp    801065bc <alltraps>

801072e2 <vector181>:
.globl vector181
vector181:
  pushl $0
801072e2:	6a 00                	push   $0x0
  pushl $181
801072e4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801072e9:	e9 ce f2 ff ff       	jmp    801065bc <alltraps>

801072ee <vector182>:
.globl vector182
vector182:
  pushl $0
801072ee:	6a 00                	push   $0x0
  pushl $182
801072f0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801072f5:	e9 c2 f2 ff ff       	jmp    801065bc <alltraps>

801072fa <vector183>:
.globl vector183
vector183:
  pushl $0
801072fa:	6a 00                	push   $0x0
  pushl $183
801072fc:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107301:	e9 b6 f2 ff ff       	jmp    801065bc <alltraps>

80107306 <vector184>:
.globl vector184
vector184:
  pushl $0
80107306:	6a 00                	push   $0x0
  pushl $184
80107308:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010730d:	e9 aa f2 ff ff       	jmp    801065bc <alltraps>

80107312 <vector185>:
.globl vector185
vector185:
  pushl $0
80107312:	6a 00                	push   $0x0
  pushl $185
80107314:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107319:	e9 9e f2 ff ff       	jmp    801065bc <alltraps>

8010731e <vector186>:
.globl vector186
vector186:
  pushl $0
8010731e:	6a 00                	push   $0x0
  pushl $186
80107320:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107325:	e9 92 f2 ff ff       	jmp    801065bc <alltraps>

8010732a <vector187>:
.globl vector187
vector187:
  pushl $0
8010732a:	6a 00                	push   $0x0
  pushl $187
8010732c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107331:	e9 86 f2 ff ff       	jmp    801065bc <alltraps>

80107336 <vector188>:
.globl vector188
vector188:
  pushl $0
80107336:	6a 00                	push   $0x0
  pushl $188
80107338:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010733d:	e9 7a f2 ff ff       	jmp    801065bc <alltraps>

80107342 <vector189>:
.globl vector189
vector189:
  pushl $0
80107342:	6a 00                	push   $0x0
  pushl $189
80107344:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107349:	e9 6e f2 ff ff       	jmp    801065bc <alltraps>

8010734e <vector190>:
.globl vector190
vector190:
  pushl $0
8010734e:	6a 00                	push   $0x0
  pushl $190
80107350:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107355:	e9 62 f2 ff ff       	jmp    801065bc <alltraps>

8010735a <vector191>:
.globl vector191
vector191:
  pushl $0
8010735a:	6a 00                	push   $0x0
  pushl $191
8010735c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107361:	e9 56 f2 ff ff       	jmp    801065bc <alltraps>

80107366 <vector192>:
.globl vector192
vector192:
  pushl $0
80107366:	6a 00                	push   $0x0
  pushl $192
80107368:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010736d:	e9 4a f2 ff ff       	jmp    801065bc <alltraps>

80107372 <vector193>:
.globl vector193
vector193:
  pushl $0
80107372:	6a 00                	push   $0x0
  pushl $193
80107374:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107379:	e9 3e f2 ff ff       	jmp    801065bc <alltraps>

8010737e <vector194>:
.globl vector194
vector194:
  pushl $0
8010737e:	6a 00                	push   $0x0
  pushl $194
80107380:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107385:	e9 32 f2 ff ff       	jmp    801065bc <alltraps>

8010738a <vector195>:
.globl vector195
vector195:
  pushl $0
8010738a:	6a 00                	push   $0x0
  pushl $195
8010738c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107391:	e9 26 f2 ff ff       	jmp    801065bc <alltraps>

80107396 <vector196>:
.globl vector196
vector196:
  pushl $0
80107396:	6a 00                	push   $0x0
  pushl $196
80107398:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010739d:	e9 1a f2 ff ff       	jmp    801065bc <alltraps>

801073a2 <vector197>:
.globl vector197
vector197:
  pushl $0
801073a2:	6a 00                	push   $0x0
  pushl $197
801073a4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801073a9:	e9 0e f2 ff ff       	jmp    801065bc <alltraps>

801073ae <vector198>:
.globl vector198
vector198:
  pushl $0
801073ae:	6a 00                	push   $0x0
  pushl $198
801073b0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801073b5:	e9 02 f2 ff ff       	jmp    801065bc <alltraps>

801073ba <vector199>:
.globl vector199
vector199:
  pushl $0
801073ba:	6a 00                	push   $0x0
  pushl $199
801073bc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801073c1:	e9 f6 f1 ff ff       	jmp    801065bc <alltraps>

801073c6 <vector200>:
.globl vector200
vector200:
  pushl $0
801073c6:	6a 00                	push   $0x0
  pushl $200
801073c8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801073cd:	e9 ea f1 ff ff       	jmp    801065bc <alltraps>

801073d2 <vector201>:
.globl vector201
vector201:
  pushl $0
801073d2:	6a 00                	push   $0x0
  pushl $201
801073d4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801073d9:	e9 de f1 ff ff       	jmp    801065bc <alltraps>

801073de <vector202>:
.globl vector202
vector202:
  pushl $0
801073de:	6a 00                	push   $0x0
  pushl $202
801073e0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801073e5:	e9 d2 f1 ff ff       	jmp    801065bc <alltraps>

801073ea <vector203>:
.globl vector203
vector203:
  pushl $0
801073ea:	6a 00                	push   $0x0
  pushl $203
801073ec:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801073f1:	e9 c6 f1 ff ff       	jmp    801065bc <alltraps>

801073f6 <vector204>:
.globl vector204
vector204:
  pushl $0
801073f6:	6a 00                	push   $0x0
  pushl $204
801073f8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801073fd:	e9 ba f1 ff ff       	jmp    801065bc <alltraps>

80107402 <vector205>:
.globl vector205
vector205:
  pushl $0
80107402:	6a 00                	push   $0x0
  pushl $205
80107404:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107409:	e9 ae f1 ff ff       	jmp    801065bc <alltraps>

8010740e <vector206>:
.globl vector206
vector206:
  pushl $0
8010740e:	6a 00                	push   $0x0
  pushl $206
80107410:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107415:	e9 a2 f1 ff ff       	jmp    801065bc <alltraps>

8010741a <vector207>:
.globl vector207
vector207:
  pushl $0
8010741a:	6a 00                	push   $0x0
  pushl $207
8010741c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107421:	e9 96 f1 ff ff       	jmp    801065bc <alltraps>

80107426 <vector208>:
.globl vector208
vector208:
  pushl $0
80107426:	6a 00                	push   $0x0
  pushl $208
80107428:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010742d:	e9 8a f1 ff ff       	jmp    801065bc <alltraps>

80107432 <vector209>:
.globl vector209
vector209:
  pushl $0
80107432:	6a 00                	push   $0x0
  pushl $209
80107434:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107439:	e9 7e f1 ff ff       	jmp    801065bc <alltraps>

8010743e <vector210>:
.globl vector210
vector210:
  pushl $0
8010743e:	6a 00                	push   $0x0
  pushl $210
80107440:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107445:	e9 72 f1 ff ff       	jmp    801065bc <alltraps>

8010744a <vector211>:
.globl vector211
vector211:
  pushl $0
8010744a:	6a 00                	push   $0x0
  pushl $211
8010744c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107451:	e9 66 f1 ff ff       	jmp    801065bc <alltraps>

80107456 <vector212>:
.globl vector212
vector212:
  pushl $0
80107456:	6a 00                	push   $0x0
  pushl $212
80107458:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010745d:	e9 5a f1 ff ff       	jmp    801065bc <alltraps>

80107462 <vector213>:
.globl vector213
vector213:
  pushl $0
80107462:	6a 00                	push   $0x0
  pushl $213
80107464:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107469:	e9 4e f1 ff ff       	jmp    801065bc <alltraps>

8010746e <vector214>:
.globl vector214
vector214:
  pushl $0
8010746e:	6a 00                	push   $0x0
  pushl $214
80107470:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107475:	e9 42 f1 ff ff       	jmp    801065bc <alltraps>

8010747a <vector215>:
.globl vector215
vector215:
  pushl $0
8010747a:	6a 00                	push   $0x0
  pushl $215
8010747c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107481:	e9 36 f1 ff ff       	jmp    801065bc <alltraps>

80107486 <vector216>:
.globl vector216
vector216:
  pushl $0
80107486:	6a 00                	push   $0x0
  pushl $216
80107488:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010748d:	e9 2a f1 ff ff       	jmp    801065bc <alltraps>

80107492 <vector217>:
.globl vector217
vector217:
  pushl $0
80107492:	6a 00                	push   $0x0
  pushl $217
80107494:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107499:	e9 1e f1 ff ff       	jmp    801065bc <alltraps>

8010749e <vector218>:
.globl vector218
vector218:
  pushl $0
8010749e:	6a 00                	push   $0x0
  pushl $218
801074a0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801074a5:	e9 12 f1 ff ff       	jmp    801065bc <alltraps>

801074aa <vector219>:
.globl vector219
vector219:
  pushl $0
801074aa:	6a 00                	push   $0x0
  pushl $219
801074ac:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801074b1:	e9 06 f1 ff ff       	jmp    801065bc <alltraps>

801074b6 <vector220>:
.globl vector220
vector220:
  pushl $0
801074b6:	6a 00                	push   $0x0
  pushl $220
801074b8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801074bd:	e9 fa f0 ff ff       	jmp    801065bc <alltraps>

801074c2 <vector221>:
.globl vector221
vector221:
  pushl $0
801074c2:	6a 00                	push   $0x0
  pushl $221
801074c4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801074c9:	e9 ee f0 ff ff       	jmp    801065bc <alltraps>

801074ce <vector222>:
.globl vector222
vector222:
  pushl $0
801074ce:	6a 00                	push   $0x0
  pushl $222
801074d0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801074d5:	e9 e2 f0 ff ff       	jmp    801065bc <alltraps>

801074da <vector223>:
.globl vector223
vector223:
  pushl $0
801074da:	6a 00                	push   $0x0
  pushl $223
801074dc:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801074e1:	e9 d6 f0 ff ff       	jmp    801065bc <alltraps>

801074e6 <vector224>:
.globl vector224
vector224:
  pushl $0
801074e6:	6a 00                	push   $0x0
  pushl $224
801074e8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801074ed:	e9 ca f0 ff ff       	jmp    801065bc <alltraps>

801074f2 <vector225>:
.globl vector225
vector225:
  pushl $0
801074f2:	6a 00                	push   $0x0
  pushl $225
801074f4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801074f9:	e9 be f0 ff ff       	jmp    801065bc <alltraps>

801074fe <vector226>:
.globl vector226
vector226:
  pushl $0
801074fe:	6a 00                	push   $0x0
  pushl $226
80107500:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107505:	e9 b2 f0 ff ff       	jmp    801065bc <alltraps>

8010750a <vector227>:
.globl vector227
vector227:
  pushl $0
8010750a:	6a 00                	push   $0x0
  pushl $227
8010750c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107511:	e9 a6 f0 ff ff       	jmp    801065bc <alltraps>

80107516 <vector228>:
.globl vector228
vector228:
  pushl $0
80107516:	6a 00                	push   $0x0
  pushl $228
80107518:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010751d:	e9 9a f0 ff ff       	jmp    801065bc <alltraps>

80107522 <vector229>:
.globl vector229
vector229:
  pushl $0
80107522:	6a 00                	push   $0x0
  pushl $229
80107524:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107529:	e9 8e f0 ff ff       	jmp    801065bc <alltraps>

8010752e <vector230>:
.globl vector230
vector230:
  pushl $0
8010752e:	6a 00                	push   $0x0
  pushl $230
80107530:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107535:	e9 82 f0 ff ff       	jmp    801065bc <alltraps>

8010753a <vector231>:
.globl vector231
vector231:
  pushl $0
8010753a:	6a 00                	push   $0x0
  pushl $231
8010753c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107541:	e9 76 f0 ff ff       	jmp    801065bc <alltraps>

80107546 <vector232>:
.globl vector232
vector232:
  pushl $0
80107546:	6a 00                	push   $0x0
  pushl $232
80107548:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010754d:	e9 6a f0 ff ff       	jmp    801065bc <alltraps>

80107552 <vector233>:
.globl vector233
vector233:
  pushl $0
80107552:	6a 00                	push   $0x0
  pushl $233
80107554:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107559:	e9 5e f0 ff ff       	jmp    801065bc <alltraps>

8010755e <vector234>:
.globl vector234
vector234:
  pushl $0
8010755e:	6a 00                	push   $0x0
  pushl $234
80107560:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107565:	e9 52 f0 ff ff       	jmp    801065bc <alltraps>

8010756a <vector235>:
.globl vector235
vector235:
  pushl $0
8010756a:	6a 00                	push   $0x0
  pushl $235
8010756c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107571:	e9 46 f0 ff ff       	jmp    801065bc <alltraps>

80107576 <vector236>:
.globl vector236
vector236:
  pushl $0
80107576:	6a 00                	push   $0x0
  pushl $236
80107578:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010757d:	e9 3a f0 ff ff       	jmp    801065bc <alltraps>

80107582 <vector237>:
.globl vector237
vector237:
  pushl $0
80107582:	6a 00                	push   $0x0
  pushl $237
80107584:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107589:	e9 2e f0 ff ff       	jmp    801065bc <alltraps>

8010758e <vector238>:
.globl vector238
vector238:
  pushl $0
8010758e:	6a 00                	push   $0x0
  pushl $238
80107590:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107595:	e9 22 f0 ff ff       	jmp    801065bc <alltraps>

8010759a <vector239>:
.globl vector239
vector239:
  pushl $0
8010759a:	6a 00                	push   $0x0
  pushl $239
8010759c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801075a1:	e9 16 f0 ff ff       	jmp    801065bc <alltraps>

801075a6 <vector240>:
.globl vector240
vector240:
  pushl $0
801075a6:	6a 00                	push   $0x0
  pushl $240
801075a8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801075ad:	e9 0a f0 ff ff       	jmp    801065bc <alltraps>

801075b2 <vector241>:
.globl vector241
vector241:
  pushl $0
801075b2:	6a 00                	push   $0x0
  pushl $241
801075b4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801075b9:	e9 fe ef ff ff       	jmp    801065bc <alltraps>

801075be <vector242>:
.globl vector242
vector242:
  pushl $0
801075be:	6a 00                	push   $0x0
  pushl $242
801075c0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801075c5:	e9 f2 ef ff ff       	jmp    801065bc <alltraps>

801075ca <vector243>:
.globl vector243
vector243:
  pushl $0
801075ca:	6a 00                	push   $0x0
  pushl $243
801075cc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801075d1:	e9 e6 ef ff ff       	jmp    801065bc <alltraps>

801075d6 <vector244>:
.globl vector244
vector244:
  pushl $0
801075d6:	6a 00                	push   $0x0
  pushl $244
801075d8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801075dd:	e9 da ef ff ff       	jmp    801065bc <alltraps>

801075e2 <vector245>:
.globl vector245
vector245:
  pushl $0
801075e2:	6a 00                	push   $0x0
  pushl $245
801075e4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801075e9:	e9 ce ef ff ff       	jmp    801065bc <alltraps>

801075ee <vector246>:
.globl vector246
vector246:
  pushl $0
801075ee:	6a 00                	push   $0x0
  pushl $246
801075f0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801075f5:	e9 c2 ef ff ff       	jmp    801065bc <alltraps>

801075fa <vector247>:
.globl vector247
vector247:
  pushl $0
801075fa:	6a 00                	push   $0x0
  pushl $247
801075fc:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107601:	e9 b6 ef ff ff       	jmp    801065bc <alltraps>

80107606 <vector248>:
.globl vector248
vector248:
  pushl $0
80107606:	6a 00                	push   $0x0
  pushl $248
80107608:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010760d:	e9 aa ef ff ff       	jmp    801065bc <alltraps>

80107612 <vector249>:
.globl vector249
vector249:
  pushl $0
80107612:	6a 00                	push   $0x0
  pushl $249
80107614:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107619:	e9 9e ef ff ff       	jmp    801065bc <alltraps>

8010761e <vector250>:
.globl vector250
vector250:
  pushl $0
8010761e:	6a 00                	push   $0x0
  pushl $250
80107620:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107625:	e9 92 ef ff ff       	jmp    801065bc <alltraps>

8010762a <vector251>:
.globl vector251
vector251:
  pushl $0
8010762a:	6a 00                	push   $0x0
  pushl $251
8010762c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107631:	e9 86 ef ff ff       	jmp    801065bc <alltraps>

80107636 <vector252>:
.globl vector252
vector252:
  pushl $0
80107636:	6a 00                	push   $0x0
  pushl $252
80107638:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010763d:	e9 7a ef ff ff       	jmp    801065bc <alltraps>

80107642 <vector253>:
.globl vector253
vector253:
  pushl $0
80107642:	6a 00                	push   $0x0
  pushl $253
80107644:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107649:	e9 6e ef ff ff       	jmp    801065bc <alltraps>

8010764e <vector254>:
.globl vector254
vector254:
  pushl $0
8010764e:	6a 00                	push   $0x0
  pushl $254
80107650:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107655:	e9 62 ef ff ff       	jmp    801065bc <alltraps>

8010765a <vector255>:
.globl vector255
vector255:
  pushl $0
8010765a:	6a 00                	push   $0x0
  pushl $255
8010765c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107661:	e9 56 ef ff ff       	jmp    801065bc <alltraps>
	...

80107668 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107668:	55                   	push   %ebp
80107669:	89 e5                	mov    %esp,%ebp
8010766b:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010766e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107671:	48                   	dec    %eax
80107672:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107676:	8b 45 08             	mov    0x8(%ebp),%eax
80107679:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010767d:	8b 45 08             	mov    0x8(%ebp),%eax
80107680:	c1 e8 10             	shr    $0x10,%eax
80107683:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107687:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010768a:	0f 01 10             	lgdtl  (%eax)
}
8010768d:	c9                   	leave  
8010768e:	c3                   	ret    

8010768f <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
8010768f:	55                   	push   %ebp
80107690:	89 e5                	mov    %esp,%ebp
80107692:	83 ec 04             	sub    $0x4,%esp
80107695:	8b 45 08             	mov    0x8(%ebp),%eax
80107698:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010769c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010769f:	0f 00 d8             	ltr    %ax
}
801076a2:	c9                   	leave  
801076a3:	c3                   	ret    

801076a4 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
801076a4:	55                   	push   %ebp
801076a5:	89 e5                	mov    %esp,%ebp
801076a7:	83 ec 04             	sub    $0x4,%esp
801076aa:	8b 45 08             	mov    0x8(%ebp),%eax
801076ad:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801076b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801076b4:	8e e8                	mov    %eax,%gs
}
801076b6:	c9                   	leave  
801076b7:	c3                   	ret    

801076b8 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801076b8:	55                   	push   %ebp
801076b9:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801076bb:	8b 45 08             	mov    0x8(%ebp),%eax
801076be:	0f 22 d8             	mov    %eax,%cr3
}
801076c1:	c9                   	leave  
801076c2:	c3                   	ret    

801076c3 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801076c3:	55                   	push   %ebp
801076c4:	89 e5                	mov    %esp,%ebp
801076c6:	8b 45 08             	mov    0x8(%ebp),%eax
801076c9:	2d 00 00 00 80       	sub    $0x80000000,%eax
801076ce:	c9                   	leave  
801076cf:	c3                   	ret    

801076d0 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801076d0:	55                   	push   %ebp
801076d1:	89 e5                	mov    %esp,%ebp
801076d3:	8b 45 08             	mov    0x8(%ebp),%eax
801076d6:	2d 00 00 00 80       	sub    $0x80000000,%eax
801076db:	c9                   	leave  
801076dc:	c3                   	ret    

801076dd <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801076dd:	55                   	push   %ebp
801076de:	89 e5                	mov    %esp,%ebp
801076e0:	53                   	push   %ebx
801076e1:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801076e4:	e8 92 b8 ff ff       	call   80102f7b <cpunum>
801076e9:	89 c2                	mov    %eax,%edx
801076eb:	89 d0                	mov    %edx,%eax
801076ed:	d1 e0                	shl    %eax
801076ef:	01 d0                	add    %edx,%eax
801076f1:	c1 e0 04             	shl    $0x4,%eax
801076f4:	29 d0                	sub    %edx,%eax
801076f6:	c1 e0 02             	shl    $0x2,%eax
801076f9:	05 60 23 11 80       	add    $0x80112360,%eax
801076fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107701:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107704:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010770a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010770d:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107713:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107716:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010771a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010771d:	8a 50 7d             	mov    0x7d(%eax),%dl
80107720:	83 e2 f0             	and    $0xfffffff0,%edx
80107723:	83 ca 0a             	or     $0xa,%edx
80107726:	88 50 7d             	mov    %dl,0x7d(%eax)
80107729:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010772c:	8a 50 7d             	mov    0x7d(%eax),%dl
8010772f:	83 ca 10             	or     $0x10,%edx
80107732:	88 50 7d             	mov    %dl,0x7d(%eax)
80107735:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107738:	8a 50 7d             	mov    0x7d(%eax),%dl
8010773b:	83 e2 9f             	and    $0xffffff9f,%edx
8010773e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107741:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107744:	8a 50 7d             	mov    0x7d(%eax),%dl
80107747:	83 ca 80             	or     $0xffffff80,%edx
8010774a:	88 50 7d             	mov    %dl,0x7d(%eax)
8010774d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107750:	8a 50 7e             	mov    0x7e(%eax),%dl
80107753:	83 ca 0f             	or     $0xf,%edx
80107756:	88 50 7e             	mov    %dl,0x7e(%eax)
80107759:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010775c:	8a 50 7e             	mov    0x7e(%eax),%dl
8010775f:	83 e2 ef             	and    $0xffffffef,%edx
80107762:	88 50 7e             	mov    %dl,0x7e(%eax)
80107765:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107768:	8a 50 7e             	mov    0x7e(%eax),%dl
8010776b:	83 e2 df             	and    $0xffffffdf,%edx
8010776e:	88 50 7e             	mov    %dl,0x7e(%eax)
80107771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107774:	8a 50 7e             	mov    0x7e(%eax),%dl
80107777:	83 ca 40             	or     $0x40,%edx
8010777a:	88 50 7e             	mov    %dl,0x7e(%eax)
8010777d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107780:	8a 50 7e             	mov    0x7e(%eax),%dl
80107783:	83 ca 80             	or     $0xffffff80,%edx
80107786:	88 50 7e             	mov    %dl,0x7e(%eax)
80107789:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010778c:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107793:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010779a:	ff ff 
8010779c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010779f:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801077a6:	00 00 
801077a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ab:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801077b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077b5:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801077bb:	83 e2 f0             	and    $0xfffffff0,%edx
801077be:	83 ca 02             	or     $0x2,%edx
801077c1:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801077c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ca:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801077d0:	83 ca 10             	or     $0x10,%edx
801077d3:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801077d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077dc:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801077e2:	83 e2 9f             	and    $0xffffff9f,%edx
801077e5:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801077eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ee:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801077f4:	83 ca 80             	or     $0xffffff80,%edx
801077f7:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801077fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107800:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107806:	83 ca 0f             	or     $0xf,%edx
80107809:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010780f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107812:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107818:	83 e2 ef             	and    $0xffffffef,%edx
8010781b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107821:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107824:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010782a:	83 e2 df             	and    $0xffffffdf,%edx
8010782d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107836:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010783c:	83 ca 40             	or     $0x40,%edx
8010783f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107845:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107848:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010784e:	83 ca 80             	or     $0xffffff80,%edx
80107851:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107857:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010785a:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107861:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107864:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010786b:	ff ff 
8010786d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107870:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107877:	00 00 
80107879:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787c:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107883:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107886:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
8010788c:	83 e2 f0             	and    $0xfffffff0,%edx
8010788f:	83 ca 0a             	or     $0xa,%edx
80107892:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107898:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010789b:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801078a1:	83 ca 10             	or     $0x10,%edx
801078a4:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801078aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ad:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801078b3:	83 ca 60             	or     $0x60,%edx
801078b6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801078bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078bf:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801078c5:	83 ca 80             	or     $0xffffff80,%edx
801078c8:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801078ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d1:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801078d7:	83 ca 0f             	or     $0xf,%edx
801078da:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801078e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e3:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801078e9:	83 e2 ef             	and    $0xffffffef,%edx
801078ec:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801078f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f5:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801078fb:	83 e2 df             	and    $0xffffffdf,%edx
801078fe:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107904:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107907:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010790d:	83 ca 40             	or     $0x40,%edx
80107910:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107916:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107919:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010791f:	83 ca 80             	or     $0xffffff80,%edx
80107922:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107928:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010792b:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107932:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107935:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
8010793c:	ff ff 
8010793e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107941:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107948:	00 00 
8010794a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010794d:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107954:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107957:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
8010795d:	83 e2 f0             	and    $0xfffffff0,%edx
80107960:	83 ca 02             	or     $0x2,%edx
80107963:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107969:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010796c:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107972:	83 ca 10             	or     $0x10,%edx
80107975:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010797b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010797e:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107984:	83 ca 60             	or     $0x60,%edx
80107987:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010798d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107990:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107996:	83 ca 80             	or     $0xffffff80,%edx
80107999:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010799f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079a2:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
801079a8:	83 ca 0f             	or     $0xf,%edx
801079ab:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b4:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
801079ba:	83 e2 ef             	and    $0xffffffef,%edx
801079bd:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079c6:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
801079cc:	83 e2 df             	and    $0xffffffdf,%edx
801079cf:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079d8:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
801079de:	83 ca 40             	or     $0x40,%edx
801079e1:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ea:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
801079f0:	83 ca 80             	or     $0xffffff80,%edx
801079f3:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079fc:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a06:	05 b4 00 00 00       	add    $0xb4,%eax
80107a0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107a0e:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80107a14:	c1 ea 10             	shr    $0x10,%edx
80107a17:	88 d1                	mov    %dl,%cl
80107a19:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107a1c:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80107a22:	c1 ea 18             	shr    $0x18,%edx
80107a25:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80107a28:	66 c7 83 88 00 00 00 	movw   $0x0,0x88(%ebx)
80107a2f:	00 00 
80107a31:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80107a34:	66 89 83 8a 00 00 00 	mov    %ax,0x8a(%ebx)
80107a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a3e:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a47:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80107a4d:	83 e1 f0             	and    $0xfffffff0,%ecx
80107a50:	83 c9 02             	or     $0x2,%ecx
80107a53:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a5c:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80107a62:	83 c9 10             	or     $0x10,%ecx
80107a65:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a6e:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80107a74:	83 e1 9f             	and    $0xffffff9f,%ecx
80107a77:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a80:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80107a86:	83 c9 80             	or     $0xffffff80,%ecx
80107a89:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a92:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107a98:	83 e1 f0             	and    $0xfffffff0,%ecx
80107a9b:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa4:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107aaa:	83 e1 ef             	and    $0xffffffef,%ecx
80107aad:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab6:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107abc:	83 e1 df             	and    $0xffffffdf,%ecx
80107abf:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac8:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107ace:	83 c9 40             	or     $0x40,%ecx
80107ad1:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ada:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107ae0:	83 c9 80             	or     $0xffffff80,%ecx
80107ae3:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aec:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af5:	83 c0 70             	add    $0x70,%eax
80107af8:	83 ec 08             	sub    $0x8,%esp
80107afb:	6a 38                	push   $0x38
80107afd:	50                   	push   %eax
80107afe:	e8 65 fb ff ff       	call   80107668 <lgdt>
80107b03:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80107b06:	83 ec 0c             	sub    $0xc,%esp
80107b09:	6a 18                	push   $0x18
80107b0b:	e8 94 fb ff ff       	call   801076a4 <loadgs>
80107b10:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80107b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b16:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107b1c:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107b23:	00 00 00 00 
}
80107b27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107b2a:	c9                   	leave  
80107b2b:	c3                   	ret    

80107b2c <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107b2c:	55                   	push   %ebp
80107b2d:	89 e5                	mov    %esp,%ebp
80107b2f:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107b32:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b35:	c1 e8 16             	shr    $0x16,%eax
80107b38:	c1 e0 02             	shl    $0x2,%eax
80107b3b:	03 45 08             	add    0x8(%ebp),%eax
80107b3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b44:	8b 00                	mov    (%eax),%eax
80107b46:	83 e0 01             	and    $0x1,%eax
80107b49:	84 c0                	test   %al,%al
80107b4b:	74 18                	je     80107b65 <walkpgdir+0x39>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b50:	8b 00                	mov    (%eax),%eax
80107b52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b57:	50                   	push   %eax
80107b58:	e8 73 fb ff ff       	call   801076d0 <p2v>
80107b5d:	83 c4 04             	add    $0x4,%esp
80107b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b63:	eb 48                	jmp    80107bad <walkpgdir+0x81>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107b65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107b69:	74 0e                	je     80107b79 <walkpgdir+0x4d>
80107b6b:	e8 8f b0 ff ff       	call   80102bff <kalloc>
80107b70:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107b77:	75 07                	jne    80107b80 <walkpgdir+0x54>
      return 0;
80107b79:	b8 00 00 00 00       	mov    $0x0,%eax
80107b7e:	eb 3e                	jmp    80107bbe <walkpgdir+0x92>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107b80:	83 ec 04             	sub    $0x4,%esp
80107b83:	68 00 10 00 00       	push   $0x1000
80107b88:	6a 00                	push   $0x0
80107b8a:	ff 75 f4             	pushl  -0xc(%ebp)
80107b8d:	e8 8c d6 ff ff       	call   8010521e <memset>
80107b92:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107b95:	83 ec 0c             	sub    $0xc,%esp
80107b98:	ff 75 f4             	pushl  -0xc(%ebp)
80107b9b:	e8 23 fb ff ff       	call   801076c3 <v2p>
80107ba0:	83 c4 10             	add    $0x10,%esp
80107ba3:	89 c2                	mov    %eax,%edx
80107ba5:	83 ca 07             	or     $0x7,%edx
80107ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bab:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107bad:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bb0:	c1 e8 0c             	shr    $0xc,%eax
80107bb3:	25 ff 03 00 00       	and    $0x3ff,%eax
80107bb8:	c1 e0 02             	shl    $0x2,%eax
80107bbb:	03 45 f4             	add    -0xc(%ebp),%eax
}
80107bbe:	c9                   	leave  
80107bbf:	c3                   	ret    

80107bc0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107bc0:	55                   	push   %ebp
80107bc1:	89 e5                	mov    %esp,%ebp
80107bc3:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bc9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bd4:	03 45 10             	add    0x10(%ebp),%eax
80107bd7:	48                   	dec    %eax
80107bd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107be0:	83 ec 04             	sub    $0x4,%esp
80107be3:	6a 01                	push   $0x1
80107be5:	ff 75 f4             	pushl  -0xc(%ebp)
80107be8:	ff 75 08             	pushl  0x8(%ebp)
80107beb:	e8 3c ff ff ff       	call   80107b2c <walkpgdir>
80107bf0:	83 c4 10             	add    $0x10,%esp
80107bf3:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107bf6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107bfa:	75 07                	jne    80107c03 <mappages+0x43>
      return -1;
80107bfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c01:	eb 48                	jmp    80107c4b <mappages+0x8b>
    if(*pte & PTE_P)
80107c03:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c06:	8b 00                	mov    (%eax),%eax
80107c08:	83 e0 01             	and    $0x1,%eax
80107c0b:	84 c0                	test   %al,%al
80107c0d:	74 0d                	je     80107c1c <mappages+0x5c>
      panic("remap");
80107c0f:	83 ec 0c             	sub    $0xc,%esp
80107c12:	68 64 8a 10 80       	push   $0x80108a64
80107c17:	e8 46 89 ff ff       	call   80100562 <panic>
    *pte = pa | perm | PTE_P;
80107c1c:	8b 45 18             	mov    0x18(%ebp),%eax
80107c1f:	0b 45 14             	or     0x14(%ebp),%eax
80107c22:	89 c2                	mov    %eax,%edx
80107c24:	83 ca 01             	or     $0x1,%edx
80107c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c2a:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c2f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107c32:	75 07                	jne    80107c3b <mappages+0x7b>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107c34:	b8 00 00 00 00       	mov    $0x0,%eax
80107c39:	eb 10                	jmp    80107c4b <mappages+0x8b>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80107c3b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107c42:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107c49:	eb 95                	jmp    80107be0 <mappages+0x20>
  return 0;
}
80107c4b:	c9                   	leave  
80107c4c:	c3                   	ret    

80107c4d <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107c4d:	55                   	push   %ebp
80107c4e:	89 e5                	mov    %esp,%ebp
80107c50:	53                   	push   %ebx
80107c51:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107c54:	e8 a6 af ff ff       	call   80102bff <kalloc>
80107c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c60:	75 0a                	jne    80107c6c <setupkvm+0x1f>
    return 0;
80107c62:	b8 00 00 00 00       	mov    $0x0,%eax
80107c67:	e9 8f 00 00 00       	jmp    80107cfb <setupkvm+0xae>
  memset(pgdir, 0, PGSIZE);
80107c6c:	83 ec 04             	sub    $0x4,%esp
80107c6f:	68 00 10 00 00       	push   $0x1000
80107c74:	6a 00                	push   $0x0
80107c76:	ff 75 f0             	pushl  -0x10(%ebp)
80107c79:	e8 a0 d5 ff ff       	call   8010521e <memset>
80107c7e:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107c81:	83 ec 0c             	sub    $0xc,%esp
80107c84:	68 00 00 00 0e       	push   $0xe000000
80107c89:	e8 42 fa ff ff       	call   801076d0 <p2v>
80107c8e:	83 c4 10             	add    $0x10,%esp
80107c91:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107c96:	76 0d                	jbe    80107ca5 <setupkvm+0x58>
    panic("PHYSTOP too high");
80107c98:	83 ec 0c             	sub    $0xc,%esp
80107c9b:	68 6a 8a 10 80       	push   $0x80108a6a
80107ca0:	e8 bd 88 ff ff       	call   80100562 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107ca5:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107cac:	eb 40                	jmp    80107cee <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
80107cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107cb1:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80107cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107cb7:	8b 50 04             	mov    0x4(%eax),%edx
80107cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cbd:	8b 58 08             	mov    0x8(%eax),%ebx
80107cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc3:	8b 40 04             	mov    0x4(%eax),%eax
80107cc6:	29 c3                	sub    %eax,%ebx
80107cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ccb:	8b 00                	mov    (%eax),%eax
80107ccd:	83 ec 0c             	sub    $0xc,%esp
80107cd0:	51                   	push   %ecx
80107cd1:	52                   	push   %edx
80107cd2:	53                   	push   %ebx
80107cd3:	50                   	push   %eax
80107cd4:	ff 75 f0             	pushl  -0x10(%ebp)
80107cd7:	e8 e4 fe ff ff       	call   80107bc0 <mappages>
80107cdc:	83 c4 20             	add    $0x20,%esp
80107cdf:	85 c0                	test   %eax,%eax
80107ce1:	79 07                	jns    80107cea <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107ce3:	b8 00 00 00 00       	mov    $0x0,%eax
80107ce8:	eb 11                	jmp    80107cfb <setupkvm+0xae>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107cea:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107cee:	b8 e0 b4 10 80       	mov    $0x8010b4e0,%eax
80107cf3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80107cf6:	72 b6                	jb     80107cae <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107cfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107cfe:	c9                   	leave  
80107cff:	c3                   	ret    

80107d00 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107d00:	55                   	push   %ebp
80107d01:	89 e5                	mov    %esp,%ebp
80107d03:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107d06:	e8 42 ff ff ff       	call   80107c4d <setupkvm>
80107d0b:	a3 38 51 11 80       	mov    %eax,0x80115138
  switchkvm();
80107d10:	e8 02 00 00 00       	call   80107d17 <switchkvm>
}
80107d15:	c9                   	leave  
80107d16:	c3                   	ret    

80107d17 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107d17:	55                   	push   %ebp
80107d18:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107d1a:	a1 38 51 11 80       	mov    0x80115138,%eax
80107d1f:	50                   	push   %eax
80107d20:	e8 9e f9 ff ff       	call   801076c3 <v2p>
80107d25:	83 c4 04             	add    $0x4,%esp
80107d28:	50                   	push   %eax
80107d29:	e8 8a f9 ff ff       	call   801076b8 <lcr3>
80107d2e:	83 c4 04             	add    $0x4,%esp
}
80107d31:	c9                   	leave  
80107d32:	c3                   	ret    

80107d33 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107d33:	55                   	push   %ebp
80107d34:	89 e5                	mov    %esp,%ebp
80107d36:	53                   	push   %ebx
80107d37:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80107d3a:	e8 db d3 ff ff       	call   8010511a <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107d3f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107d45:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107d4c:	83 c2 08             	add    $0x8,%edx
80107d4f:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80107d56:	83 c1 08             	add    $0x8,%ecx
80107d59:	c1 e9 10             	shr    $0x10,%ecx
80107d5c:	88 cb                	mov    %cl,%bl
80107d5e:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80107d65:	83 c1 08             	add    $0x8,%ecx
80107d68:	c1 e9 18             	shr    $0x18,%ecx
80107d6b:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107d72:	67 00 
80107d74:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80107d7b:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80107d81:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107d87:	83 e2 f0             	and    $0xfffffff0,%edx
80107d8a:	83 ca 09             	or     $0x9,%edx
80107d8d:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107d93:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107d99:	83 ca 10             	or     $0x10,%edx
80107d9c:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107da2:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107da8:	83 e2 9f             	and    $0xffffff9f,%edx
80107dab:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107db1:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107db7:	83 ca 80             	or     $0xffffff80,%edx
80107dba:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107dc0:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107dc6:	83 e2 f0             	and    $0xfffffff0,%edx
80107dc9:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107dcf:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107dd5:	83 e2 ef             	and    $0xffffffef,%edx
80107dd8:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107dde:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107de4:	83 e2 df             	and    $0xffffffdf,%edx
80107de7:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107ded:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107df3:	83 ca 40             	or     $0x40,%edx
80107df6:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107dfc:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107e02:	83 e2 7f             	and    $0x7f,%edx
80107e05:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107e0b:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107e11:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e17:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107e1d:	83 e2 ef             	and    $0xffffffef,%edx
80107e20:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107e26:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e2c:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107e32:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e38:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107e3f:	8b 52 08             	mov    0x8(%edx),%edx
80107e42:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107e48:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107e4b:	83 ec 0c             	sub    $0xc,%esp
80107e4e:	6a 30                	push   $0x30
80107e50:	e8 3a f8 ff ff       	call   8010768f <ltr>
80107e55:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80107e58:	8b 45 08             	mov    0x8(%ebp),%eax
80107e5b:	8b 40 04             	mov    0x4(%eax),%eax
80107e5e:	85 c0                	test   %eax,%eax
80107e60:	75 0d                	jne    80107e6f <switchuvm+0x13c>
    panic("switchuvm: no pgdir");
80107e62:	83 ec 0c             	sub    $0xc,%esp
80107e65:	68 7b 8a 10 80       	push   $0x80108a7b
80107e6a:	e8 f3 86 ff ff       	call   80100562 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107e6f:	8b 45 08             	mov    0x8(%ebp),%eax
80107e72:	8b 40 04             	mov    0x4(%eax),%eax
80107e75:	83 ec 0c             	sub    $0xc,%esp
80107e78:	50                   	push   %eax
80107e79:	e8 45 f8 ff ff       	call   801076c3 <v2p>
80107e7e:	83 c4 10             	add    $0x10,%esp
80107e81:	83 ec 0c             	sub    $0xc,%esp
80107e84:	50                   	push   %eax
80107e85:	e8 2e f8 ff ff       	call   801076b8 <lcr3>
80107e8a:	83 c4 10             	add    $0x10,%esp
  popcli();
80107e8d:	e8 ce d2 ff ff       	call   80105160 <popcli>
}
80107e92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107e95:	c9                   	leave  
80107e96:	c3                   	ret    

80107e97 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107e97:	55                   	push   %ebp
80107e98:	89 e5                	mov    %esp,%ebp
80107e9a:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107e9d:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107ea4:	76 0d                	jbe    80107eb3 <inituvm+0x1c>
    panic("inituvm: more than a page");
80107ea6:	83 ec 0c             	sub    $0xc,%esp
80107ea9:	68 8f 8a 10 80       	push   $0x80108a8f
80107eae:	e8 af 86 ff ff       	call   80100562 <panic>
  mem = kalloc();
80107eb3:	e8 47 ad ff ff       	call   80102bff <kalloc>
80107eb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107ebb:	83 ec 04             	sub    $0x4,%esp
80107ebe:	68 00 10 00 00       	push   $0x1000
80107ec3:	6a 00                	push   $0x0
80107ec5:	ff 75 f4             	pushl  -0xc(%ebp)
80107ec8:	e8 51 d3 ff ff       	call   8010521e <memset>
80107ecd:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107ed0:	83 ec 0c             	sub    $0xc,%esp
80107ed3:	ff 75 f4             	pushl  -0xc(%ebp)
80107ed6:	e8 e8 f7 ff ff       	call   801076c3 <v2p>
80107edb:	83 c4 10             	add    $0x10,%esp
80107ede:	83 ec 0c             	sub    $0xc,%esp
80107ee1:	6a 06                	push   $0x6
80107ee3:	50                   	push   %eax
80107ee4:	68 00 10 00 00       	push   $0x1000
80107ee9:	6a 00                	push   $0x0
80107eeb:	ff 75 08             	pushl  0x8(%ebp)
80107eee:	e8 cd fc ff ff       	call   80107bc0 <mappages>
80107ef3:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80107ef6:	83 ec 04             	sub    $0x4,%esp
80107ef9:	ff 75 10             	pushl  0x10(%ebp)
80107efc:	ff 75 0c             	pushl  0xc(%ebp)
80107eff:	ff 75 f4             	pushl  -0xc(%ebp)
80107f02:	e8 d3 d3 ff ff       	call   801052da <memmove>
80107f07:	83 c4 10             	add    $0x10,%esp
}
80107f0a:	c9                   	leave  
80107f0b:	c3                   	ret    

80107f0c <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107f0c:	55                   	push   %ebp
80107f0d:	89 e5                	mov    %esp,%ebp
80107f0f:	53                   	push   %ebx
80107f10:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107f13:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f16:	25 ff 0f 00 00       	and    $0xfff,%eax
80107f1b:	85 c0                	test   %eax,%eax
80107f1d:	74 0d                	je     80107f2c <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80107f1f:	83 ec 0c             	sub    $0xc,%esp
80107f22:	68 ac 8a 10 80       	push   $0x80108aac
80107f27:	e8 36 86 ff ff       	call   80100562 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107f2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f33:	e9 a2 00 00 00       	jmp    80107fda <loaduvm+0xce>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f3b:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f3e:	8d 04 02             	lea    (%edx,%eax,1),%eax
80107f41:	83 ec 04             	sub    $0x4,%esp
80107f44:	6a 00                	push   $0x0
80107f46:	50                   	push   %eax
80107f47:	ff 75 08             	pushl  0x8(%ebp)
80107f4a:	e8 dd fb ff ff       	call   80107b2c <walkpgdir>
80107f4f:	83 c4 10             	add    $0x10,%esp
80107f52:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107f55:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107f59:	75 0d                	jne    80107f68 <loaduvm+0x5c>
      panic("loaduvm: address should exist");
80107f5b:	83 ec 0c             	sub    $0xc,%esp
80107f5e:	68 cf 8a 10 80       	push   $0x80108acf
80107f63:	e8 fa 85 ff ff       	call   80100562 <panic>
    pa = PTE_ADDR(*pte);
80107f68:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f6b:	8b 00                	mov    (%eax),%eax
80107f6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f72:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f78:	8b 55 18             	mov    0x18(%ebp),%edx
80107f7b:	89 d1                	mov    %edx,%ecx
80107f7d:	29 c1                	sub    %eax,%ecx
80107f7f:	89 c8                	mov    %ecx,%eax
80107f81:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107f86:	77 11                	ja     80107f99 <loaduvm+0x8d>
      n = sz - i;
80107f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f8b:	8b 55 18             	mov    0x18(%ebp),%edx
80107f8e:	89 d1                	mov    %edx,%ecx
80107f90:	29 c1                	sub    %eax,%ecx
80107f92:	89 c8                	mov    %ecx,%eax
80107f94:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107f97:	eb 07                	jmp    80107fa0 <loaduvm+0x94>
    else
      n = PGSIZE;
80107f99:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa3:	8b 55 14             	mov    0x14(%ebp),%edx
80107fa6:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107fa9:	83 ec 0c             	sub    $0xc,%esp
80107fac:	ff 75 e8             	pushl  -0x18(%ebp)
80107faf:	e8 1c f7 ff ff       	call   801076d0 <p2v>
80107fb4:	83 c4 10             	add    $0x10,%esp
80107fb7:	ff 75 f0             	pushl  -0x10(%ebp)
80107fba:	53                   	push   %ebx
80107fbb:	50                   	push   %eax
80107fbc:	ff 75 10             	pushl  0x10(%ebp)
80107fbf:	e8 b0 9e ff ff       	call   80101e74 <readi>
80107fc4:	83 c4 10             	add    $0x10,%esp
80107fc7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107fca:	74 07                	je     80107fd3 <loaduvm+0xc7>
      return -1;
80107fcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fd1:	eb 18                	jmp    80107feb <loaduvm+0xdf>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107fd3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fdd:	3b 45 18             	cmp    0x18(%ebp),%eax
80107fe0:	0f 82 52 ff ff ff    	jb     80107f38 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107fe6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107feb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107fee:	c9                   	leave  
80107fef:	c3                   	ret    

80107ff0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107ff0:	55                   	push   %ebp
80107ff1:	89 e5                	mov    %esp,%ebp
80107ff3:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107ff6:	8b 45 10             	mov    0x10(%ebp),%eax
80107ff9:	85 c0                	test   %eax,%eax
80107ffb:	79 0a                	jns    80108007 <allocuvm+0x17>
    return 0;
80107ffd:	b8 00 00 00 00       	mov    $0x0,%eax
80108002:	e9 ae 00 00 00       	jmp    801080b5 <allocuvm+0xc5>
  if(newsz < oldsz)
80108007:	8b 45 10             	mov    0x10(%ebp),%eax
8010800a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010800d:	73 08                	jae    80108017 <allocuvm+0x27>
    return oldsz;
8010800f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108012:	e9 9e 00 00 00       	jmp    801080b5 <allocuvm+0xc5>

  a = PGROUNDUP(oldsz);
80108017:	8b 45 0c             	mov    0xc(%ebp),%eax
8010801a:	05 ff 0f 00 00       	add    $0xfff,%eax
8010801f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108024:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108027:	eb 7d                	jmp    801080a6 <allocuvm+0xb6>
    mem = kalloc();
80108029:	e8 d1 ab ff ff       	call   80102bff <kalloc>
8010802e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108031:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108035:	75 2b                	jne    80108062 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80108037:	83 ec 0c             	sub    $0xc,%esp
8010803a:	68 ed 8a 10 80       	push   $0x80108aed
8010803f:	e8 7f 83 ff ff       	call   801003c3 <cprintf>
80108044:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108047:	83 ec 04             	sub    $0x4,%esp
8010804a:	ff 75 0c             	pushl  0xc(%ebp)
8010804d:	ff 75 10             	pushl  0x10(%ebp)
80108050:	ff 75 08             	pushl  0x8(%ebp)
80108053:	e8 5f 00 00 00       	call   801080b7 <deallocuvm>
80108058:	83 c4 10             	add    $0x10,%esp
      return 0;
8010805b:	b8 00 00 00 00       	mov    $0x0,%eax
80108060:	eb 53                	jmp    801080b5 <allocuvm+0xc5>
    }
    memset(mem, 0, PGSIZE);
80108062:	83 ec 04             	sub    $0x4,%esp
80108065:	68 00 10 00 00       	push   $0x1000
8010806a:	6a 00                	push   $0x0
8010806c:	ff 75 f0             	pushl  -0x10(%ebp)
8010806f:	e8 aa d1 ff ff       	call   8010521e <memset>
80108074:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108077:	83 ec 0c             	sub    $0xc,%esp
8010807a:	ff 75 f0             	pushl  -0x10(%ebp)
8010807d:	e8 41 f6 ff ff       	call   801076c3 <v2p>
80108082:	83 c4 10             	add    $0x10,%esp
80108085:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108088:	83 ec 0c             	sub    $0xc,%esp
8010808b:	6a 06                	push   $0x6
8010808d:	50                   	push   %eax
8010808e:	68 00 10 00 00       	push   $0x1000
80108093:	52                   	push   %edx
80108094:	ff 75 08             	pushl  0x8(%ebp)
80108097:	e8 24 fb ff ff       	call   80107bc0 <mappages>
8010809c:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010809f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801080a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a9:	3b 45 10             	cmp    0x10(%ebp),%eax
801080ac:	0f 82 77 ff ff ff    	jb     80108029 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801080b2:	8b 45 10             	mov    0x10(%ebp),%eax
}
801080b5:	c9                   	leave  
801080b6:	c3                   	ret    

801080b7 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801080b7:	55                   	push   %ebp
801080b8:	89 e5                	mov    %esp,%ebp
801080ba:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801080bd:	8b 45 10             	mov    0x10(%ebp),%eax
801080c0:	3b 45 0c             	cmp    0xc(%ebp),%eax
801080c3:	72 08                	jb     801080cd <deallocuvm+0x16>
    return oldsz;
801080c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801080c8:	e9 a5 00 00 00       	jmp    80108172 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
801080cd:	8b 45 10             	mov    0x10(%ebp),%eax
801080d0:	05 ff 0f 00 00       	add    $0xfff,%eax
801080d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801080dd:	e9 81 00 00 00       	jmp    80108163 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
801080e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e5:	83 ec 04             	sub    $0x4,%esp
801080e8:	6a 00                	push   $0x0
801080ea:	50                   	push   %eax
801080eb:	ff 75 08             	pushl  0x8(%ebp)
801080ee:	e8 39 fa ff ff       	call   80107b2c <walkpgdir>
801080f3:	83 c4 10             	add    $0x10,%esp
801080f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801080f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801080fd:	75 09                	jne    80108108 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
801080ff:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108106:	eb 54                	jmp    8010815c <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80108108:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010810b:	8b 00                	mov    (%eax),%eax
8010810d:	83 e0 01             	and    $0x1,%eax
80108110:	84 c0                	test   %al,%al
80108112:	74 48                	je     8010815c <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80108114:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108117:	8b 00                	mov    (%eax),%eax
80108119:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010811e:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108121:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108125:	75 0d                	jne    80108134 <deallocuvm+0x7d>
        panic("kfree");
80108127:	83 ec 0c             	sub    $0xc,%esp
8010812a:	68 05 8b 10 80       	push   $0x80108b05
8010812f:	e8 2e 84 ff ff       	call   80100562 <panic>
      char *v = p2v(pa);
80108134:	83 ec 0c             	sub    $0xc,%esp
80108137:	ff 75 ec             	pushl  -0x14(%ebp)
8010813a:	e8 91 f5 ff ff       	call   801076d0 <p2v>
8010813f:	83 c4 10             	add    $0x10,%esp
80108142:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108145:	83 ec 0c             	sub    $0xc,%esp
80108148:	ff 75 e8             	pushl  -0x18(%ebp)
8010814b:	e8 13 aa ff ff       	call   80102b63 <kfree>
80108150:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108153:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108156:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010815c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108166:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108169:	0f 82 73 ff ff ff    	jb     801080e2 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010816f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108172:	c9                   	leave  
80108173:	c3                   	ret    

80108174 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108174:	55                   	push   %ebp
80108175:	89 e5                	mov    %esp,%ebp
80108177:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
8010817a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010817e:	75 0d                	jne    8010818d <freevm+0x19>
    panic("freevm: no pgdir");
80108180:	83 ec 0c             	sub    $0xc,%esp
80108183:	68 0b 8b 10 80       	push   $0x80108b0b
80108188:	e8 d5 83 ff ff       	call   80100562 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010818d:	83 ec 04             	sub    $0x4,%esp
80108190:	6a 00                	push   $0x0
80108192:	68 00 00 00 80       	push   $0x80000000
80108197:	ff 75 08             	pushl  0x8(%ebp)
8010819a:	e8 18 ff ff ff       	call   801080b7 <deallocuvm>
8010819f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801081a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801081a9:	eb 42                	jmp    801081ed <freevm+0x79>
    if(pgdir[i] & PTE_P){
801081ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ae:	c1 e0 02             	shl    $0x2,%eax
801081b1:	03 45 08             	add    0x8(%ebp),%eax
801081b4:	8b 00                	mov    (%eax),%eax
801081b6:	83 e0 01             	and    $0x1,%eax
801081b9:	84 c0                	test   %al,%al
801081bb:	74 2d                	je     801081ea <freevm+0x76>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801081bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c0:	c1 e0 02             	shl    $0x2,%eax
801081c3:	03 45 08             	add    0x8(%ebp),%eax
801081c6:	8b 00                	mov    (%eax),%eax
801081c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081cd:	83 ec 0c             	sub    $0xc,%esp
801081d0:	50                   	push   %eax
801081d1:	e8 fa f4 ff ff       	call   801076d0 <p2v>
801081d6:	83 c4 10             	add    $0x10,%esp
801081d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801081dc:	83 ec 0c             	sub    $0xc,%esp
801081df:	ff 75 f0             	pushl  -0x10(%ebp)
801081e2:	e8 7c a9 ff ff       	call   80102b63 <kfree>
801081e7:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801081ea:	ff 45 f4             	incl   -0xc(%ebp)
801081ed:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801081f4:	76 b5                	jbe    801081ab <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801081f6:	8b 45 08             	mov    0x8(%ebp),%eax
801081f9:	83 ec 0c             	sub    $0xc,%esp
801081fc:	50                   	push   %eax
801081fd:	e8 61 a9 ff ff       	call   80102b63 <kfree>
80108202:	83 c4 10             	add    $0x10,%esp
}
80108205:	c9                   	leave  
80108206:	c3                   	ret    

80108207 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108207:	55                   	push   %ebp
80108208:	89 e5                	mov    %esp,%ebp
8010820a:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010820d:	83 ec 04             	sub    $0x4,%esp
80108210:	6a 00                	push   $0x0
80108212:	ff 75 0c             	pushl  0xc(%ebp)
80108215:	ff 75 08             	pushl  0x8(%ebp)
80108218:	e8 0f f9 ff ff       	call   80107b2c <walkpgdir>
8010821d:	83 c4 10             	add    $0x10,%esp
80108220:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108223:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108227:	75 0d                	jne    80108236 <clearpteu+0x2f>
    panic("clearpteu");
80108229:	83 ec 0c             	sub    $0xc,%esp
8010822c:	68 1c 8b 10 80       	push   $0x80108b1c
80108231:	e8 2c 83 ff ff       	call   80100562 <panic>
  *pte &= ~PTE_U;
80108236:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108239:	8b 00                	mov    (%eax),%eax
8010823b:	89 c2                	mov    %eax,%edx
8010823d:	83 e2 fb             	and    $0xfffffffb,%edx
80108240:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108243:	89 10                	mov    %edx,(%eax)
}
80108245:	c9                   	leave  
80108246:	c3                   	ret    

80108247 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108247:	55                   	push   %ebp
80108248:	89 e5                	mov    %esp,%ebp
8010824a:	53                   	push   %ebx
8010824b:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010824e:	e8 fa f9 ff ff       	call   80107c4d <setupkvm>
80108253:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108256:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010825a:	75 0a                	jne    80108266 <copyuvm+0x1f>
    return 0;
8010825c:	b8 00 00 00 00       	mov    $0x0,%eax
80108261:	e9 f6 00 00 00       	jmp    8010835c <copyuvm+0x115>
  for(i = 0; i < sz; i += PGSIZE){
80108266:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010826d:	e9 c2 00 00 00       	jmp    80108334 <copyuvm+0xed>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108272:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108275:	83 ec 04             	sub    $0x4,%esp
80108278:	6a 00                	push   $0x0
8010827a:	50                   	push   %eax
8010827b:	ff 75 08             	pushl  0x8(%ebp)
8010827e:	e8 a9 f8 ff ff       	call   80107b2c <walkpgdir>
80108283:	83 c4 10             	add    $0x10,%esp
80108286:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108289:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010828d:	75 0d                	jne    8010829c <copyuvm+0x55>
      panic("copyuvm: pte should exist");
8010828f:	83 ec 0c             	sub    $0xc,%esp
80108292:	68 26 8b 10 80       	push   $0x80108b26
80108297:	e8 c6 82 ff ff       	call   80100562 <panic>
    if(!(*pte & PTE_P))
8010829c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010829f:	8b 00                	mov    (%eax),%eax
801082a1:	83 e0 01             	and    $0x1,%eax
801082a4:	85 c0                	test   %eax,%eax
801082a6:	75 0d                	jne    801082b5 <copyuvm+0x6e>
      panic("copyuvm: page not present");
801082a8:	83 ec 0c             	sub    $0xc,%esp
801082ab:	68 40 8b 10 80       	push   $0x80108b40
801082b0:	e8 ad 82 ff ff       	call   80100562 <panic>
    pa = PTE_ADDR(*pte);
801082b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082b8:	8b 00                	mov    (%eax),%eax
801082ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801082c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082c5:	8b 00                	mov    (%eax),%eax
801082c7:	25 ff 0f 00 00       	and    $0xfff,%eax
801082cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801082cf:	e8 2b a9 ff ff       	call   80102bff <kalloc>
801082d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801082d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801082db:	74 68                	je     80108345 <copyuvm+0xfe>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
801082dd:	83 ec 0c             	sub    $0xc,%esp
801082e0:	ff 75 e8             	pushl  -0x18(%ebp)
801082e3:	e8 e8 f3 ff ff       	call   801076d0 <p2v>
801082e8:	83 c4 10             	add    $0x10,%esp
801082eb:	83 ec 04             	sub    $0x4,%esp
801082ee:	68 00 10 00 00       	push   $0x1000
801082f3:	50                   	push   %eax
801082f4:	ff 75 e0             	pushl  -0x20(%ebp)
801082f7:	e8 de cf ff ff       	call   801052da <memmove>
801082fc:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801082ff:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108302:	83 ec 0c             	sub    $0xc,%esp
80108305:	ff 75 e0             	pushl  -0x20(%ebp)
80108308:	e8 b6 f3 ff ff       	call   801076c3 <v2p>
8010830d:	83 c4 10             	add    $0x10,%esp
80108310:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108313:	83 ec 0c             	sub    $0xc,%esp
80108316:	53                   	push   %ebx
80108317:	50                   	push   %eax
80108318:	68 00 10 00 00       	push   $0x1000
8010831d:	52                   	push   %edx
8010831e:	ff 75 f0             	pushl  -0x10(%ebp)
80108321:	e8 9a f8 ff ff       	call   80107bc0 <mappages>
80108326:	83 c4 20             	add    $0x20,%esp
80108329:	85 c0                	test   %eax,%eax
8010832b:	78 1b                	js     80108348 <copyuvm+0x101>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010832d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108337:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010833a:	0f 82 32 ff ff ff    	jb     80108272 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108340:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108343:	eb 17                	jmp    8010835c <copyuvm+0x115>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108345:	90                   	nop
80108346:	eb 01                	jmp    80108349 <copyuvm+0x102>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80108348:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108349:	83 ec 0c             	sub    $0xc,%esp
8010834c:	ff 75 f0             	pushl  -0x10(%ebp)
8010834f:	e8 20 fe ff ff       	call   80108174 <freevm>
80108354:	83 c4 10             	add    $0x10,%esp
  return 0;
80108357:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010835c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010835f:	c9                   	leave  
80108360:	c3                   	ret    

80108361 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108361:	55                   	push   %ebp
80108362:	89 e5                	mov    %esp,%ebp
80108364:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108367:	83 ec 04             	sub    $0x4,%esp
8010836a:	6a 00                	push   $0x0
8010836c:	ff 75 0c             	pushl  0xc(%ebp)
8010836f:	ff 75 08             	pushl  0x8(%ebp)
80108372:	e8 b5 f7 ff ff       	call   80107b2c <walkpgdir>
80108377:	83 c4 10             	add    $0x10,%esp
8010837a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010837d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108380:	8b 00                	mov    (%eax),%eax
80108382:	83 e0 01             	and    $0x1,%eax
80108385:	85 c0                	test   %eax,%eax
80108387:	75 07                	jne    80108390 <uva2ka+0x2f>
    return 0;
80108389:	b8 00 00 00 00       	mov    $0x0,%eax
8010838e:	eb 29                	jmp    801083b9 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108390:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108393:	8b 00                	mov    (%eax),%eax
80108395:	83 e0 04             	and    $0x4,%eax
80108398:	85 c0                	test   %eax,%eax
8010839a:	75 07                	jne    801083a3 <uva2ka+0x42>
    return 0;
8010839c:	b8 00 00 00 00       	mov    $0x0,%eax
801083a1:	eb 16                	jmp    801083b9 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
801083a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083a6:	8b 00                	mov    (%eax),%eax
801083a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083ad:	83 ec 0c             	sub    $0xc,%esp
801083b0:	50                   	push   %eax
801083b1:	e8 1a f3 ff ff       	call   801076d0 <p2v>
801083b6:	83 c4 10             	add    $0x10,%esp
}
801083b9:	c9                   	leave  
801083ba:	c3                   	ret    

801083bb <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801083bb:	55                   	push   %ebp
801083bc:	89 e5                	mov    %esp,%ebp
801083be:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801083c1:	8b 45 10             	mov    0x10(%ebp),%eax
801083c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801083c7:	e9 87 00 00 00       	jmp    80108453 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
801083cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801083cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801083d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083da:	83 ec 08             	sub    $0x8,%esp
801083dd:	50                   	push   %eax
801083de:	ff 75 08             	pushl  0x8(%ebp)
801083e1:	e8 7b ff ff ff       	call   80108361 <uva2ka>
801083e6:	83 c4 10             	add    $0x10,%esp
801083e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801083ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801083f0:	75 07                	jne    801083f9 <copyout+0x3e>
      return -1;
801083f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801083f7:	eb 69                	jmp    80108462 <copyout+0xa7>
    n = PGSIZE - (va - va0);
801083f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801083fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
801083ff:	89 d1                	mov    %edx,%ecx
80108401:	29 c1                	sub    %eax,%ecx
80108403:	89 c8                	mov    %ecx,%eax
80108405:	05 00 10 00 00       	add    $0x1000,%eax
8010840a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010840d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108410:	3b 45 14             	cmp    0x14(%ebp),%eax
80108413:	76 06                	jbe    8010841b <copyout+0x60>
      n = len;
80108415:	8b 45 14             	mov    0x14(%ebp),%eax
80108418:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010841b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010841e:	8b 55 0c             	mov    0xc(%ebp),%edx
80108421:	89 d1                	mov    %edx,%ecx
80108423:	29 c1                	sub    %eax,%ecx
80108425:	89 c8                	mov    %ecx,%eax
80108427:	03 45 e8             	add    -0x18(%ebp),%eax
8010842a:	83 ec 04             	sub    $0x4,%esp
8010842d:	ff 75 f0             	pushl  -0x10(%ebp)
80108430:	ff 75 f4             	pushl  -0xc(%ebp)
80108433:	50                   	push   %eax
80108434:	e8 a1 ce ff ff       	call   801052da <memmove>
80108439:	83 c4 10             	add    $0x10,%esp
    len -= n;
8010843c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010843f:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108442:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108445:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108448:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010844b:	05 00 10 00 00       	add    $0x1000,%eax
80108450:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108453:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108457:	0f 85 6f ff ff ff    	jne    801083cc <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010845d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108462:	c9                   	leave  
80108463:	c3                   	ret    
