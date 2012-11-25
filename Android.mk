# Makefile for libjpeg-turbo
##################################################
###                simd                        ###
##################################################
LOCAL_PATH := $(my-dir)
include $(CLEAR_VARS)

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
	# Set ANDROID_JPEG_USE_VENUM to true to enable VeNum optimizations
	ANDROID_JPEG_USE_VENUM := true
	LOCAL_ARM_NEON  := true
	LOCAL_CFLAGS := $(LOCAL_CFLAGS) -DANDROID_JPEG_USE_VENUM
	libsimd_SOURCES_DIST = simd/jsimd_arm_neon.S \
                       asm/armv7/jdcolor-armv7.S asm/armv7/jdidct-armv7.S \
                       simd/jsimd_arm.c
else
	ANDROID_JPEG_USE_VENUM := false
	libsimd_SOURCES_DIST = jsimd_none.c
endif

LOCAL_SRC_FILES := $(libsimd_SOURCES_DIST)

LOCAL_C_INCLUDES := $(LOCAL_PATH)/simd \
                    $(LOCAL_PATH)/android

LOCAL_MODULE := libsimd
 
include $(BUILD_STATIC_LIBRARY)
 
######################################################
###           libjpeg.a                             ##
######################################################
 
include $(CLEAR_VARS)

# From autoconf-generated Makefile
libjpeg_SOURCES_DIST =  jcapimin.c jcapistd.c jccoefct.c jccolor.c \
        jcdctmgr.c jchuff.c jcinit.c jcmainct.c jcmarker.c jcmaster.c \
        jcomapi.c jcparam.c jcphuff.c jcprepct.c jcsample.c jctrans.c \
        jdapimin.c jdapistd.c jdatadst.c jdatasrc.c jdcoefct.c jdcolor.c \
        jddctmgr.c jdhuff.c jdinput.c jdmainct.c jdmarker.c jdmaster.c \
        jdmerge.c jdphuff.c jdpostct.c jdsample.c jdtrans.c jerror.c \
        jfdctflt.c jfdctfst.c jfdctint.c jidctflt.c jidctfst.c jidctint.c \
        jidctred.c jquant1.c jquant2.c jutils.c jmemmgr.c jmemnobs.c \
	jaricom.c jcarith.c jdarith.c \
	turbojpeg.c transupp.c jdatadst-tj.c jdatasrc-tj.c

LOCAL_SRC_FILES:= $(libjpeg_SOURCES_DIST)
 
LOCAL_SHARED_LIBRARIES := libcutils
LOCAL_STATIC_LIBRARIES := libsimd
 
LOCAL_C_INCLUDES := $(LOCAL_PATH) \
                    $(LOCAL_PATH)/android
 
LOCAL_CFLAGS := -DAVOID_TABLES  -O3 -fstrict-aliasing -fprefetch-loop-arrays  -DANDROID \
        -DANDROID_TILE_BASED_DECODE -DENABLE_ANDROID_NULL_CONVERT

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
	LOCAL_CFLAGS := $(LOCAL_CFLAGS) -DANDROID_JPEG_USE_VENUM
endif
 
LOCAL_MODULE := libjpeg

include $(BUILD_STATIC_LIBRARY)
