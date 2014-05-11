//
//  Medicine.h
//  Chinese Herbology
//
//  Created by Andrew on 05-12-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Receipt;

@interface Medicine : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * mid;
@property (nonatomic, retain) NSSet *receipt;
@end

@interface Medicine (CoreDataGeneratedAccessors)

- (void)addReceiptObject:(Receipt *)value;
- (void)removeReceiptObject:(Receipt *)value;
- (void)addReceipt:(NSSet *)values;
- (void)removeReceipt:(NSSet *)values;

@end
