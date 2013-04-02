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
#import "ATEvent+LocalNotifications.h"
#import "ATCalendar.h"

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
  self.title = NSLocalizedString(@"Edit", @"Event edit controller title");
}
-(UIView*)footerView{
  if (nil == footerView_) {
    footerView_ = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 55.0)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10.0, 5.0, 300.0, 45.0);
    btn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [footerView_ addSubview:btn];
    [btn setTitle:NSLocalizedString(@"Delete", @"") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  return footerView_;
}
-(void)deleteCurrentEventAndNotifyDelegate{
  BOOL sholdRemoveLocalNotifications = self.event.firstAlertNotification || self.event.seccondAlertNotification;
  
  if (sholdRemoveLocalNotifications) [self.event removeExistingLocalNotifications];
  NSPredicate* eventPredicate = [NSPredicate predicateWithFormat:@"event == %@"
                                                   argumentArray:@[self.event]];
  [ATOccurrenceCache MR_deleteAllMatchingPredicate:eventPredicate inContext:self.editingMoc];
  [self.event MR_deleteInContext:self.editingMoc];
  if (sholdRemoveLocalNotifications)
    [[ATCalendar sharedInstance] updateAlarmLocalNotificationsInContext:self.event.managedObjectContext];
  [self.delegate eventEditBaseController:self
                        didFinishEditing:TRUE];
}
-(IBAction)deleteButtonAction:(UIButton*)sender{
  if (self.event.isRecurrent) {
    UIActionSheet *a = [[UIActionSheet alloc]
                        initWithTitle:NSLocalizedString(@"This event is recurrent", @"")
                        delegate:self
                        cancelButtonTitle:NSLocalizedString(@"Cancel",@"")
                        destructiveButtonTitle:NSLocalizedString(@"Delete all occurences",@"")
                        otherButtonTitles:nil];
    [a showFromRect:sender.frame
             inView:self.view
           animated:YES];
  }else{
    [self deleteCurrentEventAndNotifyDelegate];
  }
}

#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
      [self deleteCurrentEventAndNotifyDelegate];
    }
}

@end
