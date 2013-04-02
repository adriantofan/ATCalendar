//
//  ATPlanningController.h
//  ATCalendar
//
//  Created by Adrian Tofan on 13/11/12.
//  Copyright (c) 2012 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATEventEditBaseController.h"

@interface ATEventListController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate,ATEventEditBaseControllerDelegate, UISearchDisplayDelegate>
@property (strong, nonatomic) NSManagedObjectContext *moc;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end
