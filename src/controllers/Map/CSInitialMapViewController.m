//
//  CSInitialMapViewController.m
//  CycleStreets
//
//  Created by Neil Edwards on 13/02/2014.
//  Copyright (c) 2014 CycleStreets Ltd. All rights reserved.
//

#import "CSInitialMapViewController.h"
#import "CycleStreets.h"

#import "BuildTargetConstants.h"

@interface CSInitialMapViewController ()

@end

@implementation CSInitialMapViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[CycleStreets sharedInstance].storyBoardName bundle:nil];
	
	switch ([BuildTargetConstants buildTarget]) {
		case ApplicationBuildTarget_CycleStreets:
		{
			self = [super initWithCenterViewController:[storyboard instantiateViewControllerWithIdentifier:@"MapViewController"]
									leftViewController:[storyboard instantiateViewControllerWithIdentifier:@"WayPointNavController"]];
		}
		break;
			
		case ApplicationBuildTarget_CNS:
		{
			self = [super initWithCenterViewController:[storyboard instantiateViewControllerWithIdentifier:@"MapViewController"]
									leftViewController:[storyboard instantiateViewControllerWithIdentifier:@"WayPointNavController"]
									rightViewController:[storyboard instantiateViewControllerWithIdentifier:@"POINavController"]];
		}
		break;
	}
	
	
	
	// fix for "Presenting view controllers on detached view controllers is discouraged" warning
	self.title=@"Map";
	[self addChildViewController:self.centerController];
    if (self) {
        self.panningMode=IIViewDeckNoPanning;
		self.delegateMode=IIViewDeckDelegateAndSubControllers;
		self.centerhiddenInteractivity=IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
		self.navigationControllerBehavior = IIViewDeckNavigationControllerIntegrated;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.tabBarItem.image=[UIImage imageNamed:@"CSTabBar_plan_route.png"];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
