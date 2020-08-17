//
//  AppDelegate.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/7/30.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "AppDelegate.h"
#import "AppProtector.h"
#import "AppCatchError.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [AppProtector.shared openAppProtection:AppProtectionAll errorHandler:^(AppCatchError * _Nonnull error) {
        NSLog(@"%@", error.errorName);
        if (error.detail.length > 0) {
            NSLog(@"detail: %@", error.detail);
        }
        NSLog(@"%@", error.errorCallStackSymbols);
    }];

    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
