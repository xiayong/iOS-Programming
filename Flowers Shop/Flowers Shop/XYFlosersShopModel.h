//
//  XYFlosersShopModel.h
//  Flowers Shop
//
//  Created by Xia Yong on 13-12-19.
//  Copyright (c) 2013年 Xia Yong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYPropertiesLoader.h"
#import "XYProduct.h"
#import "XYOrder.h"
#import "XYItem.h"

@interface XYFlosersShopModel : NSObject
+ (XYFlosersShopModel *)sharedModel;
- (XYProduct *)productIFExists:(XYProduct *) product;
- (BOOL)addProduct:(XYProduct *)product;
- (NSArray *)products;
- (BOOL)deleteProductWithProductid:(NSUInteger)pid;
- (NSDictionary *)cart;
- (void)addProductToCartWithProductid:(NSUInteger)pid productCount:(NSUInteger)count;
@end
