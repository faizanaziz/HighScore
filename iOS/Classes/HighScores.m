//
//  HighScores.m
//  HighScores
//
//  Created by Faizan Aziz on 15/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HighScores.h"


@implementation HighScores

const int MAX_HIGHSCORES = 10;
static BOOL isConnectionStatusActive;
static BOOL shouldContinueToUpdateGlobal;

+ (void)addNewHighScore:(NSDictionary *)aScoreDictionary postGlobally:(BOOL)canPostGlobally withDelegate:(id)aDelegate{
	
	NSNumber *score = [aScoreDictionary objectForKey:@"score"];
	if( score == nil ){
		NSLog(@"Error: the key score must be present in the dictionary, can't add score");
		return;
	}
	
	NSMutableArray *localHighScores = [[NSMutableArray alloc] init];
	[HighScores updateLocalScoresWithArray:localHighScores completion:^{
		int totalScore = [score intValue], tempTotalScore, count = [localHighScores count];
		BOOL didInsert = NO;
		
		for ( int i= 0 ; i < count; i++ ){
			tempTotalScore = [[[localHighScores objectAtIndex:i] objectForKey:@"score"] intValue];
			if(totalScore > tempTotalScore){
				[localHighScores insertObject:aScoreDictionary atIndex:i];
				didInsert = YES;
				break;
			}
		}
		
		if( !didInsert )
			[localHighScores addObject:aScoreDictionary];
		count++;
		
		while( count > MAX_HIGHSCORES ){
			[localHighScores removeLastObject];
			count--;
		}
		
		[localHighScores writeToFile:[HighScores highScoresFilePath] atomically:YES];
		if(canPostGlobally){
			NSString *usrName = [aScoreDictionary objectForKey:@"name"];
			if(usrName == nil){
				NSLog(@"Error: can't post score globally name must be present");
				return;
			}
			usrName = [usrName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			NSString *urlString = [[NSString alloc] initWithFormat:@"%@put_score.php?secret=%@&name=%@&score=%d", DB_SERVER, DB_SECRET, usrName,totalScore];
			NSLog(@"Even more crappy %@", urlString);
			NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
			[NSURLConnection connectionWithRequest:request delegate:aDelegate];
			[urlString release];
		}
		
	}];
	[localHighScores release];
}

+ (void)clearLocalHighScores{
	NSArray *temp = [[NSArray alloc] init];
	[temp writeToFile:[HighScores highScoresFilePath] atomically:YES];
	[temp release];
}

+ (NSString *)highScoresFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"HighScoresFile.plist"];	
}

+ (void)updateLocalScoresWithArray:(NSMutableArray*)aHighScoresArray completion:(void (^) ())aCompletionBlock{
	[aHighScoresArray removeAllObjects];
	
	NSArray *tHighScoresArray = [[NSArray alloc] initWithContentsOfFile:[HighScores highScoresFilePath]];
	[aHighScoresArray addObjectsFromArray:tHighScoresArray];
	[tHighScoresArray release];
	
	aCompletionBlock();
}

+ (void)updateGlobalScoresWithArray:(NSMutableArray*)aHighScoresArray completion:(void (^) ())aCompletionBlock{
	if (!isConnectionStatusActive) {
		isConnectionStatusActive = YES;
		shouldContinueToUpdateGlobal = YES;
		
		dispatch_queue_t internetQ = dispatch_queue_create("com.yourcompany.internet.queue", NULL);
		
		dispatch_async(internetQ, ^{
			NSString *urlString = [[NSString alloc] initWithFormat:@"%@get_score.php", DB_SERVER];
			NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
			
			NSData *tHighScores = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
			[urlString release];
			
			if(tHighScores == NULL)
				NSLog(@"Error");
			else if(shouldContinueToUpdateGlobal){
				NSString *highScoresRawXML = [[NSString alloc] initWithData:tHighScores encoding:NSUTF8StringEncoding];
				[aHighScoresArray removeAllObjects];
				
				DDXMLElement *highScoresXML = [[DDXMLElement alloc] initWithXMLString:highScoresRawXML error:nil];
				NSArray *highScoresArray = [highScoresXML elementsForName:@"highscore"];
				
				for (DDXMLElement *highScore in highScoresArray){
					NSMutableDictionary *tDict = [[NSMutableDictionary alloc] init];
					[tDict setObject:[[highScore elementForName:@"name"] stringValue] forKey:@"name"];
					[tDict setObject:[NSNumber numberWithInt:[[[highScore elementForName:@"score"] stringValue] intValue]] forKey:@"score"];
					[tDict setObject:[[highScore elementForName:@"rank"] stringValue] forKey:@"rank"];
					[aHighScoresArray addObject:tDict];
					[tDict release];
				}
				[highScoresRawXML release];
				[highScoresXML release];
				aCompletionBlock();
			}
			
			isConnectionStatusActive = NO;
			dispatch_release(internetQ);
			
		});
	}
}

+ (void)setShouldContinueToUpdateGlobal:(BOOL)aValue{
	shouldContinueToUpdateGlobal = aValue;
}
	
@end
