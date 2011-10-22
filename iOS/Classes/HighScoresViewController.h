//
//  HighScoresViewController.h
//  leaderboard
//
//  Created by Faizan Aziz on 22/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighScores.h"

@interface HighScoresViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	IBOutlet UITableView *highScoreTable;
	NSMutableArray *highScoresArray;
	UIActivityIndicatorView *activityIndicator;
	
	IBOutlet UITextField *nameField, *scoreField;
}

@property (nonatomic, retain) UITableView *highScoreTable;
@property (nonatomic, retain) UITextField *scoreField;
@property (nonatomic, retain) UITextField *nameField;

-(void)loadGlobalScores;
-(void)loadLocalScores;

- (IBAction)postScore;
- (IBAction)segmentControl:(id)sender;

@end
