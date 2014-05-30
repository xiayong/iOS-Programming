//
//  CHDetailViewController.h
//  Chinese Herbology
//
//  Created by Andrew on 05-11-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model/Medicine.h"

@interface CHDetailViewController : UIViewController <UISplitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *patientNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *patientTelTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiptDateTextField;
@property (weak, nonatomic) IBOutlet UITextView *patientHistoryTextView;
@property (weak, nonatomic) IBOutlet UITableView *herbologyTableView;
- (void) addMedicineToReceipt:(Medicine *)medicine;
- (IBAction)segmentedControllTapped:(UISegmentedControl *)sender;
@end
