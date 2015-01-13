// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MindfulnessDagboek.m instead.

#import "_MindfulnessDagboek.h"

const struct MindfulnessDagboekAttributes MindfulnessDagboekAttributes = {
	.ademruimte = @"ademruimte",
	.behandelingnummer = @"behandelingnummer",
	.bodyscan = @"bodyscan",
	.dag = @"dag",
};

@implementation MindfulnessDagboekID
@end

@implementation _MindfulnessDagboek

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MindfulnessDagboek" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MindfulnessDagboek";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MindfulnessDagboek" inManagedObjectContext:moc_];
}

- (MindfulnessDagboekID*)objectID {
	return (MindfulnessDagboekID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"ademruimteValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"ademruimte"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"behandelingnummerValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"behandelingnummer"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"bodyscanValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"bodyscan"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic ademruimte;

- (BOOL)ademruimteValue {
	NSNumber *result = [self ademruimte];
	return [result boolValue];
}

- (void)setAdemruimteValue:(BOOL)value_ {
	[self setAdemruimte:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveAdemruimteValue {
	NSNumber *result = [self primitiveAdemruimte];
	return [result boolValue];
}

- (void)setPrimitiveAdemruimteValue:(BOOL)value_ {
	[self setPrimitiveAdemruimte:[NSNumber numberWithBool:value_]];
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

@dynamic bodyscan;

- (BOOL)bodyscanValue {
	NSNumber *result = [self bodyscan];
	return [result boolValue];
}

- (void)setBodyscanValue:(BOOL)value_ {
	[self setBodyscan:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveBodyscanValue {
	NSNumber *result = [self primitiveBodyscan];
	return [result boolValue];
}

- (void)setPrimitiveBodyscanValue:(BOOL)value_ {
	[self setPrimitiveBodyscan:[NSNumber numberWithBool:value_]];
}

@dynamic dag;

@end

