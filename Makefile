export TARGET_CC = xcrun -sdk iphoneos clang
export TARGET_CXX = xcrun -sdk iphoneos clang
export TARGET_LD = xcrun -sdk iphoneos clang

include theos/makefiles/common.mk

APPLICATION_NAME = ClassDump
ClassDump_FILES = main.m ClassDumpApplication.mm RootViewController.m
ClassDump_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore
ClassDump_LIBRARIES = applist
ClassDump_LDFLAGS = -lapplist

include $(THEOS_MAKE_PATH)/application.mk
