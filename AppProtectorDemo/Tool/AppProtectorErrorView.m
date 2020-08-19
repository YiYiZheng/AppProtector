//
//  AppProtectorErrorView.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/17.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "AppProtectorErrorView.h"

#define AppScreenWidth  [UIScreen mainScreen].bounds.size.width
#define AppScreenHeight  [UIScreen mainScreen].bounds.size.height
#define AppKeyWindow [UIApplication sharedApplication].windows[0]


@implementation AppProtectorErrorBubbleView

+ (nonnull instancetype)create {
    AppProtectorErrorBubbleView *errorView = [super buttonWithType:UIButtonTypeCustom];
    [errorView initUI];

    return errorView;
}

- (void)initUI {
    [self setTitle:@"protector" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.frame = CGRectMake(20, 20, 50, 25);
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    self.backgroundColor = [UIColor yellowColor];
    [self addTarget:self action:@selector(onBtn) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:recognizer];

#warning 临时处理，延迟加到 window 上
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [AppKeyWindow addSubview:self];
    });
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
#warning 拖拽实现原理细究
    CGPoint point = [sender translationInView:[sender.view superview]];

    CGFloat senderHalfViewWidth = sender.view.frame.size.width / 2;
    CGFloat senderHalfViewHeight = sender.view.frame.size.height / 2;

    __block CGPoint viewCenter = CGPointMake(sender.view.center.x + point.x, sender.view.center.y + point.y);
    // 拖拽状态结束
    if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.4 animations:^{
            if ((sender.view.center.x + point.x - senderHalfViewWidth) <= 12) {
                viewCenter.x = senderHalfViewWidth + 12;
            }
            if ((sender.view.center.x + point.x + senderHalfViewWidth) >= (AppScreenWidth - 12)) {
                viewCenter.x = AppScreenWidth - senderHalfViewWidth - 12;
            }
            if ((sender.view.center.y + point.y - senderHalfViewHeight) <= 12) {
                viewCenter.y = senderHalfViewHeight + 12;
            }
            if ((sender.view.center.y + point.y + senderHalfViewHeight) >= (AppScreenHeight - 12)) {
                viewCenter.y = AppScreenHeight - senderHalfViewHeight - 12;
            }
            sender.view.center = viewCenter;
        } completion:^(BOOL finished) {

        }];
        [sender setTranslation:CGPointMake(0, 0) inView:[sender.view superview]];
    } else {
        // UIGestureRecognizerStateBegan || UIGestureRecognizerStateChanged
        viewCenter.x = sender.view.center.x + point.x;
        viewCenter.y = sender.view.center.y + point.y;
        sender.view.center = viewCenter;
        [sender setTranslation:CGPointMake(0, 0) inView:[sender.view superview]];
    }

}

- (void)onBtn {
    if (_clickBlock) {
        _clickBlock();
    }
}


- (void)updateUnreadCount:(NSInteger)count {
    NSString *changedTitle = count <= 0 ? @"protector" : [NSString stringWithFormat:@"+%@", @(count)];
    [self setTitle:changedTitle forState:UIControlStateNormal];
}

@end



