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
#import "ATEventOccurenceCell.h"
#import "ATCalendarUIConfig.h"



@interface ATEventListController (){
  NSManagedObjectContext* addingContext_;
}
@property (nonatomic) UISearchBar* searchBar;
@property (nonatomic, strong) NSString *searchString;
@property (nonatomic,strong) UISearchDisplayController *searchDisplayCtrl;
@property (strong, nonatomic)  UISegmentedControl *segCtrl;
@property (nonatomic) NSInteger selectedDisplayStyle; // 0,1,2 / Month, Week, Day
@end

@implementation ATEventListController
@synthesize fetchedResultsController = fetchedResultsController_;
@synthesize sFetchedResultsController = sFetchedResultsController_;
@synthesize searchString = searchString_;
@synthesize selectedDisplayStyle = selectedDisplayStyle_;
@synthesize searchResultsEventCellId = searchResultsEventCellId_;
@synthesize eventCellId = eventCellId_;
@synthesize searchResultsEventCellClass = searchResultsEventCellClass_;
@synthesize eventCellClass = eventCellClass_;

-(Class)eventCellClass{
  if (nil == eventCellClass_) {
    eventCellClass_ = [UITableViewCell class];
  }
  return eventCellClass_;
}

-(Class)searchResultsEventCellClass{
  if (nil == searchResultsEventCellClass_) {
    searchResultsEventCellClass_ = [UITableViewCell class];
  }
  return searchResultsEventCellClass_;
}

-(NSString*)searchResultsEventCellId{
  if (nil == searchResultsEventCellId_) {
    searchResultsEventCellId_ = @"searchResultsEventCellIdDefault";
  }
  return searchResultsEventCellId_;
}
-(NSString*)eventCellId{
  if (nil == eventCellId_) {
    eventCellId_ = @"eventCellIdDefault";
  }
  return eventCellId_;
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  self.navigationController.toolbarHidden = NO;
  [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  self.navigationController.toolbarHidden = YES; // hmmm
}

- (void)loadView{
  [super loadView];
  self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 44.0)];
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 44.0, self.view.bounds.size.width, self.view.bounds.size.height-44.0-138.0)]; // just before the toolbar
  [self.view addSubview:self.searchBar];
  [self.view addSubview:self.tableView];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.eventCellClass = [ATEventOccurenceCell class];
  self.searchResultsEventCellClass = [ATEventOccurenceCell class];
  [self.tableView registerClass:self.eventCellClass forCellReuseIdentifier:self.eventCellId];
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
                                    target:self
                                    action:@selector(showToday)];
  UIBarButtonItem * spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems: @[NSLocalizedString(@"Month", @""), NSLocalizedString(@"Week", @""),NSLocalizedString(@"Day", @"") ]];
  segCtrl.selectedSegmentIndex = 0;
  [segCtrl addTarget:self action:@selector(segCtrlChanged:) forControlEvents:UIControlEventValueChanged];
  segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
  self.segCtrl = segCtrl;
  UIBarButtonItem *segCtrlItem = [[UIBarButtonItem alloc] initWithCustomView:segCtrl];
  NSArray* items = @[today,spacer,segCtrlItem];
  [self setToolbarItems:items animated:YES];
}

-(void)setSelectedDisplayStyle:(NSInteger)selectedDisplayStyle{
  selectedDisplayStyle_ = selectedDisplayStyle;
  self.fetchedResultsController = nil;
  [self.tableView reloadData];
  [self showToday];
}

-(void)showToday{
  NSDate *now = [NSDate date];
  ATOccurrenceCache* today;
  NSPredicate *before = [NSPredicate predicateWithFormat:@"day >= %@" argumentArray:@[now]];
  ATOccurrenceCache* prev = [ATOccurrenceCache MR_findFirstWithPredicate:before
                                                                sortedBy:@"day"
                                                               ascending:NO
                                                               inContext:self.moc];
  NSPredicate *after = [NSPredicate predicateWithFormat:@"day <= %@" argumentArray:@[now]];
  ATOccurrenceCache* next = [ATOccurrenceCache MR_findFirstWithPredicate:after
                                                                sortedBy:@"day"
                                                               ascending:YES
                                                               inContext:self.moc];
  if (prev && next) {
    if ([prev.day mt_isWithinSameDay:now] && ![next.day mt_isWithinSameDay:now] ) {
      today = prev;
    }else
      if ([next.day mt_isWithinSameDay:now] && ![prev.day mt_isWithinSameDay:now] ) {
        today = next;
      }else{
        today = prev; // return before by default
      }
  }else if (prev){
    today = prev;
  }else if (next){
    today = next;
  }else{
    return;
  }
  NSIndexPath* indexPath = [self.fetchedResultsController indexPathForObject:today];
  [self.tableView scrollToRowAtIndexPath:indexPath
                        atScrollPosition:UITableViewScrollPositionMiddle
                                animated:[UIView areAnimationsEnabled]?YES:NO];
}

#pragma mark - Button Actions

-(IBAction)segCtrlChanged:(id)sender{
  NSAssert(sender == self.segCtrl, @"Expecting sender to be current segmented control");
  self.selectedDisplayStyle = self.segCtrl.selectedSegmentIndex;
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
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;

    [controller.event saveToPersistentStoreAndUpdateCaches];
    [self.tableView reloadData];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
  return UITableViewCellEditingStyleNone;
}
-(ATEventOccurenceController*)createEventOccurenceControllerWith:(ATOccurrenceCache*)o{
  ATEventOccurenceController *c = [[ATEventOccurenceController alloc] initWithStyle:UITableViewStyleGrouped];
  c.eventOccurence = [o MR_inContext:self.moc];
  return c;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  ATOccurrenceCache* occurence ;
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    occurence = [self.sFetchedResultsController objectAtIndexPath:indexPath];
  }else{
    occurence = [self.fetchedResultsController objectAtIndexPath:indexPath];
  }
  ATEventOccurenceController *edit = [self createEventOccurenceControllerWith:occurence];
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
    if (self.selectedDisplayStyle == 2) { // day
      return [dateFormatter stringFromDate:day];
    }else if (self.selectedDisplayStyle == 1) { // week
      NSDate * endDate = [day mt_endOfCurrentWeek];
      return [NSString stringWithFormat:@"%@ - %@",
              [dateFormatter stringFromDate:day],
              [dateFormatter stringFromDate:endDate]];
    }else{ //month
      return [day mt_stringFromDateWithFormat:@"MMM, yyyy" localized:YES];
    }
    return @"";
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell;
  ATOccurrenceCache *object;
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    cell = [tableView dequeueReusableCellWithIdentifier:self.searchResultsEventCellId];
    object = [self.sFetchedResultsController objectAtIndexPath:indexPath];
  }else{
    cell = [tableView dequeueReusableCellWithIdentifier:self.eventCellId];
    object = [self.fetchedResultsController objectAtIndexPath:indexPath];
  }
  [self configureCell:cell forObject:object];
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
  NSString* sectionNameKeyPath;
  switch (self.selectedDisplayStyle) {
    case 0:sectionNameKeyPath = @"monthTimeStamp";break;
    case 1:sectionNameKeyPath = @"weekTimeStamp";break;
    case 2:sectionNameKeyPath = @"dayTimeStamp";break;
  }
  aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.moc sectionNameKeyPath:sectionNameKeyPath cacheName:nil];
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
      [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
              forObject:[controller objectAtIndexPath:indexPath]];
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
-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
  [tableView registerClass:self.searchResultsEventCellClass forCellReuseIdentifier:self.searchResultsEventCellId];

}
// This gets called when you cancel or close the search bar
-(void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView {
  self.searchString = nil;
  self.sFetchedResultsController = nil;
}

- (void)configureCell:(UITableViewCell *)cell forObject:(ATOccurrenceCache*)object
{
  ATEventOccurenceCell* c;
  if ([cell isKindOfClass:[ATEventOccurenceCell class]]) {
    c = (ATEventOccurenceCell*)cell;
  }
  c.summaryLabel.text = object.event.summary;
  c.timeLabel.text = [object timeSpanDescription];
  c.summaryLabel.font = [UIFont boldSystemFontOfSize:20.0];
  c.timeLabel.textColor = [[ATCalendarUIConfig sharedConfig] eventTimeLabelCollor] ;
  c.summaryLabel.font = [UIFont boldSystemFontOfSize:18.0];
  c.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  c.selectionStyle = [[ATCalendarUIConfig sharedConfig] tableViewCellSelectionStyle];
}
@end
