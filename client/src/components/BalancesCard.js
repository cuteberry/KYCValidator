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
    <Card style={{ maxWidth: 300 }}>
      <Text block color={colors.green}>
        Target Address: {targetAddress} 
      </Text>
      <Text block color={colors.green}>
        Oracle: {oracle} 
      </Text>
      <Text block color={colors.green}>
        JobId: {jobId} 
      </Text>
      <Text block color={colors.green}>
        KYC Validated: {hasTargetValidated}
      </Text>
      <Text block color={colors.green}>
        API callback data: {tempData}
      </Text>
    </Card>
  );
};

export default BalanceCard;
