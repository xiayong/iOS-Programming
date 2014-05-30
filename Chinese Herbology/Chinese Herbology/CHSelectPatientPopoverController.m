//
//  CHSelectPatientPopoverController.m
//  Chinese Herbology
//
//  Created by Andrew on 05-23-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import "CHSelectPatientPopoverController.h"

@implementation CHSelectPatientPopoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.delegate setValue:self.patients.firstObject forKeyPath:@"selectedPatient"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.patients.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Patient *patient = [self.patients objectAtIndex:row];
    return [patient.fname stringByAppendingString:patient.lname];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.delegate setValue:[self.patients objectAtIndex:row] forKeyPath:@"selectedPatient"];
}
@end
