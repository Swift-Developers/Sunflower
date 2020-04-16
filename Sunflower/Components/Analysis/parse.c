#include "resourcestype.h"
#include "parse.h"
#include <getopt.h>
#include <errno.h>
#include <string.h>

typedef uint16_t char16_t;

struct option opt[] = {
	{"help", no_argument, NULL, 'h'},
	{"filename", required_argument, NULL, 'n'},
	{"Header", no_argument, NULL, 'H'},
	{"global", no_argument, NULL, 'g'},
	{"package", no_argument, NULL, 'p'},
	{"typestring", no_argument, NULL, 't'},
	{"resstring", no_argument, NULL, 'r'},
	{"end", no_argument, NULL, 'e'},
	{0, 0, 0, 0}
	
};

/*打印帮助信息*/
void print_usage(char *progname)
{
	printf("The progname is %s\n", progname);
	printf("-h(--help): print help information.\n");
	printf("-n(--filename): specify file name.\n");
	printf("-H(--Header):print ResTable_Header.\n");
	printf("-g(--global):print global string chunk.\n");
	printf("-p(--package):print package header.\n");
	printf("-t(--typestring):print typestring chunk.\n");
	printf("-r(--resstring):print resstring chunk.\n");
	printf("-e(--end):print typespec chunk.\n");
}

void handle_cmd(int cmd, ArscFile* arsc, FILE* file)
{
	if (cmd == 1)
	{
		print_ResTable_Header(arsc);
		return;
	}
	else if (cmd == 2)
	{
		print_ResStringPool_Header(arsc);
		return;
	}
	else if (cmd == 3)
	{
		print_ResTable_Package(arsc);
		return;
	}
	else if (cmd == 4)
	{
		print_ResTable_TypeString(arsc);
		read_ResTable_TypeString(arsc);
		return;
	}
	else if (cmd == 5)
	{
		print_ResTable_ResString(arsc);
		read_ResTable_ResString(arsc);
		return;
	}
	else if (cmd == 6)
	{
		print_ResTable_typeSpec(arsc, file);
		return;
	}
}

/*判断文件大小*/
ArscFile* arsc_Open(unsigned char *buf, size_t size)
{
	ArscFile 	*arsc = NULL;
	
	if (NULL == buf || size == 0)
	{
		printf("ERR：buf or size is NULL!\n");
		return NULL;
	}

	arsc = (ArscFile*)malloc(sizeof(ArscFile));
	if (arsc == NULL)
	{
		printf("ERR:arsc malloc filure %s\n", strerror(errno));
		return NULL;
	}	
	
	arsc->data = buf;
	arsc->len = size;
	printf("arsc->len is %zu\n", arsc->len);
	
	arsc->mheader = (ResTable_Header*)arsc->data;
	uint32_t 		headersize = arsc->mheader->header.headersize;//头结构大小

	if (arsc->len != arsc->mheader->header.size)
	{
		printf("ERR: ArscFile is error!\n");
		free(arsc);
		return NULL;
	}

	arsc->stringpool = (ResStringPool_Header*)(arsc->data + headersize);
	uint32_t poolsize = arsc->stringpool->header.size;//全局字符串池大小

	arsc->package = (ResTable_Package*)(arsc->data + headersize + poolsize);
	uint32_t typestringOffset = arsc->package->typeStrings;//类型字符串资源池偏移地址
	uint32_t keystringsOffset = arsc->package->keyStrings;//资源项字符串偏移地址
	
	arsc->typestring = (ResTable_TypeString*)(arsc->data + headersize + poolsize + typestringOffset);
	arsc->resstring = (ResTable_ResString*)(arsc->data + headersize + poolsize + keystringsOffset);
	uint32_t resstringsize = arsc->resstring->header.size;//资源项块大小
	
	arsc->typespec = (ResTable_typeSpec*)(arsc->data + headersize + poolsize + keystringsOffset + resstringsize);
	uint32_t 	typespecsize = arsc->typespec->header.size;

	arsc->type = (ResTable_Type*)(arsc->data + headersize + poolsize + resstringsize + keystringsOffset + typespecsize);

	return arsc;
}

/*打印头部信息*/
void print_ResTable_Header(ArscFile* arsc)
{
	printf("ResTable_Header {\n");
	printf("\tType is 0x%02x,\n", arsc->mheader->header.type);
	printf("\tHeadersize is 0x%02x,\n", arsc->mheader->header.headersize);
	printf("\tSize is 0x%04x,\n", arsc->mheader->header.size);
	printf("\tpackageCount is 0x%04x\n", arsc->mheader->packageCount);
	printf("};\n");
}


/*读取字符串池*/
void read_ResStringPool_Header(ArscFile* arsc)
{
	uint32_t 		headersize = arsc->mheader->header.headersize;//头结构大小
	uint32_t 		poolheadersize = arsc->stringpool->header.headersize;//字符串块头大小
	uint32_t 		stringStart = arsc->stringpool->stringStart;//字符池偏移地址
	uint32_t 		*stringoffset = (uint32_t*)(arsc->data + headersize + poolheadersize);
	unsigned char 	*pstringstart = (unsigned char*)(arsc->data + headersize + stringStart);
	unsigned int	i = 0;

	for(i; i < arsc->stringpool->stringCount; i++)
	{
		char 	*string = pstringstart + *(stringoffset + i) + 2;
		if (arsc->stringpool->flags & UTF8_FLAG)
		{
            
			printf("string[%d]:%s\n", i, string);
		}
		else
		{
			printf("string[%d]:\n", i);
		}
	}
}
/*解析字符串池*/
void print_ResStringPool_Header(ArscFile* arsc)
{	
	printf("ResStringPool_Header {\n");
	printf("\tType is 0x%02x,\n", arsc->stringpool->header.type);
	printf("\tHeadersize is 0x%02x,\n", arsc->stringpool->header.headersize);
	printf("\tSize is 0x%04x,\n", arsc->stringpool->header.size);
	printf("\tStringCount is 0x%04x,\n", arsc->stringpool->stringCount);
	printf("\tStyleCount is 0x%04x,\n", arsc->stringpool->styleCount);
	printf("\tFlags is 0x%04x,\n", arsc->stringpool->flags);
	printf("\tStringStart is 0x%04x,\n", arsc->stringpool->stringStart);
	printf("\tStyleStart is 0x%04x,\n", arsc->stringpool->styleStart);
	printf("};\n");
	read_ResStringPool_Header(arsc);
}

/*读取类型字符串资源池*/
void read_ResTable_TypeString(ArscFile* arsc)
{
	uint32_t 		headersize = arsc->mheader->header.headersize;//头结构大小
	uint32_t 		poolsize = arsc->stringpool->header.size;
	uint32_t 		typestringOffset = arsc->package->typeStrings;//类型字符串资源池偏移地址
	uint32_t 		stringstart = arsc->typestring->stringStart;//偏移地址
	uint32_t 		typestringheadersize = arsc->typestring->header.headersize;
	uint32_t 		*typestringsoffset = (uint32_t*)(arsc->data + headersize + poolsize + typestringOffset + typestringheadersize);
	unsigned char 	*typestringstart = (unsigned char*)(arsc->data + headersize + poolsize + typestringOffset + stringstart);
	unsigned int 	i = 0;

	printf("typestringsoffset is 0x%x\n", typestringsoffset[1]);
	for(i; i < arsc->typestring->stringCount; i++)
	{
		char 	*typestring = typestringstart + *(typestringsoffset + i) + 2;
		printf("typestring[%d]:%s\n", i, typestring);
	}
}
/*读取资源项字符串池*/
void read_ResTable_ResString(ArscFile* arsc)
{
	uint32_t 		headersize = arsc->mheader->header.headersize;//头结构大小
	uint32_t 		poolsize = arsc->stringpool->header.size;
	uint32_t 		keystringsOffset = arsc->package->keyStrings;//资源项字符串偏移地址
	uint32_t 		keystringstart = arsc->resstring->stringStart;
	uint32_t 		resstringheadersize = arsc->resstring->header.headersize;
	uint32_t 		*keystringoffset = (uint32_t*)(arsc->data + headersize + poolsize + keystringsOffset + resstringheadersize);
	unsigned char 	*keystart = (unsigned char*)(arsc->data + headersize + poolsize + keystringsOffset + keystringstart);
	unsigned int 	i = 0;

	for(i; i< arsc->resstring->stringCount; i++)
	{
		char 	*keystring = keystart + *(keystringoffset + i) + 2;
		printf("keystring[%d]:%s\n", i, keystring);
	}
}
/*解析字符串类型资源池*/
void print_ResTable_TypeString(ArscFile* arsc)
{
	printf("ResTable_TypeString {\n");
	printf("\tType is 0x%02x,\n", arsc->typestring->header.type);
	printf("\tHeadersize is 0x%02x,\n", arsc->typestring->header.headersize);
	printf("\tSize is 0x%04x,\n", arsc->typestring->header.size);
	printf("\tStringCount is 0x%04x,\n", arsc->typestring->stringCount);
	printf("\tStyleCount is 0x%04x,\n", arsc->typestring->styleCount);
	printf("\tFlags is 0x%04x,\n", arsc->typestring->flags);
	printf("\tStringStart is 0x%04x,\n", arsc->typestring->stringStart);
	printf("\tStyleStart is 0x%04x,\n", arsc->typestring->styleStart);
	printf("};\n");
	
}
/*解析资源项字符串池*/
void print_ResTable_ResString(ArscFile* arsc)
{
	printf("ResTable_ResString {\n");
	printf("\tType is 0x%02x,\n", arsc->resstring->header.type);
	printf("\tHeadersize is 0x%02x,\n", arsc->resstring->header.headersize);
	printf("\tSize is 0x%04x,\n", arsc->resstring->header.size);
	printf("\tStringCount is 0x%04x,\n", arsc->resstring->stringCount);
	printf("\tStyleCount is 0x%04x,\n", arsc->resstring->styleCount);
	printf("\tFlags is 0x%04x,\n", arsc->resstring->flags);
	printf("\tStringStart is 0x%04x,\n", arsc->resstring->stringStart);
	printf("\tStyleStart is 0x%04x,\n", arsc->resstring->styleStart);
	printf("};\n");
}
/*package解析*/
void print_ResTable_Package(ArscFile* arsc)
{
	
	printf("ResTable_Package {\n");
	printf("\tType is 0x%02x,\n", arsc->package->header.type);
	printf("\tHeadersize is 0x%02x,\n", arsc->package->header.headersize);
	printf("\tSize is 0x%04x,\n", arsc->package->header.size);
	printf("\tID is 0x%04x,\n", arsc->package->id);
	printf("\tpackageName is %s\n", (char*)arsc->package->name);
	//print_wstr(arsc->package->name);
	printf("\ttypeStrings is 0x%04x,\n", arsc->package->typeStrings);
	printf("\tlastPublicType is 0x%04x,\n", arsc->package->lastPublicType);
	printf("\tkeyStrings is 0x%04x,\n", arsc->package->keyStrings);
	printf("\tlastPubilckey is 0x%04x\n", arsc->package->lastPublicKey);
	printf("};\n");
	//print_ResTable_TypeString(arsc);
	//read_ResTable_TypeString(arsc);
	//print_ResTable_ResString(arsc);
	//read_ResTable_ResString(arsc);
}


void print_ResTable_typeSpec(ArscFile* arsc, FILE *fp)
{
	uint32_t 		headersize = arsc->mheader->header.headersize;//头结构大小
	uint32_t 		poolsize = arsc->stringpool->header.size;//全局字符串池大小
	uint32_t 		packagesize = arsc->package->header.size;//package大小
	uint32_t 		keystringsOffset = arsc->package->keyStrings;//资源项字符串偏移地址
	uint32_t 		resstringsize = arsc->resstring->header.size;//资源项块大小
	uint32_t 		size = headersize + poolsize + keystringsOffset + resstringsize;
	uint16_t 		type;
	int m = 0, n = 0;
	
	ResTable_typeSpec 	typeSpecHeader;
	ResTable_Type 		typeHeader;

	fseek(fp, size ,SEEK_SET);

	//fread((void*)&type, sizeof(uint16_t), 1, fp);
	//fseek(fp, -sizeof(uint16_t), SEEK_CUR);
	//printf("type is 0x%04x\n", type);
	while (fread((void*)&type, sizeof(uint16_t), 1, fp) != 0)
	{	
		fseek(fp, -sizeof(uint16_t), SEEK_CUR);
		
		//printf("type[%d] is 0x%04x\n", j++, type);
		if (RES_TABLE_TYPE_SPEC_TYPE == type)
		{	
			printf("typespec[%d] is 0x%04x\n", m++, type);
			fread((void*)&typeSpecHeader, sizeof(ResTable_typeSpec), 1, fp);
			
			/*printf("ResTable_typeSpec {\n");
			printf("\tType is 0x%02x,\n", typeSpecHeader.header.type);
			printf("\tHeadersize is 0x%02x,\n", typeSpecHeader.header.headersize);
			printf("\tSize is 0x%04x,\n", typeSpecHeader.header.size);
			printf("\tid is 0x%04x,\n", typeSpecHeader.id);
			printf("\tres0 is 0x%04x,\n", typeSpecHeader.res0);
			printf("\tres1 is 0x%04x,\n", typeSpecHeader.res1);
			printf("\tentryCount is 0x%04x,\n", typeSpecHeader.entryCount);
			printf("};\n");*/
		
			read_TypeString(arsc, typeSpecHeader.id - 1);
			//printf("config is: ");
			//for(int i = 0 ; i < arsc->typespec->entryCount ; i++)
			//{
			uint32_t 		*config = (uint32_t*)malloc(typeSpecHeader.entryCount * 4);
			fread((void*)config, (typeSpecHeader.entryCount * sizeof(uint32_t)), 1, fp);
				//printf("0x%x ", config);
			//}
			printf("\n");
			free(config);
		}
		else if (RES_TABLE_TYPE_TYPE == type)
		{
			printf("type[%d] is 0x%04x\n", n++, type);
			//printf("sizeof(ResTable_Type) is %d\n", sizeof(ResTable_Type));
			fread((void*)&typeHeader, sizeof(ResTable_Type), 1, fp);
			//print_config(typeHeader.config);
			/*printf("ResTable_Type {\n");
			printf("\tType is 0x%02x,\n", typeHeader.header.type);
			printf("\tHeadersize is 0x%02x,\n", typeHeader.header.headersize);
			printf("\tSize is 0x%04x,\n", typeHeader.header.size);
			printf("\tid is 0x%04x,\n", typeHeader.id);
			printf("\tres0 is 0x%04x,\n", typeHeader.res0);
			printf("\tres1 is 0x%04x,\n", typeHeader.res1);
			printf("\tentryCount is 0x%04x,\n", typeHeader.entryCount);
			printf("\tentriesStart is 0x%04x,\n", typeHeader.entriesStart);
			printf("};\n");*/

			fseek(fp, typeHeader.header.headersize - sizeof(ResTable_Type), SEEK_CUR);//偏移20字节

			//printf("entrycount is 0x%x,\n", typeHeader.entryCount);
			uint32_t* 	pOffsets = (uint32_t*)malloc(typeHeader.entryCount * sizeof(uint32_t));
			if (NULL == pOffsets)
			{
				return;
			}
			fread((void*)pOffsets, sizeof(uint32_t), typeHeader.entryCount, fp);
			//printf("pOffsets is 0x%x,\n", pOffsets[1]);
			//printf("sizeof(ResTable_Type) is %ld\n", sizeof(ResTable_Type));
			unsigned char* 	pData = (unsigned char*)malloc(typeHeader.header.size - typeHeader.entriesStart);
			if (NULL == pData)
			{
				return;
			}
			//printf("typeheader size is %d\n", typeHeader.header.headersize);
			fread((void*)pData, (typeHeader.header.size - typeHeader.entriesStart), 1, fp);
			//printf("pData[1] is 0x%x\n", pData[1]);
			//printf("typeHeader.entryCount is %d\n", typeHeader.entryCount);
			for(int i = 0 ; i < typeHeader.entryCount ; i++) 
			{
				uint32_t 	offset = *(pOffsets + i);
				if(offset == NO_ENTRY) 
				{
						continue;
				}

				ResTable_Entry *pEntry = (ResTable_Entry*)(pData + offset);
				//printf("ResTable_Entry {\n");
				//printf("\tsize is 0x%04x,\n", pEntry->size);
				//printf("\tflags is 0x%04x,\n", pEntry->flags);
				//printf("key index is 0x%x\n", pEntry->key.index);

				printf("entryIndex: 0x%x, key :\n", i);
				read_KeyString(arsc, pEntry->key.index);

				//printf("pEntry->flags is 0x%x,\n", pEntry->flags);
				if(pEntry->flags & FLAG_COMPLEX)
				{
					ResTable_map_entry* pMapEntry = (ResTable_map_entry*)(pData + offset + sizeof(ResTable_Entry));
					//printf("pMapEntry[0] is 0x%x\n", pMapEntry->parent.ident);
					//printf("pMapEntry->count is 0x%x,\n", pMapEntry->count);
					for(int i = 0; i < pMapEntry->count ; i++)
					{
						ResTable_map* pMap = (ResTable_map*)(pData + offset + sizeof(ResTable_Entry) + sizeof(ResTable_map_entry));
						printf("\tname:0x%08x, valueType:%u, value:%u\n",
									pMap->name.ident, pMap->value.dataType, pMap->value.data);
					}	
				}
				else
				{
					Res_value* pValue = (Res_value*)((unsigned char*)pEntry + sizeof(ResTable_Entry));
					printf("value :\n");
					print_Value(pValue, arsc);
					printf("\n");
				}
			}
			free(pOffsets);
			free(pData);
		}
		else
		{
			break;
		}
	}
}

void read_TypeString(ArscFile* arsc, uint32_t stringidx)
{
	uint32_t 		headersize = arsc->mheader->header.headersize;//头结构大小
	uint32_t 		poolsize = arsc->stringpool->header.size;
	uint32_t 		typestringOffset = arsc->package->typeStrings;//类型字符串资源池偏移地址
	uint32_t 		stringstart = arsc->typestring->stringStart;//偏移地址
	uint32_t 		typestringheadersize = arsc->typestring->header.headersize;
	uint32_t 		*typestringsoffset = (uint32_t*)(arsc->data + headersize + poolsize + typestringOffset + typestringheadersize);
	unsigned char 	*typestringstart = (unsigned char*)(arsc->data + headersize + poolsize + typestringOffset + stringstart);

	char* str = typestringstart + *(typestringsoffset + stringidx) + 2;
	printf("id:0x%x, ", stringidx);
	printf("name:%s\n", str);
}
void read_KeyString(ArscFile* arsc, uint32_t keyindex)
{
	uint32_t 		headersize = arsc->mheader->header.headersize;//头结构大小
	uint32_t 		poolsize = arsc->stringpool->header.size;
	uint32_t 		keystringsOffset = arsc->package->keyStrings;//资源项字符串偏移地址
	uint32_t 		keystringstart = arsc->resstring->stringStart;
	uint32_t 		resstringheadersize = arsc->resstring->header.headersize;
	uint32_t 		*keystringoffset = (uint32_t*)(arsc->data + headersize + poolsize + keystringsOffset + resstringheadersize);
	unsigned char 	*keystart = (unsigned char*)(arsc->data + headersize + poolsize + keystringsOffset + keystringstart);

	char 	*str = keystart + *(keystringoffset + keyindex) + 2;
	printf("keystring:%s\n", str);
}


void read_ResStringPool(ArscFile* arsc, uint32_t data)
{
	uint32_t 		headersize = arsc->mheader->header.headersize;//头结构大小
	uint32_t 		poolheadersize = arsc->stringpool->header.headersize;//字符串块大小
	uint32_t 		stringStart = arsc->stringpool->stringStart;//字符池偏移地址
	uint32_t 		*stringoffset = (uint32_t*)(arsc->data + headersize + poolheadersize);
	unsigned char 	*pstringstart = (unsigned char*)(arsc->data + headersize + stringStart);
	unsigned int	i = 0;

	char 	*string = pstringstart + *(stringoffset + data) + 2;
	
	printf("%s\n", string);
}

void printStringOfComplex(uint32_t complex, bool isFraction) 
{
    const float MANTISSA_MULT =
        1.0f / (1<<COMPLEX_MANTISSA_SHIFT);
    const float RADIX_MULTS[] = {
        1.0f*MANTISSA_MULT, 1.0f/(1<<7)*MANTISSA_MULT,
        1.0f/(1<<15)*MANTISSA_MULT, 1.0f/(1<<23)*MANTISSA_MULT
    };

    float value = (complex&(COMPLEX_MANTISSA_MASK
                   <<COMPLEX_MANTISSA_SHIFT))
            * RADIX_MULTS[(complex>>COMPLEX_RADIX_SHIFT)
                            & COMPLEX_RADIX_MASK];
	printf("%f",value);

    if (!isFraction) {
        switch ((complex>>COMPLEX_UNIT_SHIFT)&COMPLEX_UNIT_MASK) 
		{
            case COMPLEX_UNIT_PX: 
				printf("px\n"); 
				break;
            case COMPLEX_UNIT_DIP: 
				printf("dp\n"); 
				break;
            case COMPLEX_UNIT_SP: 
				printf("sp\n"); 
				break;
            case COMPLEX_UNIT_PT: 
				printf("pt\n"); 
				break;
            case COMPLEX_UNIT_IN: 
				printf("in\n"); 
				break;
            case COMPLEX_UNIT_MM: 
				printf("mm\n"); 
				break;
            default: 
				printf("(unknown unit)\n"); 
				break;
        }
    } 
	else 
    {
        switch ((complex>>COMPLEX_UNIT_SHIFT)&COMPLEX_UNIT_MASK) 
		{
            case COMPLEX_UNIT_FRACTION: 
				printf("%%\n"); 
				break;
            case COMPLEX_UNIT_FRACTION_PARENT: 
				printf("%%p\n"); 
				break;
            default: 
				printf("(unknown unit)\n"); 
				break;
        }
    }
}

void print_Value(Res_value* value, ArscFile* arsc)
{
	if (TYPE_NULL == value->dataType) 
	{
        printf("(null)\n");
    }
	else if (value->dataType == TYPE_REFERENCE) 
	{
		printf("(reference) 0x%08x\n",value->data);
	}
	else if (value->dataType == TYPE_ATTRIBUTE) 
	{
		printf("(attribute) 0x%08x\n",value->data);
    }
	else if (value->dataType == TYPE_STRING) 
	{
		printf("(string) ");
		read_ResStringPool(arsc, value->data);
	}
	else if (value->dataType >= TYPE_FIRST_COLOR_INT
            && value->dataType <= TYPE_LAST_COLOR_INT) 
    {
		printf("(color) #%08x\n", value->data);
    } 
	else if (value->dataType == TYPE_INT_BOOLEAN) 
	{
        printf("(boolean) %s\n",value->data ? "true" : "false");
    } 
	else if (value->dataType >= TYPE_FIRST_INT
            && value->dataType <= TYPE_LAST_INT) 
    {
        printf("(int) %d or %u\n", value->data, value->data);
    } 
	else if (value->dataType == TYPE_DIMENSION) 
	{
        printf("(dimension) ");
		printStringOfComplex(value->data, false);
    } 
	else if (value->dataType == TYPE_FRACTION) 
	{
        printf("(fraction) ");
		printStringOfComplex(value->data, true);
    }
	else 
	{
		printf("(unknown type)\n");
    }
}

