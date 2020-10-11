//
//  AppProtectorErrorView.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/17.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "APRErrorBubbleView.h"
#import "AppProtectorViewTool.h"

@implementation APRErrorBubbleView

+ (nonnull instancetype)create {
    APRErrorBubbleView *errorView = [super buttonWithType:UIButtonTypeCustom];
    [errorView initUI];

    return errorView;
}

- (void)initUI {
    [self setTitle:@"protector" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    CGFloat width = 50;
    self.frame = CGRectMake(AppScreenWidth - 20 - width, 100, width, 25);
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    self.backgroundColor = [UIColor yellowColor];
    [self addTarget:self action:@selector(onBtn) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:recognizer];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [AppKeyWindow addSubview:self];
    });
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    /**
     1. 获取手势在 superview 的偏移坐标 point
     2. 手势启动阶段，将 subview 的坐标根据 point 进行校正（与此同时，将 手势在 superview 上的偏移坐标清掉）
     3. 手势结束阶段，查看四个方向是否保持了 12 个点的 padding，没有的话，则需要有 12 个点的 padding 偏移动画，恢复到该状态

     */

    CGPoint point = [sender translationInView:[sender.view superview]];

    CGFloat senderHalfViewWidth = sender.view.frame.size.width / 2;
    CGFloat senderHalfViewHeight = sender.view.frame.size.height / 2;

    __block CGPoint viewCenter = CGPointMake(sender.view.center.x + point.x, sender.view.center.y + point.y);

    if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.4 animations:^{
            if ((sender.view.center.x + point.x - senderHalfViewWidth) <= 12) {
                // 当 view 距离左边距小于 12 时，就会触发这个动画

                // sender.view.center.x + point.x <= 12 + senderHalfViewWidth 中
                // 如果刚刚好靠边的话，则 sender.view.center.x ==  senderHalfViewWidth
//                NSLog(@"sender.view.center.x: %f", sender.view.center.x);
//                NSLog(@"point.x: %f", point.x);
//                NSLog(@"senderHalfViewWidth: %f", senderHalfViewWidth);

                // 恢复为 12 的 padding
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

        // 以此来改变 view 的坐标
//        viewCenter.x = sender.view.center.x + point.x;
//        viewCenter.y = sender.view.center.y + point.y;
        sender.view.center = viewCenter;
        // 手势在 superview 上的偏移值重置为 0，因为 view 已经对应做了改变了
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



