// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PositiefDagboek.m instead.

#import "_PositiefDagboek.h"

const struct PositiefDagboekAttributes PositiefDagboekAttributes = {
	.behandelingnummer = @"behandelingnummer",
	.dag = @"dag",
	.item1 = @"item1",
	.item2 = @"item2",
	.item3 = @"item3",
};

@implementation PositiefDagboekID
@end

@implementation _PositiefDagboek

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PositiefDagboek" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PositiefDagboek";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PositiefDagboek" inManagedObjectContext:moc_];
}

- (PositiefDagboekID*)objectID {
	return (PositiefDagboekID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"behandelingnummerValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"behandelingnummer"];
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

@dynamic item1;

@dynamic item2;

@dynamic item3;

@end

