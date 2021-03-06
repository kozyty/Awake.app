//
//  AppDelegate.m
//  Awake
//
//  Created by xiaozi on 14-2-20.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import "AppDelegate.h"
#import "AwakeManager.h"
#import "PreferencesController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	NSDictionary *defaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"isSleepOff"];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
	awakeManager = [[AwakeManager alloc] initWithSleepOff: [[NSUserDefaults standardUserDefaults] boolForKey:@"isSleepOff"]];
}

-(void)awakeFromNib
{
	// NSVariableStatusItemLength
	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength: 22.0];
	[statusItem setHighlightMode:YES];
	statusView = [[StatusItemView alloc] initWithStatusItem: statusItem];
	[statusView setMenu: statusMenu];
	// [statusItem setView: statusView];
	[statusView setImage: [NSImage imageNamed:@"MenuIcon"]];
	[statusView setAlternateImage: [NSImage imageNamed:@"MenuIconSelected"]];

	[statusView setAction: @selector(clickStatusItem:)];
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSleepOff"]) {
		[awakeManager turnOn];
		[statusView setImage: [NSImage imageNamed:@"MenuIconActive"]];
	}
	
	[[statusMenu itemAtIndex: 0] setSubmenu: activateForMenu];
}

-(void) clickStatusItem: (NSEvent *)theEvent {
	if ([awakeManager isSleepOff]) {
		[awakeManager turnOff];
		[statusView setImage: [NSImage imageNamed:@"MenuIcon"]];
	} else {
		[awakeManager turnOn];
		[statusView setImage: [NSImage imageNamed:@"MenuIconActive"]];
	}
	[[NSUserDefaults standardUserDefaults] setBool: [awakeManager isSleepOff] forKey: @"isSleepOff"];
}

-(IBAction)awakeForWhile:(id)sender
{
	if (timer) {
		[timer invalidate];
//		timer = nil;
	}
	[awakeManager turnOn];
	[statusView setImage: [NSImage imageNamed:@"MenuIconActive"]];
	NSInteger minutes = [sender tag];
	timer = [NSTimer scheduledTimerWithTimeInterval:minutes * 60
									 target:self
								   selector:@selector(handleTimer:)
								   userInfo:nil
									repeats:NO];
}

- (void) handleTimer: (NSTimer *) timer
{
	[awakeManager turnOff];
	[statusView setImage: [NSImage imageNamed:@"MenuIcon"]];
}

-(IBAction)showAbout:(id)sender
{
	[NSApp orderFrontStandardAboutPanel:self];
}

-(IBAction)showPreferences:(id)sender
{
	if (!preferencesController) {
		preferencesController = [[PreferencesController alloc] initWithWindowNibName: @"Preferences"];
	}
	[[preferencesController window] center];
	[preferencesController showWindow: self];
}

-(IBAction)quit:(id)sender
{
	[NSApp terminate:self];
}

@end
