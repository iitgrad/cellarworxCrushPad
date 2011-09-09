//
//  CC702Rollup.m
//  Crush
//
//  Created by Kevin McQuown on 6/27/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CC702Rollup.h"
#import "CCLot.h"
#import "CC702.h"
#import "CC702Event.h"
#import "CC702SectionJuice.h"
#import "CCWT.h"
#import "CCWorkOrder.h"
#import "CCBOL.h"
#import "CC702SectionBulk.h"
#import "CC702SectionBottled.h"
#import "CC702Section.h"

@implementation CC702Rollup
@synthesize sectionJuice;
@synthesize sectionBulkBelow, sectionBulkAbove;
@synthesize sectionBottledBelow, sectionBottledAbove;

-(id) initWithLots:(NSArray *)lots betweenDate:(NSDate *)startDate andDate:(NSDate *)endDate
{
	self=[super init];
	
	sectionJuice=[[CC702SectionJuice alloc] init];
	sectionBulkBelow=[[CC702SectionBulk alloc] init];
	sectionBulkAbove=[[CC702SectionBulk alloc] init];
	sectionBottledAbove=[[CC702SectionBottled alloc] init];
	sectionBottledBelow=[[CC702SectionBottled alloc] init];
	
	for (int i=1; i<8; i++) {
		switch (i) {
			case 1:
				for (CCLot *aLot in lots)
				{
					sectionJuice.startingGallons+=[[aLot the702View] startingVolumeForDate:startDate forSection:i];
					NSArray *filteredHistory=[[aLot the702View] historyBetweenDate:startDate andDate:endDate forSection:i];
					if ([filteredHistory count]>0)
					{
						for (CC702Event *event in filteredHistory)
						{
							if ([[[event workOrder] class] isSubclassOfClass:[CCWT class]]) {
								[[sectionJuice tonsAdded] addObject:event];
								sectionJuice.totalTonsAdded+=[event changeInVolume];
							}
							if ([[[event workOrder] class] isSubclassOfClass:[CCWorkOrder class]])
							{
								if ([(CCWorkOrder *)[event workOrder] labtest] != nil )
								{
									[[sectionJuice tonsFermented] addObject:event];
									sectionJuice.totalTonsFermented+=[event changeInVolume];
								} 
								else if ([[(CCWorkOrder *)[event workOrder] theSubType] isEqualToString:@"BLEND"] | [[(CCWorkOrder *)[event workOrder] theSubType] isEqualToString:@"BLENDING"])
								{
									[[sectionJuice blending] addObject:event];
									sectionJuice.totalBlending+=[event changeInVolume];
								}
								else if ([(CCWorkOrder *)[event workOrder] inventoryAdjusted])
								{
									[[sectionJuice inventoryAdjustments] addObject:event];
									sectionJuice.totalInventoryAdjustments+=[event changeInVolume];
								}
							}							
							sectionJuice.endingGallons+=[event changeInVolume];
						}
					}					
				}
				sectionJuice.endingGallons+=sectionJuice.startingGallons;
				break;
			case 2:
				for (CCLot *aLot in lots)
				{
					sectionBulkBelow.startingGallons+=[[aLot the702View] startingVolumeForDate:startDate forSection:i];
					NSArray *filteredHistory=[[aLot the702View] historyBetweenDate:startDate andDate:endDate forSection:i];
					if ([filteredHistory count]>0)
					{
						for (CC702Event *event in filteredHistory)
						{
							if ([[[event workOrder] class] isSubclassOfClass:[CCBOL class]]) {
								if ([[(CCBOL *)[event workOrder] direction] isEqualToString:@"IN"])
								{
									[[sectionBulkBelow bolIn] addObject:event];
									sectionBulkBelow.totalBolIn+=[event changeInVolume];
								}
								else
								{
									if ([[(CCBOL *)[event workOrder] taxClass] isEqualToString:@"TAXPAID"])
									{
										[[sectionBulkBelow bolOutTaxPaid] addObject:event];
										sectionBulkBelow.totalBolOutTaxPaid+=[event changeInVolume];										
									}
									else {
										[[sectionBulkBelow bolOutBondToBond] addObject:event];
										sectionBulkBelow.totalBolOutBondToBond+=[event changeInVolume];										
									}
								}
							}
							else if ([[[event workOrder] class] isSubclassOfClass:[CCWorkOrder class]])
							{
								CCWorkOrder *wo=(CCWorkOrder *)[event workOrder];
								if ([[wo theSubType] isEqualToString:@"BOTTLING"])
								{
									[[sectionBulkBelow bottled] addObject:event];
									sectionBulkBelow.totalBottled+=[event changeInVolume];
								}
								else if ([[wo theSubType] isEqualToString:@"BLEND"] | [[wo theSubType] isEqualToString:@"BLENDING"])
								{
									[[sectionBulkBelow blending] addObject:event];
									sectionBulkBelow.totalBlending+=[event changeInVolume];
								}
								else if ([[wo theSubType] isEqualToString:@"RACKING"])
								{
									[[sectionBulkBelow lossesDueToRacking] addObject:event];
									sectionBulkBelow.totalLossesDueToRacking+=[event changeInVolume];
								}
								else if ([[wo theSubType] isEqualToString:@"DUMP"])
								{
									[[sectionBulkBelow lossesDueToDumping] addObject:event];
									sectionBulkBelow.totalLossesDueToDumping+=[event changeInVolume];
								}
								else if ([wo labtest] != nil)
								{
									if ([event previousState]==1)
									{
										[[sectionBulkBelow fermented] addObject:event];
										sectionBulkBelow.totalFermented+=[event changeInVolume];
									}
									else
									{
										[[sectionBulkBelow changeInAlcohol] addObject:event];
										sectionBulkBelow.totalChangeInAlcohol+=[event changeInVolume];
									}
								}
								else
								{
									[[sectionBulkBelow lossesDueToEvaporation] addObject:event];
									sectionBulkBelow.totalLossesDueToEvaporation+=[event changeInVolume];
								}
								
							}
							sectionBulkBelow.endingGallons+=[event changeInVolume];
						}
					}
				}
				sectionBulkBelow.endingGallons+=sectionBulkBelow.startingGallons;
				break;
			case 3:
				for (CCLot *aLot in lots)
				{
					sectionBulkAbove.startingGallons+=[[aLot the702View] startingVolumeForDate:startDate forSection:i];
					NSArray *filteredHistory=[[aLot the702View] historyBetweenDate:startDate andDate:endDate forSection:i];
					if ([filteredHistory count]>0)
					{
						for (CC702Event *event in filteredHistory)
						{
							if ([[[event workOrder] class] isSubclassOfClass:[CCBOL class]]) {
								if ([[(CCBOL *)[event workOrder] direction] isEqualToString:@"IN"])
								{
									[[sectionBulkAbove bolIn] addObject:event];
									sectionBulkAbove.totalBolIn+=[event changeInVolume];
								}
								else
								{
									if ([[(CCBOL *)[event workOrder] taxClass] isEqualToString:@"TAXPAID"])
									{
										[[sectionBulkAbove bolOutTaxPaid] addObject:event];
										sectionBulkAbove.totalBolOutTaxPaid+=[event changeInVolume];										
									}
									else {
										[[sectionBulkAbove bolOutBondToBond] addObject:event];
										sectionBulkAbove.totalBolOutBondToBond+=[event changeInVolume];										
									}
								}
							}
							else if ([[[event workOrder] class] isSubclassOfClass:[CCWorkOrder class]])
							{
								CCWorkOrder *wo=(CCWorkOrder *)[event workOrder];
								if ([[wo theSubType] isEqualToString:@"BOTTLING"])
								{
									[[sectionBulkAbove bottled] addObject:event];
									sectionBulkAbove.totalBottled+=[event changeInVolume];
								}
								else if ([[wo theSubType] isEqualToString:@"BLEND"] | [[wo theSubType] isEqualToString:@"BLENDING"])
								{
									[[sectionBulkAbove blending] addObject:event];
									sectionBulkAbove.totalBlending+=[event changeInVolume];
								}
								else if ([[wo theSubType] isEqualToString:@"RACKING"])
								{
									[[sectionBulkAbove lossesDueToRacking] addObject:event];
									sectionBulkAbove.totalLossesDueToRacking+=[event changeInVolume];
								}
								else if ([[wo theSubType] isEqualToString:@"DUMP"])
								{
									[[sectionBulkAbove lossesDueToDumping] addObject:event];
									sectionBulkAbove.totalLossesDueToDumping+=[event changeInVolume];
								}
								else if ([wo labtest] != nil)
								{
									if ([event previousState]==1)
									{
										[[sectionBulkAbove fermented] addObject:event];
										sectionBulkAbove.totalFermented+=[event changeInVolume];
									}
									else
									{
										[[sectionBulkAbove changeInAlcohol] addObject:event];
										sectionBulkAbove.totalChangeInAlcohol+=[event changeInVolume];
									}
								}
								else
								{
									[[sectionBulkAbove lossesDueToEvaporation] addObject:event];
									sectionBulkAbove.totalLossesDueToEvaporation+=[event changeInVolume];
								}
								
							}
							sectionBulkAbove.endingGallons+=[event changeInVolume];
						}
					}
				}
				sectionBulkAbove.endingGallons+=sectionBulkAbove.startingGallons;
				break;
			case 4:
				for (CCLot *aLot in lots)
				{
					sectionBottledBelow.startingGallons+=[[aLot the702View] startingVolumeForDate:startDate forSection:i];
					NSArray *filteredHistory=[[aLot the702View] historyBetweenDate:startDate andDate:endDate forSection:i];
					if ([filteredHistory count]>0)
					{
						for (CC702Event *event in filteredHistory)
						{
							if ([[[event workOrder] class] isSubclassOfClass:[CCBOL class]]) {
								if ([[(CCBOL *)[event workOrder] direction] isEqualToString:@"IN"])
								{
									[[sectionBottledBelow bolIn] addObject:event];
									sectionBottledBelow.totalBolIn+=[event changeInVolume];
								}
								else
								{
									if ([[(CCBOL *)[event workOrder] taxClass] isEqualToString:@"TAXPAID"])
									{
										[[sectionBottledBelow bolOutTaxPaid] addObject:event];
										sectionBottledBelow.totalBolOutTaxPaid+=[event changeInVolume];										
									}
									else {
										[[sectionBottledBelow bolOutBondToBond] addObject:event];
										sectionBottledBelow.totalBolOutBondToBond+=[event changeInVolume];										
									}
								}
							}
							else if ([[[event workOrder] class] isSubclassOfClass:[CCWorkOrder class]])
							{
								CCWorkOrder *wo=(CCWorkOrder *)[event workOrder];
								if ([[wo theSubType] isEqualToString:@"BOTTLING"])
								{
									[[sectionBottledBelow bottled] addObject:event];
									sectionBottledBelow.totalBottled+=[event changeInVolume];
								}
							}
							sectionBottledBelow.endingGallons+=[event changeInVolume];
						}
					}
				}
				sectionBottledBelow.endingGallons+=sectionBottledBelow.startingGallons;
				break;
			case 5:
				for (CCLot *aLot in lots)
				{
					sectionBottledAbove.startingGallons+=[[aLot the702View] startingVolumeForDate:startDate forSection:i];
					NSArray *filteredHistory=[[aLot the702View] historyBetweenDate:startDate andDate:endDate forSection:i];
					if ([filteredHistory count]>0)
					{
						for (CC702Event *event in filteredHistory)
						{
							if ([[[event workOrder] class] isSubclassOfClass:[CCBOL class]]) {
								if ([[(CCBOL *)[event workOrder] direction] isEqualToString:@"IN"])
								{
									[[sectionBottledAbove bolIn] addObject:event];
									sectionBottledAbove.totalBolIn+=[event changeInVolume];
								}
								else
								{
									if ([[(CCBOL *)[event workOrder] taxClass] isEqualToString:@"TAXPAID"])
									{
										[[sectionBottledAbove bolOutTaxPaid] addObject:event];
										sectionBottledAbove.totalBolOutTaxPaid+=[event changeInVolume];										
									}
									else {
										[[sectionBottledAbove bolOutBondToBond] addObject:event];
										sectionBottledAbove.totalBolOutBondToBond+=[event changeInVolume];										
									}
								}
							}
							else if ([[[event workOrder] class] isSubclassOfClass:[CCWorkOrder class]])
							{
								CCWorkOrder *wo=(CCWorkOrder *)[event workOrder];
								if ([[wo theSubType] isEqualToString:@"BOTTLING"])
								{
									[[sectionBottledAbove bottled] addObject:event];
									sectionBottledAbove.totalBottled+=[event changeInVolume];
								}
							}
							sectionBottledAbove.endingGallons+=[event changeInVolume];
						}
					}
				}
				sectionBottledAbove.endingGallons+=sectionBottledAbove.startingGallons;
				break;
			default:
				break;
		}
	}
	
	return self;
}

-(void) dealloc
{
	[sectionJuice release];
	[sectionBulkBelow release];
	[sectionBulkAbove release];
	[super dealloc];
}
@end
