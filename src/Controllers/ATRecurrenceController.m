//
//  ATRepeatController.m
//  ATCalendar
//
//  Created by Adrian Tofan on 21/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATRecurrenceController.h"

@interface ATRecurrenceController ()
@property (nonatomic) NSArray* reccurenceLabels;
@end
static NSString *CellIdentifier = @"Cell";

@implementation ATRecurrenceController

@synthesize currentReccurrence = currentReccurrence_;
@synthesize reccurenceLabels = reccurenceLabels_;
-(NSArray*)reccurenceLabels{
  if (nil == reccurenceLabels_) {
    reccurenceLabels_ = @[NSLocalizedString(@"None", @"repeat selection"),
                          NSLocalizedString(@"Every Day", @"repeat selection"),
                          NSLocalizedString(@"Every Week", @"repeat selection"),
                          NSLocalizedString(@"Every Month", @"repeat selection"),
                          NSLocalizedString(@"Every Year", @"repeat selection"),
                          ];
  }
  return reccurenceLabels_;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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
  self.title = NSLocalizedString(@"Repeat", @"Recurrence controller title");
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(NSInteger)currentSelectedCellIndex{
  return [self cellIndexForReccurence:self.currentReccurrence];
}
-(ATRecurrenceType)reccurenceForCellIndex:(NSInteger)index{
  switch (index) {
    case 0: return ATRecurrenceTypeNone;
    case 1: return ATRecurrenceTypeDay;
    case 2: return ATRecurrenceTypeWeek;
    case 3: return ATRecurrenceTypeMonth;
    case 4: return ATRecurrenceTypeYear;
  }
  return -1;
}

-(NSInteger)cellIndexForReccurence:(ATRecurrenceType)reccurence{
  switch (reccurence) {
    case ATRecurrenceTypeNone:
      return 0;
    case ATRecurrenceTypeDay:
      return 1;
    case ATRecurrenceTypeWeek:
      return 2;
    case ATRecurrenceTypeMonth:
      return 3;
    case ATRecurrenceTypeYear:
      return 4;
  }
  return -1;
}

-(BOOL)cellIsSelectedAtIndex:(NSInteger)index{
  return self.currentReccurrence == index;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.reccurenceLabels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  cell.textLabel.text = [self.reccurenceLabels objectAtIndex:indexPath.row];
  if ([self cellIsSelectedAtIndex:indexPath.row]) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  }
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  ATRecurrenceType newReccurene = [self reccurenceForCellIndex:indexPath.row];
  if (newReccurene == -1) return;
  self.currentReccurrence = newReccurene;
  for (NSInteger i = 0; i<self.reccurenceLabels.count;i++) {
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    if ([self cellIsSelectedAtIndex:i]) {
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
      cell.accessoryType = UITableViewCellAccessoryNone;
    }
  }
}
@end
