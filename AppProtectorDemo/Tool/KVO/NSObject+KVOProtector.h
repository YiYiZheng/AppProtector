//
//  NSObject+KVOProtector.h
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/19.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVOProtector)

- (void)apr_addObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                context:(void *)context;

- (void)apr_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

- (void)apr_removeObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath
                   context:(nullable void *)context;

- (void)apr_dealloc;

@end

NS_ASSUME_NONNULL_END
