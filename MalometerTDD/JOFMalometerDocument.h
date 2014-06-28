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
#import "Agent+Model.h"

extern NSString *const freakTypesKey;
extern NSString *const domainsKey;
extern NSString *const agentsKey;


@interface JOFMalometerDocument : UIManagedDocument

@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSURL *initialDataURL;

- (void) importData:(NSDictionary *)dictionary;

@end
