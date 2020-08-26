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

// About Leaks
#import "UIViewController+Leaks.h"
#import "UINavigationController+Leaks.h"

// About view
#import "APRErrorListViewController.h"
#import "AppProtectorViewTool.h"

#pragma mark - AppProtector

@interface AppProtector ()

@property (nonatomic, assign) BOOL unrecognizedSelectorProtectOpen;
@property (nonatomic, assign) BOOL kvoProtectOpen;
@property (nonatomic, assign) BOOL timerProtectOpen;
@property (nonatomic, assign) BOOL containersProtectOpen;
@property (nonatomic, assign) BOOL retainCycleDetectOpen;

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

- (void)openAppProtection:(AppProtection)protection
             errorHandler:(APPErrorHandler)errorHandler {
    self.appErrorHandler = errorHandler;

    [self openOrCloseAppProtection:protection isOpen:YES];
}

- (void)closeAppProtection:(AppProtection)protection {
    [self openOrCloseAppProtection:protection isOpen:NO];
}

- (void)openOrCloseAppProtection:(AppProtection)protection isOpen:(BOOL)isOpen {
    if (protection == AppProtectionAll) {
        protection = AppProtectionUnrecognizedSelector | AppProtectionKVO | AppProtectionTimer | AppProtectionTypeContainers | AppProtectionTypeRetainCycle;
    }

    if (protection & AppProtectionUnrecognizedSelector) {
        if (self.unrecognizedSelectorProtectOpen != isOpen) {
            // 开启
            [self exchangeMethodForUnrecognizedSelector];
            self.unrecognizedSelectorProtectOpen = isOpen;
        }
    }

    if (protection & AppProtectionKVO) {
        if (self.kvoProtectOpen != isOpen) {
            [self exchangeMethodForKVO];
            self.kvoProtectOpen = isOpen;
        }
    }

    if (protection & AppProtectionTimer) {
        if (self.timerProtectOpen != isOpen) {
            [self exchangeMethodForTimer];
            self.timerProtectOpen = isOpen;
        }
    }

    if (protection & AppProtectionTypeContainers) {
        if (self.containersProtectOpen != isOpen) {
            [self exchangeMethodForContainers];
            self.containersProtectOpen = isOpen;
        }
    }

    if (protection & AppProtectionTypeRetainCycle) {
        if (self.retainCycleDetectOpen != isOpen) {
            [self exchangeMethodForRetainCycle];
            self.retainCycleDetectOpen = isOpen;
        }
    }
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

- (void)exchangeMethodForRetainCycle {
    Class vcClass = [UIViewController class];
    app_exchangeInstanceMethod(vcClass, @selector(viewDidDisappear:), vcClass, @selector(apr_viewDidDisappear:));
    app_exchangeInstanceMethod(vcClass, @selector(viewWillAppear:), vcClass, @selector(apr_viewWillAppear:));
    app_exchangeInstanceMethod(vcClass, @selector(dismissViewControllerAnimated:completion:), vcClass, @selector(apr_dismissViewControllerAnimated:completion:));


    Class navClass = [UINavigationController class];
    app_exchangeInstanceMethod(navClass, @selector(popViewControllerAnimated:), navClass, @selector(apr_popViewControllerAnimated:));
    app_exchangeInstanceMethod(navClass, @selector(popToViewController:animated:), navClass, @selector(apr_popToViewController:animated:));
    app_exchangeInstanceMethod(navClass, @selector(popToRootViewControllerAnimated:), navClass, @selector(apr_popToRootViewControllerAnimated:));
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
