#import "ATYearlyRecurrence.h"


@interface ATYearlyRecurrence ()

// Private interface goes here.

@end


@implementation ATYearlyRecurrence
-(NSDate*)nextOccurenceAfter:(NSDate*)date{
  NSDate* next = [date dateYearsAfter:1];
  if ([next isBetweenDate:self.startDate andDate:self.endDate]) {
    return next;
  }
  return nil;
}

-(NSString*)reccurenceTypeDescription{
  return NSLocalizedString(@"Yearly", @"Yearly reccurence type description");
}

@end
