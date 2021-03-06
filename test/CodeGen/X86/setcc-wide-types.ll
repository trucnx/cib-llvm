; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=sse2 | FileCheck %s --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx2 | FileCheck %s --check-prefix=AVX2

; Equality checks of 128/256-bit values can use PMOVMSK or PTEST to avoid scalarization.

define i32 @ne_i128(<2 x i64> %x, <2 x i64> %y) {
; SSE2-LABEL: ne_i128:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpeqb %xmm1, %xmm0
; SSE2-NEXT:    pmovmskb %xmm0, %ecx
; SSE2-NEXT:    xorl %eax, %eax
; SSE2-NEXT:    cmpl $65535, %ecx # imm = 0xFFFF
; SSE2-NEXT:    setne %al
; SSE2-NEXT:    retq
;
; AVX2-LABEL: ne_i128:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpeqb %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpmovmskb %xmm0, %ecx
; AVX2-NEXT:    xorl %eax, %eax
; AVX2-NEXT:    cmpl $65535, %ecx # imm = 0xFFFF
; AVX2-NEXT:    setne %al
; AVX2-NEXT:    retq
  %bcx = bitcast <2 x i64> %x to i128
  %bcy = bitcast <2 x i64> %y to i128
  %cmp = icmp ne i128 %bcx, %bcy
  %zext = zext i1 %cmp to i32
  ret i32 %zext
}

define i32 @eq_i128(<2 x i64> %x, <2 x i64> %y) {
; SSE2-LABEL: eq_i128:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pcmpeqb %xmm1, %xmm0
; SSE2-NEXT:    pmovmskb %xmm0, %ecx
; SSE2-NEXT:    xorl %eax, %eax
; SSE2-NEXT:    cmpl $65535, %ecx # imm = 0xFFFF
; SSE2-NEXT:    sete %al
; SSE2-NEXT:    retq
;
; AVX2-LABEL: eq_i128:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpeqb %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpmovmskb %xmm0, %ecx
; AVX2-NEXT:    xorl %eax, %eax
; AVX2-NEXT:    cmpl $65535, %ecx # imm = 0xFFFF
; AVX2-NEXT:    sete %al
; AVX2-NEXT:    retq
  %bcx = bitcast <2 x i64> %x to i128
  %bcy = bitcast <2 x i64> %y to i128
  %cmp = icmp eq i128 %bcx, %bcy
  %zext = zext i1 %cmp to i32
  ret i32 %zext
}

define i32 @ne_i256(<4 x i64> %x, <4 x i64> %y) {
; SSE2-LABEL: ne_i256:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm0[2,3,0,1]
; SSE2-NEXT:    movq %xmm4, %rax
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm1[2,3,0,1]
; SSE2-NEXT:    movq %xmm4, %rcx
; SSE2-NEXT:    movq %xmm0, %rdx
; SSE2-NEXT:    movq %xmm1, %r8
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm2[2,3,0,1]
; SSE2-NEXT:    movq %xmm0, %rdi
; SSE2-NEXT:    xorq %rax, %rdi
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm3[2,3,0,1]
; SSE2-NEXT:    movq %xmm0, %rsi
; SSE2-NEXT:    xorq %rcx, %rsi
; SSE2-NEXT:    orq %rdi, %rsi
; SSE2-NEXT:    movq %xmm2, %rax
; SSE2-NEXT:    xorq %rdx, %rax
; SSE2-NEXT:    movq %xmm3, %rcx
; SSE2-NEXT:    xorq %r8, %rcx
; SSE2-NEXT:    orq %rax, %rcx
; SSE2-NEXT:    xorl %eax, %eax
; SSE2-NEXT:    orq %rsi, %rcx
; SSE2-NEXT:    setne %al
; SSE2-NEXT:    retq
;
; AVX2-LABEL: ne_i256:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpeqb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpmovmskb %ymm0, %ecx
; AVX2-NEXT:    xorl %eax, %eax
; AVX2-NEXT:    cmpl $-1, %ecx
; AVX2-NEXT:    setne %al
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %bcx = bitcast <4 x i64> %x to i256
  %bcy = bitcast <4 x i64> %y to i256
  %cmp = icmp ne i256 %bcx, %bcy
  %zext = zext i1 %cmp to i32
  ret i32 %zext
}

define i32 @eq_i256(<4 x i64> %x, <4 x i64> %y) {
; SSE2-LABEL: eq_i256:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm0[2,3,0,1]
; SSE2-NEXT:    movq %xmm4, %rax
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm1[2,3,0,1]
; SSE2-NEXT:    movq %xmm4, %rcx
; SSE2-NEXT:    movq %xmm0, %rdx
; SSE2-NEXT:    movq %xmm1, %r8
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm2[2,3,0,1]
; SSE2-NEXT:    movq %xmm0, %rdi
; SSE2-NEXT:    xorq %rax, %rdi
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm3[2,3,0,1]
; SSE2-NEXT:    movq %xmm0, %rsi
; SSE2-NEXT:    xorq %rcx, %rsi
; SSE2-NEXT:    orq %rdi, %rsi
; SSE2-NEXT:    movq %xmm2, %rax
; SSE2-NEXT:    xorq %rdx, %rax
; SSE2-NEXT:    movq %xmm3, %rcx
; SSE2-NEXT:    xorq %r8, %rcx
; SSE2-NEXT:    orq %rax, %rcx
; SSE2-NEXT:    xorl %eax, %eax
; SSE2-NEXT:    orq %rsi, %rcx
; SSE2-NEXT:    sete %al
; SSE2-NEXT:    retq
;
; AVX2-LABEL: eq_i256:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpeqb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpmovmskb %ymm0, %ecx
; AVX2-NEXT:    xorl %eax, %eax
; AVX2-NEXT:    cmpl $-1, %ecx
; AVX2-NEXT:    sete %al
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %bcx = bitcast <4 x i64> %x to i256
  %bcy = bitcast <4 x i64> %y to i256
  %cmp = icmp eq i256 %bcx, %bcy
  %zext = zext i1 %cmp to i32
  ret i32 %zext
}

; This test models the expansion of 'memcmp(a, b, 32) != 0' 
; if we allowed 2 pairs of 16-byte loads per block.

define i32 @ne_i128_pair(i128* %a, i128* %b) {
; SSE2-LABEL: ne_i128_pair:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movq (%rdi), %rax
; SSE2-NEXT:    movq 8(%rdi), %rcx
; SSE2-NEXT:    xorq (%rsi), %rax
; SSE2-NEXT:    xorq 8(%rsi), %rcx
; SSE2-NEXT:    movq 24(%rdi), %rdx
; SSE2-NEXT:    movq 16(%rdi), %rdi
; SSE2-NEXT:    xorq 16(%rsi), %rdi
; SSE2-NEXT:    orq %rax, %rdi
; SSE2-NEXT:    xorq 24(%rsi), %rdx
; SSE2-NEXT:    orq %rcx, %rdx
; SSE2-NEXT:    xorl %eax, %eax
; SSE2-NEXT:    orq %rdi, %rdx
; SSE2-NEXT:    setne %al
; SSE2-NEXT:    retq
;
; AVX2-LABEL: ne_i128_pair:
; AVX2:       # %bb.0:
; AVX2-NEXT:    movq (%rdi), %rax
; AVX2-NEXT:    movq 8(%rdi), %rcx
; AVX2-NEXT:    xorq (%rsi), %rax
; AVX2-NEXT:    xorq 8(%rsi), %rcx
; AVX2-NEXT:    movq 24(%rdi), %rdx
; AVX2-NEXT:    movq 16(%rdi), %rdi
; AVX2-NEXT:    xorq 16(%rsi), %rdi
; AVX2-NEXT:    orq %rax, %rdi
; AVX2-NEXT:    xorq 24(%rsi), %rdx
; AVX2-NEXT:    orq %rcx, %rdx
; AVX2-NEXT:    xorl %eax, %eax
; AVX2-NEXT:    orq %rdi, %rdx
; AVX2-NEXT:    setne %al
; AVX2-NEXT:    retq
  %a0 = load i128, i128* %a
  %b0 = load i128, i128* %b
  %xor1 = xor i128 %a0, %b0
  %ap1 = getelementptr i128, i128* %a, i128 1
  %bp1 = getelementptr i128, i128* %b, i128 1
  %a1 = load i128, i128* %ap1
  %b1 = load i128, i128* %bp1
  %xor2 = xor i128 %a1, %b1
  %or = or i128 %xor1, %xor2
  %cmp = icmp ne i128 %or, 0
  %z = zext i1 %cmp to i32
  ret i32 %z
}

; This test models the expansion of 'memcmp(a, b, 32) == 0' 
; if we allowed 2 pairs of 16-byte loads per block.

define i32 @eq_i128_pair(i128* %a, i128* %b) {
; SSE2-LABEL: eq_i128_pair:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movq (%rdi), %rax
; SSE2-NEXT:    movq 8(%rdi), %rcx
; SSE2-NEXT:    xorq (%rsi), %rax
; SSE2-NEXT:    xorq 8(%rsi), %rcx
; SSE2-NEXT:    movq 24(%rdi), %rdx
; SSE2-NEXT:    movq 16(%rdi), %rdi
; SSE2-NEXT:    xorq 16(%rsi), %rdi
; SSE2-NEXT:    orq %rax, %rdi
; SSE2-NEXT:    xorq 24(%rsi), %rdx
; SSE2-NEXT:    orq %rcx, %rdx
; SSE2-NEXT:    xorl %eax, %eax
; SSE2-NEXT:    orq %rdi, %rdx
; SSE2-NEXT:    sete %al
; SSE2-NEXT:    retq
;
; AVX2-LABEL: eq_i128_pair:
; AVX2:       # %bb.0:
; AVX2-NEXT:    movq (%rdi), %rax
; AVX2-NEXT:    movq 8(%rdi), %rcx
; AVX2-NEXT:    xorq (%rsi), %rax
; AVX2-NEXT:    xorq 8(%rsi), %rcx
; AVX2-NEXT:    movq 24(%rdi), %rdx
; AVX2-NEXT:    movq 16(%rdi), %rdi
; AVX2-NEXT:    xorq 16(%rsi), %rdi
; AVX2-NEXT:    orq %rax, %rdi
; AVX2-NEXT:    xorq 24(%rsi), %rdx
; AVX2-NEXT:    orq %rcx, %rdx
; AVX2-NEXT:    xorl %eax, %eax
; AVX2-NEXT:    orq %rdi, %rdx
; AVX2-NEXT:    sete %al
; AVX2-NEXT:    retq
  %a0 = load i128, i128* %a
  %b0 = load i128, i128* %b
  %xor1 = xor i128 %a0, %b0
  %ap1 = getelementptr i128, i128* %a, i128 1
  %bp1 = getelementptr i128, i128* %b, i128 1
  %a1 = load i128, i128* %ap1
  %b1 = load i128, i128* %bp1
  %xor2 = xor i128 %a1, %b1
  %or = or i128 %xor1, %xor2
  %cmp = icmp eq i128 %or, 0
  %z = zext i1 %cmp to i32
  ret i32 %z
}

; This test models the expansion of 'memcmp(a, b, 64) != 0' 
; if we allowed 2 pairs of 32-byte loads per block.

define i32 @ne_i256_pair(i256* %a, i256* %b) {
; SSE2-LABEL: ne_i256_pair:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movq 16(%rdi), %r9
; SSE2-NEXT:    movq 24(%rdi), %r11
; SSE2-NEXT:    movq (%rdi), %r8
; SSE2-NEXT:    movq 8(%rdi), %r10
; SSE2-NEXT:    xorq 8(%rsi), %r10
; SSE2-NEXT:    xorq 24(%rsi), %r11
; SSE2-NEXT:    xorq (%rsi), %r8
; SSE2-NEXT:    xorq 16(%rsi), %r9
; SSE2-NEXT:    movq 48(%rdi), %rdx
; SSE2-NEXT:    movq 32(%rdi), %rax
; SSE2-NEXT:    movq 56(%rdi), %rcx
; SSE2-NEXT:    movq 40(%rdi), %rdi
; SSE2-NEXT:    xorq 40(%rsi), %rdi
; SSE2-NEXT:    xorq 56(%rsi), %rcx
; SSE2-NEXT:    orq %r11, %rcx
; SSE2-NEXT:    orq %rdi, %rcx
; SSE2-NEXT:    orq %r10, %rcx
; SSE2-NEXT:    xorq 32(%rsi), %rax
; SSE2-NEXT:    xorq 48(%rsi), %rdx
; SSE2-NEXT:    orq %r9, %rdx
; SSE2-NEXT:    orq %rax, %rdx
; SSE2-NEXT:    orq %r8, %rdx
; SSE2-NEXT:    xorl %eax, %eax
; SSE2-NEXT:    orq %rcx, %rdx
; SSE2-NEXT:    setne %al
; SSE2-NEXT:    retq
;
; AVX2-LABEL: ne_i256_pair:
; AVX2:       # %bb.0:
; AVX2-NEXT:    movq 16(%rdi), %r9
; AVX2-NEXT:    movq 24(%rdi), %r11
; AVX2-NEXT:    movq (%rdi), %r8
; AVX2-NEXT:    movq 8(%rdi), %r10
; AVX2-NEXT:    xorq 8(%rsi), %r10
; AVX2-NEXT:    xorq 24(%rsi), %r11
; AVX2-NEXT:    xorq (%rsi), %r8
; AVX2-NEXT:    xorq 16(%rsi), %r9
; AVX2-NEXT:    movq 48(%rdi), %rdx
; AVX2-NEXT:    movq 32(%rdi), %rax
; AVX2-NEXT:    movq 56(%rdi), %rcx
; AVX2-NEXT:    movq 40(%rdi), %rdi
; AVX2-NEXT:    xorq 40(%rsi), %rdi
; AVX2-NEXT:    xorq 56(%rsi), %rcx
; AVX2-NEXT:    orq %r11, %rcx
; AVX2-NEXT:    orq %rdi, %rcx
; AVX2-NEXT:    orq %r10, %rcx
; AVX2-NEXT:    xorq 32(%rsi), %rax
; AVX2-NEXT:    xorq 48(%rsi), %rdx
; AVX2-NEXT:    orq %r9, %rdx
; AVX2-NEXT:    orq %rax, %rdx
; AVX2-NEXT:    orq %r8, %rdx
; AVX2-NEXT:    xorl %eax, %eax
; AVX2-NEXT:    orq %rcx, %rdx
; AVX2-NEXT:    setne %al
; AVX2-NEXT:    retq
  %a0 = load i256, i256* %a
  %b0 = load i256, i256* %b
  %xor1 = xor i256 %a0, %b0
  %ap1 = getelementptr i256, i256* %a, i256 1
  %bp1 = getelementptr i256, i256* %b, i256 1
  %a1 = load i256, i256* %ap1
  %b1 = load i256, i256* %bp1
  %xor2 = xor i256 %a1, %b1
  %or = or i256 %xor1, %xor2
  %cmp = icmp ne i256 %or, 0
  %z = zext i1 %cmp to i32
  ret i32 %z
}

; This test models the expansion of 'memcmp(a, b, 64) == 0' 
; if we allowed 2 pairs of 32-byte loads per block.

define i32 @eq_i256_pair(i256* %a, i256* %b) {
; SSE2-LABEL: eq_i256_pair:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movq 16(%rdi), %r9
; SSE2-NEXT:    movq 24(%rdi), %r11
; SSE2-NEXT:    movq (%rdi), %r8
; SSE2-NEXT:    movq 8(%rdi), %r10
; SSE2-NEXT:    xorq 8(%rsi), %r10
; SSE2-NEXT:    xorq 24(%rsi), %r11
; SSE2-NEXT:    xorq (%rsi), %r8
; SSE2-NEXT:    xorq 16(%rsi), %r9
; SSE2-NEXT:    movq 48(%rdi), %rdx
; SSE2-NEXT:    movq 32(%rdi), %rax
; SSE2-NEXT:    movq 56(%rdi), %rcx
; SSE2-NEXT:    movq 40(%rdi), %rdi
; SSE2-NEXT:    xorq 40(%rsi), %rdi
; SSE2-NEXT:    xorq 56(%rsi), %rcx
; SSE2-NEXT:    orq %r11, %rcx
; SSE2-NEXT:    orq %rdi, %rcx
; SSE2-NEXT:    orq %r10, %rcx
; SSE2-NEXT:    xorq 32(%rsi), %rax
; SSE2-NEXT:    xorq 48(%rsi), %rdx
; SSE2-NEXT:    orq %r9, %rdx
; SSE2-NEXT:    orq %rax, %rdx
; SSE2-NEXT:    orq %r8, %rdx
; SSE2-NEXT:    xorl %eax, %eax
; SSE2-NEXT:    orq %rcx, %rdx
; SSE2-NEXT:    sete %al
; SSE2-NEXT:    retq
;
; AVX2-LABEL: eq_i256_pair:
; AVX2:       # %bb.0:
; AVX2-NEXT:    movq 16(%rdi), %r9
; AVX2-NEXT:    movq 24(%rdi), %r11
; AVX2-NEXT:    movq (%rdi), %r8
; AVX2-NEXT:    movq 8(%rdi), %r10
; AVX2-NEXT:    xorq 8(%rsi), %r10
; AVX2-NEXT:    xorq 24(%rsi), %r11
; AVX2-NEXT:    xorq (%rsi), %r8
; AVX2-NEXT:    xorq 16(%rsi), %r9
; AVX2-NEXT:    movq 48(%rdi), %rdx
; AVX2-NEXT:    movq 32(%rdi), %rax
; AVX2-NEXT:    movq 56(%rdi), %rcx
; AVX2-NEXT:    movq 40(%rdi), %rdi
; AVX2-NEXT:    xorq 40(%rsi), %rdi
; AVX2-NEXT:    xorq 56(%rsi), %rcx
; AVX2-NEXT:    orq %r11, %rcx
; AVX2-NEXT:    orq %rdi, %rcx
; AVX2-NEXT:    orq %r10, %rcx
; AVX2-NEXT:    xorq 32(%rsi), %rax
; AVX2-NEXT:    xorq 48(%rsi), %rdx
; AVX2-NEXT:    orq %r9, %rdx
; AVX2-NEXT:    orq %rax, %rdx
; AVX2-NEXT:    orq %r8, %rdx
; AVX2-NEXT:    xorl %eax, %eax
; AVX2-NEXT:    orq %rcx, %rdx
; AVX2-NEXT:    sete %al
; AVX2-NEXT:    retq
  %a0 = load i256, i256* %a
  %b0 = load i256, i256* %b
  %xor1 = xor i256 %a0, %b0
  %ap1 = getelementptr i256, i256* %a, i256 1
  %bp1 = getelementptr i256, i256* %b, i256 1
  %a1 = load i256, i256* %ap1
  %b1 = load i256, i256* %bp1
  %xor2 = xor i256 %a1, %b1
  %or = or i256 %xor1, %xor2
  %cmp = icmp eq i256 %or, 0
  %z = zext i1 %cmp to i32
  ret i32 %z
}

