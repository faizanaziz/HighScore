//
//  HighScores.h
//  HighScores
//
//  Created by Faizan Aziz on 15/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//	To use this the dictionary must have a key called score

#import <Foundation/Foundation.h>
#import "DDXML.h"
#import "DDXMLElementAdditions.h"

#define DB_SERVER @"http://test.faizanaziz.com/"
#define DB_SECRET @"dbsecret"

@interface HighScores : NSObject {
}

+ (void)addNewHighScore:(NSDictionary *)aScoreDictionary postGlobally:(BOOL)canPostGlobally withDelegate:(id)aDelegate;
+ (void)clearLocalHighScores;

+ (NSString *)highScoresFilePath;
+ (void)updateGlobalScoresWithArray:(NSMutableArray*)aHighScoresArray completion:(void (^) ())aCompletionBlock;
+ (void)updateLocalScoresWithArray:(NSMutableArray*)aHighScoresArray completion:(void (^) ())aCompletionBlock;
+ (void)setShouldContinueToUpdateGlobal:(BOOL)aValue;

@end
