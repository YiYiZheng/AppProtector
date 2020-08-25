//
//  UIView+Leaks.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/25.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "UIView+Leaks.h"
#import "NSObject+Leaks.h"

@implementation UIView (Leaks)

- (BOOL)willDealloc {
    if (![super willDealloc]) {
        return NO;
    }

    [self willReleaseChildren:self.subviews];

    return YES;
}

@end
