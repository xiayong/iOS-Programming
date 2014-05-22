//
//  CHSelectDatePopoverController.m
//  Chinese Herbology
//
//  Created by Andrew on 05-23-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import "CHSelectDatePopoverController.h"

@implementation CHSelectDatePopoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.delegate setValue:self.datePicker.date forKey:@"receiptDate"];
}


- (IBAction)datePickerValueChanged:(UIDatePicker *)sender {
    [self.delegate setValue:self.datePicker.date forKey:@"receiptDate"];
}
@end
