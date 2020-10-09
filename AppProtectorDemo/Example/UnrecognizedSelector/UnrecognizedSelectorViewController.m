//
//  UnrecognizedSelectorViewController.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/7.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "UnrecognizedSelectorViewController.h"
#import "APRCommonTool.h"

@interface UnrecognizedSelectorViewController ()

@end

@implementation UnrecognizedSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDictionary *dic = @{@"key": [NSObject new]};

    NSLog(@"key = %ld", [dic[@"key"] integerValue]);

//    [[Car new] fly];
}

@end

// types https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
