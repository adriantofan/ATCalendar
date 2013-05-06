//
//  ATAvilabilityController.h
//  ATCalendar
//
//  Created by Adrian Tofan on 27/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ATAvilabilityControllerReturn)(BOOL saveOrCancel);

@interface ATAvilabilityController : UITableViewController
@property (nonatomic,copy) ATAvilabilityControllerReturn endBlock;
@property (nonatomic,assign) BOOL busy;
@end
