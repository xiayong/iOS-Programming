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
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(loginButtonTapped)];
}

- (void)loginButtonTapped {
    if (![XYAppDelegate loginStatus]) {
        UIAlertView *loginAlertView = [[UIAlertView alloc] initWithTitle:@"Manager Login" message:@"Enter login and password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        loginAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [loginAlertView show];
    } else
        [self forwardAddProductPage];
}

- (void)logoutButtonTapped {
    [XYAppDelegate setLoginStatus:NO];
    NSLog(@"Manager logout successful.");
    // 管理员登出后，显示登入按钮
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(loginButtonTapped)];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 如果管理员已经登入，显示登出按钮
    if ([XYAppDelegate loginStatus]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonTapped)];
    }
    
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

- (void)forwardShoppingCartPage {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"ShoppingCart"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)addProductToCartButtonTapped:(UIButton *)sender {
    UITableViewCell *currentCell = (UITableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:currentCell];
    XYProduct *product = [[model products] objectAtIndex:indexPath.row];
    [model addProductToCartWithProductid:product.prodid];
    NSLog(@"User add %@ to the cart.", product.prodname);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(forwardShoppingCartPage)];
}

- (IBAction)deleteProductButtonTapped:(UIBarButtonItem *)sender {
    self.tableView.editing = !self.tableView.editing;
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
    label.text = [NSString stringWithFormat:@"%@  %.2f", product.prodname, [product.prodprice floatValue]];
    
    [cell viewWithTag:2].hidden = [XYAppDelegate loginStatus];
    
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
