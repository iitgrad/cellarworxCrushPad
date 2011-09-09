//
//  CC702SectionBottled.h
//  Crush
//
//  Created by Kevin McQuown on 6/28/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CC702Section.h"

@interface CC702SectionBottled : CC702Section {

	float totalBottled;
	NSMutableArray *bottled;
}
@property float totalBottled;
@property (retain) NSMutableArray *bottled;

@end
