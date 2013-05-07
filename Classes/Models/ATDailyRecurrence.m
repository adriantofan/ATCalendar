#import "ATDailyRecurrence.h"
#import "NSBundle+ATCalendar.h"
#import "NSDate+MTDates.h"

@interface ATDailyRecurrence ()

// Private interface goes here.

@end


@implementation ATDailyRecurrence

-(NSDate*)nextOccurenceAfter:(NSDate*)date{
  NSDate* next = [date mt_dateDaysAfter:1];
  if ([next mt_isBetweenDate:self.startDate andDate:self.endDate]) {
    return next;
  }
  return nil;
}
-(NSString*)reccurenceTypeDescription{
  return ATLocalizedString(@"daily", @"daily reccurence type description");
}
@end
