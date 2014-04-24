//
//  ATEventTimeEditCell.m
//  ATCalendar
//
//  Created by Adrian Tofan on 19/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATEventTimeEditCell.h"
#import "ATCalendarUIConfig.h"

@implementation ATEventTimeEditCell
+(CGFloat)height{
  return 72.0;
}
-(void)awakeFromNib{
  [super awakeFromNib];
  UIColor* c = [[ATCalendarUIConfig sharedConfig] tableViewCellDetailLabelCollor];
  self.startDateLabel.textColor = c;
  self.endDateLabel.textColor = c;
  self.timeZoneLabel.textColor = c;
}

@end
