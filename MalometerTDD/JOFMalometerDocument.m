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

@end
