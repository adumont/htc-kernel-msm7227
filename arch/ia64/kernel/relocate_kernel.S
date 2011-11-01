/*
 * arch/ia64/kernel/relocate_kernel.S
 *
 * Relocate kexec'able kernel and start it
 *
 * Copyright (C) 2005 Hewlett-Packard Development Company, L.P.
 * Copyright (C) 2005 Khalid Aziz  <khalid.aziz@hp.com>
 * Copyright (C) 2005 Intel Corp,  Zou Nan hai <nanhai.zou@intel.com>
 *
 * This source code is licensed under the GNU General Public License,
 * Version 2.  See the file COPYING for more details.
 */
#include <asm/asmmacro.h>
#include <asm/kregs.h>
#include <asm/page.h>
#include <asm/pgtable.h>
#include <asm/mca_asm.h>

       /* Must be relocatable PIC code callable as a C function
        */
GLOBAL_ENTRY(relocate_new_kernel)
	.prologue
	alloc r31=ar.pfs,4,0,0,0
        .body
.reloc_entry:
{
	rsm psr.i| psr.ic
	mov r2=ip
}
	;;
{
        flushrs                         // must be first insn in group
        srlz.i
}
	;;
	dep r2=0,r2,61,3		//to physical address
	;;
	//first switch to physical mode
	add r3=1f-.reloc_entry, r2
	movl r16 = IA64_PSR_AC|IA64_PSR_BN|IA64_PSR_IC
	mov ar.rsc=0	          	// put