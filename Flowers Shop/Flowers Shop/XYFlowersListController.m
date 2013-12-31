//
//  XYFlowersListController.m
//  Flowers Shop
//
//  Created by Xia Yong on 13-12-15.
//  Copyright (c) 2013年 Xia Yong. All rights reserved.
//

#import "XYFlowersListController.h"
#import "XYFlosersShopModel.h"

@interface XYFlowersListController () <UIAlertViewDelegate>
- (void)forwardAddProductPage;
@end

@implementation XYFlowersListController

XYPropertiesLoader *propertiesLoder;
XYFlosersShopModel *model;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    propertiesLoder = [XYPropertiesLoader sharedPropertiesLoader];
    model = [XYFlosersShopModel sharedModel];
    self.navigationController.toolbarHidden = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)forwardAddProductPage {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"AddProduct"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)addProduct:(UIBarButtonItem *)sender {
    if (![XYAppDelegate loginStatus]) {
        UIAlertView *loginAlertView = [[UIAlertView alloc] initWithTitle:@"Manager Login" message:@"Enter login and password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        loginAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [loginAlertView show];
    } else
        [self forwardAddProductPage];
}

- (IBAction)addProductToCartButtonTapped:(UIButton *)sender {
    UITableViewCell *currentCell = (UITableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:currentCell];
    XYProduct *product = [[model products] objectAtIndex:indexPath.row];
    [model addProductToCartWithProductid:product.prodid productCount:1];
    NSLog(@"User add %@ to the cart.", product.prodname);
}

- (IBAction)deleteProductButtonTapped:(UIBarButtonItem *)sender {
    self.tableView.editing = !self.tableView.editing;
}

- (IBAction)cartButtonTapped:(UIBarButtonItem *)sender {
}

- (IBAction)searchButtonTapped:(UIBarButtonItem *)sender {
}

- (IBAction)markButtonTapped:(UIBarButtonItem *)sender {
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 != buttonIndex) {
        NSString *username = [alertView textFieldAtIndex:0].text;
        NSString *password = [alertView textFieldAtIndex:1].text;
        BOOL usernameMatch = [[propertiesLoder propertyForKey:@kConfigManagerusernameKey defaultValue:@"root"] compare:username options:NSCaseInsensitiveSearch | NSNumericSearch ] == NSOrderedSame;
        BOOL passwordMatch = [[propertiesLoder propertyForKey:@kConfigManagerpasswordKey defaultValue:@"root"] isEqualToString:password];
        if (usernameMatch && passwordMatch) {
            [XYAppDelegate setLoginStatus:YES];
            NSLog(@"Manager login successful.");
            self.navigationItem.leftBarButtonItem.enabled = YES;
            [self forwardAddProductPage];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"User name and password do not match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [model products].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"productCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    XYProduct *product = [[model products] objectAtIndex:indexPath.row];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.text = [NSString stringWithFormat:@"%@ %.2f", product.prodname, product.prodprice.floatValue];
    if ([XYAppDelegate loginStatus]) {
        UIButton *button = (UIButton *)[cell viewWithTag:2];
        button.hidden = YES;
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([XYAppDelegate loginStatus] && editingStyle == UITableViewCellEditingStyleDelete) {
        XYProduct *product = [[model products] objectAtIndex:indexPath.row];
        [model deleteProductWithProductid:product.prodid];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XYAppDelegate loginStatus];
}

@end
