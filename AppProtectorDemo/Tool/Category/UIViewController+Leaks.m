//
//  UIViewController+Leaks.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/24.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "UIViewController+Leaks.h"
#import <objc/runtime.h>

const void *const kVCHasBeenPopedKey = &kVCHasBeenPopedKey;

@implementation UIViewController (Leaks)


- (void)app_viewDidDisappear:(BOOL)animated {
    [self app_viewDidDisappear:animated];

//    if ([objc_getAssociatedObject(<#id  _Nonnull object#>, <#const void * _Nonnull key#>)]) {
//        <#statements#>
//    }
}

@end
