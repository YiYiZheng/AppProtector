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
#import "AppCommonTool.h"
#import "AppContainerProtector.h"
#import "APRErrorBubbleView.h"

#import "NSObject+unrecognizedSelector.h"
#import "NSObject+KVOProtector.h"
#import "NSObject+TimerProtector.h"

// 下面两个要搞走
#import "APRErrorListViewController.h"
#import "AppProtectorViewTool.h"

#pragma mark - AppProtector

@interface AppProtector ()

@property (nonatomic, assign) BOOL unrecognizedSelectorProtectOpen;
@property (nonatomic, assign) BOOL kvoProtectOpen;
@property (nonatomic, assign) BOOL timerProtectOpen;
@property (nonatomic, assign) BOOL containersProtectOpen;

@property (nonatomic, strong) NSMutableArray <AppCatchError *> *errorInfos;
@property (nonatomic, strong) APRErrorBubbleView *bubbleView;

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
#warning How to check whether is already exchange?
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

- (void)handleListViewQuit {
    [self updateBubbleUnreadCount];
}


#pragma mark - UI

- (void)showErrorView {
    self.bubbleView.hidden = NO;
}

- (void)hideErrorView {
    self.bubbleView.hidden = YES;
}

- (void)showErrorListView {
    __weak typeof(self) weakSelf = self;
    APRErrorListViewController *vc = [[APRErrorListViewController alloc] initWithErrorList:self.errorInfos quitBlock:^{
        [weakSelf handleListViewQuit];
    }];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
    navc.modalPresentationStyle = UIModalPresentationFullScreen;
    [AppCurViewController presentViewController:navc animated:YES completion:nil];
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
    [AppContainerProtector exchangeAllMethods];
}

#pragma mark - Lazy load

- (NSMutableArray<AppCatchError *> *)errorInfos {
    if (!_errorInfos) {
        _errorInfos = [NSMutableArray array];
    }

    return _errorInfos;
}

- (APRErrorBubbleView *)bubbleView {
    if (!_bubbleView) {
        _bubbleView = [APRErrorBubbleView create];
        __weak typeof(self) weakSelf = self;
        _bubbleView.clickBlock = ^{
            [weakSelf showErrorListView];
        };
    }

    return _bubbleView;
}


@end
