//
//  AppTimerProxy.h
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/12.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AppCatchError;

@interface AppTimerProxy : NSObject

+ (instancetype)scheduleWithTimeInterval:(NSTimeInterval)ti
                                  target:(id)aTarget
                                selector:(SEL)aSelector
                                userInfo:(id)userInfo
                                 repeats:(BOOL)yesOrNo
                            errorHandler:(void(^)(AppCatchError * error))errorHandler;

@end

NS_ASSUME_NONNULL_END
