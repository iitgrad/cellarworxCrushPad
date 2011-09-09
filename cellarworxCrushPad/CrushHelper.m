//
//  TwitterHelper.m
//  Presence
//

#import "CrushHelper.h"
#import "JSON.h"
#import "CCWorkOrder.h"
#import "CCWT.h"
#import "CCFermProtocol.h"
//#import "LotTableViewController.h"
#import "CCVineyard.h"
#import "CCBOL.h"
#import "CCFacility.h"
#import "cellarworxAppDelegate.h"
#include <dispatch/dispatch.h>

@implementation CrushHelper

+ (NSString *)devToken
{
	return [[[NSUserDefaults standardUserDefaults] objectForKey:@"devtoken"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
+ (void)setBadges:(NSDictionary *)badgeCounts
{
	dispatch_async(dispatch_get_main_queue(), ^{
//		int totalCount=0;
//		cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
//		UITabBarItem *sortingTableTabBarItem=[[[ap mapTagsToControllers] objectForKey:[NSNumber numberWithInt:ksorting]] tabBarItem];
//		int sortingValue=[[badgeCounts objectForKey:@"sorting"] intValue];
//		if (sortingValue==0)
//			[sortingTableTabBarItem setBadgeValue:nil];
//		else 
//			[sortingTableTabBarItem setBadgeValue:[badgeCounts objectForKey:@"sorting"]];
//		totalCount+=sortingValue;
		
//		UITabBarItem *toDoBarItem=[[[ap mapTagsToControllers] objectForKey:[NSNumber numberWithInt:kToDo]] tabBarItem];
//		int todoValue=[[badgeCounts objectForKey:@"todo"] intValue];
//		if (todoValue==0)
//			[toDoBarItem setBadgeValue:nil];
//		else 
//			[toDoBarItem setBadgeValue:[badgeCounts objectForKey:@"todo"]];	
//		totalCount+=todoValue;
//		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:totalCount];
	});
}

+ (NSMutableArray *)sharedInterface
{
	static NSMutableArray *myInstance = nil;
	if (!myInstance)
	{
		myInstance=[[NSMutableArray alloc] init];
	}
	return myInstance;
}

+(BOOL) isStaffOrClientwithClientCode:(NSString *)cc
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *currentClientCode=[[NSUserDefaults standardUserDefaults] objectForKey:@"clientcode"];	
	if ([currentClientCode isEqualToString:cc] | [ap staff])
		return YES;
	else 
		return NO;
}

+(CCVintage *)getVintageDataUsingViewController:(UIViewController *)controller
{
	
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	return [ap defaultVintage];

}

+ (void)sendProviderDeviceToken:(NSData *)devToken 
{
	NSString *theBytes=[devToken description];
	NSLog(@"devtoken is: %@",devToken);
	NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:
						theBytes,@"DEVTOKEN",
						[[UIDevice currentDevice] uniqueIdentifier],@"UDID",
						nil];
	NSDictionary *result=[self sendPostFromDictionary:dict withAction:@"update_devtoken"];
	if ([[result objectForKey:@"query_result"] isEqualToString:@"SUCCESSFUL"])
		[[NSUserDefaults standardUserDefaults] setObject:theBytes forKey:@"devtoken"];
	
	[dict release];
	[self setBadges:[result objectForKey:@"badges"]];
	NSLog(@"Token received is: %@",theBytes);
}

+ (float) calcSO2MLWithPPM:(NSInteger)ppm andTons:(float)tons andGallonsPerTon:(NSInteger)gallonsPerTon
{
	return ((float)ppm*tons*gallonsPerTon*3.786*1000)/60000;
}

+ (NSString *)crushHostName
{
	return @"www.copaincustomcrush.com/cellarworx/mobile";
//    NSString *db=[[NSUserDefaults standardUserDefaults] objectForKey:@"database"];
//    if (db==nil) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"www.copaincustomcrush.com/ccc" forKey:@"database"];
//    }
//    NSLog(@"Database is: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"database"]);
//    backendServerValid=YES;
//    return [[NSUserDefaults standardUserDefaults] objectForKey:@"database"];
//	}
//	@catch (NSException * e) {
//		if (!backendServerAlertGiven) {
//			backendServerAlertGiven=YES;
//			UIAlertView *theAlert=[[UIAlertView alloc] initWithTitle:@"No Backend Server Selected" message:@"Click in System Preferences on the Crush Application and select the database server you want to use." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//			[theAlert show];
//		}
//	}
//	return @"";
}

+ (NSString *)deviceid
{
	return [[UIDevice currentDevice] uniqueIdentifier];
}

+ (id)fetchJSONValueForURL:(NSURL *)url
{
    NSString *jsonString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	id jsonValue = [jsonString JSONValue];    
	[jsonString release];
	
    return jsonValue;
}
+ (NSDictionary *)fetchStaff
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/json/test.php?action=getstaff&deviceid=%@", [self crushHostName],[self deviceid]];
    NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	return [self fetchJSONValueForURL:url];
}

+ (NSDictionary *)fetchDefaults
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/json/test.php?action=defaults&deviceid=%@", [self crushHostName],[self deviceid]];
    NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	return [self fetchJSONValueForURL:url];
}
+ (void)modifyLot:(NSString *)clientid withYear:(int)vintage withDescription:(NSString *)description withLotNumber:(NSString *)lotnumber
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/lotmgt.php?action=modlot&clientid=%@&vintage=%4d&description=%@&lotnumber=%@",
						 [self crushHostName],clientid,vintage,[description stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],lotnumber];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	[self fetchJSONValueForURL:url];	
}
+ (NSArray *)getBrixTempListForLot:(NSString *)l andVessel:(NSString *)v 
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=brixtemp&lot=%@&vessel=%@",
						 [self crushHostName],
						 l,
						 v];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	NSArray *result=[[[NSArray alloc] initWithArray:[self fetchJSONValueForURL:url]] autorelease];

	return result;
}
+(void)setDefaultClientAndVintageFromWT:(CCWT *)wt andView:(UIViewController *)view
{
 
    cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];

	if (wt != nil)
	{
		//	[self setVintageUsingViewController:view withVintage:nil];
		
		NSString *cc=[[NSUserDefaults standardUserDefaults] stringForKey:@"clientcode"];
		if ((cc == nil) | (![cc isEqualToString:wt.clientcode]) )
		{
			[[NSUserDefaults standardUserDefaults] setObject:wt.clientid forKey:@"clientid"];
			[[NSUserDefaults standardUserDefaults] setObject:wt.clientname forKey:@"clientname"];
			[[NSUserDefaults standardUserDefaults] setObject:wt.clientcode forKey:@"clientcode"];
			NSString *newVintage=nil;
			if (wt.inLot != nil)
				newVintage=[[NSString alloc] initWithFormat:@"20%@",[wt.inLot.lotNumber substringWithRange:NSMakeRange(0, 2)]];
			else 
				newVintage=[[NSString alloc] initWithFormat:@"20%@",[[wt.date description] substringWithRange:NSMakeRange(2, 2)]];
			if ([newVintage intValue]>0)
			{
				[[NSUserDefaults standardUserDefaults] setObject:newVintage forKey:@"vintage"];
			}
			[newVintage release];
            [ap setClientVintageChanged:YES];
		}
		UIViewController *clientVintage=nil;
		for (UIViewController *v in view.tabBarController.viewControllers)
		{
			if (v.view.tag==kPickCustomerVintage)
			{
				clientVintage=v;
				break;
			}
		}
		clientVintage.title=[NSString stringWithFormat:@"%@ - %4d",
							 wt.clientcode,
							 [[[NSUserDefaults standardUserDefaults]objectForKey:@"vintage"] intValue]];
		
	}
}

+(void)setDefaultClientAndVintageFromWO:(CCWorkOrder *)wo
{
    cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];

	if (wo != nil)
	{
//		NSString *cc=[[NSUserDefaults standardUserDefaults] stringForKey:@"clientcode"];
//		if ((cc == nil) | (![cc isEqualToString:wo.clientcode]) )
//		{
			[[NSUserDefaults standardUserDefaults] setObject:wo.clientid forKey:@"clientid"];
			[[NSUserDefaults standardUserDefaults] setObject:wo.clientname forKey:@"clientname"];
			[[NSUserDefaults standardUserDefaults] setObject:wo.clientcode forKey:@"clientcode"];
			NSString *newVintage=nil;
			if (wo.lot != nil)
				newVintage=[[NSString alloc] initWithFormat:@"20%@",[wo.lot substringWithRange:NSMakeRange(0, 2)]];
			else 
				newVintage=[[NSString alloc] initWithFormat:@"20%@",[[wo.date description] substringWithRange:NSMakeRange(2, 2)]];
			if ([newVintage intValue]>0)
			{
				[[NSUserDefaults standardUserDefaults] setObject:newVintage forKey:@"vintage"];
			}
			[newVintage release];				
			
            [ap setClientVintageChanged:YES];
//		}		
	}
}

+ (CCWorkOrder *)getWOReferenceFromWO:(CCWorkOrder *)wo
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	CCLot *l=[[ap getVintageForClient:wo.client andYear:[CCLot getVintageYearFromLotNumber:wo.inLot.lotNumber]] getLotByNumber:wo.lot];
	CCWorkOrder *w=[l getWorkOrderByID:wo.theID];
	return w;
}
+ (CCWT *)getWTReferenceFromWT:(CCWT *)wt   inView:(UIViewController *)view
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	CCVintage *v=[ap defaultVintage];
	CCLot *l=[v getLotByNumber:wt.inLot.lotNumber];
	CCWT *w=[l getWTByID:wt.theID];
	return w;
}
+ (NSArray *)fetchOutstandingSCPsAferTodayFromView:(UIViewController *)view
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=outstandingSCPsAfterToday",[self crushHostName]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	
	NSMutableArray *wolist=[[[NSMutableArray alloc] init] autorelease];
	NSArray *result=[[[NSArray alloc] initWithArray:[self fetchJSONValueForURL:url]] autorelease];
	for (NSDictionary *dict in result)
	{
		CCSCP *awo=[[CCSCP alloc] initWithDictionary:dict withLot:nil];
		NSLog(@"%@",awo.theID);
		[wolist addObject:awo];
		[awo release];
	}
	return wolist;
}
+ (NSArray *)fetchFacilityWeight:(UIViewController *)view
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=getfacilityweight",[self crushHostName]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	
	NSArray *result=[[[NSArray alloc] initWithArray:[self fetchJSONValueForURL:url]] autorelease];
	return result;	
}

+ (NSArray *)fetchOutstandingSCPsForToday
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=outstandingSCPsForToday",[self crushHostName]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	
	NSMutableArray *wolist=[[[NSMutableArray alloc] init] autorelease];
	NSArray *result=[[[NSArray alloc] initWithArray:[self fetchJSONValueForURL:url]] autorelease];
	for (NSDictionary *dict in result)
	{
		CCSCP *awo=[[CCSCP alloc] initWithDictionary:dict withLot:nil];
		[wolist addObject:awo];
		[awo release];
	}
	return wolist;
}
+ (NSArray *)fetchOutstandingSCPs
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=outstandingSCPs",[self crushHostName]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	
	NSMutableArray *wolist=[[[NSMutableArray alloc] init] autorelease];
	NSArray *result=[[[NSArray alloc] initWithArray:[self fetchJSONValueForURL:url]] autorelease];
	for (NSDictionary *dict in result)
	{
		CCSCP *awo=[[CCSCP alloc] initWithDictionary:dict withLot:nil];
		[wolist addObject:awo];
		[awo release];
	}
	return wolist;
}
+ (NSArray *)fetchTankCapacityAnalysisData
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=tankCapacityAnalysis",[self crushHostName]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	return [self fetchJSONValueForURL:url];	
}
+ (NSArray *)fetchSCPsForSeason
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=SCPsForSeason",[self crushHostName]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	
	NSMutableArray *wolist=[[[NSMutableArray alloc] init] autorelease];
	NSArray *result=[[[NSArray alloc] initWithArray:[self fetchJSONValueForURL:url]] autorelease];
	for (NSDictionary *dict in result)
	{
		CCSCP *awo=[[CCSCP alloc] initWithDictionary:dict withLot:nil];
		[wolist addObject:awo];
		[awo release];
	}
	return wolist;
}
+ (NSArray *)fetchOutstandingPOsFromView:(UIViewController *)view
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=outstandingPOs",[self crushHostName]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	
	NSMutableArray *wolist=[[[NSMutableArray alloc] init] autorelease];
	NSArray *result=[[[NSArray alloc] initWithArray:[self fetchJSONValueForURL:url]] autorelease];
	for (NSDictionary *dict in result)
	{
		CCWorkOrder *awo=[[CCWorkOrder alloc] initWithDictionary:dict withLot:nil];
		
		[wolist addObject:awo];
		[awo release];
	}
	return wolist;
}
+ (NSArray *)fetchLocations
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=getvineyards&clientid=%@",[self crushHostName],
						 [[NSUserDefaults standardUserDefaults] objectForKey:@"clientid"]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	
	NSMutableArray *vydList=[[[NSMutableArray alloc] init] autorelease];
	NSArray *result=[[[NSArray alloc] initWithArray:[self fetchJSONValueForURL:url]] autorelease];
	for (NSDictionary *dict in result)
	{
		CCVineyard *vyd=[[CCVineyard alloc] initWithDictionary:dict];
		[vydList addObject:vyd];
		[vyd release];
	}
	return vydList;
}

+ (CCBOL *)getBOLReferenceFromBOL:(CCBOL *)theBOL
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSArray *bols=[ap getBOLsForClient:theBOL.client];
	for (CCBOL *bol in bols)
	{
		if (bol.bolid=theBOL.bolid) {
			return bol;
		}
	}
	return nil;
}
+ (CCFacility *)getFacilityFromFacility:(CCFacility *)theFacility
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	for (CCFacility *facility in [ap facilities])
	{
		if (facility.dbid=theFacility.dbid) {
			return facility;
		}
	}
	return nil;
}
+ (NSArray *)fetchFacilityList
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=getfacilities",[self crushHostName]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	
	NSMutableArray *facilityList=[[[NSMutableArray alloc] init] autorelease];
	NSArray *result=[[[NSArray alloc] initWithArray:[self fetchJSONValueForURL:url]] autorelease];
	for (NSDictionary *dict in result)
	{
		CCFacility *theFacility=[[CCFacility alloc] initWithDictionary:dict];
		if (theFacility!=nil)
		{
			CCFacility *f=[CrushHelper getFacilityFromFacility:theFacility];
			if (f!=nil)
				[facilityList addObject:f];
			else
				[facilityList addObject:theFacility];
			[theFacility release];			
		}
	}
	return facilityList;
	
}
+ (NSDictionary *)fetchBOLByID:(NSInteger)dbid
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=getbol&id=%@",[self crushHostName],[[CrushHelper numberFormatQtyNoDecimals] stringFromNumber:[NSNumber numberWithInt:dbid]]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	
	NSDictionary *dict=[self fetchJSONValueForURL:url];
	return dict;
}

+ (NSArray *)fetchBOLsForClient:(CCClient *)theClient
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=getbols&clientcode=%@",[self crushHostName],theClient.clientCode];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	
	NSMutableArray *bolList=[[[NSMutableArray alloc] init] autorelease];
	NSArray *result=[[[NSArray alloc] initWithArray:[self fetchJSONValueForURL:url]] autorelease];
	for (NSDictionary *dict in result)
	{
		CCBOL *theBOL=[[CCBOL alloc] initWithDictionary:dict withLot:nil];
		if (theBOL!=nil)
		{
			CCBOL *w=[CrushHelper getBOLReferenceFromBOL:theBOL];
			if (w!=nil)
				[bolList addObject:w];
			else
				[bolList addObject:theBOL];
			[theBOL release];			
		}
	}
	return bolList;
}
+ (NSArray *)fetchOutstandingWOs
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=showoutstandingwos",[self crushHostName]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	
	NSMutableArray *wolist=[[[NSMutableArray alloc] init] autorelease];
	NSArray *result=[[[NSArray alloc] initWithArray:[self fetchJSONValueForURL:url]] autorelease];
	for (NSDictionary *dict in result)
	{
		CCWorkOrder *awo=[[CCWorkOrder alloc] initWithDictionary:dict withLot:nil];
		if (awo!=nil)
		{
			CCWorkOrder *w=[CrushHelper getWOReferenceFromWO:awo];
			if (w!=nil)
				[wolist addObject:w];
			else
				[wolist addObject:awo];
			[awo release];			
		}
	}
	return wolist;
}

+(NSString *)boolDescription:(BOOL)b
{
	if (b)
		return @"YES";
    else 
		return @"NO";
}
+ (NSArray *)fetchWeighTagsForVintage:(CCVintage *)vintage inView:(UIViewController *)view
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=showwtsforvintage&vintage=%4d",[self crushHostName],[vintage year]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	
	NSMutableArray *wolist=[[[NSMutableArray alloc] init] autorelease];
	NSArray *result=[[[NSArray alloc] initWithArray:[self fetchJSONValueForURL:url]] autorelease];
	for (NSDictionary *dict in result)
	{
		CCWT *theWT=[[CCWT alloc] initWithDictionary:dict withLot:nil];
		if (theWT!=nil)
	    {
			CCWT *wt=[CrushHelper getWTReferenceFromWT:theWT inView:view];
			if (wt!=nil)
				[wolist addObject:wt];
			else 
				[wolist addObject:theWT];
		}
		[theWT release];
	}
	return wolist;	
}
+ (NSArray *)fetchWeighTagsForTodayInView:(UIViewController *)view
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=showwtsfortoday",[self crushHostName]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	
	NSMutableArray *wolist=[[[NSMutableArray alloc] init] autorelease];
	NSArray *result=[[[NSArray alloc] initWithArray:[self fetchJSONValueForURL:url]] autorelease];
	for (NSDictionary *dict in result)
	{
		CCWT *theWT=[[CCWT alloc] initWithDictionary:dict withLot:nil];
		if (theWT!=nil)
	    {
			CCWT *wt=[CrushHelper getWTReferenceFromWT:theWT inView:view];
			if (wt!=nil)
				[wolist addObject:wt];
			else 
				[wolist addObject:theWT];
		}
		[theWT release];
	}
	return wolist;	
}
+ (NSArray *)fetchWeighTagsForClientcode:(NSString *)clientid withVintage:(CCVintage *)vintage inView:(UIViewController *)view
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=showwts&clientcode=%@&vintage=%4d",[self crushHostName],clientid,[vintage year]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	
	NSMutableArray *wolist=[[[NSMutableArray alloc] init] autorelease];
	NSArray *result=[[[NSArray alloc] initWithArray:[self fetchJSONValueForURL:url]] autorelease];
	for (NSDictionary *dict in result)
	{
		CCWT *theWT=[[CCWT alloc] initWithDictionary:dict withLot:nil];
		if (theWT!=nil)
	    {
			CCWT *wt=[CrushHelper getWTReferenceFromWT:theWT inView:view];
			if (wt!=nil)
				[wolist addObject:wt];
			else 
				[wolist addObject:theWT];
		}
		[theWT release];
	}
	return wolist;
}

+ (NSArray *)fetchNewWOsFromView:(UIViewController *)view
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=shownewwos&devtoken=%@",
						 [self crushHostName],
						 [[[NSUserDefaults standardUserDefaults] objectForKey:@"devtoken"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	
	NSMutableArray *wolist=[[[NSMutableArray alloc] init] autorelease];
	NSArray *result=[[[NSArray alloc] initWithArray:[self fetchJSONValueForURL:url]] autorelease];
	for (NSDictionary *dict in result)
	{
		CCWorkOrder *awo=[[CCWorkOrder alloc] initWithDictionary:dict withLot:nil];
		if (awo!=nil)
		{
			CCWorkOrder *w=[CrushHelper getWOReferenceFromWO:awo];
			if (w!=nil)
				[wolist addObject:w];
			else
				[wolist addObject:awo];
			[awo release];			
		}
	}
	return wolist;	
}
+(UIColor *) organicGreen
{
	static UIColor* theOrganicGreen = nil; // Static var -- global that's invisible outside this method. Initialization only happens the first time. 
	if( theOrganicGreen == nil )
		theOrganicGreen = [[UIColor alloc] initWithRed: 0.755 green: 0.984 blue: 0.7 alpha:1.0]; 
	return theOrganicGreen;
}

+ (NSArray *)getFermentationProtocols
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=fermprotocols&clientid=%@&clientcode=%@&vintage=%@",[self crushHostName],
						 [[NSUserDefaults standardUserDefaults] objectForKey:@"clientid"],
						 [[NSUserDefaults standardUserDefaults] objectForKey:@"clientcode"],
						 [[NSUserDefaults standardUserDefaults] objectForKey:@"vintage"]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	
	NSMutableArray *fermProtocolList=[[[NSMutableArray alloc] init] autorelease];
	NSArray *result=[[[NSArray alloc] initWithArray:[self fetchJSONValueForURL:url]] autorelease];
	for (NSDictionary *dict in result)
	{
		CCFermProtocol *aProtocol=(CCFermProtocol *)[[CCFermProtocol alloc] initWithDictionary:dict];
		[fermProtocolList addObject:aProtocol];
		[aProtocol release];
	}
	return fermProtocolList;	
}

+ (NSDictionary *)getActiveFerms
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=activefermsbygroup&clientid=%@&clientcode=%@&vintage=%@",[self crushHostName],
						 [[NSUserDefaults standardUserDefaults] objectForKey:@"clientid"],
						 [[NSUserDefaults standardUserDefaults] objectForKey:@"clientcode"],
						 [[NSUserDefaults standardUserDefaults] objectForKey:@"vintage"]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	
	NSMutableArray *poam=[[NSMutableArray alloc] init];
	NSMutableArray *ponoon=[[NSMutableArray alloc] init];
	NSMutableArray *popm=[[NSMutableArray alloc] init];
	NSMutableArray *pdam=[[NSMutableArray alloc] init];
	NSMutableArray *pdnoon=[[NSMutableArray alloc] init];
	NSMutableArray *pdpm=[[NSMutableArray alloc] init];
		
	NSDictionary *result=[self fetchJSONValueForURL:url];

	NSMutableDictionary *groups=[[NSMutableDictionary alloc] init];
	
	NSArray *groupNumbers=[result allKeys];
	for (NSString *groupNumber in groupNumbers) {
		NSDictionary *workOrders=[result objectForKey:groupNumber];
		NSMutableArray *theWorkOrders=[[NSMutableArray alloc] init];
		NSMutableArray *woAM=[[NSMutableArray alloc] init];
		NSMutableArray *woNOON=[[NSMutableArray alloc] init];
		NSMutableArray *woPM=[[NSMutableArray alloc] init];
		for (NSDictionary *item in workOrders) {
			CCWorkOrder *wo=[[CCWorkOrder alloc] initWithDictionary:item withLot:nil];
			if ([wo.timeslot isEqualToString:@"MORNING"])
				[woAM addObject:wo];
			if ([wo.timeslot isEqualToString:@"NOON"])
				[woNOON addObject:wo];
			if ([wo.timeslot isEqualToString:@"EVENING"])
				[woPM addObject:wo];
//			[theWorkOrders addObject:[[[CCWorkOrder alloc] initWithDictionary:item withLot:nil]autorelease]];
		}
		[theWorkOrders addObject:woAM];
		[theWorkOrders addObject:woNOON];
		[theWorkOrders addObject:woPM];
		[woAM release];
		[woNOON release];
		[woPM release];
		[groups setObject:theWorkOrders forKey:groupNumber];
		[theWorkOrders release];
	}
	return groups;
		
	NSArray *po=[result objectForKey:@"PUMP OVER"];
	if (po != nil)
	{
		for (NSDictionary *dict in po)
		{
			CCWorkOrder *wo=[[CCWorkOrder alloc] initWithDictionary:dict withLot:nil];
			if ([wo.timeslot isEqualToString:@"MORNING"])
				[poam addObject:wo];
			if ([wo.timeslot isEqualToString:@"NOON"])
				[ponoon addObject:wo];
			if ([wo.timeslot isEqualToString:@"EVENING"])
				[popm addObject:wo];
			[wo release];
		}
	}
	NSArray *pd=[result objectForKey:@"PUNCH DOWN"];
	if (pd != nil)
	{
		for (NSDictionary *dict in pd)
		{
			CCWorkOrder *wo=[[CCWorkOrder alloc] initWithDictionary:dict withLot:nil];
			if ([wo.timeslot isEqualToString:@"MORNING"])
				[pdam addObject:wo];
			if ([wo.timeslot isEqualToString:@"NOON"])
				[pdnoon addObject:wo];
			if ([wo.timeslot isEqualToString:@"EVENING"])
				[pdpm addObject:wo];
			[wo release];
		}
	}
	NSDictionary *dictresult=[[[NSDictionary alloc] initWithObjectsAndKeys:poam,@"POAM",
							  ponoon,@"PONOON",
							  popm,@"POPM",
							  pdam,@"PDAM",
							  pdnoon,@"PDNOON",
							  pdpm,@"PDPM",
							  nil] autorelease];
	[pdam release];
	[pdnoon release];
	[pdpm release];
	[poam release];
	[ponoon release];
	[popm release];
	return dictresult;
}

+ (NSObject *)fetchList:(NSString *)listName fromTable:(NSString *)table
{
	BOOL contactServer;
	
	NSString *keyName=[[[NSString alloc] initWithFormat:@"%@-%@-%@",[self crushHostName],
						[[NSUserDefaults standardUserDefaults] objectForKey:@"clientcode"],
						listName] autorelease];
	
	// This checks to see if we have already loaded the various lists to avoid going to internet each time for this.
	if ([listName isEqualToString:@"VARIETY"] |
		 [listName isEqualToString:@"VARIETAL"] |
		 [listName isEqualToString:@"APPELLATION"]|
		  [listName isEqualToString:@"TYPE"]) 
	{
		contactServer=YES;
	}
	else
	{
		if ([[NSUserDefaults standardUserDefaults] objectForKey:keyName]==nil)
			contactServer=YES;
		else 
			contactServer=NO;
	}
	if (contactServer)
	{
		NSString *urlString=[NSString stringWithFormat:@"http://%@/json/lists.php?action=%@&clientid=%@&clientcode=%@&vintage=%@",[self crushHostName],listName,
							 [[NSUserDefaults standardUserDefaults] objectForKey:@"clientid"],
							 [[NSUserDefaults standardUserDefaults] objectForKey:@"clientcode"],
							 [[NSUserDefaults standardUserDefaults] objectForKey:@"vintage"]];
		NSURL *url = [NSURL URLWithString:urlString];
		NSLog(@"%@",urlString);
		NSDictionary *theList=[self fetchJSONValueForURL:url];
		[[NSUserDefaults standardUserDefaults] setObject:theList forKey:keyName];
		return [[NSUserDefaults standardUserDefaults] objectForKey:keyName];
	}
	else 
		return [[NSUserDefaults standardUserDefaults] objectForKey:keyName];

}

+(UIColor *) getSCPColorFromColorString:(NSString *)theColor
{
	if ([theColor isEqualToString:@"RED"]) return [UIColor redColor];
	if ([theColor isEqualToString:@"BLUE"]) return [UIColor blueColor];
	if ([theColor isEqualToString:@"PURPLE"]) return [UIColor purpleColor];
	if ([theColor isEqualToString:@"YELLOW"]) return [UIColor yellowColor];
	if ([theColor isEqualToString:@"WHITE"]) return [UIColor whiteColor];
	if ([theColor isEqualToString:@"ORANGE"]) return [UIColor orangeColor];
	if ([theColor isEqualToString:@"GREEN"]) return [UIColor greenColor];
	if ([theColor isEqualToString:@"BROWN"]) return [UIColor brownColor];
	return [UIColor blackColor];
}

+(NSString *) getColorStringFromColor:(UIColor *)color
{
	if (CGColorEqualToColor([[UIColor redColor] CGColor], [color CGColor])) return @"RED"; 
	if (CGColorEqualToColor([[UIColor blueColor] CGColor], [color CGColor])) return @"BLUE"; 
	if (CGColorEqualToColor([[UIColor greenColor] CGColor], [color CGColor])) return @"GREEN"; 
	if (CGColorEqualToColor([[UIColor purpleColor] CGColor], [color CGColor])) return @"PURPLE"; 
	if (CGColorEqualToColor([[UIColor brownColor] CGColor], [color CGColor])) return @"BROWN"; 
	if (CGColorEqualToColor([[UIColor yellowColor] CGColor], [color CGColor])) return @"YELLOW"; 
	if (CGColorEqualToColor([[UIColor whiteColor] CGColor], [color CGColor])) return @"WHITE"; 
	if (CGColorEqualToColor([[UIColor orangeColor] CGColor], [color CGColor])) return @"ORANGE"; 
	return @"";
}
+(NSString *) getColorStringFromColor1:(UIColor *)color1 andColor2:(UIColor *)color2
{
	if (color2 != nil)
		return [NSString stringWithFormat:@"%@-%@",[self getColorStringFromColor:color1], [self getColorStringFromColor:color2]];
	return [self getColorStringFromColor:color1];
}

+(NSString *)dateAndTimeString:(NSDate *)theDate
{
    NSDateFormatter *dateTime=[[[NSDateFormatter alloc] init] autorelease];
	[dateTime setDateStyle:NSDateFormatterShortStyle];
	[dateTime setTimeStyle:NSDateFormatterShortStyle];
	return [dateTime stringFromDate:theDate];
}

+ (NSDateFormatter *)dateFormatShortStyle
{
    NSDateFormatter *theFormat=[[[NSDateFormatter alloc] init] autorelease];
    [theFormat setDateStyle:NSDateFormatterShortStyle];
    [theFormat setTimeStyle:NSDateFormatterNoStyle];
    return theFormat;
}
+ (NSDateFormatter *)timeOfDayFormat
{
    NSDateFormatter *theFormat=[[[NSDateFormatter alloc] init] autorelease];
    [theFormat setDateStyle:NSDateFormatterNoStyle];
    [theFormat setTimeStyle:NSDateFormatterShortStyle];
    return theFormat;
}
+ (NSDateFormatter *)dateFormatSQLStyle
{
    NSDateFormatter *theFormat=[[[NSDateFormatter alloc] init] autorelease];
    [theFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [theFormat setDateFormat:@"yyyy-MM-dd"];
    return theFormat;
}

+ (NSDateFormatter *)dateAndTimeFormatSQLStyle
{
    NSDateFormatter *theFormat=[[[NSDateFormatter alloc] init] autorelease];
    [theFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return theFormat;
}
+ (NSDateFormatter *)dateFormatDay
{
	NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[inputFormatter setDateFormat:@"EEE"];
	return inputFormatter;
}
+ (NSNumberFormatter *) numberFormatQty
{
	NSNumberFormatter *qtyFormat=[[[NSNumberFormatter alloc] init] autorelease];
	[qtyFormat setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[qtyFormat setNumberStyle:NSNumberFormatterDecimalStyle];
	return qtyFormat;
}
+ (NSNumberFormatter *) numberFormatQtyWithDecimals:(int)decimalCount
{
	NSNumberFormatter *qtyFormat=[[[NSNumberFormatter alloc] init] autorelease];
	[qtyFormat setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[qtyFormat setNumberStyle:NSNumberFormatterDecimalStyle];
	[qtyFormat setMaximumFractionDigits:decimalCount];
	return qtyFormat;
}
//+ (NSNumberFormatter *) numberFormatQtyWithDecimalsAsDegrees:(int)decimalCount
//{
//	return [NSString stringWithFormat:@"%@%C",[self numberFormatQtyWithDecimals:decimalCount],0x00B0];
//}
+ (NSNumberFormatter *) numberFormatQtyNoDecimals
{
	NSNumberFormatter *qtyFormat=[[[NSNumberFormatter alloc] init] autorelease];
	[qtyFormat setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[qtyFormat setNumberStyle:NSNumberFormatterDecimalStyle];
	[qtyFormat setMaximumFractionDigits:0];
	return qtyFormat;
}
+ (NSNumberFormatter *) numberFormatCurrency
{
	NSNumberFormatter *currencyFormat=[[[NSNumberFormatter alloc] init] autorelease];
	[currencyFormat setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[currencyFormat setNumberStyle:NSNumberFormatterCurrencyStyle];	
	return currencyFormat;
}
+ (NSNumberFormatter *) numberFormatCurrencyNoCents
{
	NSNumberFormatter *currencyFormat=[[[NSNumberFormatter alloc] init] autorelease];
	[currencyFormat setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[currencyFormat setNumberStyle:NSNumberFormatterCurrencyStyle];	
	[currencyFormat setMaximumFractionDigits:0];
	return currencyFormat;
}

+ (NSSortDescriptor *) sortDateDescending
{
	return [[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO] autorelease];
}
+ (NSSortDescriptor *) sortDateAscending
{
	return [[[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES] autorelease];
}
+ (NSDateFormatter *)dateFormatSQLLong
{
	NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
	[df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
	return df;
}

+ (NSDateFormatter *)dateFormatSQL
{
	NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
	[df setDateFormat:@"yyyy-MM-dd"];
	return df;
}
+ (NSDateFormatter *)dateFormatRegular
{
	NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
	[df setDateFormat:@"MM/dd/yyyy"];
	return df;
}
+ (NSDateFormatter *)dateFormatShortNoYear
{
	NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
	[df setDateFormat:@"MM/dd"];
	return df;
}


+ (NSArray *) fetchAppellations
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/lists.php?action=appellation",[self crushHostName]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	return [self fetchJSONValueForURL:url];	
	
}

+ (NSArray *) fetchTotalTonnageForClientocde: (NSString *)clientid withYear:(int)vintage
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/companystats.php?action=totalweight&clientcode=%@&vintage=%4d",
						 [self crushHostName],clientid,vintage];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	return [self fetchJSONValueForURL:url];	
}

+ (NSArray *) fetchTotalGallonsForClientcode: (NSString *)clientid withYear:(int)vintage
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/companystats.php?action=totalgallons&clientcode=%@&vintage=%4d",
						 [self crushHostName],clientid,vintage];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	return [self fetchJSONValueForURL:url];	
}

+ (NSArray *)fetchLotsForClient:(CCClient *)client withYear:(int)vintage withDetail:(BOOL)detail
{
	NSString *urlString;
	if (detail)
		urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=showlots&allActive=0&clientcode=%@&vintage=%4d&detail=YES",[self crushHostName],[client clientID],vintage];
	else 
		urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=showlots&allActive=0&clientcode=%@&vintage=%4d&detail=NO",[self crushHostName],[client clientID],vintage];
		
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	return [self fetchJSONValueForURL:url];
}

+ (NSArray *)fetchAssetList
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=getassetlist",[self crushHostName]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	return [self fetchJSONValueForURL:url];
}
+ (NSArray *)fetchAssetListOfTanks
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=getassetlistfortankcalcs",[self crushHostName]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	return [self fetchJSONValueForURL:url];
}
//+(NSString *)blankIfNullOrNill:(NSDictionary *)dict objectForKey:(NSString *)key
//{
//	NSObject *test=[dict objectForKey:key];
//	if (test==nil)
//		return [[NSString alloc] initWithString:@""];
//	if ([[[test class] description] isEqualToString:@"NSNULL"])
//		return [[NSString alloc] initWithString:@""];
//	return [[NSString alloc] initWithString:[dict objectForKey:key]];	
//}

+ (id) nillIfNull:(id)value 
{
	if ([NSNull null] == value)
		return nil;
	else 
		return value;
}

+ (NSDictionary *)fetchWO:(NSInteger)withID
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=workorder&id=%d",[self crushHostName],withID];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	return [self fetchJSONValueForURL:url];	
}

+ (NSDictionary *)fetchSortingTableActivities
{
	NSString *devToken=[[[NSUserDefaults standardUserDefaults] objectForKey:@"devtoken"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=get_sortingTableActivities&devToken=%@",[self crushHostName],
						 devToken];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	NSDictionary *result=[self fetchJSONValueForURL:url];
	return result;
	
}
+ (NSDictionary *)fetchLotInfoForLotID:(NSString *)lotNumber 
{
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/test.php?action=showlotinfo&lot=%@&clientid=%@",[self crushHostName],lotNumber,
						 [[NSUserDefaults standardUserDefaults] objectForKey:@"clientid"]];
	NSURL *url = [NSURL URLWithString:urlString];
	NSLog(@"%@",urlString);
	NSDictionary *result=[self fetchJSONValueForURL:url];
	return result;
}

+ (float)totalWeight:(NSArray *)fromWeights
{
	float total=0;
	
	if (fromWeights != (NSArray *)[NSNull null])
	{
		for (NSDictionary *wts in fromWeights)
		{
			float weight=0;
			float tare=0;
			@try { weight=[[wts objectForKey:@"WEIGHT"] floatValue];} @catch (NSException * e) {}
			@try { tare=[[wts objectForKey:@"TARE"] floatValue];} @catch (NSException * e) {}
			total+=(weight-tare);
		}		
	}
	return total/2000.0;
}

+ (void)deleteWeightMeasurement:(NSUInteger) bindetailid 
{
	NSString *post=[[NSString alloc] initWithFormat:@"ID=%@&action=%@",[NSString stringWithFormat:@"%d",bindetailid,@"bindetail"]];
	NSData *myRequestData=[NSData dataWithBytes:[post UTF8String] length:[post length]];
	[post release];
	NSMutableURLRequest *request=[[[NSMutableURLRequest alloc] init] autorelease];

	NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/json/deleteitem.php",[self crushHostName]]];
	[request setURL:url];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:myRequestData];
	
	NSURLResponse *response;
	NSError *error;
	NSData *myData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSString *theresponse=[[NSString alloc] initWithData:myData encoding:NSStringEncodingConversionAllowLossy];
	NSDictionary *dictresponse=[theresponse JSONValue];
	[theresponse release];
	NSLog(@"Length of Return data: %d",myData.length);
	NSLog(@"%@",[dictresponse description]);
}

+(void)print:(CCActivity *)activity
{
	NSInteger dbid=activity.dbid;
	if ([[activity class] isSubclassOfClass:[activity class]]) {
		dbid=[(CCWT *)activity tagID];
	}
	NSDictionary *theParams=[[NSDictionary alloc] initWithObjectsAndKeys:NSStringFromClass([activity class]),@"class",
							 [NSString stringWithFormat:@"%d",dbid],@"dbid",
																   nil];
	[self sendPostFromDictionary:theParams withAction:@"print"];
	[theParams release];
}

+ (NSDate *)stripTimeFromDate:(NSDate *)theDate
{
	NSCalendar *cal=[[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDateComponents *components=[[[NSDateComponents alloc] init] autorelease];
	[components setYear:[[cal components:NSYearCalendarUnit fromDate:theDate] year]];
	[components setMonth:[[cal components:NSMonthCalendarUnit fromDate:theDate] month]];
	[components setDay:[[cal components:NSDayCalendarUnit fromDate:theDate] day]];
	return [cal dateFromComponents:components];
}

+ (NSString *)yesNoFromBOOL:(BOOL)theBool
{
	if (theBool)
		return @"YES";
	else 
		return @"NO";
}

+ (int) currentQuarter
{
	NSCalendar *cal=[[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	int currentMonth=[[cal components:NSMonthCalendarUnit fromDate:[NSDate date]] month];
	int currentQuarter=(currentMonth-1)/3+1;
	return currentQuarter;
}

+ (int) currentYear
{
	NSCalendar *cal=[[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	int theYear=[[cal components:NSYearCalendarUnit fromDate:[NSDate date]] year];
	return theYear;
}
+ (int) currentYearFromDate:(NSDate *)theDate
{
	NSCalendar *cal=[[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	int theYear=[[cal components:NSYearCalendarUnit fromDate:theDate] year];
	return theYear;
}

+ (NSDictionary *)sendPost:(NSArray *)values
{
	NSMutableString *post=[[NSMutableString alloc] init];
	
	for (NSString *val in values)
	{
		[post appendFormat:@"%@&",val];
	}
	NSData *myRequestData=[NSData dataWithBytes:[post UTF8String] length:[post length]];
	NSMutableURLRequest *request=[[[NSMutableURLRequest alloc] init] autorelease];
	
	NSString *urlString=[NSString stringWithFormat:@"http://%@/json/postitem.php",[self crushHostName]];
	NSURL *url=[NSURL URLWithString:urlString];
	[request setURL:url];
	[request setHTTPMethod:	@"POST"];
	[request setHTTPBody:myRequestData];
	
	NSLog(@"%@?%@",urlString,post);
	
	NSURLResponse *response;
	NSError *error;
	NSData *myData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSString *theresponse=[[[NSString alloc] initWithData:myData encoding:NSStringEncodingConversionAllowLossy] autorelease];
	[post release];
	return [theresponse JSONValue];
}
+ (NSDictionary *)sendPostFromDictionary:(NSDictionary *)dict withAction:(NSString *)action
{
	NSMutableArray *params=[[[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"action=%@",action],nil] autorelease];
	NSArray *allKeys=[dict allKeys];
	for (NSString *key in allKeys)
	{
		if ([[[dict objectForKey:key] class] isSubclassOfClass:[NSString class]])
		{
			NSString *val=[dict objectForKey:key];
			NSString *param=[NSString stringWithFormat:@"%@=%@",key,val];
			[params addObject:param];
		}
		else if ([[[dict objectForKey:key] class] isSubclassOfClass:[NSNumber class]])
		{
			NSString *val=[[dict objectForKey:key] stringValue];
			NSString *param=[NSString stringWithFormat:@"%@=%@",key,val];
			[params addObject:param];
		}
		else if ([[[dict objectForKey:key] class] isSubclassOfClass:[NSDate class]])
		{
			NSString *stringDate=[[dict objectForKey:key] description];
			[params addObject:[NSString stringWithFormat:@"DELIVERYDATE=%@",stringDate]];
			[params addObject:[NSString stringWithFormat:@"DUEDATE=%@",stringDate]];
		}
	}
	return [self sendPost:params];
}
+ (NSArray *)deleteLot:(NSString *)lotid
{
	NSDictionary *theParams=[[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:lotid,nil] forKeys:[NSArray arrayWithObjects:@"lotid",nil]];
	[self sendPostFromDictionary:theParams withAction:@"deletelot"];
	[theParams release];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"lotDeleted" object:nil];
	return nil;
}

+ (NSDictionary *)deleteWO:(NSString *)woid
{
	NSDictionary *post=[[NSDictionary alloc] initWithObjectsAndKeys:woid,@"ID",nil];
	return [self sendPostFromDictionary:post withAction:@"delete_wo"];
}

#pragma mark Miscellaneous Helpers
+(NSString *)blankIfNull:(NSString *)text
{
	if ([[NSNull null] isEqual:text])
		return @"";
	else if(text==nil)
		return @"";
	else
		return text;
}

+ (UIColor *)backGroundTheme
{
	UIColor *redTheme=[UIColor colorWithRed:196.0/255.0 green:65.0/255.0 blue:56.0/255.0 alpha:1.0];
	return redTheme;
}
+ (UIColor *)darkBlue
{
	UIColor *redTheme=[UIColor colorWithRed:19/255.0 green:25/255.0 blue:109/255.0 alpha:1.0];
	return redTheme;
}
+ (UIColor *)cellBackgroundColor
{
	UIColor *redTheme=[UIColor colorWithRed:223.0/255.0 green:159.0/255.0 blue:69.0/255.0 alpha:1.0];
	return redTheme;
}
+(UIColor *)navBarColor
{
	return [UIColor colorWithRed:.37 green:0 blue:0 alpha:.5];
}

+ (void)sendPushToClient:(CCClient *)theClient withMessage:(NSString *)message incrementBadge:(BOOL)badgeIncrement playSound:(BOOL)sound
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSDictionary *theParams=[[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:theClient.clientID,message,[NSNumber numberWithBool:badgeIncrement],
																	   [NSNumber numberWithBool:sound],[[UIDevice currentDevice] uniqueIdentifier], nil] 
															  forKeys:[NSArray arrayWithObjects:@"clientid",@"message",@"badgeIncrement",@"playSound",@"requestingUDID", nil]];
		[self sendPostFromDictionary:theParams withAction:@"sendPush"];
		[theParams release];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"messageSent" object:nil];
	});
}
+ (void)sendPushToStaffWithMessage:(NSString *)message incrementBadge:(BOOL)badgeIncrement playSound:(BOOL)sound
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSDictionary *theParams=[[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],
																	   message,
																	   [NSNumber numberWithBool:badgeIncrement],
																	   [NSNumber numberWithBool:sound],
																	   [[UIDevice currentDevice] uniqueIdentifier],
																	   nil] 
															  forKeys:[NSArray arrayWithObjects:@"clientid",
																	   @"message",
																	   @"badgeIncrement",
																	   @"playSound",
																	   @"requestingUDID", 
																	   nil]];
		[self sendPostFromDictionary:theParams withAction:@"sendPush"];
		[theParams release];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"messageSent" object:nil];
	});
}
+ (void)sendPushNotifyOfSortingTableUpdate
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:
							 [CrushHelper devToken],@"devToken",
							 nil] autorelease];
		[self sendPostFromDictionary:dict withAction:@"notifySortingTableChange"];
	});
}

+(CGRect)createRectInCenterWithPercentage:(float)percentage inCurrentBound:(CGRect)theBounds;
{
	float frameWidth=theBounds.size.width;
	float frameHeight=theBounds.size.height;
	float newFrameWidth=frameWidth*percentage;
	float newFrameHeight=frameHeight*percentage;
	
	return CGRectMake((frameWidth-newFrameWidth)/2, (frameHeight-newFrameHeight)/2, newFrameWidth, newFrameHeight);
}
+(float)calculateTankVolumeWithDiameter:(float)diameter andHeight:(float)height andConeHeight:(float)coneHeight andTankCapHeight:(float)tankCapHeight andLidDiameter:(float)lidDiameter
{
	float R=diameter/2;
	float r=lidDiameter/2;
	float cylinderArea=(pow(R,2)*kPI*height);
	float capArea=(pow(r, 2.0)*kPI*tankCapHeight);
	float coneArea=(kPI*coneHeight)/3*(pow(R, 2)+R*r+pow(r,2));
	return (coneArea+cylinderArea+capArea)/kCubicInchesToGallons;
}
@end
