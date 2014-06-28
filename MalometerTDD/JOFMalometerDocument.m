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


@implementation JOFMalometerDocument

- (void) importData:(NSDictionary *)dictionary {
    [self importFreakTypes:dictionary[freakTypesKey]];
    [self importDomains:dictionary[domainsKey]];
}


- (void) importFreakTypes:(NSArray *)freakTypesDictionaries {
    for (NSDictionary *freakTypeDict in freakTypesDictionaries) {
        [FreakType freakTypeInMOC:self.managedObjectContext withDictionary:freakTypeDict];
    }
}


- (void) importDomains:(NSArray *)domainsDictionaries {
    for (NSDictionary *domainDict in domainsDictionaries) {
        [Domain domainInMOC:self.managedObjectContext withDictionary:domainDict];
    }
}


@end
