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
#import "ATRecurrenceController.h"

#import "ATRecurrence.h"
#import "ATDailyRecurrence.h"
#import "ATWeeklyRecurrence.h"
#import "ATMonthlyRecurrence.h"
#import "ATYearlyRecurrence.h"


NSString const*  ATEventEditBaseSectionHeader = @"ATEventEditBaseSectionHeader";
NSString const*  ATEventEditBaseSectionDate = @"ATEventEditBaseSectionDate";
NSString const*  ATEventEditBaseSectionRecurrence = @"ATEventEditBaseSectionRecurrence";
NSString const*  ATEventEditBaseSectionParticipants = @"ATEventEditBaseSectionParticipants";
NSString const*  ATEventEditBaseSectionAlert = @"ATEventEditBaseSectionAlert";
NSString const*  ATEventEditBaseSectionURL = @"ATEventEditBaseSectionURL";
NSString const*  ATEventEditBaseSectionNotes = @"ATEventEditBaseSectionNotes";


@interface ATEventEditBaseController (){
  NSDateFormatter *dateTimeFormatter_;
  NSDateFormatter *dateFormatter_;
}
@property (nonatomic,readwrite) ATEvent* event;
@property (nonatomic,readwrite) NSManagedObjectContext* editingMoc;
@property (nonatomic,readonly) NSArray* sections;
@property (nonatomic,readonly) NSDictionary* sectionCells;
@property (nonatomic) BOOL repeatEndVisible;

@property (nonatomic,readonly) ATEventTextFieldCell* summaryCell;
@property (nonatomic,readonly) ATEventTextFieldCell* placeCell;
@property (nonatomic,readonly) ATEventTimeEditCell* timeEditCell;
@property (nonatomic,readonly) UITableViewCell* repeatTypeCell;
@property (nonatomic,readonly) UITableViewCell* repeatEndCell;


@end

@implementation ATEventEditBaseController
@synthesize sections = sections_,sectionCells = sectionCells_;
@synthesize summaryCell = summaryCell_;
@synthesize placeCell = placeCell_;
@synthesize timeEditCell = timeEditCell_;
@synthesize repeatTypeCell = repeatTypeCell_;
@synthesize repeatEndCell = repeatEndCell_;

#pragma mark - Cells
-(UITableViewCell*)repeatEndCell{
  if (nil == repeatEndCell_) {
    repeatEndCell_ = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellStyleValue1Id"];
    repeatEndCell_.textLabel.text = NSLocalizedString(@"End Repeat", @"");
    repeatEndCell_.detailTextLabel.text = NSLocalizedString(@"Never", @"");
    repeatEndCell_.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  }
  return repeatEndCell_;
}
-(UITableViewCell*)repeatTypeCell{
  if (nil == repeatTypeCell_) {
    repeatTypeCell_ = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellStyleValue1Id"];
    repeatTypeCell_.textLabel.text = NSLocalizedString(@"Repeat", @"Repeat cell title");
    repeatTypeCell_.detailTextLabel.text = NSLocalizedString(@"Never", @"");
    repeatTypeCell_.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  return repeatTypeCell_;
}

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
  NSDateFormatter *formater = event.allDayValue?dateFormatter_:dateTimeFormatter_;
  self.timeEditCell.startDateLabel.text = [formater stringFromDate:event.startDate];
  self.timeEditCell.endDateLabel.text = [formater stringFromDate:event.endDate];
  self.summaryCell.textField.text = event.summary;
  self.placeCell.textField.text = event.location;
  if (event.recurence) {
    self.repeatTypeCell.detailTextLabel.text = event.recurence.reccurenceTypeDescription;
    if (nil == event.recurence.endDate) {
      self.repeatEndCell.detailTextLabel.text = NSLocalizedString(@"Never", @"");
    }else{
      self.repeatEndCell.detailTextLabel.text = [dateTimeFormatter_ stringFromDate:event.recurence.endDate];
    }
  }else{
    self.repeatTypeCell.detailTextLabel.text = NSLocalizedString(@"Never", @"");;
    self.repeatEndCell.detailTextLabel.text = NSLocalizedString(@"Never", @"");;
  }
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
                      ATEventEditBaseSectionDate:@[self.timeEditCell],
                      ATEventEditBaseSectionRecurrence:@[self.repeatTypeCell,self.repeatEndCell]};
  }
  return sectionCells_;
}

-(NSString*)sectionNameForSection:(NSInteger)section{
  return [self.sections objectAtIndex:section];
}

-(NSInteger)numberOfCellsInSection:(NSInteger)section{
  NSString* sectionName = [self sectionNameForSection:section];
  if (sectionName == ATEventEditBaseSectionRecurrence) {
    if (self.repeatEndVisible) {
      return 2;
    }else{
      return 1;
    }
  }
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
  dateTimeFormatter_ = [[NSDateFormatter alloc] init];
  [dateTimeFormatter_ setTimeStyle:NSDateFormatterShortStyle];
  [dateTimeFormatter_ setDateStyle:NSDateFormatterMediumStyle];
  dateFormatter_ = [[NSDateFormatter alloc] init];
  [dateFormatter_ setTimeStyle:NSDateFormatterNoStyle];
  [dateFormatter_ setDateStyle:NSDateFormatterLongStyle];
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
  self.repeatEndVisible = self.event.isRecurrent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Helpers


-(void)showReccurenceTypeSelection{
  ATRecurrenceController* ctrl = [[ATRecurrenceController alloc] initWithStyle:UITableViewStyleGrouped];
  ctrl.currentReccurrence  = self.event.recurence.typeValue;
  typeof(self) __weak SELF = self;
  typeof(ctrl) __weak CTRL = ctrl;
  ctrl.endBlock = ^void (BOOL saveOrCancel){
    if (saveOrCancel) {
      [SELF.event changeRecurenceType:CTRL.currentReccurrence];
      [SELF updateViewWithEvent:SELF.event];
      NSIndexPath* endCellIndexPath = [NSIndexPath indexPathForRow:1 inSection:[SELF.sections indexOfObject:ATEventEditBaseSectionRecurrence]];
      if (SELF.event.isRecurrent && !SELF.repeatEndVisible) {
        SELF.repeatEndVisible = YES;
        [SELF.tableView insertRowsAtIndexPaths:@[endCellIndexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
      }
      if (!SELF.event.isRecurrent && SELF.repeatEndVisible) {
        SELF.repeatEndVisible = NO;
        [SELF.tableView deleteRowsAtIndexPaths:@[endCellIndexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
      }
    }
    [SELF.navigationController popViewControllerAnimated:YES];
  };
  [self.navigationController pushViewController:ctrl animated:YES];
}

-(void)showEventDurationSeclection{
  UIStoryboard* story = [UIStoryboard storyboardWithName:@"Calendar" bundle:nil];
  ATDurationEditController* ctrl = [story instantiateViewControllerWithIdentifier:@"ATDurationEditControllerSceneId"];
  ctrl.startDate = self.event.startDate;
  ctrl.endDate = self.event.endDate;
  ctrl.allDay = self.event.allDayValue;
  ctrl.delegate = self;
  [self.navigationController pushViewController:ctrl animated:YES];
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
    [self showEventDurationSeclection];
  }
  
  if (section == ATEventEditBaseSectionRecurrence ) {
    if (indexPath.row == 0) { // recurrence type
      [self showReccurenceTypeSelection];
    }
    if (indexPath.row == 1) { // recurrence duration
      
    }
  }
}
#pragma mark - ATDurationEditControllerDelegate protocol
-(void)durationEditController:(ATDurationEditController*)ctrl
            didFinishWithSave:(BOOL)saveOrCancel{
  if (saveOrCancel) {
    self.event.startDate = ctrl.startDate;
    self.event.endDate = ctrl.endDate;
    self.event.allDayValue = ctrl.allDay;
    [self updateViewWithEvent:self.event];
  }
  [self.navigationController  popViewControllerAnimated:YES];
}
@end
