//
//  XYFlowersListController.h
//  Flowers Shop
//
//  Created by Xia Yong on 13-12-15.
//  Copyright (c) 2013年 Xia Yong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYAppDelegate.h"

@interface XYFlowersListController : UITableViewController

- (IBAction)addProduct:(UIBarButtonItem *)sender;
- (IBAction)addToCartButtonTaped:(UIButton *)sender;
- (IBAction)deleteProductButtonTaped:(UIBarButtonItem *)sender;

@end
