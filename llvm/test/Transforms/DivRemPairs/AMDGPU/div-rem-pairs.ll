; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 4
; RUN: opt < %s -passes=div-rem-pairs -S -mtriple=amdgcn-amd-amdhsa | FileCheck %s

define i32 @basic(ptr %p, i32 %x, i32 %y) {
; CHECK-LABEL: define i32 @basic(
; CHECK-SAME: ptr [[P:%.*]], i32 [[X:%.*]], i32 [[Y:%.*]]) {
; CHECK-NEXT:    [[X_FROZEN:%.*]] = freeze i32 [[X]]
; CHECK-NEXT:    [[Y_FROZEN:%.*]] = freeze i32 [[Y]]
; CHECK-NEXT:    [[DIV:%.*]] = udiv i32 [[X_FROZEN]], [[Y_FROZEN]]
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 [[DIV]], [[Y_FROZEN]]
; CHECK-NEXT:    [[REM_DECOMPOSED:%.*]] = sub i32 [[X_FROZEN]], [[TMP1]]
; CHECK-NEXT:    store i32 [[DIV]], ptr [[P]], align 4
; CHECK-NEXT:    ret i32 [[REM_DECOMPOSED]]
;
  %div = udiv i32 %x, %y
  %rem = urem i32 %x, %y
  store i32 %div, ptr %p, align 4
  ret i32 %rem
}

define i32 @no_freezes(ptr %p, i32 noundef %x, i32 noundef %y) {
; CHECK-LABEL: define i32 @no_freezes(
; CHECK-SAME: ptr [[P:%.*]], i32 noundef [[X:%.*]], i32 noundef [[Y:%.*]]) {
; CHECK-NEXT:    [[DIV:%.*]] = udiv i32 [[X]], [[Y]]
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 [[DIV]], [[Y]]
; CHECK-NEXT:    [[REM_DECOMPOSED:%.*]] = sub i32 [[X]], [[TMP1]]
; CHECK-NEXT:    store i32 [[DIV]], ptr [[P]], align 4
; CHECK-NEXT:    ret i32 [[REM_DECOMPOSED]]
;
  %div = udiv i32 %x, %y
  %rem = urem i32 %x, %y
  store i32 %div, ptr %p, align 4
  ret i32 %rem
}

define i32 @poison_does_not_freeze(ptr %p, i32 noundef %x, i32 noundef %y) {
; CHECK-LABEL: define i32 @poison_does_not_freeze(
; CHECK-SAME: ptr [[P:%.*]], i32 noundef [[X:%.*]], i32 noundef [[Y:%.*]]) {
; CHECK-NEXT:    [[X2:%.*]] = shl nuw nsw i32 [[X]], 5
; CHECK-NEXT:    [[Y2:%.*]] = add nuw nsw i32 [[Y]], 1
; CHECK-NEXT:    [[DIV:%.*]] = udiv i32 [[X2]], [[Y2]]
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 [[DIV]], [[Y2]]
; CHECK-NEXT:    [[REM_DECOMPOSED:%.*]] = sub i32 [[X2]], [[TMP1]]
; CHECK-NEXT:    store i32 [[DIV]], ptr [[P]], align 4
; CHECK-NEXT:    ret i32 [[REM_DECOMPOSED]]
;
  %x2 = shl nuw nsw i32 %x, 5
  %y2 = add nuw nsw i32 %y, 1
  %div = udiv i32 %x2, %y2
  %rem = urem i32 %x2, %y2
  store i32 %div, ptr %p, align 4
  ret i32 %rem
}

define i32 @poison_does_not_freeze_signed(ptr %p, i32 noundef %x, i32 noundef %y) {
; CHECK-LABEL: define i32 @poison_does_not_freeze_signed(
; CHECK-SAME: ptr [[P:%.*]], i32 noundef [[X:%.*]], i32 noundef [[Y:%.*]]) {
; CHECK-NEXT:    [[X2:%.*]] = shl nuw nsw i32 [[X]], 5
; CHECK-NEXT:    [[Y2:%.*]] = add nuw nsw i32 [[Y]], 1
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i32 [[X2]], [[Y2]]
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 [[DIV]], [[Y2]]
; CHECK-NEXT:    [[REM_DECOMPOSED:%.*]] = sub i32 [[X2]], [[TMP1]]
; CHECK-NEXT:    store i32 [[DIV]], ptr [[P]], align 4
; CHECK-NEXT:    ret i32 [[REM_DECOMPOSED]]
;
  %x2 = shl nuw nsw i32 %x, 5
  %y2 = add nuw nsw i32 %y, 1
  %div = sdiv i32 %x2, %y2
  %rem = srem i32 %x2, %y2
  store i32 %div, ptr %p, align 4
  ret i32 %rem
}

define <4 x i8> @poison_does_not_freeze_vector(ptr %p, <4 x i8> noundef %x, <4 x i8> noundef %y) {
; CHECK-LABEL: define <4 x i8> @poison_does_not_freeze_vector(
; CHECK-SAME: ptr [[P:%.*]], <4 x i8> noundef [[X:%.*]], <4 x i8> noundef [[Y:%.*]]) {
; CHECK-NEXT:    [[X2:%.*]] = shl nuw nsw <4 x i8> [[X]], splat (i8 5)
; CHECK-NEXT:    [[Y2:%.*]] = add nuw nsw <4 x i8> [[Y]], splat (i8 1)
; CHECK-NEXT:    [[DIV:%.*]] = udiv <4 x i8> [[X2]], [[Y2]]
; CHECK-NEXT:    [[TMP1:%.*]] = mul <4 x i8> [[DIV]], [[Y2]]
; CHECK-NEXT:    [[REM_DECOMPOSED:%.*]] = sub <4 x i8> [[X2]], [[TMP1]]
; CHECK-NEXT:    store <4 x i8> [[DIV]], ptr [[P]], align 4
; CHECK-NEXT:    ret <4 x i8> [[REM_DECOMPOSED]]
;
  %x2 = shl nuw nsw <4 x i8> %x, <i8 5, i8 5, i8 5, i8 5>
  %y2 = add nuw nsw <4 x i8> %y, <i8 1, i8 1, i8 1, i8 1>
  %div = udiv <4 x i8> %x2, %y2
  %rem = urem <4 x i8> %x2, %y2
  store <4 x i8> %div, ptr %p, align 4
  ret <4 x i8> %rem
}

define i32 @explicit_poison_does_not_freeze(ptr %p, i32 noundef %y) {
; CHECK-LABEL: define i32 @explicit_poison_does_not_freeze(
; CHECK-SAME: ptr [[P:%.*]], i32 noundef [[Y:%.*]]) {
; CHECK-NEXT:    [[X:%.*]] = add i32 poison, 1
; CHECK-NEXT:    [[Y2:%.*]] = add nuw nsw i32 [[Y]], 1
; CHECK-NEXT:    [[DIV:%.*]] = udiv i32 [[X]], [[Y2]]
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 [[DIV]], [[Y2]]
; CHECK-NEXT:    [[REM_DECOMPOSED:%.*]] = sub i32 [[X]], [[TMP1]]
; CHECK-NEXT:    store i32 [[DIV]], ptr [[P]], align 4
; CHECK-NEXT:    ret i32 [[REM_DECOMPOSED]]
;
  %x = add i32 poison, 1
  %y2 = add nuw nsw i32 %y, 1
  %div = udiv i32 %x, %y2
  %rem = urem i32 %x, %y2
  store i32 %div, ptr %p, align 4
  ret i32 %rem
}

define i32 @explicit_poison_does_not_freeze_signed(ptr %p, i32 noundef %y) {
; CHECK-LABEL: define i32 @explicit_poison_does_not_freeze_signed(
; CHECK-SAME: ptr [[P:%.*]], i32 noundef [[Y:%.*]]) {
; CHECK-NEXT:    [[X:%.*]] = add i32 poison, 1
; CHECK-NEXT:    [[Y2:%.*]] = add nuw nsw i32 [[Y]], 1
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i32 [[X]], [[Y2]]
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 [[DIV]], [[Y2]]
; CHECK-NEXT:    [[REM_DECOMPOSED:%.*]] = sub i32 [[X]], [[TMP1]]
; CHECK-NEXT:    store i32 [[DIV]], ptr [[P]], align 4
; CHECK-NEXT:    ret i32 [[REM_DECOMPOSED]]
;
  %x = add i32 poison, 1
  %y2 = add nuw nsw i32 %y, 1
  %div = sdiv i32 %x, %y2
  %rem = srem i32 %x, %y2
  store i32 %div, ptr %p, align 4
  ret i32 %rem
}
