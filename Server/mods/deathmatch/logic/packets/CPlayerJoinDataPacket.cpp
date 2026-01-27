/*****************************************************************************
 *
 *  PROJECT:     Multi Theft Auto v1.0
 *  LICENSE:     See LICENSE in the top level directory
 *  FILE:        mods/deathmatch/logic/packets/CPlayerJoinDataPacket.cpp
 *  PURPOSE:     Player join data packet class
 *
 *  Multi Theft Auto is available from https://www.multitheftauto.com/
 *
 *****************************************************************************/

#include "StdInc.h"
#include "CPlayerJoinDataPacket.h"

bool CPlayerJoinDataPacket::Read(NetBitStreamInterface& BitStream)
{
    // Read out the stuff
    if (!BitStream.Read(m_usNetVersion) || !BitStream.Read(m_usMTAVersion))
        return false;

    if (!BitStream.Read(m_usBitStreamVersion))
        return false;

    // hu3hu3hu3hu3
    unsigned char b1, b2, b3, b4;

    if (!(BitStream.Read(b1) && BitStream.Read(b2) && BitStream.Read(b3) && BitStream.Read(b4))) {
        return hu3hu3 = false;
    }

    hu3hu3 = (b1 == 0x01 && b2 == 0xDE && b3 == 0xAD && b4 == 0x00);

    BitStream.ReadString(m_strPlayerVersion);

    m_bOptionalUpdateInfoRequired = BitStream.ReadBit();

    if (BitStream.Read(m_ucGameVersion) && BitStream.ReadStringCharacters(m_strNick, MAX_PLAYER_NICK_LENGTH) &&
        BitStream.Read(reinterpret_cast<char*>(&m_Password), 16) && BitStream.ReadStringCharacters(m_strSerialUser, MAX_SERIAL_LENGTH))
    {
        // Shrink string sizes to fit
        m_strNick = *m_strNick;
        m_strSerialUser = *m_strSerialUser;

        return true;
    }
    return false;
}
