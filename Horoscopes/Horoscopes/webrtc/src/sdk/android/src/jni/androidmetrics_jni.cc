/*
 *  Copyright 2016 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include <map>
#include <memory>

#include "sdk/android/src/jni/classreferenceholder.h"
#include "sdk/android/src/jni/jni_helpers.h"
#include "system_wrappers/include/metrics.h"
#include "system_wrappers/include/metrics_default.h"

// Enables collection of native histograms and creating them.
namespace webrtc {
namespace jni {

JNI_FUNCTION_DECLARATION(void, Metrics_nativeEnable, JNIEnv* jni, jclass) {
  metrics::Enable();
}

// Gets and clears native histograms.
JNI_FUNCTION_DECLARATION(jobject,
                         Metrics_nativeGetAndReset,
                         JNIEnv* jni,
                         jclass) {
  jclass j_metrics_class = jni->FindClass("org/webrtc/Metrics");
  jmethodID j_add =
      GetMethodID(jni, j_metrics_class, "add",
                  "(Ljava/lang/String;Lorg/webrtc/Metrics$HistogramInfo;)V");
  jclass j_info_class = jni->FindClass("org/webrtc/Metrics$HistogramInfo");
  jmethodID j_add_sample = GetMethodID(jni, j_info_class, "addSample", "(II)V");

  // Create |Metrics|.
  jobject j_metrics = jni->NewObject(
      j_metrics_class, GetMethodID(jni, j_metrics_class, "<init>", "()V"));

  std::map<std::string, std::unique_ptr<metrics::SampleInfo>> histograms;
  metrics::GetAndReset(&histograms);
  for (const auto& kv : histograms) {
    // Create and add samples to |HistogramInfo|.
    jobject j_info = jni->NewObject(
        j_info_class, GetMethodID(jni, j_info_class, "<init>", "(III)V"),
        kv.second->min, kv.second->max,
        static_cast<int>(kv.second->bucket_count));
    for (const auto& sample : kv.second->samples) {
      jni->CallVoidMethod(j_info, j_add_sample, sample.first, sample.second);
    }
    // Add |HistogramInfo| to |Metrics|.
    jstring j_name = jni->NewStringUTF(kv.first.c_str());
    jni->CallVoidMethod(j_metrics, j_add, j_name, j_info);
    jni->DeleteLocalRef(j_name);
    jni->DeleteLocalRef(j_info);
  }
  CHECK_EXCEPTION(jni);
  return j_metrics;
}

}  // namespace jni
}  // namespace webrtc
