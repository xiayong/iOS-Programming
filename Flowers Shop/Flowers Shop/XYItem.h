//
//  XYItem.h
//  Flowers Shop
//
//  Created by Xia Yong on 13-12-18.
//  Copyright (c) 2013年 Xia Yong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYItem : NSObject <NSCopying>
@property (assign, nonatomic) NSUInteger oid;
@property (assign, nonatomic) NSUInteger pid;
@property (assign, nonatomic) NSUInteger count;

- (id)initWithOrderid:(NSUInteger)oid productid:(NSUInteger)pid count:(NSUInteger)count;

@end
