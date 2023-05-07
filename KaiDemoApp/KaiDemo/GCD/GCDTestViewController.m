//
//  GCDTestViewController.m
//  KaiDemo
//
//  Created by KaiKai on 2023/5/7.
//

#import "GCDTestViewController.h"

const NSNotificationName KaiTestNotificationName = @"KaiTestNotification";

@interface GCDTestViewController ()

@property (nonatomic, strong) dispatch_queue_t concurrentQueue;
@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, assign) int soldCount;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSRecursiveLock *rLock;

@end

@implementation GCDTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.concurrentQueue = dispatch_queue_create("kai_concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:KaiTestNotificationName object:nil];
    
    [self addOneTest:@"dispatch_barrier_async" selector:@selector(dispatch_barrier_test:) withObject:@(NO)];
    [self addOneTest:@"dispatch_barrier_sync" selector:@selector(dispatch_barrier_test:) withObject:@(YES)];
    [self addOneTest:@"dispatch_group_notify" selector:@selector(dispatch_group_notify)];
    [self addOneTest:@"dispatch_group_ enter leave" selector:@selector(dispatch_group_enter_leave)];
    [self addOneTest:@"dispatch_group_wait 2s" selector:@selector(dispatch_group_wait:) withObject:@(2)];
    [self addOneTest:@"dispatch_group_wait 5s" selector:@selector(dispatch_group_wait:) withObject:@(5)];
    [self addOneTest:@"dispatch_semaphore_wait 加锁" selector:@selector(dispatch_semaphore_wait_for_lock)];
    [self addOneTest:@"dispatch_semaphore_wait 异步返回" selector:@selector(dispatch_semaphore_wait_for_return)];
    [self addOneTest:@"dispatch_semaphore_wait 控制并发" selector:@selector(dispatch_semaphore_wait_for_concurrent)];
    [self addOneTest:@"no NSLock/RecursiveLock 卖票" selector:@selector(sellTicketEntry:) withObject:@(NO)];
    [self addOneTest:@"has NSLock/RecursiveLock 卖票" selector:@selector(sellTicketEntry:) withObject:@(YES)];
    [self addOneTest:@"NSNotificationQueue YES" selector:@selector(notificationQueueEntry:) withObject:@(YES)];
    [self addOneTest:@"NSNotificationQueue NO" selector:@selector(notificationQueueEntry:) withObject:@(NO)];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
};

- (void)receivedNotification:(NSNotification *)notify {
    NSLog(@"lookKaiNotify receivedNotification: %@", [NSThread currentThread]);
}

- (void)notificationQueueEntry:(NSNumber *)useQueue {
    dispatch_block_t block = ^() {
        NSLog(@"lookKaiNotify notificationQueueEntry begin useQueue=%@: %@", useQueue, [NSThread currentThread]);
        NSNotification *notify = [NSNotification notificationWithName:KaiTestNotificationName object:nil];
        if (useQueue.boolValue) {
//用队列似乎只能在主线程enqueue,不然收不到,不触发receivedNotification
            [[NSNotificationQueue defaultQueue] enqueueNotification:notify postingStyle:NSPostASAP];
        } else {
//直接post可以在非主线程post,在同一线程收到
            [[NSNotificationCenter defaultCenter] postNotification:notify];
        }
        NSLog(@"lookKaiNotify notificationQueuelEntry end useQueue=%@: %@", useQueue, [NSThread currentThread]);
    };
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
    block();
}

- (void)sellTicketEntry:(NSNumber *)lockObj {
    NSMutableArray *muTickets = [NSMutableArray array];
    for (NSInteger index = 101; index <= 130; ++index) {
        [muTickets addObject:[NSString stringWithFormat:@"票_%ld", index]];
    }
    self.tickets = muTickets.copy;
    self.soldCount = 0;
    self.lock = [[NSLock alloc] init];
    self.rLock = [[NSRecursiveLock alloc] init];
//第一窗口
    NSThread *windowOne = [[NSThread alloc] initWithTarget:self selector:@selector(soldTicketInTread:) object:lockObj];
    windowOne.name = @"一号窗口";
    [windowOne start];
//第二窗口
    NSThread *windowTwo = [[NSThread alloc] initWithTarget:self selector:@selector(soldTicketInTread:) object:lockObj];
    windowTwo.name = @"二号窗口";
    [windowTwo start];
//第三窗口
    NSThread *windowThree = [[NSThread alloc] initWithTarget:self selector:@selector(soldTicketInTread:) object:lockObj];
    windowThree.name = @"三号窗口";
    [windowThree start];
//第四窗口
    NSThread *windowFour = [[NSThread alloc] initWithTarget:self selector:@selector(soldTicketInTread:) object:lockObj];
    windowFour.name = @"四号窗口";
    [windowFour start];
}

- (void)soldTicketInTread:(NSNumber *)lockObj {
    BOOL lock = lockObj != nil ? lockObj.boolValue : NO;
    BOOL rLock = YES;
    if (lock) {
        //NSLock即使同一线程，也不能连续lock两次，会死锁，NSRecursiveLock可以，但也要unlock对应次数
        rLock ? [self.rLock lock] : [self.lock lock];
    }
    if (self.soldCount == self.tickets.count) {
        NSLog(@"=====%@ 剩余票数：%lu", [[NSThread currentThread] name], self.tickets.count - self.soldCount);
        //解锁
        if (lock) {
            rLock ? [self.rLock unlock] : [self.lock unlock];
        }
        return;
    }
    //延时卖票
    [NSThread sleepForTimeInterval:0.2];
    self.soldCount++;//如果不加锁，可能某线程在这里暂停，恢复时下一步用了相同索引，卖了同一张票;
    //如果刚好++前暂停,会有两个以上线程上面判断都不是最后一张，进入++,还会导致数组越界crash,Terminating app due to uncaught exception'NSRangeException'
    //                                    reason: '*** -[__NSFrozenArrayM objectAtIndexedSubscript:]: index 30 beyond bounds [0 .. 29]'
    NSLog(@"=====%@,卖%@ 剩%lu", [[NSThread currentThread] name], self.tickets[self.soldCount - 1], self.tickets.count - self.soldCount);
    //解锁
    if (lock) {
        rLock ? [self.rLock unlock] : [self.lock unlock];
    }
//继续卖票
    usleep(1); // 1us (故意休眠1微妙，给其它线程获得lock锁的机会)
    [self soldTicketInTread:lockObj];//NSRecursiveLock相同线程可重入，也会导致递归调用时本线程依然获得了锁，导致其它线程不起作用
}

- (void)dispatch_barrier_test:(NSNumber *)sync {
    NSLog(@"lookKai dispatch_barrier sync=%@", sync);
    NSLog(@"main ———1--");
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"test1 begin – ");
        sleep(3);
        NSLog(@"test1 - end - ");
    });
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"test2 begin – ");
        sleep(3);
        NSLog(@"test2 - end - ");
    });
    if (sync.boolValue) {
        dispatch_barrier_sync(self.concurrentQueue, ^{//分界线在这里
            NSLog(@"barrier –- start");
            sleep(1);
            NSLog(@"barrier —- end");
        });
    } else {
        dispatch_barrier_async(self.concurrentQueue, ^{//分界线在这里
            NSLog(@"barrier -- start");
            sleep(1);
            NSLog(@"barrier –- end");
        });
    }
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"test4 begin - ");
        sleep(3);
        NSLog(@"test4 - end - ");
    });
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"test5 begin - ");
        sleep(3);
        NSLog(@"test5 - end - ");
    });
    NSLog(@"main ---6—-");
}

- (void)dispatch_barrier_sync {
    NSLog(@"lookKai dispatch_barrier_sync");
    NSLog(@"main ———1—-");
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"test1 begin - ");
        sleep(3);
        NSLog(@"test1 - end - ");
    });
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"test2 begin - ");
        sleep(3);
        NSLog(@"test2 – end - ");
    });
    dispatch_barrier_async(self.concurrentQueue, ^{///分界线在这里
        NSLog(@"barrier -- start");
        sleep(1);
        NSLog(@"barrier -- end");
    });
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"test4 begin - ");
        sleep(3);
        NSLog(@"test4 – end – ");
    });
    dispatch_async(self.concurrentQueue, ^{
        NSLog(@"test5 begin – ");
        sleep(3);
        NSLog(@"test5 - end – ");
    });
    NSLog(@"main –——6—-");
}

- (void)dispatch_group_notify {
//创建队列组
    dispatch_group_t group = dispatch_group_create();
    NSLog(@"dispatch_group_notify ----group--start----");
//封装任务
    dispatch_group_async(group, self.concurrentQueue, ^{
        sleep(2);
        NSLog(@"1 - ---%@", [NSThread currentThread]);
    });
    dispatch_group_async(group, self.concurrentQueue, ^{
        sleep(1);
        NSLog(@"2- -%@", [NSThread currentThread]);
    });
    dispatch_group_async(group, self.concurrentQueue, ^{
        sleep(3);
        NSLog(@"3---%@", [NSThread currentThread]);
    });
//4.拦截通知
    dispatch_group_notify(group, self.concurrentQueue, ^{
        NSLog(@"---dispatch_group_notify------%@", [NSThread currentThread]);//这个线程是在最后一个dispatch_group_async结束的线程,此例是3
    });
//不用等待，队列任务添加完但未执行完就会立即执行这个代码
    NSLog(@"----group--end----");
}

- (void)dispatch_group_enter_leave {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    //模拟多线程耗时操作
    dispatch_group_async(group, self.concurrentQueue, ^{
        dispatch_async(self.concurrentQueue, ^{
            NSLog(@"1---1--begin");
            sleep(3);
            NSLog(@"1–--1--end");
            dispatch_group_leave(group);
        });
    });
    dispatch_group_enter(group);
    //模拟多线程耗时操作
    dispatch_group_async(group, self.concurrentQueue, ^{
        dispatch_async(self.concurrentQueue, ^{
            NSLog(@"2–—–2––begin");
            sleep(2);
            NSLog(@"2––2–end");
            dispatch_group_leave(group);
//            dispatch_group_leave(group);//enter与leave要匹配,不然crash
        });
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        // 如果上面不加group_enter与leave，那么此处很快完成。
        // 因为dispatch_group_async里任务很轻量只是触发了另一个异步任务
        NSLog(@"%@-—-全部done。。。", [NSThread currentThread]);
    });
    NSLog(@"main");
}

- (void)dispatch_group_wait:(NSNumber *)waitSecond {
    dispatch_group_t group = dispatch_group_create();
//异步
    dispatch_group_async(group, self.concurrentQueue, ^{
        usleep(1500 * 1000); //1.5秒
        NSLog(@"1");
    });
    dispatch_group_async(group, self.concurrentQueue, ^{
        sleep(1);
        NSLog(@"2");
    });
    dispatch_group_async(group, self.concurrentQueue, ^{
        sleep(3);
        NSLog(@"3");
    });
    NSLog(@"dispatch_group_wait %lds", waitSecond.integerValue);
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, waitSecond.integerValue * NSEC_PER_SEC);
    long result = dispatch_group_wait(group, time);
    if (result == 0) {
//属于Dispatch Group的Block全部处理结束
        NSLog(@"全部处理结束");
    } else {
//属于Dispatch Group的某一个处理还在执行中
        NSLog(@"某一个处理还在执行中:result=%ld", result);
    }
    NSLog(@"main");
}

- (void)dispatch_semaphore_wait_for_lock {
    NSLog(@"lookKai dispatch_semaphore_wait_for_lock");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    NSMutableString *str = [NSMutableString new];
    for (NSInteger i = 0; i < 10; i++) {
        dispatch_async(self.concurrentQueue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"lookKai wait_for_lock idx=%ld", i);//只保证这段代码不会被中断执行,但不保证i的顺序
//            [str appendFormat:@"%ld_",i];
            dispatch_semaphore_signal(semaphore);
        });
    }
    NSLog(@"lookKai summeary: %@", str);
}

- (void)dispatch_semaphore_wait_for_return {
    NSLog(@"lookKai dispatch_semaphore_wait_for_return");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2.0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
// 注意此处不能与下面wait是同一个线程,不然死锁了
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"lookKai async task complete");
}

- (void)dispatch_semaphore_wait_for_concurrent {
    NSLog(@"lookKai dispatch_semaphore_wait_for_concurrent");
    dispatch_group_t group = dispatch_group_create();
    NSInteger correntNum = 3;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(correntNum);
    for (int i = 0; i < 10; i++) {
        dispatch_group_async(group, self.concurrentQueue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"%d---开始--", i);
//线程操作区域 最多有 correntNum 个线程在此做事情
            sleep(2);
            NSLog(@"%d --- end --", i);
            dispatch_semaphore_signal(semaphore);
        });
    }
//group任务全部执行完毕回调
    dispatch_group_notify(group, self.concurrentQueue, ^{
        NSLog(@"lookKai all done");
    });
}

@end
