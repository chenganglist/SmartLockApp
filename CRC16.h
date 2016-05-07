//
//  CRC16.h
//  SmartLock
//
//  Created by csis on 16/5/4.
//  Copyright © 2016年 csis. All rights reserved.
//

#ifndef CRC16_h
#define CRC16_h

#include <stdio.h>

typedef union _CRC
{
    uint16_t crc16; //typedef unsigned short uint16_t;  占二个字节
    uint8_t  by[2]; //typedef unsigned char uint8_t;  占一个字节
}CRC_Cacu;

uint16_t CRC16(uint8_t *ba, int size);

/************************ (C) COPYRIGHT CSIS *****END OF FILE****/

#endif /* CRC16_h */
