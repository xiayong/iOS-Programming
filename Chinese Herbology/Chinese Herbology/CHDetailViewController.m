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



@interface CHDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

- (void)configureView;
- (void)addNewPatient:(NSNotification *)sender;
@end

@implementation CHDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
    }
}

- (void)addNewPatient:(NSNotification *)sender {
    NSDictionary *dictionary = [sender userInfo];
    NSLog(@"Recived the add new patient notification, saving...");
    Patient *newPatient = [NSEntityDescription insertNewObjectForEntityForName:@"Patient" inManagedObjectContext:self.managedObjectContext];
    newPatient.pid = [[NSUUID UUID] UUIDString];
    newPatient.fname = [dictionary objectForKey:@"fname"];
    newPatient.lname = [dictionary objectForKey:@"lname"];
    newPatient.email = [dictionary objectForKey:@"email"];
    newPatient.tel = [dictionary objectForKey:@"tel"];
    newPatient.age = [dictionary objectForKey:@"age"];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Save the new patient - %@%@ failed. %@, %@", newPatient.fname, newPatient.lname, error, [error userInfo]);
        abort();
    }
    NSLog(@"Save the new patient - %@%@ successful.", newPatient.fname, newPatient.lname);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.managedObjectContext = ((CHAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    [self configureView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewPatient:) name:@kNotificationAddNewPatientName object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    return !segment.selectedSegmentIndex;
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

@end
