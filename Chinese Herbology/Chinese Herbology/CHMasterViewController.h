//
//  CHMasterViewController.h
//  Chinese Herbology
//
//  Created by Andrew on 05-11-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHDetailViewController;

#import <CoreData/CoreData.h>

@interface CHMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) CHDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
