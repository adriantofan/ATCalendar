//
//  ATEventEditController.h
//  ATCalendar
//
//  Created by Adrian Tofan on 13/11/12.
//  Copyright (c) 2012 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATEventEditBaseController.h"
@interface ATEventEditController : ATEventEditBaseController
@property (nonatomic,readwrite) ATEvent* sourceEvent;
@end
