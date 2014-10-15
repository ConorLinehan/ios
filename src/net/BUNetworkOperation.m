//
//  BUNetworkOperation.m
//  CycleStreets
//
//  Created by Neil Edwards on 03/03/2014.
//  Copyright (c) 2014 CycleStreets Ltd. All rights reserved.
//

#import "BUNetworkOperation.h"

#import "AppConstants.h"
#import "NSDictionary+UrlEncoding.h"
#import "StringUtilities.h"
#import "GlobalUtilities.h"
#import "CJSONSerializer.h"

#import "CycleStreets.h"

@interface BUNetworkOperation()





@end

@implementation BUNetworkOperation



- (instancetype)init {
	
	if (self = [super init]) {
		
		_source=DataSourceRequestCacheTypeUseNetwork;
		_trackProgress=NO;
		
	}
    return self;
}


-(void)setService:(NSDictionary *)aService{
    
    if (_service != aService) {
        _service = aService;
    }
    
    self.dataType=[GenericConstants parserStringTypeToConstant:[_service objectForKey:@"parserType"]];
}


// creates /x/x/x/ based based url suffixes
-(NSString*)urlForRequestType{
    
    NSString *servicetype=[_service objectForKey:@"type"];
    
    if ([servicetype isEqualToString:URL]) {
		
		return [[_parameters objectForKey:@"parameterarray"] componentsJoinedByString:@"/"];
		
    }
    
    return nil;
}


-(NSDictionary*)parametersForRequestType{
    
    
	NSString *servicetype=[_service objectForKey:@"type"];
	
	if(_parameters==nil)
		self.parameters=[NSMutableDictionary dictionary];
	
	
	self.dataType=[GenericConstants parserStringTypeToConstant:[_service objectForKey:@"parserType"]];
	
	if ([servicetype isEqualToString:URL]) {
		
		
	}else if([servicetype isEqualToString:POST]){
		
		
		if([_service objectForKey:CONTROLLER]!=nil)
			[_parameters setValue:[_service objectForKey:CONTROLLER] forKey:@"c"];
		if([_service objectForKey:CONTROLLER]!=nil)
			[_parameters setValue:[_service objectForKey:@"method"] forKey:@"m"];
		
		
	}else if ([servicetype isEqualToString:GET]) {
		
		BetterLog(@"parameters=%@",_parameters);
		
		// optional support for server side methods/controllers
		NSString *controllerString=[_service objectForKey:CONTROLLER];
		NSString *methodString=[_service objectForKey:@"method"];
		
		if(controllerString!=nil)
			[_parameters setValue:controllerString forKey:@"c"];
		if(methodString!=nil)
			[_parameters setValue:methodString forKey:@"m"];
		
        
		
	}else{
		
		
		
	}
	
	
	
	return _parameters;
}




#pragma mark - Request construction




-(NSMutableURLRequest*)requestForType{
	
	NSString *servicetype=[_service objectForKey:@"type"];
	
	return [self createRequestForServiceType:servicetype];
	
}




-(NSMutableURLRequest*)createRequestForServiceType:(NSString*)servicetype{
	
	NSMutableURLRequest *request=nil;
	NSURL *requesturl=nil;
	
	self.dataType=[GenericConstants parserStringTypeToConstant:[_service objectForKey:@"parserType"]];
	
	if ([servicetype isEqualToString:URL]) {
		
		NSString *urlString=[StringUtilities urlFromParameterArray:[_parameters objectForKey:@"parameterarray"] url:[[self url] mutableCopy]];
		requesturl=[NSURL URLWithString:urlString];
		
		request = [NSMutableURLRequest requestWithURL:requesturl
										  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
									  timeoutInterval:30.0 ];
		
		BetterLog(@"url type url: %@",urlString);
		
	}else if([servicetype isEqualToString:POST]){
		
		requesturl=[NSURL URLWithString:[self url]];
		
		request = [NSMutableURLRequest requestWithURL:requesturl
										  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
									  timeoutInterval:30.0 ];
		
		
		NSString *parameterString=[_parameters urlEncodedString];
		NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[parameterString length]];
		[request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
		[request setHTTPMethod:@"POST"];
		[request setHTTPBody: [parameterString dataUsingEncoding:NSUTF8StringEncoding]];
		
		[request setValue:[CycleStreets sharedInstance].userAgent forHTTPHeaderField:@"User-Agent"];
		
		
	}else if ([servicetype isEqualToString:GET]) {
		
		NSString *urlString=[[NSString alloc]initWithFormat:@"%@?%@",[self url],[_parameters urlEncodedString]];
		
		BetterLog(@"parameters=%@",_parameters);
		BetterLog(@"GET url=%@",urlString);
		
		
		requesturl=[NSURL URLWithString:urlString];
		
		request = [NSMutableURLRequest requestWithURL:requesturl
										  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
									  timeoutInterval:30.0 ];
		
		[request setValue:[CycleStreets sharedInstance].userAgent forHTTPHeaderField:@"User-Agent"];
		
		
	}else if([servicetype isEqualToString:POSTJSON]){
		
		requesturl=[NSURL URLWithString:[self url]];
		
		request = [NSMutableURLRequest requestWithURL:requesturl
										  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
									  timeoutInterval:30.0 ];
		
		NSString *parameterString = [[NSString alloc] initWithData:[[CJSONSerializer serializer] serializeDictionary:_parameters error:nil]
                                                          encoding:NSUTF8StringEncoding];
		
		BetterLog(@"parameters=%@",_parameters);
		
		NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[parameterString length]];
		[request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
		[request setHTTPMethod:@"POST"];
		[request setHTTPBody: [parameterString dataUsingEncoding:NSUTF8StringEncoding]];
		[request setValue:[CycleStreets sharedInstance].userAgent forHTTPHeaderField:@"User-Agent"];
		
		
	}else if([servicetype isEqualToString:GETPOST]){
		
		NSDictionary *getparameters=[_parameters objectForKey:@"getparameters"];
		NSDictionary *postparameters=[_parameters objectForKey:@"postparameters"];
		
		NSString *urlString=[[NSString alloc]initWithFormat:@"%@?%@",[self url],[getparameters urlEncodedString]];
		requesturl=[NSURL URLWithString:urlString];
		
		request = [NSMutableURLRequest requestWithURL:requesturl
										  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
									  timeoutInterval:30.0 ];
		
		NSLog(@"[DEBUG] GETPOST SEND url:%@",urlString);
		NSLog(@"[DEBUG] GETPOST SEND body:%@",[postparameters urlEncodedString]);
		
		NSString *parameterString=[postparameters urlEncodedString];
		
		[request setHTTPMethod:@"POST"];
		NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[parameterString length]];
		[request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
		NSString *contentType = @"application/x-www-form-urlencoded";
		[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
		[request setHTTPBody: [parameterString dataUsingEncoding:NSUTF8StringEncoding]];
		[request setValue:[CycleStreets sharedInstance].userAgent forHTTPHeaderField:@"User-Agent"];
		
	}else if([servicetype isEqualToString:IMAGEPOST]){
		
		NSDictionary *getparameters=[_parameters objectForKey:@"getparameters"];
		NSDictionary *postparameters=[_parameters objectForKey:@"postparameters"];
        NSData *imageData=[postparameters objectForKey:@"imageData"];
		
		if(imageData!=nil){
			
			[postparameters        setValue:nil forKey:@"imageData"];
			
			// optional get parameters
			NSString *urlString;
			if(getparameters!=nil){
				urlString=[[NSString alloc]initWithFormat:@"%@?%@",[self url],[getparameters urlEncodedString]];
			}else{
				urlString=[self url];
			}
			
			BetterLog(@"IMAGEPOST url=%@",urlString);
			
			requesturl=[NSURL URLWithString:urlString];
			
			request = [NSMutableURLRequest requestWithURL:requesturl
											  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
										  timeoutInterval:30.0 ];
			
			
			
			NSMutableData *body = [[NSMutableData alloc] init];
			
			// Image Data
			[request addValue:@"gzip" forHTTPHeaderField:@"Accepts-Encoding"];
			[request setHTTPMethod:@"POST"];
			NSString *stringBoundary = @"0xBoundaryBoundaryBoundaryBoundary";
			NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
			[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
			[request setValue:[CycleStreets sharedInstance].userAgent forHTTPHeaderField:@"User-Agent"];
			
			[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[@"Content-Disposition: form-data; name=\"mediaupload\"; filename=\"from_iphone.jpeg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:imageData];
			
			// POST form content
			
			[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
			
			[self appendFormValues:postparameters toPostData:body];
			
			[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
			
			//
			
			[request setHTTPBody: body];
			
		}else{
			
			request=[self createRequestForServiceType:GETPOST];
			
		}
		
		
        
	}
	
	return request;
	
}


- (void)appendFormValues:(NSDictionary*)postparameters toPostData:(NSMutableData*)data {
	
	NSString *stringBoundary = @"0xBoundaryBoundaryBoundaryBoundary";
	
	for(NSString *key in postparameters){
		
		[data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		NSString *line = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
		[data appendData:[line dataUsingEncoding:NSUTF8StringEncoding]];
		[data appendData:[[postparameters objectForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
		
	}
	
}


-(NSMutableURLRequest*)addRequestHeadersForService:(NSMutableURLRequest*)request{
    
    if(request!=nil){
        NSDictionary *headerdict=[_service objectForKey:@"headers"];
        if (headerdict!=nil) {
            for(NSString *key in headerdict){
                [request setValue:key forHTTPHeaderField:[headerdict objectForKey:key]];
            }
        }
    }
    
    return request;
    
}




-(NSString*)requestParameterForType:(NSString*)type{
	
	return _parameters[type];
}





#pragma mark - Errors

+ (NSString*)errorTypeToString:(BUNetworkOperationError)errorType {
    
//	if(errorType==NetResponseErrorInvalidResponse){
//		return @"InvalidResponse";
//	}else if (errorType==NetResponseErrorNotConnected){
//		return @"ConnectionFailed";
//	}else if (errorType==NetResponseErrorParserFailed) {
//		return @"ParserFailed";
//	}else if (errorType==NetResponseErrorNoResults) {
//		return @"NoResults";
//	}
	
    return NONE;
}



#pragma mark - getter methods


-(NSString*)url{
	
	return [_service objectForKey:REMOTEURL];
	
}

-(BOOL)serviceShouldBeCached{
    if(_service!=nil){
        
        if(_service[@"cache"]!=nil){
            return [_service[@"cache"] boolValue];
        }
        
    }
    return NO;
}


-(int)serviceCacheInterval{
    
    if(_service!=nil){
        
        if(_service[@"cacheInterval"]!=nil){
            return [_service[@"cacheInterval"] intValue];
        }else{
            return 0;
        }
        
    }
    
    return 0;
    
}


#pragma mark - BUCodableObject

-(NSArray*)uncodableProperties{
	return @[_completionBlock,_parameters,_service,];
}


@end
