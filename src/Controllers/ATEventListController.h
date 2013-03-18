//
//  ATPlanningController.h
//  ATCalendar
//
//  Created by Adrian Tofan on 13/11/12.
//  Copyright (c) 2012 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATEventEditBaseController.h"

@interface ATEventListController : UITableViewController<NSFetchedResultsControllerDelegate,ATEventEditBaseControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *moc;
@end
