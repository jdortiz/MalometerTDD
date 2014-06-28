//
//  Domain+Model.m
//  MalometerTDD
//
//  Created by Jorge D. Ortiz Fuentes on 27/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "Domain+Model.h"

NSString *const domainEntityName = @"Domain";
NSString *const domainPropertyName = @"name";


@implementation Domain (Model)

+ (instancetype) domainInMOC:(NSManagedObjectContext *)moc {
    Domain *domain = [NSEntityDescription insertNewObjectForEntityForName:domainEntityName inManagedObjectContext:moc];
    
    return domain;
}


+ (instancetype) domainInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name {
    Domain *domain = [self domainInMOC:moc];
    domain.name = name;
    
    return domain;
}


+ (instancetype) domainInMOC:(NSManagedObjectContext *)moc withDictionary:(NSDictionary *)dict {
    Domain *domain = [self domainInMOC:moc];
    domain.name = dict[domainPropertyName];
    
    return domain;
}


#pragma mark - Fetches

+ (Domain *) fetchInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:domainEntityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", domainPropertyName, name];
    NSError *error;
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
    
    return [results lastObject];
}


+ (NSFetchRequest *) fetchRequestControlledDomains {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:domainEntityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(SUBQUERY(agents,$x,$x.destructionPower >= 3)).@count > 1"];
    return fetchRequest;
}

@end
