//
//  AppProtector.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/7/30.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "AppProtector.h"
#import <objc/runtime.h>
#import "AppCatchError.h"
#import "AppKVOPorxy.h"
#import "AppCommonTool.h"
#import "AppTimerProxy.h"
#import "AppContainerProtector.h"
#import "AppProtectorErrorView.h"

@interface AppProtector ()

- (void)addErrorWithType:(AppErrorType)errorType
               callStack:(NSArray *)callStack
                  detail:(NSString *)detail;

- (void)addErrorInfo:(AppCatchError *)errorInfo;

@end

#pragma mark - NSObject + unrecognizedSelector

@interface NSObject (UnrecognizedSelector)

@end

@implementation NSObject (UnrecognizedSelector)

- (id)app_swizzle_forwardingTargetForSelector:(SEL)selector {
    if ([self isOverrideForwardingMethods]) {
        return [self app_swizzle_forwardingTargetForSelector:selector];
    } else {
        // 补救
        class_addMethod([AppProtector class], selector, (IMP)DynamicAddMethodIMP, "v@:");

        [AppProtector.shared addErrorWithType:AppErrorTypeUnrecognizedSelector
                                    callStack:[NSThread callStackSymbols]
                                       detail:@""];


        return AppProtector.shared;
    }
}

- (BOOL)isOverrideForwardingMethods {
    BOOL overide = NO;
    // 确保转发相关的方法都没有被重写过 forwardInvocation 和 forwardingTargetForSelector
    overide = (class_getMethodImplementation([NSObject class], @selector(forwardInvocation:)) != class_getMethodImplementation([self class], @selector(forwardInvocation:))) ||
    (class_getMethodImplementation([NSObject class], @selector(forwardingTargetForSelector:)) != class_getMethodImplementation([self class], @selector(forwardingTargetForSelector:)));
    return overide;
}

@end

#pragma mark - NSObject + kvo

@interface NSObject (KVOProtector)

@end

@implementation NSObject (KVOProtector)

/// 下面两个事用于说明当前对象曾经有过 kvo 观察
static void *AppProtectorKey = &AppProtectorKey;
static NSString *const AppProtectorValue = @"App_KVOProtector";

static void *appKVOProxyKey = &appKVOProxyKey;

- (void)setAppKVOProxy:(AppKVOPorxy *)appKVOProxy {
    objc_setAssociatedObject(self, appKVOProxyKey, appKVOProxy, OBJC_ASSOCIATION_RETAIN);
}

- (AppKVOPorxy *)appKVOProxy {
    id appKVOProxy = objc_getAssociatedObject(self, appKVOProxyKey);

    if (appKVOProxy == nil) {
        appKVOProxy = [[AppKVOPorxy alloc] init];
        self.appKVOProxy = appKVOProxy;
    }

    return appKVOProxy;
}

- (void)app_addObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                context:(void *)context {
    if (isSystemClass(self.class)) {
        [self app_addObserver:observer forKeyPath:keyPath options:options context:context];
    } else {
        // 只要曾经有过观察，就记录上，在 dealloc 时用
        objc_setAssociatedObject(self, AppProtectorKey, AppProtectorValue, OBJC_ASSOCIATION_RETAIN);
        BOOL success = [self.appKVOProxy addKVOInfoWithObserver:observer keyPath:keyPath options:options context:context];

        if (success) {
            [self app_addObserver:self.appKVOProxy forKeyPath:keyPath options:options context:context];
        } else {
            NSString *errorInfo = [NSString stringWithFormat:@"重复添加KVO 被观察者-%@ observer-%@ keyPath-%@", NSStringFromClass([self class]), NSStringFromClass([observer class]), keyPath];
            [AppProtector.shared addErrorWithType:AppErrorTypeKVO callStack:[NSThread callStackSymbols] detail:errorInfo];
        }
    }
}

- (void)app_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    if (isSystemClass(self.class)) {
        [self app_removeObserver:observer forKeyPath:keyPath];
    } else {

        if ([self.appKVOProxy removeKVOInfoWithObserver:observer keyPath:keyPath]) {
            [self app_removeObserver:observer forKeyPath:keyPath];
        } else {
            NSString *errorInfo = [NSString stringWithFormat:@"该 KVO 信息已不存在，请勿重复移除 被观察者-%@ observer-%@ keyPath-%@", NSStringFromClass([self class]), NSStringFromClass([observer class]), keyPath];
            [AppProtector.shared addErrorWithType:AppErrorTypeKVO callStack:[NSThread callStackSymbols] detail:errorInfo];
        }
    }
}

- (void)app_removeObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath
                   context:(nullable void *)context {
    if (isSystemClass(self.class)) {
        [self app_removeObserver:observer forKeyPath:keyPath context:context];
    } else {
        if ([self.appKVOProxy removeKVOInfoWithObserver:observer keyPath:keyPath]) {
            [self app_removeObserver:observer forKeyPath:keyPath context:context];
        } else {
            NSString *errorInfo = [NSString stringWithFormat:@"该 KVO 信息已不存在，请勿重复移除 被观察者-%@ observer-%@ keyPath-%@", NSStringFromClass([self class]), NSStringFromClass([observer class]), keyPath];
            [AppProtector.shared addErrorWithType:AppErrorTypeKVO callStack:[NSThread callStackSymbols] detail:errorInfo];
        }
    }
}

- (void)app_dealloc {
    if (!isSystemClass(self.class)) {
        NSString *value = (NSString *)objc_getAssociatedObject(self, AppProtectorKey);
        // 说明当前类，曾添加过 KVO
        if ([value isEqualToString:AppProtectorValue]) {
            NSArray *keyPaths = [self.appKVOProxy getAllKeyPaths];

            if (keyPaths.count > 0) {
                // 报错
                NSString *errorInfo = [NSString stringWithFormat:@"被观察者-%@ dealloc 时其 KVO 未被移除", NSStringFromClass([self class])];
                [AppProtector.shared addErrorWithType:AppErrorTypeKVO callStack:[NSThread callStackSymbols] detail:errorInfo];

                // 纠正，取消观察
                [keyPaths enumerateObjectsUsingBlock:^(NSString *keyPath, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self app_removeObserver:self.appKVOProxy forKeyPath:keyPath];
                }];
            }
        }
    }

    [self app_dealloc];
}

@end

#pragma mark - NSObject + Timer

@interface NSObject (TimerProtector)

@end

@implementation NSObject (TimerProtector)

+ (NSTimer *)app_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    if (yesOrNo && !isSystemClass([aTarget class])) {
        AppTimerProxy *proxy = [AppTimerProxy scheduleWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo errorHandler:^(AppCatchError * _Nonnull error) {
            [AppProtector.shared addErrorInfo:error];
        }];

        return [self app_scheduledTimerWithTimeInterval:ti target:proxy selector:NSSelectorFromString(@"triggerTimer:") userInfo:userInfo repeats:yesOrNo];
    } else {
        return [self app_scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    }
}

+ (NSTimer *)app_timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    if (yesOrNo && !isSystemClass([aTarget class])) {
        AppTimerProxy *proxy = [AppTimerProxy scheduleWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo errorHandler:^(AppCatchError * _Nonnull error) {
            [AppProtector.shared addErrorInfo:error];
        }];

        return [self app_timerWithTimeInterval:ti target:proxy selector:NSSelectorFromString(@"triggerTimer:") userInfo:userInfo repeats:yesOrNo];
    } else {
        return [self app_timerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    }
}


@end

#pragma mark - AppProtector

@interface AppProtector ()

@property (nonatomic, assign) BOOL unrecognizedSelectorProtectOpen;
@property (nonatomic, assign) BOOL kvoProtectOpen;
@property (nonatomic, assign) BOOL timerProtectOpen;
@property (nonatomic, assign) BOOL containersProtectOpen;

@property (nonatomic, strong) NSMutableArray <AppCatchError *> *errorInfos;
@property (nonatomic, strong) AppProtectorErrorBubbleView *bubbleView;

@property (nonatomic, copy) APPErrorHandler appErrorHandler;

@end

@implementation AppProtector

+ (nonnull instancetype)shared {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

//- (instancetype)init {
//    if (self = [super init]) {
//    }
//    return self;
//}

- (void)openAppProtection:(AppProtection)protection
             errorHandler:(APPErrorHandler)errorHandler {
    self.appErrorHandler = errorHandler;
#warning 如果已经有方法交换了，需要避免重复交换，可以算一个难点吧，因为有其他库
    if (protection == AppProtectionAll) {
//        NSLog(@"AppProtectionAll");
        protection = AppProtectionUnrecognizedSelector | AppProtectionKVO | AppProtectionTimer | AppProtectionTypeContainers;
    }

    if (protection & AppProtectionUnrecognizedSelector) {
//        NSLog(@"AppProtectionUnrecognizedSelector");
        // 避免重复开启
        if (!self.unrecognizedSelectorProtectOpen) {
            // 开启
            [self exchangeMethodForUnrecognizedSelector];
            self.unrecognizedSelectorProtectOpen = YES;
        }
    }

    if (protection & AppProtectionKVO) {
//        NSLog(@"AppProtectionKVO");
        if (!self.kvoProtectOpen) {
            [self exchangeMethodForKVO];
            self.kvoProtectOpen = YES;
        }
    }

    if (protection & AppProtectionTimer) {
//        NSLog(@"AppProtectionTimer");
        if (!self.timerProtectOpen) {
            [self exchangeMethodForTimer];
            self.timerProtectOpen = YES;
        }
    }

    if (protection & AppProtectionTypeContainers) {
        if (!self.containersProtectOpen) {
            [self exchangeMethodForContainers];
            self.containersProtectOpen = YES;
        }
    }
}

- (void)closeAppProtection:(AppProtection)protection {

}

- (void)addErrorWithType:(AppErrorType)errorType
               callStack:(NSArray *)callStack
                  detail:(NSString *)detail {
    AppCatchError *error = [[AppCatchError alloc] initWithType:errorType errorCallStackSymbols:callStack detail:detail];
    self.appErrorHandler(error);
    [self addErrorInfo:error];
}

- (void)addErrorInfo:(AppCatchError *)errorInfo {
    [self.errorInfos addObject:errorInfo];

    [self updateBubbleUnreadCount];
}

- (void)updateBubbleUnreadCount {
    [self.bubbleView updateUnreadCount:[self getUnreadCount]];
}

- (NSInteger)getUnreadCount {
    __block NSInteger unreadCount = 0;
    [self.errorInfos enumerateObjectsUsingBlock:^(AppCatchError * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!info.isRead) {
            unreadCount++;
        }
    }];

    return unreadCount;
}


#pragma mark - UI

- (void)showErrorView {
    self.bubbleView.hidden = NO;
}

- (void)hideErrorView {
    self.bubbleView.hidden = YES;
}

- (void)showErrorListView {
    // 需要把数据传过去
}



#pragma mark - 各种不同类型的开启

- (void)exchangeMethodForUnrecognizedSelector {
    app_exchangeInstanceMethod([NSObject class], @selector(forwardingTargetForSelector:), [NSObject class], @selector(app_swizzle_forwardingTargetForSelector:));
}

- (void)exchangeMethodForKVO {
    Class cls = [NSObject class];
    app_exchangeInstanceMethod(cls, @selector(addObserver:forKeyPath:options:context:),
                               cls, @selector(app_addObserver:forKeyPath:options:context:));

    app_exchangeInstanceMethod(cls, @selector(removeObserver:forKeyPath:),
    cls, @selector(app_removeObserver:forKeyPath:));
    app_exchangeInstanceMethod(cls, @selector(removeObserver:forKeyPath:context:),
    cls, @selector(app_removeObserver:forKeyPath:context:));
    // ARC forbids use of 'dealloc' in a @selector
    app_exchangeInstanceMethod(cls, NSSelectorFromString(@"dealloc"),
    cls, @selector(app_dealloc));
}

- (void)exchangeMethodForTimer {
    // timer
    Class cls = [NSTimer class];
    // 注意 这里交换的是类方法
    app_exchangeClassMethod(cls, @selector(timerWithTimeInterval:target:selector:userInfo:repeats:),
                            @selector(app_timerWithTimeInterval:target:selector:userInfo:repeats:));

    app_exchangeClassMethod(cls, @selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:),
                            @selector(app_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:));
}

- (void)exchangeMethodForContainers {
    [AppContainerProtector exchangeAllMethodsWithHandler:self.appErrorHandler];
}


#pragma mark - Lazy load

- (NSMutableArray<AppCatchError *> *)errorInfos {
    if (!_errorInfos) {
        _errorInfos = [NSMutableArray array];
    }

    return _errorInfos;
}

- (AppProtectorErrorBubbleView *)bubbleView {
    if (!_bubbleView) {
        _bubbleView = [AppProtectorErrorBubbleView create];
        __weak typeof(self) weakSelf = self;
        _bubbleView.clickBlock = ^{
            // 都是单例 循环引用无所谓
            [weakSelf showErrorListView];
        };
    }

    return _bubbleView;
}


@end
