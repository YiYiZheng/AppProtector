//
//  NSObject+Leaks.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/24.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "NSObject+Leaks.h"
#import "APRLeaksProxy.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

static const void *const kViewStackKey = &kViewStackKey;
static const void *const kParentPtrsKey = &kParentPtrsKey;

@implementation NSObject (Leaks)

- (BOOL)willDealloc {
    NSString *className = NSStringFromClass([self class]);

    if ([[NSObject classNameWhitelist] containsObject:className]) {
        return NO;
    }

    __weak id weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong id strongSelf = weakSelf;
        [strongSelf assertNotDealloc];
    });

    return YES;
}

- (void)assertNotDealloc {
    if ([APRLeaksProxy isAnyObjectAlreadyRecordAsLeakedWithPtrs:[self parentPtrs]]) {
        // it means it is already marked as leaks
        // No repeat
        return;
    }

    [APRLeaksProxy addLeakedObject:self];

    NSString *className = NSStringFromClass([self class]);
    NSLog(@"Possibly Memory Leak.\nIn case that %@ should not be dealloced, override -willDealloc in %@ by returning NO.\nView-ViewController stack: %@", className, className, [self viewStack]);
}

#pragma mark - Release

- (void)willReleaseChild:(id)child {
    [self willReleaseChildren:@[child]];
}

- (void)willReleaseChildren:(NSArray *)children {
    NSArray *viewStack = [self viewStack];
    NSSet *parentPtrs = [self parentPtrs];

    for (id child in children) {
        NSString *className = NSStringFromClass([child class]);

        [child setViewStack:[viewStack arrayByAddingObject:className]];
        [child setParentPtrs:[parentPtrs setByAddingObject:@((uintptr_t)child)]];
        [child willDealloc];
    }
}

#pragma mark - View Stack

- (NSArray *)viewStack {
    NSArray *viewStack = objc_getAssociatedObject(self, kViewStackKey);
    if (viewStack) {
        return viewStack;
    }

    return @[NSStringFromClass([self class])];
}

- (void)setViewStack:(NSArray *)viewStack {
    objc_setAssociatedObject(self, kViewStackKey, viewStack, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - Parent Pointer

- (NSSet *)parentPtrs {
    NSSet *parentPtrs = objc_getAssociatedObject(self, kParentPtrsKey);

    if (!parentPtrs) {
        parentPtrs = [[NSSet alloc] initWithObjects:@((uintptr_t)self), nil];
    }

    return parentPtrs;
}

- (void)setParentPtrs:(NSSet *)parentPtrs {
    objc_setAssociatedObject(self, kParentPtrsKey, parentPtrs, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - Whitelist

+ (void)addClassNamesToWhitelist:(NSArray *)classNames {
    [[self classNameWhitelist] addObjectsFromArray:classNames];
}

+ (NSMutableSet *)classNameWhitelist {
    static NSMutableSet *whitelist = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        whitelist = [NSMutableSet setWithObjects:
                     @"UIFieldEditor", // UIAlertControllerTextField
                     @"UINavigationBar",
                     @"_UIAlertControllerActionView",
                     @"_UIVisualEffectBackdropView",
                     nil
                     ];
    });

    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    if ([systemVersion compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending) {
        [whitelist addObject:@"UISwitch"];
    };

    return whitelist;
}


@end
