//
//  Receipt.h
//  Chinese Herbology
//
//  Created by Andrew on 05-12-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patient;

@interface Receipt : NSManagedObject

@property (nonatomic, retain) NSNumber * rid;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * createDate;
@property (nonatomic, retain) NSManagedObject *medicine;
@property (nonatomic, retain) Patient *patient;

@end
