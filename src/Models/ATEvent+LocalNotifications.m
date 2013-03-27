//
//  ATEvent+LocalNotifications.m
//  ATCalendar
//
//  Created by Adrian Tofan on 27/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATEvent+LocalNotifications.h"
#import "ATAlertNotification.h"
#import "ATOccurrenceCache.h"
#import "ATCalendar.h"
#import "ATTimeSpan.h"


@implementation ATEvent (LocalNotifications)

-(void)removeExistingLocalNotifications{
  if (self.firstAlertNotification.notification) {
    [[UIApplication sharedApplication] cancelLocalNotification:self.firstAlertNotification.notification];
    [self.firstAlertNotification MR_deleteInContext:self.managedObjectContext];
    self.firstAlertNotification = nil;
  }
  if (self.seccondAlertNotification.notification) {
    [[UIApplication sharedApplication] cancelLocalNotification:self.seccondAlertNotification.notification];
    [self.seccondAlertNotification MR_deleteInContext:self.managedObjectContext];
    self.seccondAlertNotification = nil;
  }
}

-(void)scheduleLocalNotificationForOccurenceStart:(NSDate*)eventStart{
  
  
}

-(void)removeLocalNotificationsBeforeDelete{
  if (self.firstAlertNotification || self.seccondAlertNotification) {
    [self removeExistingLocalNotifications];
    ATCalendar* cal = [ATCalendar sharedInstance];
    [cal updateAlarmLocalNotificationsInContext:self.managedObjectContext];
  }
}

-(void)updateLocalNotificationsAfterChange{
  ATCalendar* cal = [ATCalendar sharedInstance];
  [self removeExistingLocalNotifications];
  [cal updateAlarmLocalNotificationsInContext:self.managedObjectContext];
}

@end