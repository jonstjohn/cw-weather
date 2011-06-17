//
//  CwDailyViewController.m
//  cw-weather
//
//  Created by Jonathan StJohn
//  Copyright 2011 ClimbingWeather.com. All rights reserved.
//

#import "CwDailyViewController.h"
#import "AreaDailyCell.h"
#import "JSON.h"


@implementation CwDailyViewController

- (id) init
{	
	days = [[NSMutableArray alloc] initWithObjects: nil];
	
	[[self navigationItem] setTitle: @"NRG Weather"];
	areaId = 3; // ClimbingWeather.com area id
	apiKeyCode = @"aw"; // specified by ClimbingWeather.com
	
	// Create refresh button
	UIBarButtonItem *iButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
	[[self navigationItem] setRightBarButtonItem: iButton];
	[iButton release];
	
	return self;
}

- (void) viewDidLoad
{
	
	[super viewDidLoad];
	
	float inset = 2.0;
	float columnSpacing = 10.0;
	
	float dayX = inset;
	float dayWidth = 50.0;
	
	float iconX = dayX + dayWidth + columnSpacing;
	float iconWidth = 40.0;
	
	float highX = iconX + iconWidth + columnSpacing;
	float highWidth = 50.0;
	
	float precipX = highX + highWidth + columnSpacing;
	float precipWidth = 50.0;
	
	float windX = precipX + precipWidth + columnSpacing;
	float windWidth = 60.0;
	
	float fontSize = 10.0;
	float rowHeight = fontSize + inset * 2.0;
	
	// Set table header
	UIView *containerView = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 300, rowHeight)] autorelease];
	[containerView setBackgroundColor: [[UIColor lightGrayColor] colorWithAlphaComponent: 0.5]];

	UILabel *dayLabel = [[[UILabel alloc] initWithFrame: CGRectMake(dayX, inset, dayWidth, fontSize)] autorelease];
	[dayLabel setText: @"Forecast"];
	[dayLabel setBackgroundColor:[UIColor clearColor]];
	[dayLabel setFont: [UIFont systemFontOfSize: fontSize]];
	[dayLabel setTextAlignment: UITextAlignmentCenter];
	[containerView addSubview: dayLabel];
	
	UILabel *highLabel = [[[UILabel alloc] initWithFrame: CGRectMake(highX, inset, highWidth, fontSize)] autorelease];
	[highLabel setText: @"High/Low"];
	[highLabel setBackgroundColor:[UIColor clearColor]];
	[highLabel setFont: [UIFont systemFontOfSize: fontSize]];
	[highLabel setTextAlignment: UITextAlignmentCenter];
	[containerView addSubview: highLabel];
	
	UILabel *precipLabel = [[[UILabel alloc] initWithFrame: CGRectMake(precipX, inset, precipWidth, fontSize)] autorelease];
	[precipLabel setText: @"Precip"];
	[precipLabel setBackgroundColor:[UIColor clearColor]];
	[precipLabel setFont: [UIFont systemFontOfSize: fontSize]];
	[precipLabel setTextAlignment: UITextAlignmentCenter];
	[containerView addSubview: precipLabel];
	
	UILabel *windLabel = [[[UILabel alloc] initWithFrame: CGRectMake(windX, inset, windWidth, fontSize)] autorelease];
	[windLabel setText: @"Wind/Hum"];
	[windLabel setBackgroundColor:[UIColor clearColor]];
	[windLabel setFont: [UIFont systemFontOfSize: fontSize]];
	[windLabel setTextAlignment: UITextAlignmentCenter];
	[containerView addSubview: windLabel];
	
	[dailyTable setTableHeaderView: containerView];
}

- (void) viewWillAppear:(BOOL)animated
{
	[self refreshData];	
	[super viewWillAppear: animated];
}
/*
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear: animated];
}
 */

- (void) refreshData
{
	[dailyTable setHidden: YES];
	[[self view] bringSubviewToFront: activityIndicator]; 
	[activityIndicator startAnimating];
	
	// Send request for JSON data
	responseData = [[NSMutableData data] retain];
	
	NSString *url = [NSString stringWithFormat: @"http://api.climbingweather.com/api/area/daily/%d?apiKey=iphone-%@-%@",
					 areaId, apiKeyCode, [[UIDevice currentDevice] uniqueIdentifier]];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];	
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
	return [days count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
	AreaDailyCell *cell = (AreaDailyCell *)[tableView dequeueReusableCellWithIdentifier: @"AreaDailyCell"];
	
	if (!cell) {
		cell = [[[AreaDailyCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"AreaDailyCell"] autorelease];
	}
	NSString *high = [[days objectAtIndex: [indexPath row]] objectForKey: @"hi"];
	NSString *low = [[days objectAtIndex: [indexPath row]] objectForKey: @"l"];
	NSString *conditions = [[days objectAtIndex: [indexPath row]] objectForKey: @"c"];
	
	[[cell dayLabel] setText: [[days objectAtIndex: [indexPath row]] objectForKey: @"dy"]]; // @"test"];
	[[cell dateLabel] setText: [[days objectAtIndex: [indexPath row]] objectForKey: @"dd"]];
	[[cell highLabel] setText: [NSString stringWithFormat: @"%@˚", high]];
	[[cell lowLabel] setText: [NSString stringWithFormat: @"%@˚", low]];
	[[cell precipDayLabel] setText: [NSString stringWithFormat: @"%@%%", [[days objectAtIndex: [indexPath row]] objectForKey: @"pd"]]];
	[[cell precipNightLabel] setText: [NSString stringWithFormat: @"%@%%", [[days objectAtIndex: [indexPath row]] objectForKey: @"pn"]]];
	[[cell windLabel] setText: [NSString stringWithFormat: @"%@ mph", [[days objectAtIndex: [indexPath row]] objectForKey: @"ws"]]];
	[[cell humLabel] setText: [NSString stringWithFormat: @"%@%%", [[days objectAtIndex: [indexPath row]] objectForKey: @"h"]]];
	[[cell conditionsLabel] setText: conditions];
	if ([conditions length] == 0) {
		[[cell conditionsLabel] setHidden: YES];
	} else {
		[[cell conditionsLabel] setHidden: NO];
	}
	
	[[cell iconImage] setImage: [UIImage imageNamed: [NSString stringWithFormat: @"%@.png", [[days objectAtIndex: [indexPath row]] objectForKey: @"sy"]]]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return cell;
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
	// Increase row height if conditions string is present
	if ([[[days objectAtIndex: [indexPath row]] objectForKey: @"c"] length] == 0) {
		return 53.0;
	} else {
		return 68.0;
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[activityIndicator stopAnimating];
	[dailyTable setHidden: NO];
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"Network Connection Failure" message:@"Please try again when your network connection is restored." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
	
	NSDictionary *data = [responseString JSONValue];
	NSDictionary *daysJson = [data objectForKey: @"results"];
	
	[days removeAllObjects];
	
	NSArray *forecastJson = [daysJson objectForKey: @"f"];
	
	for (int i = 0; i < [forecastJson count]; i++) {
		[days addObject: [forecastJson objectAtIndex: i]];
	}
	
	[responseString release];
	
	[activityIndicator stopAnimating];
	[dailyTable setHidden: NO];
	[dailyTable reloadData];
	
}


- (void)dealloc {
	[days release];
	[responseData release];
    [super dealloc];
}


@end
