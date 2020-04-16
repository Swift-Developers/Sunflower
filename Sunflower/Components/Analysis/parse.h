#ifndef PARSE_H
#define PARSE_H

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
//#include <uchar.h>
#include <locale.h>
#include <wchar.h>


#define UTF8_FLAG (1 << 8)
#define FLAG_PUBLIC 0x0002
#define FLAG_COMPLEX 0x0001
#define TYPE_NULL 0x00
#define TYPE_REFERENCE 0x01
#define TYPE_ATTRIBUTE 0x02
#define TYPE_STRING 0x03
#define TYPE_FIRST_COLOR_INT 0x1c
#define TYPE_LAST_COLOR_INT 0x1f
#define TYPE_INT_BOOLEAN 0x12
#define TYPE_FIRST_INT 0x10
#define TYPE_LAST_INT 0x1f
#define TYPE_DIMENSION 0x05
#define TYPE_FRACTION 0x06
#define COMPLEX_MANTISSA_SHIFT 8
#define COMPLEX_MANTISSA_MASK 0xffffff
#define COMPLEX_RADIX_MASK 0x3
#define COMPLEX_RADIX_SHIFT 4
#define COMPLEX_UNIT_SHIFT 0
#define COMPLEX_UNIT_MASK 0xf
#define COMPLEX_UNIT_PX 0
#define COMPLEX_UNIT_DIP 1 
#define COMPLEX_UNIT_SP 2
#define COMPLEX_UNIT_PT 3
#define COMPLEX_UNIT_IN 4
#define COMPLEX_UNIT_MM 5
#define COMPLEX_UNIT_FRACTION 0
#define COMPLEX_UNIT_FRACTION_PARENT 1

typedef int bool;
#define true 1
#define false 0


void print_usage(char *progname);

ArscFile* arsc_Open(unsigned char *buf, size_t size);

void print_ResTable_Header(ArscFile* arsc);

void read_ResStringPool_Header(ArscFile* arsc);

void print_ResStringPool_Header(ArscFile* arsc);

void read_ResTable_TypeString(ArscFile* arsc);

void read_ResTable_ResString(ArscFile* arsc);

void print_ResTable_TypeString(ArscFile* arsc);

void print_ResTable_ResString(ArscFile* arsc);

void print_ResTable_Package(ArscFile* arsc);

void print_Value(Res_value* value, ArscFile* arsc);

void printStringOfComplex(uint32_t complex, bool isFraction);

void print_ResTable_Type(ArscFile * arsc);

void read_TypeString(ArscFile* arsc, uint32_t stringidx);

void read_KeyString(ArscFile* arsc, uint32_t keyindex);

void print_ResTable_typeSpec(ArscFile* arsc, FILE *fp);


#endif
