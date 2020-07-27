//
//  TargetActionDemoTests.m
//  TargetActionDemoTests
//
//  Created by 天边的星星 on 2019/6/29.
//  Copyright © 2019 starxin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LXCHomeController.h"
#import "LXHttpSessionTask.h"
#import "LXXCTestExample.h"

@interface TargetActionDemoTests : XCTestCase<XCTWaiterDelegate>

/// 测试异步请求
@property (nonatomic, strong) XCTestExpectation *exp1;
@property (nonatomic, strong) XCTestExpectation *exp2;

@end

@implementation TargetActionDemoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testExampleMock {
//    id exMock = [OCMockObject mockForClass:LXXCTestExample.class];
//    [[[exMock stub] andReturnValue: OCMOCK_VALUE(10)] example1:[OCMArg any]];
//    int mockRet = [exMock example1:@(10)];
//    [exMock stopMocking];
    
    id userDefaultsMock = OCMClassMock(LXXCTestExample.class);
    OCMStub([userDefaultsMock example1:[OCMArg any]]).andReturn(22);
    int result = [userDefaultsMock example1:@(100)];
    NSLog(@"result = %d", result);
}

- (void)DISABLE_testCHomeTest {
    LXCHomeController *vc = [[LXCHomeController alloc] init];
    [vc p_test:2];
    
    self.exp1 = [[XCTestExpectation alloc] initWithDescription:@"异步测试"];
    
    ///异步请求
    LXHttpSessionTask* task = [[LXHttpSessionTask alloc] init];
    task.lx_sessionUrlParameters(@"www.baidu.com", @"POST", nil)
    .lx_resCallback(^(NSURLResponse* _Nonnull response, id _Nullable responseObject, NSError* _Nullable error) {
        [self.exp1 fulfill];
    });
    
    [self waitForExpectations:@[self.exp1] timeout:15];
}
- (void)testRequest1 {
    XCTWaiter * waiter = [[XCTWaiter alloc] initWithDelegate:self];
    self.exp1 = [[XCTestExpectation alloc] initWithDescription:@"测试异步1"];
    self.exp2 = [[XCTestExpectation alloc] initWithDescription:@"测试异步2"];
    
    NSLog(@"1111111111111111");
    dispatch_async(dispatch_queue_create("test01", NULL), ^{
        XCTWaiterResult waiterResult = [waiter waitForExpectations:@[self.exp1, self.exp2] timeout:15];
        XCTAssertEqual(waiterResult, XCTWaiterResultCompleted);
    });
    NSLog(@"2222222222222222");
    [self asynchronizeCompleted];
}
- (void)asynchronizeCompleted {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:10];
        [self.exp1 fulfill];
        [self.exp2 fulfill];
    });
}
#pragma mark --- XCTWaiterDelegate
- (void)waiter:(XCTWaiter *)waiter didTimeoutWithUnfulfilledExpectations:(NSArray<XCTestExpectation *> *)unfulfilledExpectations {
    NSLog(@"didTimeoutWithUnfulfilledExpectations:");
}
- (void)waiter:(XCTWaiter *)waiter fulfillmentDidViolateOrderingConstraintsForExpectation:(XCTestExpectation *)expectation requiredExpectation:(XCTestExpectation *)requiredExpectation {
    NSLog(@"fulfillmentDidViolateOrderingConstraintsForExpectation:");
}
- (void)waiter:(XCTWaiter *)waiter didFulfillInvertedExpectation:(XCTestExpectation *)expectation {
    NSLog(@"didFulfillInvertedExpectation:");
}
- (void)nestedWaiter:(XCTWaiter *)waiter wasInterruptedByTimedOutWaiter:(XCTWaiter *)outerWaiter {
    NSLog(@"wasInterruptedByTimedOutWaiter:");
}

@end
