//
//  NSObject+TimerProtector.h
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/19.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (TimerProtector)

+ (NSTimer *)app_scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                         target:(id)aTarget
                                       selector:(SEL)aSelector
                                       userInfo:(id)userInfo
                                        repeats:(BOOL)yesOrNo;

+ (NSTimer *)app_timerWithTimeInterval:(NSTimeInterval)ti
                                target:(id)aTarget
                              selector:(SEL)aSelector
                              userInfo:(id)userInfo
                               repeats:(BOOL)yesOrNo;

@end

NS_ASSUME_NONNULL_END
