/*****************************************************************************
 * cpu.h: cpu detection
 *****************************************************************************
 * Copyright (C) 2004-2019 x264 project
 *
 * Authors: Loren Merritt <lorenm@u.washington.edu>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02111, USA.
 *
 * This program is also available under a commercial proprietary license.
 * For more information, contact us at licensing@x264.com.
 *****************************************************************************/

#ifndef X264_CPU_H
#define X264_CPU_H
#include <stdint.h>

/* CPU flags */

/* x86 */
#define X264_CPU_MMX                (1<<0)
#define X264_CPU_MMX2               (1<<1)  /* MMX2 aka MMXEXT aka ISSE */
#define X264_CPU_MMXEXT             X264_CPU_MMX2
#define X264_CPU_SSE                (1<<2)
#define X264_CPU_SSE2               (1<<3)
#define X264_CPU_LZCNT              (1<<4)
#define X264_CPU_SSE3               (1<<5)
#define X264_CPU_SSSE3              (1<<6)
#define X264_CPU_SSE4               (1<<7)  /* SSE4.1 */
#define X264_CPU_SSE42              (1<<8)  /* SSE4.2 */
#define X264_CPU_AVX                (1<<9)  /* Requires OS support even if YMM registers aren't used */
#define X264_CPU_XOP                (1<<10) /* AMD XOP */
#define X264_CPU_FMA4               (1<<11) /* AMD FMA4 */
#define X264_CPU_FMA3               (1<<12)
#define X264_CPU_BMI1               (1<<13)
#define X264_CPU_BMI2               (1<<14)
#define X264_CPU_AVX2               (1<<15)
#define X264_CPU_AVX512             (1<<16) /* AVX-512 {F, CD, BW, DQ, VL}, requires OS support */
/* x86 modifiers */
#define X264_CPU_CACHELINE_32       (1<<17) /* avoid memory loads that span the border between two cachelines */
#define X264_CPU_CACHELINE_64       (1<<18) /* 32/64 is the size of a cacheline in bytes */
#define X264_CPU_SSE2_IS_SLOW       (1<<19) /* avoid most SSE2 functions on Athlon64 */
#define X264_CPU_SSE2_IS_FAST       (1<<20) /* a few functions are only faster on Core2 and Phenom */
#define X264_CPU_SLOW_SHUFFLE       (1<<21) /* The Conroe has a slow shuffle unit (relative to overall SSE performance) */
#define X264_CPU_STACK_MOD4         (1<<22) /* if stack is only mod4 and not mod16 */
#define X264_CPU_SLOW_ATOM          (1<<23) /* The Atom is terrible: slow SSE unaligned loads, slow
                                             * SIMD multiplies, slow SIMD variable shifts, slow pshufb,
                                             * cacheline split penalties -- gather everything here that
                                             * isn't shared by other CPUs to avoid making half a dozen
                                             * new SLOW flags. */
#define X264_CPU_SLOW_PSHUFB        (1<<24) /* such as on the Intel Atom */
#define X264_CPU_SLOW_PALIGNR       (1<<25) /* such as on the AMD Bobcat */

/* PowerPC */
#define X264_CPU_ALTIVEC         0x0000001

/* ARM and AArch64 */
#define X264_CPU_ARMV6           0x0000001
#define X264_CPU_NEON            0x0000002  /* ARM NEON */
#define X264_CPU_FAST_NEON_MRC   0x0000004  /* Transfer from NEON to ARM register is fast (Cortex-A9) */
#define X264_CPU_ARMV8           0x0000008

/* MIPS */
#define X264_CPU_MSA             0x0000001  /* MIPS MSA */

uint32_t x264_cpu_detect( void );
int      x264_cpu_num_processors( void );
void     x264_cpu_emms( void );
void     x264_cpu_sfence( void );
#if HAVE_MMX
/* There is no way to forbid the compiler from using float instructions
 * before the emms so miscompilation could theoretically occur in the
 * unlikely event that the compiler reorders emms and float instructions. */
#if HAVE_X86_INLINE_ASM
/* Clobbering memory makes the compiler less likely to reorder code. */
#define x264_emms() asm volatile( "emms":::"memory","st","st(1)","st(2)", \
                                  "st(3)","st(4)","st(5)","st(6)","st(7)" )
#else
#define x264_emms() x264_cpu_emms()
#endif
#else
#define x264_emms()
#endif
#define x264_sfence x264_cpu_sfence

/* kludge:
 * gcc can't give variables any greater alignment than the stack frame has.
 * We need 32 byte alignment for AVX2, so here we make sure that the stack is
 * aligned to 32 bytes.
 * gcc 4.2 introduced __attribute__((force_align_arg_pointer)) to fix this
 * problem, but I don't want to require such a new version.
 * aligning to 32 bytes only works if the compiler supports keeping that
 * alignment between functions (osdep.h handles manual alignment of arrays
 * if it doesn't).
 */
#if HAVE_MMX && (STACK_ALIGNMENT > 16 || (ARCH_X86 && STACK_ALIGNMENT > 4))
intptr_t x264_stack_align( void (*func)(), ... );
#define x264_stack_align(func,...) x264_stack_align((void (*)())func, __VA_ARGS__)
#else
#define x264_stack_align(func,...) func(__VA_ARGS__)
#endif

typedef struct
{
    const char *name;
    uint32_t flags;
} x264_cpu_name_t;
extern const x264_cpu_name_t x264_cpu_names[];

#endif
