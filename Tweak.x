#import <Foundation/Foundation.h>

%group gFabric

%hook Fabric

+ (id)with:(id)kits {
	NSLog(@"[FlexFix] Fabric blocked");
	return nil;
}

%end

%end

%group gCrashlytics

%hook Crashlytics

- (void)start {
}

+ (id)startWithAPIKey:(id)k {
	return nil;
}

+ (void)initializeIfNeeded {
}

%end

%end

%ctor {
	if (objc_getClass("Fabric")) {
		%init(gFabric);
	}
	if (objc_getClass("Crashlytics")) {
		%init(gCrashlytics);
	}
}
