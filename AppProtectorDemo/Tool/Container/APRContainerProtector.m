//
//  APRContainerProtector.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/13.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "APRContainerProtector.h"
#import "APRCommonTool.h"
#import "AppProtector.h"
#import "AppProtector+internal.h"

#pragma mark - NSArray

@interface NSArray (AppProtector)

@end

@implementation NSArray (AppProtector)

/// 替换 arrayWithObjects 常见的是 @[] 写法
+ (instancetype)apr_arrayWithObjects:(id _Nonnull const [])objects count:(NSUInteger)count {
    NSUInteger index = 0;
    id _Nonnull objectsNew[count];

    for (int i = 0; i < count; i++) {
        if (objects[i]) {
            objectsNew[index] = objects[i];
            index++;
        } else {
            NSString *errorInfo = [NSString stringWithFormat:@"-[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object at index [%d]", i];
            [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];
        }
    }

    // 只返回有限数量
    return [self apr_arrayWithObjects:objects count:index];
}

- (id)apr_NSArray0ObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSString *type = @"__NSArray0";
        NSString *errorInfo = [NSString stringWithFormat:@"-[%@ %@]: index %ld beyond bounds [0 .. %ld]", type, NSStringFromSelector(_cmd), index, (unsigned long)self.count];

        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

        return nil;
    } else {
        return [self apr_NSArray0ObjectAtIndex:index];
    }
}

- (id)apr_NSArrayIObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSString *type = @"__NSArrayI";
        NSString *errorInfo = [NSString stringWithFormat:@"-[%@ %@]: index %ld beyond bounds [0 .. %ld]", type, NSStringFromSelector(_cmd), index, (unsigned long)self.count];

        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

        return nil;
    } else {
        return [self apr_NSArrayIObjectAtIndex:index];
    }
}

- (id)apr_NSSingleObjectArrayIObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSString *type = @"NSSingleObjectArrayI";
        NSString *errorInfo = [NSString stringWithFormat:@"-[%@ %@]: index %ld beyond bounds [0 .. %ld]", type, NSStringFromSelector(_cmd), index, (unsigned long)self.count];

        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

        return nil;
    } else {
        return [self apr_NSSingleObjectArrayIObjectAtIndex:index];
    }
}

- (id)apr_NSArrayIObjectAtIndexedSubscript:(NSUInteger)index {
    if (index >= self.count) {
        NSString *type = @"__NSArrayI";
        NSString *errorInfo = [NSString stringWithFormat:@"-[%@ objectAtIndexedSubscript:]: index %ld beyond bounds [0 .. %ld]'", type, index, (unsigned long)self.count];

        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

        return nil;
    } else {
        return [self apr_NSArrayIObjectAtIndexedSubscript:index];
    }
}

@end

#pragma mark - NSMutableArray

@interface NSMutableArray (AppProtector)

@end

@implementation NSMutableArray (AppProtector)

- (id)apr_MArrayObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSString *type = @"__NSArrayI";

        NSString *errorInfo = [NSString stringWithFormat:@"-[%@ %@]: index %ld beyond bounds [0 .. %ld]", type, NSStringFromSelector(_cmd), index, (unsigned long)self.count];
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

        return nil;
    } else {
        return [self apr_MArrayObjectAtIndex:index];
    }
}

- (id)apr_MArrayObjectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count) {
        NSString *errorInfo = [NSString stringWithFormat:@"*** -[__NSArrayM objectAtIndexedSubscript:]: index %ld beyond bounds [0 .. %ld]'",(unsigned long)idx,(unsigned long)self.count];
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

        return nil;
    } else {
        return [self apr_MArrayObjectAtIndexedSubscript:idx];
    }
}

- (void)apr_MArrayRemoveObjectAtIndex:(NSUInteger)idx {
    if (idx >= self.count) {
        NSString *errorInfo = [NSString stringWithFormat:@"*** -[__NSArrayM removeObjectsAtIndex:]: range {%ld, 1} extends beyond bounds [0 .. %ld]",(unsigned long)index,(unsigned long)self.count];
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

    } else {
        [self apr_MArrayRemoveObjectAtIndex:idx];
    }
}

- (void)apr_MArrayRemoveObjectsInRange:(NSRange)range {
    if (range.location + range.length > self.count) {
        NSString *errorInfo = [NSString stringWithFormat:@"*** -[__NSArrayM removeObjectsInRange:]: range {%ld, %ld} extends beyond bounds [0 .. %ld]",(unsigned long)range.location,(unsigned long)range.length,(unsigned long)self.count];
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

    } else {
        [self apr_MArrayRemoveObjectsInRange:range];
    }
}

- (void)apr_MArrayInsertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject == nil) {
        NSString *errorInfo = @"***  -[__NSArrayM insertObject:atIndex:]: object cannot be nil";
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

        return;
    }
    if (index > self.count) {
        NSString *errorInfo = [NSString stringWithFormat:@"*** -[__NSArrayM insertObject:atIndex:]: index %ld beyond bounds [0 .. %ld]",(unsigned long)index,(unsigned long)self.count];
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

        return;
    }
    [self apr_MArrayInsertObject:anObject atIndex:index];
}

- (void)apr_MArrayInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes{
    if (indexes.firstIndex > self.count) {
        NSString *errorInfo = [NSString stringWithFormat:@"*** -[NSMutableArray insertObjects:atIndexes:]: index %ld in index set beyond bounds [0 .. %ld]",(unsigned long)indexes.firstIndex,(unsigned long)self.count];
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

        return;
    } else if (objects.count != (indexes.count)){
        NSString *errorInfo = [NSString stringWithFormat:@"*** -[NSMutableArray insertObjects:atIndexes:]: count of array (%ld) differs from count of index set (%ld)",(unsigned long)objects.count,(unsigned long)indexes.count];
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];
        return;
    }
    [self apr_MArrayInsertObjects:objects atIndexes:indexes];
}

- (void)apr_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    if (anObject == nil) {
        NSString *errorInfo = @"***  -[__NSArrayM replaceObjectAtIndex:withObject:]: object cannot be nil";
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

        return;
    }
    if (index >= self.count) {
        NSString *errorInfo = [NSString stringWithFormat:@"*** -[__NSArrayM replaceObjectAtIndex:withObject:]: index %ld beyond bounds [0 .. %ld]",(unsigned long)index,(unsigned long)self.count];
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

        return;
    }
    [self apr_replaceObjectAtIndex:index withObject:anObject];
}

- (void)apr_replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects{
    if (indexes.lastIndex >= self.count||indexes.firstIndex >= self.count) {
        NSString *errorInfo = [NSString stringWithFormat:@"*** -[__NSArrayM replaceObjectsInRange:withObjects:count:]: range {%ld, %ld} extends beyond bounds [0 .. %ld]",(unsigned long)indexes.firstIndex,(unsigned long)indexes.count,(unsigned long)self.count];
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];
    } else {
        [self apr_replaceObjectsAtIndexes:indexes withObjects:objects];
    }
}

@end

#pragma mark - NSDictionary

@interface NSDictionary (AppProtector)

@end

@implementation NSDictionary (AppProtector)

- (instancetype)apr_initWithObjects:(id  _Nonnull const [])objects
                            forKeys:(id<NSCopying>  _Nonnull const [])keys
                              count:(NSUInteger)cnt {
    NSUInteger index = 0;
    id _Nonnull newObjects[cnt];
    id <NSCopying> _Nonnull newKeys[cnt];

    for (int i = 0; i < cnt; i++) {
        if (objects[i] && keys[i]) {
            newObjects[index] = objects[i];
            newKeys[index] = keys[i];
            index++;
        } else {
            // key or value is nil
            NSString *errorInfo = [NSString stringWithFormat:@"*** -[__NSPlaceholderDictionary initWithObjects:forKeys:count:]: attempt to insert nil object from objects[%d]",i];

            [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];
        }
    }

    return [self apr_initWithObjects:newObjects forKeys:newKeys count:index];
}

@end

#pragma mark - NSMutableDictionary

@interface NSMutableDictionary (AppProtector)

@end

@implementation NSMutableDictionary (AppProtector)

- (void)apr_dictionaryMSetObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject == nil || aKey == nil) {
        NSString * errorInfo = @"*** setObjectForKey: object or key cannot be nil";
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];
    } else {
        [self apr_dictionaryMSetObject:anObject forKey:aKey];
    }
}

- (void)apr_dictionaryMRemoveObjectForKey:(id)aKey {
    if (aKey == nil) {
        NSString * errorInfo = @"*** -[__NSDictionaryM removeObjectForKey:]: key cannot be nil";
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];
    } else {
        [self apr_dictionaryMRemoveObjectForKey:aKey];
    }
}

@end


#pragma mark - AppContainerProtector

@implementation APRContainerProtector

+ (void)exchangeAllMethods {
    [self exchangeAllNSArrayMethods];
    [self exchangeAllNSMutableArrayMethods];
    [self exchangeAllNSDictionaryMethods];
    [self exchangeAllNSMutableDictionaryMethods];
}

+ (void)exchangeAllNSArrayMethods {
    /**
        1、__NSPlaceholderArray：仅仅是 alloc
        2、__NSArray0：空数组
        3、__NSSingleObjectArrayI：有且仅有一个元素
        4、__NSArrayI：大于一个元素

     */
    Class __NSArray = NSClassFromString(@"NSArray");
    Class __NSArrayI = NSClassFromString(@"__NSArrayI");
    Class __NSSingleObjectArrayI = NSClassFromString(@"__NSSingleObjectArrayI");
    Class __NSArray0 = NSClassFromString(@"__NSArray0");

    /**
      1、  NSArray *array = @[@"12", @"234", @"456", nilValue];
        注意使用的是类方法
     */
    apr_exchangeClassMethod(__NSArray, @selector(arrayWithObjects:count:), @selector(apr_arrayWithObjects:count:));

    /**

     2、objectAtIndexedSubscript
     取下标的方法

    NSArray *array2 = @[@"1",@"2",@"3"];
    id obj = array2[4];
     */
    apr_exchangeInstanceMethod(__NSArrayI, @selector(objectAtIndexedSubscript:), __NSArrayI, @selector(apr_NSArrayIObjectAtIndexedSubscript:));

    /**
        3-1 objectAtIndex:

        __NSArrayI 只有一个元素的数组
        NSArray *array2 = @[@"1",@"2",@"3"];
        id objectAtIndex = [array2 objectAtIndex:4];
     */
    apr_exchangeInstanceMethod(__NSArrayI, @selector(objectAtIndex:), __NSArrayI, @selector(apr_NSArrayIObjectAtIndex:));




    /*
        3-2

        __NSSingleObjectArrayI 是 NSArray 类族
        适用于只有一个元素的
        objectAtIndex 和取下标方法，都会走这个流程
    */
    apr_exchangeInstanceMethod(__NSSingleObjectArrayI, @selector(objectAtIndex:), __NSArrayI, @selector(apr_NSSingleObjectArrayIObjectAtIndex:));

    /*
     3-3


     __NSArray0 是 NSArray 类族

     objectAtIndex 和取下标方法，都会走这个流程
     */
    apr_exchangeInstanceMethod(__NSArray0, @selector(objectAtIndex:), __NSArrayI, @selector(apr_NSArray0ObjectAtIndex:));
}

+ (void)exchangeAllNSMutableArrayMethods {
    Class cls = NSClassFromString(@"__NSArrayM");

    // get
    apr_exchangeInstanceMethod(cls, @selector(objectAtIndex:), cls, @selector(apr_MArrayObjectAtIndex:));

    apr_exchangeInstanceMethod(cls, @selector(objectAtIndexedSubscript:), cls, @selector(apr_MArrayObjectAtIndexedSubscript:));

    // remove
    apr_exchangeInstanceMethod(cls, @selector(removeObjectAtIndex:), cls, @selector(apr_MArrayRemoveObjectAtIndex:));
    apr_exchangeInstanceMethod(cls, @selector(removeObjectsInRange:), cls, @selector(apr_MArrayRemoveObjectsInRange:));

    // insert

    // addObject 同样适用
    apr_exchangeInstanceMethod(cls, @selector(insertObject:atIndex:), cls, @selector(apr_MArrayInsertObject:atIndex:));
    apr_exchangeInstanceMethod(cls, @selector(insertObjects:atIndexes:), cls, @selector(apr_MArrayInsertObjects:atIndexes:));

    // replace
    apr_exchangeInstanceMethod(cls, @selector(replaceObjectAtIndex:withObject:), cls, @selector(apr_replaceObjectAtIndex:withObject:));
    apr_exchangeInstanceMethod(cls, @selector(replaceObjectsAtIndexes:withObjects:), cls, @selector(apr_replaceObjectsAtIndexes:withObjects:));

}

+ (void)exchangeAllNSDictionaryMethods {
//    Class dicClass = NSClassFromString(@"NSDictionary");
//    apr_exchangeClassMethod(dicClass, @selector(dictionaryWithObjects:forKeys:count:), @selector(apr_dictionaryWithObjects:forKeys:count:));

    /**

     字面量方法和普通方法走的 initWithObjects:forKeys:count:

     */

    Class placeholderClass = NSClassFromString(@"__NSPlaceholderDictionary");
    apr_exchangeInstanceMethod(placeholderClass, @selector(initWithObjects:forKeys:count:), placeholderClass, @selector(apr_initWithObjects:forKeys:count:));
}

+ (void)exchangeAllNSMutableDictionaryMethods {
    Class cls = NSClassFromString(@"__NSDictionaryM");

    apr_exchangeInstanceMethod(cls, @selector(setObject:forKey:), cls, @selector(apr_dictionaryMSetObject:forKey:));
    apr_exchangeInstanceMethod(cls, @selector(removeObjectForKey:), cls, @selector(apr_dictionaryMRemoveObjectForKey:));
}


@end
