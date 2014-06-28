//
//  JOFMalometerDocument.h
//  MalometerTDD
//
//  Created by Jorge D. Ortiz Fuentes on 28/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FreakType+Model.h"
#import "Domain+Model.h"

extern NSString *const freakTypesKey;
extern NSString *const domainsKey;


@interface JOFMalometerDocument : UIManagedDocument

- (void) importData:(NSDictionary *)dictionary;

@end
