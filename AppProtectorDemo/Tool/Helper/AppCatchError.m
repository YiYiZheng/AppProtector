//
//  AppCatchError.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/7.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "AppCatchError.h"

@interface AppCatchError ()

@property (nonatomic, assign) AppErrorType errorType;

@property (nonatomic, copy) NSArray *errorCallStackSymbols;

@property (nonatomic, copy) NSString *detail;

@end

@implementation AppCatchError

- (instancetype)initWithType:(AppErrorType)errorType
       errorCallStackSymbols:(NSArray *)errorCallStackSymbols
                      detail:(NSString *)detail {
    if (self = [super init]) {
        self.errorType = errorType;
        self.errorCallStackSymbols = errorCallStackSymbols;
        self.detail = detail;
    }
    return self;
}

- (NSString *)errorName {
    NSString *name = @"捕获到的错误";
    switch (self.errorType) {
        case AppErrorTypeUnrecognizedSelector:
            name = @"Unrecognized Selector 错误";
            break;
        case AppErrorTypeKVO:
            name = @"KVO 错误";
            break;
        case AppErrorTypeTimer:
            name = @"Timer 错误 未被释放";
            break;
        case AppErrorTypeContainers:
            name = @"Containers 错误";
            break;
    }

    return name;
}

- (NSString *)fullDescription {
    NSString *str = [NSString stringWithFormat:@"%@ \n详情 %@ \n\nCall stack %@", self.errorName, self.detail, self.errorCallStackSymbols];
    return str;
}

@end
