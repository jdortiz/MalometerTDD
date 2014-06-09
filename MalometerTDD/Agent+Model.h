//
//  Agent+Model.h
//  MalometerTDD
//
//  Created by Jorge D. Ortiz Fuentes on 08/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "Agent.h"

extern NSString *const agentEntityName;
extern NSString *const agentPropertyDestructionPower;
extern NSString *const agentPropertyMotivation;
extern NSString *const agentPropertyAssessment;


@interface Agent (Model)

+ (instancetype) agentInMOC:(NSManagedObjectContext *)moc;

@end
