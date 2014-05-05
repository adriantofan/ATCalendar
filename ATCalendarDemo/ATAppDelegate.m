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
#import "NSDate+MTDates.h"
#import "CoreData+MagicalRecord.h"


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
  application.applicationIconBadgeNumber = 0;
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
  UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
  if (notification) {
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [self application:application didReceiveLocalNotification:notification];
    });
  }
  return YES;
}

-(NSManagedObjectContext*)managedObjectContext{
  return [NSManagedObjectContext MR_context];
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
  [[ATCalendar sharedInstance] handleLocalNotification:notification];
  NSLog(@"didReceiveLocalNotification notification");

}
- (void)applicationWillTerminate:(UIApplication *)application { [MagicalRecord cleanUp]; }
@end
