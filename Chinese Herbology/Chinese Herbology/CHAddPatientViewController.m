//
//  CHAddPatientViewController.m
//  Chinese Herbology
//
//  Created by Andrew on 05-13-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import "CHAddPatientViewController.h"
#import "CHConstants.h"
#import "Patient.h"

@interface CHAddPatientViewController () <UITextFieldDelegate>

- (void)configureView;

@end

@implementation CHAddPatientViewController

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
    
    [self configureView];
}

- (void)configureView {
    if (self.mode) {
        self.fnameTextField.text = self.currentPatient.fname;
        self.lnameTextField.text = self.currentPatient.lname;
        self.emailTextField.text = self.currentPatient.email;
        self.telTextField.text = self.currentPatient.tel;
        self.ageTextField.text = [self.currentPatient.age debugDescription];
    }
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
    NSString *fname = [self.fnameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lname = [self.lnameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *tel = [self.telTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *age = [self.ageTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL invalid = NO;
    NSString *msg = nil;
    NSInteger var = -1;
    if (age.length) {
        NSScanner *scanner = [NSScanner scannerWithString:age];
        if (!([scanner scanInteger:&var] && [scanner isAtEnd])) {
            invalid = YES;
            msg = @"Please type the valid patient's age.";
        }
    } else
        age = nil;
    NSString *telRegex = @"^[+]?[0-9]{5,15}";
    NSPredicate *contactNoPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    if (tel.length ) {
        if (![contactNoPredicate evaluateWithObject:tel]) {
            invalid = YES;
            msg = @"Please type the valid telephone number.";
        }
    } else
        tel = nil;
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (email.length) {
        if (![emailPredicate evaluateWithObject:email]) {
            invalid = YES;
            msg = @"Please type the valid email.";
        }
    } else
        email = nil;
    if (!fname.length) {
        invalid = YES;
        msg = @"Please type the patient's first name.";
    }
    if (!lname.length) {
        invalid = YES;
        msg = @"Please type the patient's last name.";
    }
    if (invalid) {
        [[[UIAlertView alloc] initWithTitle:@"Incomplete information" message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
    }
    NSMutableDictionary *patientDict = [NSMutableDictionary dictionary];
    [patientDict setObject:[NSNumber numberWithInteger:self.mode] forKey:@"mode"];
    if (self.mode) {
        self.currentPatient.fname = fname;
        self.currentPatient.lname = lname;
        if (email)
            self.currentPatient.email = email;
        if (tel)
            self.currentPatient.tel = tel;
        if (age)
            self.currentPatient.age = [NSNumber numberWithInteger:var];
    } else {
        [patientDict setObject:lname forKey:@"lname"];
        [patientDict setObject:fname forKey:@"fname"];
        if (email)
            [patientDict setObject:email forKey:@"email"];
        if (tel)
            [patientDict setObject:tel forKey:@"tel"];
        if (age)
            [patientDict setObject:[NSNumber numberWithInteger:var] forKey:@"age"];

    }
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAddOrUpdatePatientName object:self userInfo:patientDict];
    }];
}

/*
 iPad应用程序中，以Form Sheet样式modal出来的页面使用[UITextField resignFirstResponder]无法关闭键盘
 需要重写这个方法以关闭键盘
 */
-(BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *textFieldNames = @[@"lname",@"fname",@"email",@"tel",@"age"];
    for (NSString *name in textFieldNames) {
        UITextField *textField = (UITextField *)[self valueForKey:[NSString stringWithFormat:@"%@TextField", name]];
        [textField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (IBAction)textFieldReturnKeyTapped:(UITextField *)sender {
    if (sender.tag < 14) {
        UITextField *textField = (UITextField *) [self.view viewWithTag:sender.tag + 1];
        [textField becomeFirstResponder];
    }
}
@end
