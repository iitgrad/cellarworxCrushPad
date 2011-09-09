//
//  CC702.h
//  Crush
//
//  Created by Kevin McQuown on 6/24/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CC702 : NSObject {

	NSMutableArray *history;
	
	int wineState;
	NSMutableArray *volume;
}
@property (retain) NSMutableArray *history;
@property int wineState; 
@property (retain) NSMutableArray *volume;

-(id) initWithWorkOrders:(NSArray *)theWorkOrders;
-(NSArray *)historyBetweenDate:(NSDate *)startDate andDate:(NSDate *)endDate forSection:(int)section;
-(float) startingVolumeForDate:(NSDate *)theDate forSection:(int)section;
-(int) inSectionOnDate:(NSDate *)theDate;
-(NSString *)sectionNameFromNumber:(int)number;

@end
