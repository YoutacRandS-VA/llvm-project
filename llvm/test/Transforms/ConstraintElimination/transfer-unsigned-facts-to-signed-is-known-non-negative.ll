; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=constraint-elimination -S %s | FileCheck %s

declare void @use(i1)

define void @iv_known_non_negative_iv_constant_trip_count_uge() {
; CHECK-LABEL: @iv_known_non_negative_iv_constant_trip_count_uge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    br i1 false, label [[LOOP_LATCH]], label [[EXIT_1:%.*]]
; CHECK:       loop.latch:
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i8 [[IV]], 1
; CHECK-NEXT:    br label [[LOOP_HEADER]]
; CHECK:       exit.1:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i8 [ 0, %entry ], [ %iv.next, %loop.latch ]
  %cmp = icmp uge i8 %iv, 2
  br i1 %cmp, label %loop.latch, label %exit.1

loop.latch:
  %t.1 = icmp uge i8 %iv, 2
  call void @use(i1 %t.1)
  %t.2 = icmp sge i8 %iv, 2
  call void @use(i1 %t.2)
  %f.1 = icmp ult i8 %iv, 2
  call void @use(i1 %f.1)
  %f.2 = icmp slt i8 %iv, 2
  call void @use(i1 %f.2)
  %iv.next = add nsw nuw i8 %iv, 1
  br label %loop.header

exit.1:
  ret void
}

define void @iv_known_non_negative_iv_variable_trip_count_uge(i8 %N) {
; CHECK-LABEL: @iv_known_non_negative_iv_variable_trip_count_uge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp uge i8 [[IV]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[LOOP_LATCH]], label [[EXIT_1:%.*]]
; CHECK:       loop.latch:
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[C_0:%.*]] = icmp ugt i8 [[IV]], 2
; CHECK-NEXT:    call void @use(i1 [[C_0]])
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i8 [[IV]], 1
; CHECK-NEXT:    br label [[LOOP_HEADER]]
; CHECK:       exit.1:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i8 [ 0, %entry ], [ %iv.next, %loop.latch ]
  %cmp = icmp uge i8 %iv, %N
  br i1 %cmp, label %loop.latch, label %exit.1

loop.latch:
  %t.1 = icmp uge i8 %iv, %N
  call void @use(i1 %t.1)
  %t.2 = icmp sge i8 %iv, %N
  call void @use(i1 %t.2)
  %f.1 = icmp ult i8 %iv, %N
  call void @use(i1 %f.1)
  %f.2 = icmp slt i8 %iv, %N
  call void @use(i1 %f.2)
  %c.0 = icmp ugt i8 %iv, 2
  call void @use(i1 %c.0)
  %iv.next = add nsw nuw i8 %iv, 1
  br label %loop.header

exit.1:
  ret void
}

define void @iv_known_non_negative_iv_variable_trip_count_uge_operands_swapped(i8 %N) {
; CHECK-LABEL: @iv_known_non_negative_iv_variable_trip_count_uge_operands_swapped(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp uge i8 [[N:%.*]], [[IV]]
; CHECK-NEXT:    br i1 [[CMP]], label [[LOOP_LATCH]], label [[EXIT_1:%.*]]
; CHECK:       loop.latch:
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[T_2:%.*]] = icmp sge i8 [[N]], [[IV]]
; CHECK-NEXT:    call void @use(i1 [[T_2]])
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[F_2:%.*]] = icmp slt i8 [[N]], [[IV]]
; CHECK-NEXT:    call void @use(i1 [[F_2]])
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i8 [[IV]], 1
; CHECK-NEXT:    br label [[LOOP_HEADER]]
; CHECK:       exit.1:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i8 [ 0, %entry ], [ %iv.next, %loop.latch ]
  %cmp = icmp uge i8 %N, %iv
  br i1 %cmp, label %loop.latch, label %exit.1

loop.latch:
  %t.1 = icmp uge i8 %N, %iv
  call void @use(i1 %t.1)
  %t.2 = icmp sge i8 %N, %iv
  call void @use(i1 %t.2)
  %f.1 = icmp ult i8 %N, %iv
  call void @use(i1 %f.1)
  %f.2 = icmp slt i8 %N, %iv
  call void @use(i1 %f.2)
  %iv.next = add nsw nuw i8 %iv, 1
  br label %loop.header

exit.1:
  ret void
}

define void @iv_known_non_negative_iv_variable_trip_count_ugt(i8 %N) {
; CHECK-LABEL: @iv_known_non_negative_iv_variable_trip_count_ugt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i8 [[IV]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[LOOP_LATCH]], label [[EXIT_1:%.*]]
; CHECK:       loop.latch:
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[C_0:%.*]] = icmp ugt i8 [[IV]], 2
; CHECK-NEXT:    call void @use(i1 [[C_0]])
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i8 [[IV]], 1
; CHECK-NEXT:    br label [[LOOP_HEADER]]
; CHECK:       exit.1:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i8 [ 0, %entry ], [ %iv.next, %loop.latch ]
  %cmp = icmp ugt i8 %iv, %N
  br i1 %cmp, label %loop.latch, label %exit.1

loop.latch:
  %t.1 = icmp ugt i8 %iv, %N
  call void @use(i1 %t.1)
  %t.2 = icmp sgt i8 %iv, %N
  call void @use(i1 %t.2)
  %f.1 = icmp ult i8 %iv, %N
  call void @use(i1 %f.1)
  %f.2 = icmp slt i8 %iv, %N
  call void @use(i1 %f.2)
  %c.0 = icmp ugt i8 %iv, 2
  call void @use(i1 %c.0)
  %iv.next = add nsw nuw i8 %iv, 1
  br label %loop.header

exit.1:
  ret void
}

define void @iv_known_non_negative_iv_variable_trip_count_ugt_operands_swapped(i8 %N) {
; CHECK-LABEL: @iv_known_non_negative_iv_variable_trip_count_ugt_operands_swapped(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i8 [[N:%.*]], [[IV]]
; CHECK-NEXT:    br i1 [[CMP]], label [[LOOP_LATCH]], label [[EXIT_1:%.*]]
; CHECK:       loop.latch:
; CHECK-NEXT:    call void @use(i1 true)
; CHECK-NEXT:    [[T_2:%.*]] = icmp sgt i8 [[N]], [[IV]]
; CHECK-NEXT:    call void @use(i1 [[T_2]])
; CHECK-NEXT:    call void @use(i1 false)
; CHECK-NEXT:    [[F_2:%.*]] = icmp slt i8 [[N]], [[IV]]
; CHECK-NEXT:    call void @use(i1 [[F_2]])
; CHECK-NEXT:    [[C_0:%.*]] = icmp ugt i8 [[IV]], 2
; CHECK-NEXT:    call void @use(i1 [[C_0]])
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i8 [[IV]], 1
; CHECK-NEXT:    br label [[LOOP_HEADER]]
; CHECK:       exit.1:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i8 [ 0, %entry ], [ %iv.next, %loop.latch ]
  %cmp = icmp ugt i8 %N, %iv
  br i1 %cmp, label %loop.latch, label %exit.1

loop.latch:
  %t.1 = icmp ugt i8 %N, %iv
  call void @use(i1 %t.1)
  %t.2 = icmp sgt i8 %N, %iv
  call void @use(i1 %t.2)
  %f.1 = icmp ult i8 %N, %iv
  call void @use(i1 %f.1)
  %f.2 = icmp slt i8 %N, %iv
  call void @use(i1 %f.2)
  %c.0 = icmp ugt i8 %iv, 2
  call void @use(i1 %c.0)
  %iv.next = add nsw nuw i8 %iv, 1
  br label %loop.header

exit.1:
  ret void
}
