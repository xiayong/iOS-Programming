//
//  Patient.h
//  Chinese Herbology
//
//  Created by Andrew on 05-12-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Patient : NSManagedObject

@property (nonatomic, retain) NSNumber * pid;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * history;
@property (nonatomic, retain) NSSet *receipt;
@end

@interface Patient (CoreDataGeneratedAccessors)

- (void)addReceiptObject:(NSManagedObject *)value;
- (void)removeReceiptObject:(NSManagedObject *)value;
- (void)addReceipt:(NSSet *)values;
- (void)removeReceipt:(NSSet *)values;

@end
