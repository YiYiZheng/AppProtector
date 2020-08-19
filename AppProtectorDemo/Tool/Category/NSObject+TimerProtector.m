//
//  NSObject+TimerProtector.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/19.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "NSObject+TimerProtector.h"
#import "AppCommonTool.h"
#import "AppProtector.h"
#import "AppTimerProxy.h"

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