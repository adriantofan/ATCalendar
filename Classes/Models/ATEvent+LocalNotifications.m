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
#define MR_SHORTHAND
#import "CoreData+MagicalRecord.h"
#import "NSDate+MTDates.h"


NSString* const ATEventURIKey = @"ATEventURIKey";

@implementation ATEvent (LocalNotifications)

-(UILocalNotification*)notificationWithDate:(NSDate*)eventStart alertType:(ATEventAlertType)type{
  UILocalNotification* not = [UILocalNotification new];
  // ignore secconds
  not.fireDate = [eventStart dateByAddingTimeInterval:[eventStart mt_secondOfMinute]*-1.0];
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
      not.fireDate = [not.fireDate mt_dateMinutesBefore:5];
      break;
    case ATEventAlertType15MinBefore:
      not.fireDate = [not.fireDate mt_dateMinutesBefore:15];
      break;
    case ATEventAlertType30MinBefore:
      not.fireDate = [not.fireDate mt_dateMinutesBefore:30];
      break;
    case ATEventAlertType1HBefore:
      not.fireDate = [not.fireDate mt_dateHoursBefore:1];
      break;
    case ATEventAlertType2HBefore:
      not.fireDate = [not.fireDate mt_dateHoursBefore:2];
      break;
    case ATEventAlertType1DayBefore:
      not.fireDate = [not.fireDate mt_dateDaysBefore:1];
      break;
    case ATEventAlertType2DaysBefore:
      not.fireDate = [not.fireDate mt_dateDaysBefore:2];
      break;
  }
  not.userInfo = @{ATEventURIKey:[self.objectID.URIRepresentation absoluteString]};
  return not;
}


-(void)removeExistingLocalNotifications{
  for (ATAlertNotification* not in self.alertNotifications) {
    [[UIApplication sharedApplication] cancelLocalNotification:not.notification];
    [not MR_deleteEntity];
  }
  self.alertNotifications = [NSSet set];
}

-(void)scheduleLocalNotificationForOccurenceStart:(NSDate*)eventStart{
  if ([self.alertNotifications count]) {
    [self removeExistingLocalNotifications]; // How to do it otherwise ?
  }
  if (self.firstAlertTypeValue != ATEventAlertTypeNone) {
    UILocalNotification* not = [self notificationWithDate:eventStart alertType:self.firstAlertTypeValue];
    ATAlertNotification *notLink = [ATAlertNotification MR_createInContext:self.managedObjectContext];
    notLink.notification = not;
    notLink.event = self;
    [self.alertNotificationsSet addObject:notLink];
    [[UIApplication sharedApplication] scheduleLocalNotification:not];
  }
  if (self.seccondAlertTypeValue != ATEventAlertTypeNone) {
    UILocalNotification* not = [self notificationWithDate:eventStart alertType:self.seccondAlertTypeValue];
    ATAlertNotification *notLink = [ATAlertNotification MR_createInContext:self.managedObjectContext];
    notLink.notification = not;
    notLink.event = self;
    [self.alertNotificationsSet addObject:notLink];
    [[UIApplication sharedApplication] scheduleLocalNotification:not];
  }
}

-(void)removeLocalNotificationsBeforeDelete{
  if ([self.alertNotifications count]) {
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