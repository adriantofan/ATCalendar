//
//  ATAppDelegate.m
//  ATCalendarDemo
//
//  Created by Adrian Tofan on 14/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATAppDelegate.h"

#import "ATMasterViewController.h"

@implementation ATAppDelegate

@synthesize managedObjectContext;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
  UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
  ATMasterViewController *controller = (ATMasterViewController *)navigationController.topViewController;
  [MagicalRecord setupCoreDataStackWithStoreNamed:@"ATCalendar.sqlite"];
  controller.managedObjectContext = self.managedObjectContext;
    return YES;
}

-(NSManagedObjectContext*)managedObjectContext{
  return [NSManagedObjectContext MR_context];
}

- (void)applicationWillTerminate:(UIApplication *)application { [MagicalRecord cleanUp]; }
@end
