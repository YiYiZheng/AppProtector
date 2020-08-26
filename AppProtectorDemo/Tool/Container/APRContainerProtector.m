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
+ (instancetype)app_arrayWithObjects:(id _Nonnull const [])objects count:(NSUInteger)count {
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
    return [self app_arrayWithObjects:objects count:index];
}

- (id)app_NSArray0ObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSString *type = @"__NSArray0";
        NSString *errorInfo = [NSString stringWithFormat:@"-[%@ %@]: index %ld beyond bounds [0 .. %ld]", type, NSStringFromSelector(_cmd), index, (unsigned long)self.count];

        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

        return nil;
    } else {
        return [self app_NSArray0ObjectAtIndex:index];
    }
}

- (id)app_NSArrayIObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSString *type = @"__NSArrayI";
        NSString *errorInfo = [NSString stringWithFormat:@"-[%@ %@]: index %ld beyond bounds [0 .. %ld]", type, NSStringFromSelector(_cmd), index, (unsigned long)self.count];

        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

        return nil;
    } else {
        return [self app_NSArrayIObjectAtIndex:index];
    }
}

- (id)app_NSSingleObjectArrayIObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSString *type = @"NSSingleObjectArrayI";
        NSString *errorInfo = [NSString stringWithFormat:@"-[%@ %@]: index %ld beyond bounds [0 .. %ld]", type, NSStringFromSelector(_cmd), index, (unsigned long)self.count];

        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

        return nil;
    } else {
        return [self app_NSSingleObjectArrayIObjectAtIndex:index];
    }
}

- (id)app_NSArrayIObjectAtIndexedSubscript:(NSUInteger)index {
    if (index >= self.count) {
        NSString *type = @"__NSArrayI";
        NSString *errorInfo = [NSString stringWithFormat:@"-[%@ objectAtIndexedSubscript:]: index %ld beyond bounds [0 .. %ld]'", type, index, (unsigned long)self.count];

        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

        return nil;
    } else {
        return [self app_NSArrayIObjectAtIndexedSubscript:index];
    }
}

@end

#pragma mark - NSMutableArray

@interface NSMutableArray (AppProtector)

@end

@implementation NSMutableArray (AppProtector)

- (id)app_MArrayObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSString *type = @"__NSArrayI";

        NSString *errorInfo = [NSString stringWithFormat:@"-[%@ %@]: index %ld beyond bounds [0 .. %ld]", type, NSStringFromSelector(_cmd), index, (unsigned long)self.count];
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

        return nil;
    } else {
        return [self app_MArrayObjectAtIndex:index];
    }
}

- (id)app_MArrayObjectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count) {
        NSString *errorInfo = [NSString stringWithFormat:@"*** -[__NSArrayM objectAtIndexedSubscript:]: index %ld beyond bounds [0 .. %ld]'",(unsigned long)idx,(unsigned long)self.count];
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

        return nil;
    } else {
        return [self app_MArrayObjectAtIndexedSubscript:idx];
    }
}

- (void)app_MArrayRemoveObjectAtIndex:(NSUInteger)idx {
    if (idx >= self.count) {
        NSString *errorInfo = [NSString stringWithFormat:@"*** -[__NSArrayM removeObjectsAtIndex:]: range {%ld, 1} extends beyond bounds [0 .. %ld]",(unsigned long)index,(unsigned long)self.count];
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

    } else {
        [self app_MArrayRemoveObjectAtIndex:idx];
    }
}

- (void)app_MArrayRemoveObjectsInRange:(NSRange)range {
    if (range.location + range.length > self.count) {
        NSString *errorInfo = [NSString stringWithFormat:@"*** -[__NSArrayM removeObjectsInRange:]: range {%ld, %ld} extends beyond bounds [0 .. %ld]",(unsigned long)range.location,(unsigned long)range.length,(unsigned long)self.count];
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

    } else {
        [self app_MArrayRemoveObjectsInRange:range];
    }
}

- (void)app_MArrayInsertObject:(id)anObject atIndex:(NSUInteger)index {
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
    [self app_MArrayInsertObject:anObject atIndex:index];
}

- (void)app_MArrayInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes{
    if (indexes.firstIndex > self.count) {
        NSString *errorInfo = [NSString stringWithFormat:@"*** -[NSMutableArray insertObjects:atIndexes:]: index %ld in index set beyond bounds [0 .. %ld]",(unsigned long)indexes.firstIndex,(unsigned long)self.count];
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];

        return;
    } else if (objects.count != (indexes.count)){
        NSString *errorInfo = [NSString stringWithFormat:@"*** -[NSMutableArray insertObjects:atIndexes:]: count of array (%ld) differs from count of index set (%ld)",(unsigned long)objects.count,(unsigned long)indexes.count];
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];
        return;
    }
    [self app_MArrayInsertObjects:objects atIndexes:indexes];
}

- (void)app_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
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
    [self app_replaceObjectAtIndex:index withObject:anObject];
}

- (void)app_replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects{
    if (indexes.lastIndex >= self.count||indexes.firstIndex >= self.count) {
        NSString *errorInfo = [NSString stringWithFormat:@"*** -[__NSArrayM replaceObjectsInRange:withObjects:count:]: range {%ld, %ld} extends beyond bounds [0 .. %ld]",(unsigned long)indexes.firstIndex,(unsigned long)indexes.count,(unsigned long)self.count];
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];
    } else {
        [self app_replaceObjectsAtIndexes:indexes withObjects:objects];
    }
}

@end

#pragma mark - NSDictionary

@interface NSDictionary (AppProtector)

@end

@implementation NSDictionary (AppProtector)

- (instancetype)app_initWithObjects:(id  _Nonnull const [])objects
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

    return [self app_initWithObjects:newObjects forKeys:newKeys count:index];
}

@end

#pragma mark - NSMutableDictionary

@interface NSMutableDictionary (AppProtector)

@end

@implementation NSMutableDictionary (AppProtector)

- (void)app_dictionaryMSetObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject == nil || aKey == nil) {
        NSString * errorInfo = @"*** setObjectForKey: object or key cannot be nil";
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];
    } else {
        [self app_dictionaryMSetObject:anObject forKey:aKey];
    }
}

- (void)app_dictionaryMRemoveObjectForKey:(id)aKey {
    if (aKey == nil) {
        NSString * errorInfo = @"*** -[__NSDictionaryM removeObjectForKey:]: key cannot be nil";
        [AppProtector.shared addErrorWithType:AppErrorTypeContainers callStack:[NSThread callStackSymbols] detail:errorInfo];
    } else {
        [self app_dictionaryMRemoveObjectForKey:aKey];
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
    app_exchangeClassMethod(__NSArray, @selector(arrayWithObjects:count:), @selector(app_arrayWithObjects:count:));

    /**

     2、objectAtIndexedSubscript
     取下标的方法

    NSArray *array2 = @[@"1",@"2",@"3"];
    id obj = array2[4];
     */
    app_exchangeInstanceMethod(__NSArrayI, @selector(objectAtIndexedSubscript:), __NSArrayI, @selector(app_NSArrayIObjectAtIndexedSubscript:));

    /**
        3-1 objectAtIndex:

        __NSArrayI 只有一个元素的数组
        NSArray *array2 = @[@"1",@"2",@"3"];
        id objectAtIndex = [array2 objectAtIndex:4];
     */
    app_exchangeInstanceMethod(__NSArrayI, @selector(objectAtIndex:), __NSArrayI, @selector(app_NSArrayIObjectAtIndex:));




    /*
        3-2

        __NSSingleObjectArrayI 是 NSArray 类族
        适用于只有一个元素的
        objectAtIndex 和取下标方法，都会走这个流程
    */
    app_exchangeInstanceMethod(__NSSingleObjectArrayI, @selector(objectAtIndex:), __NSArrayI, @selector(app_NSSingleObjectArrayIObjectAtIndex:));

    /*
     3-3


     __NSArray0 是 NSArray 类族

     objectAtIndex 和取下标方法，都会走这个流程
     */
    app_exchangeInstanceMethod(__NSArray0, @selector(objectAtIndex:), __NSArrayI, @selector(app_NSArray0ObjectAtIndex:));
}

+ (void)exchangeAllNSMutableArrayMethods {
    Class cls = NSClassFromString(@"__NSArrayM");

    // get
    app_exchangeInstanceMethod(cls, @selector(objectAtIndex:), cls, @selector(app_MArrayObjectAtIndex:));

    app_exchangeInstanceMethod(cls, @selector(objectAtIndexedSubscript:), cls, @selector(app_MArrayObjectAtIndexedSubscript:));

    // remove
    app_exchangeInstanceMethod(cls, @selector(removeObjectAtIndex:), cls, @selector(app_MArrayRemoveObjectAtIndex:));
    app_exchangeInstanceMethod(cls, @selector(removeObjectsInRange:), cls, @selector(app_MArrayRemoveObjectsInRange:));

    // insert

    // addObject 同样适用
    app_exchangeInstanceMethod(cls, @selector(insertObject:atIndex:), cls, @selector(app_MArrayInsertObject:atIndex:));
    app_exchangeInstanceMethod(cls, @selector(insertObjects:atIndexes:), cls, @selector(app_MArrayInsertObjects:atIndexes:));

    // replace
    app_exchangeInstanceMethod(cls, @selector(replaceObjectAtIndex:withObject:), cls, @selector(app_replaceObjectAtIndex:withObject:));
    app_exchangeInstanceMethod(cls, @selector(replaceObjectsAtIndexes:withObjects:), cls, @selector(app_replaceObjectsAtIndexes:withObjects:));

}

+ (void)exchangeAllNSDictionaryMethods {
//    Class dicClass = NSClassFromString(@"NSDictionary");
//    app_exchangeClassMethod(dicClass, @selector(dictionaryWithObjects:forKeys:count:), @selector(app_dictionaryWithObjects:forKeys:count:));

    /**

     字面量方法和普通方法走的 initWithObjects:forKeys:count:

     */

    Class placeholderClass = NSClassFromString(@"__NSPlaceholderDictionary");
    app_exchangeInstanceMethod(placeholderClass, @selector(initWithObjects:forKeys:count:), placeholderClass, @selector(app_initWithObjects:forKeys:count:));
}

+ (void)exchangeAllNSMutableDictionaryMethods {
    Class cls = NSClassFromString(@"__NSDictionaryM");

    app_exchangeInstanceMethod(cls, @selector(setObject:forKey:), cls, @selector(app_dictionaryMSetObject:forKey:));
    app_exchangeInstanceMethod(cls, @selector(removeObjectForKey:), cls, @selector(app_dictionaryMRemoveObjectForKey:));
}


@end
