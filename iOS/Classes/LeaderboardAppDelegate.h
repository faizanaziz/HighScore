//
//  LeaderboardAppDelegate.h
//  Leaderboard
//
//  Created by Faizan Aziz on 28/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HighScoresViewController;

@interface LeaderboardAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	HighScoresViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

