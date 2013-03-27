//
//  ATAvilabilityController.m
//  ATCalendar
//
//  Created by Adrian Tofan on 27/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATAvilabilityController.h"

@interface ATAvilabilityController ()

@end

static NSString *CellIdentifier = @"Cell";

@implementation ATAvilabilityController
@synthesize endBlock = endBlock_;
@synthesize busy = busy_;

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
  self.title = NSLocalizedString(@"Avilability", @"Avilability controller title");
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  if (indexPath.row == 0) {
    cell.textLabel.text = NSLocalizedString(@"Busy", @"Busy label");
  }else{
    cell.textLabel.text = NSLocalizedString(@"Free", @"Free label");
  }
  return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.row == 0) {
    cell.accessoryType = self.busy?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
  }else
  if (indexPath.row == 1) {
    cell.accessoryType = !self.busy?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
  }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  self.busy = indexPath.row == 0?TRUE:FALSE; // first one is busy
  UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
  cell.accessoryType = self.busy?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
  cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
  cell.accessoryType = !self.busy?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
}

@end
