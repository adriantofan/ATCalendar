//
//  ATEventController.m
//  ATCalendar
//
//  Created by Adrian Tofan on 13/11/12.
//  Copyright (c) 2012 Adrian Tofan. All rights reserved.
//

#import "ATEventOccurenceController.h"
#import "ATEventEditController.h"
#import "ATEventDetailCell.h"
#import "ATEvent.h"
NSString * const ATEventDetailCellId = @"ATEventDetailCell";
@interface ATEventOccurenceController ()

@end

@implementation ATEventOccurenceController{
  ATEvent* tmpEvent_;
}

@synthesize eventOccurence = eventOccurence_;

-(void)dealloc{
  tmpEvent_ = nil;
  eventOccurence_ = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  UIBarButtonItem *edit = [[UIBarButtonItem alloc]
    initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                           target:self
                           action:@selector(editButtonAction)];
  self.navigationItem.rightBarButtonItem = edit;
  [self.tableView registerClass:[ATEventDetailCell class]
         forCellReuseIdentifier:ATEventDetailCellId];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(saveMocNotif:)
                                               name:NSManagedObjectContextDidSaveNotification
                                             object:self.eventOccurence.managedObjectContext];
  self.title = NSLocalizedString(@"Event details", @"View Event details controller title");
}

#pragma mark - Button actions
-(void)saveMocNotif:(NSNotification*)notification{
  NSSet* deleted = [notification.userInfo objectForKey:NSDeletedObjectsKey];
  if ([deleted containsObject:tmpEvent_]) {
    if (!self.isBeingDismissed && self.parentViewController) {
      [self.navigationController popViewControllerAnimated:NO];
    }
  }else if ([deleted containsObject:self.eventOccurence]) {
    if (!tmpEvent_) {
      if (!self.isBeingDismissed && self.parentViewController) {
        [self.navigationController popViewControllerAnimated:NO];
      }
      self.eventOccurence = nil;
      [self.tableView reloadData];
      return;
    }
    ATOccurrenceCache *potentialOccurence;
      NSPredicate* eventPredicate = [NSPredicate predicateWithFormat:@"event == %@ AND day >= %@"
                                                       argumentArray:@[tmpEvent_,self.eventOccurence.day]];
      potentialOccurence =
        [ATOccurrenceCache MR_findFirstWithPredicate:eventPredicate
                                           sortedBy:@"day"
                                          ascending:YES
                                           inContext:self.eventOccurence.managedObjectContext];
    if (!potentialOccurence) {
      eventPredicate = [NSPredicate predicateWithFormat:@"event == %@ AND day < %@"
                                          argumentArray:@[tmpEvent_,self.eventOccurence.day]];
      potentialOccurence =
      [ATOccurrenceCache MR_findFirstWithPredicate:eventPredicate
                                          sortedBy:@"day"
                                         ascending:NO
                                         inContext:self.eventOccurence.managedObjectContext];
    }
    if (!potentialOccurence) {
      if (!self.isBeingDismissed && self.parentViewController) {
        [self.navigationController popViewControllerAnimated:NO];
      }
    }
    self.eventOccurence = potentialOccurence;
    [self.tableView reloadData];
  }
}

-(IBAction)editButtonAction{
  ATEventEditController *editController =
    [[ATEventEditController alloc] initWithStyle:UITableViewStyleGrouped];
  editController.sourceEvent = self.eventOccurence.event;
  editController.delegate = self;
  UINavigationController*  ctrl = [[UINavigationController alloc] initWithRootViewController:editController];
  [self presentViewController:ctrl animated:YES completion:nil];
  tmpEvent_  = self.eventOccurence.event;
}

#pragma mark - protocol ATEventEditBaseControllerDelegate

-(void) eventEditBaseController:(ATEventEditBaseController*)controller
               didFinishEditing:(BOOL)successOrCancel{
  ATEventEditBaseController* ctrl = controller; // keep a reff
  [self dismissViewControllerAnimated:YES completion:nil];
  if (successOrCancel) {
    [ctrl.editingMoc MR_saveToPersistentStoreAndWait];
    [self.tableView reloadData];
  }  
}
#pragma mark - Table View
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return [ATEventDetailCell heightWithTitle:eventOccurence_.event.summary
                                   subtitle:eventOccurence_.event.location
                                description:[eventOccurence_ durationDescription]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  ATEventDetailCell* cell = [self.tableView dequeueReusableCellWithIdentifier:ATEventDetailCellId];
  cell.subtitleLabel.textColor = [UIColor lightGrayColor];
  cell.descriptionLabel.textColor = [UIColor colorWithRed:0.200 green:0.310 blue:0.510 alpha:1.000];
  
  [cell setTitle:eventOccurence_.event.summary
        subtitle:eventOccurence_.event.location
     description:[eventOccurence_ durationDescription]];
  return cell;
}
@end
