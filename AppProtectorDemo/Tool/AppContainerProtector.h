//
//  AppContainerProtector.h
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/13.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AppCatchError;

@interface AppContainerProtector : NSObject

+ (void)exchangeAllMethodsWithHandler:(void (^)(AppCatchError *error))handler;

@end

NS_ASSUME_NONNULL_END
