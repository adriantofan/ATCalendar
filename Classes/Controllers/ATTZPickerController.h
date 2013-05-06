//
//  ATTZPickerController.h
//  ATCalendar
//
//  Created by Adrian Tofan on 28/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ATTZPickerControllerReturn)(BOOL saveOrCancel);

@interface ATTZPickerController : UITableViewController<UISearchBarDelegate>
@property (nonatomic,copy) ATTZPickerControllerReturn endBlock;
@property (nonatomic) NSTimeZone* timeZone;

@end
