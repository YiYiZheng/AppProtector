//
//  TimerDemoViewController.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/13.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "TimerDemoViewController.h"

@interface TimerDemoViewController ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TimerDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(trigger) userInfo:nil repeats:YES];
}

- (void)trigger {
    NSLog(@"Timer is triggered");
}

@end
