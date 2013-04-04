//
//  ATDurationEditController.m
//  ATCalendar
//
//  Created by Adrian Tofan on 19/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATDurationEditController.h"
#import "ATTZPickerController.h"
#import "ATCalendarUIConfig.h"
#import "ATCalendarUIConfig.h"


typedef enum{
  ATDurationEditControllerEditElementStart,
  ATDurationEditControllerEditElementEnd
} ATDurationEditControllerEditElement;
@interface ATDurationEditController (){
  
  IBOutlet UILabel *startDateLabel_;
  IBOutlet UILabel *endDateLabel_;
  IBOutlet UIDatePicker *picker_;
  IBOutlet UISwitch *allDaySwitch_;
  IBOutlet UILabel *timeZoneLabel_;
  NSDateFormatter* dateTimeFormatter_;
  NSDateFormatter* dateFormatter_;
  ATDurationEditControllerEditElement edigingElement_;
}

@end

@implementation ATDurationEditController
@synthesize startDate = startDate_;
@synthesize endDate = endDate_;
@synthesize timeZone = timeZone_;



- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
  self.tableView.backgroundView.backgroundColor = [[ATCalendarUIConfig sharedConfig] groupedTableViewBGCollor];
  startDateLabel_.textColor = [[ATCalendarUIConfig sharedConfig] tableViewCellDetailLabelCollor];
  endDateLabel_.textColor = [[ATCalendarUIConfig sharedConfig] tableViewCellDetailLabelCollor];
  timeZoneLabel_.textColor = [[ATCalendarUIConfig sharedConfig] tableViewCellDetailLabelCollor];

  edigingElement_ = ATDurationEditControllerEditElementStart;
  dateTimeFormatter_ = [[NSDateFormatter alloc] init];
  [dateTimeFormatter_ setTimeStyle:NSDateFormatterShortStyle];
  [dateTimeFormatter_ setDateStyle:NSDateFormatterMediumStyle];
  dateFormatter_ = [[NSDateFormatter alloc] init];
  [dateFormatter_ setTimeStyle:NSDateFormatterNoStyle];
  [dateFormatter_ setDateStyle:NSDateFormatterMediumStyle];
  dateFormatter_.timeZone = timeZone_;
  dateTimeFormatter_.timeZone = timeZone_;
//  picker_.locale = [NSLocale currentLocale];
  picker_.date = startDate_;
  allDaySwitch_.on = self.allDay;
  if (self.allDay) {
    picker_.datePickerMode = UIDatePickerModeDate;
  }else{
    picker_.datePickerMode = UIDatePickerModeDateAndTime;
  }
  [self updateTimeZone:timeZone_];
  [self updateDatesToLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
  if (cell.selectionStyle != UITableViewCellSelectionStyleNone) {
    cell.selectionStyle = [[ATCalendarUIConfig sharedConfig] tableViewCellSelectionStyle];
  }
  return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{  
  if (indexPath.row == 0) {
    edigingElement_ = ATDurationEditControllerEditElementStart;
    [self updateDatesToPicker];
  }else
  if (indexPath.row == 1) {
    edigingElement_ = ATDurationEditControllerEditElementEnd;
    [self updateDatesToPicker];
  }else if (indexPath.row == 3){
    [self showTimeZonePicker];
  }
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.row == 2) {
    return NO;
  }
  return YES;
}


#pragma mark -


-(void)updateTimeZone:(NSTimeZone*) timeZone{
  NSTimeZone *current             = timeZone_;
  NSTimeInterval currentOffset    = [current secondsFromGMTForDate:startDate_];
  NSTimeInterval toOffset         = [timeZone secondsFromGMTForDate:startDate_];
  NSTimeInterval diff             = currentOffset - toOffset;
  startDate_ = [startDate_ dateByAddingTimeInterval:diff];
  currentOffset    = [current secondsFromGMTForDate:endDate_];
  toOffset         = [timeZone secondsFromGMTForDate:endDate_];
  diff             = currentOffset - toOffset;
  endDate_ = [endDate_ dateByAddingTimeInterval:diff];

  self.timeZone = timeZone;
  picker_.timeZone = timeZone;
  timeZoneLabel_.text = [timeZone name];
  timeZone_ = timeZone;
  dateFormatter_.timeZone = timeZone_;
  dateTimeFormatter_.timeZone = timeZone_;
  [self updateDatesToPicker];
  [self updateDatesToLabels];
}

-(void)showTimeZonePicker{
  ATTZPickerController *picker  = [[ATTZPickerController alloc] initWithStyle:UITableViewStylePlain];
  picker.timeZone = self.timeZone;
  __weak ATTZPickerController * P = picker;
  __weak typeof (self) SELF = self;
  picker.endBlock = ^(BOOL save){
    if (save) {
      [SELF updateTimeZone:P.timeZone];
    }
    [SELF dismissViewControllerAnimated:YES completion:nil];
  };
  [self presentViewController:[[UINavigationController alloc] initWithRootViewController:picker]  animated:YES completion:nil];
}

-(void)updateDatesToLabels{
  NSDateFormatter* formater = self.allDay ? dateFormatter_:dateTimeFormatter_;
  startDateLabel_.text = [formater stringFromDate:startDate_];
  endDateLabel_.text = [formater stringFromDate:endDate_];
}

-(void)updateDatesFromPicker{
  UIColor* c = [[ATCalendarUIConfig sharedConfig] tableViewCellDetailLabelCollor];
  NSInteger timeSpan = [endDate_ timeIntervalSinceDate:startDate_];
  if (edigingElement_ == ATDurationEditControllerEditElementStart) {
    startDate_ = picker_.date;
    if ([startDate_ mt_isAfter:endDate_]) {
      endDate_ = [startDate_ dateByAddingTimeInterval:timeSpan];
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;
    startDateLabel_.textColor = c;
    endDateLabel_.textColor = c;

  }
  if (edigingElement_ == ATDurationEditControllerEditElementEnd) {
    endDate_ = picker_.date;
    if ([startDate_ mt_isAfter:endDate_]) {
      self.navigationItem.rightBarButtonItem.enabled = NO;
      startDateLabel_.textColor = [UIColor redColor];
      endDateLabel_.textColor = [UIColor redColor];
    }else{
      self.navigationItem.rightBarButtonItem.enabled = YES;
      startDateLabel_.textColor = c;
      endDateLabel_.textColor = c;
    }
  }
  [self updateDatesToLabels];
}
-(void)updateDatesToPicker{
  switch (edigingElement_) {
    case ATDurationEditControllerEditElementStart:picker_.date = startDate_; break;
    case ATDurationEditControllerEditElementEnd:picker_.date = endDate_; break;
  }
}


#pragma mark -  Button actions
- (IBAction)allDayButtonAction:(id)sender {
  if (allDaySwitch_.on) {
    if (!self.allDay) {
      self.allDay = TRUE;
      startDate_ = [startDate_ mt_startOfCurrentDay];
      endDate_ = [endDate_ mt_endOfCurrentDay];
      picker_.datePickerMode = UIDatePickerModeDate;
    }
  }else{
    if (self.allDay) {
      self.allDay = NO;
      startDate_ = [NSDate date];
      endDate_ = [startDate_ mt_oneHourNext];
      picker_.datePickerMode = UIDatePickerModeDateAndTime;
    }
  }
  [self updateDatesToLabels];
  [self updateDatesToPicker];
}

- (IBAction)dateChanged:(id)sender {
  [self updateDatesFromPicker];
}

- (IBAction)cancelButtonAction:(id)sender {
  [self.delegate durationEditController:self didFinishWithSave:NO];
}
- (IBAction)saveButtonAction:(id)sender {
  if ([startDate_ mt_isAfter:endDate_]) {
    UIAlertView *allert =
    [[UIAlertView alloc] initWithTitle:NSLocalizedString(
 @"Cannot save event",@"")
                                message:NSLocalizedString(@"The start date must be before the end date",@"")
                               delegate:nil
                     cancelButtonTitle:NSLocalizedString(@"OK", @"OK button text")
                     otherButtonTitles:nil];
    [allert show];
  }else{
    [self.delegate durationEditController:self didFinishWithSave:YES];
  }
}

@end
