//
//  ATEventController.m
//  ATCalendar
//
//  Created by Adrian Tofan on 13/11/12.
//  Copyright (c) 2012 Adrian Tofan. All rights reserved.
//

#import "ATEventController.h"
#import "ATEventEditController.h"

@interface ATEventController ()

@end

@implementation ATEventController
@synthesize event = event_;

- (void)viewDidLoad
{
  [super viewDidLoad];
  UIBarButtonItem *edit = [[UIBarButtonItem alloc]
    initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                           target:self
                           action:@selector(editButtonAction)];
  self.navigationItem.rightBarButtonItem = edit;
}
#pragma mark - Button actions

-(IBAction)editButtonAction{
  ATEventEditController *editController =
    [[ATEventEditController alloc] initWithStyle:UITableViewStyleGrouped];
  editController.sourceEvent = self.event;
  editController.delegate = self;
  UINavigationController*  ctrl = [[UINavigationController alloc] initWithRootViewController:editController];
  [self presentViewController:ctrl animated:YES completion:nil];
}
#pragma mark - protocol ATEventEditBaseControllerDelegate

-(void) eventEditBaseController:(ATEventEditBaseController*)controller
               didFinishEditing:(BOOL)successOrCancel{
  if (successOrCancel) {
    [controller.editingMoc MR_saveToPersistentStoreAndWait];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  cell.textLabel.text = self.event.summary;
  return cell;
}
@end
