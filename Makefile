export GO_EASY_ON_ME=1

APPLICATION_NAME = ClassDumpGUI
ClassDumpGUI_FILES = classdumpgui.m CDGViewController.m CDGAppDelegate.m
ClassDumpGUI_FRAMEWORKS = UIKit CoreGraphics QuartzCore
ClassDumpGUI_PRIVATE_FRAMEWORKS = Preferences
ClassDumpGUI_LIBRARIES = applist

TARGET_IPHONEOS_DEPLOYMENT_VERSION = 5.0

ARCHS = armv7

include theos/makefiles/common.mk
include theos/makefiles/application.mk
