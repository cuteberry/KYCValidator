import { useContract } from './useContract';
// import C_TOKEN_ABI from '../static/cEthABI';
import KYC_VALIDATOR_ABI from '../contracts/KYCValidatorWithAPICall.json';
import useIsValidNetwork from './useIsValidNetwork';
import { useWeb3React } from '@web3-react/core';
import { useAppContext } from '../AppContext';
import { formatUnits, parseEther } from '@ethersproject/units';
import { useEffect } from 'react';

export const useKYCValidator = () => {
  const { account } = useWeb3React();
  const { isValidNetwork } = useIsValidNetwork();
  const validator = account;
  const kycValidatorContractAddress = '0x9afBB0de076895917C21318307AD8B1084d77914'; // ropsten
  const kycValidatorContract = useContract(kycValidatorContractAddress, KYC_VALIDATOR_ABI.abi);
  const { setTargetAddress, setHasTargetValidated, targetAddress, isTargetValidated, setTxnStatus, setTempData, tempData } = useAppContext();

  const retrieveKYC = async (targetAddress) => {
    if (account && isValidNetwork) {
      try {
        setTxnStatus('LOADING');
        setHasTargetValidated("retrieving");
        const txn = await kycValidatorContract.retrieveKYC(targetAddress, {
          from: validator
        });
        console.log(txn);
        // await txn.wait(1);
        // const hasKYCData = await kycValidatorContract.hasKYC(targetAddress, {
        //   from: validator,
        // });
        // console.log(hasKYCData);
        // setHasTargetValidated(hasKYCData);
        setTxnStatus('COMPLETE');
      } catch (error) {
        console.log(error);
        setTxnStatus('ERROR');
      }
    }
  };

  const hasKYC = async (targetAddress) => {
    if (account && isValidNetwork) {
      try {
        setTxnStatus('LOADING');
        setHasTargetValidated("retrieving");
        const hasKYCData = await kycValidatorContract.hasKYC(targetAddress, {
          from: validator,
        });
        setHasTargetValidated(hasKYCData);
        setTxnStatus('COMPLETE');
      } catch (error) {
        console.log(error);
        setTxnStatus('ERROR');
      }
    }
  };


  const getTemp = async () => {
    if (account && isValidNetwork) {
      try {
        setTxnStatus('LOADING');
        setTempData("retrieving");
        const tempData = await kycValidatorContract.getTemp({
          from: validator,
        });
        setTempData(tempData);
        setTxnStatus('COMPLETE');
      } catch (error) {
        console.log(error);
        setTxnStatus('ERROR');
      }
    }
  };

  return {
    retrieveKYC,
    hasKYC,
    getTemp,
    targetAddress,
    tempData,
    setTargetAddress,
    isTargetValidated
  };
};