#import "ATMonthlyRecurrence.h"
#import "NSBundle+ATCalendar.h"
#import "NSDate+MTDates.h"

@interface ATMonthlyRecurrence ()

// Private interface goes here.

@end


@implementation ATMonthlyRecurrence
-(NSDate*)nextOccurenceAfter:(NSDate*)date{
  NSDate* next = [date mt_dateMonthsAfter:1];
  if ([next mt_isBetweenDate:self.startDate andDate:self.endDate]) {
    return next;
  }
  return nil;
}
// Custom logic goes here.
-(NSString*)reccurenceTypeDescription{
  return ATLocalizedString(@"monthly", @"Monthly reccurence type description");
}
@end
