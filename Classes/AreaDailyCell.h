//
//  AreaDailyCell.h
//  cw-weather
//
//  Created by Jonathan StJohn
//  Copyright 2011 ClimbingWeather.com. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface AreaDailyCell : UITableViewCell {
	UILabel *dayLabel;
	UILabel *dateLabel;
	UILabel *highLabel;
	UILabel *lowLabel;
	UILabel *precipDayLabel;
	UILabel *precipNightLabel;
	UILabel *windLabel;
	UILabel *humLabel;
	UILabel *conditionsLabel;
	UIImageView *iconImage;
}

@property (nonatomic, retain) UILabel *dayLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *highLabel;
@property (nonatomic, retain) UILabel *lowLabel;

@property (nonatomic, retain) UILabel *precipDayLabel;
@property (nonatomic, retain) UILabel *precipNightLabel;
@property (nonatomic, retain) UILabel *windLabel;
@property (nonatomic, retain) UILabel *humLabel;

@property (nonatomic, retain) UILabel *conditionsLabel;
@property (nonatomic, retain) UIImageView *iconImage;


@end