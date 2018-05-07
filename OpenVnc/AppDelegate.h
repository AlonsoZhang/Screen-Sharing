//
//  AppDelegate.h
//  TEST
//
//  Created by Alonso on 2016/12/19.
//  Copyright © 2016年 Alonso. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JFHotkeyManager.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    NSDictionary    *ConfigPlist;
    JFHotkeyManager *hkm;
}

@property  BOOL SHOW;
@property  NSMutableArray *Users;
@property (weak) IBOutlet NSTableView *TABLE;
@property(readwrite, retain) NSStatusItem *statusItem;

@property (weak) IBOutlet NSPanel *Window;
- (IBAction)create:(NSButton *)sender;

@end

