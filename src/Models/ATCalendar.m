//
//  ATCalendar.m
//  ATCalendar
//
//  Created by Adrian Tofan on 14/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATCalendar.h"
#import "ATGlobalPropertyes.h"
#import "NSDate+MTDates.h"
#import "ATOccurrenceCache.h"
#import "ATEvent.h"
#import "ATTimeSpan.h"
#import "ATRecurrence.h"
#import "ATAlertNotification.h"
#import "ATEvent+LocalNotifications.h"

const int kMaxNotifications = 30;

@implementation ATCalendar
-(void)handleLocalNotification:(UILocalNotification*)notification{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                  message:notification.alertBody
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
}


static ATCalendar* ___sharedInstance;
-(NSInteger)maxSystemNotificationsCount{
  return kMaxNotifications;
}

-(void)updateAlarmLocalNotificationsInContext:(NSManagedObjectContext*)moc{
  NSArray* current =
    [ATOccurrenceCache firstOccurenceCacheOfEventWithAlarmAfter:self.currentSyncSpan.start
                                                    inContext:moc
                                                        limit:kMaxNotifications];
  
  NSArray* actives = [ATAlertNotification MR_findAllInContext:moc];
  [self updateAlarmLocalNotificationsForEventOccurences:current
                                 andActiveNotifications:actives];
}

-(void)updateAlarmLocalNotificationsForEventOccurences:(NSArray*)current
                                andActiveNotifications:(NSArray*)actives{
  NSArray* currentEvents = [current map:^id(ATOccurrenceCache* obj) {
    return [obj event];
  }];
  
  NSArray* activeEvents = [[actives map:^id(ATAlertNotification* obj) {
    return [obj event];}]
                           reduce:^id(NSMutableArray* memo, id obj) {
                             if (![memo containsObject:obj]) [memo addObject:obj];
                             return memo;
                           }
                           withInitialMemo:[NSMutableArray new]];
  
  // events to delete : what's active and not in current (active - current)
  NSArray* toDelete = [activeEvents filter:^BOOL(id obj) {
    return ![currentEvents containsObject:obj];
  }];
  [toDelete enumerateObjectsUsingBlock:^(ATEvent* e, NSUInteger idx, BOOL *stop) {
    [e removeExistingLocalNotifications];
  }];
  
  // events to add : what's current and not active (current - active)
  NSArray* toAdd = [currentEvents filter:^BOOL(id obj) {
    return ![activeEvents containsObject:obj];
  }];
  [toAdd enumerateObjectsUsingBlock:^(ATEvent* e, NSUInteger idx, BOOL *stop) {
    [current enumerateObjectsUsingBlock:^(ATOccurrenceCache* o, NSUInteger idx, BOOL *stop) {
      if (o.event == e) {
        [e scheduleLocalNotificationForOccurenceStart:o.occurrenceDate];
        *stop = TRUE;
      }
    }];
  }];  
}


+(ATCalendar*)sharedInstance{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    ___sharedInstance = [[ATCalendar alloc] init];
  });
  return ___sharedInstance;
}

-(void)syncCachesIfNeeded:(NSDate*)toDate inContext:(NSManagedObjectContext*)moc{
  NSDate *lastCachedDay = [ATGlobalPropertyes lastCachedDay];
  NSDate * from,* to;
  if ([lastCachedDay isAfter:toDate]) {
    [self clearOccurenceCache];
    from = nil;
  }
  from = [lastCachedDay startOfCurrentDay];
  to = [toDate endOfCurrentDay];
  ATTimeSpan* syncSpan = [self timeSpanToSyncFrom:from to:to];
  [self syncNonRecurringEventsFrom:syncSpan.start to:syncSpan.end inContext:moc];
  [self syncRecurringEventsFrom:syncSpan.start to:syncSpan.end inContext:moc];
  [ATGlobalPropertyes setLastCachedDay:toDate];
}

-(ATTimeSpan*)currentSyncSpan{
  return [self timeSpanToSyncFrom:nil to:[ATGlobalPropertyes lastCachedDay]];
}

@end

@implementation ATCalendar(ATOccurenceCache)
- (void)clearOccurenceCache{
  [ATOccurrenceCache MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@""]];
}


- (void)syncNonRecurringEventsFrom:(NSDate *)fromDate to:(NSDate *)toDate inContext:(NSManagedObjectContext*)moc{
  NSArray* nonRecuringEvents = [ATEvent nonRecurringEventsFrom:fromDate
                                                            to:toDate];
  for (ATEvent *event in nonRecuringEvents) {
    [event updateSimpleOccurencesFrom:fromDate to:toDate inContext:moc];
  }
}



-(void)syncRecurringEventsFrom:(NSDate *)fromDate to:(NSDate *)toDate inContext:(NSManagedObjectContext*)moc{
  NSArray* reccurences = [ATRecurrence recurrencesFrom:fromDate
                                                    to:toDate];
  for (ATRecurrence *reccurence in reccurences) {
    [reccurence updateOccurencesFrom:fromDate to:toDate inContext:moc];
  }
}

-(ATTimeSpan*)timeSpanToSyncFrom:(NSDate*)fromDate to:(NSDate*)toDate{
  if ((nil == fromDate) && (toDate == nil)){
    return nil;
  }else
    if (nil == fromDate) {
      return [ATTimeSpan timeSpanFrom:[[toDate oneYearPrevious] startOfCurrentDay]
                                   to:[[[toDate oneYearNext] oneYearNext] endOfCurrentDay]];
    }else
      if ([fromDate isWithinSameDay:toDate]) {
        return nil;
      }else{
        return [ATTimeSpan timeSpanFrom: [[fromDate dateDaysAfter:1] startOfCurrentDay]
                                     to:[toDate endOfCurrentDay]];
      }
  
}

-(NSArray*)dateArrayToSyncFrom:(NSDate*)fromDate to:(NSDate*)toDate{
  ATTimeSpan* timeSpan = [self timeSpanToSyncFrom:fromDate to:toDate];
  if ([timeSpan.start isWithinSameDay:timeSpan.end]) {
    return @[[timeSpan.start startOfCurrentDay]];
  }else
    return [NSDate datesCollectionFromDate:[[timeSpan.start oneDayPrevious] startOfCurrentDay]
                                 untilDate:[timeSpan.end startOfCurrentDay]];
}

@end


