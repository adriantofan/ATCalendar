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
#import "ATEventOccurenceController.h"
#import "ATEventCreateController.h"
#import "ATEvent+LocalNotifications.h"

@interface ATEventListController (){
  NSManagedObjectContext* addingContext_;
}
@property (nonatomic) UISearchBar* searchBar;
@property (nonatomic) UITableView* tableView;
@property (nonatomic, strong) NSString *searchString;
@property (nonatomic,strong) UISearchDisplayController *searchDisplayCtrl;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *sFetchedResultsController;
@end

@implementation ATEventListController
@synthesize fetchedResultsController = fetchedResultsController_;
@synthesize sFetchedResultsController = sFetchedResultsController_;
@synthesize searchString = searchString_;

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  self.navigationController.toolbarHidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  self.navigationController.toolbarHidden = YES; // hmmm
}

- (void)loadView{
  [super loadView];
  self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 44.0)];
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 44.0, self.view.bounds.size.width, self.view.bounds.size.height-44.0)];
  [self.view addSubview:self.searchBar];
  [self.view addSubview:self.tableView];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  UISearchDisplayController *searchDisplayCtrl =
    [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
  searchDisplayCtrl.delegate = self;
  searchDisplayCtrl.searchResultsDelegate = self;
  searchDisplayCtrl.searchResultsDataSource = self;
  self.searchDisplayCtrl = searchDisplayCtrl;
  
//	self.mySearchBar.delegate = self;
	self.searchBar.showsCancelButton = NO;
  self.searchBar.showsBookmarkButton = NO;
  
//  self.tableView.tableHeaderView = self.searchBar;
  
  UIBarButtonItem *addButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction)];
  self.navigationItem.rightBarButtonItem = addButton;
  self.title = NSLocalizedString(@"Calendar",@"Day list controller title");
  UIBarButtonItem * today = [[UIBarButtonItem alloc]
                             initWithTitle:NSLocalizedString(@"Today", @"")
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
  UIBarButtonItem * spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems: @[NSLocalizedString(@"Month", @""), NSLocalizedString(@"Week", @"") ]];
  segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
  UIBarButtonItem *segCtrlItem = [[UIBarButtonItem alloc] initWithCustomView:segCtrl];
  NSArray* items = @[today,spacer,segCtrlItem];
  [self setToolbarItems:items animated:YES];
}
#pragma mark - Button Actions

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
  if (successOrCancel) { // This can only be an add action
    [controller.event saveToPersistentStoreAndUpdateCaches];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
  return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  ATOccurrenceCache* occurence ;
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    occurence = [self.sFetchedResultsController objectAtIndexPath:indexPath];
  }else{
    occurence = [self.fetchedResultsController objectAtIndexPath:indexPath];
  }
  ATEventOccurenceController *edit = [[ATEventOccurenceController alloc] initWithStyle:UITableViewStyleGrouped];
  edit.eventOccurence = [occurence MR_inContext:self.moc];
  [self.navigationController pushViewController:edit
                                       animated:YES];  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    return [[self.sFetchedResultsController sections] count];
  }else{
    return [[self.fetchedResultsController sections] count];
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (tableView == self.searchDisplayController.searchResultsTableView) {
      return [[self.sFetchedResultsController sections][section] numberOfObjects];
  }else{
    return [[self.fetchedResultsController sections][section] numberOfObjects];
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    return nil;
  }else{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSTimeInterval refTime = [[sectionInfo name] doubleValue];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSDate* day = [NSDate dateWithTimeIntervalSinceReferenceDate:refTime];
    return [dateFormatter stringFromDate:day];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ;
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
  return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
  return NO;
}
#pragma mark - Fetched results controller

- (NSFetchedResultsController *)sFetchedResultsController
{
  if (sFetchedResultsController_ != nil) {
    return sFetchedResultsController_;
  }
  NSFetchRequest*fetchRequest =
  [ATOccurrenceCache MR_requestAllSortedBy:@"day"
                                 ascending:YES
                                 inContext:self.moc];
  NSFetchedResultsController *aFetchedResultsController;

  NSString *search = [NSString stringWithFormat:@"*%@*",searchString_];
  NSPredicate *predicate =
  [NSPredicate predicateWithFormat:@"(event.summary LIKE[cd] %@) OR (event.notes LIKE[cd] %@)", search,search];
  [fetchRequest setPredicate:predicate];
  aFetchedResultsController =
  [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                      managedObjectContext:self.moc
                                        sectionNameKeyPath:nil
                                                 cacheName:nil];
  [fetchRequest setFetchBatchSize:20];
  aFetchedResultsController.delegate = self;
  self.sFetchedResultsController = aFetchedResultsController;
	NSError *error = nil;
	if (![self.sFetchedResultsController performFetch:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
  
  return sFetchedResultsController_;
}

- (NSFetchedResultsController *)fetchedResultsController
{
  if (fetchedResultsController_ != nil) {
    return fetchedResultsController_;
  }
  NSFetchRequest*fetchRequest =
  [ATOccurrenceCache MR_requestAllSortedBy:@"day"
                                 ascending:YES
                                 inContext:self.moc];
  NSFetchedResultsController *aFetchedResultsController;
//  BOOL shouldFilter = searchString_ && [searchString_ isNotEmpty];
  aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.moc sectionNameKeyPath:@"dayTimeStamp" cacheName:nil];
  [fetchRequest setFetchBatchSize:20];
  aFetchedResultsController.delegate = self;
  self.fetchedResultsController = aFetchedResultsController;
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
  
  return fetchedResultsController_;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  UITableView* tableView;
  if (controller == self.sFetchedResultsController) {
    tableView = self.searchDisplayController.searchResultsTableView;
  }else{
    tableView = self.tableView;
  }
  [tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
  UITableView* tableView;
  if (controller == self.sFetchedResultsController) {
    tableView = self.searchDisplayController.searchResultsTableView;
  }else{
    tableView = self.tableView;
  }
  
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
  UITableView* tableView;
  if (controller == self.sFetchedResultsController) {
    tableView = self.searchDisplayController.searchResultsTableView;
  }else{
    tableView = self.tableView;
  }
  
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
  UITableView* tableView;
  if (controller == self.sFetchedResultsController) {
    tableView = self.searchDisplayController.searchResultsTableView;
  }else{
    tableView = self.tableView;
  }
  [tableView endUpdates];
}
#pragma mark -
#pragma mark UISearchDisplayController delegate methods

// This gets called when you start typing text into the search bar
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
  [controller.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ContactCell"];
  self.searchString = searchString;
  self.sFetchedResultsController = nil;
  return YES;
}

// This gets called when you cancel or close the search bar
-(void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView {
  self.searchString = nil;
  self.sFetchedResultsController = nil;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  ATOccurrenceCache *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.textLabel.text = object.event.summary;
}

@end
