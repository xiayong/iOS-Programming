//
//  Receipt.h
//  Chinese Herbology
//
//  Created by Andrew on 05-16-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Medicine, Patient;

@interface Receipt : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * rid;
@property (nonatomic, retain) Medicine *medicine;
@property (nonatomic, retain) Patient *patient;

@end
