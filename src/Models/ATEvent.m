#import "ATEvent.h"
#import "ATOccurrenceCache.h"
#import "ATDailyRecurrence.h"
#import "ATWeeklyRecurrence.h"
#import "ATMonthlyRecurrence.h"
#import "ATYearlyRecurrence.h"
#import "ATEvent+LocalNotifications.h"
#import "NSBundle+ATCalendar.h"

@interface ATEvent ()
@end


@implementation ATEvent
-(void)awakeFromInsert{
  [super awakeFromInsert];
  self.timeZone = [NSTimeZone defaultTimeZone];
  self.firstAlertTypeValue = ATEventAlertTypeNone;
  self.seccondAlertTypeValue = ATEventAlertTypeNone;
}

-(NSString*)avilabilityDescription{
  if (self.busyValue) {
    return ATLocalizedString(@"Busy", @"Busy label");
  }else{
    return ATLocalizedString(@"Free", @"Free label");
  }
}

+ (NSString *)descriptionFor:(ATEventAlertType)alertType {
  NSString *text;
  switch (alertType) {
    case ATEventAlertTypeNone:
      text = ATLocalizedString(@"None", @"alert type");break;
    case ATEventAlertTypeAtTime:
      text = ATLocalizedString(@"At event time", @"alert type");break;
    case ATEventAlertType5MinBefore:
      text = ATLocalizedString(@"5 minutes before", @"alert type");break;
    case ATEventAlertType15MinBefore:
      text = ATLocalizedString(@"15 minutes before", @"alert type");break;
    case ATEventAlertType30MinBefore:
      text = ATLocalizedString(@"30 minutes before", @"alert type");break;
    case ATEventAlertType1HBefore:
      text = ATLocalizedString(@"1 hour before", @"alert type");break;
    case ATEventAlertType2HBefore:
      text = ATLocalizedString(@"2 hour before", @"alert type");break;
    case ATEventAlertType1DayBefore:
      text = ATLocalizedString(@"1 day before", @"alert type");break;
    case ATEventAlertType2DaysBefore:
      text = ATLocalizedString(@"2 days before", @"alert type");break;
  }
  return text;
}

-(NSString*)alertsDescription{
  NSString* text;
  if (self.firstAlertTypeValue != ATEventAlertTypeNone && self.seccondAlertTypeValue == ATEventAlertTypeNone ) {
    text = [NSString stringWithFormat:@"%@\n",
            [ATEvent descriptionFor:self.firstAlertTypeValue]];
    return text;
  }
  if (self.firstAlertTypeValue != ATEventAlertTypeNone && self.seccondAlertTypeValue != ATEventAlertTypeNone ) {
    text = [NSString stringWithFormat:@"%@\n%@\n",
            [ATEvent descriptionFor:self.firstAlertTypeValue],
            [ATEvent descriptionFor:self.seccondAlertTypeValue]];
    return text;
  }
  return @"";
}
-(BOOL)isRecurrent{
  return self.recurence && (self.recurence.typeValue != ATRecurrenceTypeNone);
}

-(void)changeRecurenceType:(ATRecurrenceType)type{
  if (self.recurence && (self.recurence.typeValue == type)) return;
  if (ATRecurrenceTypeNone == type) {
    [self.recurence MR_deleteInContext:self.managedObjectContext];
    self.recurence = nil;
    return;
  }
  NSDate* startDate;
  NSDate* endDate;
  if (self.recurence == nil) {
    startDate = [NSDate date];
    endDate = nil;
  }else{
    [self.recurence MR_deleteInContext:self.managedObjectContext];
    startDate = self.recurence.startDate;
    endDate = self.recurence.endDate;
  }
  ATRecurrence *reccurence = nil;
  switch (type) {
    case ATRecurrenceTypeNone:return;
    case ATRecurrenceTypeDay:
      reccurence = (ATRecurrence *)[ATDailyRecurrence MR_createInContext:self.managedObjectContext];
      break;
    case ATRecurrenceTypeWeek:
      reccurence = (ATRecurrence *)[ATWeeklyRecurrence MR_createInContext:self.managedObjectContext];
      break;
    case ATRecurrenceTypeMonth:
      reccurence = (ATRecurrence *)[ATMonthlyRecurrence MR_createInContext:self.managedObjectContext];
      break;
    case ATRecurrenceTypeYear:
      reccurence = (ATRecurrence *)[ATYearlyRecurrence MR_createInContext:self.managedObjectContext];
      break;
  }
  reccurence.typeValue = type;
  reccurence.startDate = startDate;
  reccurence.endDate = endDate;
  self.recurence = reccurence;
}

+ (NSArray*)nonRecurringEventsFrom:(NSDate*)fromDate to:(NSDate*)endDate{
  NSDate* start = fromDate?fromDate:[NSDate dateWithTimeIntervalSince1970:0];
  NSDate* end = endDate?endDate:[NSDate dateWithTimeIntervalSince1970:MAXFLOAT];
  //TODO: optimize this ?
  NSPredicate *predicate =
   [NSPredicate predicateWithFormat:@"(((%@ <= endDate) AND (endDate <= %@))\
                                      OR((%@ <= startDate) AND (startDate <= %@))\
                                      OR  ((startDate <= %@  ) AND ( %@ <= endDate)))\
                                     AND (recurence == nil)"
                      argumentArray:@[start,end,start,end,start,end]];
  
  NSArray * events = [ATEvent MR_findAllSortedBy:@"startDate"
                                       ascending:YES
                                   withPredicate:predicate];
  return events;
}


- (NSDate*)eventStartAtDate:(NSDate*)occurence offset:(NSInteger)days{
  NSDate *offsetedStartDate = [self.startDate mt_dateDaysAfter:days];
  NSDate *offsetedEndDate = [self.endDate mt_dateDaysAfter:days];
  if (occurence == nil)
    return nil;
  if ([occurence mt_isWithinSameDay:offsetedStartDate]) {
    return offsetedStartDate;
  }
  if ([occurence mt_isBetweenDate:[offsetedStartDate mt_startOfCurrentDay] andDate:[offsetedEndDate mt_endOfCurrentDay]]) {
    return [occurence mt_startOfCurrentDay];
  }
  return nil;
}

- (NSDate*)eventEndAtDate:(NSDate*)occurence offset:(NSInteger)days{
  NSDate *offsetedStartDate = [self.startDate mt_dateDaysAfter:days];
  NSDate *offsetedEndDate = [self.endDate mt_dateDaysAfter:days];
  if (occurence == nil)
    return nil;
  else
    if ([occurence mt_isWithinSameDay:offsetedEndDate])
      return offsetedEndDate;
    else
      if ([occurence mt_isBetweenDate:[offsetedStartDate mt_startOfCurrentDay] andDate:[offsetedEndDate mt_endOfCurrentDay]])
        return [occurence mt_endOfCurrentDay];
  return nil;
}


- (NSDate*)eventStartAtDate:(NSDate*)occurence{
  return [self eventStartAtDate:occurence offset:0];
}

- (NSDate*)eventEndAtDate:(NSDate*)occurence{
  return [self eventEndAtDate:occurence offset:0];
}
@end

@implementation ATEvent (ATOccurenceCache)
-(void)saveToPersistentStoreAndUpdateCaches{
  [self.managedObjectContext MR_saveToPersistentStoreAndWait];
  [ATOccurrenceCache updateCachesAfterEventChange:self];
  [self.managedObjectContext MR_saveToPersistentStoreAndWait];
  [self updateLocalNotificationsAfterChange];
  [self.managedObjectContext MR_saveToPersistentStoreAndWait];
}
- (void)updateSimpleOccurencesFrom:(NSDate *)fromDate to:(NSDate *)toDate inContext:(NSManagedObjectContext*)moc{
  if (self.recurence) {return; };
  NSArray* eventMatchingDates = [self matchingDates:fromDate to:toDate];
  for (NSDate *occurenceDate in eventMatchingDates) {
    ATOccurrenceCache *occurence = [ATOccurrenceCache MR_createInContext:moc];
    occurence.day = [occurenceDate mt_startOfCurrentDay];
    occurence.startDate = [self eventStartAtDate:occurenceDate];
    occurence.occurrenceDate = self.startDate;
    occurence.endDate = [self eventEndAtDate:occurenceDate];
    occurence.event = self;
  }
}

- (NSArray*)matchingDates:(NSDate*)fromDate to:(NSDate*)endDate offset:(NSUInteger)days{
  if (!fromDate || !endDate) { return [NSArray array]; }
  
  if ([fromDate mt_isAfter:endDate]) {
    NSDate *tmp = endDate;
    endDate = fromDate;
    fromDate = tmp;
  }
  NSDate* crtStartDate = [self.startDate mt_dateDaysAfter:days];
  NSDate* crtEndDate = [self.endDate mt_dateDaysAfter:days];
  if ([crtStartDate mt_isBefore:fromDate] && [crtEndDate mt_isBefore:fromDate])
    return [NSArray array];
  if ([crtStartDate mt_isAfter:endDate] && [crtEndDate mt_isAfter:endDate])
    return [NSArray array];
  NSDate* start,*end;
  if ([fromDate mt_isBefore:crtStartDate]) {
    start = [crtStartDate mt_startOfCurrentDay];
  }else{
    start = [fromDate mt_startOfCurrentDay];
  }
  if ([endDate mt_isAfter:crtEndDate]) {
    end = [crtEndDate mt_startOfCurrentDay];
  }else{
    end = [endDate mt_startOfCurrentDay];
  }
  return [NSDate mt_datesCollectionFromDate:start untilDate:[end mt_oneDayNext]];
}

- (NSArray*)matchingDates:(NSDate*)fromDate to:(NSDate*)endDate{
  return [self matchingDates:fromDate to:endDate offset:0];
}


@end