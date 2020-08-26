//
//  UINavigationController+Leaks.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/25.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "UINavigationController+Leaks.h"
#import <objc/runtime.h>
#import "NSObject+Leaks.h"

@implementation UINavigationController (Leaks)

- (void)dealloc {
    NSLog(@"UINavigationController dealloc");
}

- (UIViewController *)apr_popViewControllerAnimated:(BOOL)animated {
    UIViewController *poppedViewController = [self apr_popViewControllerAnimated:animated];

    if (!poppedViewController) {
        return nil;
    }

    // VC is not dealloced until disappear when popped using a left-edge swipe gesture
    extern const void *const kVCHasBeenPopedKey;
    objc_setAssociatedObject(poppedViewController, kVCHasBeenPopedKey, @(YES), OBJC_ASSOCIATION_RETAIN);

    return poppedViewController;
}

- (NSArray<UIViewController *> *)apr_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray<UIViewController *> *poppedViewControllers = [self apr_popToViewController:viewController animated:animated];

    for (UIViewController *viewController in poppedViewControllers) {
        [viewController willDealloc];
    }

    return poppedViewControllers;
}

- (NSArray<UIViewController *> *)apr_popToRootViewControllerAnimated:(BOOL)animated {
    NSArray<UIViewController *> *poppedViewControllers = [self apr_popToRootViewControllerAnimated:animated];

    for (UIViewController *viewController in poppedViewControllers) {
        [viewController willDealloc];
    }

    return poppedViewControllers;
}

- (BOOL)willDealloc {
    if (![super willDealloc]) {
        return NO;
    }

    [self willReleaseChildren:self.viewControllers];

    return YES;
}

@end
