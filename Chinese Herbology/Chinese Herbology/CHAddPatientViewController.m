//
//  CHAddPatientViewController.m
//  Chinese Herbology
//
//  Created by Andrew on 05-13-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import "CHAddPatientViewController.h"

@interface CHAddPatientViewController () <UITextFieldDelegate>

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
}

/*
 iPad应用程序中，以Form Sheet样式modal出来的页面使用[UITextField resignFirstResponder]无法关闭键盘
 需要重写这个方法以关闭键盘
 */
-(BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *textFieldNames = @[@"lname",@"fname",@"emial",@"tel",@"age"];
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
