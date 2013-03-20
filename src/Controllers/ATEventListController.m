//
//  ATPlanningController.m
//  ATCalendar
//
//  Created by Adrian Tofan on 13/11/12.
//  Copyright (c) 2012 Adrian Tofan. All rights reserved.
//

#import "ATEventListController.h"
#import "ATOccurrenceCache.h"
#import "ATEventEditController.h"
#import "ATEvent.h"
#import "ATEventController.h"
#import "ATEventCreateController.h"

@interface ATEventListController (){
  NSManagedObjectContext* addingContext_;
}

@end

@implementation ATEventListController

- (void)viewDidLoad
{
  [super viewDidLoad];
  UIBarButtonItem *addButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction)];
  self.navigationItem.leftBarButtonItem = addButton;
}

-(IBAction)eventEditSaved:(UIStoryboardSegue *)segue{
  [self dismissViewControllerAnimated:YES completion:^{
    [addingContext_ MR_saveOnlySelfAndWait];
    addingContext_ = nil;
  }];
}
-(IBAction)eventEditCanceled:(UIStoryboardSegue *)segue{
  [self dismissViewControllerAnimated:YES completion:^{
    addingContext_ = nil;
  }];
}

#pragma mark - Button Actions

-(IBAction)addButtonAction{
  ATEventCreateController *create = [[ATEventCreateController alloc] initWithStyle:UITableViewStyleGrouped];
  create.sourceMoc = self.moc;
  create.delegate = self;
  UINavigationController* ctrl = [[UINavigationController alloc] initWithRootViewController:create];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [self.fetchedResultsController objectAtIndexPath:indexPath];
  ATEventController *edit = [[ATEventController alloc] initWithStyle:UITableViewStyleGrouped];
  edit.event = [[self.fetchedResultsController objectAtIndexPath:indexPath] event];
  [self.navigationController pushViewController:edit
                                       animated:YES];  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
  return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ;
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
    NSError *error = nil;
    if (![context save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  // The table view should not be re-orderable.
  return NO;
}
#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
  if (_fetchedResultsController != nil) {
    return _fetchedResultsController;
  }
  NSFetchRequest*fetchRequest =
  [ATOccurrenceCache MR_requestAllSortedBy:@"day"
                                 ascending:YES
                                 inContext:self.moc];  
  NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.moc sectionNameKeyPath:@"day" cacheName:nil];
  [fetchRequest setFetchBatchSize:20];
  aFetchedResultsController.delegate = self;
  self.fetchedResultsController = aFetchedResultsController;
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
  
  return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
  UITableView *tableView = self.tableView;
  
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeUpdate:
      [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
      break;
      
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  ATOccurrenceCache *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.textLabel.text = object.event.summary;
}
@end
