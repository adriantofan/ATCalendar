//
//  ATCalendar.h
//  ATCalendar
//
//  Created by Adrian Tofan on 14/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATTimeSpan;

@interface ATCalendar : NSObject

+(ATCalendar*)sharedInstance;

-(NSInteger)maxSystemNotificationsCount;
// Checks last  sync date against toDate and syncs daycache
-(void)syncCachesIfNeeded:(NSDate*)toDate inContext:(NSManagedObjectContext*)moc;
// Returns current expected sync span
-(ATTimeSpan*)currentSyncSpan;
-(void)updateAlarmLocalNotificationsInContext:(NSManagedObjectContext*)moc;
-(void)handleLocalNotification:(UILocalNotification*)notification;
@end


// Used internaly to manage Occurenche cache
@interface ATCalendar(ATOccurenceCache)
// Given a last sync date and a target date computes the sync time span
-(ATTimeSpan*)timeSpanToSyncFrom:(NSDate*)fromDate to:(NSDate*)toDate;
// Syncs all non recuring events between dates
- (void)syncNonRecurringEventsFrom:(NSDate *)fromDate to:(NSDate *)toDate inContext:(NSManagedObjectContext*)moc;
// Syncs all recuring events between dates
-(void)syncRecurringEventsFrom:(NSDate *)fromDate to:(NSDate *)toDate inContext:(NSManagedObjectContext*)moc;
// clears occurence caches
- (void)clearOccurenceCache;
// returns a list of days to sync spaning fromDate - toDate
-(NSArray*)dateArrayToSyncFrom:(NSDate*)fromDate to:(NSDate*)toDate;

// current array of ATOccurrenceCache / actives array of ATAlertNotification
-(void)updateAlarmLocalNotificationsForEventOccurences:(NSArray*)current
                                andActiveNotifications:(NSArray*)actives;

@end