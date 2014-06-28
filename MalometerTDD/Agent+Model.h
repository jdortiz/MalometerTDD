//
//  Agent+Model.h
//  MalometerTDD
//
//  Created by Jorge D. Ortiz Fuentes on 08/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "Agent.h"

typedef NS_ENUM(NSUInteger, AgentErrorCode) {
    AgentErrorCodeNameNotDefined = 1,
    AgentErrorCodeNameEmpty
};


extern NSString *const agentEntityName;
extern NSString *const agentPropertyName;
extern NSString *const agentPropertyDestructionPower;
extern NSString *const agentPropertyMotivation;
extern NSString *const agentPropertyAssessment;
extern NSString *const agentRelationshipFreakTypeName;
extern NSString *const agentRelationshipDomainNames;


@interface Agent (Model)

+ (instancetype) agentInMOC:(NSManagedObjectContext *)moc;
+ (instancetype) agentInMOC:(NSManagedObjectContext *)moc withDictionary:(NSDictionary *)dict;
- (NSString *) generatePictureUUID;
+ (NSFetchRequest *) fetchAllAgentsWithSortDescriptors:(NSArray *)sortDescriptors;
+ (NSFetchRequest *) fetchAllAgentsByName;
+ (NSFetchRequest *) fetchAllAgentsWithPredicate:(NSPredicate *)predicate;
- (BOOL) validateName:(NSString **)name error:(NSError *__autoreleasing *)error;

@end
