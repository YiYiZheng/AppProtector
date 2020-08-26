//
//  APRKVOPorxy.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/11.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "APRKVOPorxy.h"

@interface AppKVOInfo : NSObject
{
    // 不写 @package 就会是默认的 @protected
    @package
    void *_context;
    NSKeyValueObservingOptions _options;
    __weak NSObject *_observer;
    NSString *_keyPath;
}


@end

@implementation AppKVOInfo



@end

@interface APRKVOPorxy ()

/**
 存储结构

 第一层 字典 key: keyPath value: 数组
 第二层 数组存放所有的 KVO 信息
 */
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMutableArray<AppKVOInfo *> *> *keyPathMap;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation APRKVOPorxy

- (instancetype)init {
    self = [super init];
    if (self) {
        _keyPathMap = [NSMutableDictionary dictionary];
        _lock = [[NSLock alloc] init];
    }

    return self;
}



- (BOOL)addKVOInfoWithObserver:(NSObject *)observer
                       keyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                       context:(void *)context {
    BOOL success = false;

    [_lock lock];

    // 查看是否存在 同一个 observer 观察同一个 keyPath，如果有，就是重复观察
    NSMutableArray <AppKVOInfo *> *kvoInfos = [self getKVOInfosForKeyPath:keyPath];
    __block BOOL isExist = NO;
    [kvoInfos enumerateObjectsUsingBlock:^(AppKVOInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj->_observer == observer) {
            isExist = YES;
        }
    }];

    if (isExist) {
        success = NO;
    } else {
        // 不存在，则添加观察到数据中
        AppKVOInfo *info = [[AppKVOInfo alloc] init];
        info->_observer = observer;
        info->_keyPath = keyPath;
        info->_options = options;
        info->_context = context;
        [kvoInfos addObject:info];

        [self setKVOInfos:kvoInfos forKeyPath:keyPath];
        success = YES;
    }

    [_lock unlock];

    return success;
}

- (BOOL)removeKVOInfoWithObserver:(NSObject *)observer
                          keyPath:(NSString *)keyPath {
    [_lock lock];

    BOOL success = false;
    NSMutableArray <AppKVOInfo *> *kvoInfos = [self getKVOInfosForKeyPath:keyPath];

    __block BOOL isExist = NO;
    __block AppKVOInfo *kvoInfo;

    [kvoInfos enumerateObjectsUsingBlock:^(AppKVOInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj->_observer == observer) {
            isExist = YES;
            kvoInfo = obj;
        }
    }];

    if (kvoInfo) {
        // 从数组中删除该观察信息
        [kvoInfos removeObject:kvoInfo];
        // 如果数组为空，则把数组从字典中删除
        if (kvoInfos.count == 0) {
            [_keyPathMap removeObjectForKey:keyPath];
        }
    }

    success = isExist;

    [_lock unlock];

    return success;
}

#pragma mark - observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    NSMutableArray <AppKVOInfo *> *kvoInfos = [self getKVOInfosForKeyPath:keyPath];

    [kvoInfos enumerateObjectsUsingBlock:^(AppKVOInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 找到所有 keyPath 的观察者 并触发
        if (obj->_keyPath == keyPath) {
            [obj->_observer observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }];
}

#pragma mark - Others

- (NSArray *)getAllKeyPaths {
    return _keyPathMap.allKeys;
}

- (NSMutableArray *)getKVOInfosForKeyPath:(NSString *)keyPath {
    if ([_keyPathMap.allKeys containsObject:keyPath]) {
        return [_keyPathMap objectForKey:keyPath];
    } else {
        return [NSMutableArray array];
    }
}

- (void)setKVOInfos:(NSMutableArray *)kvoInfos forKeyPath:(NSString *)keyPath {
    [_keyPathMap setValue:kvoInfos forKey:keyPath];
}

@end
