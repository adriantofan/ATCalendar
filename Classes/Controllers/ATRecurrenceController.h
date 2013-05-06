//
//  ATRepeatController.h
//  ATCalendar
//
//  Created by Adrian Tofan on 21/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATRecurrence.h"
typedef void(^ATRecurrenceControllerReturn)(BOOL saveOrCancel);
@interface ATRecurrenceController : UITableViewController
@property (nonatomic,assign) ATRecurrenceType currentReccurrence;
@property (nonatomic,copy) ATRecurrenceControllerReturn endBlock;
@end
