//
//  AppProtector.h
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/7/30.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppCatchError.h"


NS_ASSUME_NONNULL_BEGIN

/**

整体思路
 1. 有 error， AppProtector 就 add 一下给 bubbleView，bubble view 上显示未读过的数字
 2. 点击以后，present 一个错误信息列表 vc，只显示错误类型，已读和未读，颜色做区分。
 3. 每个 vc 还能再点击进去，查看详情

 */


typedef NS_OPTIONS(NSInteger, AppProtection) {
    /*开启全部保护*/
    AppProtectionAll = 0,
    /*UnrecognizedSelector保护*/
    AppProtectionUnrecognizedSelector = 1<<0,
    /*KVO保护*/
    AppProtectionKVO = 1<<1,
    /*Timer保护*/
    AppProtectionTimer = 1<<2,
    /*Containers保护：包括NSArray、NSMutableArray、NSDictionary、NSMutableDictionary、NSString、NSMutableString*/
    AppProtectionTypeContainers = 1<<3,
    /*Retain Cycle detect*/
    AppProtectionTypeRetainCycle = 1<<4
};

/**
1. unrecognized selector
2. kvo
3. timer
4. container
5. vc 存在内存泄露

 */
@interface AppProtector : NSObject

+ (nonnull instancetype)shared;

- (void)openAppProtection:(AppProtection)protection
             errorHandler:(void(^)(AppCatchError * error))errorHandler;

- (void)closeAppProtection:(AppProtection)protection;

- (void)showErrorView;

- (void)hideErrorView;

#warning 以下接口要换一个地方放
- (void)addErrorWithType:(AppErrorType)errorType
               callStack:(NSArray *)callStack
                  detail:(NSString *)detail;

- (void)addErrorInfo:(AppCatchError *)errorInfo;

@end

NS_ASSUME_NONNULL_END
