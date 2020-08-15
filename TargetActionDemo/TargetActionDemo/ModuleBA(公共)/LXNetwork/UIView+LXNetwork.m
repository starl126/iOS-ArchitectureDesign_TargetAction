//
//  UIView+Network.m
//  ScrollViewRefresh
//
//  Created by 天边的星星 on 2019/8/3.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "UIView+LXNetwork.h"
#import "LXAgencyObserver.h"

#define LXScrollSelf UIScrollView* scrollSelf = (UIScrollView*)self
#define LXScrollWeakSelf __weak typeof(UIScrollView*) lx_scrollWeakSelf = (UIScrollView*)self
#define LXWeakSelf __weak typeof(self) lx_weakSelf = self

@interface LXTaskManagerModel : NSObject

@property (nonatomic, readonly) NSString* url;
@property (nonatomic,   assign) NSUInteger latestIdentifier;
@property (nonatomic, readonly) NSMutableArray<NSURLSessionDataTask*>* taskArrM;

- (instancetype)initWithUrl:(NSString*)url identifier:(NSUInteger)identifier taskArr:(NSArray*)taskArr;

@end

@implementation LXTaskManagerModel

- (instancetype)initWithUrl:(NSString*)url identifier:(NSUInteger)identifier taskArr:(NSArray*)taskArr {
    if (self = [super init]) {
        _url = url.copy;
        _latestIdentifier = identifier;
        _taskArrM = [NSMutableArray arrayWithArray:taskArr];
    }
    return self;
}

@end

@interface UIView ()

///当前页
@property (nonatomic, assign) NSInteger lx_current;
///总页数
@property (nonatomic, assign) NSInteger lx_total;
///前一次请求的页数
@property (nonatomic, assign) NSInteger lx_previous;

@property (nonatomic, weak) MJRefreshBackNormalFooter* lx_footer;
@property (nonatomic, weak) MJRefreshNormalHeader* lx_header;

///缓存请求任务task
@property (nonatomic, strong) NSMutableArray<LXTaskManagerModel*>* lx_taskArrM;
///解析数据类型缓存，用于多接口类型校正
@property (nonatomic, strong) NSMutableDictionary* lx_dataClassDictM;
///缓存分页数据，用于多接口分页校正
@property (nonatomic, strong) NSMutableDictionary* lx_isPageDictM;
///是否在请求网络中
@property (nonatomic, assign) BOOL lx_requesting;
@property (nonatomic, strong) LXAgencyObserver* lx_scrollPositionObv;

@end

@implementation UIView (LXNetwork)

#pragma mark --- 处理刷新
- (void)lx_actionForDealWithRefresh {
    if (![self isKindOfClass:UIScrollView.class]) {
        return;
    }
    LXWeakSelf;
    if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_refreshOption)]) {
        LXRefreshOption opt = [self.lx_delegate lx_refreshOption];
        LXScrollSelf;
        
        switch (opt) {
            case LXRefreshOptionHeader:
            {
                MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    [lx_weakSelf lx_actionForPullDownRefresh];
                }];
                scrollSelf.mj_header = header;
                scrollSelf.lx_header = header;
            }
                break;
            case LXRefreshOptionFooter:
            {
                MJRefreshBackNormalFooter* footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    [lx_weakSelf lx_actionForPullUpRefresh];
                }];
                [footer endRefreshingWithNoMoreData];
                scrollSelf.mj_footer = footer;
                scrollSelf.lx_footer = footer;
                [self lx_hideFooterView:YES];
            }
                break;
            case LXRefreshOptionHeaderFooter:
            {
                MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    [lx_weakSelf lx_actionForPullDownRefresh];
                }];
                scrollSelf.mj_header = header;
                scrollSelf.lx_header = header;
                MJRefreshBackNormalFooter* footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    [lx_weakSelf lx_actionForPullUpRefresh];
                }];
                [footer endRefreshingWithNoMoreData];
                scrollSelf.mj_footer = footer;
                scrollSelf.lx_footer = footer;
                [self lx_hideFooterView:YES];
            }
                break;
            default:
                break;
        }
    }
    if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_requestTwiceOneTime)] &&
        [self.lx_delegate lx_requestTwiceOneTime] &&
        self.lx_footer) {
        self.lx_scrollPositionObv = [LXAgencyObserver new];
        self.lx_scrollPositionObv.lx_consignorView = self;
        self.lx_scrollPositionObv.lx_needRequestBlock = ^{
            [lx_weakSelf lx_actionForPullUpRefresh];
        };
    }

}
///下拉刷新
- (void)lx_actionForPullDownRefresh {
    LXScrollSelf;
    if (scrollSelf.mj_footer.isRefreshing) {
        [scrollSelf.mj_footer endRefreshing];
        [scrollSelf.mj_footer resetNoMoreData];
    }
    scrollSelf.lx_current = 1;
    [scrollSelf lx_actionForStartRequestData];
}
///上拉加载更多
- (void)lx_actionForPullUpRefresh {
    LXScrollSelf;
    if (scrollSelf.mj_header.isRefreshing) {
        [scrollSelf.mj_footer endRefreshing];
        [scrollSelf.mj_footer resetNoMoreData];
        return;
    }
    if (scrollSelf.lx_current >= self.lx_total) {
        [scrollSelf.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    //NSLog(@"111111加页码前-%tu----%d",self.lx_current,self.lx_requesting);
    if (self.lx_requesting) {
        return;
    }
    scrollSelf.lx_current++;
    //NSLog(@"111111加页码后-%tu----%d",self.lx_current,self.lx_requesting);
    [scrollSelf lx_actionForStartRequestData];
}
- (void)lx_actionForStartRequestData {
    
    LXMethodOption method = [self lx_method];
    NSString* url = [self lx_checkedUrl];
    [self lx_cacheIsPageWithUrl:url];
    id parameter = [self lx_checkedParameter];
    self.lx_requesting = YES;
    self.lx_scrollPositionObv.lx_requesting = YES;
    
    /// 传递网络请求状态
    if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_requestInNetwork:)]) {
        [self.lx_delegate lx_requestInNetwork:YES];
    }
    
    //NSLog(@"111111更新刷新状态-%d-%d-%@",self.lx_requesting,self.lx_scrollPositionObv.lx_requesting,self.lx_scrollPositionObv);
    LXWeakSelf;
    switch (method) {
        case LXMethodOptionGet:
        {
            __block NSURLSessionDataTask* task = nil;
            
#pragma GCC warning "此处加入自己的网络请求工具类"
            /*
            task = [HttpService.sharedInstance get:url parameters:parameter completion:^(ResponseData *data) {
                if (data.code == ResponseCodeTypeSuccess) {
                    [lx_weakSelf lx_dealWithResponseDataTask:task responseObject:data.data];
                }else {
                    [lx_weakSelf lx_dealWithResponseTask:task errorCode:data.code msg:data.msg];
                }
            }];
             */
            
            [self lx_cacheTask:task url:url];
            [self lx_cacheDataClassWithUrl:url];
        }
            break;
        case LXMethodOptionPost:
        {
            __block NSURLSessionDataTask* task = nil;
#pragma GCC warning "此处加入自己的网络请求工具类"
            /*
            task = [HttpService.sharedInstance post:url parameters:parameter completion:^(ResponseData *data) {
                    if (data.code == ResponseCodeTypeSuccess) {
                        [lx_weakSelf lx_dealWithResponseDataTask:task responseObject:data.data];
                    }else {
                        [lx_weakSelf lx_dealWithResponseTask:task errorCode:data.code msg:data.msg];
                    }
                }];
             */
            [self lx_cacheTask:task url:url];
            [self lx_cacheDataClassWithUrl:url];
        }
            break;
        case LXMethodOptionPut:
        {
            __block NSURLSessionDataTask* task = nil;
#pragma GCC warning "此处加入自己的网络请求工具类"
            /*
            task = [HttpService.sharedInstance put:url parameters:parameter completion:^(ResponseData *data) {
                if (data.code == ResponseCodeTypeSuccess) {
                    [lx_weakSelf lx_dealWithResponseDataTask:task responseObject:data.data];
                }else {
                    [lx_weakSelf lx_dealWithResponseTask:task errorCode:data.code msg:data.msg];
                }
            }];
             */
            [self lx_cacheTask:task url:url];
            [self lx_cacheDataClassWithUrl:url];
        }
            break;
        case LXMethodOptionDelete:
        {
            __block NSURLSessionDataTask* task = nil;
#pragma GCC warning "此处加入自己的网络请求工具类"
            /*
            task = [HttpService.sharedInstance del:url parameters:parameter completion:^(ResponseData *data) {
                if (data.code == ResponseCodeTypeSuccess) {
                    [lx_weakSelf lx_dealWithResponseDataTask:task responseObject:data.data];
                }else {
                    [lx_weakSelf lx_dealWithResponseTask:task errorCode:data.code msg:data.msg];
                }
            }];
             */
            [self lx_cacheTask:task url:url];
            [self lx_cacheDataClassWithUrl:url];
        }
            break;
        default:
            break;
    }
}

#pragma mark --- private
///是否分页
- (BOOL)lx_isPageList {
    if (![self isKindOfClass:UIScrollView.class]) {
        return NO;
    }
    
    BOOL isPageList = NO;
    if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_isPageData)]) {
        isPageList = [self.lx_delegate lx_isPageData];
    }
    return isPageList;
}
///校正后的url请求地址
- (nullable NSString*)lx_checkedUrl {
    NSString* url = @"";
    if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_url)]) {
        NSString* oriStr = [self.lx_delegate lx_url];
        NSCharacterSet* set = NSCharacterSet.URLQueryAllowedCharacterSet;
        url = [oriStr stringByAddingPercentEncodingWithAllowedCharacters:set];
    }
    return url;
}
///参数校正
- (nullable id)lx_checkedParameter {
    id parameter = nil;
    if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_parameters)]) {
        parameter = [self.lx_delegate lx_parameters];
    }
    if ([self lx_isPageList]) {
        //请求分页数据
        if ([parameter isKindOfClass:NSDictionary.class]) {
            NSMutableDictionary* dictM = [NSMutableDictionary dictionaryWithDictionary:parameter];
            NSString* pageSizeName = @"pageSize";
            NSInteger pageSize = 10;
            NSString* currentName = @"current";
            if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_pageSizeName)]) {
                pageSizeName = [self.lx_delegate lx_pageSizeName];
            }
            if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_pageSize)]) {
                pageSize = [self.lx_delegate lx_pageSize];
            }
            if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_currentName)]) {
                currentName = [self.lx_delegate lx_currentName];
            }
            [dictM setObject:@(pageSize) forKey:pageSizeName];
            [dictM setObject:@(self.lx_current) forKey:currentName];
            //临时加入请求参数currentPage，兼容接口，后续2个版本后会删除，使用current
            [dictM setObject:@(self.lx_current) forKey:@"currentPage"];
            return dictM.copy;
        }
    }
    return parameter;
}
///设置请求头
- (void)lx_setRequestHeaderFiled {
    NSDictionary* dict = nil;
    if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_requestHeaderFiled)]) {
        dict = [self.lx_delegate lx_requestHeaderFiled];
    }
    if (dict && dict.count) {
        for (NSString* key in dict.allKeys) {
            id value = [dict objectForKey:key];
            [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }
}
///获取当前页key
- (NSString*)lx_currentPageName {
    NSString* name = @"current";
    if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_currentName)]) {
        name = [self.lx_delegate lx_currentName];
    }
    return name;
}
///获取总页数key
- (NSString*)lx_totalPagesName {
    NSString* name = @"pages";
    if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_pagesName)]) {
        name = [self.lx_delegate lx_pagesName];
    }
    return name;
}
///分页数据key
- (NSString*)lx_dataArrName {
    NSString* name = @"records";
    if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_onePageDataArrName)]) {
        name = [self.lx_delegate lx_onePageDataArrName];
    }
    return name;
}
///获取当前的请求method
- (LXMethodOption)lx_method {
    LXMethodOption method = LXMethodOptionPost;
    if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_methodOption)]) {
        method = [self.lx_delegate lx_methodOption];
    }
    return method;
}
///判断当前请求是否是有效的最新的请求
- (BOOL)lx_isLatestRequestWithUrl:(NSString*)url taskIdentifier:(NSUInteger)taskIdentifier {
    LXTaskManagerModel* model = nil;
    for (LXTaskManagerModel* one in self.lx_taskArrM) {
        if ([one.url isEqualToString:url]) {
            model = one;
            break;
        }
    }
    if (model && model.latestIdentifier != taskIdentifier) {//无效的
        return NO;
    }else {
        return YES;
    }
}
///缓存task处理
- (void)lx_cacheTask:(NSURLSessionDataTask*)task url:(NSString*)url  {
    LXTaskManagerModel* existModel = nil;
    
    for (LXTaskManagerModel* model in self.lx_taskArrM) {
        if ([model.url isEqualToString:url]) {
            model.latestIdentifier = task.taskIdentifier;
            [model.taskArrM enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj cancel];
            }];
            [model.taskArrM removeAllObjects];
            existModel = model;
            break;
        }
    }
    if (existModel) {
         //NSLog(@"count=%tu",existModel.taskArrM.count);
        [existModel.taskArrM addObject:task];
    }else {
        //NSLog(@"count=%tu",existModel.taskArrM.count);
        LXTaskManagerModel* taskModel = [[LXTaskManagerModel alloc] initWithUrl:url identifier:task.taskIdentifier taskArr:@[task]];
        [self.lx_taskArrM addObject:taskModel];
    }
}
///缓存数据类型
- (void)lx_cacheDataClassWithUrl:(NSString*)url {
    Class cls = nil;
    if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_dataClass)]) {
        cls = [self.lx_delegate lx_dataClass];
    }
    if (cls) {
        [self.lx_dataClassDictM setObject:cls forKey:url];
    }else {
        [self.lx_dataClassDictM removeObjectForKey:url];
    }
}
///缓存是否是分页
- (void)lx_cacheIsPageWithUrl:(NSString*)url {
    if (![self isKindOfClass:UIScrollView.class]) {
        [self.lx_isPageDictM setObject:@(NO) forKey:url];
        return;
    }
    BOOL isPage = NO;
    if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_isPageData)]) {
        isPage = [self.lx_delegate lx_isPageData];
    }
    [self.lx_isPageDictM setObject:@(isPage) forKey:url];
}
///是否隐藏footer view
- (void)lx_hideFooterView:(BOOL)hide {
    self.lx_footer.hidden = hide;
}
///请求成功网络数据处理
- (void)lx_dealWithResponseDataTask:(NSURLSessionDataTask*)task responseObject:(id)responseObject {
    NSString* url = task.response.URL.absoluteString;
    
    BOOL valid = [self lx_isLatestRequestWithUrl:url taskIdentifier:task.taskIdentifier];
    if (!valid) {
        if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_cancelTaskWithUrl:)]) {
            [self.lx_delegate lx_cancelTaskWithUrl:url];
        }
        NSLog(@"无效identifier=%tu",task.taskIdentifier);
        return;
    }
    self.lx_requesting = NO;
    self.lx_scrollPositionObv.lx_requesting = NO;
    
    /// 传递网络请求状态
    if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_requestInNetwork:)]) {
        [self.lx_delegate lx_requestInNetwork:NO];
    }
    
    //NSLog(@"请求完成--%d--%d--%@",self.lx_requesting,self.lx_scrollPositionObv.lx_requesting,self.lx_scrollPositionObv);
    if (responseObject) {
        //NSLog(@"3333333333333");
        BOOL isPageList = [[self.lx_isPageDictM objectForKey:url] boolValue];
        if (isPageList) {//分页数据处理
            NSDictionary* dictData = (NSDictionary*)responseObject;
            NSString* currentPageName = [dictData objectForKey:[self lx_currentPageName]];
            NSString* totalPagesName = [dictData objectForKey:[self lx_totalPagesName]];
            
            NSInteger current = 0;
            NSInteger pages = 0;
            if (currentPageName) {
                current = [currentPageName integerValue];
            }
            if (pages) {
                pages = [totalPagesName integerValue];
            }
            
            if (current != 0) {
                self.lx_current = current;
                self.lx_total = pages;
                self.lx_previous = self.lx_current;
            }
            //NSLog(@"返回请求赋值页数--%tu--%tu",self.lx_current,self.lx_total);
            
            [self lx_hideFooterView:NO];
            if (current >= pages) {
                [self.lx_footer endRefreshingWithNoMoreData];
                [self.lx_header endRefreshing];
                //再无更多数据后，禁止掉监听滚动自动刷新功能，避免接口过多请求
                self.lx_scrollPositionObv.lx_requesting = YES;
            }else {
                [self.lx_footer endRefreshing];
                [self.lx_footer resetNoMoreData];
                [self.lx_header endRefreshing];
            }
            
            NSArray* arr = [dictData objectForKey:[self lx_dataArrName]];

            //解析数据
            Class cls = [self.lx_dataClassDictM objectForKey:url];
            
            if (cls) {
                NSArray* models = [NSArray yy_modelArrayWithClass:cls json:arr];
                
                if (self.lx_current == 1) {
                    [self.lx_dataSourceArrM setArray:models];
                    
                    if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_successRequestTotalCounts:pages:)]) {
                        NSInteger total = [dictData[@"total"] integerValue];
                        NSInteger pages = [dictData[@"pages"] integerValue];
                        [self.lx_delegate lx_successRequestTotalCounts:total pages:pages];
                    }
                }else {
                    [self.lx_dataSourceArrM addObjectsFromArray:models];
                }
                if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_successRequestCurrentPageData:totalData:url:)]) {
                    //                    NSLog(@"有效identifer=%tu",task.taskIdentifier);
                    [self.lx_delegate lx_successRequestCurrentPageData:models totalData:self.lx_dataSourceArrM.copy url:url];
                }
            }else {
                if (self.lx_current == 1) {
                    [self.lx_dataSourceArrM setArray:arr];
                }else {
                    [self.lx_dataSourceArrM addObjectsFromArray:arr];
                }
                if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_successRequestCurrentPageData:totalData:url:)]) {
                    //                    NSLog(@"有效identifer=%tu",task.taskIdentifier);
                    [self.lx_delegate lx_successRequestCurrentPageData:arr totalData:self.lx_dataSourceArrM.copy url:url];
                }
            }
        }else {//非分页数据
            if (self.lx_header != nil) {
                [self.lx_header endRefreshing];
            }
            //NSLog(@"非分页数据------");
            //解析数据
            Class cls = [self.lx_dataClassDictM objectForKey:url];
            if (cls) {
                id model = nil;
                if ([responseObject isKindOfClass:NSArray.class]) {
                    model = [NSArray yy_modelArrayWithClass:cls json:responseObject];
                }else {
                    model = [cls yy_modelWithJSON:responseObject];
                }
                
                if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_successRequestData:url:)]) {
                    //NSLog(@"有效identifer=%tu",task.taskIdentifier);
                    [self.lx_delegate lx_successRequestData:model url:url];
                }
            }else {
                if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_successRequestData:url:)]) {
                    //NSLog(@"有效identifer=%tu",task.taskIdentifier);
                    [self.lx_delegate lx_successRequestData:responseObject url:url];
                }
            }
        }
    }else {//没有数据,当作非分页数据处理
        //NSLog(@"没有数据------");
        if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_successRequestData:url:)]) {
            [self.lx_delegate lx_successRequestData:nil url:url];
        }
    }
}
///网络请求不成功，包括应用层code非零以及网络断开、超时等错误
- (void)lx_dealWithResponseTask:(NSURLSessionDataTask*)task errorCode:(NSInteger)errorCode msg:(NSString*)msg {
    if (self.lx_header != nil) {
        [self.lx_header endRefreshing];
    }
    if (self.lx_footer != nil) {
        [self.lx_footer endRefreshing];
    }
    self.lx_current = self.lx_previous;
    
    NSString* url = task.originalRequest.URL.absoluteString;
    //判断是否是主动cancel的任务
    if (errorCode == -999) {
        //NSLog(@"取消task导致的无效identifier=%tu",task.taskIdentifier);
        if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_cancelTaskWithUrl:)]) {
            [self.lx_delegate lx_cancelTaskWithUrl:url];
        }
        return;
    }
    BOOL valid = [self lx_isLatestRequestWithUrl:task.response.URL.absoluteString taskIdentifier:task.taskIdentifier];
    if (!valid) {
        if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_cancelTaskWithUrl:)]) {
            [self.lx_delegate lx_cancelTaskWithUrl:url];
        }
        //NSLog(@"无效identifier=%tu",task.taskIdentifier);
        return;
    }
    
    if (self.lx_delegate && [self.lx_delegate respondsToSelector:@selector(lx_failRequestWithMessage:code:url:)]) {
        [self.lx_delegate lx_failRequestWithMessage:msg code:errorCode url:url];
    }
    //网络请求失败后，此时会禁止掉监听滚动自动刷新功能，避免接口过多请求，但保留手动上拉加载更多功能
    self.lx_scrollPositionObv.lx_requesting = YES;
}
///初始化数据
- (void)lx_initConfigure {
    self.lx_current = 1;
    self.lx_previous = 1;
    self.lx_taskArrM = [NSMutableArray array];
    self.lx_dataClassDictM = [NSMutableDictionary dictionary];
    self.lx_dataSourceArrM = [NSMutableArray array];
    self.lx_isPageDictM    = [NSMutableDictionary dictionary];
}

#pragma mark --- public
- (void)lx_requestData {
    if ([self lx_isPageList]) {
        self.lx_current = 1;
    }
    [self lx_actionForStartRequestData];
}
#pragma mark --- 属性设置
- (void)setLx_delegate:(id<LXNetworkConfigureProtocol>)lx_delegate {
    objc_setAssociatedObject(self, _cmd, lx_delegate, OBJC_ASSOCIATION_ASSIGN);
    if (lx_delegate) {
        //设置请求头
        [self lx_setRequestHeaderFiled];
        //设置数据刷新类型
        [self lx_actionForDealWithRefresh];
        //初始化数据
        [self lx_initConfigure];
    }
}
- (id<LXNetworkConfigureProtocol>)lx_delegate {
    return objc_getAssociatedObject(self, @selector(setLx_delegate:));
}
- (void)setLx_dataSourceArrM:(NSMutableArray * _Nonnull)lx_dataSourceArrM {
    objc_setAssociatedObject(self, _cmd, lx_dataSourceArrM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray *)lx_dataSourceArrM {
    return objc_getAssociatedObject(self, @selector(setLx_dataSourceArrM:));
}
- (void)setLx_current:(NSInteger)lx_current {
    objc_setAssociatedObject(self, _cmd, @(lx_current), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)lx_current {
    return [objc_getAssociatedObject(self, @selector(setLx_current:)) integerValue];
}
- (void)setLx_total:(NSInteger)lx_total {
    objc_setAssociatedObject(self, _cmd, @(lx_total), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)lx_total {
    return [objc_getAssociatedObject(self, @selector(setLx_total:)) integerValue];
}
- (void)setLx_previous:(NSInteger)lx_previous {
    objc_setAssociatedObject(self, _cmd, @(lx_previous), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)lx_previous {
    return [objc_getAssociatedObject(self, @selector(setLx_previous:)) integerValue];
}
- (void)setManager:(AFHTTPSessionManager *)manager {
    objc_setAssociatedObject(self, _cmd, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (AFHTTPSessionManager *)manager {
    return objc_getAssociatedObject(self, @selector(setManager:));
}
- (void)setTaskIdentifier:(NSInteger)taskIdentifier {
    objc_setAssociatedObject(self, _cmd, @(taskIdentifier), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)taskIdentifier {
    return [objc_getAssociatedObject(self, @selector(setTaskIdentifier:)) integerValue];
}
- (void)setLx_footer:(MJRefreshBackNormalFooter *)lx_footer {
    objc_setAssociatedObject(self, _cmd, lx_footer, OBJC_ASSOCIATION_ASSIGN);
}
- (MJRefreshBackNormalFooter *)lx_footer {
    return objc_getAssociatedObject(self, @selector(setLx_footer:));
}
- (void)setLx_header:(MJRefreshStateHeader *)lx_header {
    objc_setAssociatedObject(self, _cmd, lx_header, OBJC_ASSOCIATION_ASSIGN);
}
- (MJRefreshStateHeader *)lx_header {
    return objc_getAssociatedObject(self, @selector(setLx_header:));
}
- (void)setLx_taskArrM:(NSMutableArray<LXTaskManagerModel *> *)lx_taskArrM {
    objc_setAssociatedObject(self, _cmd, lx_taskArrM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray<LXTaskManagerModel *> *)lx_taskArrM {
    return objc_getAssociatedObject(self, @selector(setLx_taskArrM:));
}
- (void)setLx_dataClassDictM:(NSMutableDictionary *)lx_dataClassDictM {
    objc_setAssociatedObject(self, _cmd, lx_dataClassDictM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableDictionary *)lx_dataClassDictM {
    return objc_getAssociatedObject(self, @selector(setLx_dataClassDictM:));
}
- (void)setLx_isPageDictM:(NSMutableDictionary *)lx_isPageDictM {
    objc_setAssociatedObject(self, _cmd, lx_isPageDictM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableDictionary *)lx_isPageDictM {
    return objc_getAssociatedObject(self, @selector(setLx_isPageDictM:));
}
- (void)setLx_requesting:(BOOL)lx_requesting {
    objc_setAssociatedObject(self, _cmd, @(lx_requesting), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)lx_requesting {
    return [objc_getAssociatedObject(self, @selector(setLx_requesting:)) boolValue];
}
- (void)setLx_scrollPositionObv:(LXAgencyObserver *)lx_scrollPositionObv {
    objc_setAssociatedObject(self, _cmd, lx_scrollPositionObv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (LXAgencyObserver *)lx_scrollPositionObv {
    return objc_getAssociatedObject(self, @selector(setLx_scrollPositionObv:));
}

@end
