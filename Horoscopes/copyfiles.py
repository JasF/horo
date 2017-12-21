# -*- coding: utf-8 -*-
import os
import fnmatch
from shutil import copyfile

text_file = open("ofiles.h", "r")
lines = text_file.readlines()
text_file.close()
ccfiles = []
for line in lines:
  begin = line.find('/*')+3
  end = line.find('*/')
  content = line[begin:begin+(end-begin)-2] + 'cc'
  ccfiles.append(content)

for root, dir, files in os.walk("webrtc/src/rtc_base/"):
  for items in fnmatch.filter(files, "*"):
    fullpath = root + items
    for filename in ccfiles:
      if filename in fullpath:
        newpath = fullpath[:-3]
        newpath += '_forxcode.cc'
        print newpath
        copyfile(fullpath, newpath)
        ccfiles.remove(filename)
        break
#print ccfiles
