//
//  CC702Rollup.h
//  Crush
//
//  Created by Kevin McQuown on 6/27/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CC702SectionJuice;
@class CC702SectionBulk;
@class CC702SectionBottled;
@interface CC702Rollup : NSObject {

	CC702SectionJuice *sectionJuice;
	CC702SectionBulk *sectionBulkBelow;	
	CC702SectionBulk *sectionBulkAbove;	
	CC702SectionBottled *sectionBottledBelow;
	CC702SectionBottled *sectionBottledAbove;
}
@property (retain) CC702SectionJuice *sectionJuice;
@property (retain) CC702SectionBulk *sectionBulkBelow;	
@property (retain) CC702SectionBulk *sectionBulkAbove;	
@property (retain) CC702SectionBottled *sectionBottledBelow;	
@property (retain) CC702SectionBottled *sectionBottledAbove;	

-(id) initWithLots:(NSArray *)lots betweenDate:(NSDate *)startDate andDate:(NSDate *)endDate;

@end
