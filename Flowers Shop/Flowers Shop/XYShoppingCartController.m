//
//  XYShoppingCartController.m
//  Flowers Shop
//
//  Created by Andrew on 4/15/14.
//  Copyright (c) 2014 Xia Yong. All rights reserved.
//

#import "XYShoppingCartController.h"

@interface XYShoppingCartController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation XYShoppingCartController

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
    
    self.navigationController.toolbarHidden = NO;
    NSLog(@"%@", [self.view class]);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] init];
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
@end
