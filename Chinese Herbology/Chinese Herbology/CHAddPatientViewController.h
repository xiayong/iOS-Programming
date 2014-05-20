//
//  CHAddPatientViewController.h
//  Chinese Herbology
//
//  Created by Andrew on 05-13-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHAddPatientViewController : UIViewController
- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender;
- (IBAction)saveButtonTapped:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextField *lnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *fnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emialTextField;
@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

- (IBAction)textFieldReturnKeyTapped:(UITextField *)sender;
@end
