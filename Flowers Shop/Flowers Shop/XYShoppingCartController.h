//
//  XYShoppingCartController.h
//  Flowers Shop
//
//  Created by Andrew on 4/15/14.
//  Copyright (c) 2014 Xia Yong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYShoppingCartController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *puchasedDateTextField;
@property (weak, nonatomic) IBOutlet UITableView *shoppingCartTableView;
- (IBAction)searchButtonTapped:(UIBarButtonItem *)sender;
- (IBAction)cartButtonTapped:(UIBarButtonItem *)sender;
- (IBAction)shareButtonTapped:(UIBarButtonItem *)sender;
- (IBAction)textFieldDidBeginEditing:(UITextField *)sender;
- (IBAction)textFieldDidEndOnExit:(UITextField *)sender;

@end
