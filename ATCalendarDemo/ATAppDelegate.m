//
//  ATAppDelegate.m
//  ATCalendarDemo
//
//  Created by Adrian Tofan on 14/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATAppDelegate.h"

#import "ATMasterViewController.h"
#import "ATEventListController.h"
#import "ATCalendar.h"
#import "NSBundle+ATCalendar.h"


@implementation ATAppDelegate

@synthesize managedObjectContext;
-(void)applicationDidBecomeActive:(UIApplication *)application{
#if DEBUG
  if (getenv("runningTests"))
    return ;
#endif
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if DEBUG
  if (getenv("runningTests"))
    return YES;
#endif
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  [NSManagedObjectModel MR_setDefaultManagedObjectModel:
   [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle at_calendar_defaultBundle]]]];
  [MagicalRecord setupCoreDataStackWithStoreNamed:@"ATCalendar.sqlite"];
  NSManagedObjectContext* moc = [NSManagedObjectContext MR_contextForCurrentThread];
  [[ATCalendar sharedInstance] syncCachesIfNeeded:[NSDate date] inContext:moc];
  [moc MR_saveToPersistentStoreAndWait];
  [[ATCalendar sharedInstance] updateAlarmLocalNotificationsInContext:moc];
  [moc MR_saveToPersistentStoreAndWait];

  ATEventListController* controller = [[ATEventListController alloc] init];
  UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
  self.window.rootViewController = navigationController;
    // Override point for customization after application launch.
  controller.moc = self.managedObjectContext;
  [self.window makeKeyAndVisible];

   return YES;
}

-(NSManagedObjectContext*)managedObjectContext{
  return [NSManagedObjectContext MR_context];
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
  [[ATCalendar sharedInstance] handleLocalNotification:notification];
}
- (void)applicationWillTerminate:(UIApplication *)application { [MagicalRecord cleanUp]; }
@end
