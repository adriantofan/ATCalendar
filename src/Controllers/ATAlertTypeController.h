//
//  ATAlertTypeController.h
//  ATCalendar
//
//  Created by Adrian Tofan on 26/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATEvent.h"

typedef void(^ATAlertTypeControllerReturn)(BOOL saveOrCancel);
@interface ATAlertTypeController : UITableViewController
@property (nonatomic,copy) ATAlertTypeControllerReturn endBlock;
@property (nonatomic,assign) ATEventAlertType type;

@end
