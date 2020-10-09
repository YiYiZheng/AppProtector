//
//  UnrecognizedSelectorViewController.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/7.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "UnrecognizedSelectorViewController.h"
#import "APRCommonTool.h"

@interface Car: NSObject

- (void)fly;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation Car

// types https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"enter resolveInstanceMethod sel %s", sel);
//    class_addMethod([self class], sel, (IMP)DynamicAddMethodIMP, "v@:");
    return false;
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    return false;
}

/*
 This method gives an object a chance to redirect an unknown message sent to it before the much more expensive forwardInvocation: machinery takes over.
 */
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"enter forwardingTargetForSelector");

    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"enter methodSignatureForSelector");
    return [NSMethodSignature signatureWithObjCTypes:":v@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"enter forwardInvocation");
}

@end

#pragma clang diagnostic pop


@interface UnrecognizedSelectorViewController ()

@end

@implementation UnrecognizedSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDictionary *dic = @{@"key": [NSObject new]};

    NSLog(@"key = %ld", [dic[@"key"] integerValue]);

//    [[Car new] fly];
}

@end
