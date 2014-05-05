#import "_ATEvent.h"
#import "ATRecurrence.h"
typedef enum{
  ATEventAlertTypeNone        =   0,
  ATEventAlertTypeAtTime      =   10,
  ATEventAlertType5MinBefore  =   20,
  ATEventAlertType15MinBefore =   30,
  ATEventAlertType30MinBefore =   40,
  ATEventAlertType1HBefore    =   50,
  ATEventAlertType2HBefore    =   60,
  ATEventAlertType1DayBefore  =   70,
  ATEventAlertType2DaysBefore =   80,
  ATEventAlertType2WeeksBefore=   90,
} ATEventAlertType;

@interface ATEvent : _ATEvent {}

///

/// description
+ (NSString *)descriptionFor:(ATEventAlertType)alertType;
-(NSString*)avilabilityDescription;
-(NSString*)alertsDescription;

-(BOOL)isRecurrent;
-(void)changeRecurenceType:(ATRecurrenceType)type;
// returns all the non recurring events having effect within |fromDate| to |endDate|
+ (NSArray*)nonRecurringEventsFrom:(NSDate*)fromDate to:(NSDate*)endDate;
// returns a precise ending date assuming that |occurence| is in event
- (NSDate*)eventEndAtDate:(NSDate*)occurence;
// returns a precise starting date assuming that |occurence| is in event
- (NSDate*)eventStartAtDate:(NSDate*)occurence;
// Same as eventStartAtDate: with startDate offseted with |days|
- (NSDate*)eventStartAtDate:(NSDate*)occurence offset:(NSInteger)days;
// Same as eventEndAtDate: with startDate offseted with |days|
- (NSDate*)eventEndAtDate:(NSDate*)occurence offset:(NSInteger)days;
@end

@interface ATEvent (ATOccurenceCache)
-(void)saveToPersistentStoreAndUpdateCaches;

// updates event's ocurence cache between |fromDate| to |endDate| (inclusive)
// Should be used with simple occurences
- (void)updateSimpleOccurencesFrom:(NSDate *)fromDate to:(NSDate *)toDate inContext:(NSManagedObjectContext*)moc;

// returns the dates between |fromDate| to |endDate| when the event matches
- (NSArray*)matchingDates:(NSDate*)fromDate to:(NSDate*)endDate;
// returns the dates between |fromDate+days| to |endDate+days| when the event matches
- (NSArray*)matchingDates:(NSDate*)fromDate to:(NSDate*)endDate offset:(NSUInteger)days;
@end