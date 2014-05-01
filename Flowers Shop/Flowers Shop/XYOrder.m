//
//  XYOrder.m
//  Flowers Shop
//
//  Created by Xia Yong on 13-12-18.
//  Copyright (c) 2013年 Xia Yong. All rights reserved.
//

#import "XYOrder.h"

@implementation XYOrder
- (id)initWithOrderid:(NSUInteger)oid firstname:(NSString *)firstname lastname:(NSString *)lastname email:(NSString *)email phone:(NSString *)phone purchaseDate:(NSDate *)purchaseDate {
    if (self = [super init]) {
        _oid = oid;
        _firstname = firstname;
        _lastname = lastname;
        _email = email;
        _phone = phone;
        _purchaseDate = purchaseDate;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[XYOrder allocWithZone:zone] initWithOrderid:_oid firstname:_firstname lastname:_lastname email:_email phone:_phone purchaseDate:_purchaseDate];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[oid:%lu, firstname:%@, lastname:%@,email:%@,phone:%@,purchaseDate:%@]", (unsigned long)_oid, _firstname, _lastname, _email, _phone, _purchaseDate.description];
}

@end
