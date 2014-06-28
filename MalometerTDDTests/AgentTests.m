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
#import "FreakType+Model.h"
#import "Domain+Model.h"


@interface AgentTests : XCTestCase {
    // Core Data stack objects.
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *coordinator;
    NSPersistentStore *store;
    NSManagedObjectContext *context;
    // Object to test.
    Agent *sut;
    // Other objects
    FreakType *freakType1;
    Domain *domain1;
    Domain *domain2;
    
    // Change
    BOOL changeFlag;
}

@end


@implementation AgentTests

#pragma mark - Constants & Parameters

static NSString *const agentNameMain = @"Agent0";
static const NSUInteger agentDestructPowerMain = 2;
static const NSUInteger agentMotivationMain = 4;

static NSString *const freakTypeMainName = @"Category0";
static NSString *const domainMainName = @"Domain0";
static NSString *const domainAltName = @"Domain1";


#pragma mark - Set up and tear down

- (void) setUp {
    [super setUp];

    [self createCoreDataStack];
    [self createSut];
    [self createFixture];
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


- (void) createSut {
    sut = [Agent agentInMOC:context];
}


- (void) createFixture {
    freakType1 = [FreakType freakTypeInMOC:context withName:freakTypeMainName];
    domain1 = [Domain domainInMOC:context withName:domainMainName];
    domain2 = [Domain domainInMOC:context withName:domainAltName];
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
    freakType1 = nil;
    domain1 = nil;
    domain2 = nil;
}


- (void) releaseCoreDataStack {
    context = nil;
    store = nil;
    coordinator = nil;
    model = nil;
}


#pragma mark - Basic test

- (void) testObjectIsNotNil {
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


- (void) testFetchAllAgentsWithSortDescriptorsIsNotNil {
    XCTAssertNotNil([Agent fetchAllAgentsWithSortDescriptors:nil], @"Fetch all the agents with sort descriptors must return a not nil request.");
}


- (void) testFetchAllAgentsWithSortDescriptorsPreservesSortDescriptors {
    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:agentPropertyName ascending:YES];
    NSArray *sortDescriptors = @[ nameSortDescriptor];
    NSFetchRequest *fetchRequest = [Agent fetchAllAgentsWithSortDescriptors:sortDescriptors];
    XCTAssertEqual(fetchRequest.sortDescriptors, sortDescriptors, @"Fetch all agents with sort descriptors must preserve sort descriptors.");
}


- (void) testFetchAllAgentsWithPredicateIsNotNil {
    XCTAssertNotNil([Agent fetchAllAgentsWithPredicate:nil], @"Fetch all the agents with predicate must return a not nil request.");
}


- (void) testFetchAllAgentsWithPredicatePreservesPredicate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == 'john'"];
    NSFetchRequest *fetchRequest = [Agent fetchAllAgentsWithPredicate:predicate];
    XCTAssertEqual(fetchRequest.predicate, predicate, @"Fetch all agents with predicate must preserve predicate.");
}


#pragma mark - Agent name validation

- (void) testEmptyAgentNameCannotBeSaved {
    sut.name = @"";
    NSError *error;
    XCTAssertFalse([context save:&error], @"Empty agent name must not be allowed when saving");
}


- (void) testAgentNameWithOnlySpacesCannotBeSaved {
    sut.name = @"  ";
    NSError *error;
    XCTAssertFalse([context save:&error], @"Agent name with only spaces must not be allowed when saving");
}


- (void) testAgentNameWithOnlySpacesValidationReturnsAppropiateError {
    NSString *name = @" ";
    NSError *error;
    [sut validateName:&name error:&error];
    
    XCTAssertNotNil(error, @"An error must be returned when name is not validated.");
    XCTAssertEqual(error.code, AgentErrorCodeNameEmpty, @"Appropiate error code must be returned when name is not validated.");
}


#pragma mark - Importing data

- (void) testNotNilAgentIsCreatedWithImportingInitializer {
    XCTAssertNotNil([Agent agentInMOC:context withDictionary:nil],
                    @"Agent created with importer constructor must not be nil.");
}


- (void) testImportingInitializerPreservesName {
    Agent *agent = [Agent agentInMOC:context withDictionary:@{agentPropertyName: agentNameMain}];
    XCTAssertEqual(agent.name, agentNameMain,
                   @"Agent created with importer constructor must preserve name.");
}


- (void) testImportingInitializerPreservesDestructionPower {
    Agent *agent = [Agent agentInMOC:context withDictionary:@{agentPropertyDestructionPower: @(agentDestructPowerMain)}];
    XCTAssertEqual([agent.destructionPower unsignedIntegerValue], agentDestructPowerMain,
                   @"Agent created with importer constructor must preserve destruction power.");
}


- (void) testImportingInitializerPreservesMotivation {
    Agent *agent = [Agent agentInMOC:context withDictionary:@{agentPropertyMotivation: @(agentMotivationMain)}];
    XCTAssertEqual([agent.motivation unsignedIntegerValue], agentMotivationMain,
                   @"Agent created with importer constructor must preserve motivation.");
}


#pragma mark - Import relationships

- (void) testImportingInitializerEstablishesRelationshipWithFreakTypeWithName {
    Agent *agent = [Agent agentInMOC:context withDictionary:@{@"freakTypeName": freakTypeMainName}];
    XCTAssertEqual(agent.category, freakType1,
                   @"Agent created with imported must be related to the FreakType with the given name.");
}


- (void) testImportingInitializerEstablishesRelationshipWithDomainsWithNames {
    Agent *agent = [Agent agentInMOC:context withDictionary:@{@"domainNames": @[domainMainName, domainAltName]}];
    XCTAssertTrue([agent.domains containsObject:domain1],
                  @"Agent created with imported must be related to the Domains with the given names.");
    XCTAssertTrue([agent.domains containsObject:domain2],
                  @"Agent created with imported must be related to the Domains with the given names.");
}


#pragma mark - Observation

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    changeFlag = YES;
}

@end
