//
//  CCBOL.h
//  Crush
//
//  Created by Kevin McQuown on 6/25/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCFacility.h"
#import "CCActivity.h"

@class CCLot;
@class CCBOLItem;

@interface CCBOL : CCActivity {

    int bolid;
    NSString *taxClass;
    NSString *direction;
	NSString *clientCode;
    CCFacility *facility;
    NSString *carrier;
	CCBOLItem *BOLItem;
	NSMutableArray *bolItems;
}
@property int bolid;
@property (retain) NSString *taxClass;
@property (retain) NSString *direction;
@property (retain) CCFacility *facility;
@property (retain) NSString *carrier;
@property (retain) CCBOLItem *BOLItem;
@property (nonatomic, retain) NSString *clientCode;
@property (nonatomic, retain) NSMutableArray *bolItems;

-(id) initWithDictionary:(NSDictionary *)dictionary withLot:(CCLot *)parentLot;
-(id) initWithClient:(CCClient *)theClient;
-(void) refresh;

-(float) changeInVolume:(CCLot *)theLot;

-(NSString *) description;

-(NSString *)save;
-(void)delete;

@end
