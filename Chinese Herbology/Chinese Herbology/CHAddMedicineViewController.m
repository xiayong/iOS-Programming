//
//  CHAddMedicineViewController.m
//  Chinese Herbology
//
//  Created by Andrew on 05-15-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import "CHAddMedicineViewController.h"

@interface CHAddMedicineViewController ()

@property (nonatomic, strong) NSString *medicineDetailURL;

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
    
    NSData *imageData = UIImageJPEGRepresentation(self.medicineImageView.image, 0.5);
    NSDictionary *dic = @{@"name":name, @"no":self.medicineNoTextField.text, @"englishname":englishname, @"price" : [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", price]], @"image" : imageData, @"url":self.medicineDetailURL};
    NSLog(@"Posting the notification to save the new medidine - %@.", name);
    [self dismissViewControllerAnimated:YES completion:^{
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:@kNotificationAddNewMedicineName object:self userInfo:dic];
    }];
}
- (IBAction)keyboardReturnTapped:(UITextField *)sender {
    //[sender resignFirstResponder];
    if (self.medicineNameTextField == sender)
        [self.medicineEnglishNameTextField becomeFirstResponder];
    else if (self.medicineEnglishNameTextField == sender)
        [self.medicinePriceTextField becomeFirstResponder];
    else if(self.medicineNoTextField == sender) {
        NSString *medicieNo = [[self.medicineNoTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
        self.medicineNoTextField.text  = medicieNo;
        self.medicineDetailURL = [@kMedicineDetialURLPrefix stringByAppendingString:medicieNo];
        NSURL *detailURL = [NSURL URLWithString:self.medicineDetailURL];
        [self.medicineWebView loadRequest:[NSURLRequest requestWithURL:detailURL]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@kMedicineImageURL, medicieNo]]];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.medicineImageView.image = [[UIImage alloc] initWithData:data];
                });
            }
        });
    }
}
@end
