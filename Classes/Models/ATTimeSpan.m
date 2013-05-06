//
//  ATTimeSpan.m
//  ATCalendar
//
//  Created by Adrian Tofan on 15/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATTimeSpan.h"

@implementation ATTimeSpan
@synthesize start = start_, end = end_;

-(id)initFrom:(NSDate*)start to:(NSDate*)end{
  if (self = [super init]) {
    start_ = start;
    end_ = end;
  }
  return self;
}

+(ATTimeSpan*)timeSpanFrom:(NSDate*)start to:(NSDate*)end{
  return [[ATTimeSpan alloc] initFrom:start to:end];
}
@end
