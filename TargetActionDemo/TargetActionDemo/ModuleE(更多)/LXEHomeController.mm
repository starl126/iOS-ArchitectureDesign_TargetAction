//
//  LXEHomeController.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2019/6/29.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXEHomeController.h"
#import "LXHttpSessionTask.h"
#import "LXETestController.h"
#import "SMCallStack.h"
#import "SMLagMonitor.h"

#import <mach/task_info.h>
#import <mach/task.h>
#import <mach/mach_init.h>
#import <mach/thread_act.h>
#import <mach/thread_info.h>
#import <mach/vm_map.h>

#import "EncryptTools.h"

#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <mach-o/getsect.h>
#import "LXdladdr.h"
#import <mach/mach_time.h>

typedef void (^WXModuleCallback)(id result);
typedef void (^WXModuleKeepAliveCallback)(id result, BOOL keepAlive);

@interface LXEHomeController ()

@property (nonatomic, strong) LXHttpSessionTask* sessionTask;
@property (nonatomic, strong) dispatch_semaphore_t signal;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation LXEHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更多";
    self.view.lx_backgroundColor(UIColor.whiteColor);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_observerNoti01:) name:@"noti_01" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_observerNoti02:) name:@"noti_02" object:nil];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgV.image = [UIImage imageNamed:@"Image"];
    [self.view addSubview:imgV];
    self.signal = dispatch_semaphore_create(1);
    self.queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    Method method = class_getInstanceMethod(self.class, @selector(p_testName:callback:keepCallback:));
    char des[40];
    const char *types = method_getTypeEncoding(method);
//     [NSMethodSignature methodForSelector:@selector(p_testName:callback:keepCallback:)];
//    NSMethodSignature *signature = [self.class instanceMethodSignatureForSelector:@selector(p_testName:callback:keepCallback:)];
//    const char *type1 = [signature getArgumentTypeAtIndex:3];
//    const char *type2 = [signature getArgumentTypeAtIndex:4];
    
    Method method2 = class_getInstanceMethod(self.class, @selector(p_testName:keepCallback:));
    const char *types2 = method_getTypeEncoding(method2);
    
    NSURL *url = [NSURL URLWithString:@"iosbridge://methodName/type=0/1?params=""&commandId=1234"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_semaphore_wait(self.signal, DISPATCH_TIME_FOREVER);
        dispatch_async(self.queue, ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LXLog(@"111111111");
                dispatch_semaphore_signal(self.signal);
            });
        });
        
        dispatch_semaphore_wait(self.signal, DISPATCH_TIME_FOREVER);
        dispatch_async(self.queue, ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LXLog(@"22222222222");
                dispatch_semaphore_signal(self.signal);
            });
        });
        
        dispatch_semaphore_wait(self.signal, DISPATCH_TIME_FOREVER);
        dispatch_async(self.queue, ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LXLog(@"33333333333");
                dispatch_semaphore_signal(self.signal);
            });
        });
    });
}

- (void)p_testName:(NSString *)name callback:(WXModuleCallback)callback keepCallback:(WXModuleKeepAliveCallback)keepCallback {
    
}
- (void)p_testName:(NSString *)name keepCallback:(WXModuleKeepAliveCallback)keepCallback {
    
}
/// 测试内部方法有没有被外界hook
BOOL checkMethodBeHooked(Class cls, SEL selector) {
    
    //你也可以借助runtime中的C函数来获取方法的实现地址
    IMP imp = [cls methodForSelector:selector];
    
    if(imp == NULL)
        
        return NO;
    
    //计算出可执行程序的slide值。
    
    intptr_t pmh = (intptr_t)_dyld_get_image_header(1);
    
#ifdef __LP64__
    const struct segment_command_64 *psegment = getsegbyname("__TEXT");
#else
    const struct segment_command *psegment = getsegbyname("__TEXT");
#endif
    
    intptr_t slide = pmh - psegment->vmaddr;
    
    unsigned long startpos = (unsigned long)pmh;
    
    unsigned long endpos = get_end() + slide;
    
    unsigned long imppos = (unsigned long)imp;
    
    return(imppos < startpos) || (imppos > endpos);
    
}
void termFunc(void *objAddr) {
    printf("%s", objAddr);
}
- (void)p_postNotification01:(NSString *)noti {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noti_01" object:nil];
}
- (void)p_postNotification02:(NSString *)noti {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noti_02" object:nil];
}
- (void)p_observerNoti01:(NSNotification *)noti {
    NSLog(@"%@", noti);
}
- (void)p_observerNoti02:(NSNotification *)noti {
    NSLog(@"%@", noti);
}
/// 常住子线程
- (void)testThreadPermanantLife {
    [self performSelector:@selector(testSemaphore) onThread:[LXEHomeController sharedThread] withObject:nil waitUntilDone:NO];
}
+ (NSThread *)sharedThread {
    static NSThread *thread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadTest) object:nil];
        thread.name = @"threadTest";
        [thread start];
    });
    return thread;
}
+ (void)threadTest {
    @autoreleasepool {
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runloop run];
    }
}

/// 测试semaphore
- (void)testSemaphore {
    NSLog(@"开始");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    dispatch_async(dispatch_queue_create("one", DISPATCH_QUEUE_CONCURRENT), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSLog(@"任务1=%@", [NSThread currentThread]);
        
        sleep(5);
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_async(dispatch_queue_create("two", DISPATCH_QUEUE_CONCURRENT), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSLog(@"任务2=%@", [NSThread currentThread]);
        
        sleep(5);
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_async(dispatch_queue_create("three", DISPATCH_QUEUE_CONCURRENT), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSLog(@"任务3=%@", [NSThread currentThread]);
        
        sleep(5);
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_async(dispatch_queue_create("four", DISPATCH_QUEUE_CONCURRENT), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSLog(@"任务4=%@", [NSThread currentThread]);
        
        sleep(5);
        dispatch_semaphore_signal(semaphore);
    });
    
}
/// 测试子线程的performSelector
- (void)testPerformSelectorMultiThread {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    
    for (NSInteger i = 0; i < 10; i++) {
        
        dispatch_barrier_async(concurrentQueue, ^{
            if (i % 2 == 1) {
                sleep(2);
            }
            NSLog(@"%zd",i);
        });
    }
    
    dispatch_barrier_sync(concurrentQueue, ^{
        
        NSLog(@"barrier");
    });
    
    for (NSInteger i = 10; i < 20; i++) {
        
        dispatch_sync(concurrentQueue, ^{
            
            NSLog(@"%zd",i);
        });
    }
}
- (void)testForPrint {
    NSLog(@"1111");
}
/// 测试主线程卡顿
- (void)testMainThread {
    CFRunLoopObserverRef observerRef = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                LXLog(@"进入");
                break;
            case kCFRunLoopBeforeTimers:
                LXLog(@"BeforeTimers");
                break;
            case kCFRunLoopBeforeSources:
                LXLog(@"BeforeSources");
                break;
            case kCFRunLoopBeforeWaiting:
                LXLog(@"BeforeWaiting");
                break;
            case kCFRunLoopAfterWaiting:
                LXLog(@"AfterWaiting");
                break;
            case kCFRunLoopExit:
                LXLog(@"Exit");
                break;
            default:
                break;
        }
        if (activity == kCFRunLoopEntry) {
            LXLog(@"进入");
        }
    });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observerRef, kCFRunLoopCommonModes);
}
/// 获取当前应用的内存占用情况，和Xcode数值相近
+ (double)getMemoryUsage {
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    if(task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count) == KERN_SUCCESS) {
        return (double)vmInfo.phys_footprint / (1024 * 1024);
    } else {
        return -1.0;
    }
}
/// 获取cpu使用情况
+ (double)getCpuUsage {
    kern_return_t           kr;
    thread_array_t          threadList;         // 保存当前Mach task的线程列表
    mach_msg_type_number_t  threadCount;        // 保存当前Mach task的线程个数
    thread_info_data_t      threadInfo;         // 保存单个线程的信息列表
    mach_msg_type_number_t  threadInfoCount;    // 保存当前线程的信息列表大小
    thread_basic_info_t     threadBasicInfo;    // 线程的基本信息
    
    // 通过“task_threads”API调用获取指定 task 的线程列表
    //  mach_task_self_，表示获取当前的 Mach task
    kr = task_threads(mach_task_self(), &threadList, &threadCount);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    double cpuUsage = 0;
    for (int i = 0; i < threadCount; i++) {
        threadInfoCount = THREAD_INFO_MAX;
        // 通过“thread_info”API调用来查询指定线程的信息
        //  flavor参数传的是THREAD_BASIC_INFO，使用这个类型会返回线程的基本信息，
        //  定义在 thread_basic_info_t 结构体，包含了用户和系统的运行时间、运行状态和调度优先级等
        kr = thread_info(threadList[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        threadBasicInfo = (thread_basic_info_t)threadInfo;
        if (!(threadBasicInfo->flags & TH_FLAGS_IDLE)) {
            cpuUsage += threadBasicInfo->cpu_usage;
        }
    }
    
    // 回收内存，防止内存泄漏
    vm_deallocate(mach_task_self(), (vm_offset_t)threadList, threadCount * sizeof(thread_t));

    return cpuUsage / (double)TH_USAGE_SCALE * 100.0;
}

#pragma mark --- lazy


@end

