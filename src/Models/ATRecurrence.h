#import "_ATRecurrence.h"

typedef enum {
  ATRecurrenceTypeNone       = 0,
  ATRecurrenceTypeDay       = 1,
  ATRecurrenceTypeWeek      = 2,
  ATRecurrenceTypeMonth     = 3,
  ATRecurrenceTypeYear      = 4,
} ATRecurrenceType;

@interface ATRecurrence : _ATRecurrence {}
// returns all Reccurrences having effect within |fromDate| to |endDate|
+ (NSArray*)recurrencesFrom:(NSDate*)fromDate to:(NSDate*)endDate;

// Returns next occurence of the event after date if any
// Method to subclass
-(NSDate*)nextOccurenceAfter:(NSDate*)date;

-(NSString*)reccurenceTypeDescription;
@end

@interface ATRecurrence (ATOccurenceCache)
// Returns the intersection of the fromDate - endData with the event occurences
// The dictionary :
//  key  : (NSNumber) offset from event start of the current occurence
//  value: (NSArray) occurence dates
- (NSDictionary*)matchingDateSets:(NSDate*)fromDate to:(NSDate*)endDate;

// returns the dates between |fromDate| to |endDate| of a potential start of
// event match taking in consideration the reccurence and event aduration.
- (NSArray*)matchingStartDates:(NSDate*)fromDate to:(NSDate*)endDate;

// Update reccurence day cache between dates
- (void)updateOccurencesFrom:(NSDate *)fromDate to:(NSDate *)toDate inContext:(NSManagedObjectContext*)moc;
@end
