//
//  ATEndRecurrenceController.h
//  ATCalendar
//
//  Created by Adrian Tofan on 21/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ATEndRecurrenceControllerReturn)(BOOL saveOrCancel);


@interface ATEndRecurrenceController : UITableViewController
@property (nonatomic,copy) ATEndRecurrenceControllerReturn endBlock;
@property (nonatomic) NSDate *minimumDate;
@property (nonatomic) NSDate *endDate;
@end
