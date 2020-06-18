#coding=utf8
import os
import sys
import glob
import shutil
import platform
from sys import argv

share_lib = 'libxTest.so'
static_lib =  'libxTest.a'
static_exe = 'demo'
#检查是否为windows系统
def  isWindowsSys():
	return 'Windows' in platform.system()
#检查是否为Linux系统
def  isLinuxSys():
	return 'Linux' in platform.system()
#清空目录下的内容
def  delDirFile(pathDir):
	for i in os.listdir(pathDir):
		file_path = os.path.join(pathDir, i)
		if os.path.isfile(file_path):
			os.remove(file_path)
		else:
			delDirFile(file_path)
			
def  excuteProcess(ndk_dir, android_dir, pure_c, delimiter):
	ndk_build = ndk_dir + delimiter + 'ndk-build'
	mk_path = android_dir + delimiter + 'jni'
	application_mk = android_dir + delimiter + 'jni' + delimiter + 'Application.mk'
	
	static_lib_path = android_dir + delimiter + 'obj' + delimiter + 'local' + delimiter
	share_lib_path = android_dir + delimiter + 'obj' + delimiter + 'local' + delimiter
	
	out_share_path = android_dir + delimiter + 'out' + delimiter
	out_static_path = android_dir + delimiter + 'out' + delimiter
	if isWindowsSys():
		cpy = "copy "
	else:
		cpy = "cp "
		
	opt = pure_c.split('=')[1]
	# "=================CLEAR OUTPUT DIR========================="
	outdir_files = glob.glob(android_dir + delimiter + 'out' + delimiter + '*')
	for outdir in outdir_files:
		print(outdir)
		delDirFile(outdir)
		isExist = os.path.exists(outdir)
		if(not isExist):
			os.mkdir(outdir)

	pFile = open(application_mk, 'w')
	cmd = 'APP_ABI := x86 armeabi-v7a\nAPP_PLATFORM := android-9\nNDK_TOOLCHAIN_VERSION := 4.9'
	pFile.writelines(cmd)
	pFile.write('\n')
	pFile.close()
	# "==================BUILD SHARED LIBRARY===================="
	cmd = ndk_build + " -B " + "NDK_PROJECT_PATH:=" + android_dir + " APP_BUILD_SCRIPT:=" + mk_path + delimiter + "Android_lib.mk" + " V=1 SHARED=1" + " PURE_C=" + opt
	print(cmd)
	os.system(cmd)
	cmd = cpy + share_lib_path + "armeabi-v7a" + delimiter + share_lib + "  " + out_share_path + "armeabi-v7a" + delimiter 
	print(cmd)
	os.system(cmd)

	cmd = cpy + share_lib_path + "x86" + delimiter + share_lib + "  " + out_share_path + "x86" + delimiter 
	os.system(cmd)
	##其他平台依次类推
	# "==================BUILD STATIC LIBRARY===================="
	cmd = ndk_build + " -B " + "NDK_PROJECT_PATH:=" + android_dir + " APP_BUILD_SCRIPT:=" + mk_path + delimiter + "Android_lib.mk" + " V=1 SHARED=0" + " PURE_C=" + opt
	print(cmd)
	os.system(cmd)
	cmd = cpy + static_lib_path + "armeabi-v7a" + delimiter + static_lib + "  " + out_static_path + "armeabi-v7a" + delimiter
	print(cmd)
	os.system(cmd)
	cmd = cpy + static_lib_path + "x86" + delimiter + static_lib + "  " + out_static_path + "x86" + delimiter
	os.system(cmd)

	# "==================BUILD STATIC EXE ===================="
	cmd = ndk_build + " -B " + "NDK_PROJECT_PATH:=" + android_dir + " APP_BUILD_SCRIPT:=" + mk_path + delimiter + "Android_app.mk"
	print(cmd)
	os.system(cmd)
	cmd = cpy + static_lib_path + "armeabi-v7a" + delimiter + static_exe + "  " + out_static_path + "armeabi-v7a" + delimiter
	print(cmd)
	os.system(cmd)
	cmd = cpy + static_lib_path + "x86" + delimiter + static_exe + "  " + out_static_path + "x86" + delimiter
	os.system(cmd)
##############################main函数入口######################
if __name__ == '__main__':
	if(len(argv) < 3):
		printf("Tips: build_android.py android_ndk_dir pure_c=0/1\n")
		exit()
	delimiter =os.path.sep
	ndk_dir = argv[1]
	pure_c = argv[2]
	android_dir = os.getcwd()
	excuteProcess(ndk_dir,android_dir,pure_c,delimiter)

