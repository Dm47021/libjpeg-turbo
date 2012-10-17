# Makefile for libjpeg-turbo
##################################################
###                simd                        ###
##################################################
LOCAL_PATH := $(my-dir)
include $(CLEAR_VARS)

# Set ANDROID_JPEG_USE_VENUM to true to enable VeNum optimizations
ANDROID_JPEG_USE_VENUM := true

# Disable VeNum optimizations if they are not supported on the build target
#ifneq ($(ARCH_ARM_HAVE_VFP),true)
#ANDROID_JPEG_USE_VENUM := false
#else
#ifneq ($(ARCH_ARM_HAVE_NEON),true)
#ANDROID_JPEG_USE_VENUM := false
#endif
#endif
LOCAL_ARM_NEON  := true
 
# From autoconf-generated Makefile
EXTRA_DIST = simd/nasm_lt.sh simd/jcclrmmx.asm simd/jcclrss2.asm simd/jdclrmmx.asm simd/jdclrss2.asm \
	simd/jdmrgmmx.asm simd/jdmrgss2.asm simd/jcclrss2-64.asm simd/jdclrss2-64.asm \
	simd/jdmrgss2-64.asm simd/CMakeLists.txt
 
libsimd_SOURCES_DIST = simd/jsimd_arm_neon.S \
                       asm/armv7//jdcolor-armv7.S asm/armv7/jdidct-armv7.S \
                       simd/jsimd_arm.c 

# or jsimd_none.c

 
LOCAL_SRC_FILES := $(libsimd_SOURCES_DIST)

LOCAL_C_INCLUDES := $(LOCAL_PATH)/simd \
                    $(LOCAL_PATH)/android
 
LOCAL_CFLAGS := -DANDROID_JPEG_USE_VENUM
AM_CFLAGS := -march=armv7-a -mfpu=neon
AM_CCASFLAGS := -march=armv7-a -mfpu=neon
 
LOCAL_MODULE_TAGS := debug
 
LOCAL_MODULE := libsimd
 
include $(BUILD_STATIC_LIBRARY)
 
######################################################
###           libjpeg.a                       ##
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
#	turbojpeg-mapfile

#possible adds jmem-android.c jmemnobs.c jmemmgr.c jmem-ashmem.c 

LOCAL_SRC_FILES:= $(libjpeg_SOURCES_DIST)
 
LOCAL_SHARED_LIBRARIES := libcutils
LOCAL_STATIC_LIBRARIES := libsimd
 
LOCAL_C_INCLUDES := $(LOCAL_PATH) \
                    $(LOCAL_PATH)/android
 
LOCAL_CFLAGS := -DAVOID_TABLES  -O3 -fstrict-aliasing -fprefetch-loop-arrays  -DANDROID \
        -DANDROID_TILE_BASED_DECODE -DENABLE_ANDROID_NULL_CONVERT -DANDROID_JPEG_USE_VENUM

#-DANDROID_TILE_BASED_DECODE -DUSE_ANDROID_ASHMEM 
 
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_STATIC_LIBRARY)
 
LOCAL_MODULE_TAGS := debug
 
LOCAL_MODULE := libjpeg

include $(BUILD_STATIC_LIBRARY)
