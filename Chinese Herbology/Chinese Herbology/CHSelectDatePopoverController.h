//
//  CHSelectDatePopoverController.h
//  Chinese Herbology
//
//  Created by Andrew on 05-23-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHSelectDatePopoverController : UIViewController

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) id delegate;
@end
