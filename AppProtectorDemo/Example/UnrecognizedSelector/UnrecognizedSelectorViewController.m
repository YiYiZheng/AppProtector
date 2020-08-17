//
//  UnrecognizedSelectorViewController.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/7.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "UnrecognizedSelectorViewController.h"

@interface Car: NSObject

- (void)fly;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation Car

@end

#pragma clang diagnostic pop


@interface UnrecognizedSelectorViewController ()

@end

@implementation UnrecognizedSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[Car new] fly];
}

@end
