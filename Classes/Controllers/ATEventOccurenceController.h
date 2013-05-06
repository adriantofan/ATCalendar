//
//  ATEventController.h
//  ATCalendar
//
//  Created by Adrian Tofan on 13/11/12.
//  Copyright (c) 2012 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATEventEditBaseController.h"
#import "ATOccurrenceCache.h"

@interface ATEventOccurenceController : UITableViewController<ATEventEditBaseControllerDelegate>
@property (nonatomic,strong,readwrite) ATOccurrenceCache* eventOccurence;
@end
