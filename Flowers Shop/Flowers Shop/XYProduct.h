//
//  XYProduct.h
//  Flowers Shop
//
//  Created by Xia Yong on 13-12-18.
//  Copyright (c) 2013年 Xia Yong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYProduct : NSObject <NSCopying>
@property (assign, nonatomic) NSUInteger prodid;
@property (copy, nonatomic) NSString *prodname;
@property (copy, nonatomic) NSNumber *prodprice;
- (id)initWithProductid:(NSUInteger)prodid productName:(NSString *)prodname productPrice:(NSNumber *)prodprice;
@end
