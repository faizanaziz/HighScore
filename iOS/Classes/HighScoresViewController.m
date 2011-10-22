//
//  HighScoresViewController.m
//  leaderboard
//
//  Created by Faizan Aziz on 22/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HighScoresViewController.h"


@implementation HighScoresViewController

@synthesize highScoreTable, nameField, scoreField;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	highScoresArray = [[NSMutableArray alloc] init];
	
	[self.view addSubview:highScoreTable];
	[highScoreTable release];
	
	activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 20.0, 20.0);
	activityIndicator.center = CGPointMake(159, 286);
	[self.view addSubview:activityIndicator];
	[activityIndicator setHidden:YES];
	[activityIndicator release];
	
	[nameField setDelegate:self];
	
	[self loadLocalScores];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSLog(@"Network error");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

- (IBAction)segmentControl:(id)sender{
	UISegmentedControl *control = (UISegmentedControl*)sender;
	if( [control selectedSegmentIndex] == 0 )
		[self loadGlobalScores];
	else
		[self loadLocalScores];
}

-(void)loadGlobalScores{
	[activityIndicator setHidden:NO];
	[activityIndicator startAnimating];
	[highScoreTable setHidden:YES];

	[HighScores updateGlobalScoresWithArray:highScoresArray completion:^{
		dispatch_async(dispatch_get_main_queue(), ^{
			[highScoreTable reloadData];
			[activityIndicator setHidden:YES];
			[activityIndicator stopAnimating];
			[highScoreTable setHidden:NO];
		});
	}];
}

-(void)loadLocalScores{
	[HighScores setShouldContinueToUpdateGlobal:NO];
	[activityIndicator setHidden:NO];
	[activityIndicator startAnimating];
	[highScoreTable setHidden:YES];
	
	[HighScores updateLocalScoresWithArray:highScoresArray completion:^{
		dispatch_async(dispatch_get_main_queue(), ^{
			[highScoreTable reloadData];
			[highScoreTable setHidden:NO];
			[activityIndicator setHidden:YES];
			[activityIndicator stopAnimating];
		});
	}];
}

-(IBAction)postScore{
	[nameField resignFirstResponder];
	[scoreField resignFirstResponder];
	
	if( [[nameField text] isEqualToString:@""] || [[scoreField text] isEqualToString:@""] ){
		UIAlertView *msg = 	[[UIAlertView alloc] initWithTitle:@"Check data" message:@"Make sure name and score is filled" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[msg show];
		[msg release];
	}
	
	NSMutableArray *temp = [[NSMutableArray alloc] init];
	[temp addObject:[nameField text]];
	[temp addObject:[NSNumber numberWithInt:[[scoreField text] intValue] ] ];
	
	NSMutableArray *temp1 = [[NSMutableArray alloc] init];
	[temp1 addObject:@"name"];
	[temp1 addObject:@"score"];
	
	[HighScores addNewHighScore:[NSDictionary dictionaryWithObjects:temp forKeys:temp1] postGlobally:YES withDelegate:self];
	
	[temp release];
	[temp1 release];
}


//local high scores

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int x = tableView.frame.size.height/44;
	x++;
	if(x>[highScoresArray count])
		return x;
	
	return [highScoresArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *HighScoreCellIdentifier = @"HighScoreCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HighScoreCellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HighScoreCellIdentifier] autorelease];
	}
	
	int row = indexPath.row;
	NSDictionary *highScoreDict = nil;
	if( row < [highScoresArray count] )
		highScoreDict = [highScoresArray objectAtIndex:row];
	if( row%2 != 0)
		cell.backgroundColor = [UIColor colorWithRed:.9f green:.9f blue:.9f alpha:1];
	else
		cell.backgroundColor = [UIColor whiteColor];
	
	if(highScoreDict == nil ){
		cell.textLabel.text = @"";
		cell.detailTextLabel.text = @"";
	}
	else {
		
		cell.detailTextLabel.text = [[highScoreDict objectForKey:@"score"] stringValue];
		
		NSString *temp = [[NSString alloc] initWithFormat:@"%d. %@", row + 1, [highScoreDict objectForKey:@"name"]];
		cell.textLabel.text = temp;
		[temp release];
	}	
	return cell;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	//This is done so that it does not try to update or redraw if the view has already been unloaded
	[HighScores setShouldContinueToUpdateGlobal:NO];
	[self release];
}

- (void)dealloc {
	[activityIndicator removeFromSuperview];
	[highScoreTable removeFromSuperview];
	[highScoresArray release];
	[super dealloc];
}


@end
