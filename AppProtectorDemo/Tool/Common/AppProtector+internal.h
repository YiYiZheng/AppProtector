//
//  AppProtector+internal.h
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/26.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APRCatchError.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppProtector ()

- (void)addErrorWithType:(AppErrorType)errorType
               callStack:(NSArray *)callStack
                  detail:(NSString *)detail;

- (void)addErrorInfo:(APRCatchError *)errorInfo;

@end



NS_ASSUME_NONNULL_END
