//
//  Agent+Model.m
//  MalometerTDD
//
//  Created by Jorge D. Ortiz Fuentes on 08/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "Agent+Model.h"
#import "FreakType+Model.h"
#import "Domain+Model.h"

NSString *const agentEntityName = @"Agent";
NSString *const agentPropertyName = @"name";
NSString *const agentPropertyDestructionPower = @"destructionPower";
NSString *const agentPropertyMotivation = @"motivation";
NSString *const agentPropertyAssessment = @"assessment";
NSString *const agentErrorDomain = @"AgentModelError";


@implementation Agent (Model)

#pragma mark - Convenience constructors

+ (instancetype) agentInMOC:(NSManagedObjectContext *)moc {
    return [NSEntityDescription insertNewObjectForEntityForName:agentEntityName
                                         inManagedObjectContext:moc];
}


+ (instancetype) agentInMOC:(NSManagedObjectContext *)moc withDictionary:(NSDictionary *)dict {
    Agent *agent = [Agent agentInMOC:moc];
    agent.name = dict[agentPropertyName];
    agent.destructionPower = dict[agentPropertyDestructionPower];
    agent.motivation = dict[agentPropertyMotivation];
    agent.category = [FreakType fetchInMOC:agent.managedObjectContext
                                  withName:dict[@"freakTypeName"]];
    NSMutableSet *domains = [[NSMutableSet alloc] init];
    for (NSString *domainName in dict[@"domainNames"]) {
        [domains addObject:[Domain fetchInMOC:agent.managedObjectContext withName:domainName]];
    }
    agent.domains = domains;
    return agent;
}


#pragma mark - Properties

- (NSNumber *) assessment {
    [self willAccessValueForKey:agentPropertyAssessment];
    NSUInteger destrPowerValue = [[self primitiveValueForKey:agentPropertyDestructionPower]
                                  unsignedIntegerValue];
    NSUInteger motivationValue = [[self primitiveValueForKey:agentPropertyMotivation]
                                  unsignedIntegerValue];
    NSUInteger assessmentValue = (destrPowerValue + motivationValue) / 2;
    [self didAccessValueForKey:agentPropertyAssessment];
    return @(assessmentValue);
}


- (void) setMotivation:(NSNumber *)motivation {
    [self willChangeValueForKey:agentPropertyMotivation];
    [self willChangeValueForKey:agentPropertyAssessment];
    [self setPrimitiveValue:motivation forKey:agentPropertyMotivation];
    [self didChangeValueForKey:agentPropertyAssessment];
    [self didChangeValueForKey:agentPropertyMotivation];
}


- (void) setDestructionPower:(NSNumber *)destructionPower {
    [self willChangeValueForKey:agentPropertyDestructionPower];
    [self willChangeValueForKey:agentPropertyAssessment];
    [self setPrimitiveValue:destructionPower forKey:agentPropertyDestructionPower];
    [self didChangeValueForKey:agentPropertyAssessment];
    [self didChangeValueForKey:agentPropertyDestructionPower];
}


#pragma mark - Picture logic

- (NSString *) generatePictureUUID {
    CFUUIDRef   fileUUID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef fileUUIDString = CFUUIDCreateString(kCFAllocatorDefault, fileUUID);
    CFRelease(fileUUID);
    return (__bridge_transfer NSString *)fileUUIDString;
}


#pragma mark - Validation

- (BOOL) validateName:(NSString **)name error:(NSError *__autoreleasing *)error {
    BOOL validated = NO;
    if (name != nil) {
        NSString *nameWithoutSpace = [*name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (nameWithoutSpace.length > 0) {
            validated = YES;
        } else {
            *error = [NSError errorWithDomain:agentErrorDomain
                                         code:AgentErrorCodeNameEmpty userInfo:nil];
        }
    } else {
        *error = [NSError errorWithDomain:agentErrorDomain
                                     code:AgentErrorCodeNameNotDefined userInfo:nil];
    }
    return validated;
}


#pragma mark - Fetch requests

+ (NSFetchRequest *) fetchAllAgentsWithSortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *fetchRequest = [self baseFetchRequest];
    fetchRequest.sortDescriptors = sortDescriptors;
    return fetchRequest;
}


+ (NSFetchRequest *) fetchAllAgentsByName {
    NSFetchRequest *fetchRequest = [self baseFetchRequest];
    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:agentPropertyName ascending:YES];
    fetchRequest.sortDescriptors = @[ nameSortDescriptor ];
    return fetchRequest;
}


+ (NSFetchRequest *) fetchAllAgentsWithPredicate:(NSPredicate *)predicate {
    NSFetchRequest *fetchRequest = [self baseFetchRequest];
    fetchRequest.predicate =  predicate;
    return fetchRequest;
}


+ (NSFetchRequest *) baseFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:agentEntityName];
    return fetchRequest;
}

@end
