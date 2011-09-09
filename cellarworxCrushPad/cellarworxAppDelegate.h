//
//  CrushAppDelegate.h
//  Crush
//
//  Created by Kevin McQuown on 8/6/10.
//  Copyright Deck 5 Software 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSecretPin 2846
#define kPinDelayTimeInSeconds 30

@class RootViewController;
@class DetailViewController;
@class CCVintage;
@class CCSortingTable;
@class CCIcons;
@class CCWorkOrder;
@class CCDatabaseObject;
@class CCClient;
@interface cellarworxAppDelegate : UIResponder <UIApplicationDelegate> {
    
    UIWindow *window;
    
    UISplitViewController *splitViewController;
    
    RootViewController *rootViewController;
    DetailViewController *detailViewController;
	
    NSOperationQueue *queue;
    
	NSMutableDictionary *vintages;
    NSMutableDictionary *tasks;
    CCIcons *icons;
	BOOL staff;
    BOOL clientVintageChanged;
    CCSortingTable *sortingTable;
	NSMutableArray *facilities;
	
	NSMutableDictionary *db;
	
	NSTimer *staffTimer;
}
@property (nonatomic, retain) NSMutableArray *facilities;
@property (nonatomic, retain) NSMutableDictionary *db;
@property (nonatomic, retain) NSTimer *staffTimer;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property BOOL staff;
@property BOOL clientVintageChanged;
@property (nonatomic, retain) NSMutableDictionary *vintages;
@property (nonatomic, retain) NSMutableDictionary *tasks;
@property (nonatomic, retain) CCSortingTable *sortingTable;
@property (nonatomic, retain) CCIcons *icons;
@property (nonatomic, retain) NSOperationQueue *queue;

@property (nonatomic, retain) UINavigationController *navsorting;

-(CCVintage *)defaultVintage;

-(CCVintage *)getVintageForClient:(CCClient *)client andYear:(int)year;
-(NSArray *)getBOLsForClient:(CCClient *)client;

-(void)addWO:(CCWorkOrder *)theWO toTask:(NSString *)taskID;

-(void)deleteDBItem:(CCDatabaseObject *)theItem;
-(void)updateDBWithItem:(NSObject *)theItem;
-(CCDatabaseObject *)getDBObjectWithItem:(CCDatabaseObject *)theItem;

@end
