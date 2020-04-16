#include <stdio.h>
//#include <uchar.h>
#include <stdlib.h>
#include <stdint.h>


#define RES_TABLE_TYPE_TYPE 		0x0201
#define RES_TABLE_TYPE_SPEC_TYPE 	0x0202
#define NO_ENTRY 0xFFFFFFFF

typedef uint16_t char16_t;

/*每一数据块都包含此结构体*/
typedef struct {
	uint16_t 	type;//类型
	uint16_t 	headersize;//头部大小
	uint32_t 	size;//块大小
}Res_Header;

/*arsc文件结构头*/
typedef struct {
	Res_Header 			header;
	uint32_t 			packageCount;//包个数
}ResTable_Header;

/*全局字符串池*/
typedef struct {
	Res_Header 	header;
	uint32_t 	stringCount;
	uint32_t 	styleCount;
	//enum{
		//SORTED_FLAG = 1 << 0,
		//UTF8_FLAG = 1 << 8
	//};
	uint32_t 	flags;
	uint32_t 	stringStart;
	uint32_t 	styleStart;
}ResStringPool_Header;

/*package资源*/
typedef struct {
	Res_Header 	header;
	uint32_t 	id;
	char16_t 	name[128];
	uint32_t 	typeStrings;
	uint32_t 	lastPublicType;
	uint32_t 	keyStrings;
	uint32_t 	lastPublicKey;
}ResTable_Package;
/*类型资源字符串池*/
typedef struct {
	Res_Header 	header;
	uint32_t 	stringCount;
	uint32_t 	styleCount;
	uint32_t 	flags;
	uint32_t 	stringStart;
	uint32_t 	styleStart;
}ResTable_TypeString;
/*资源项字符串池*/
typedef struct {
	Res_Header 	header;
	uint32_t 	stringCount;
	uint32_t 	styleCount;
	uint32_t 	flags;
	uint32_t 	stringStart;
	uint32_t 	styleStart;
}ResTable_ResString;

/*类型规范数据块*/
typedef struct {
     Res_Header 	header;
     uint8_t 		id;
     uint8_t 		res0;
     uint16_t 		res1;
     uint32_t 		entryCount;
 }ResTable_typeSpec;

typedef struct {
	uint32_t size;
  
      union {
          struct {
              // Mobile country code (from SIM).  0 means "any".
              uint16_t mcc;
              // Mobile network code (from SIM).  0 means "any".
              uint16_t mnc;
          };
          uint32_t imsi;
      };
  
       union {
          struct {
              // \0\0 means "any".  Otherwise, en, fr, etc.
              char language[2];
  
              // \0\0 means "any".  Otherwise, US, CA, etc.
              char country[2];
          };
          uint32_t locale;
      };
 
      union {
          struct {
              uint8_t orientation;
              uint8_t touchscreen;
              uint16_t density;
          };
          uint32_t screenType;
      };
  
      union {
          struct {
              uint8_t keyboard;
              uint8_t navigation;
              uint8_t inputFlags;
              uint8_t inputPad0;
          };
          uint32_t input;
      };
 
      union {
          struct {
              uint16_t screenWidth;
              uint16_t screenHeight;
          };
          uint32_t screenSize;
      };
 
      union {
          struct {
              uint16_t sdkVersion;
              // For now minorVersion must always be 0!!!  Its meaning
              // is currently undefined.
              uint16_t minorVersion;
          };
          uint32_t version;
      };
 
      union {
          struct {
              uint8_t screenLayout;
              uint8_t uiMode;
              uint16_t smallestScreenWidthDp;
          };
          uint32_t screenConfig;
      };
 
     union {
         struct {
             uint16_t screenWidthDp;
             uint16_t screenHeightDp;
         };
         uint32_t screenSizeDp;
     };
}ResTable_Config;

typedef struct {
	Res_Header 			header;

	/*enum{
		NO_ENTRY = 0xFFFFFFFF
	};*/
		
	uint8_t 			id;
	uint8_t 			res0;
	uint16_t 			res1;
	uint32_t 			entryCount;
	uint32_t 			entriesStart;
	ResTable_Config 	config;
}ResTable_Type;


typedef struct {
    uint32_t index;
}ResStringPool_ref;

typedef struct {
    // Number of bytes in this structure.
    uint16_t size;

	/*enum{
		FALG_COMPLEX = 0x0001,
		FLAG_PUBLIC = 0x0002
		};*/
    //根据flags的不同,后面跟随的数据也不相同：bag资源和非bag资源
    //flags为1,则ResTable_entry是ResTable_map_entry
    //资源项标志位。如果是一个Bag资源项，那么FLAG_COMPLEX位就等于1，并且在ResTable_entry后面跟有一个ResTable_map数组，
    //否则的话，在ResTable_entry后面跟的是一个Res_value。如果是一个可以被引用的资源项，那么FLAG_PUBLIC位就等于1。/
    uint16_t flags;

    //对应的资源项名称 资源项名称字符串池中的偏移数组的索引
    ResStringPool_ref key;
}ResTable_Entry;

typedef struct {
    uint32_t ident;
}ResTable_ref;

/*struct ResTable_map_entry : public ResTable_Entry{
	ResTable_ref 	parent;
    // Number of name/value pairs that follow for FLAG_COMPLEX.
    uint32_t 		count;
};*/

typedef struct {
     //Res_value头部大小
     uint16_t size;
     //保留,始终为0
     uint8_t res0;
     //数据的类型,可以从上面的枚举类型中获取
     uint8_t dataType;
  
     //数据对应的索引
     uint32_t data;
 }Res_value;

typedef struct {
    // The resource identifier defining this mapping's name.  For attribute
    // resources, 'name' can be one of the following special resource types
    // to supply meta-data about the attribute; for all other resource types
    // it must be an attribute resource.
    ResTable_ref name;//4
    
    // This mapping's value.
    Res_value 	value;//8
}ResTable_map;

typedef struct {
	ResTable_ref 	parent;
	uint32_t 		count;//代表大小
}ResTable_map_entry;


typedef struct {
	unsigned char 	*data;
	size_t 			len;
	
	ResTable_Header 		*mheader;
	ResStringPool_Header 	*stringpool;
	ResTable_Package 		*package;
	ResTable_TypeString 	*typestring;
	ResTable_ResString 		*resstring;
	ResTable_typeSpec 		*typespec;
	ResTable_Type 			*type;
}ArscFile;

