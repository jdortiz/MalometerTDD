//
//  Agent+Model.h
//  MalometerTDD
//
//  Created by Jorge D. Ortiz Fuentes on 08/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "Agent.h"

extern NSString *const agentEntityName;


@interface Agent (Model)

+ (instancetype) agentInMOC:(NSManagedObjectContext *)moc;

@end
