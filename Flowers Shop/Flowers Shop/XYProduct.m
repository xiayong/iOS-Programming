//
//  XYProduct.m
//  Flowers Shop
//
//  Created by Xia Yong on 13-12-18.
//  Copyright (c) 2013年 Xia Yong. All rights reserved.
//

#import "XYProduct.h"

@implementation XYProduct

- (id)initWithProductid:(NSUInteger)prodid productName:(NSString *)prodname productPrice:(NSNumber *)prodprice {
    if (self = [super init]) {
        _prodid = prodid;
        _prodname = prodname;
        _prodprice = prodprice;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[prodid:%d, prodname:\"%@\", prodprice:%@]", _prodid, _prodname, _prodprice];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[XYProduct allocWithZone:zone] initWithProductid:_prodid productName:_prodname productPrice:_prodprice];
}

@end
