//
//  CCBlend.h
//  Crush
//
//  Created by Kevin McQuown on 7/2/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCWorkOrder;

@interface CCBlend : NSObject {
	
	NSString *sourceLot;
	float gallons;
	NSString *direction;
	NSString *comment;
	NSString *blendID;
	NSString *endState;
	NSString *woID;
	NSString *dbid;
}

@property (nonatomic, retain) NSString *sourceLot;
@property float gallons;
@property (nonatomic, retain) NSString *direction;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSString *blendID;
@property (nonatomic, retain) NSString *endState;
@property (nonatomic, retain) NSString *woID;
@property (nonatomic, retain) NSString *dbid;

//-(id) initFromDictionary:(NSDictionary *)dict;
-(id) initWithDictionary:(NSDictionary *)dict;
-(id) initWithWorkOrder:(CCWorkOrder *)wo;

-(void)save;
-(void)delete;

@end
