//
//  ATEventEditBaseController.h
//  ATCalendar
//
//  Created by Adrian Tofan on 19/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATEvent.h"

@class ATEventEditBaseController;
@protocol ATEventEditBaseControllerDelegate <NSObject>
-(void) eventEditBaseController:(ATEventEditBaseController*)controller
               didFinishEditing:(BOOL)successOrCancel;
@end

@interface ATEventEditBaseController : UITableViewController
@property (nonatomic,readonly) ATEvent* event;
@property (nonatomic,readonly) NSManagedObjectContext* editingMoc;
@property (nonatomic,weak) id <ATEventEditBaseControllerDelegate> delegate;
@end
