//
//  RetainCycleViewController.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/25.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "RetainCycleViewController.h"

@interface RetainCycleViewController ()

@property (nonatomic, copy) void (^block)(void);

@end

@implementation RetainCycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.block = ^{
        self.view.backgroundColor = [UIColor yellowColor];
    };
}

@end
