//
//  APRLeaksProxy.h
//  AppProtectorDemo
//
//  Created by 郑尧元 on 2020/8/25.
//  Copyright © 2020 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APRLeaksProxy : NSObject

+ (BOOL)isAnyObjectAlreadyRecordAsLeakedWithPtrs:(NSSet *)ptrs;

+ (void)addLeakedObject:(id)object;
@end

NS_ASSUME_NONNULL_END
