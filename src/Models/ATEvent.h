#import "_ATEvent.h"

@interface ATEvent : _ATEvent {}

// returns all the events having effect within |fromDate| to |endDate|
+ (NSArray*)allEventsFrom:(NSDate*)fromDate to:(NSDate*)endDate;
// returns the dates between |fromDate| to |endDate| when the event matches
- (NSArray*)matchingDates:(NSDate*)fromDate to:(NSDate*)endDate;
// returns a precise ending date assuming that |occurence| is in event
- (NSDate*)endDateForDate:(NSDate*)occurence;
// returns a precise starting date assuming that |occurence| is in event
- (NSDate*)startDateForDate:(NSDate*)occurence;
// updates event's ocurence cache between |fromDate| to |endDate| (inclusive)
- (void)updateOccurencesFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end
