//
//  XYAddProductsViewController.m
//  Flowers Shop
//
//  Created by Xia Yong on 13-12-19.
//  Copyright (c) 2013年 Xia Yong. All rights reserved.
//

#import "XYAddProductsViewController.h"
#import "XYFlosersShopModel.h"

@interface XYAddProductsViewController () <UIActionSheetDelegate>

@property (strong, nonatomic) XYProduct *currentProduct;

- (void)doCancel;
- (void)doSave;
- (void)saveWithReplace:(BOOL)replace;

@end

@implementation XYAddProductsViewController

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
    self.navigationItem.title = @"Add Products";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doCancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(doSave)];
    model = [XYFlosersShopModel sharedModel];
}

- (void)doSave {
    [self.flowerNameLabel resignFirstResponder];
    [self.flowerPriceLabel resignFirstResponder];
    
    NSString *name = [self.flowerNameLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (name.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please type the flower name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:self.flowerPriceLabel.text];
    float price;
    if (!([scanner scanFloat:&price] && scanner.isAtEnd)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please type the valid flower price." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    price = roundf(price * 100.0) / 100.0;
    self.currentProduct = [[XYProduct alloc] initWithProductid:0 productName:name productPrice:[NSNumber numberWithFloat:price]];
    XYProduct *oldProduct = [model productIFExists:self.currentProduct];
    if (oldProduct) {
        self.currentProduct.prodid = oldProduct.prodid;
        NSString *sheetTitle = [NSString stringWithFormat:@"Thers is some product named %@, Replace it?", name];
        UIActionSheet *confimActionSheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Replace" otherButtonTitles:nil];
        [confimActionSheet showInView:self.view];
    } else
        [self saveWithReplace:NO];
}

- (void)saveWithReplace:(BOOL)replace {
    BOOL b = [model addProduct:self.currentProduct];
    NSLog(@"%@ the product:%@ %@", replace ? @"Replace" : @"Add" , self.currentProduct.description, b ? @"successful" : @"failed");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
        [self saveWithReplace:YES];
}

- (void)doCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
