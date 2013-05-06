//
//  NSBundle+ATCalendar.h
//  ATCalendar
//
//  Created by Adrian Tofan on 06/05/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <Foundation/Foundation.h>
// this is not a public file. Do not use it outside project

@interface NSBundle (ATCalendar) 
+(NSBundle*)at_calendar_defaultBundle;
@end

#define ATLocalizedString(key, comment) \
  [[NSBundle at_calendar_defaultBundle] localizedStringForKey:(key) value:@"" table:nil]
