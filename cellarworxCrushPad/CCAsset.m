//
//  CCAsset.m
//  Crush
//
//  Created by Kevin McQuown on 6/30/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCAsset.h"
#import "CrushHelper.h"


@implementation CCAsset

@synthesize name,desc,capacity,owner,location,type,dbid,cylinderDiameter, cylinderHeight,coneHeight,capHeight,capDiameter,initialGallons;

-(id)initWithDictionary:(NSDictionary *)dictionary{
	
	self.name=[dictionary objectForKey:@"NAME"];
	self.desc=[CrushHelper blankIfNull:[dictionary objectForKey:@"DESCRIPTION"]];
	self.type=[dictionary objectForKey:@"TYPENAME"];
	self.owner=[dictionary objectForKey:@"OWNER"];
	self.location=[CrushHelper blankIfNull:[dictionary objectForKey:@"LOCATION"]];
	self.dbid=[dictionary objectForKey:@"ASSETID"];
	if ([[NSNull null] isEqual: [dictionary objectForKey:@"CAPACITY"]])
		capacity=[[NSNumber alloc] initWithFloat:0];
	else
		capacity=[[NSNumber alloc] initWithFloat:[[dictionary objectForKey:@"CAPACITY"] floatValue]];
	if ([[NSNull null] isEqual: [dictionary objectForKey:@"CYLINDERHEIGHT"]])
		cylinderHeight=[[NSNumber alloc] initWithFloat:0.0];
	else
		cylinderHeight=[[NSNumber alloc] initWithFloat:[[dictionary objectForKey:@"CYLINDERHEIGHT"] floatValue]];
	if ([[NSNull null] isEqual: [dictionary objectForKey:@"INITIALGALLONS"]])
		initialGallons=[[NSNumber alloc] initWithFloat:0.0];
	else
		initialGallons=[[NSNumber alloc] initWithFloat:[[dictionary objectForKey:@"INITIALGALLONS"] floatValue]];
	if ([[NSNull null] isEqual: [dictionary objectForKey:@"CYLINDERDIAMETER"]])
		cylinderDiameter=[[NSNumber alloc] initWithFloat:0.0];
	else
		cylinderDiameter=[[NSNumber alloc] initWithFloat:[[dictionary objectForKey:@"CYLINDERDIAMETER"] floatValue]];
	
	capDiameter=[[NSNumber alloc] initWithFloat:[[dictionary objectForKey:@"LIDDIAMETER"] floatValue]];
	capHeight=[[NSNumber alloc] initWithFloat:[[dictionary objectForKey:@"TANKCAPHEIGHT"] floatValue]];
	coneHeight=[[NSNumber alloc] initWithFloat:[[dictionary objectForKey:@"CONEHEIGHT"] floatValue]];
	return self;
}
-(NSString *)description
{
	NSString *desc2=[NSString stringWithFormat:@"%@ - %@",name,owner];
	return desc2;
}
//-(float) volumeWithHeight2:(float)height
//{
//	float vol=pow([cylinderDiameter floatValue]/2.0,2)*kPI*height;
//	return vol;
//}
//-(float) volumeByDipLength:(float)length
//{
//}
-(float) gallonsByDipLength:(float)length
{	
	float theLength=length;
	float newCapHeight=[capHeight floatValue];
	float newConeHeight=[coneHeight floatValue];
	float newCyclinderHeight=[cylinderHeight floatValue];
	if (theLength>=[capHeight floatValue]) {
		theLength-=[capHeight floatValue];
		newCapHeight=0;
	}
	else {
		newCapHeight=newCapHeight-theLength;
		theLength=0;
	}
	if (theLength>=[coneHeight floatValue]) {
		theLength-=[coneHeight floatValue];
		newConeHeight=0;
	}
	else {
		newConeHeight=newConeHeight-theLength;
		theLength=0;
	}
	newCyclinderHeight=newCyclinderHeight-theLength;
//		theLength-=([cylinderHeight floatValue]-newCyclinderHeight);
	
	float vol=[CrushHelper calculateTankVolumeWithDiameter:[cylinderDiameter floatValue]
												 andHeight:newCyclinderHeight
											 andConeHeight:newConeHeight
										  andTankCapHeight:newCapHeight
											andLidDiameter:[capDiameter floatValue]]+[self.initialGallons floatValue];
	//	float vol=pow([cylinderDiameter floatValue]/2.0,2)*kPI*([cylinderHeight floatValue]-length);
	return vol;	
}

- (NSNumber *)capacity
{
	 return [NSNumber numberWithFloat:[self gallonsByDipLength:0]];
}
- (float) gallonsByCylinderOnly
{
	return [CrushHelper calculateTankVolumeWithDiameter:[cylinderDiameter floatValue]
											  andHeight:[cylinderHeight floatValue]
										  andConeHeight:0 
									   andTankCapHeight:0 
										 andLidDiameter:0];
}
- (void) dealloc
{
	[initialGallons release];
	[capHeight release];
	[coneHeight release];
	[capDiameter release];
    [name release];
    [desc release];
    [capacity release];
    [owner release];
    [location release];
    [cylinderDiameter release];
    [cylinderHeight release];
    [type release];
    [dbid release];
    
    [super dealloc];
}

//-(id)initWithName:(NSString *)theName
//{
//	if (self=[super init]) {
//		self.name=[[NSString alloc] initWithString:theName];
//		self.dbid=@"";
//		self.owner=@"";
//		self.capacity=[[NSNumber alloc] initWithInt:<#(int)value#>;
//	}
//	return self;
//}


@end
