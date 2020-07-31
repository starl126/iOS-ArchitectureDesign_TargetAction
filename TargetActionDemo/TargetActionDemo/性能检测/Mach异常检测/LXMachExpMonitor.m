//
//  LXMachExpMonitor.m
//  TargetActionDemo
//
//  Created by 天边的星星 on 2020/7/27.
//  Copyright © 2020 starxin. All rights reserved.
//

#import "LXMachExpMonitor.h"

@implementation LXMachExpMonitor

+ (mach_port_t)createPortAndAddListener {
    mach_port_t server_port;
    //内核中创建一个消息队列，获取对应的port
    kern_return_t kr = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &server_port);
    assert(kr == KERN_SUCCESS);
    NSLog(@"create a mach port: %d successfully", server_port);
    
    //创建port的name
    mach_port_name_t port_name = 0;
    kr = mach_port_allocate_name(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, port_name);
    assert(kr == KERN_SUCCESS);
    NSLog(@"create a mach port name: %d successfully", port_name);
    
    //授予task对port的指定权限
    kr = mach_port_insert_right(mach_task_self(), port_name, server_port, MACH_MSG_TYPE_MOVE_RECEIVE);
    assert(kr == KERN_SUCCESS);
    NSLog(@"create a mach port name: %d successfully", port_name);
    
    [self setMachPortListener: server_port portName: port_name];

    return server_port;
}

+ (void)setMachPortListener:(mach_port_t)mach_port portName:(mach_port_name_t)port_name {
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_UTILITY, 0);
    dispatch_queue_t queue = dispatch_queue_create("ExceptionQueue", attr);
    dispatch_async(queue, ^{
        
        mach_msg_header_t mach_header;
        mach_header.msgh_size = 1024;
        mach_header.msgh_local_port = mach_port;
        
        mach_msg_return_t mr;
        while (true) {
            mr = mach_msg(&mach_header, MACH_RCV_MSG | MACH_RCV_LARGE, 0, mach_header.msgh_size, port_name, MACH_MSG_TIMEOUT_NONE, MACH_PORT_NULL);
            if (mr != MACH_MSG_SUCCESS && mr != MACH_RCV_TOO_LARGE) {
                NSLog(@"error!");
            }
            
            mach_msg_id_t msg_id = mach_header.msgh_id;
            mach_port_t remote_port = mach_header.msgh_remote_port;
            mach_port_t local_port = mach_header.msgh_local_port;
            
            
        }
    });
}
+ (void)sendMachPortMessage:(mach_port_t)mach_port {
    
  
}

@end
