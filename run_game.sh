#!/bin/bash

# Ensamblar el bootloader
nasm gamebootloader.asm -f bin -o gamebootloader.com

# Verificar que no hay errores de ensamblaje
if [ $? -eq 0 ]; then
    echo "Ensamblaje exitoso, ejecutando con QEMU..."
    # Ejecutar el bootloader con QEMU
    qemu-system-i386 gamebootloader.com
else
    echo "Hubo un error durante el ensamblaje."
fi