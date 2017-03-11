//
//  AppDelegate.m
//  TEST
//
//  Created by MAC on 2016/12/19.
//  Copyright © 2016年 Wistron. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //******************  Inin Config ******************
    ConfigPlist = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"]];
    
    //******************  Open Users firstly ******************
    NSMutableArray *ArryFromPlist = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[ConfigPlist objectForKey:@"DefaultType"] ofType:@"plist"]];
    self.Users=([ArryFromPlist count]>0)?ArryFromPlist:[NSMutableArray new];

    //******************  setDoubleAction  ******************
    [self.TABLE setDoubleAction:@selector(Doopen)];
    
    //******************  set StatusBarItem  ******************
    [self StatusBarItem];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    [self.Users writeToFile:[[NSBundle mainBundle]pathForResource:[ConfigPlist objectForKey:@"DefaultType"] ofType:@"plist"] atomically:YES];
    return YES;
}

- (void)Doopen{
    NSString *ip =[[self.Users objectAtIndex:self.TABLE.selectedRow] objectForKey:@"IP"];
    if([ip length]>0)
    {
        [self RunCMD:[NSString stringWithFormat:@"do shell script \"Open vnc://%@\" ",ip]];
    }
}


-(NSString *)RunCMD:(NSString *)script {
    NSDictionary *error = [NSDictionary new];
    NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
    NSAppleEventDescriptor *des = [appleScript executeAndReturnError:&error];
    return  des.stringValue;
}

- (void)password
{
  [self RunCMD:[NSString stringWithFormat:[ConfigPlist objectForKey:@"InputPswScript"],[[self.Users objectAtIndex:self.TABLE.selectedRow] objectForKey:@"Username"],[[self.Users objectAtIndex:self.TABLE.selectedRow] objectForKey:@"Password"]]];
    
    NSLog(@"%@", [NSString stringWithFormat:[ConfigPlist objectForKey:@"InputPswScript"],[[self.Users objectAtIndex:self.TABLE.selectedRow] objectForKey:@"Username"],[[self.Users objectAtIndex:self.TABLE.selectedRow] objectForKey:@"Password"]]);
}

- (void)StatusBarItem {
    
    self.statusItem= [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    NSMenu *MainMenu = [[NSMenu alloc]init];
    NSMenuItem *Password = [[NSMenuItem alloc] initWithTitle:@"Input_Password" action:@selector(password) keyEquivalent:@""];
    NSMenuItem *Quit = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quit) keyEquivalent:@""];
    [MainMenu addItem:Password];
    
    
    NSArray *Type = [ConfigPlist objectForKey:@"Type"];
    for( NSString *Name in Type )
    {
        NSMenuItem *Item = [[NSMenuItem alloc] initWithTitle:Name action:@selector(ChangeType:) keyEquivalent:@""];
        [MainMenu addItem:Item];
    }
    
    
    [MainMenu addItem:Quit];
    NSImage *menuIcon = [NSImage imageNamed:@"Menu Icon"];
    [menuIcon setTemplate:YES];
    [[self statusItem] setImage:menuIcon];
    self.statusItem.menu = MainMenu;
}

-(void) ChangeType:(NSMenuItem *) Item
{
    //******************  Save Users firstly ******************
    [self.Users writeToFile:[[NSBundle mainBundle]pathForResource:[ConfigPlist objectForKey:@"DefaultType"] ofType:@"plist"] atomically:YES];

    //Chage DefaultType
    [ConfigPlist setValue:Item.title forKey:@"DefaultType"];
    
    //******************  Chage self.Users ******************
    NSMutableArray *ArryFromPlist = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[ConfigPlist objectForKey:@"DefaultType"] ofType:@"plist"]];
    self.Users=([ArryFromPlist count]>0)?ArryFromPlist:[NSMutableArray new];
    
    //******************  Save DefaultType ******************
    [ConfigPlist writeToFile:[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"] atomically:YES];
}


-(void) quit
{
    [self.Users writeToFile:[[NSBundle mainBundle]pathForResource:[ConfigPlist objectForKey:@"DefaultType"] ofType:@"plist"] atomically:YES];
    [NSApp terminate:self];
}
@end
