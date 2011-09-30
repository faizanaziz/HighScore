//
//  HighScoresViewController.h
//  leaderboard
//
//  Created by Faizan Aziz on 22/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighScores.h"

@interface HighScoresViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *highScoreTable;
	NSMutableArray *highScoresArray;
	UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) UITableView *highScoreTable;

-(IBAction)loadGlobalScores;
-(IBAction)loadLocalScores;
-(IBAction)postScore;

@end
