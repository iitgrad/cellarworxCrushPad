//
//  CCTest.h
//  Crush
//
//  Created by Kevin McQuown on 6/27/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCLabTest.h"

@class CCWorkOrder;
@class CCLabTest;

@interface CCTest : NSObject {

	NSString *test;
	float value;
	NSString *units;
	NSString *dbid;
	
	CCLabTest *labTest;
}

@property (nonatomic, retain) NSString *test;
@property  float value;
@property (nonatomic, retain) NSString *units;
@property (nonatomic, retain) NSString *dbid;

@property (nonatomic, assign) CCLabTest *labTest;

-(id)initWithDictionary:(NSDictionary *)dict fromLabTest:(CCLabTest *)lt;
-(CCTest *)initWithLabTest:(CCLabTest *)lt;
-(BOOL)inRange;
-(float)minimumValue;
-(float)maximumValue;
-(NSString *)unitsDescription;
-(NSString *)formatDescription;

-(void)save;
-(void)delete;


-(NSString *)description;

@end
