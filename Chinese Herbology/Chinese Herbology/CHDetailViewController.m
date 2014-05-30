//
//  CHDetailViewController.m
//  Chinese Herbology
//
//  Created by Andrew on 05-11-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import "CHDetailViewController.h"
#import "CHAppDelegate.h"
#import "CHConstants.h"
#import "Model/Patient.h"
#import "Model/Receipt.h"



@interface CHDetailViewController () <UITextFieldDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (nonatomic, strong) CHAppDelegate *appDelegate;
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSDate *receiptDate;
@property (nonatomic, strong) NSMutableArray *patients;
@property (nonatomic, weak) Medicine *dragingMedicine;

@property (nonatomic, assign, readonly) BOOL draging;

- (void)configureView;
- (void)addOrUpdatePatient:(NSNotification *)sender;
@end

@implementation CHDetailViewController

- (void)setReceiptDate:(NSDate *)receiptDate {
    _receiptDate = receiptDate;
    [self configureView];
}
- (void)setSelectedPatient:(Patient *)selectedPatient {
    _selectedPatient = selectedPatient;
    [self configureView];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ReceiptCellIdentifier = @"ReceiptCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReceiptCellIdentifier forIndexPath:indexPath];
    static NSArray *receipts = nil;
    if (!indexPath.row)
        receipts = [[_selectedPatient.receipts allObjects] mutableCopy];
    Receipt *receipt = [receipts objectAtIndex:indexPath.row];
    ((UILabel *)[cell viewWithTag:1]).text = receipt.medicine.name;
    ((UILabel *)[cell viewWithTag:2]).text = receipt.quantity.description;
    ((UILabel *)[cell viewWithTag:3]).text = [NSString stringWithFormat:@"HK$ %@", receipt.price];
    return cell;
}

- (void)configureView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterFullStyle;
    self.receiptDateTextField.text = [formatter stringFromDate:_receiptDate];
    self.patientNameTextField.text = [_selectedPatient.fname stringByAppendingString:_selectedPatient.lname];
    self.patientTelTextField.text = _selectedPatient.tel;
    self.patientHistoryTextView.text = _selectedPatient.history;
    [self.herbologyTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _selectedPatient.receipts.count;
}


- (void)addOrUpdatePatient:(NSNotification *)sender {
    NSDictionary *dictionary = [sender userInfo];
    int mode = [((NSNumber *)[dictionary objectForKey:@"mode"]) intValue];
    NSLog(@"Recived the %@ patient notification, saving...", mode ? @"update":@"save");
    Patient *patient = nil;
    
    if (!mode) {
        patient = [NSEntityDescription insertNewObjectForEntityForName:@"Patient" inManagedObjectContext:self.appDelegate.managedObjectContext];
        patient.pid = [[NSUUID UUID] UUIDString];
        patient.fname = [dictionary objectForKey:@"fname"];
        patient.lname = [dictionary objectForKey:@"lname"];
        patient.email = [dictionary objectForKey:@"email"];
        patient.tel = [dictionary objectForKey:@"tel"];
        patient.age = [dictionary objectForKey:@"age"];
    } else
        patient = self.selectedPatient;
    
    [self.appDelegate saveContext];
    [self configureView];
    
    NSLog(@"%@ the patient - %@%@ successful.", mode ? @"Update":@"Save", patient.fname, patient.lname);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!buttonIndex) {
        NSScanner *scanner = [NSScanner scannerWithString:[alertView textFieldAtIndex:0].text];
        int count;
        if (!([scanner scanInt:&count] && [scanner isAtEnd]))
            [[[UIAlertView alloc] initWithTitle:@"Chinese Herbology" message:@"The count invalid." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        else {
            NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.appDelegate.managedObjectContext];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            request.entity = entityDescription;
            request.predicate = [NSPredicate predicateWithFormat:@"medicine.mid = %@ AND patient.pid = %@",self.dragingMedicine.mid, self.selectedPatient.pid];
            NSError *error;
            Receipt *receipt;
            NSArray *receipts = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
            if (receipts.count) {
                receipt = receipts.firstObject;
                receipt.quantity = [NSNumber numberWithInt:receipt.quantity.intValue + count];
            }
            else {
                receipt = [NSEntityDescription insertNewObjectForEntityForName:@"Receipt" inManagedObjectContext:self.appDelegate.managedObjectContext];
                receipt.rid = [[NSUUID UUID] UUIDString];
                receipt.quantity = [NSNumber numberWithInt:count];
                receipt.medicine = self.dragingMedicine;
                receipt.patient = self.selectedPatient;
                [self.dragingMedicine addReceiptsObject:receipt];
                [self.selectedPatient addReceiptsObject:receipt];
            }
            receipt.price = [self.dragingMedicine.price decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:receipt.quantity.description]];
            receipt.createDate = self.receiptDate;
            NSLog(@"add %d %@ to %@%@'s receipts", count, self.dragingMedicine.name, self.selectedPatient.fname, self.selectedPatient.lname);
            [self.herbologyTableView reloadData];
        }
    }
}

- (void)addMedicineToReceipt:(Medicine *)medicine {
    if (self.selectedPatient) {
        self.dragingMedicine = medicine;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Chinese Herbology" message:[NSString stringWithFormat:@"Type the count of %@", medicine.name] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alertView textFieldAtIndex:0];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.returnKeyType = UIReturnKeyDone;
        textField.text = @"1";
        [alertView show];
    }
}

- (IBAction)segmentedControllTapped:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex ==2) {
        if (self.selectedPatient.receipts.count) {
            if (!self.receiptDate)
                self.receiptDate = [NSDate date];
            [_selectedPatient setValue:_receiptDate forKeyPath:@"receipts.createDate"];
            [self.appDelegate saveContext];
            NSLog(@"Save the %@%@'s receipts successful.", self.selectedPatient.fname, self.selectedPatient.lname);
        }
        else
            [[[UIAlertView alloc] initWithTitle:@"Chinese Herbology" message:@"Please select a patient and add some medicines first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _appDelegate = [UIApplication sharedApplication].delegate;
    [self configureView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addOrUpdatePatient:) name:@kNotificationAddOrUpdatePatientName object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([@"AddPatient" isEqualToString:identifier]) {
        UISegmentedControl *segment = (UISegmentedControl *)sender;
        return (!segment.selectedSegmentIndex) || (segment.selectedSegmentIndex == 1 && self.selectedPatient);
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destinationViewController = [segue destinationViewController];
    if ([@"AddPatient" isEqualToString:segue.identifier]) {
        UISegmentedControl *segment = (UISegmentedControl *)sender;
        
        // 告知是添加模式，还是编辑模式
        [destinationViewController setValue:[NSNumber numberWithInteger:segment.selectedSegmentIndex] forKey:@"mode"];
        // 如果是编辑模式，则把当前选中的Patient传给编辑页面
        if (segment.selectedSegmentIndex)
            [destinationViewController setValue:self.selectedPatient forKey:@"currentPatient"];
    } else {
        [destinationViewController setValue:self forKey:@"delegate"];
        if ([@"SelectPatient" isEqualToString:segue.identifier]) {
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            request.entity = [NSEntityDescription entityForName:@"Patient" inManagedObjectContext:self.appDelegate.managedObjectContext];
            NSError *error;
            NSArray *patients = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
            self.patients = [NSMutableArray arrayWithArray:patients];
            [destinationViewController setValue:self.patients forKey:@"patients"];
        }
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"中药资料", @"中药资料");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSString *history = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.selectedPatient.history = history.length ? history : nil;
}

@end
