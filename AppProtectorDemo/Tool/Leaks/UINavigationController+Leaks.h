//
//  UINavigationController+Leaks.h
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/25.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Leaks)

- (UIViewController *)apr_popViewControllerAnimated:(BOOL)animated;
- (NSArray<UIViewController *> *)apr_popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (NSArray<UIViewController *> *)apr_popToRootViewControllerAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
