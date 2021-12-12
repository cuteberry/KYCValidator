import React, { useEffect } from 'react';
import Text from './Text';
import Card from './Card';
import { colors } from '../theme';
import { useWeb3React } from '@web3-react/core';
import { useKYCValidator } from '../hooks/useKYCValidator';
import { useAppContext } from '../AppContext';

const BalanceCard = () => {
  const { account } = useWeb3React();
  const { 
    hasTargetValidated,
    targetAddress,
    oracle,
    jobId,
    tempData,
   } = useAppContext();

  // useEffect(() => {
  //   if (account && targetAddress) {
  //     hasKYC(targetAddress);
  //     setIsTargetValidated(isTargetValidated);
  //   }
  // }, [account]);

  return (
    <Card style={{ maxWidth: 500}}>
      <Text block color={colors.darkRed}>
        System
      </Text>
      <Text block color={colors.green}>
        KYC Validator Address on Kovan TestNet: <Text block color={colors.brown}>0x5d97A2DD17517379010b6f7FaC1aE7B5c963F91d</Text> 
      </Text>
      <Text block color={colors.green}>
        Oracle: <Text block color={colors.brown}>{oracle}</Text>
      </Text>
      <Text block color={colors.green}>
        JobId: <Text block color={colors.brown}>{jobId}</Text>
      </Text>
      <br/>
      <Text block color={colors.darkRed}>
        User
      </Text>
      <Text block color={colors.green}>
        Address: <Text block color={colors.brown}>{targetAddress}</Text> 
      </Text>
      <Text block color={colors.green}>
        KYC Validated: <Text block color={colors.brown}>{hasTargetValidated}</Text>
      </Text>
    </Card>
  );
};

export default BalanceCard;
