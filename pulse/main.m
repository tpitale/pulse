//
//  main.m
//  pulse
//
//  Created by Tony Pitale on 5/3/12.
//  Copyright (c) 2012 Innovative Computer Solutions. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
