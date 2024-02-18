format pe64 efi
entry main

section ".text" executable

struc M32 {
    align 4
    . dd ?
}
struc M64 {
    align 8
    . dq ?
}
struc MHDR {
    align 8
    . db 24 dup ?
}
struc EFI_SYSTEM_TABLE {
    align 8
    .Hdr MHDR
    .FirmwareVendor M64
    .FirmwareRevision M32
    .ConsoleInHandle M64
    .ConIn M64
    .ConsoleOutHandle M64
    .ConOut M64
    .StandardErrorHandle M64
    .StdErr M64
    .RuntimeServices M64
    .BootServices M64
    .NumberOfTableEntries M64
    .ConfigurationTable M64
}
struc EFI_SIMPLE_OUTPUT_PROTOCOL {
    .Reset M64
    .OutputString M64
    .TestString M64
    .QueryMode M64
    .SetMode M64
    .ClearScreen M64
    .SetCursorPosition M64
    .EnableCursor M64
    .Mode M64
}

virtual at 0
    EFI_SYSTEM_TABLE EFI_SYSTEM_TABLE
end virtual
virtual at 0
    EFI_SIMPLE_OUTPUT_PROTOCOL EFI_SIMPLE_OUTPUT_PROTOCOL
end virtual

main:
    mov [SystemTable], rdx
    
    mov rcx, [SystemTable]
    mov rcx, [rcx+EFI_SYSTEM_TABLE.ConOut]
    mov rdx, string
    mov rax, [rcx+EFI_SIMPLE_OUTPUT_PROTOCOL.OutputString]
    call rax
    ret

section ".data" writeable

SystemTable: dq ?
string: du "Hello World!", 0x000A, 0x000D, 0x0000
