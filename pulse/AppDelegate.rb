#
#  AppDelegate.rb
#  pulse
#
#  Created by Tony Pitale on 5/3/12.
#  Copyright 2012 Innovative Computer Solutions. All rights reserved.
#

class AppDelegate
  attr_accessor :menu

  def awakeFromNib
    # setup_menu # programmatic?
    setup_images
    create_status_item
    @poller = Poller.new(self)
    @poller.start
  end

  # def setup_menu
  #   self.menu = NSMenu.alloc.initWithTitle("Pulse")

  #   menu_item = NSMenuItem.alloc.init
  #   menu_item.title = "Update"
  #   menu_item.target = self
  #   menu_item.action = "highlight:"
  #   menu.addItem menu_item

  #   menu_item = NSMenuItem.alloc.init
  #   menu_item.title = "Quit"
  #   menu_item.target = self
  #   menu_item.action = "quit:"
  #   menu.addItem menu_item
  # end

  def setup_images
    @default_image = NSImage.imageNamed("default.png")
    @alternate_image = NSImage.imageNamed("alternate.png")
    @highlight_image = NSImage.imageNamed("highlight.png")
  end

  def status_item
    @status_item ||= NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength)
  end

  def create_status_item
    status_item.highlightMode = true
    set_default_image
    status_item.menu = menu
  end

  def set_highlight_image
    status_item.image = @highlight_image
  end

  def set_default_image
    status_item.image = @default_image
    status_item.alternateImage = @alternate_image
  end

  def trigger_update_available
    menu_item = menu.itemAtIndex(0)
    menu_item.title = "Update Available"
    menu_item.action = "handle_update:"
    set_highlight_image
  end

  def help(sender)
    # open a url in the default browser
    open_in_browser "http://github.com/bleything/bootstrap/readme.md"
  end

  def check_for_update(sender)
    @poller.perform_request(nil)
  end

  def handle_update(sender)
    # open a url to dna-lab
    open_in_browser "http://ls-dna-lab.herokuapp.com/configs"

    menu_item = menu.itemAtIndex(0)
    menu_item.title = "Update"
    menu_item.action = "check_for_update:"
    set_default_image
  end

  def highlight(sender)
    set_highlight_image
  end

  def open_in_browser(str)
    NSWorkspace.sharedWorkspace.openURL(NSURL.URLWithString(str))
  end

  def quit(sender)
    NSApplication.sharedApplication.terminate(self)
  end
end
