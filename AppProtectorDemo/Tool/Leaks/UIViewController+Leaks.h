//
//  UIViewController+Leaks.h
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/24.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Leaks)

- (void)apr_viewDidDisappear:(BOOL)animated;
- (void)apr_viewWillAppear:(BOOL)animated;
- (void)apr_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
