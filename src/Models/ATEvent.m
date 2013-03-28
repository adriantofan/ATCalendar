#import "ATEvent.h"
#import "ATOccurrenceCache.h"
#import "ATDailyRecurrence.h"
#import "ATWeeklyRecurrence.h"
#import "ATMonthlyRecurrence.h"
#import "ATYearlyRecurrence.h"

@interface ATEvent ()
@end


@implementation ATEvent
-(void)awakeFromInsert{
  [super awakeFromInsert];
  self.timeZone = [NSTimeZone defaultTimeZone];
}

-(NSString*)avilabilityDescription{
  if (self.busyValue) {
    return NSLocalizedString(@"Busy", @"Busy label");
  }else{
    return NSLocalizedString(@"Free", @"Free label");
  }
}

+ (NSString *)descriptionFor:(ATEventAlertType)alertType {
  NSString *text;
  switch (alertType) {
    case ATEventAlertTypeNone:
      text = NSLocalizedString(@"None", @"alert type");break;
    case ATEventAlertTypeAtTime:
      text = NSLocalizedString(@"At event time", @"alert type");break;
    case ATEventAlertType5MinBefore:
      text = NSLocalizedString(@"5 minutes before", @"alert type");break;
    case ATEventAlertType15MinBefore:
      text = NSLocalizedString(@"15 minutes before", @"alert type");break;
    case ATEventAlertType30MinBefore:
      text = NSLocalizedString(@"30 minutes before", @"alert type");break;
    case ATEventAlertType1HBefore:
      text = NSLocalizedString(@"1 hour before", @"alert type");break;
    case ATEventAlertType2HBefore:
      text = NSLocalizedString(@"2 hour before", @"alert type");break;
    case ATEventAlertType1DayBefore:
      text = NSLocalizedString(@"1 day before", @"alert type");break;
    case ATEventAlertType2DaysBefore:
      text = NSLocalizedString(@"2 days before", @"alert type");break;
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
  NSDate *offsetedStartDate = [self.startDate dateDaysAfter:days];
  NSDate *offsetedEndDate = [self.endDate dateDaysAfter:days];
  if (occurence == nil)
    return nil;
  if ([occurence isWithinSameDay:offsetedStartDate]) {
    return offsetedStartDate;
  }
  if ([occurence isBetweenDate:[offsetedStartDate startOfCurrentDay] andDate:[offsetedEndDate endOfCurrentDay]]) {
    return [occurence startOfCurrentDay];
  }
  return nil;
}

- (NSDate*)eventEndAtDate:(NSDate*)occurence offset:(NSInteger)days{
  NSDate *offsetedStartDate = [self.startDate dateDaysAfter:days];
  NSDate *offsetedEndDate = [self.endDate dateDaysAfter:days];
  if (occurence == nil)
    return nil;
  else
    if ([occurence isWithinSameDay:offsetedEndDate])
      return offsetedEndDate;
    else
      if ([occurence isBetweenDate:[offsetedStartDate startOfCurrentDay] andDate:[offsetedEndDate endOfCurrentDay]])
        return [occurence endOfCurrentDay];
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

- (void)updateSimpleOccurencesFrom:(NSDate *)fromDate to:(NSDate *)toDate inContext:(NSManagedObjectContext*)moc{
  if (self.recurence) {return; };
  NSArray* eventMatchingDates = [self matchingDates:fromDate to:toDate];
  for (NSDate *occurenceDate in eventMatchingDates) {
    ATOccurrenceCache *occurence = [ATOccurrenceCache MR_createInContext:moc];
    occurence.day = [occurenceDate startOfCurrentDay];
    occurence.startDate = [self eventStartAtDate:occurenceDate];
    occurence.occurrenceDate = self.startDate;
    occurence.endDate = [self eventEndAtDate:occurenceDate];
    occurence.event = self;
  }
}

- (NSArray*)matchingDates:(NSDate*)fromDate to:(NSDate*)endDate offset:(NSUInteger)days{
  if (!fromDate || !endDate) { return [NSArray array]; }
  
  if ([fromDate isAfter:endDate]) {
    NSDate *tmp = endDate;
    endDate = fromDate;
    fromDate = tmp;
  }
  NSDate* crtStartDate = [self.startDate dateDaysAfter:days];
  NSDate* crtEndDate = [self.endDate dateDaysAfter:days];
  if ([crtStartDate isBefore:fromDate] && [crtEndDate isBefore:fromDate])
    return [NSArray array];
  if ([crtStartDate isAfter:endDate] && [crtEndDate isAfter:endDate])
    return [NSArray array];
  NSDate* start,*end;
  if ([fromDate isBefore:crtStartDate]) {
    start = [crtStartDate startOfCurrentDay];
  }else{
    start = [fromDate startOfCurrentDay];
  }
  if ([endDate isAfter:crtEndDate]) {
    end = [crtEndDate startOfCurrentDay];
  }else{
    end = [endDate startOfCurrentDay];
  }
  return [NSDate datesCollectionFromDate:start untilDate:[end oneDayNext]];
}

- (NSArray*)matchingDates:(NSDate*)fromDate to:(NSDate*)endDate{
  return [self matchingDates:fromDate to:endDate offset:0];
}


@end