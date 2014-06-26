//
//  AgentTests.m
//  MalometerTDD
//
//  Created by Jorge D. Ortiz Fuentes on 08/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import <XCTest/XCTest.h>
#import <OCMock.h>
#import "Agent+Model.h"


@interface AgentTests : XCTestCase {
    // Core Data stack objects.
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *coordinator;
    NSPersistentStore *store;
    NSManagedObjectContext *context;
    // Object to test.
    Agent *sut;
    
    // Change
    BOOL changeFlag;
}

@end


@implementation AgentTests

#pragma mark - Set up and tear down

- (void) setUp {
    [super setUp];

    [self createCoreDataStack];
    [self createFixture];
    [self createSut];
    [self resetChangeFlag];
}


- (void) createCoreDataStack {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    model = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    store = [coordinator addPersistentStoreWithType: NSInMemoryStoreType
                                      configuration: nil
                                                URL: nil
                                            options: nil
                                              error: NULL];
    context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = coordinator;
}


- (void) createFixture {
    // Test data
}


- (void) createSut {
    sut = [Agent agentInMOC:context];
}


- (void) resetChangeFlag {
    changeFlag = NO;
}


- (void) tearDown {
    [self releaseSut];
    [self releaseFixture];
    [self releaseCoreDataStack];

    [super tearDown];
}


- (void) releaseSut {
    sut = nil;
}


- (void) releaseFixture {

}


- (void) releaseCoreDataStack {
    context = nil;
    store = nil;
    coordinator = nil;
    model = nil;
}


#pragma mark - Basic test

- (void) testObjectIsNotNil {
    // Prepare

    // Operate

    // Check
    XCTAssertNotNil(sut, @"The object to test must be created in setUp.");
}


- (void) testAssessmentValueIsCalculatedFromDestPowerAndMotivation {
    sut.destructionPower = @(3);
    sut.motivation = @(4);

    XCTAssertEqual([sut.assessment unsignedIntegerValue], (NSUInteger)3, @"Assessment should be calculated from destruction power and motivation");
}


- (void) testAssessmentValueIsCalculatedFromOtherDestPowerAndMotivation {
    sut.destructionPower = @(1);
    sut.motivation = @(2);
    
    XCTAssertEqual([sut.assessment unsignedIntegerValue], (NSUInteger)1, @"Assessment should be calculated from destruction power and motivation");
}


- (void) testAssessmentAccessIsNotified {
    sut.destructionPower = @(2);
    sut.motivation = @(4);
    id sutMock = [OCMockObject partialMockForObject:sut];
    [[sutMock expect] willAccessValueForKey:agentPropertyAssessment];
    [[sutMock expect] didAccessValueForKey:agentPropertyAssessment];

    [sutMock assessment];
    
    XCTAssertNoThrow([sutMock verify], @"Assessment access must be notified.");
}


- (void) testMotivationIsPreservedProperly {
    sut.motivation = @(4);
    
    XCTAssertEqual([sut.motivation unsignedIntegerValue], (NSUInteger)4,
                   @"Motivation must be preserved properly.");
}


- (void) testMotivationNotifiesChangesForKVO {
    [sut addObserver:self forKeyPath:agentPropertyMotivation
             options:0 context:NULL];
    sut.motivation = @(3);
    
    XCTAssertTrue(changeFlag, @"Changes to motivation should be notified.");
    [sut removeObserver:self forKeyPath:agentPropertyMotivation];
}


- (void) testMotivationChangesAssessment {
    sut.destructionPower = @(1);
    sut.motivation = @(1);

    [sut addObserver:self forKeyPath:agentPropertyAssessment
             options:0 context:NULL];
    sut.motivation = @(3);
    
    XCTAssertTrue(changeFlag, @"Changes to motivation should change assessment.");
    [sut removeObserver:self forKeyPath:agentPropertyAssessment];
}


- (void) testDestructionPowerIsPreservedProperly {
    sut.destructionPower = @(4);
    
    XCTAssertEqual([sut.destructionPower unsignedIntegerValue], (NSUInteger)4,
                   @"Destruction power must be preserved properly.");
}


- (void) testDestructionPowerNotifiesChangesForKVO {
    [sut addObserver:self forKeyPath:agentPropertyDestructionPower
             options:0 context:NULL];
    sut.destructionPower = @(3);
    
    XCTAssertTrue(changeFlag, @"Changes to destructionPower should be notified.");
    [sut removeObserver:self forKeyPath:agentPropertyDestructionPower];
}


- (void) testDestructionPowerChangesAssessment {
    sut.destructionPower = @(1);
    sut.motivation = @(1);
    
    [sut addObserver:self forKeyPath:agentPropertyAssessment
             options:0 context:NULL];
    sut.destructionPower = @(3);
    
    XCTAssertTrue(changeFlag, @"Changes to destructionPower should change assessment.");
    [sut removeObserver:self forKeyPath:agentPropertyAssessment];
}


#pragma mark - Picture logic

- (void) testGeneratedPictureUUIDIsNotNil {
    XCTAssertNotNil([sut generatePictureUUID], @"Generated picture UUID must not be nil.");
}


- (void) testGeneratedPictureUUIDLengthIsMoreThanTen {
    XCTAssertTrue([[sut generatePictureUUID] length] > 10, @"Generated picture UUID length must be more than 10.");
}


- (void) testGeneratedPictureUUIDMustBeDifferentEachTime {
    NSString *uuid1 = [sut generatePictureUUID];
    NSString *uuid2 = [sut generatePictureUUID];
    XCTAssertNotEqualObjects(uuid1, uuid2, @"Generated picture UUID must be different each time.");
}


#pragma mark - Fetch requests

- (void) testFetchAllAgentsByNameIsNotNil {
    XCTAssertNotNil([Agent fetchAllAgentsByName], @"Fetch all the agents by name must return a not nil request.");
}


- (void) testFetchAllAgentsByNameHasSortDescriptors {
    NSFetchRequest *fetchRequest = [Agent fetchAllAgentsByName];
    
    XCTAssertNotNil(fetchRequest.sortDescriptors, @"Fetch all agents by name must use sort descriptors.");
}


- (void) testFetchAllAgentsByNameFirstSortDescriptorIsName {
    NSFetchRequest *fetchRequest = [Agent fetchAllAgentsByName];
    NSSortDescriptor *sortDescriptor = [fetchRequest.sortDescriptors objectAtIndex:0];
    XCTAssertEqual(sortDescriptor.key, agentPropertyName, @"Fetch all agents by name must use sort descriptors.");
}


#pragma mark - Observation

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    changeFlag = YES;
}

@end
