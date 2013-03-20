//
//  ATEventEditController.m
//  ATCalendar
//
//  Created by Adrian Tofan on 13/11/12.
//  Copyright (c) 2012 Adrian Tofan. All rights reserved.
//

#import "ATEventEditController.h"

@interface ATEventEditController (){
  
  IBOutlet UITextField *titleTextField_;
  IBOutlet UITextField *placeTextField_;
}
@property (nonatomic,readwrite) NSManagedObjectContext* editingMoc;
@property (nonatomic,strong,readwrite) ATEvent* event;
@end

@implementation ATEventEditController

-(void)viewDidLoad{
  [super viewDidLoad];
  self.editingMoc = [NSManagedObjectContext MR_contextWithParent:self.sourceEvent.managedObjectContext];
  self.event = [self.sourceEvent MR_inContext:self.editingMoc];
  [self updateViewWithEvent:self.event];
}

@end
