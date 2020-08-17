//
//  AppKVOPorxy.h
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/11.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppKVOPorxy : NSObject

- (BOOL)addKVOInfoWithObserver:(NSObject *)observer
                       keyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                       context:(void *)context;

- (BOOL)removeKVOInfoWithObserver:(NSObject *)observer
                          keyPath:(NSString *)keyPath;

- (NSArray *)getAllKeyPaths;

@end

NS_ASSUME_NONNULL_END
