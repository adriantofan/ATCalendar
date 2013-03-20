//
//  ATDurationEditController.h
//  ATCalendar
//
//  Created by Adrian Tofan on 19/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATDurationEditController;

@protocol ATDurationEditControllerDelegate
-(void)durationEditController:(ATDurationEditController*)ctrl
            didFinishWithSave:(BOOL)saveOrCancel;
@end


@interface ATDurationEditController : UITableViewController
@property (nonatomic,strong,readwrite) NSDate *startDate;
@property (nonatomic,strong,readwrite) NSDate *endDate;
@property (nonatomic,readwrite) BOOL allDay;

@property (nonatomic,weak) id <ATDurationEditControllerDelegate> delegate;
@end
