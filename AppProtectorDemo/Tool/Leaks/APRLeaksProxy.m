//
//  APRLeaksProxy.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/25.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "APRLeaksProxy.h"
#import <objc/runtime.h>
#import "AppProtector.h"
#import "AppProtector+internal.h"

static NSMutableSet *leakedObjectPtrs;

@interface APRLeaksProxy ()

@property (nonatomic, weak) id object;
@property (nonatomic, strong) NSNumber *objectPtr;
@property (nonatomic, strong) NSArray *viewStack;

@end

@implementation APRLeaksProxy

+ (BOOL)isAnyObjectAlreadyRecordAsLeakedWithPtrs:(NSSet *)ptrs {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        leakedObjectPtrs = [[NSMutableSet alloc] init];
    });

    if (ptrs.count == 0) {
        return NO;
    }

    if ([leakedObjectPtrs intersectsSet:ptrs]) {
        return YES;
    }

    return NO;
}

+ (void)addLeakedObject:(id)object {
    APRLeaksProxy *proxy = [[APRLeaksProxy alloc] init];
    proxy.object = object;
    proxy.objectPtr = @((uintptr_t)object);
    proxy.viewStack = [object viewStack];

    static const void *const kLeakedObjectProxyKey = &kLeakedObjectProxyKey;
    objc_setAssociatedObject(object, kLeakedObjectProxyKey, proxy, OBJC_ASSOCIATION_RETAIN);
    [leakedObjectPtrs addObject:proxy.objectPtr];

    NSString *detail = [NSString stringWithFormat:@"%@", proxy.viewStack];
    [AppProtector.shared addErrorWithType:AppErrorTypeRetainCycle callStack:@[] detail:detail];
}


/// Useless?
- (void)dealloc {
    NSNumber *objectPtr = _objectPtr;
//    NSArray *viewStack = _viewStack;
    dispatch_async(dispatch_get_main_queue(), ^{
        [leakedObjectPtrs removeObject:objectPtr];

    });
}


@end
