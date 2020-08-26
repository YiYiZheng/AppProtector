//
//  APRErrorDetailViewController.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/20.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "APRErrorDetailViewController.h"

@interface APRErrorDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, copy) NSString *content;

@end

@implementation APRErrorDetailViewController

- (instancetype)initWithContent:(NSString *)content {
    if (self = [super init]) {
        self.content = content;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Error Detail";

    self.textView.text = self.content;
}




@end
