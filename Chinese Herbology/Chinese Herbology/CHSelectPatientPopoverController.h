//
//  CHSelectPatientPopoverController.h
//  Chinese Herbology
//
//  Created by Andrew on 05-23-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@interface CHSelectPatientPopoverController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *patients;
@end
