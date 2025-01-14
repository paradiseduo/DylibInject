#import <dlfcn.h>
#import <UIKit/UIKit.h>
#import <notify.h>
#import <objc/message.h>
#import <SpringBoard/SpringBoard.h>


@interface DylibLoader : NSObject

@end

@implementation DylibLoader

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static DylibLoader *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (void)dylibLoad {
	Class FLEXManager = NSClassFromString(@"FLEXManager");
	id sharedManager = [FLEXManager performSelector:@selector(sharedManager)];
	[sharedManager performSelector:@selector(showExplorer)];
}

@end

%ctor {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.paradiseduo.DylibInject.plist"] ;
    NSString *libraryPath = @"/Library/Frameworks/FLEX.framework/FLEX";
        
	NSString *keyPath = [NSString stringWithFormat:@"DylibInjectEnabled-%@", [[NSBundle mainBundle] bundleIdentifier]];
	NSLog(@"DylibLoader before loaded %@,keyPath = %@,prefs = %@", libraryPath,keyPath,prefs);
	if ([[prefs objectForKey:keyPath] boolValue]) {
		if ([[NSFileManager defaultManager] fileExistsAtPath:libraryPath]){
			void *haldel = dlopen([libraryPath UTF8String], RTLD_NOW);
		if (haldel == NULL) {
			char *error = dlerror();
			NSLog(@"dlopen error: %s", error);
		} else {
			NSLog(@"dlopen load framework success.");
			[[NSNotificationCenter defaultCenter] addObserver:[DylibLoader sharedInstance] 
										selector:@selector(dylibLoad) 
										name:UIApplicationDidBecomeActiveNotification 
										object:nil];	
		}
		NSLog(@"DylibLoader loaded %@", libraryPath);
		} else {
			NSLog(@"DylibLoader file not exists %@", libraryPath);
		}
	} else {
		NSLog(@"DylibLoader not enabled %@", libraryPath);
	}
	
	NSLog(@"DylibLoader after loaded %@", libraryPath);
}

