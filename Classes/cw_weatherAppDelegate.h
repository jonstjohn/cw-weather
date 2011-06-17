//
//  cw_weatherAppDelegate.h
//  cw-weather
//
//  Created by Jonathan StJohn
//  Copyright 2011 ClimbingWeather.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cw_weatherAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

