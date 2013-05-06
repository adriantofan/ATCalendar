//
//  ATCalendarUIConfig.h
//  ATCalendar
//
//  Created by Adrian Tofan on 04/04/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATCalendarUIConfig : NSObject
+(ATCalendarUIConfig*)sharedConfig;
+(void)setSharedConfig:(ATCalendarUIConfig*)otherConfig;

// if there is a grouped table view this is it's bg collor
@property (nonatomic,strong) UIColor* groupedTableViewBGCollor;

// if there is a detail label this is how it's collor is set
@property (nonatomic,strong) UIColor* tableViewCellDetailLabelCollor;

// event time label collor
@property (nonatomic,strong) UIColor* eventTimeLabelCollor;

// cell subtitle collor 
@property (nonatomic,strong) UIColor* cellSubtitleLabelCollor;

// cell text() collor
@property (nonatomic,strong) UIColor* cellTextLabelCollor;

// Where it is not disabled
@property (nonatomic,assign) UITableViewCellSelectionStyle tableViewCellSelectionStyle;
@end
