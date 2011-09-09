//
//  CrushAppDelegate.m
//  Crush
//
//  Created by Kevin McQuown on 8/6/10.
//  Copyright Deck 5 Software 2010. All rights reserved.
//

#import "cellarworxAppDelegate.h"


#import "RootViewController.h"
#import "DetailViewController.h"
#import "CCVintage.h"
#import "CCClient.h"
#import "CCSortingTable.h"
#import "CCIcons.h"
#import "CrushHelper.h"
#import "CCSortingTableScheduleController.h"
#import "CCWorkOrder.h"
#import "CCTask.h"
#import "CCClient.h"

@implementation cellarworxAppDelegate

@synthesize window, splitViewController, rootViewController, detailViewController;
@synthesize staff;
@synthesize vintages;
@synthesize tasks;
@synthesize clientVintageChanged;
@synthesize sortingTable;
@synthesize icons;
@synthesize queue;
@synthesize staffTimer;
@synthesize db;
@synthesize facilities;
@synthesize navsorting;

#pragma mark -
#pragma mark cellarworx methods
-(CCVintage *)defaultVintage
{
	CCClient *theClient=[[[CCClient alloc] initWithNSUserDefaults] autorelease];
	return [[vintages objectForKey:[theClient clientCode]] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"vintage"]];
}

#pragma mark -
#pragma mark Application lifecycle

-(void) getStaff
{
	NSDictionary *dict=[CrushHelper fetchStaff];
	NSString *result=[dict objectForKey:@"staff"];
	if (result != nil)
	{
		if ([result isEqualToString:@"YES"])
			self.staff=YES;
		else 
			self.staff=NO;
	}
    [[NSNotificationCenter defaultCenter] postNotificationName:@"staffStatusChanged" object:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    self.staff=NO;
	clientVintageChanged=YES;
	staff=NO;
	
	sortingTable=[[CCSortingTable alloc] init];
	facilities=[[NSMutableArray alloc] init];
	db=[[NSMutableDictionary alloc] init];

	icons=[[CCIcons alloc] init];
    tasks=[[NSMutableDictionary alloc] init];
	vintages=[[NSMutableDictionary alloc] init];
	
	queue=[[NSOperationQueue alloc] init];
	[queue setMaxConcurrentOperationCount:1];
	NSInvocationOperation *myOp=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getStaff) object:nil];
	[queue addOperation:myOp];		
	[myOp release];	

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)];

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    CCSortingTableScheduleController *sorting=[[CCSortingTableScheduleController alloc] initWithNibName:@"CCSortingTableScheduleController" bundle:nil];
	navsorting=[[UINavigationController alloc] initWithRootViewController:sorting];
    [sorting release];
	[navsorting.navigationBar setTintColor:[CrushHelper navBarColor]];
    
    [window addSubview:navsorting.view];
    
    [window makeKeyAndVisible];
    
    return YES;
}

-(void)addTabBarItemImage:(NSString *)imageName toController:(UIViewController *)controller withTitle:(NSString *)title andTag:(NSInteger)tag
{
	UIImage *theImage=[UIImage imageNamed:imageName];
	UITabBarItem *item=[[UITabBarItem alloc] initWithTitle:title image:theImage tag:tag];
	controller.view.tag=tag;
	controller.tabBarItem=item;
	[item release];
}

-(CCVintage *)getVintageForClient:(CCClient *)client andYear:(int)year
{
	return [[vintages objectForKey:[client clientCode]] objectForKey:[NSNumber numberWithInt:year]];	
}
-(NSArray *)getBOLsForClient:(CCClient *)client
{
	return [[vintages objectForKey:client.clientCode] objectForKey:@"BOLs"];	
}
-(void)updateDBWithItem:(CCDatabaseObject *)theItem
{
	NSString *table=NSStringFromClass([theItem class]);
	NSMutableDictionary *items=[db objectForKey:table];
	if (items!=nil) {
		NSString *key=[NSString stringWithFormat:@"%d",theItem.dbid];
		NSDictionary *item=[items objectForKey:key];
		if (item!=nil)
		{
			[items removeObjectForKey:key];
			[items setObject:theItem forKey:key];
		}
		else 
		{
			[items setObject:theItem forKey:key];
		}
	}
	else {
		[db setObject:[[[NSMutableDictionary alloc] init] autorelease] forKey:table];
		[self updateDBWithItem:theItem];
	}
}

-(CCDatabaseObject *)getDBObjectWithItem:(CCDatabaseObject *)theItem
{
	NSString *table=NSStringFromClass([theItem class]);
	NSMutableDictionary *items=[db objectForKey:table];
	if (items!=nil)
	{
		NSString *key=[NSString stringWithFormat:@"%d",theItem.dbid];
		CCDatabaseObject *item=[items objectForKey:key];
		return item;
	}
	return nil;
}
-(void)deleteDBItem:(CCDatabaseObject *)theItem
{
	NSString *table=NSStringFromClass([theItem class]);
	NSMutableDictionary *items=[db objectForKey:table];
	if (items!=nil)
	{
		NSString *key=[NSString stringWithFormat:@"%d",theItem.dbid];
		[items removeObjectForKey:key];
	}	
}

-(void)addWO:(CCWorkOrder *)theWO toTask:(NSString *)taskID
{
	CCTask *theTask=[tasks objectForKey:taskID];
	CCWorkOrder *workOrderToReplace=nil;
	if (theTask != nil)
	{
		for (CCWorkOrder *wo in [theTask.workOrders allObjects])
		{
			if (wo.dbid==theWO.dbid) {
				workOrderToReplace=wo;
			}
		}
		if (workOrderToReplace!=nil) {
			[theTask.workOrders removeObject:workOrderToReplace];
		}
		[theTask.workOrders addObject:theWO];
		theWO.task=theTask;
	}
	else {
		CCTask *newTask=[[CCTask alloc] initWithWorkOrder:theWO];
		newTask.dbid=[taskID intValue];
		[tasks setObject:newTask forKey:[NSString stringWithFormat:@"%d",newTask.dbid]];
		theWO.task=newTask;
		[newTask release];
	}
	
}

-(void)setVintageForClient:(CCClient *)client andYear:(int)year
{
	//	[mainLock lock];
	CCVintage *theVintage=[[vintages objectForKey:[client clientCode]] objectForKey:[NSNumber numberWithInt:year]];
	if (clientVintageChanged || ([self defaultVintage]==nil))
	{
		clientVintageChanged=NO;
		if ([vintages objectForKey:[client clientCode]]==nil)
		{
			NSMutableDictionary *newClient=[[NSMutableDictionary alloc] init];
			CCVintage *newVintage=[[CCVintage alloc] initWithClient:client andVintageYear:year withDetail:NO];
			[newClient setObject:newVintage forKey:[NSString stringWithFormat:@"%4d",year]];
			[newVintage release];
			[vintages setObject:newClient forKey:[client clientCode]];
			[newClient release];
		}
		else {
			if (theVintage==nil) {
				CCVintage *newVintage=[[CCVintage alloc] initWithClient:client andVintageYear:year withDetail:NO];
				[[vintages objectForKey:[client clientCode]] setObject:newVintage forKey:[NSString stringWithFormat:@"%4d",year]];
				[newVintage release];
			}
		}
	}
	else {
		CCVintage *newVintage=[[CCVintage alloc] initWithClient:client andVintageYear:year withDetail:NO];
		[[vintages objectForKey:[client clientCode]] setObject:newVintage forKey:[NSString stringWithFormat:@"%4d",year]];
		[newVintage release];
	}
	//	[mainLock unlock];
	return;
}

-(void)sendDevToken:(NSData *)devToken
{
	[CrushHelper sendProviderDeviceToken:devToken];	
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken 
{
    //	queue=[[NSOperationQueue alloc] init];
	NSInvocationOperation *operation=[[NSInvocationOperation alloc] initWithTarget:self 
																		  selector:@selector(sendDevToken:) 
																			object:devToken];
	[queue addOperation:operation];
	[operation release];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error 
{
	NSString *st=[[NSString alloc] initWithString:[[UIDevice currentDevice] uniqueIdentifier]];
	NSData *devToken=[[NSData alloc] initWithData:[st dataUsingEncoding:NSUTF8StringEncoding]];
	NSInvocationOperation *operation=[[NSInvocationOperation alloc] initWithTarget:self 
																		  selector:@selector(sendDevToken:) 
																			object:devToken];
	[queue addOperation:operation];
	[st release];
	[devToken release];
	[operation release];
	
	NSLog(@"Error in registration. Error: %@",error);
	
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	
	NSDictionary *theNotice=[userInfo objectForKey:@"notice"];
	
	if (theNotice)
	{
		if ([[theNotice objectForKey:@"sl"] isEqualToString:@"update"]) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"sortingTableNeedsUpdating" object:nil];
		}
		NSLog(@"push received");
	}
	else {
        //		AudioServicesPlaySystemSound(kSystemSoundID_UserPreferredAlert);
        //		UIAlertView *pushNotice=[[UIAlertView alloc] initWithTitle:@"Crush" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"View",nil];
        //		[pushNotice show];
        //		[pushNotice release];
	}
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [navsorting release];
	[facilities release];
	[db release];
	[staffTimer release];
    [queue release];
    [icons release];
    [sortingTable release];
    [tasks release];
	[vintages release];
    [splitViewController release];
    [window release];
    [super dealloc];
}


@end

