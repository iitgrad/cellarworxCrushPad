//
//  CCStructure.m
//  Crush
//
//  Created by Kevin McQuown on 7/25/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCStructure.h"
#import "CCWT.h"
#import "CCBlend.h"
#import "CCLot.h"
#import "CCVintage.h"
#import "CrushHelper.h"

@implementation CCStructure
@synthesize vineyard, vineyardGallons;
@synthesize varietal, varietalGallons;
@synthesize appellation, appellationGallons;
@synthesize vintage, vintageGallons;
@synthesize clone, cloneGallons;
@synthesize totalGallons;

-(id)init
{
	if (self=[super init])
	{
		vineyard=[[NSMutableArray alloc] init];
		vineyardGallons=[[NSMutableArray alloc] init];
		
		varietal=[[NSMutableArray alloc] init];
		varietalGallons=[[NSMutableArray alloc] init];
		
		appellation=[[NSMutableArray alloc] init];
		appellationGallons=[[NSMutableArray alloc] init];
		
		vintage=[[NSMutableArray alloc] init];
		vintageGallons=[[NSMutableArray alloc] init];
		
		clone=[[NSMutableArray alloc] init];
		cloneGallons=[[NSMutableArray alloc] init];
	}
	return self;
}

-(void)addStructureToStructure:(NSMutableArray *)struct1Name struct1Gallons:(NSMutableArray *)struct1Gallons 
					structure2:(NSMutableArray *)struct2Name structure2Gallons:(NSMutableArray *)struct2Gallons
					withPercentage:(float)perc
{
	for (int i=0; i<[struct2Name count]; i++) {
		int j=[struct1Name indexOfObject:[struct2Name objectAtIndex:i]];
		if (j!=NSNotFound) {
			NSNumber *newValue=[[NSNumber alloc] initWithFloat:[[struct1Gallons objectAtIndex:j] floatValue]+([[struct2Gallons objectAtIndex:i] floatValue]*perc)];
			[struct1Gallons replaceObjectAtIndex:j withObject:newValue];
			[newValue release];
		}
		else {
			NSNumber *newGallons=[[NSNumber alloc] initWithFloat:([[struct2Gallons objectAtIndex:i]floatValue]*perc)];
			[struct1Name insertObject:[struct2Name objectAtIndex:i] atIndex:[struct1Name count]];
			[struct1Gallons insertObject:newGallons atIndex:[struct1Gallons count]];
			[newGallons release];
		}
	}
	
}

-(void) nameArray:(NSMutableArray *)nameArray gallonArray:(NSMutableArray *)gallonsArray theName:(NSString *)theName theGallons:(float)theGallons
{
	int index=[nameArray indexOfObject:theName];
	if (index!=NSNotFound) {
		NSNumber *currentGallons=[gallonsArray objectAtIndex:index];
		float g=[currentGallons floatValue]+theGallons;
		NSNumber *newGallons=[[[NSNumber alloc] initWithFloat:g] autorelease];
		[gallonsArray replaceObjectAtIndex:index withObject:newGallons];
	}
	else {
		int index=[nameArray count];
		[nameArray insertObject:theName atIndex:index];
		NSNumber *newGallons=[[[NSNumber alloc] initWithFloat:theGallons] autorelease];
		[gallonsArray insertObject:newGallons atIndex:index];
	}
}

-(void)removeGlns:(float)g nameGallons:(NSMutableArray *)theGallons
{
	for (int i=0;i<[theGallons count];i++)
	{
		[theGallons replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:[[theGallons objectAtIndex:i]floatValue]-g]];
	}	
}

-(void)removeGallons:(float)gallons
{
	[self removeGlns:gallons nameGallons:self.vineyardGallons];
	[self removeGlns:gallons nameGallons:self.appellationGallons];
	[self removeGlns:gallons nameGallons:self.varietalGallons];
	[self removeGlns:gallons nameGallons:self.cloneGallons];
	[self removeGlns:gallons nameGallons:self.vintageGallons];
}

-(void)addStructure:(CCStructure *)structure withPercentage:(float)perc
{
	[self addStructureToStructure:self.vineyard 
				   struct1Gallons:self.vineyardGallons 
					   structure2:structure.vineyard 
				structure2Gallons:structure.vineyardGallons 
				   withPercentage:perc];
	
	[self addStructureToStructure:self.varietal 
				   struct1Gallons:self.varietalGallons 
					   structure2:structure.varietal 
				structure2Gallons:structure.varietalGallons 
				   withPercentage:perc];

	[self addStructureToStructure:self.appellation
				   struct1Gallons:self.appellationGallons 
					   structure2:structure.appellation 
				structure2Gallons:structure.appellationGallons 
				   withPercentage:perc];
	
	[self addStructureToStructure:self.vintage
				   struct1Gallons:self.vintageGallons
					   structure2:structure.vintage 
				structure2Gallons:structure.vintageGallons 
				   withPercentage:perc];
	
	[self addStructureToStructure:self.clone
				   struct1Gallons:self.cloneGallons 
					   structure2:structure.clone 
				structure2Gallons:structure.cloneGallons 
				   withPercentage:perc];
}

-(void) addToStructureFromWT:(CCWT *)theWT
{
	float gallons=[theWT totalNetWeight]/2000 * 155;
	
	[self nameArray:vineyard gallonArray:vineyardGallons theName:[theWT.vineyard name] theGallons:gallons];
	[self nameArray:varietal gallonArray:varietalGallons theName:theWT.varietal theGallons:gallons];
	[self nameArray:appellation gallonArray:appellationGallons theName:theWT.appellation theGallons:gallons];
	[self nameArray:vintage gallonArray:vintageGallons theName:[[CrushHelper numberFormatQtyNoDecimals] stringFromNumber:[NSNumber numberWithInt:theWT.inLot.vintage.year]] theGallons:gallons];
	[self nameArray:clone gallonArray:cloneGallons theName:theWT.clone theGallons:gallons];
	
}

-(NSString *)singleDescription:(NSArray *)nameArray valuesArray:(NSArray *)values displayName:(NSString *)name
{
	NSMutableString *desc=[[[NSMutableString alloc] init] autorelease];
	float total=0;
	for (int i=0; i<[values count];i++)
	{
		total+=[[values objectAtIndex:i] floatValue];
	}
	[desc appendFormat:@"  %@:\n",name];
	for (int i=0; i<[nameArray count]; i++) {
		[desc appendFormat:@"    %@ - %d (%3.0f%%)\n",
		 [nameArray objectAtIndex:i],
		 [[values objectAtIndex:i]intValue],
		 [[values objectAtIndex:i]floatValue]/total*100];
	}
	return desc;
	
}
-(NSString *)description
{
	NSMutableString *desc=[[[NSMutableString alloc] init] autorelease];
	[desc appendFormat:@"%@\n",@"Lot Structure:"];
	[desc appendString:[self singleDescription:self.vineyard valuesArray:self.vineyardGallons displayName:@"Vineyards"]];
	[desc appendString:[self singleDescription:self.varietal valuesArray:self.varietalGallons displayName:@"Varietals"]];
	[desc appendString:[self singleDescription:self.appellation valuesArray:self.appellationGallons displayName:@"Appellations"]];
	[desc appendString:[self singleDescription:self.vintage valuesArray:self.vintageGallons displayName:@"Vintages"]];
	[desc appendString:[self singleDescription:self.clone valuesArray:self.cloneGallons displayName:@"Clones"]];
	return desc;
}

-(void) addToStructureFromWO:(CCWorkOrder *)theWO
{
	if ([theWO.theType isEqualToString:@"BLEND"])
	{
		CCBlend *theBlend=[theWO.blends objectAtIndex:0];
		if ([theBlend.direction isEqualToString:@"IN FROM"]) // really is an out to since blends are backwards
		{
			float outGallons=theBlend.gallons;
			[self removeGallons:outGallons];
		}
		else {
	//		CCStructure *incomingStructure=[[CCStructure alloc] init];
			CCLot *sourceLot=[theWO.inLot.vintage getLotByNumber:theBlend.sourceLot];
			CCStructure *incomingStructure=[sourceLot getStructureUpToWorkOrder:theWO includeWO:NO];
			float currentGallons=[[sourceLot previousWorkOrder:theWO] derivedVolume];
			[self addStructure:incomingStructure withPercentage:(theBlend.gallons/currentGallons)];			
		}

	}
	if ([theWO.theSubType isEqualToString:@"BLENDING"])
	{
		for (CCBlend *theBlend in theWO.blends)
		{
			if ([theBlend.direction isEqualToString:@"OUT TO"])
			{
				float outGallons=theBlend.gallons;
				for (int i=0;i<[vineyardGallons count];i++)
				{
					[vineyardGallons replaceObjectAtIndex:i 
											   withObject:[NSNumber numberWithFloat:[[vineyardGallons objectAtIndex:i]floatValue]-outGallons]];
				}
			}
			else {
//				CCStructure *incomingStructure=[[CCStructure alloc] init];
				CCLot *sourceLot=[theWO.inLot.vintage getLotByNumber:theBlend.sourceLot];
				CCStructure *incomingStructure=[sourceLot getStructureUpToWorkOrder:theWO includeWO:NO];
				float currentGallons=[[sourceLot previousWorkOrder:theWO] derivedVolume];
				[self addStructure:incomingStructure withPercentage:(theBlend.gallons/currentGallons)];
			}

		}
	}
//	if ([[theWO newGallons] floatValue]>0)
//	{
//		for (int i=0;i<[vineyardGallons count];i++)
//		{
//			[vineyardGallons replaceObjectAtIndex:i 
//									   withObject:[theWO newGallons]];
//		}		
//	}
}

-(void) dealloc
{
    [vineyard release];
    [vineyardGallons release];
    [varietal release];
    [varietalGallons release];
    [appellation release];
    [appellationGallons release];
    [vintage release];
    [vintageGallons release];
    [clone release];
    [cloneGallons release];
    [totalGallons release];
    
    [super dealloc];
}
@end
