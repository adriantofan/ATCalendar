#import "_ATEvent.h"

@interface ATEvent : _ATEvent {}

+ (NSArray*)allEventsFrom:(NSDate*)fromDate to:(NSDate*)endDate;

- (NSArray*)matchingDates:(NSDate*)fromDate to:(NSDate*)endDate;
- (NSDate*)endDateForDate:(NSDate*)occurence;
@end
