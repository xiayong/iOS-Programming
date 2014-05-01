//
//  XYShoppingCartController.m
//  Flowers Shop
//
//  Created by Andrew on 4/15/14.
//  Copyright (c) 2014 Xia Yong. All rights reserved.
//

#import "XYShoppingCartController.h"
#import "XYFlosersShopModel.h"

#define kRightNavigationButtonSave      "Save"
#define kRightNavigationButtonDone      "Done"
#define kDateformatter                  "yyyy-MM-dd"

@interface XYShoppingCartController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
-(void)itemEditButtonTapped:(UIButton *)button;
@property(strong, nonatomic) UITableViewCell *currentEditingCell;
-(void)rightNavigationButtomTapped;
@end

@implementation XYShoppingCartController

XYFlosersShopModel *model;

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
    
    model = [XYFlosersShopModel sharedModel];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@kRightNavigationButtonSave style:UIBarButtonItemStylePlain target:self action:@selector(rightNavigationButtomTapped)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)rightNavigationButtomTapped {
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@kRightNavigationButtonDone]) {
        NSArray *textFields = @[@"firstNameTextField", @"lastNameTextField", @"emailAddressTextField", @"contactNoTextField", @"puchasedDateTextField"];
        for (NSString *textField in textFields)
            if ([[self valueForKeyPath:textField] respondsToSelector:@selector(resignFirstResponder)])
                [[self valueForKeyPath:textField] resignFirstResponder];
        self.navigationItem.rightBarButtonItem.title = @kRightNavigationButtonSave;
    } else {
        NSString *firstName = [self.firstNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *lastName = [self.lastNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *email = [self.emailAddressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *contactNo = [self.contactNoTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *purchasedDate = self.puchasedDateTextField.text;
        if (firstName.length == 0) {
            [[[UIAlertView alloc] initWithTitle:@"Incomplete information" message:@"First name could not be null." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            return;
        }
        if (lastName.length == 0) {
            [[[UIAlertView alloc] initWithTitle:@"Incomplete information" message:@"Last name could not be nil" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            return;
        }
        
        NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
        NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailPredicate evaluateWithObject:email]) {
            [[[UIAlertView alloc] initWithTitle:@"Incomplete information" message:@"Email invalid" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            return;
        }
        NSString *parten = @"^[+]?[0-9]{5,15}";
        NSPredicate *contactNoPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", parten];
        if (![contactNoPredicate evaluateWithObject:contactNo]) {
            [[[UIAlertView alloc] initWithTitle:@"Incomplete information" message:@"Contract No invalid" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            return;
        }
        if (purchasedDate.length == 0) {
            [[[UIAlertView alloc] initWithTitle:@"Incomplete information" message:@"Purchased date could not be nil" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            return;
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @kDateformatter;
        
        XYOrder *neworder = [[XYOrder alloc] initWithOrderid:NSNotFound firstname:firstName lastname:lastName email:email phone:contactNo purchaseDate:[formatter dateFromString:purchasedDate]];
        NSLog(@"User begin settlement: %@", neworder.description);
        BOOL b = [model settlement:neworder];
        NSLog(@"User settlement %@.", b ? @"successful" : @"failed");
        [[[UIAlertView alloc] initWithTitle:@"Settlement Result" message:[NSString stringWithFormat:@"Settlement %@.", b ? @"successful" : @"failed"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        if (b) {
            [self.shoppingCartTableView reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [model cart].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"OrderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    XYItem *item = [[model cart] objectAtIndex:indexPath.row];
    //XYProduct *product = [model findProductById:item.pid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"prodid = %lu", (unsigned long)item.pid];
    XYProduct *product = [[[model products] filteredArrayUsingPredicate:predicate] objectAtIndex:0];
    ((UILabel *)[cell viewWithTag:1]).text = product.prodname;
    ((UILabel *)[cell viewWithTag:2]).text = [NSString stringWithFormat:@"HK$%.2F", [product.prodprice floatValue]];
    ((UILabel *)[cell viewWithTag:3]).text = [[NSNumber numberWithInteger:item.count] stringValue];
    UIButton *editButton = (UIButton *)[cell viewWithTag:4];
    [editButton addTarget:self action:@selector(itemEditButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)itemEditButtonTapped:(UIButton *)button {
    self.currentEditingCell = (UITableViewCell *)[[[button superview] superview] superview];
    NSIndexPath *indexPath = [self.shoppingCartTableView indexPathForCell:self.currentEditingCell];
    XYItem *item = [[model cart] objectAtIndex:indexPath.row];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Update item" message:@"Please type the count" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.text = [[NSNumber numberWithInteger:item.count] stringValue];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    alertView.delegate = self;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *inputText = [alertView textFieldAtIndex:0].text;
        NSScanner *scanner = [NSScanner scannerWithString:inputText];
        int newCount;
        if ([scanner scanInt:&newCount] && scanner.isAtEnd) {
            NSIndexPath *indexPath = [self.shoppingCartTableView indexPathForCell:self.currentEditingCell];
            XYItem *item = [[model cart] objectAtIndex:indexPath.row];
            NSLog(@"User modify the %@ count to %d", [item description], newCount);
            item.count = newCount;
            [model modifyItem:item];
            [self.shoppingCartTableView reloadData];
        } else
            [[[UIAlertView alloc] initWithTitle:@"Input Error" message:[NSString stringWithFormat:@"The %@ is not a number!",inputText] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Purchased Items:";
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
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

- (IBAction)searchButtonTapped:(UIBarButtonItem *)sender {
}

- (IBAction)cartButtonTapped:(UIBarButtonItem *)sender {
}

- (IBAction)shareButtonTapped:(UIBarButtonItem *)sender {
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)sender {
    self.navigationItem.rightBarButtonItem.title = @kRightNavigationButtonDone;
    if (sender == self.puchasedDateTextField) {
        UIDatePicker *picker = [[UIDatePicker alloc] init];
        picker.datePickerMode = UIDatePickerModeDate;
        sender.inputView = picker;
    }
}
- (IBAction)textFieldDidEndOnExit:(UITextField *)sender {
    [sender resignFirstResponder];
    if (sender == self.puchasedDateTextField) {
        UIDatePicker *datePicker = (UIDatePicker *)sender.inputView;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //formatter.dateStyle = NSDateFormatterLongStyle;
        formatter.dateFormat = @kDateformatter;
        sender.text = [formatter stringFromDate:datePicker.date];
    }
    
    self.navigationItem.rightBarButtonItem.title = @kRightNavigationButtonSave;
}
@end
