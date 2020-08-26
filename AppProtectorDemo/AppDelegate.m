//
//  AppDelegate.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/7/30.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "AppDelegate.h"
#import "AppProtector.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//    [AppProtector.shared closeAppProtection:AppProtectionAll];
    [AppProtector.shared openAppProtection:AppProtectionAll errorHandler:^(AppCatchError * _Nonnull error) {
        NSLog(@"%@", error.errorName);
        if (error.detail.length > 0) {
            NSLog(@"detail: %@", error.detail);
        }
        NSLog(@"%@", error.errorCallStackSymbols);
    }];

    [AppProtector.shared showErrorView];


    return YES;
}

@end
