//
//  sortingTable.h
//  Crush
//
//  Created by Kevin McQuown on 7/19/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCSCP;
@interface CCSortingTableActivity : NSObject {

	int dbid;
	CCSCP *scp;
	NSMutableArray *weighTags;
	NSDate *estimatedTimeOnTable;
	NSDate *fixedStartTime;
	NSDate *day;
	int sequenceNumber;
	BOOL onTable;
	BOOL completed;
}
@property int dbid;
@property (nonatomic, retain) CCSCP *scp;
@property (nonatomic, retain) NSMutableArray *weighTags;
@property (nonatomic, retain) NSDate *estimatedTimeOnTable;
@property (nonatomic, retain) NSDate *day;
@property (nonatomic, retain) NSDate *fixedStartTime;
@property int sequenceNumber;
@property BOOL onTable;
@property BOOL completed;

-(id) initWithSCP:(CCSCP *)theSCP onDay:(NSDate *)theDate;
-(id) initWithDictionary:(NSDictionary *)dict;

-(void) completeWithPushNotification:(BOOL)sendPushNotification;
-(void) deleteWithPushNotification:(BOOL)sendPushNotification;
-(void) saveWithPushNotification:(BOOL)sendPushNotification;

@end
