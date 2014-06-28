//
//  DomainTests.m
//  MalometerTDD
//
//  Created by Jorge D. Ortiz Fuentes on 27/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "Domain+Model.h"
#import "Agent+Model.h"


@interface DomainTests : XCTestCase {
    // Core Data stack objects.
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *coordinator;
    NSPersistentStore *store;
    NSManagedObjectContext *context;
    // Object to test.
    Domain *sut;
    // Other objects
    Domain *domain1;
    Domain *domain2;
}

@end


@implementation DomainTests

#pragma mark - Constants & Parameters

static NSString *const domainNameMain = @"domain1";
static NSString *const domainNameAlt = @"domain2";
static NSString *const domainNameAlt2 = @"domain3";


#pragma mark - Set up and tear down

- (void) setUp {
    [super setUp];

    [self createCoreDataStack];
    [self createSut];
    [self createFixture];
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
    domain1 = [Domain domainInMOC:context withName:domainNameAlt];
    domain2 = [Domain domainInMOC:context withName:domainNameAlt2];

    Agent *agent1 = [Agent agentInMOC:context];
    agent1.destructionPower = @(3);
    [sut addAgentsObject:agent1];
    [domain1 addAgentsObject:agent1];
    
    Agent *agent2 = [Agent agentInMOC:context];
    agent2.destructionPower = @(4);
    [sut addAgentsObject:agent2];
    [domain2 addAgentsObject:agent2];

    Agent *agent3 = [Agent agentInMOC:context];
    agent3.destructionPower = @(5);
    [sut addAgentsObject:agent3];
    [domain1 addAgentsObject:agent3];
    
    Agent *agent4 = [Agent agentInMOC:context];
    agent4.destructionPower = @(1);
    [sut addAgentsObject:agent4];
    [domain1 addAgentsObject:agent4];
    [domain2 addAgentsObject:agent4];
}


- (void) createSut {
    sut = [Domain domainInMOC:context withName:domainNameMain];
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
    domain1 = nil;
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


#pragma mark - Data persistence

- (void) testConvenienceConstructorPreservesName {
    XCTAssertEqual(sut.name, domainNameMain,
                   @"Domain convenience constructor must preserve name.");
}


#pragma mark - Fetches

- (void) testFetchesDomainWithGivenName {
    XCTAssertEqual([Domain fetchInMOC:context withName:domainNameMain], sut,
                   @"Fetch Domain with name must retrieve the right object.");
}


- (void) testFetchControlledDomainsIsNotNil {
    XCTAssertNotNil([Domain fetchRequestControlledDomains],
                    @"Fetch request for controlled domains must not be nil.");
}


- (void) testControlledDomainsFetchReturnsDomainsWithTwoOrMorePowerfulAgents {
    NSFetchRequest *fetchRequest = [Domain fetchRequestControlledDomains];
    NSError *err;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&err];
    
    XCTAssertTrue([results containsObject:sut], @"Controller domains fetch must return domains with more than one powerful agent.");
    XCTAssertTrue([results containsObject:domain1], @"Controller domains fetch must return domains with more than one powerful agent.");
    XCTAssertEqual([results count], 2, @"Controller domains fetch must return domains with more than one powerful agent and only those.");
}


#pragma mark - Importing data

- (void) testNotNilAgentIsCreatedWithImportingInitializer {
    XCTAssertNotNil([Domain domainInMOC:context withDictionary:nil],
                    @"Domain created with importer constructor must not be nil.");
}


- (void) testImportingInitializerPreservesName {
    Domain *domain = [Domain domainInMOC:context withDictionary:@{domainPropertyName: domainNameMain}];
    XCTAssertEqual(domain.name, domainNameMain,
                   @"FreakType created with importer constructor must preserve name.");
}

@end
