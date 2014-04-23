//
//  NSArray+DeepCopy.m
//  Flowers Shop
//
//  Created by Andrew on 04-23-14.
//  Copyright (c) 2014 Xia Yong. All rights reserved.
//

#import "NSArray+DeepCopy.h"

@implementation NSArray (DeepCopy)
- (NSArray *)deepCopy {
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:self.count];
    id copyValue;
    for (id obj in self) {
        if ([obj respondsToSelector:@selector(deepCopy)])
            copyValue = [obj deepCopy];
        else
            copyValue = [obj copy];
        [newArray addObject:copyValue];
    }
    
    return [newArray copy];
}
@end
