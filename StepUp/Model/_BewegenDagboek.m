// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BewegenDagboek.m instead.

#import "_BewegenDagboek.h"

const struct BewegenDagboekAttributes BewegenDagboekAttributes = {
	.behandelingnummer = @"behandelingnummer",
	.dag = @"dag",
	.intensiteit = @"intensiteit",
	.plezier = @"plezier",
	.training = @"training",
};

@implementation BewegenDagboekID
@end

@implementation _BewegenDagboek

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BewegenDagboek" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BewegenDagboek";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BewegenDagboek" inManagedObjectContext:moc_];
}

- (BewegenDagboekID*)objectID {
	return (BewegenDagboekID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"behandelingnummerValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"behandelingnummer"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"intensiteitValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"intensiteit"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"plezierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"plezier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"trainingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"training"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic behandelingnummer;

- (int16_t)behandelingnummerValue {
	NSNumber *result = [self behandelingnummer];
	return [result shortValue];
}

- (void)setBehandelingnummerValue:(int16_t)value_ {
	[self setBehandelingnummer:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveBehandelingnummerValue {
	NSNumber *result = [self primitiveBehandelingnummer];
	return [result shortValue];
}

- (void)setPrimitiveBehandelingnummerValue:(int16_t)value_ {
	[self setPrimitiveBehandelingnummer:[NSNumber numberWithShort:value_]];
}

@dynamic dag;

@dynamic intensiteit;

- (int16_t)intensiteitValue {
	NSNumber *result = [self intensiteit];
	return [result shortValue];
}

- (void)setIntensiteitValue:(int16_t)value_ {
	[self setIntensiteit:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveIntensiteitValue {
	NSNumber *result = [self primitiveIntensiteit];
	return [result shortValue];
}

- (void)setPrimitiveIntensiteitValue:(int16_t)value_ {
	[self setPrimitiveIntensiteit:[NSNumber numberWithShort:value_]];
}

@dynamic plezier;

- (int16_t)plezierValue {
	NSNumber *result = [self plezier];
	return [result shortValue];
}

- (void)setPlezierValue:(int16_t)value_ {
	[self setPlezier:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitivePlezierValue {
	NSNumber *result = [self primitivePlezier];
	return [result shortValue];
}

- (void)setPrimitivePlezierValue:(int16_t)value_ {
	[self setPrimitivePlezier:[NSNumber numberWithShort:value_]];
}

@dynamic training;

- (int16_t)trainingValue {
	NSNumber *result = [self training];
	return [result shortValue];
}

- (void)setTrainingValue:(int16_t)value_ {
	[self setTraining:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveTrainingValue {
	NSNumber *result = [self primitiveTraining];
	return [result shortValue];
}

- (void)setPrimitiveTrainingValue:(int16_t)value_ {
	[self setPrimitiveTraining:[NSNumber numberWithShort:value_]];
}

@end

