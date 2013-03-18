//
//  ATEventController.h
//  ATCalendar
//
//  Created by Adrian Tofan on 13/11/12.
//  Copyright (c) 2012 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATEventEditBaseController.h"
#import "ATEvent.h"

@interface ATEventController : UITableViewController<ATEventEditBaseControllerDelegate>
@property (nonatomic,strong,readwrite) ATEvent* event;
@end
