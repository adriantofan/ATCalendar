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
#import "ATDailyRecurrence.h"
#import "ATWeeklyRecurrence.h"
#import "ATMonthlyRecurrence.h"
#import "ATYearlyRecurrence.h"

#import "ATOccurrenceCache.h"
#import "ATEventTextFieldCell.h"
#import "ATEventTimeEditCell.h"
#import "ATRecurrenceController.h"
#import "ATEndRecurrenceController.h"
#import "ATEventTextViewCell.h"
#import "ATAlertTypeController.h"
#import "ATAvilabilityController.h"
#import "ATCalendarUIConfig.h"
#import "NSBundle+ATCalendar.h"

#define ISEMPTYSTRING(str) ((nil ==str) || ([str length] == 0) || ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0))

NSString * const ATEventEditControllerEventWillSaveNotification = @"ATEventEditControllerEventWillSaveNotification";
NSString * const ATEventEditControllerEventDidSaveNotification = @"ATEventEditControllerEventDidSaveNotification";

NSString const*  ATEventEditBaseSectionHeader = @"ATEventEditBaseSectionHeader";
NSString const*  ATEventEditBaseSectionDate = @"ATEventEditBaseSectionDate";
NSString const*  ATEventEditBaseSectionRecurrence = @"ATEventEditBaseSectionRecurrence";
NSString const*  ATEventEditBaseSectionParticipants = @"ATEventEditBaseSectionParticipants";
NSString const*  ATEventEditBaseSectionAlert = @"ATEventEditBaseSectionAlert";
NSString const*  ATEventEditBaseSectionURL = @"ATEventEditBaseSectionURL";
NSString const*  ATEventEditBaseSectionNotes = @"ATEventEditBaseSectionNotes";
NSString const* ATEventEditBaseSectionAvilability = @"ATEventEditBaseSectionAvilability";


@interface ATEventEditBaseController (){
  NSDateFormatter *dateTimeFormatter_;
  NSDateFormatter *dateFormatter_;
  UIBarButtonItem* saveButton_;
}
@property (nonatomic,readwrite) ATEvent* event;
@property (nonatomic,readwrite) NSManagedObjectContext* editingMoc;
@property (nonatomic,readonly) NSArray* sections;
@property (nonatomic,readonly) NSDictionary* sectionCells;
@property (nonatomic) BOOL repeatEndVisible;
@property (nonatomic) BOOL seccondAlertVisible;


@property (nonatomic,readonly) ATEventTextFieldCell* summaryCell;
@property (nonatomic,readonly) ATEventTextFieldCell* placeCell;
@property (nonatomic,readonly) ATEventTimeEditCell* timeEditCell;
@property (nonatomic,readonly) UITableViewCell* repeatTypeCell;
@property (nonatomic,readonly) UITableViewCell* repeatEndCell;
@property (nonatomic,readonly) ATEventTextFieldCell* urlCell;
@property (nonatomic,readonly) ATEventTextViewCell* notesCell;
@property (nonatomic,readonly) UITableViewCell* firstAlertCell;
@property (nonatomic,readonly) UITableViewCell* seccondAlertCell;
@property (nonatomic,readonly) UITableViewCell* busyCell;



@end

@implementation ATEventEditBaseController
@synthesize sections = sections_,sectionCells = sectionCells_;
@synthesize summaryCell = summaryCell_;
@synthesize placeCell = placeCell_;
@synthesize timeEditCell = timeEditCell_;
@synthesize repeatTypeCell = repeatTypeCell_;
@synthesize repeatEndCell = repeatEndCell_;
@synthesize urlCell = urlCell_;
@synthesize notesCell = notesCell_;
@synthesize firstAlertCell = firstAlertCell_;
@synthesize seccondAlertCell = seccondAlertCell_;
@synthesize busyCell = busyCell_;

#pragma mark - Cells
-(UITableViewCell*)busyCell{
  if (nil == busyCell_) {
    busyCell_ = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellStyleValue1Id"];
    busyCell_.textLabel.text = ATLocalizedString(@"Avilability", @"Avilability cell label");
    busyCell_.detailTextLabel.text = ATLocalizedString(@"", @"");
    busyCell_.detailTextLabel.textColor = [[ATCalendarUIConfig sharedConfig] tableViewCellDetailLabelCollor];
    busyCell_.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    busyCell_.selectionStyle = [[ATCalendarUIConfig sharedConfig] tableViewCellSelectionStyle];
  }
  return busyCell_;
}
-(UITableViewCell*)firstAlertCell{
  if (nil == firstAlertCell_) {
    firstAlertCell_ = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellStyleValue1Id"];
    firstAlertCell_.textLabel.text = ATLocalizedString(@"Alert", @"Alert cell label");
    firstAlertCell_.detailTextLabel.text = ATLocalizedString(@"None", @"Alert cell default to no alert");
    firstAlertCell_.detailTextLabel.textColor = [[ATCalendarUIConfig sharedConfig] tableViewCellDetailLabelCollor];
    firstAlertCell_.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    firstAlertCell_.selectionStyle = [[ATCalendarUIConfig sharedConfig] tableViewCellSelectionStyle];
    
  }
  return firstAlertCell_;
}

-(UITableViewCell*)seccondAlertCell{
  if (nil == seccondAlertCell_) {
    seccondAlertCell_ = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellStyleValue1Id"];
    seccondAlertCell_.textLabel.text = ATLocalizedString(@"Second Alert", @"Alert cell label");
    seccondAlertCell_.detailTextLabel.text = ATLocalizedString(@"None", @"Alert cell default to no alert");
    seccondAlertCell_.detailTextLabel.textColor = [[ATCalendarUIConfig sharedConfig] tableViewCellDetailLabelCollor];
    seccondAlertCell_.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    seccondAlertCell_.selectionStyle = [[ATCalendarUIConfig sharedConfig] tableViewCellSelectionStyle];
  }
  return seccondAlertCell_;
}

-(UITableViewCell*)repeatEndCell{
  if (nil == repeatEndCell_) {
    repeatEndCell_ = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellStyleValue1Id"];
    repeatEndCell_.textLabel.text = ATLocalizedString(@"End Repeat", @"When repeating ends");
    repeatEndCell_.detailTextLabel.text = ATLocalizedString(@"Never", @"Repeat forever");
    repeatEndCell_.detailTextLabel.textColor = [[ATCalendarUIConfig sharedConfig] tableViewCellDetailLabelCollor];
    repeatEndCell_.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    repeatEndCell_.selectionStyle = [[ATCalendarUIConfig sharedConfig] tableViewCellSelectionStyle];

  }
  return repeatEndCell_;
}
-(UITableViewCell*)repeatTypeCell{
  if (nil == repeatTypeCell_) {
    repeatTypeCell_ = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellStyleValue1Id"];
    repeatTypeCell_.textLabel.text = ATLocalizedString(@"Repeat", @"Repeat type cell title");
    repeatTypeCell_.detailTextLabel.text = ATLocalizedString(@"Never", @"Do not repeat");
    repeatTypeCell_.detailTextLabel.textColor = [[ATCalendarUIConfig sharedConfig] tableViewCellDetailLabelCollor];
    repeatTypeCell_.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    repeatTypeCell_.selectionStyle = [[ATCalendarUIConfig sharedConfig] tableViewCellSelectionStyle];
  }
  return repeatTypeCell_;
}

-(ATEventTimeEditCell*)timeEditCell{
  if (nil == timeEditCell_) {
    timeEditCell_ = [[[NSBundle at_calendar_defaultBundle]
                      loadNibNamed:@"EventTimeEditCell"
                             owner:nil
                           options:nil]
                     objectAtIndex:0];
    timeEditCell_.selectionStyle = [[ATCalendarUIConfig sharedConfig] tableViewCellSelectionStyle];

  }
  return timeEditCell_;
}
-(ATEventTextFieldCell*)placeCell{
  if (nil == placeCell_) {
    placeCell_ = [[ATEventTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ATEventTextFieldCellPlace"];
    placeCell_.textField.placeholder = ATLocalizedString(@"Location",@"Event Location");
    placeCell_.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  return placeCell_;
}
-(ATEventTextFieldCell*)summaryCell{
  if (nil == summaryCell_) {
    summaryCell_ = [[ATEventTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ATEventTextFieldCellName"];
    summaryCell_.textField.placeholder = ATLocalizedString(@"Title",@"Event Title");
    summaryCell_.selectionStyle = UITableViewCellSelectionStyleNone;
    summaryCell_.textField.delegate = self;
  }
  return summaryCell_;
}
-(ATEventTextFieldCell*)urlCell{
  if (nil == urlCell_) {
    urlCell_ = [[ATEventTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ATEventTextFieldCellName"];
    urlCell_.textField.placeholder = ATLocalizedString(@"URL",@"Event URL");
    urlCell_.textField.keyboardType = UIKeyboardTypeURL;
    urlCell_.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  
  return urlCell_;
}

-(ATEventTextViewCell*)notesCell{
  if (nil == notesCell_) {
    notesCell_ = [[ATEventTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ATEventTextViewCellId"];
    notesCell_.textView.placeholder = ATLocalizedString(@"Notes",@"Event notes");
    notesCell_.textView.font = [UIFont systemFontOfSize:16.0];
    notesCell_.textView.placeholderColor = [UIColor lightGrayColor];
    notesCell_.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  return notesCell_;
}

#pragma mark - Table view model



-(void)updateViewWithEvent:(ATEvent*)event{
  dateTimeFormatter_.timeZone = event.timeZone;
  dateFormatter_.timeZone = event.timeZone;
  NSDateFormatter *formater = event.allDayValue?dateFormatter_:dateTimeFormatter_;
  self.timeEditCell.startDateLabel.text = [formater stringFromDate:event.startDate];
  self.timeEditCell.endDateLabel.text = [formater stringFromDate:event.endDate];
  self.summaryCell.textField.text = event.summary;
  self.placeCell.textField.text = event.location;
  if (event.recurence) {
    self.repeatTypeCell.detailTextLabel.text = event.recurence.reccurenceTypeDescription;
    if (nil == event.recurence.endDate) {
      self.repeatEndCell.detailTextLabel.text = ATLocalizedString(@"Never", @"Do not repeat");
    }else{
      self.repeatEndCell.detailTextLabel.text = [dateFormatter_ stringFromDate:event.recurence.endDate];
    }
  }else{
    self.repeatTypeCell.detailTextLabel.text = ATLocalizedString(@"Never", @"Do not repeat");;
    self.repeatEndCell.detailTextLabel.text = ATLocalizedString(@"Never", @"Do not repeat");;
  }
  self.firstAlertCell.detailTextLabel.text = [ATEvent descriptionFor:event.firstAlertTypeValue];
  self.seccondAlertCell.detailTextLabel.text = [ATEvent descriptionFor:event.seccondAlertTypeValue];
  self.urlCell.textField.text = event.url;
  self.notesCell.textView.text = event.notes;
  if(self.event.busyValue){
    self.busyCell.detailTextLabel.text = ATLocalizedString(@"Busy", @"Busy label");
  }else{
    self.busyCell.detailTextLabel.text = ATLocalizedString(@"Free", @"Free label");
  }
  self.timeEditCell.timeZoneLabel.text = [event.timeZone name];
}

-(void)updateFromView:(ATEvent*)event{
  event.summary = self.summaryCell.textField.text;
  event.location = self.placeCell.textField.text;
  event.url = self.urlCell.textField.text;
  event.notes = self.notesCell.textView.text;
}

-(NSArray*)sections{
  if (nil == sections_) {
    sections_ = @[ATEventEditBaseSectionHeader,
                  ATEventEditBaseSectionDate,
                  ATEventEditBaseSectionRecurrence,
//                  ATEventEditBaseSectionParticipants,
                  ATEventEditBaseSectionAlert,
                  ATEventEditBaseSectionAvilability,
                  ATEventEditBaseSectionURL,
                  ATEventEditBaseSectionNotes];
  }
  return sections_;
}

-(NSDictionary*)sectionCells {
  if (nil == sectionCells_) {
    sectionCells_ = @{ATEventEditBaseSectionHeader:@[self.summaryCell,self.placeCell],
                      ATEventEditBaseSectionDate:@[self.timeEditCell],
                      ATEventEditBaseSectionRecurrence:@[self.repeatTypeCell,self.repeatEndCell],
                      ATEventEditBaseSectionURL:@[self.urlCell],
                      ATEventEditBaseSectionNotes:@[self.notesCell],
                      ATEventEditBaseSectionAlert:@[self.firstAlertCell,self.seccondAlertCell],
                      ATEventEditBaseSectionAvilability:@[self.busyCell]};
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
  if (sectionName == ATEventEditBaseSectionAlert) {
    if (self.seccondAlertVisible) {
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
  if (sectionName == ATEventEditBaseSectionNotes) {
    return 100.0;
  }
  return 44.0;
}


#pragma mark -
-(void)setEvent:(ATEvent *)event{
  _event = event;
  dateTimeFormatter_.timeZone = event.timeZone;
  dateFormatter_.timeZone = event.timeZone;
  self.repeatEndVisible = event.isRecurrent;
  self.seccondAlertVisible = event.firstAlertTypeValue != ATEventAlertTypeNone;
  if (!event.summary ||( 0 == [[event.summary stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])) {
    saveButton_.enabled = NO;
  }
}

-(void)viewWillDisappear:(BOOL)animated{
  [self updateFromView:self.event];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
  self.tableView.backgroundView.backgroundColor = [[ATCalendarUIConfig sharedConfig] groupedTableViewBGCollor];

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
  saveButton_ = save;
  self.navigationItem.leftBarButtonItem = cancel;
  self.navigationItem.rightBarButtonItem = save;
}


#pragma mark - Helpers
-(void)showAvilabilitySelection{
  ATAvilabilityController * ctrl = [[ATAvilabilityController alloc] initWithStyle:UITableViewStyleGrouped];
  ctrl.busy = self.event.busyValue;
  typeof(self) __weak SELF = self;
  typeof(ctrl) __weak CTRL = ctrl;
  ctrl.endBlock = ^void (BOOL saveOrCancel){
    if (saveOrCancel) {
      SELF.event.busyValue = CTRL.busy;
      [SELF updateViewWithEvent:SELF.event];
    }
    [SELF.navigationController popViewControllerAnimated:YES];
  };
  [self.navigationController pushViewController:ctrl animated:YES];
}

-(void)showFirstAlertSelection{
  ATAlertTypeController * ctrl = [[ATAlertTypeController alloc] initWithStyle:UITableViewStyleGrouped];
  ctrl.type = self.event.firstAlertTypeValue;
  typeof(self) __weak SELF = self;
  typeof(ctrl) __weak CTRL = ctrl;
  ctrl.endBlock = ^void (BOOL saveOrCancel){
      if (saveOrCancel) {
        if (CTRL.type == ATEventAlertTypeNone
            && SELF.seccondAlertVisible
            && SELF.event.seccondAlertTypeValue != ATEventAlertTypeNone) {
          SELF.event.firstAlertTypeValue = SELF.event.seccondAlertTypeValue;
          SELF.event.seccondAlertTypeValue = ATEventAlertTypeNone;
          [SELF updateViewWithEvent:SELF.event];
        }else{
          SELF.event.firstAlertTypeValue = CTRL.type;
          [SELF updateViewWithEvent:SELF.event];
          NSIndexPath* endCellIndexPath = [NSIndexPath indexPathForRow:1 inSection:[SELF.sections indexOfObject:ATEventEditBaseSectionAlert]];
          if ((SELF.event.firstAlertTypeValue != ATEventAlertTypeNone) &&
              !SELF.seccondAlertVisible) {
            SELF.seccondAlertVisible = YES;
            [SELF.tableView insertRowsAtIndexPaths:@[endCellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
          }
          if (!(SELF.event.firstAlertTypeValue != ATEventAlertTypeNone)
              && SELF.seccondAlertVisible) {
            SELF.seccondAlertVisible = NO;
            [SELF.tableView deleteRowsAtIndexPaths:@[endCellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
          }
          
        }
    }
    [SELF.navigationController popViewControllerAnimated:YES];
  };
  [self.navigationController pushViewController:ctrl animated:YES];
}

-(void)showSeccondAlertSelection{
  ATAlertTypeController * ctrl = [[ATAlertTypeController alloc] initWithStyle:UITableViewStyleGrouped];
  ctrl.type = self.event.seccondAlertTypeValue;
  typeof(self) __weak SELF = self;
  typeof(ctrl) __weak CTRL = ctrl;
  ctrl.endBlock = ^void (BOOL saveOrCancel){
    if (saveOrCancel) {
      if (saveOrCancel) {
        SELF.event.seccondAlertTypeValue = CTRL.type;
        [SELF updateViewWithEvent:SELF.event];
      }
    }
    [SELF.navigationController popViewControllerAnimated:YES];
  };
  [self.navigationController pushViewController:ctrl animated:YES];

}
-(void)showEndReccurenceSelection{
  ATEndRecurrenceController* ctrl = [[ATEndRecurrenceController alloc] initWithStyle:UITableViewStyleGrouped];
  ctrl.minimumDate = self.event.startDate;
  ctrl.endDate = self.event.recurence.endDate;
  typeof(self) __weak SELF = self;
  typeof(ctrl) __weak CTRL = ctrl;
  ctrl.endBlock = ^void (BOOL saveOrCancel){
    if (saveOrCancel) {
      if (saveOrCancel) {
        SELF.event.recurence.endDate = CTRL.endDate;
        [SELF updateViewWithEvent:SELF.event];
      }
    }
    [SELF.navigationController popViewControllerAnimated:YES];
  };
  [self.navigationController pushViewController:ctrl animated:YES];
}

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
  NSString *resourceBundlePath = [[NSBundle mainBundle] pathForResource:@"ATCalendar" ofType:@"bundle"];
  UIStoryboard* story = [UIStoryboard storyboardWithName:@"Calendar"
                                                  bundle:[NSBundle bundleWithPath:resourceBundlePath]];
  ATDurationEditController* ctrl = [story instantiateViewControllerWithIdentifier:@"ATDurationEditControllerSceneId"];
  ctrl.startDate = self.event.startDate;
  ctrl.endDate = self.event.endDate;
  ctrl.allDay = self.event.allDayValue;
  ctrl.timeZone = self.event.timeZone;
  ctrl.delegate = self;
  [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - Bar Button actions
-(IBAction)cancelButtonAction{
  [self.delegate eventEditBaseController:self
                        didFinishEditing:FALSE];
}

-(IBAction)saveButtonAction{
  [[NSNotificationCenter defaultCenter] postNotificationName:ATEventEditControllerEventWillSaveNotification object:self.event];

  [self updateFromView:self.event];
  [self.delegate eventEditBaseController:self
                        didFinishEditing:TRUE];
  [[NSNotificationCenter defaultCenter] postNotificationName:ATEventEditControllerEventDidSaveNotification object:self.event];
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
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
  return UITableViewCellEditingStyleNone;
}

#pragma mark - Table view delegate
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString *section = [self sectionNameForSection:indexPath.section];
  if (section == ATEventEditBaseSectionRecurrence ) return YES;
  if (section == ATEventEditBaseSectionDate ) return YES;
  if (section == ATEventEditBaseSectionAlert ) return YES;
  if (section == ATEventEditBaseSectionAvilability ) return YES;

  return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString *section = [self sectionNameForSection:indexPath.section];
  if (section == ATEventEditBaseSectionAvilability ) {
    [self.tableView endEditing:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self showAvilabilitySelection];
    });
  }
  if (section == ATEventEditBaseSectionAlert ) {
    if (indexPath.row == 0) { // recurrence type
      [self.tableView endEditing:YES];
      dispatch_async(dispatch_get_main_queue(), ^{
        [self showFirstAlertSelection];
      });
    }
    if (indexPath.row == 1) { // recurrence type
      [self.tableView endEditing:YES];
      dispatch_async(dispatch_get_main_queue(), ^{
        [self showSeccondAlertSelection];
      });
    }
  }
  if (section == ATEventEditBaseSectionDate ) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.tableView endEditing:YES];
      [self showEventDurationSeclection];
    });
  }
  if (section == ATEventEditBaseSectionRecurrence ) {
    if (indexPath.row == 0) { // recurrence type
      [self.tableView endEditing:YES];
      dispatch_async(dispatch_get_main_queue(), ^{
        [self showReccurenceTypeSelection];
      });
    }
    if (indexPath.row == 1) { // recurrence duration
      [self.tableView endEditing:YES];
      dispatch_async(dispatch_get_main_queue(), ^{
        [self showEndReccurenceSelection];
      });
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
    self.event.timeZone = ctrl.timeZone;
    [self updateViewWithEvent:self.event];
  }
  [self.navigationController  popViewControllerAnimated:YES];
}



#pragma mark - UITextFieldDelegate protocol
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  if (textField == self.summaryCell.textField) {
    NSMutableString *newText = [textField.text mutableCopy];
    [newText replaceCharactersInRange:range withString:string];
    if (!ISEMPTYSTRING(newText)) {
      [saveButton_ setEnabled:YES];
    }else{
      [saveButton_ setEnabled:NO];
    }
    return YES;
  }
  
  return YES;
}

@end
