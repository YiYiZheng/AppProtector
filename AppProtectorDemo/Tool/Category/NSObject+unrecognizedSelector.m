//
//  NSObject+unrecognizedSelector.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/19.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "NSObject+unrecognizedSelector.h"
#import "AppCommonTool.h"
#import "AppProtector.h"

@implementation NSObject (unrecognizedSelector)

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
