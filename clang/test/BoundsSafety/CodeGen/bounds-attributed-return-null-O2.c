// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --version 5
// RUN: %clang_cc1 -O2 -triple arm64-apple-iphoneos -fbounds-safety -fbounds-safety-bringup-missing-checks=return_size -Wno-bounds-safety-single-to-count -emit-llvm %s -o - | FileCheck %s
// RUN: %clang_cc1 -O2 -triple arm64-apple-iphoneos -fbounds-safety -fno-bounds-safety-bringup-missing-checks=return_size -Wno-bounds-safety-single-to-count -emit-llvm %s -o - | FileCheck --check-prefix=LEGACY %s

#include <ptrcheck.h>

// CHECK-LABEL: define dso_local noalias noundef ptr @cb_0(
// CHECK-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR0:[0-9]+]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[LEN]], 0, !annotation [[META2:![0-9]+]]
// CHECK-NEXT:    br i1 [[CMP]], label %[[CONT:.*]], label %[[TRAP:.*]], !annotation [[META2]]
// CHECK:       [[TRAP]]:
// CHECK-NEXT:    tail call void @llvm.ubsantrap(i8 25) #[[ATTR3:[0-9]+]], !annotation [[META2]]
// CHECK-NEXT:    unreachable, !annotation [[META2]]
// CHECK:       [[CONT]]:
// CHECK-NEXT:    ret ptr null
//
// LEGACY-LABEL: define dso_local noalias noundef ptr @cb_0(
// LEGACY-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR0:[0-9]+]] {
// LEGACY-NEXT:  [[ENTRY:.*:]]
// LEGACY-NEXT:    ret ptr null
//
int *__counted_by(len) cb_0(int len) {
  return 0;
}

// CHECK-LABEL: define dso_local noalias noundef ptr @cb_NULL(
// CHECK-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[LEN]], 0, !annotation [[META2]]
// CHECK-NEXT:    br i1 [[CMP]], label %[[CONT:.*]], label %[[TRAP:.*]], !annotation [[META2]]
// CHECK:       [[TRAP]]:
// CHECK-NEXT:    tail call void @llvm.ubsantrap(i8 25) #[[ATTR3]], !annotation [[META2]]
// CHECK-NEXT:    unreachable, !annotation [[META2]]
// CHECK:       [[CONT]]:
// CHECK-NEXT:    ret ptr null
//
// LEGACY-LABEL: define dso_local noalias noundef ptr @cb_NULL(
// LEGACY-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR0]] {
// LEGACY-NEXT:  [[ENTRY:.*:]]
// LEGACY-NEXT:    ret ptr null
//
int *__counted_by(len) cb_NULL(int len) {
  return (void *)0;
}

// CHECK-LABEL: define dso_local noalias noundef ptr @cb_int_cast(
// CHECK-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[LEN]], 0, !annotation [[META2]]
// CHECK-NEXT:    br i1 [[CMP]], label %[[CONT:.*]], label %[[TRAP:.*]], !annotation [[META2]]
// CHECK:       [[TRAP]]:
// CHECK-NEXT:    tail call void @llvm.ubsantrap(i8 25) #[[ATTR3]], !annotation [[META2]]
// CHECK-NEXT:    unreachable, !annotation [[META2]]
// CHECK:       [[CONT]]:
// CHECK-NEXT:    ret ptr null
//
// LEGACY-LABEL: define dso_local noalias noundef ptr @cb_int_cast(
// LEGACY-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR0]] {
// LEGACY-NEXT:  [[ENTRY:.*:]]
// LEGACY-NEXT:    ret ptr null
//
int *__counted_by(len) cb_int_cast(int len) {
  return (int *)0;
}

// CHECK-LABEL: define dso_local noalias noundef ptr @cb_int_cast_NULL(
// CHECK-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[LEN]], 0, !annotation [[META2]]
// CHECK-NEXT:    br i1 [[CMP]], label %[[CONT:.*]], label %[[TRAP:.*]], !annotation [[META2]]
// CHECK:       [[TRAP]]:
// CHECK-NEXT:    tail call void @llvm.ubsantrap(i8 25) #[[ATTR3]], !annotation [[META2]]
// CHECK-NEXT:    unreachable, !annotation [[META2]]
// CHECK:       [[CONT]]:
// CHECK-NEXT:    ret ptr null
//
// LEGACY-LABEL: define dso_local noalias noundef ptr @cb_int_cast_NULL(
// LEGACY-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR0]] {
// LEGACY-NEXT:  [[ENTRY:.*:]]
// LEGACY-NEXT:    ret ptr null
//
int *__counted_by(len) cb_int_cast_NULL(int len) {
  return (int *)(void*)0;
}

// CHECK-LABEL: define dso_local noalias noundef ptr @sb_0(
// CHECK-SAME: i32 noundef [[SIZE:%.*]]) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[SIZE]], 0, !annotation [[META2]]
// CHECK-NEXT:    br i1 [[CMP]], label %[[CONT:.*]], label %[[TRAP:.*]], !annotation [[META2]]
// CHECK:       [[TRAP]]:
// CHECK-NEXT:    tail call void @llvm.ubsantrap(i8 25) #[[ATTR3]], !annotation [[META2]]
// CHECK-NEXT:    unreachable, !annotation [[META2]]
// CHECK:       [[CONT]]:
// CHECK-NEXT:    ret ptr null
//
// LEGACY-LABEL: define dso_local noalias noundef ptr @sb_0(
// LEGACY-SAME: i32 noundef [[SIZE:%.*]]) local_unnamed_addr #[[ATTR0]] {
// LEGACY-NEXT:  [[ENTRY:.*:]]
// LEGACY-NEXT:    ret ptr null
//
int *__sized_by(size) sb_0(int size) {
  return 0;
}

// CHECK-LABEL: define dso_local noalias noundef ptr @sb_int_cast(
// CHECK-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[LEN]], 0, !annotation [[META2]]
// CHECK-NEXT:    br i1 [[CMP]], label %[[CONT:.*]], label %[[TRAP:.*]], !annotation [[META2]]
// CHECK:       [[TRAP]]:
// CHECK-NEXT:    tail call void @llvm.ubsantrap(i8 25) #[[ATTR3]], !annotation [[META2]]
// CHECK-NEXT:    unreachable, !annotation [[META2]]
// CHECK:       [[CONT]]:
// CHECK-NEXT:    ret ptr null
//
// LEGACY-LABEL: define dso_local noalias noundef ptr @sb_int_cast(
// LEGACY-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR0]] {
// LEGACY-NEXT:  [[ENTRY:.*:]]
// LEGACY-NEXT:    ret ptr null
//
int *__sized_by(len) sb_int_cast(int len) {
  return (int *)0;
}

// CHECK-LABEL: define dso_local noalias noundef ptr @sb_int_cast_NULL(
// CHECK-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR0]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[LEN]], 0, !annotation [[META2]]
// CHECK-NEXT:    br i1 [[CMP]], label %[[CONT:.*]], label %[[TRAP:.*]], !annotation [[META2]]
// CHECK:       [[TRAP]]:
// CHECK-NEXT:    tail call void @llvm.ubsantrap(i8 25) #[[ATTR3]], !annotation [[META2]]
// CHECK-NEXT:    unreachable, !annotation [[META2]]
// CHECK:       [[CONT]]:
// CHECK-NEXT:    ret ptr null
//
// LEGACY-LABEL: define dso_local noalias noundef ptr @sb_int_cast_NULL(
// LEGACY-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR0]] {
// LEGACY-NEXT:  [[ENTRY:.*:]]
// LEGACY-NEXT:    ret ptr null
//
int *__sized_by(len) sb_int_cast_NULL(int len) {
  return (int *)(void*)0;
}

// CHECK-LABEL: define dso_local noalias noundef ptr @cbn_0(
// CHECK-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR2:[0-9]+]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret ptr null
//
// LEGACY-LABEL: define dso_local noalias noundef ptr @cbn_0(
// LEGACY-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR0]] {
// LEGACY-NEXT:  [[ENTRY:.*:]]
// LEGACY-NEXT:    ret ptr null
//
int *__counted_by_or_null(len) cbn_0(int len) {
  return 0;
}

// CHECK-LABEL: define dso_local noalias noundef ptr @cbn_int_cast(
// CHECK-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR2]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret ptr null
//
// LEGACY-LABEL: define dso_local noalias noundef ptr @cbn_int_cast(
// LEGACY-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR0]] {
// LEGACY-NEXT:  [[ENTRY:.*:]]
// LEGACY-NEXT:    ret ptr null
//
int *__counted_by_or_null(len) cbn_int_cast(int len) {
  return (int*)0;
}

// CHECK-LABEL: define dso_local noalias noundef ptr @cbn_int_cast_NULL(
// CHECK-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR2]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret ptr null
//
// LEGACY-LABEL: define dso_local noalias noundef ptr @cbn_int_cast_NULL(
// LEGACY-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR0]] {
// LEGACY-NEXT:  [[ENTRY:.*:]]
// LEGACY-NEXT:    ret ptr null
//
int *__counted_by_or_null(len) cbn_int_cast_NULL(int len) {
  return (int*)(void*)0;
}

// CHECK-LABEL: define dso_local noalias noundef ptr @sbn_0(
// CHECK-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR2]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret ptr null
//
// LEGACY-LABEL: define dso_local noalias noundef ptr @sbn_0(
// LEGACY-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR0]] {
// LEGACY-NEXT:  [[ENTRY:.*:]]
// LEGACY-NEXT:    ret ptr null
//
int *__sized_by_or_null(len) sbn_0(int len) {
  return 0;
}

// CHECK-LABEL: define dso_local noalias noundef ptr @sbn_int_cast(
// CHECK-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR2]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret ptr null
//
// LEGACY-LABEL: define dso_local noalias noundef ptr @sbn_int_cast(
// LEGACY-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR0]] {
// LEGACY-NEXT:  [[ENTRY:.*:]]
// LEGACY-NEXT:    ret ptr null
//
int *__sized_by_or_null(len) sbn_int_cast(int len) {
  return (int*)0;
}

// CHECK-LABEL: define dso_local noalias noundef ptr @sbn_int_cast_NULL(
// CHECK-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR2]] {
// CHECK-NEXT:  [[ENTRY:.*:]]
// CHECK-NEXT:    ret ptr null
//
// LEGACY-LABEL: define dso_local noalias noundef ptr @sbn_int_cast_NULL(
// LEGACY-SAME: i32 noundef [[LEN:%.*]]) local_unnamed_addr #[[ATTR0]] {
// LEGACY-NEXT:  [[ENTRY:.*:]]
// LEGACY-NEXT:    ret ptr null
//
int *__sized_by_or_null(len) sbn_int_cast_NULL(int len) {
  return (int*)(void*)0;
}
//.
// CHECK: [[META2]] = !{!"bounds-safety-generic"}
//.
