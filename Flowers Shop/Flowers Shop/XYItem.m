//
//  XYItem.m
//  Flowers Shop
//
//  Created by Xia Yong on 13-12-18.
//  Copyright (c) 2013年 Xia Yong. All rights reserved.
//

#import "XYItem.h"

@implementation XYItem

- (id)initWithOrderid:(NSUInteger)oid productid:(NSUInteger)pid count:(NSUInteger)count{
    if (self = [super init]) {
        _oid = oid;
        _pid = pid;
        _count = count;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[XYItem allocWithZone:zone] initWithOrderid:_oid productid:_pid count:_count];
}

@end
