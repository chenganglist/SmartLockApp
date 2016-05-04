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


//====输入不带CRC码的数据时，返回值是CRC码=====
//*输入带CRC码的数据时，则可以进行校验，返回0时CRC校验成功，否则CRC校验失败
uint16_t CRC16(uint8_t *ba, int size)
{
    CRC_Cacu crc;
    crc.crc16 = 0xffff;
    int i, l;
    for (i=0; i<size; i++)
    {
        uint8_t ch = ba[i];
        crc.by[0] = crc.by[0] ^ ch;
        for (l=0; l<8; l++)
        {
            if (crc.by[0] & 0x01)
            {
                crc.crc16 = crc.crc16 >> 1;
                crc.crc16 = crc.crc16 ^ 0xa001;
            }
            else
            {
                crc.crc16 = crc.crc16 >> 1;
            }
        }
    }
    uint8_t swap = crc.by[0];
    crc.by[0] = crc.by[1];
    crc.by[1] = swap;
    return crc.crc16;
}

/************************ (C) COPYRIGHT CSIS *****END OF FILE****/

#endif /* CRC16_h */
