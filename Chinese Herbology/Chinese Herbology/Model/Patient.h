//
//  Patient.h
//  Chinese Herbology
//
//  Created by Andrew on 05-20-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Receipt;

@interface Patient : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * fname;
@property (nonatomic, retain) NSString * history;
@property (nonatomic, retain) NSString * lname;
@property (nonatomic, retain) NSString * pid;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSSet *receipts;
@end

@interface Patient (CoreDataGeneratedAccessors)

- (void)addReceiptsObject:(Receipt *)value;
- (void)removeReceiptsObject:(Receipt *)value;
- (void)addReceipts:(NSSet *)values;
- (void)removeReceipts:(NSSet *)values;

@end
