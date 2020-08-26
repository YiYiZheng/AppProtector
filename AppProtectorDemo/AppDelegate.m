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
    [AppProtector.shared openAppProtection:AppProtectionAll errorHandler:^(APRCatchError * _Nonnull error) {
        NSLog(@"%@", error.fullDescription);
    }];

    [AppProtector.shared showErrorView];


    return YES;
}

@end
