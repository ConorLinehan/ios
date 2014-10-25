//
//  SegmentVO.h
//  CycleStreets
//
//  Created by Neil Edwards on 24/10/2011.
//  Copyright (c) 2011 CycleStreets Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SegmentVO : NSObject <NSCoding>


@property (nonatomic, strong)	NSString							*roadName;
@property (nonatomic, strong)	NSString							*provisionName;
@property (nonatomic, strong)	NSString							*turnType;
@property (nonatomic)	NSInteger									walkValue;
@property (nonatomic)	NSInteger									segmentTime;
@property (nonatomic)	NSInteger									segmentDistance;
@property (nonatomic)	NSInteger									startBearing;
@property (nonatomic)	NSInteger									segmentBusynance;
@property (nonatomic)	NSInteger									startTime;
@property (nonatomic)	NSInteger									startDistance;
@property (nonatomic, strong)	NSArray								*pointsArray;

@property (nonatomic, strong)	NSString							*elevations;

// getters
@property (nonatomic, readonly)	NSString		*timeString;
@property (nonatomic, readonly)	CLLocationCoordinate2D				segmentStart;
@property (nonatomic, readonly)	CLLocationCoordinate2D				segmentEnd;

@property (nonatomic, readonly)	NSString							*provisionIcon;
@property (nonatomic, readonly)	NSDictionary						*infoStringDictionary;


@property (nonatomic, readonly)	BOOL								isWalkingSection;
@property (nonatomic, readonly)	int									segmentElevation;
@property (nonatomic, readonly)	int									maxElevation;


// return array of allpoints for this segment
- (NSArray *)allPoints;


- (NSString *) infoString;

+(NSString*)provisionIconForType:(NSString*)type isWalking:(int)walking;// legacy support for walking
+(NSString*)iconForType:(NSString*)type;

-(CLLocationCoordinate2D)maxNorthEastForLocation:(CLLocation*)comparelocation;
-(CLLocationCoordinate2D)maxSouthWestForLocation:(CLLocation*)comparelocation;

@end

