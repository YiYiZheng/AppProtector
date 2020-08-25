//
//  UITabBarController+Leaks.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/25.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "UITabBarController+Leaks.h"
#import "NSObject+Leaks.h"

@implementation UITabBarController (Leaks)

- (BOOL)willDealloc {
    if (![super willDealloc]) {
        return NO;
    }

    [self willReleaseChildren:self.viewControllers];

    return YES;
}

@end
