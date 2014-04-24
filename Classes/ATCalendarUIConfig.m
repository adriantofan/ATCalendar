//
//  ATCalendarUIConfig.m
//  ATCalendar
//
//  Created by Adrian Tofan on 04/04/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATCalendarUIConfig.h"
static ATCalendarUIConfig* __sharedConfig;

@implementation ATCalendarUIConfig

+(ATCalendarUIConfig*)sharedConfig{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (!__sharedConfig) {
      __sharedConfig = [[ATCalendarUIConfig alloc] init];
      [__sharedConfig setUP];
    }
  });
  return __sharedConfig;
}

+(void)setSharedConfig:(ATCalendarUIConfig*)otherConfig{
  __sharedConfig = otherConfig;
}
-(void)setUP{
  self.groupedTableViewBGCollor = [UIColor clearColor];
  self.tableViewCellDetailLabelCollor = [UIColor darkGrayColor];
  self.eventTimeLabelCollor = [UIColor colorWithRed:0x6c/255.0 green:0x72/255.0 blue:0x7c/255.0 alpha:1.0];
  self.cellSubtitleLabelCollor = [UIColor lightGrayColor];
  self.cellTextLabelCollor = [UIColor colorWithRed:0.200 green:0.310 blue:0.510 alpha:1.000];
  self.tableViewCellSelectionStyle = UITableViewCellSelectionStyleGray;
}
@end
