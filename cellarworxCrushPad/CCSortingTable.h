//
//  CCSortingTable.h
//  Crush
//
//  Created by Kevin McQuown on 7/19/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCSortingTableActivity;
@class CCSCP;
@interface CCSortingTable : NSObject {

	NSMutableArray *activities;
	
@private
	BOOL serverContacted;
	NSLock *refreshInProgress;
}
@property (nonatomic, retain) NSMutableArray *activities;

-(id) init;
-(void) addActivity:(CCSortingTableActivity *)theActivity;
-(void) removeActivity:(CCSortingTableActivity *)theActivity;
-(void) calculateTableSchedule;
-(void) moveRow:(int)sourceRow toRow:(int)destinationRow;
-(void) startedTopMostActivity;
-(void) completeTopMostActivity;
-(void) initFromServerWithRefresh:(BOOL)refresh;
-(void) refreshLotLinks;
-(BOOL) hasSCP:(CCSCP *)theSCP;
-(void) deleteActivityForSCP:(CCSCP *)theSCP;

@end
