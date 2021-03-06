//
//  StringManager.h
//
//
//  Created by Neil Edwards on 19/02/2010.
//  Copyright 2010 Buffer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@protocol StringManagerDelegate<NSObject>

@optional
-(void)startupComplete;
-(void)startupFailedWithError:(NSString*)error;

@end


@interface StringManager : NSObject {
	
	NSMutableDictionary *stringsDict;
	
	id<StringManagerDelegate> __unsafe_unretained delegate;
	

}
@property(nonatomic,strong)NSMutableDictionary *stringsDict;
@property(nonatomic,unsafe_unretained)id<StringManagerDelegate> delegate;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(StringManager);

-(void)initialise;
-(NSString*)stringForSection:(NSString*)section andType:(NSString*)type;
@end
