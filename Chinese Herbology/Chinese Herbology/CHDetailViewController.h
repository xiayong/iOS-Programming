//
//  CHDetailViewController.h
//  Chinese Herbology
//
//  Created by Andrew on 05-11-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
