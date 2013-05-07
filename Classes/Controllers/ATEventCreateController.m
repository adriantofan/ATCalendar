//
//  ATEventCreateController.m
//  ATCalendar
//
//  Created by Adrian Tofan on 19/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATEventCreateController.h"
#import "NSBundle+ATCalendar.h"
#import "CoreData+MagicalRecord.h"


@interface ATEventCreateController ()

@property (nonatomic,readwrite) NSManagedObjectContext* editingMoc;
@property (nonatomic,readwrite) ATEvent* event;
@end

@implementation ATEventCreateController


- (void)viewDidLoad
{
  [super viewDidLoad];
  self.editingMoc = [NSManagedObjectContext MR_contextWithParent:self.sourceMoc];
  self.event = [ATEvent MR_createInContext:self.editingMoc];
  self.event.summary = @"";
  self.event.startDate = [NSDate date];
  self.event.endDate = [NSDate date];
  [self updateViewWithEvent:self.event];
  self.title = ATLocalizedString(@"Add event", @"Event add controller title");

}

- (void)didReceiveMemoryWarning{
  [super didReceiveMemoryWarning];
}

@end
