//
//  ATEventEditBaseController.m
//  ATCalendar
//
//  Created by Adrian Tofan on 19/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATEventEditBaseController.h"
#import "ATCalendar.h"
#import "ATTimeSpan.h"
#import "ATRecurrence.h"
#import "ATOccurrenceCache.h"
#import "ATEventTextFieldCell.h"
#import "ATEventTimeEditCell.h"


NSString const*  ATEventEditBaseSectionHeader = @"ATEventEditBaseSectionHeader";
NSString const*  ATEventEditBaseSectionDate = @"ATEventEditBaseSectionDate";
NSString const*  ATEventEditBaseSectionRecurrence = @"ATEventEditBaseSectionRecurrence";
NSString const*  ATEventEditBaseSectionParticipants = @"ATEventEditBaseSectionParticipants";
NSString const*  ATEventEditBaseSectionAlert = @"ATEventEditBaseSectionAlert";
NSString const*  ATEventEditBaseSectionURL = @"ATEventEditBaseSectionURL";
NSString const*  ATEventEditBaseSectionNotes = @"ATEventEditBaseSectionNotes";


@interface ATEventEditBaseController (){
  NSDateFormatter *formatter_;
}
@property (nonatomic,readwrite) ATEvent* event;
@property (nonatomic,readwrite) NSManagedObjectContext* editingMoc;
@property (nonatomic,readonly) NSArray* sections;
@property (nonatomic,readonly) NSDictionary* sectionCells;

@property (nonatomic,readonly) ATEventTextFieldCell* summaryCell;
@property (nonatomic,readonly) ATEventTextFieldCell* placeCell;
@property (nonatomic,readonly) ATEventTimeEditCell* timeEditCell;

@end

@implementation ATEventEditBaseController
@synthesize sections = sections_,sectionCells = sectionCells_;
@synthesize summaryCell = summaryCell_;
@synthesize placeCell = placeCell_;
@synthesize timeEditCell = timeEditCell_;

#pragma mark - Cells


-(ATEventTimeEditCell*)timeEditCell{
  if (nil == timeEditCell_) {
    timeEditCell_ = [[[NSBundle mainBundle]loadNibNamed:@"EventTimeEditCell" owner:nil options:nil] objectAtIndex:0];
  }
  return timeEditCell_;
}
-(ATEventTextFieldCell*)placeCell{
  if (nil == placeCell_) {
    placeCell_ = [[ATEventTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ATEventTextFieldCellPlace"];
    placeCell_.textField.placeholder = NSLocalizedString(@"Location",@"Event Location");
  }
  return placeCell_;
}
-(ATEventTextFieldCell*)summaryCell{
  if (nil == summaryCell_) {
    summaryCell_ = [[ATEventTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ATEventTextFieldCellName"];
    summaryCell_.textField.placeholder = NSLocalizedString(@"Title",@"Event Title");
  }
  return summaryCell_;
}

#pragma mark - Table view model

-(void)updateViewWithEvent:(ATEvent*)event{
  self.timeEditCell.startDateLabel.text = [formatter_ stringFromDate:event.startDate];
  self.timeEditCell.endDateLabel.text = [formatter_ stringFromDate:event.endDate];
  self.summaryCell.textField.text = event.summary;
  self.placeCell.textField.text = event.location;
}

-(void)updateFromView:(ATEvent*)event{
  event.summary = self.summaryCell.textField.text;
  event.location = self.placeCell.textField.text;
}

-(NSArray*)sections{
  if (nil == sections_) {
    sections_ = @[ATEventEditBaseSectionHeader,
                  ATEventEditBaseSectionDate,
                  ATEventEditBaseSectionRecurrence,
                  ATEventEditBaseSectionParticipants,
                  ATEventEditBaseSectionAlert,
                  ATEventEditBaseSectionURL,
                  ATEventEditBaseSectionNotes];
  }
  return sections_;
}

-(NSDictionary*)sectionCells {
  if (nil == sectionCells_) {
    sectionCells_ = @{ATEventEditBaseSectionHeader:@[self.summaryCell,self.placeCell],
                      ATEventEditBaseSectionDate:@[self.timeEditCell]};
  }
  return sectionCells_;
}

-(NSString*)sectionNameForSection:(NSInteger)section{
  return [self.sections objectAtIndex:section];
}

-(NSInteger)numberOfCellsInSection:(NSInteger)section{
  NSString* sectionName = [self sectionNameForSection:section];
  return [[self.sectionCells objectForKey:sectionName] count];
}

-(UITableViewCell*)cachedCellForRowAtIndexPath:(NSIndexPath*)indexPath{
  NSString* sectionName = [self sectionNameForSection:indexPath.section];
  NSArray* cellsInSection = [self.sectionCells objectForKey:sectionName];
  return [cellsInSection objectAtIndex:indexPath.row];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString* sectionName = [self sectionNameForSection:indexPath.section];
  if (sectionName == ATEventEditBaseSectionDate) {
    return [ATEventTimeEditCell height];
  }
  return 44.0;
}

#pragma mark -

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
  formatter_ = [[NSDateFormatter alloc] init];
  [formatter_ setTimeStyle:NSDateFormatterShortStyle];
  [formatter_ setDateStyle:NSDateFormatterMediumStyle];
  self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Bar Button actions
-(IBAction)cancelButtonAction{
  [self.delegate eventEditBaseController:self
                        didFinishEditing:FALSE];
}

-(IBAction)saveButtonAction{
  [self updateFromView:self.event];
  NSPredicate* eventPredicate = [NSPredicate predicateWithFormat:@"event == %@"
                                                   argumentArray:@[self.event]];
  [ATOccurrenceCache MR_deleteAllMatchingPredicate:eventPredicate inContext:self.editingMoc];
  ATTimeSpan* syncSpan = [[ATCalendar sharedInstance] currentSyncSpan];
  [self.event updateSimpleOccurencesFrom:syncSpan.start to:syncSpan.end inContext:self.editingMoc];
  if (self.event.recurence) {
    [self.event.recurence updateOccurencesFrom:syncSpan.start to:syncSpan.end inContext:self.editingMoc];
  }
  [self.delegate eventEditBaseController:self
                        didFinishEditing:TRUE];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self numberOfCellsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [self cachedCellForRowAtIndexPath:indexPath];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString *section = [self sectionNameForSection:indexPath.section];
  if (section == ATEventEditBaseSectionDate ) {
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Calendar" bundle:nil];
    ATDurationEditController* ctrl = [story instantiateViewControllerWithIdentifier:@"ATDurationEditControllerSceneId"];
    ctrl.startDate = self.event.startDate;
    ctrl.endDate = self.event.endDate;
    ctrl.allDay = self.event.allDayValue;
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
  }
}
#pragma mark - ATDurationEditControllerDelegate protocol
-(void)durationEditController:(ATDurationEditController*)ctrl
            didFinishWithSave:(BOOL)saveOrCancel{
  if (saveOrCancel) {
    self.event.startDate = ctrl.startDate;
    self.event.endDate = ctrl.endDate;
    self.event.allDayValue = ctrl.allDay;
    self.timeEditCell.startDateLabel.text = [formatter_ stringFromDate:self.event.startDate];
    self.timeEditCell.endDateLabel.text = [formatter_ stringFromDate:self.event.endDate];
  }
  [self.navigationController  popViewControllerAnimated:YES];
}
@end
