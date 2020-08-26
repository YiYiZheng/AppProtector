//
//  APRErrorListViewController.h
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/20.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class APRCatchError;

@interface APRErrorListViewController : UIViewController

- (instancetype)initWithErrorList:(NSArray <APRCatchError*>*)list
                        quitBlock:(void (^) (void))quitBlock;

@end

NS_ASSUME_NONNULL_END
