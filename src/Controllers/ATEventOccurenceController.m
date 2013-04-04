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
#import "ATEvent+LocalNotifications.h"

NSString * const CellTitleSubtitleDescriptionlId = @"CellTitleSubtitleDescriptionlId";
@interface ATEventOccurenceController ()
@property (nonatomic)  NSArray* cellList;
@end

typedef enum{
  CellTypeDescription     = 0,
  CellTypeAlarms          = 20,
  CellTypeAvilability     = 30,
  CellTypeURL             = 40,
  CellTypeNotes           = 50,
}CellType;

@implementation ATEventOccurenceController{
  ATEvent* tmpEvent_;
}

@synthesize eventOccurence = eventOccurence_;
@synthesize cellList = cellList_;



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
         forCellReuseIdentifier:CellTitleSubtitleDescriptionlId];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(saveMocNotif:)
                                               name:NSManagedObjectContextDidSaveNotification
                                             object:self.eventOccurence.managedObjectContext];
  self.title = NSLocalizedString(@"Event details", @"View Event details controller title");
}

#pragma mark - Setters & Getters

-(void)setEventOccurence:(ATOccurrenceCache *)eventOccurence{
  eventOccurence_ = eventOccurence;
  cellList_ = nil; // force reload
}

-(NSArray*)cellList{
  if (nil == cellList_) {
    NSMutableArray* list = [[NSMutableArray alloc] init];
    [list addObject:@(CellTypeDescription)];
    if (self.eventOccurence.event.firstAlertTypeValue != ATEventAlertTypeNone)
      [list addObject:@(CellTypeAlarms)];
    [list addObject:@(CellTypeAvilability)];
    if (self.eventOccurence.event.url
        && ![self.eventOccurence.event.url isEqualToString:@""]){
      [list addObject:@(CellTypeURL)];
    }
    if (self.eventOccurence.event.notes &&
        ![self.eventOccurence.event.notes isEqualToString:@""]){
      [list addObject:@(CellTypeNotes)];
    }
    cellList_ = [NSArray arrayWithArray:list];
  }
  return cellList_;
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
    [controller.editingMoc MR_saveToPersistentStoreAndWait];
    if (!controller.event.isDeleted && controller.event.managedObjectContext) {
      [ATOccurrenceCache updateCachesAfterEventChange:controller.event];
      [controller.editingMoc MR_saveToPersistentStoreAndWait];
      [controller.event updateLocalNotificationsAfterChange];
      [controller.editingMoc MR_saveToPersistentStoreAndWait];
    }
    self.cellList = nil;
    [self.tableView reloadData];
  }  
}

-(void)configureDescriptionCell:(ATEventDetailCell*)cell atIndexPath:(NSIndexPath*)indexPath{
  cell.subtitleLabel.textColor = [UIColor lightGrayColor];
  cell.descriptionLabel.textColor = [UIColor colorWithRed:0.200 green:0.310 blue:0.510 alpha:1.000];
  
  [cell setTitle:self.eventOccurence.event.summary
        subtitle:self.eventOccurence.event.location
     description:[self.eventOccurence durationDescription]];
}

-(void)configureURLCell:(ATEventDetailCell*)cell atIndexPath:(NSIndexPath*)indexPath{
  cell.subtitleLabel.textColor = [UIColor lightGrayColor];
  cell.descriptionLabel.textColor = [UIColor colorWithRed:0.200 green:0.310 blue:0.510 alpha:1.000];
  [cell setTitle:NSLocalizedString(@"URL", @"URL field title")
        subtitle:@""
     description:self.eventOccurence.event.url];
}

-(void)configureNotesCell:(ATEventDetailCell*)cell atIndexPath:(NSIndexPath*)indexPath{
  cell.subtitleLabel.textColor = [UIColor lightGrayColor];
  cell.descriptionLabel.textColor = [UIColor colorWithRed:0.200 green:0.310 blue:0.510 alpha:1.000];
  [cell setTitle:NSLocalizedString(@"Notes", @"Notes field title")
        subtitle:@""
     description:self.eventOccurence.event.notes];
}
-(void)configureAlertCell:(ATEventDetailCell*)cell atIndexPath:(NSIndexPath*)indexPath{
  cell.subtitleLabel.textColor = [UIColor lightGrayColor];
  cell.descriptionLabel.textColor = [UIColor colorWithRed:0.200 green:0.310 blue:0.510 alpha:1.000];
  [cell setTitle:NSLocalizedString(@"Alert", @"Alert field title")
        subtitle:@""
     description:[self.eventOccurence.event alertsDescription]];
}

-(void)configureAvilabilityCell:(ATEventDetailCell*)cell atIndexPath:(NSIndexPath*)indexPath{
  cell.subtitleLabel.textColor = [UIColor lightGrayColor];
  cell.descriptionLabel.textColor = [UIColor colorWithRed:0.200 green:0.310 blue:0.510 alpha:1.000];
  [cell setTitle:NSLocalizedString(@"Avilability", @"Avilability field title")
        subtitle:@""
     description:[self.eventOccurence.event avilabilityDescription]];
}

#pragma mark - TableView model & Configuration


-(CellType)cellTypeForIndexPath:(NSIndexPath*)indexPath{
  return [[self.cellList objectAtIndex:indexPath.row] integerValue];
}


#pragma mark - Table View

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  CellType type = [self cellTypeForIndexPath:indexPath];
  if (type == CellTypeDescription) {
    return [ATEventDetailCell heightWithTitle:self.eventOccurence.event.summary
                                   subtitle:self.eventOccurence.event.location
                                description:[self.eventOccurence durationDescription]];
  }
  if (type == CellTypeURL) {
    return [ATEventDetailCell heightWithTitle:NSLocalizedString(@"URL", @"URL field title")
                                     subtitle:@""
                                  description:self.eventOccurence.event.url];
  }
  if (type == CellTypeNotes) {
    return [ATEventDetailCell heightWithTitle:NSLocalizedString(@"Notes", @"Notes field title")
                                     subtitle:@""
                                  description:self.eventOccurence.event.notes];
  }
  if (type == CellTypeAlarms) {
    return [ATEventDetailCell heightWithTitle:NSLocalizedString(@"Alert", @"Alert field title")
                                     subtitle:@""
                                  description:[self.eventOccurence.event alertsDescription]];
  }
  if (type == CellTypeAvilability) {
    return [ATEventDetailCell heightWithTitle:NSLocalizedString(@"Avilability", @"Avilability field title")
                                     subtitle:@""
                                  description:[self.eventOccurence.event avilabilityDescription]];
  }

  return 44.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [self.cellList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

  CellType type = [self cellTypeForIndexPath:indexPath];
  if (type == CellTypeAvilability) {
    ATEventDetailCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellTitleSubtitleDescriptionlId];
    [self configureAvilabilityCell:cell atIndexPath:indexPath];
    return cell;
  }
  if (type == CellTypeDescription) {
    ATEventDetailCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellTitleSubtitleDescriptionlId];
    [self configureDescriptionCell:cell atIndexPath:indexPath];
    return cell;
  }
  if (type == CellTypeURL) {
    ATEventDetailCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellTitleSubtitleDescriptionlId];
    [self configureURLCell:cell atIndexPath:indexPath];
    return cell;
  }
  if (type == CellTypeNotes) {
    ATEventDetailCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellTitleSubtitleDescriptionlId];
    [self configureNotesCell:cell atIndexPath:indexPath];
    return cell;
  }
  if (type == CellTypeAlarms) {
    ATEventDetailCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellTitleSubtitleDescriptionlId];
    [self configureAlertCell:cell atIndexPath:indexPath];
    return cell;
  }
  return nil;
}
@end
