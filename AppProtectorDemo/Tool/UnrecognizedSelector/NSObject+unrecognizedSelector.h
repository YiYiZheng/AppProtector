//
//  NSObject+unrecognizedSelector.h
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/19.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (unrecognizedSelector)

- (id)app_swizzle_forwardingTargetForSelector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
