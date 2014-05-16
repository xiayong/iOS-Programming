//
//  CHAddMedicineViewController.m
//  Chinese Herbology
//
//  Created by Andrew on 05-15-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import "CHAddMedicineViewController.h"

@interface CHAddMedicineViewController ()

@end

@implementation CHAddMedicineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:[@"https://zh.wikipedia.org/wiki/黄芪" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.medicineWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonTapped:(UIBarButtonItem *)sender {
    NSString *name = [self.medicineNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!name.length) {
        [[[UIAlertView alloc] initWithTitle:@"Chinese Herbology" message:@"The medicine name can not be blank" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
    }
    
    NSString *englishname = [self.medicineEnglishNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSScanner *scanner = [NSScanner scannerWithString:self.medicinePriceTextField.text];
    float price;
    if (!([scanner scanFloat:&price] && scanner.isAtEnd)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Chinese Herbology" message:@"Please type the valid medicine price." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    NSDictionary *dic = @{@"name":name, @"englishname":englishname, @"price" : [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", price]]};
    [self dismissViewControllerAnimated:YES completion:^{
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:@kNotificationAddNewMedicineName object:self userInfo:dic];
    }];
}
- (IBAction)keyboardReturnTapped:(UITextField *)sender {
    [sender resignFirstResponder];
    if (self.medicineNameTextField == sender)
        [self.medicineEnglishNameTextField becomeFirstResponder];
    else if (self.medicineEnglishNameTextField == sender)
        [self.medicinePriceTextField becomeFirstResponder];
}
@end
