//
//  Medicine.h
//  Chinese Herbology
//
//  Created by Andrew on 05-16-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Receipt;

@interface Medicine : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * mid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * englistname;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSSet *receipts;
@end

@interface Medicine (CoreDataGeneratedAccessors)

- (void)addReceiptsObject:(Receipt *)value;
- (void)removeReceiptsObject:(Receipt *)value;
- (void)addReceipts:(NSSet *)values;
- (void)removeReceipts:(NSSet *)values;

@end
