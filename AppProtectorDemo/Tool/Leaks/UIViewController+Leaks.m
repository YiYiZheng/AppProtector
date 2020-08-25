//
//  UIViewController+Leaks.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/24.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "UIViewController+Leaks.h"
#import <objc/runtime.h>
#import "NSObject+Leaks.h"

const void *const kVCHasBeenPopedKey = &kVCHasBeenPopedKey;

@implementation UIViewController (Leaks)


- (void)apr_viewDidDisappear:(BOOL)animated {
    [self apr_viewDidDisappear:animated];

    if ([objc_getAssociatedObject(self, kVCHasBeenPopedKey) boolValue]) {
        [self willDealloc];
    }
}

- (void)apr_viewWillAppear:(BOOL)animated {
    [self apr_viewWillAppear:animated];

    objc_setAssociatedObject(self, kVCHasBeenPopedKey, @(NO), OBJC_ASSOCIATION_RETAIN);
}

- (void)apr_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [self apr_dismissViewControllerAnimated:flag completion:completion];

    UIViewController *dismissedViewController = self.presentedViewController;
#warning Why?
    if (!dismissedViewController && self.presentingViewController) {
        // self is the presenting VC
        dismissedViewController = self;
    }

    if (dismissedViewController) {
        [dismissedViewController willDealloc];
    }

}

- (BOOL)willDealloc {
    if (![super willDealloc]) {
        return NO;
    }

    [self willReleaseChildren:self.childViewControllers];
    [self willReleaseChild:self.presentingViewController];

    if (self.isViewLoaded) {
        [self willReleaseChild:self.view];
    }

    return YES;
}

@end
