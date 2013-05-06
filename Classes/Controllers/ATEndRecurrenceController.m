//
//  ATEndRecurrenceController.m
//  ATCalendar
//
//  Created by Adrian Tofan on 21/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATEndRecurrenceController.h"
#import "ATCalendarUIConfig.h"
#import "NSBundle+ATCalendar.h"
#define MR_SHORTHAND
#import "CoreData+MagicalRecord.h"

@interface ATEndRecurrenceController (){
  NSDateFormatter *formater_;
}
@property (nonatomic,strong) IBOutlet UIDatePicker *pickerView;
@property (nonatomic) UITableViewCell *dateCell;
@property (nonatomic) UITableViewCell *buttonCell;

@end

@implementation ATEndRecurrenceController
@synthesize pickerView = pickerView_;
@synthesize dateCell = dateCell_;
@synthesize buttonCell = buttonCell_;

-(UITableViewCell*)dateCell{
  if (nil == dateCell_) {
    dateCell_ = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellStyleValue1Id"];
    dateCell_.textLabel.text = ATLocalizedString(@"End repeat", @"End repeat cell label");
    dateCell_.detailTextLabel.text = @"vvv";
    dateCell_.selectionStyle = [[ATCalendarUIConfig sharedConfig] tableViewCellSelectionStyle];
  }
  return dateCell_;
}
-(UITableViewCell*)buttonCell{
  if (nil == buttonCell_) {
        buttonCell_ = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellStyleDefaultId"];
    buttonCell_.textLabel.text = ATLocalizedString(@"Repeat forever", @"");
    buttonCell_.textLabel.textAlignment = NSTextAlignmentCenter;
    buttonCell_.selectionStyle = [[ATCalendarUIConfig sharedConfig] tableViewCellSelectionStyle];

  }
  return buttonCell_;
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
  self.tableView.backgroundView.backgroundColor = [[ATCalendarUIConfig sharedConfig] groupedTableViewBGCollor];
  self.pickerView = [[UIDatePicker alloc] initWithFrame:CGRectZero];
  self.pickerView.datePickerMode = UIDatePickerModeDate;
  [self.pickerView addTarget:self
                      action:@selector(dateChanged:)
            forControlEvents:UIControlEventValueChanged];
  if (!self.endDate) {
    self.endDate = [[NSDate date] mt_endOfCurrentDay];
  }
  self.pickerView.minimumDate = self.minimumDate;
  self.pickerView.date = self.endDate;
  formater_ = [[NSDateFormatter alloc] init];
  formater_.dateStyle = NSDateFormatterLongStyle;
  formater_.timeStyle = NSDateFormatterNoStyle;
  self.title = ATLocalizedString(@"End Repeat", @"End repeat viewcontroller title");
  self.tableView.scrollEnabled = NO;
  self.dateCell.detailTextLabel.text = [formater_ stringFromDate:self.endDate];
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

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  if (self.pickerView.superview == nil)
	{
		[self.view addSubview: self.pickerView];
		
		// size up the picker view to our screen and compute the start/end frame origin for our slide up animation
		//
		// compute the start frame
		CGRect screenRect = [self.view  bounds];
		CGSize pickerSize = [self.pickerView sizeThatFits:CGSizeZero];
		CGRect startRect = CGRectMake(0.0,
                                  screenRect.origin.y + screenRect.size.height,
                                  pickerSize.width, pickerSize.height);
		self.pickerView.frame = startRect;
		
		// compute the end frame
		CGRect pickerRect = CGRectMake(0.0,
                                   screenRect.origin.y + screenRect.size.height - pickerSize.height,
                                   pickerSize.width,
                                   pickerSize.height);
    
    self.pickerView.frame = pickerRect;
    CGRect newFrame = self.tableView.frame;
    newFrame.size.height -= self.pickerView.frame.size.height;
    self.tableView.frame = newFrame;
	}
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

-(IBAction)dateChanged:(id)sender{
  self.endDate = [pickerView_.date mt_endOfCurrentDay];
  self.dateCell.detailTextLabel.text = [formater_ stringFromDate:self.endDate];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.section == 0) {
    return self.dateCell;
  }
  if (indexPath.section == 1) {
    return self.buttonCell;
  }
  return nil;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.section == 1) {
    self.endDate = nil;
    [self saveButtonAction];
  }
}

@end
