//
//  NSObject+Leaks.h
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/24.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Leaks)

- (BOOL)willDealloc;
- (void)willReleaseChild:(id)child;
- (void)willReleaseChildren:(NSArray *)children;
- (NSArray *)viewStack;
+ (void)addClassNamesToWhitelist:(NSArray *)classNames;

@end

NS_ASSUME_NONNULL_END
