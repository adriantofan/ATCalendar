//
//  NSBundle+ATCalendar.m
//  ATCalendar
//
//  Created by Adrian Tofan on 06/05/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "NSBundle+ATCalendar.h"

static NSBundle *resourceBundle__;

@implementation NSBundle (ATCalendar)
+(NSBundle*)at_calendar_defaultBundle{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSString *resourceBundlePath = [[NSBundle mainBundle] pathForResource:@"ATCalendar" ofType:@"bundle"];
    resourceBundle__ = [NSBundle bundleWithPath:resourceBundlePath];
  });
  return resourceBundle__;
}
@end
