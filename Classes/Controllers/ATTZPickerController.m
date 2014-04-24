//
//  ATTZPickerController.m
//  ATCalendar
//
//  Created by Adrian Tofan on 28/03/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATTZPickerController.h"
#import "ATCalendarUIConfig.h"
#import "NSBundle+ATCalendar.h"
#import "NSDate+MTDates.h"
#import "NSArray+F.h"


@interface ATTZPickerController ()
@property (nonatomic) NSArray* timeZoneNames;
@property (nonatomic) NSArray* allTimeZoneNames;
@property (nonatomic) NSString* filter;

@end

@implementation ATTZPickerController
static NSString *CellIdentifier = @"Cell";

@synthesize timeZoneNames = timeZoneNames_;
@synthesize allTimeZoneNames = allTimeZoneNames_;

-(NSArray*)allTimeZoneNames{
  if (nil == allTimeZoneNames_) {
    allTimeZoneNames_ = [NSTimeZone knownTimeZoneNames];
  }
  return allTimeZoneNames_;
}

-(NSArray*)timeZoneNames{
  if (nil == timeZoneNames_) {
    timeZoneNames_ = [self.allTimeZoneNames filter:^BOOL(NSString* obj) {
      return [obj rangeOfString:self.filter options:NSCaseInsensitiveSearch].location != NSNotFound;
    }];
  }
  return timeZoneNames_;
}

- (void)viewDidLoad
{

  [super viewDidLoad];
  UIBarButtonItem* cancel = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                             target:self
                             action:@selector(cancelButtonAction)];
  [self.navigationController setNavigationBarHidden:NO];
  self.navigationItem.prompt = ATLocalizedString(@"Type a city name",@"Time zone selection controller name");
  self.navigationItem.rightBarButtonItem = cancel;
  UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 240, 40)] ;
  searchBar.backgroundImage = [[UIImage alloc] init];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
  searchBar.text = [self.timeZone name];
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
  self.filter = searchBar.text;
  searchBar.delegate = self;
}

-(IBAction)cancelButtonAction{
  if (self.endBlock) {
    self.endBlock(NO);
  }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [self.timeZoneNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  cell.textLabel.text = [self.timeZoneNames objectAtIndex:indexPath.row];
  cell.selectionStyle = [[ATCalendarUIConfig sharedConfig] tableViewCellSelectionStyle];
    return cell;
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
  self.filter = searchText;
  timeZoneNames_ = nil;
  [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  self.timeZone = [NSTimeZone timeZoneWithName:[self.timeZoneNames objectAtIndex:indexPath.row]];
  if (self.endBlock) {
    self.endBlock(YES);
  }
}

@end
