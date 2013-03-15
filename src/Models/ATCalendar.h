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

-(void)syncCachesForDate:(NSDate*)toDate;
-(ATTimeSpan*)timeSpanToSyncFrom:(NSDate*)fromDate to:(NSDate*)toDate;
-(NSArray*)dateArrayToSyncFrom:(NSDate*)fromDate to:(NSDate*)toDate;
-(void)clearOccurenceCache;
- (void)syncNonRecurringEventsFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end
