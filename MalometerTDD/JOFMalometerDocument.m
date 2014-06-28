//
//  JOFMalometerDocument.m
//  MalometerTDD
//
//  Created by Jorge D. Ortiz Fuentes on 28/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "JOFMalometerDocument.h"

NSString *const freakTypesKey = @"FreakTypes";
NSString *const domainsKey = @"Domains";
NSString *const agentsKey = @"Agents";
NSString *const initialDataResource = @"initialAgentData";
NSString *const initialDataExtension = @"sqlite";


@implementation JOFMalometerDocument

- (void) importData:(NSDictionary *)dictionary {
    [self importFreakTypes:dictionary[freakTypesKey]];
    [self importDomains:dictionary[domainsKey]];
    [self importAgents:dictionary[agentsKey]];
}


- (void) importFreakTypes:(NSArray *)freakTypeDictionaries {
    for (NSDictionary *freakTypeDict in freakTypeDictionaries) {
        [FreakType freakTypeInMOC:self.managedObjectContext withDictionary:freakTypeDict];
    }
}


- (void) importDomains:(NSArray *)domainDictionaries {
    for (NSDictionary *domainDict in domainDictionaries) {
        [Domain domainInMOC:self.managedObjectContext withDictionary:domainDict];
    }
}


- (void) importAgents:(NSArray *)agentDictionaries {
    for (NSDictionary *agentDict in agentDictionaries) {
        [Agent agentInMOC:self.managedObjectContext withDictionary:agentDict];
    }
}


#pragma mark - Preload data

- (BOOL) configurePersistentStoreCoordinatorForURL:(NSURL *)storeURL ofType:(NSString *)fileType modelConfiguration:(NSString *)configuration storeOptions:(NSDictionary *)storeOptions error:(NSError *__autoreleasing *)error {
    if (![self.fileManager fileExistsAtPath:[storeURL path]]) {
        NSError *error;
        [self.fileManager copyItemAtURL:self.initialDataURL
                                  toURL:storeURL error:&error];
    }
    return [super configurePersistentStoreCoordinatorForURL:storeURL ofType:fileType
                                         modelConfiguration:configuration storeOptions:storeOptions
                                                      error:error];
}


#pragma mark - Lazy loaded properties for dependency injection

- (NSFileManager *) fileManager {
    if (_fileManager == nil) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}


- (NSURL *) initialDataURL {
    if (_initialDataURL == nil) {
        _initialDataURL = [[NSBundle mainBundle] URLForResource:initialDataResource
                                                  withExtension:initialDataExtension];
    }
    return _initialDataURL;
}

@end
