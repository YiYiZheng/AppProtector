//
//  AppTimerProxy.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/12.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "AppTimerProxy.h"
#import "AppCatchError.h"
#import "AppCommonTool.h"

// 不是成员变量的原因 不需要有很多份
APPErrorHandler _Nullable _timerErrorHandler;

@implementation AppTimerProxy {
    @package
    NSTimeInterval _ti;
    __weak id _aTarget;
    SEL _aSelector;
    __weak id _userInfo;
    BOOL _yesOrNo;
    // 记录实际创建 timer 的类
    NSString *_targetClassName;
}

+ (instancetype)scheduleWithTimeInterval:(NSTimeInterval)ti
                                  target:(id)aTarget
                                selector:(SEL)aSelector
                                userInfo:(id)userInfo
                                 repeats:(BOOL)yesOrNo
                            errorHandler:(void(^)(AppCatchError * error))errorHandler {
    return [[self alloc] initWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo errorHandler:errorHandler];
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)ti
                              target:(id)aTarget
                            selector:(SEL)aSelector
                            userInfo:(id)userInfo
                             repeats:(BOOL)yesOrNo
                        errorHandler:(void(^)(AppCatchError * error))errorHandler {
    if (self = [super init]) {
        _ti = ti;
        _aTarget = aTarget;
        _aSelector = aSelector;
        _userInfo = userInfo;
        _yesOrNo = yesOrNo;
        _targetClassName = NSStringFromClass([aTarget class]);
        _timerErrorHandler = errorHandler;
    }
    return self;
}

- (void)triggerTimer:(NSTimer *)timer {
    if (_aTarget) {
        // 说明应该继续触发
        if ([_aTarget respondsToSelector:_aSelector]) {
            BMP_SuppressPerformSelectorLeakWarning(
                                                   [_aTarget performSelector:_aSelector];
                                                   );

        }
    } else {
        // 不应该触发了，要销毁
        // 应该把对应 target 信息打印出来
        NSString *detail = [NSString stringWithFormat:@"发生类 %@", _targetClassName];
        AppCatchError *error = [[AppCatchError alloc] initWithType:AppErrorTypeTimer errorCallStackSymbols:[NSThread callStackSymbols]  detail:detail];
        _timerErrorHandler(error);

//        NSLog(@"targetClass %@ ", _targetClassName);

        [timer invalidate];
        timer = nil;
    }
}

@end
