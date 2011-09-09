//
//  CCWineStructure.h
//  Crush
//
//  Created by Kevin McQuown on 8/1/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CCWineStructure : NSObject {

	NSMutableArray *appellation;
	NSMutableArray *varietal;
	NSMutableArray *vineyard;
	NSMutableArray *vintage;
}
@property (nonatomic, retain) NSMutableArray *appellation;
@property (nonatomic, retain) NSMutableArray *varietal;
@property (nonatomic, retain) NSMutableArray *vineyard;
@property (nonatomic, retain) NSMutableArray *vintage;

-(id) initWithDictionary:(NSDictionary *)dictionary;
-(id) initWithWineStructure:(CCWineStructure *)theWineStructure;

@end
