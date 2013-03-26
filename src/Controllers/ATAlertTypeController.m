//
//  ATAlertTypeController.m
//  ATCalendar
//
//  Created by Adrian Tofan on 26/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATAlertTypeController.h"
#import "ATEvent.h"

@interface ATAlertTypeController ()
@property (nonatomic) NSArray* alertLabels;
@end
static NSString *CellIdentifier = @"Cell";

@implementation ATAlertTypeController
@synthesize type = type_;
@synthesize alertLabels = alertLabels_;
@synthesize endBlock = endBlock_;

-(NSArray*)alertLabels{
  if (nil == alertLabels_) {
    alertLabels_ = @[NSLocalizedString(@"None", @"alert type"),
                     NSLocalizedString(@"At event time", @"alert type"),
                     NSLocalizedString(@"5 minutes before", @"alert type"),
                     NSLocalizedString(@"15 minutes before", @"alert type"),
                     NSLocalizedString(@"30 minutes before", @"alert type"),
                     NSLocalizedString(@"1 hour before", @"alert type"),
                     NSLocalizedString(@"2 hours before", @"alert type"),
                     NSLocalizedString(@"1 day before", @"alert type"),
                     NSLocalizedString(@"2 days before", @"alert type"),
                          ];
  }
  return alertLabels_;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  UIBarButtonItem* cancel = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                             target:self
                             action:@selector(cancelButtonAction)];
  UIBarButtonItem* save = [[UIBarButtonItem alloc]
                           initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                           target:self
                           action:@selector(saveButtonAction)];
  self.navigationItem.leftBarButtonItem = cancel;
  self.navigationItem.rightBarButtonItem = save;
  self.title = NSLocalizedString(@"Event Alert", @"Event Alert controller title");
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}
#pragma mark - Button actions

-(IBAction)cancelButtonAction{
  if (self.endBlock) {
    self.endBlock(NO);
  }
}

-(IBAction)saveButtonAction{
  if (self.endBlock) {
    self.endBlock(YES);
  }
}
#pragma mark - Model

-(ATEventAlertType)typeForCellIndex:(NSInteger)index{
  switch (index) {
    case 0: return ATEventAlertTypeNone;
    case 1: return ATEventAlertTypeAtTime;
    case 2: return ATEventAlertType5MinBefore;
    case 3: return ATEventAlertType15MinBefore;
    case 4: return ATEventAlertType30MinBefore;
    case 5: return ATEventAlertType1HBefore;
    case 6: return ATEventAlertType2HBefore;
    case 7: return ATEventAlertType1DayBefore;
    case 8: return ATEventAlertType2DaysBefore;
  }
  
  return -1;
}

-(BOOL)cellIsSelectedAtIndex:(NSInteger)index{
  return [self currentSelectedCellIndex] == index;
}

-(NSInteger)currentSelectedCellIndex{
  return [self cellIndexForType:self.type];
}

-(NSInteger)cellIndexForType:(ATEventAlertType)type{
  switch (type) {
    case ATEventAlertTypeNone:
      return 0;
    case ATEventAlertTypeAtTime:
      return 1;
    case ATEventAlertType5MinBefore:
      return 2;
    case ATEventAlertType15MinBefore:
      return 3;
    case ATEventAlertType30MinBefore:
      return 4;
    case ATEventAlertType1HBefore:
      return 5;
    case ATEventAlertType2HBefore:
      return 6;
    case ATEventAlertType1DayBefore:
      return 7;
    case ATEventAlertType2DaysBefore:
      return 8;
  }
  return -1;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.alertLabels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  cell.textLabel.text = [self.alertLabels objectAtIndex:indexPath.row];
  return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
  if ([self cellIsSelectedAtIndex:indexPath.row]) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  ATEventAlertType newType = [self typeForCellIndex:indexPath.row];
  if (newType == -1) return;
  self.type = newType;
  for (NSInteger i = 0; i<self.alertLabels.count;i++) {
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    if ([self cellIsSelectedAtIndex:i]) {
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
      cell.accessoryType = UITableViewCellAccessoryNone;
    }
  }
}

@end
