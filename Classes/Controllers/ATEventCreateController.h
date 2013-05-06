//
//  ATEventCreateController.h
//  ATCalendar
//
//  Created by Adrian Tofan on 19/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATEventEditBaseController.h"

@interface ATEventCreateController : ATEventEditBaseController
@property (strong, nonatomic) NSManagedObjectContext *sourceMoc;
@end