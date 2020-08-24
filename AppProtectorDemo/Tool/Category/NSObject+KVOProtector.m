//
//  NSObject+KVOProtector.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/19.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "NSObject+KVOProtector.h"
#import "AppKVOPorxy.h"
#import "AppCommonTool.h"
#import "AppProtector.h"

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
                // 不应报错，因为不需要修复
//                NSString *errorInfo = [NSString stringWithFormat:@"被观察者-%@ dealloc 时其 KVO 未被移除", NSStringFromClass([self class])];
//                [AppProtector.shared addErrorWithType:AppErrorTypeKVO callStack:[NSThread callStackSymbols] detail:errorInfo];

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
