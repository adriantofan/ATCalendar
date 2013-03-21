//
//  ATDurationEditController.m
//  ATCalendar
//
//  Created by Adrian Tofan on 19/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATDurationEditController.h"
typedef enum{
  ATDurationEditControllerEditElementStart,
  ATDurationEditControllerEditElementEnd
} ATDurationEditControllerEditElement;
@interface ATDurationEditController (){
  
  IBOutlet UILabel *startDateLabel_;
  IBOutlet UILabel *endDateLabel_;
  IBOutlet UIDatePicker *picker_;
  IBOutlet UISwitch *allDaySwitch_;
  NSDateFormatter* dateTimeFormatter_;
  NSDateFormatter* dateFormatter_;

  ATDurationEditControllerEditElement edigingElement_;
}

@end

@implementation ATDurationEditController
@synthesize startDate = startDate_;
@synthesize endDate = endDate_;

- (void)viewDidLoad
{
  [super viewDidLoad];
  edigingElement_ = ATDurationEditControllerEditElementStart;
  dateTimeFormatter_ = [[NSDateFormatter alloc] init];
  [dateTimeFormatter_ setTimeStyle:NSDateFormatterShortStyle];
  [dateTimeFormatter_ setDateStyle:NSDateFormatterMediumStyle];
  dateFormatter_ = [[NSDateFormatter alloc] init];
  [dateFormatter_ setTimeStyle:NSDateFormatterNoStyle];
  [dateFormatter_ setDateStyle:NSDateFormatterMediumStyle];
  picker_.locale = [NSLocale currentLocale];
  picker_.date = startDate_;
  allDaySwitch_.on = self.allDay;
  if (self.allDay) {
    picker_.datePickerMode = UIDatePickerModeDate;
  }else{
    picker_.datePickerMode = UIDatePickerModeDateAndTime;
  }
  [self updateDatesToLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.row == 0) {
    edigingElement_ = ATDurationEditControllerEditElementStart;
  }else
  if (indexPath.row == 1) {
    edigingElement_ = ATDurationEditControllerEditElementEnd;
  }else {return;}
  [self updateDatesToPicker];
}

#pragma mark -
-(void)updateDatesToLabels{
  NSDateFormatter* formater = self.allDay ? dateFormatter_:dateTimeFormatter_;
  startDateLabel_.text = [formater stringFromDate:startDate_];
  endDateLabel_.text = [formater stringFromDate:endDate_];
}

-(void)updateDatesFromPicker{
  NSInteger timeSpan = [endDate_ timeIntervalSinceDate:startDate_];
  if (edigingElement_ == ATDurationEditControllerEditElementStart) {
    startDate_ = picker_.date;
    if ([startDate_ isAfter:endDate_]) {
      endDate_ = [startDate_ dateByAddingTimeInterval:timeSpan];
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;
    startDateLabel_.textColor = [UIColor blackColor];
    endDateLabel_.textColor = [UIColor blackColor];

  }
  if (edigingElement_ == ATDurationEditControllerEditElementEnd) {
    endDate_ = picker_.date;
    if ([startDate_ isAfter:endDate_]) {
      self.navigationItem.rightBarButtonItem.enabled = NO;
      startDateLabel_.textColor = [UIColor redColor];
      endDateLabel_.textColor = [UIColor redColor];
    }else{
      self.navigationItem.rightBarButtonItem.enabled = YES;
      startDateLabel_.textColor = [UIColor blackColor];
      endDateLabel_.textColor = [UIColor blackColor];
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
      startDate_ = [startDate_ startOfCurrentDay];
      endDate_ = [endDate_ endOfCurrentDay];
      picker_.datePickerMode = UIDatePickerModeDate;
    }
  }else{
    if (self.allDay) {
      self.allDay = NO;
      startDate_ = [NSDate date];
      endDate_ = [startDate_ oneHourNext];
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
  if ([startDate_ isAfter:endDate_]) {
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
