#import "ATMonthlyRecurrence.h"


@interface ATMonthlyRecurrence ()

// Private interface goes here.

@end


@implementation ATMonthlyRecurrence
-(NSDate*)nextOccurenceAfter:(NSDate*)date{
  NSDate* next = [date dateMonthsAfter:1];
  if ([next isBetweenDate:self.startDate andDate:self.endDate]) {
    return next;
  }
  return nil;
}
// Custom logic goes here.
-(NSString*)reccurenceTypeDescription{
  return NSLocalizedString(@"monthly", @"Monthly reccurence type description");
}
@end
