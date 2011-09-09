

#import <Foundation/Foundation.h>

#define USE_TEST_SERVER 0

#define kPickCustomerVintage 2
#define kLotList 1
#define kToDo 0
#define kWTs 3
#define kSCPs 4
#define kpress 5
#define kfermProtocols 6
#define kPOPD 7
#define kVineyards 8
#define kppm 9
#define kreports 10
#define ksorting 11
#define kBOLs 12

#define kTotalTabs 13

#define kPI 3.1415927
#define kCubicInchesToGallons 231
#define ktallestTankHeight 120

#define klowBrix -2.0
#define kHighBrix 35.0
#define klowTemp 40
#define kHighTemp 105


#import <CoreData/CoreData.h>
#import "CCWorkOrder.h"
#import "CCVintage.h"
#import "CCVineyard.h"
#import "CCClient.h"

BOOL backendServerAlertGiven;
BOOL backendServerValid;
BOOL phoneRegistered;
BOOL staff;


@interface CrushHelper : NSObject {	
	
}

//+(CrushHelper *)myApplication;

+ (NSMutableArray *)sharedInterface;

// Returns a dictionary with info about the given username.
// This method is synchronous (it will block the calling thread).
+ (NSDictionary *)fetchDefaults;
+ (NSDictionary *)fetchStaff;

+ (NSString *)crushHostName;
//+ (NSArray *)fetchVarietals;
+ (NSArray *)fetchAppellations;
+ (NSDictionary *)fetchList:(NSString *)listName fromTable:(NSString *)table;
+ (NSArray *)fetchOutstandingWOs;
+ (NSArray *)fetchOutstandingSCPs;
+ (NSArray *)fetchSCPsForSeason;
+ (NSArray *)fetchOutstandingSCPsForToday;
//+ (NSArray *)fetchOutstandingSCPsAfterTodayFromView:(UIViewController *)view;
+ (NSArray *)fetchOutstandingPOsFromView:(UIViewController *)view;
+ (NSArray *)fetchNewWOsFromView:(UIViewController *)view;
+ (NSArray *)fetchBOLsForClient:(CCClient *)theClient;
+ (NSArray *)fetchLocations;
+ (NSArray *)fetchAssetList;
+ (NSArray *)fetchAssetListOfTanks;
+ (NSArray *)fetchTankCapacityAnalysisData;
+ (NSArray *)getFermentationProtocols;
+ (NSDictionary *)getActiveFerms;
+ (NSArray *)getBrixTempListForLot:(NSString *)l andVessel:(NSString *)v;

+ (NSArray *)fetchLotsForClient: (CCClient *)client withYear:(int)vintage withDetail:(BOOL)detail;
+ (NSArray *) fetchTotalTonnageForClientocde: (NSString *)clientid withYear:(int)vintage;
+ (NSArray *) fetchTotalGallonsForClientcode: (NSString *)clientid withYear:(int)vintage;
+ (NSDictionary *)fetchWO:(NSInteger)withID;

+ (void)modifyLot:(NSString *)clientid withYear:(int)vintage withDescription:(NSString *) description withLotNumber:(NSString *)lotnumber;
//+ (void)modifyLot:(NSString *)forLotID withDescription:(NSString *) description;
+ (NSArray *)deleteLot:(NSString *)lotid;
+ (NSDictionary *)deleteWO:(NSString *)woid;
+ (int) currentQuarter;
+ (int) currentYear;
+ (int) currentYearFromDate:(NSDate *)theDate;
+ (NSDate *)stripTimeFromDate:(NSDate *)theDate;
+ (NSNumberFormatter *) numberFormatQtyWithDecimals:(int)decimalCount;

+ (NSDictionary *)fetchSortingTableActivities;

+ (void)setBadges:(NSDictionary *)badgeCounts;
+ (NSString *)devToken;

+ (NSArray *)fetchWeighTagsForClientcode:(NSString *)clientid withVintage:(CCVintage *)vintage inView:(UIViewController *)view;
+ (NSArray *)fetchWeighTagsForVintage:(CCVintage *)vintage inView:(UIViewController *)view;
+ (NSArray *)fetchWeighTagsForTodayInView:(UIViewController *)view;
+ (NSArray *)fetchFacilityWeight:(UIViewController *)view;
+ (NSArray *)fetchFacilityList;
+ (NSDictionary *)fetchBOLByID:(NSInteger)dbid;

+ (NSDictionary *)fetchLotInfoForLotID:(NSString *)lotNumber;

+ (float)totalWeight:(NSArray *)fromWeights;

+ (NSDateFormatter *)timeOfDayFormat;
+ (NSDateFormatter *)dateFormatShortStyle;
+ (NSDateFormatter *)dateFormatSQLStyle;
+ (NSDateFormatter *)dateAndTimeFormatSQLStyle;
+ (NSString *)dateAndTimeString:(NSDate *)theDate;

+ (NSString *)yesNoFromBOOL:(BOOL)theBool;

+ (void)deleteWeightMeasurement:(NSUInteger) bindetailid;
//+ (NSDictionary *)sendPost:(NSArray *)values;
+ (NSDictionary *)sendPostFromDictionary:(NSDictionary *)dict withAction:(NSString *)action;

+ (void)sendProviderDeviceToken:(NSData *)devToken;

+(NSString *)blankIfNull:(NSString *)text;
//+(NSString *)blankIfNullOrNill:(NSDictionary *)dict objectForKey:(NSString *)key;

+(void)setDefaultClientAndVintageFromWO:(CCWorkOrder *)wo;
+(void)setDefaultClientAndVintageFromWT:(CCWT *)wt andView:(UIViewController *)view;

+(CCVintage *)getVintageDataUsingViewController:(UIViewController *)controller;
//+(void) setVintageUsingViewController:(UIViewController *)controller withVintage:(CCVintage *)v;
+ (CCWorkOrder *)getWOReferenceFromWO:(CCWorkOrder *)wo;
+ (CCWT *)getWTReferenceFromWT:(CCWT *)wt   inView:(UIViewController *)view;

+(BOOL) isStaffOrClientwithClientCode:(NSString *)cc;

+(NSString *)boolDescription:(BOOL)b;

+(UIColor *) getSCPColorFromColorString:(NSString *)theColor;
+(NSString *) getColorStringFromColor:(UIColor *)color;
+(NSString *) getColorStringFromColor1:(UIColor *)color1 andColor2:(UIColor *)color2;

+(void)print:(CCActivity *)activity;

+(UIColor *) organicGreen;
+(id)nillIfNull:(id)value;

+ (NSNumberFormatter *) numberFormatQty;
+ (NSNumberFormatter *) numberFormatQtyNoDecimals;
+ (NSNumberFormatter *) numberFormatCurrency;
+ (NSNumberFormatter *) numberFormatCurrencyNoCents;
+ (NSSortDescriptor *) sortDateDescending;
+ (NSSortDescriptor *) sortDateAscending;
+ (NSDateFormatter *)dateFormatSQL;
+ (NSDateFormatter *)dateFormatSQLLong;
+ (NSDateFormatter *)dateFormatRegular;
+ (NSDateFormatter *)dateFormatShortNoYear;
+ (NSDateFormatter *)dateFormatDay;

+ (float) calcSO2MLWithPPM:(NSInteger)ppm andTons:(float)tons andGallonsPerTon:(NSInteger)gallonsPerTon;

+ (UIColor *)backGroundTheme;
+ (UIColor *)darkBlue;
+ (UIColor *)cellBackgroundColor;
+(UIColor *)navBarColor;

+ (void)sendPushToClient:(CCClient *)theClient withMessage:(NSString *)message incrementBadge:(BOOL)badgeIncrement playSound:(BOOL)sound;
+ (void)sendPushToStaffWithMessage:(NSString *)message incrementBadge:(BOOL)badgeIncrement playSound:(BOOL)sound;
+ (void)sendPushNotifyOfSortingTableUpdate;

+(CGRect)createRectInCenterWithPercentage:(float)percentage inCurrentBound:(CGRect)theBounds;

+(float)calculateTankVolumeWithDiameter:(float)diameter andHeight:(float)height andConeHeight:(float)coneHeight andTankCapHeight:(float)tankCapHeight andLidDiameter:(float)lidDiameter;


@end
