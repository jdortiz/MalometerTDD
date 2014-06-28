//
//  JOFMalometerDocumentTests.m
//  MalometerTDD
//
//  Created by Jorge D. Ortiz Fuentes on 28/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import <XCTest/XCTest.h>
//#import <OCMock/OCMock.h>
#import "JOFMalometerDocument.h"


@interface JOFMalometerDocumentTests : XCTestCase {
    // Core Data stack objects.
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *coordinator;
    NSPersistentStore *store;
    NSManagedObjectContext *context;
    // Object to test.
    JOFMalometerDocument *sut;
}

@end


@implementation JOFMalometerDocumentTests

#pragma mark - Constants & Parameters

static NSString *const freakTypeMainName = @"Category0";
static NSString *const freakTypeAltName = @"Category1";
static NSString *const domainMainName = @"Domain0";
static NSString *const domainAltName = @"Domain0";


#pragma mark - Set up and tear down

- (void) setUp {
    [super setUp];

    [self createCoreDataStack];
//    [self createFixture];
    [self createSut];
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
    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = coordinator;
}


- (void) createFixture {
    // Test data
}


- (void) createSut {
    NSURL *docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                             inDomains:NSUserDomainMask] lastObject];
    NSURL *fakeURL = [docsURL URLByAppendingPathComponent:@"nofile"];
    sut = [[JOFMalometerDocument alloc] initWithFileURL:fakeURL];
    [sut setValue:context forKey:@"managedObjectContext"];
}


- (void) tearDown {
    [self releaseSut];
//    [self releaseFixture];
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
    XCTAssertNotNil(sut, @"The object to test must be created in setUp.");
}


#pragma mark - Fake environment

- (void) testMOCAssignment {
    XCTAssertEqualObjects(sut.managedObjectContext, context,
                          @"Managed object context must be injected for other tests to work.");
}


#pragma mark - Import data

- (void) testImportDataCreatesOneFreakTypeWhenDataContainsOne {
    NSDictionary *data = @{freakTypesKey: @[@{freakTypePropertyName: freakTypeMainName}]};

    [sut importData:data];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:freakTypeEntityName]
                                              error:&error];
    XCTAssertEqual(results.count, (NSUInteger)1,
                   @"Import data must create one FreakType and only one when that is provided in the data");
}


- (void) testImportDataCreatesTwoFreakTypesWhenDataContainsTwo {
    NSDictionary *data = @{freakTypesKey: @[@{freakTypePropertyName: freakTypeMainName},
                                            @{freakTypePropertyName: freakTypeAltName}]};
    
    [sut importData:data];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:freakTypeEntityName]
                                              error:&error];
    XCTAssertEqual(results.count, (NSUInteger)2,
                   @"Import data must create two FreakType and only two when that is provided in the data.");
}


- (void) testImportDataCreatesAFreakTypeWithDataInItsDictionary {
    NSDictionary *data = @{freakTypesKey: @[@{freakTypePropertyName: freakTypeMainName}]};
    
    [sut importData:data];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:freakTypeEntityName]
                                              error:&error];
    FreakType *freakType = [results lastObject];
    XCTAssertEqualObjects(freakType.name, freakTypeMainName,
                   @"Import data must create FreakTypes with the provided data.");
}


- (void) testImportDataCreatesOneDomainWhenDataContainsOne {
    NSDictionary *data = @{domainsKey: @[@{domainPropertyName: domainMainName}]};
    
    [sut importData:data];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:domainEntityName]
                                              error:&error];
    XCTAssertEqual(results.count, (NSUInteger)1,
                   @"Import data must create one Domain and only one when that is provided in the data.");
}


- (void) testImportDataCreatesTwoDomainsWhenDataContainsTwo {
    NSDictionary *data = @{domainsKey: @[@{domainPropertyName: domainMainName},
                                         @{domainPropertyName: domainAltName}]};
    
    [sut importData:data];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:domainEntityName]
                                              error:&error];
    XCTAssertEqual(results.count, (NSUInteger)2,
                   @"Import data must create two Domains and only two when that is provided in the data.");
}


- (void) testImportDataCreatesADomainWithDataInItsDictionary {
    NSDictionary *data = @{domainsKey: @[@{domainPropertyName: domainMainName}]};
    
    [sut importData:data];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:domainEntityName]
                                              error:&error];
    Domain *domain = [results lastObject];
    XCTAssertEqualObjects(domain.name, domainMainName,
                          @"Import data must create Domains with the provided data.");
}

@end
