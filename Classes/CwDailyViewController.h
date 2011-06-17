//
//  CwDailyViewController.h
//  cw-weather
//
//  Created by Jonathan StJohn
//  Copyright 2011 ClimbingWeather.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CwDailyViewController : UIViewController <UITableViewDelegate> {
	NSMutableArray *days;
	IBOutlet UITableView *dailyTable;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	NSMutableData *responseData;
	int areaId;
	NSString *apiKeyCode;
}

- (void) refreshData;

@end
