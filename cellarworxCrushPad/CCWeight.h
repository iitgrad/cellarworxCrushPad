//
//  CCWeights.h
//  Crush
//
//  Created by Kevin McQuown on 6/18/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CCWeight : NSObject {

	NSInteger bincount;
	NSInteger weight;
	NSInteger tare;
	NSString *misc;
	NSInteger dbid;
	NSInteger netWeight;
}

@property NSInteger bincount;
@property NSInteger weight;
@property NSInteger tare;
@property (nonatomic, retain) NSString *misc;
@property NSInteger dbid;
@property NSInteger netWeight;

-(id)initWithDictionary:(NSDictionary *)dictionary;
-(id)initWithMeasurementForWT:(NSInteger)wtid theBinCount:(int)newBinCount theWeight:(int)newWeight theTare:(int)newTare;

-(NSString *)description;
-(void)save;
-(void)delete;

@end
