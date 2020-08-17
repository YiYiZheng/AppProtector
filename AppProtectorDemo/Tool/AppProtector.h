//
//  AppProtector.h
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/7/30.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@class AppCatchError;

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
    AppProtectionTypeContainers = 1<<3
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

@end

NS_ASSUME_NONNULL_END
