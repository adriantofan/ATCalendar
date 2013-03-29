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
#import "ATDailyRecurrence.h"
#import "ATWeeklyRecurrence.h"
#import "ATMonthlyRecurrence.h"
#import "ATYearlyRecurrence.h"


@implementation ATEvent (LocalNotifications)

-(UILocalNotification*)notificationWithDate:(NSDate*)eventStart alertType:(ATEventAlertType)type{
  UILocalNotification* not = [UILocalNotification new];
  // ignore secconds
  not.fireDate = [eventStart dateByAddingTimeInterval:[eventStart secondOfMinute]*-1.0];
  // TODO fixme
  not.timeZone = self.timeZone;
  not.alertBody = self.summary;
  if (self.isRecurrent) {
    if ([self.recurence class] == [ATDailyRecurrence class]) {
      not.repeatInterval = NSDayCalendarUnit;
    }
    if ([self.recurence class] == [ATWeeklyRecurrence class]) {
      not.repeatInterval = NSWeekCalendarUnit;
    }
    if ([self.recurence class] == [ATMonthlyRecurrence class]) {
      not.repeatInterval = NSMonthCalendarUnit;
    }
    if ([self.recurence class] == [ATYearlyRecurrence class]) {
      not.repeatInterval = NSYearCalendarUnit;
    }
  }
  switch (type) {
    case ATEventAlertTypeNone:
      not = nil;break;
    case ATEventAlertTypeAtTime:
      break;
    case ATEventAlertType5MinBefore:
      not.fireDate = [not.fireDate dateMinutesBefore:5];
      break;
    case ATEventAlertType15MinBefore:
      not.fireDate = [not.fireDate dateMinutesBefore:15];
      break;
    case ATEventAlertType30MinBefore:
      not.fireDate = [not.fireDate dateMinutesBefore:30];
      break;
    case ATEventAlertType1HBefore:
      not.fireDate = [not.fireDate dateHoursBefore:1];
      break;
    case ATEventAlertType2HBefore:
      not.fireDate = [not.fireDate dateHoursBefore:2];
      break;
    case ATEventAlertType1DayBefore:
      not.fireDate = [not.fireDate dateDaysBefore:1];
      break;
    case ATEventAlertType2DaysBefore:
      not.fireDate = [not.fireDate dateDaysBefore:2];
      break;
  }
  not.userInfo = @{@"ATEventURI":self.objectID.URIRepresentation};
  return not;
}


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
  if (self.firstAlertTypeValue != ATEventAlertTypeNone) {
    UILocalNotification* not = [self notificationWithDate:eventStart alertType:self.firstAlertTypeValue];
    ATAlertNotification *notLink = [ATAlertNotification MR_createInContext:self.managedObjectContext];
    self.firstAlertNotification = notLink;
    notLink.notification = not;
    notLink.event = self;
    [[UIApplication sharedApplication] scheduleLocalNotification:not];
    NSLog(@"Scheduled first notification: %@",[not description]);


  }
  if (self.seccondAlertTypeValue != ATEventAlertTypeNone) {
    UILocalNotification* not = [self notificationWithDate:eventStart alertType:self.seccondAlertTypeValue];
    ATAlertNotification *notLink = [ATAlertNotification MR_createInContext:self.managedObjectContext];
    self.seccondAlertNotification = notLink;
    notLink.notification = not;
    notLink.event = self;
    NSLog(@"Scheduled seccond notification: %@",[not description]);
    [[UIApplication sharedApplication] scheduleLocalNotification:not];
  }
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