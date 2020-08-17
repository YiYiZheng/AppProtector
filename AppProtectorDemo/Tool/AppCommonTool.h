//
//  AppCommonTool.h
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/12.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <objc/runtime.h>

#ifndef AppCommonTool_h
#define AppCommonTool_h

#define BMP_SuppressPerformSelectorLeakWarning(Stuff)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


typedef void(^APPErrorHandler)(AppCatchError * error);

#pragma mark - C 方法

/*交换实例方法*/
static inline void app_exchangeInstanceMethod(Class _originalClass, SEL _originalSel, Class _targetClass, SEL _targetSel){
    Method methodOriginal = class_getInstanceMethod(_originalClass, _originalSel);
    Method methodNew = class_getInstanceMethod(_targetClass, _targetSel);
    BOOL didAddMethod = class_addMethod(_originalClass, _originalSel, method_getImplementation(methodNew), method_getTypeEncoding(methodNew));
    if (didAddMethod) {
        class_replaceMethod(_originalClass, _targetSel, method_getImplementation(methodOriginal), method_getTypeEncoding(methodOriginal));
    }else{
        method_exchangeImplementations(methodOriginal, methodNew);
    }
}

static inline int DynamicAddMethodIMP(id self,SEL _cmd,...){
    return 0;
}

/**交换类方法*/
static inline void app_exchangeClassMethod(Class _cls, SEL _originalSel, SEL _exchangeSel) {
    Method originalMethod = class_getClassMethod(_cls, _originalSel);
    Method newMethod = class_getClassMethod(_cls, _exchangeSel);
    method_exchangeImplementations(originalMethod, newMethod);
}

/*是否是系统类*/
static inline BOOL isSystemClass(Class cls) {
    __block BOOL isSystem = NO;
    NSString *className = NSStringFromClass(cls);

    if ([className hasPrefix:@"NS"]) {
        return YES;
    }

    NSBundle *bundle = [NSBundle bundleForClass:cls];

    isSystem = (bundle != [NSBundle mainBundle]);

    return isSystem;
}


#endif /* AppCommonTool_h */
