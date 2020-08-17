//
//  AppCatchError.h
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/7.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AppErrorType) {
    /*UnrecognizedSelector异常*/
    AppErrorTypeUnrecognizedSelector = 1,
    /*KVO异常*/
    AppErrorTypeKVO,
    /*Timer异常*/
    AppErrorTypeTimer,
    /*Containers*/
    AppErrorTypeContainers
};

@interface AppCatchError : NSObject

@property (nonatomic, assign, readonly) AppErrorType errorType;

@property (nonatomic, copy, readonly) NSArray *errorCallStackSymbols;

@property (nonatomic, copy, readonly) NSString *errorName;


@property (nonatomic, copy, readonly) NSString *detail;

- (instancetype)initWithType:(AppErrorType)errorType
       errorCallStackSymbols:(NSArray *)errorCallStackSymbols
                      detail:(NSString *)detail;

@end

NS_ASSUME_NONNULL_END
