//
//  Agent+Model.m
//  MalometerTDD
//
//  Created by Jorge D. Ortiz Fuentes on 08/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "Agent+Model.h"

NSString *const agentEntityName = @"Agent";

@implementation Agent (Model)

#pragma mark - Convenience constructor

+ (instancetype) agentInMOC:(NSManagedObjectContext *)moc {
    return [NSEntityDescription insertNewObjectForEntityForName:agentEntityName
                                         inManagedObjectContext:moc];
}

@end
