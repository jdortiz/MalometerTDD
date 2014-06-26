//
//  Agent+Model.m
//  MalometerTDD
//
//  Created by Jorge D. Ortiz Fuentes on 08/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "Agent+Model.h"

NSString *const agentEntityName = @"Agent";
NSString *const agentPropertyDestructionPower = @"destructionPower";
NSString *const agentPropertyMotivation = @"motivation";
NSString *const agentPropertyAssessment = @"assessment";


@implementation Agent (Model)

#pragma mark - Convenience constructor

+ (instancetype) agentInMOC:(NSManagedObjectContext *)moc {
    return [NSEntityDescription insertNewObjectForEntityForName:agentEntityName
                                         inManagedObjectContext:moc];
}


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

@end
