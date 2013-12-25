//
//  XYOrder.h
//  Flowers Shop
//
//  Created by Xia Yong on 13-12-18.
//  Copyright (c) 2013年 Xia Yong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYOrder : NSObject <NSCopying>
@property (assign, nonatomic) NSUInteger oid;
@property (copy, nonatomic) NSString *firstname;
@property (copy, nonatomic) NSString *lastname;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *phone;
@property (strong, nonatomic) NSDate *purchaseDate;

- (id)initWithOrderid:(NSUInteger)oid firstname:(NSString *)firstname lastname:(NSString *)lastname email:(NSString *)email phone:(NSString *) phone purchaseDate:(NSDate *)purchaseDate;
@end
