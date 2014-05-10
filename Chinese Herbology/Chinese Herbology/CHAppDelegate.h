//
//  CHAppDelegate.h
//  Chinese Herbology
//
//  Created by Andrew on 05-11-14.
//  Copyright (c) 2014年 FREE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
