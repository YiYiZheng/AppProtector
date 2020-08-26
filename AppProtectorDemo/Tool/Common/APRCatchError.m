//
//  APRCatchError.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/7.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "APRCatchError.h"

@interface APRCatchError ()

@property (nonatomic, assign) AppErrorType errorType;

@property (nonatomic, copy) NSArray *errorCallStackSymbols;

@property (nonatomic, copy) NSString *detail;

@end

@implementation APRCatchError

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
    NSString *name = @"Unknow Error";
    switch (self.errorType) {
        case AppErrorTypeUnrecognizedSelector:
            name = @"Unrecognized Selector Error";
            break;
        case AppErrorTypeKVO:
            name = @"KVO Error";
            break;
        case AppErrorTypeTimer:
            name = @"Timer Error: Target not released";
            break;
        case AppErrorTypeContainers:
            name = @"Containers Error";
            break;
        case AppErrorTypeRetainCycle:
            name = @"Retain Cycle Error";
            break;
    }

    return name;
}

- (NSString *)fullDescription {
    NSString *str = [NSString stringWithFormat:@"Type: %@ \nDetail %@ \nCall stack %@", self.errorName, self.detail, self.errorCallStackSymbols];
    return str;
}

@end
