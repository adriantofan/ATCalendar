//
//  ATEventEditController.m
//  ATCalendar
//
//  Created by Adrian Tofan on 13/11/12.
//  Copyright (c) 2012 Adrian Tofan. All rights reserved.
//

#import "ATEventEditController.h"
#import <QuartzCore/QuartzCore.h>
#import "ATOccurrenceCache.h"

@interface ATEventEditController (){
  
  IBOutlet UITextField *titleTextField_;
  IBOutlet UITextField *placeTextField_;
}
@property (nonatomic,readwrite) NSManagedObjectContext* editingMoc;
@property (nonatomic,strong,readwrite) ATEvent* event;
@property (nonatomic) UIView* footerView;
@end

@implementation ATEventEditController
@synthesize footerView = footerView_;

-(void)viewDidLoad{
  [super viewDidLoad];
  self.editingMoc = [NSManagedObjectContext MR_contextWithParent:self.sourceEvent.managedObjectContext];
  self.event = [self.sourceEvent MR_inContext:self.editingMoc];
  [self updateViewWithEvent:self.event];
  self.tableView.tableFooterView = self.footerView;
}
-(UIView*)footerView{
  if (nil == footerView_) {
    footerView_ = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 55.0)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10.0, 5.0, 300.0, 45.0);
    btn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [footerView_ addSubview:btn];
    [btn setTitle:NSLocalizedString(@"Delete", @"") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
  }
  return footerView_;
}

-(IBAction)deleteButtonAction{
  NSPredicate* eventPredicate = [NSPredicate predicateWithFormat:@"event == %@"
                                                   argumentArray:@[self.event]];
  [ATOccurrenceCache MR_deleteAllMatchingPredicate:eventPredicate inContext:self.editingMoc];
  [self.event MR_deleteInContext:self.editingMoc];
  [self.delegate eventEditBaseController:self
                        didFinishEditing:TRUE];
}

@end
