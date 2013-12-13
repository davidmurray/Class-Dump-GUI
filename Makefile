export GO_EASY_ON_ME=1

APPLICATION_NAME = classdumpgui
classdumpgui_FILES = classdumpgui.m CDGViewController.m
classdumpgui_FRAMEWORKS = UIKit CoreGraphics QuartzCore
classdumpgui_PRIVATE_FRAMEWORKS = Preferences
classdumpgui_CFLAGS = -I./Headers/
classdumpgui_LDFLAGS = -L./lib/
classdumpgui_LIBRARIES = applist

TARGET_IPHONEOS_DEPLOYMENT_VERSION = 5.0

ARCHS = armv7

include theos/makefiles/common.mk
include theos/makefiles/application.mk
