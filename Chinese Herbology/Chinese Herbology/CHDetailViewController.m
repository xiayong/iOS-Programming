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
#import "Patient.h"



@interface CHDetailViewController () <UITextFieldDelegate>
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSDate *receiptDate;
@property (nonatomic, strong) NSMutableArray *patients;

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

- (void)configureView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterFullStyle;
    self.receiptDateTextField.text = [formatter stringFromDate:_receiptDate];
    self.patientNameTextField.text = [_selectedPatient.fname stringByAppendingString:_selectedPatient.lname];
    self.patientTelTextField.text = _selectedPatient.tel;
}

- (void)addOrUpdatePatient:(NSNotification *)sender {
    NSDictionary *dictionary = [sender userInfo];
    int mode = [((NSNumber *)[dictionary objectForKey:@"mode"]) intValue];
    NSLog(@"Recived the %@ patient notification, saving...", mode ? @"update":@"save");
    NSError *error;
    Patient *patient = nil;
    
    if (!mode) {
        patient = [NSEntityDescription insertNewObjectForEntityForName:@"Patient" inManagedObjectContext:self.managedObjectContext];
        patient.pid = [[NSUUID UUID] UUIDString];
        patient.fname = [dictionary objectForKey:@"fname"];
        patient.lname = [dictionary objectForKey:@"lname"];
        patient.email = [dictionary objectForKey:@"email"];
        patient.tel = [dictionary objectForKey:@"tel"];
        patient.age = [dictionary objectForKey:@"age"];
    } else
        patient = self.selectedPatient;
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@ the patient - %@%@ failed. %@, %@", mode ? @"Update":@"Save", patient.fname, patient.lname, error, [error userInfo]);
        abort();
    }
    [self configureView];
    
    NSLog(@"%@ the patient - %@%@ successful.", mode ? @"Update":@"Save", patient.fname, patient.lname);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.managedObjectContext = ((CHAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
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
            request.entity = [NSEntityDescription entityForName:@"Patient" inManagedObjectContext:self.managedObjectContext];
            NSError *error;
            NSArray *patients = [self.managedObjectContext executeFetchRequest:request error:&error];
            self.patients = [NSMutableArray arrayWithArray:patients];
            [destinationViewController setValue:patients forKey:@"patients"];
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

@end
