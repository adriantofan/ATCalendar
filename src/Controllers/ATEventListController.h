//
//  ATPlanningController.h
//  ATCalendar
//
//  Created by Adrian Tofan on 13/11/12.
//  Copyright (c) 2012 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATEventEditBaseController.h"
@class ATOccurrenceCache;
@interface ATEventListController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate,ATEventEditBaseControllerDelegate, UISearchDisplayDelegate>
@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (nonatomic) UITableView* tableView;

@property (nonatomic,strong) NSString* searchResultsEventCellId;
@property (nonatomic,strong) NSString* eventCellId;
@property (nonatomic,assign) Class searchResultsEventCellClass;
@property (nonatomic,assign) Class eventCellClass;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *sFetchedResultsController;

- (void)configureCell:(UITableViewCell *)cell forObject:(ATOccurrenceCache*)object;

@end
