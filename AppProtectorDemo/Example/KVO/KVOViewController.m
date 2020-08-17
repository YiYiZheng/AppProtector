//
//  KVOViewController.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/11.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "KVOViewController.h"

@interface Human : NSObject

@property (nonatomic, assign) NSInteger age;

@end

@implementation Human

@end

@interface KVOViewController ()

@property (nonatomic, strong) Human *human;

@end

@implementation KVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"KVO";

    self.human = [[Human alloc] init];
    [self.human addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];

    [self.human addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];

    self.human.age = 2;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.human && [keyPath  isEqual: @"age"]) {
        NSLog(@"%@", change);
    }
}

@end
