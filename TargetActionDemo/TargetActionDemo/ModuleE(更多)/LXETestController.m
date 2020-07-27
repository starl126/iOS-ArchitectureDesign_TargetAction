//
//  LXETestController.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/5/12.
//  Copyright © 2020 starxin. All rights reserved.
//

#import "LXETestController.h"
#import "LXXCTestExample.h"

@interface LXProxy: NSProxy

@property (nonatomic, weak, readonly) id target;

+ (instancetype)proxyWithTarget:(id)target;
- (instancetype)initWithTarget:(id)target;

@end

@implementation LXProxy

+ (instancetype)proxyWithTarget:(id)target {
    return [[self alloc] initWithTarget:target];
}
- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}
- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL sel = [invocation selector];
    if ([self.target respondsToSelector:sel]) {
        [invocation invokeWithTarget:self.target];
    }
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}
- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self.target respondsToSelector:aSelector];
}

@end

@interface LXETestController ()

@property (nonatomic, strong) CADisplayLink* displayLink;
@property (nonatomic, strong) LXProxy* fpsProxy;
@property (nonatomic, assign) CFTimeInterval lastTime;
@property (nonatomic, assign) NSUInteger currentFps;

@end

@implementation LXETestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"测试";
    self.view.backgroundColor = [UIColor lightGrayColor];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
//    [self orderlistMerge];
//    [self hashTest];
    [LXXCTestExample blockTest];
}
- (void)hashTest {
    NSString * testString = @"abaccdeff";
    char testCh[100];
    memcpy(testCh, [testString cStringUsingEncoding:NSUTF8StringEncoding], testString.length);
    
    int list[256];
    for (int i=0; i<256; i++) {
        list[i] = 0;
    }
    
    char *p = testCh;
    char result = '\0';
    while (*p != result) {
        list[*(p++)]++;
    }
    p = testCh;
    
    while (*p != result) {
        if (list[*p] == 1) {
            result = *p;
            break;
        }
        p++;
    }
    printf("result:%c\n", result);
}

- (void)orderlistMerge {
    int aLen = 5,bLen = 9;
    int a[] = {1,4,6,7,9};
    int b[] = {2,3,5,6,8,9,10,11,12};
    int c[aLen+bLen];
    
    //i代表数组a，j代表数组b，idx代表数组c的索引
    int i = 0,j = 0,idx = 0;
    while (i < aLen && j < bLen) {
        if (a[i] < b[j]) {
            c[idx++] = a[i++];
        }else {
            c[idx++] = b[j++];
        }
    }
    while (j < bLen) {
        c[idx++] = b[j++];
    }
}

struct Node {
    NSInteger data;
    struct Node *next;
};
/// reverse list table
- (void)listReverse {
    struct Node *list = [self constructList];
    struct Node *head = NULL;
    
    while (list != NULL) {
        struct Node *temp = list->next;
        list->next = head;
        head = temp;
        list = head;
    }
}

/// construct list table
- (struct Node *)constructList {
    struct Node *head = NULL;
    struct Node *cur  = NULL;
    
    for (int i=0; i<10; i++) {
        struct Node *node = malloc(sizeof(struct Node));
        node -> data = i;
        if (head == NULL) {
            head = node;
        }else {
            cur ->next = node;
        }
        cur = node;
    }
    return head;
}
/// 获取当前的FPS
- (void)getInstantFPSWithLink:(CADisplayLink*)displayLink {
    NSTimeInterval delta = displayLink.timestamp - self.lastTime;
    self.currentFps = 1 / delta;
    self.lastTime = displayLink.timestamp;
    LXLog(@"%tu帧",self.currentFps);
}
- (void)dealloc {
    [self.displayLink invalidate];
    LXLog(@"dealloc --- %@", NSStringFromClass(self.class));
}

#pragma mark --- lazy
- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        self.fpsProxy = [LXProxy proxyWithTarget:self];
        _displayLink = [CADisplayLink displayLinkWithTarget:self.fpsProxy selector:@selector(getInstantFPSWithLink:)];
    }
    return _displayLink;
}

@end
