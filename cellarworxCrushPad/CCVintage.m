//
//  CCVintage.m
//  Crush
//
//  Created by Kevin McQuown on 7/3/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCVintage.h"
#import "CrushHelper.h"
#import "CCLot.h"
#import "CCValidLabTests.h"
#import "CCClient.h"

#import <CoreData/CoreData.h>

@implementation CCVintage
@synthesize lots,year;
@synthesize favoriteLots;
@synthesize nonFavoriteLots;
@synthesize activeLots;
@synthesize inActiveLots;
@synthesize validLabTests;
@synthesize client;
@synthesize requestsReceived;
@synthesize theLock;
@synthesize maxRequestsOutstanding;

-(id) initWithClient:(CCClient *)theClient andVintageYear:(int) vintage withDetail:(BOOL)detail
{
	self=[super init];

	lots=[[NSMutableArray alloc] init];

	favoriteLots=[[NSMutableArray alloc] init];
	nonFavoriteLots=[[NSMutableArray alloc] init];
    activeLots=[[NSMutableArray alloc] init];
    inActiveLots=[[NSMutableArray alloc] init];

	validLabTests=[[CCValidLabTests alloc] init];
	client=[[CCClient alloc] initWithClient:theClient];
	theLock=[[NSLock alloc] init];
	year=vintage;
	requestsReceived=0;
	maxRequestsOutstanding=100;
	
	NSArray *allLots = [[NSArray alloc] initWithArray:[CrushHelper fetchLotsForClient:theClient withYear:vintage withDetail:NO]];
				
	for (NSDictionary *theLot in allLots)
	{
		CCLot *aLot=[[CCLot alloc] initWithDictionary:theLot forVintage:self];

		[lots addObject:aLot];

        if (aLot.active)
        {
            [aLot setRetrieved:NO];
            [activeLots addObject:aLot];
            if (aLot.favorite)
                [favoriteLots addObject:aLot];
            else 
                [nonFavoriteLots addObject:aLot];            
        }
        else
        {
            [inActiveLots addObject:aLot];
        }

		[aLot release];
	}
	[allLots release];
	
	return self;
}
//-(id) initWithLot:(NSString *)lot withDetail:(BOOL)detail{
//
//	NSArray *components=[lot componentsSeparatedByString:@"-"];
//	int theVintage=[[NSString stringWithFormat:@"20%@",[components objectAtIndex:0]] intValue];
//	return [self initWithClientCode:[components objectAtIndex:1] andVintage:theVintage withDetail:detail];
//}
-(void)incrementRequestsReceived
{
	[theLock lock];
	requestsReceived++;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"outstandingRequestChanged" object:nil];
	[theLock unlock];
}
-(void)decrementRequestsReceived;
{
	[theLock lock];
	requestsReceived--;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"outstandingRequestChanged" object:nil];
	[theLock unlock];
}
-(int)numberRetrieved:(NSArray *)theLots
{
	int count=0;
	for (CCLot *aLot in theLots)
	{
		if (aLot.retrieved)
		{
			count++;
		}
	}
	return count;
}

-(void)setMaxRequestsOutstanding:(int)maxValue
{
	maxRequestsOutstanding=maxValue;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"outstandingRequestChanged" object:nil];	
}

-(void)updateFavorites
{
	[self.favoriteLots removeAllObjects];
	[self.nonFavoriteLots removeAllObjects];
	for (CCLot *aLot in self.lots)
	{
		if (aLot.active) {
			if (aLot.favorite)
				[self.favoriteLots addObject:aLot];
			else 
				[self.nonFavoriteLots addObject:aLot];		
		}
	}
}

-(void)updateActives
{
	[self.activeLots removeAllObjects];
	[self.inActiveLots removeAllObjects];
	for (CCLot *aLot in self.lots)
	{
		if (aLot.active)
			[self.activeLots addObject:aLot];
		else 
			[self.inActiveLots addObject:aLot];		
	}
}

-(void)addLot:(CCLot *)theLot
{
	[lots addObject:theLot];
	[self updateFavorites];
	[self updateActives];
}

-(void)removeLot:(CCLot *)theLot
{
	[lots removeObject:theLot];
	[self updateFavorites];
	[self updateActives];
}
-(void)refreshLotCategories
{
	[self updateFavorites];
	[self updateActives];
}
//-(void) updateWithDetail:(NSString *)lotNumber
//{
//	int i=0;
//	for (CCLot *lot in self.lots)
//	{
//		if ([lot.lotNumber isEqualToString:lotNumber]) {
//			break;
//		}
//		i++;
//	}
//	
//	if ([self.lots objectAtIndex:i] != nil)
//	{
//		if (![[self.lots objectAtIndex:i] retrieved])
//		{
//			[[self.lots objectAtIndex:i] updateDetail];
//		}		
//	}
//	
//}
-(void) updateWithDetail:(CCLot *)lot
{
	if (lot != nil)
	{
		if (![lot retrieved])
		{
			[lot updateDetail];
		}		
	}
	
}
-(NSArray *)lotsWithDetail
{
	NSMutableArray *filteredLots=[[[NSMutableArray alloc] initWithArray:self.lots] autorelease];
    NSMutableIndexSet *removeLots=[[NSMutableIndexSet alloc] init];
    for (int i=0; i<[self.lots count]; i++)
    {
        if (![[self.lots objectAtIndex:i] retrieved])
        {
            [removeLots addIndex:i];
        }
    }
//	NSIndexSet *removeLots=[filteredLots indexesOfObjectsPassingTest:
//								   ^(id obj, NSUInteger idx, BOOL *stop)
//								   {  
//									   if (![(CCLot *)obj retrieved]) {
//										   return YES;
//									   }
//									   return NO;
//								   }];
	[filteredLots removeObjectsAtIndexes:removeLots];
	return filteredLots;
}
-(void)reSort
{
	NSSortDescriptor *dateDescriptor;
	NSArray *sortDescriptors;
	dateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"lotNumber"
												  ascending:YES] autorelease];
	sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
	[self.lots sortUsingDescriptors:sortDescriptors];
	[self.favoriteLots sortUsingDescriptors:sortDescriptors];
	[self.nonFavoriteLots sortUsingDescriptors:sortDescriptors];
	[self.activeLots sortUsingDescriptors:sortDescriptors];
	[self.inActiveLots sortUsingDescriptors:sortDescriptors];
}
-(void)saveLot:(CCLot *)l
{
//	dispatch_queue_t queue;
//	queue=dispatch_queue_create("com.cellarworx.Crush", NULL);
//	dispatch_async(queue, ^{
		[l save];
//	});
//	dispatch_release(queue);
}

-(void)changeActiveStatusOnLot:(CCLot *)lot
{
	if (!lot.active)  //Make lot Active
    {
        [lot.vintage.activeLots addObject:lot];
        [lot.vintage.inActiveLots removeObject:lot];
		if (lot.favorite)
			[lot.vintage.favoriteLots addObject:lot];
		else 
			[lot.vintage.nonFavoriteLots addObject:lot];
		lot.active=YES;
    }
	else
    {
        [lot.vintage.inActiveLots addObject:lot];
        [lot.vintage.activeLots removeObject:lot];
		if (lot.favorite)
			[lot.vintage.favoriteLots removeObject:lot];
		else 
			[lot.vintage.nonFavoriteLots removeObject:lot];
		lot.active=NO;        
    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lot save];
 //   });
	
}
-(void)toggleFavoriteOnLot:(CCLot *)l;
{
	if (l.favorite)
	{
		[self.nonFavoriteLots addObject:l];
		[self.favoriteLots removeObject:l];
		l.favorite=NO;
	}
	else {
		[self.favoriteLots addObject:l];
		[self.nonFavoriteLots removeObject:l];
		l.favorite=YES;
	}
	[self saveLot:l];
	
	[self reSort];
}

-(CCLot *)getLotByNumber:(NSString *)lotNumber
{
	for (CCLot *aLot in self.lots)
	{
		if ([aLot.lotNumber isEqualToString:lotNumber])
			return aLot;
	}
	CCLot *newLot=[[[CCLot alloc] initWithLotNumber:lotNumber] autorelease];
	[self addLot:newLot];
	return newLot;
}

-(void) dealloc
{
//	NSLog(@"lots: %d",[lots retainCount]);
//	NSLog(@"favoriteLots: %d",[favoriteLots retainCount]);
//	NSLog(@"nonFavoriteLots: %d",[nonFavoriteLots retainCount]);
//	NSLog(@"activeLots: %d",[activeLots retainCount]);
//	NSLog(@"inActiveLots: %d",[inActiveLots retainCount]);
//	NSLog(@"validLabTests: %d",[validLabTests retainCount]);

	[theLock release];
	[client release];
    [favoriteLots release];
    [nonFavoriteLots release];
    [activeLots release];
    [inActiveLots release];
    [validLabTests release];
    [lots release];
    [super dealloc];
}
@end
