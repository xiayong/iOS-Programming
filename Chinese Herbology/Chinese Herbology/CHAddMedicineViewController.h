//
//  CHAddMedicineViewController.h
//  Chinese Herbology
//
//  Created by Andrew on 05-15-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHConstants.h"

@interface CHAddMedicineViewController : UIViewController
- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender;
- (IBAction)saveButtonTapped:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextField *medicineNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *medicineEnglishNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *medicinePriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *medicineNoTextField;
@property (weak, nonatomic) IBOutlet UIImageView *medicineImageView;
@property (weak, nonatomic) IBOutlet UIWebView *medicineWebView;

- (IBAction)keyboardReturnTapped:(UITextField *)sender;

@end
