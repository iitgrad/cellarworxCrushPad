//
//  WTSummaryCellController.m
//  CCC2
//
//  Created by Kevin McQuown on 5/28/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "WTSummaryCellController.h"
#import "CrushHelper.h"

@implementation WTSummaryCellController
@synthesize bincount, gross, tare, net, tons;
@synthesize grossWeight;
@synthesize netWeight;
@synthesize tareWeight;
@synthesize totalTons;
@synthesize totalBinCount;
@synthesize averageWeightPerBin;



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateAverageBinWeight
{
	if (totalBinCount==0) {
		averageWeightPerBin.text=@"";
		return;
	}
	float average=netWeight/totalBinCount;
	averageWeightPerBin.text=[[CrushHelper numberFormatQtyNoDecimals] stringFromNumber:[NSNumber numberWithInt:(int)average]];
}

- (void) setGrossWeight:(int)value
{
	grossWeight=value;
	gross.text=[[CrushHelper numberFormatQtyNoDecimals] stringFromNumber:[NSNumber numberWithInt:value]];
	[self updateAverageBinWeight];
}
- (void) setNetWeight:(int)value
{
	netWeight=value;
	net.text=[[CrushHelper numberFormatQtyNoDecimals] stringFromNumber:[NSNumber numberWithInt:value]];
}
- (void) setTareWeight:(int)value
{
	tareWeight=value;
	tare.text=[[CrushHelper numberFormatQtyNoDecimals] stringFromNumber:[NSNumber numberWithInt:value]];
}

- (void) setTotalBinCount:(int)value
{
	totalBinCount=value;
	bincount.text=[[CrushHelper numberFormatQtyNoDecimals] stringFromNumber:[NSNumber numberWithInt:value]];
	[self updateAverageBinWeight];
}
- (void) setTotalTons:(float)value
{
	totalTons=value;
	tons.text=[[CrushHelper numberFormatQtyWithDecimals:1] stringFromNumber:[NSNumber numberWithFloat:value]];
}

- (void)dealloc {
	[averageWeightPerBin release];
    [gross release];
    [net release];
    [tare release];
    [tons release];
    [bincount release];
    [super dealloc];
}


@end
