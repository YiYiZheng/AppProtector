//
//  ContainerViewController.m
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/13.
//  Copyright © 2020 Karl. All rights reserved.
//

#import "ContainerViewController.h"
#import <objc/runtime.h>

@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self cluster];
    [self testArray];
//    [self testMutableArray];
//    [self testDic];
//    [self testMutableDic];

}

- (void)cluster {
    /**
        1、__NSPlaceholderArray：仅仅是 alloc
        2、__NSArray0：空数组
        3、__NSSingleObjectArrayI：有且仅有一个元素
        4、__NSArrayI：大于一个元素

     */
    NSLog(@"[NSArray alloc] 类型 %s", object_getClassName([NSArray alloc]));
    NSLog(@"[[NSArray alloc] init] 类型 %s", object_getClassName([[NSArray alloc] init]));
    NSLog(@"[@1] %s", object_getClassName(@[@1]));
    NSLog(@"@[@1, @2] %s", object_getClassName(@[@1, @2]));
}

- (void)testArray {
    // 1 arrayWithObjects @[]
//    NSString *nilValue;
//    NSArray *array1 = @[@"12", @"234", @"456", nilValue];

    // 2 objectAtIndexedSubscript 越界
//    NSArray *array3 = @[@"12", @"123"];
//    NSString *item = array3[2];

    // 3 以下三种都是 objectAtIndex 越界

    // __NSArray0
    NSArray *array4 = @[];
    NSLog(@"%s", object_getClassName(array4));
    NSString *item4 = [array4 objectAtIndexedSubscript:4];
    NSLog(@"item4 为 %@", item4);

    NSLog(@"---------------------------------------------------------");

    // __NSSingleObjectArrayI
    NSArray *array5 = @[@"1"];
    NSLog(@"%s", object_getClassName(array5));
    NSString *item5 = [array5 objectAtIndexedSubscript:4];
    NSLog(@"item5 为 %@", item5);

    NSLog(@"---------------------------------------------------------");

    // __NSArrayI
    NSArray *array6 = @[@"1", @"2", @"5"];
    NSLog(@"%s", object_getClassName(array6));
    NSString *item6 = [array6 objectAtIndexedSubscript:4];
    NSLog(@"item6 为 %@", item6);
}

- (void)testMutableArray {
    NSMutableArray *array1 = @[@"1"].mutableCopy;

    NSString *nilVal;

    // objectAtIndex
//    NSString *item1 = [array1 objectAtIndex:2];

    // objectAtIndexedSubscript
//    NSString *item2 = array1[3];

    // remove
//    [array1 removeObjectAtIndex:2];
//    [array1 removeObjectsInRange:NSMakeRange(0, 3)];

    // insert
//    [array1 insertObject:nilVal atIndex:0];
//    [array1 addObject:nilVal];
//    [array1 insertObject:@"1" atIndex:5];
//    [array1 insertObjects:@[@1, @3] atIndexes:[NSIndexSet indexSetWithIndex:4]];

    // replace

    // nil
    [array1 replaceObjectAtIndex:0 withObject:nilVal];
    // out of bounds
    [array1 replaceObjectAtIndex:3 withObject:@"q"];
    // out of bounds
    [array1 replaceObjectsAtIndexes:[NSIndexSet indexSetWithIndex:3] withObjects:@[@"132"]];
}

- (void)testDic {
    NSString *nilValue;
    NSDictionary *dic1 = @{@"0": nilValue};
    NSLog(@"dic1 %@", dic1);
}

- (void)testMutableDic {
    NSString *nilKey;
    NSString *nilValue;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    // set nil value
    [dic setObject:@"1212" forKey:nilValue];
    // remove nil key
    [dic removeObjectForKey:nilKey];
}



@end
