//
//  NSObject+TimerProtector.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/19.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "NSObject+TimerProtector.h"
#import "APRCommonTool.h"
#import "AppProtector.h"
#import "APRTimerProxy.h"
#import "AppProtector+internal.h"

@implementation NSObject (TimerProtector)

+ (NSTimer *)apr_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    if (yesOrNo && !isSystemClass([aTarget class])) {
        APRTimerProxy *proxy = [APRTimerProxy scheduleWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo errorHandler:^(APRCatchError * _Nonnull error) {
            [AppProtector.shared addErrorInfo:error];
        }];

        return [self apr_scheduledTimerWithTimeInterval:ti target:proxy selector:NSSelectorFromString(@"triggerTimer:") userInfo:userInfo repeats:yesOrNo];
    } else {
        return [self apr_scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    }
}

+ (NSTimer *)apr_timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    if (yesOrNo && !isSystemClass([aTarget class])) {
        APRTimerProxy *proxy = [APRTimerProxy scheduleWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo errorHandler:^(APRCatchError * _Nonnull error) {
            [AppProtector.shared addErrorInfo:error];
        }];

        return [self apr_timerWithTimeInterval:ti target:proxy selector:NSSelectorFromString(@"triggerTimer:") userInfo:userInfo repeats:yesOrNo];
    } else {
        return [self apr_timerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    }
}


@end
