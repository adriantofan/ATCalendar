#import "ATYearlyRecurrence.h"
#import "NSBundle+ATCalendar.h"
#import "NSDate+MTDates.h"
#define MR_SHORTHAND
#import <MagicalRecord/MagicalRecord.h>

@interface ATYearlyRecurrence ()

// Private interface goes here.

@end


@implementation ATYearlyRecurrence
-(NSDate*)nextOccurenceAfter:(NSDate*)date{
  NSDate* next = [date mt_dateYearsAfter:1];
  if ([next mt_isBetweenDate:self.startDate andDate:self.endDate]) {
    return next;
  }
  return nil;
}

-(NSString*)reccurenceTypeDescription{
  return ATLocalizedString(@"yearly", @"Yearly reccurence type description");
}

@end
