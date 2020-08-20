//
//  AppProtectorErrorView.h
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/17.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppProtector.h"

NS_ASSUME_NONNULL_BEGIN

@class AppCatchError;

//@interface AppProtector (view)

//+ (void)showErrorView;

//+ (void)addErrorInfo:(AppCatchError *)errorInfo;


//@end

@interface AppProtectorErrorBubbleView : UIButton

+ (nonnull instancetype)create;

//- (void)addErrorInfo:(AppCatchError *)errorInfo;

@property (nonatomic, copy) void (^clickBlock)(void);

- (void)updateUnreadCount:(NSInteger)count;

@end


NS_ASSUME_NONNULL_END
