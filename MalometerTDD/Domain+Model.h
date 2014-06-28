//
//  Domain+Model.h
//  MalometerTDD
//
//  Created by Jorge D. Ortiz Fuentes on 27/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "Domain.h"

extern NSString *const domainEntityName;
extern NSString *const domainPropertyName;


@interface Domain (Model)

+ (instancetype) domainInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name;
+ (instancetype) domainInMOC:(NSManagedObjectContext *)moc withDictionary:(NSDictionary *)dict;
+ (Domain *) fetchInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name;
+ (NSFetchRequest *) fetchRequestControlledDomains;

@end
